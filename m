Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab0L2Fin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 00:38:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab0L2Fil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 00:38:41 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [KVM Clock Synchronization 4/4] Add master clock for KVM clock
Date: Tue, 28 Dec 2010 19:38:20 -1000
Message-Id: <1293601100-32109-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1293601100-32109-1-git-send-email-zamsden@redhat.com>
References: <1293601100-32109-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with synchronized TSCs, we still have VCPU individual
KVM clocks, each with their own computed offset.  As this all happens
at different times, the computed KVM clock offset can vary, causing a
globally visible backwards clock.  Currently this is protected against
by using an atomic compare to ensure it does not happen.

This change should remove that requirement.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   42 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8d829b8..ff651b7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -445,6 +445,7 @@ struct kvm_arch {
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
 	spinlock_t clock_lock;
+	struct pvclock_vcpu_time_info master_clock;
 	u64 last_tsc_nsec;
 	u64 last_tsc_offset;
 	u64 last_tsc_write;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59d5999..a339e50 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1116,6 +1116,38 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		return 0;
 
 	/*
+	 * If there is a stable TSC, we use a master reference clock for
+	 * the KVM clock; otherwise, individual computations for each VCPU
+	 * would exhibit slight drift relative to each other, which could
+	 * cause global time to go backwards.
+	 *
+	 * If the master clock has no TSC timestamp, that means we must
+	 * recompute the clock as either some real time has elapsed during
+	 * a suspend cycle, or we are measuring the clock for the first time
+	 * during VM creation (or following a migration).  Since master clock
+	 * changes should happen only at rare occasions, so we can ignore
+	 * the precautions below.
+	 */
+	if (!check_tsc_unstable()) {
+		struct pvclock_vcpu_time_info *master =
+						&v->kvm->arch.master_clock;
+		if (vcpu->hv_clock.version != master->version) {
+			spin_lock(&v->kvm->arch.clock_lock);
+			WARN_ON(master->version < vcpu->hv_clock.version);
+			if (!master->tsc_timestamp) {
+				pr_debug("KVM: computing new master clock\n");
+				update_pvclock(v, master, tsc_timestamp,
+						kernel_ns, tsc_khz);
+			}
+			memcpy(&vcpu->hv_clock, master, sizeof(*master));
+			spin_unlock(&v->kvm->arch.clock_lock);
+			update_user_kvmclock(v, &vcpu->hv_clock);
+		} else
+			pr_debug("ignoring spurious KVM clock update");
+		return 0;
+	}
+
+	/*
 	 * Time as measured by the TSC may go backwards when resetting the base
 	 * tsc_timestamp.  The reason for this is that the TSC resolution is
 	 * higher than the resolution of the other clock scales.  Thus, many
@@ -3482,7 +3514,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		now_ns = get_kernel_ns();
 		delta = user_ns.clock - now_ns;
+		spin_lock(&kvm->arch.clock_lock);
+		kvm->arch.master_clock.version += 2;
+		kvm->arch.master_clock.tsc_timestamp = 0;
 		kvm->arch.kvmclock_offset = delta;
+		spin_unlock(&kvm->arch.clock_lock);
 		break;
 	}
 	case KVM_GET_CLOCK: {
@@ -5845,11 +5881,14 @@ int kvm_arch_hardware_enable(void *garbage)
 	 */
 	if (backwards_tsc) {
 		u64 delta_cyc = max_tsc - local_tsc;
-		list_for_each_entry(kvm, &vm_list, vm_list)
+		list_for_each_entry(kvm, &vm_list, vm_list) {
 			kvm_for_each_vcpu(i, vcpu, kvm) {
 				vcpu->arch.tsc_offset_adjustment += delta_cyc;
 				vcpu->arch.last_host_tsc = 0;
 			}
+			kvm->arch.master_clock.tsc_timestamp = 0;
+			kvm->arch.master_clock.version += 2;
+		}
 	}
 
 	return 0;
@@ -5965,6 +6004,7 @@ struct  kvm *kvm_arch_create_vm(void)
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
 	spin_lock_init(&kvm->arch.clock_lock);
+	kvm->arch.master_clock.version = 1000;
 
 	return kvm;
 }
-- 
1.7.1

