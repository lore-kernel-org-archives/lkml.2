Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1FUAAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:00:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230Ab1FUAAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:00:11 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Zachary Amsden <zamsden@gmail.com>
Subject: [KVM TSC emulation 7/9] Don't mark TSC unstable due to S4 suspend
Date: Mon, 20 Jun 2011 16:59:35 -0700
Message-Id: <1308614377-18627-8-git-send-email-zamsden@redhat.com>
In-Reply-To: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
References: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a host suspend, TSC may go backwards, which KVM interprets
as an unstable TSC.  Technically, KVM should not be marking the
TSC unstable, which causes the TSC clocksource to go bad, but we
need to be adjusting the TSC offsets in such a case.

Dealing with this issue is a little tricky as the only place we
can reliably do it is before much of the timekeeping infrastructure
is up and running.  On top of this, we are not in a KVM thread
context, so we may not be able to safely access VCPU fields.
Instead, we compute our best known hardware offset at power-up and
stash it to be applied to all VCPUs when they actually start running.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   93 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c2854da..226897f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -394,6 +394,7 @@ struct kvm_vcpu_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
 	u64 last_host_tsc;
+	u64 tsc_offset_adjustment;
 	bool tsc_catchup;
 	bool tsc_always_catchup;
 	s8 virtual_tsc_shift;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 10950f7..cb8876b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2152,6 +2152,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
+
+	/* Apply any externally detected TSC adjustments (due to suspend) */
+	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
+		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
+		vcpu->arch.tsc_offset_adjustment = 0;
+		set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
+	}
+
 	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
 		/* Make sure TSC doesn't go backwards */
 		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
@@ -6221,13 +6229,88 @@ int kvm_arch_hardware_enable(void *garbage)
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	int i;
+	int ret;
+	u64 local_tsc;
+	u64 max_tsc = 0;
+	bool stable, backwards_tsc = false;
 
 	kvm_shared_msr_cpu_online();
-	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_for_each_vcpu(i, vcpu, kvm)
-			if (vcpu->cpu == smp_processor_id())
-				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-	return kvm_x86_ops->hardware_enable(garbage);
+ 	ret = kvm_x86_ops->hardware_enable(garbage);
+	if (ret != 0)
+		return ret;
+
+	local_tsc = native_read_tsc();
+	stable = !check_tsc_unstable();
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (!stable && vcpu->cpu == smp_processor_id())
+				set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
+			if (stable && vcpu->arch.last_host_tsc > local_tsc) {
+				backwards_tsc = true;
+				if (vcpu->arch.last_host_tsc > max_tsc)
+					max_tsc = vcpu->arch.last_host_tsc;
+			}
+		}
+	}
+
+	/*
+	 * Sometimes, even reliable TSCs go backwards.  This happens on
+	 * platforms that reset TSC during suspend or hibernate actions, but
+	 * maintain synchronization.  We must compensate.  Fortunately, we can
+	 * detect that condition here, which happens early in CPU bringup,
+	 * before any KVM threads can be running.  Unfortunately, we can't
+	 * bring the TSCs fully up to date with real time, as we aren't yet far
+	 * enough into CPU bringup that we know how much real time has actually
+	 * elapsed; our helper function, get_kernel_ns() will be using boot
+	 * variables that haven't been updated yet.
+	 *
+	 * So we simply find the maximum observed TSC above, then record the
+	 * adjustment to TSC in each VCPU.  When the VCPU later gets loaded,
+	 * the adjustment will be applied.  Note that we accumulate
+	 * adjustments, in case multiple suspend cycles happen before some VCPU
+	 * gets a chance to run again.  In the event that no KVM threads get a
+	 * chance to run, we will miss the entire elapsed period, as we'll have
+	 * reset last_host_tsc, so VCPUs will not have the TSC adjusted and may
+	 * loose cycle time.  This isn't too big a deal, since the loss will be
+	 * uniform across all VCPUs (not to mention the scenario is extremely
+	 * unlikely). It is possible that a second hibernate recovery happens
+	 * much faster than a first, causing the observed TSC here to be
+	 * smaller; this would require additional padding adjustment, which is
+	 * why we set last_host_tsc to the local tsc observed here.
+	 *
+	 * N.B. - this code below runs only on platforms with reliable TSC,
+	 * as that is the only way backwards_tsc is set above.  Also note
+	 * that this runs for ALL vcpus, which is not a bug; all VCPUs should
+	 * have the same delta_cyc adjustment applied if backwards_tsc
+	 * is detected.  Note further, this adjustment is only done once,
+	 * as we reset last_host_tsc on all VCPUs to stop this from being
+	 * called multiple times (one for each physical CPU bringup).
+	 *
+	 * Platforms with unnreliable TSCs don't have to deal with this, they
+	 * will be compensated by the logic in vcpu_load, which sets the TSC to
+	 * catchup mode.  This will catchup all VCPUs to real time, but cannot
+	 * guarantee that they stay in perfect synchronization.
+	 */
+	if (backwards_tsc) {
+		u64 delta_cyc = max_tsc - local_tsc;
+		list_for_each_entry(kvm, &vm_list, vm_list) {
+			kvm_for_each_vcpu(i, vcpu, kvm) {
+				vcpu->arch.tsc_offset_adjustment += delta_cyc;
+				vcpu->arch.last_host_tsc = local_tsc;
+			}
+
+			/*
+			 * We have to disable TSC offset matching.. if you were
+			 * booting a VM while issuing an S4 host suspend....
+			 * you may have some problem.  Solving this issue is
+			 * left as an exercise to the reader.
+			 */
+			kvm->arch.last_tsc_nsec = 0;
+			kvm->arch.last_tsc_write = 0;
+		}
+
+	}
+	return 0;
 }
 
 void kvm_arch_hardware_disable(void *garbage)
-- 
1.7.1

