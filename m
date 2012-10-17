Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2JQCY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:24:57 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37930 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab2JQCYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:24:53 -0400
Subject: [PATCH RFC V2 4/5] Add a timer to allow the separation of consigned
 from steal time.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com,
        anthony@codemonkey.ws
Date: Tue, 16 Oct 2012 21:24:38 -0500
Message-ID: <20121017022437.16949.47212.stgit@lambeau>
In-Reply-To: <20121017022249.16949.2775.stgit@lambeau>
References: <20121017022249.16949.2775.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101702-7014-0000-0000-00000209C528
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a timer to the host.  This will define the period.  During a period
the first n ticks will go into the consigned bucket.  Any other ticks that
occur within the period will be placed in the stealtime bucket.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |   10 +++++++++
 arch/x86/include/asm/paravirt.h |    2 +-
 arch/x86/kvm/x86.c              |   42 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bd4e412..d700850 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -41,6 +41,8 @@
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
 
+#define KVM_STEAL_TIMER_DELAY 100000000UL
+
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
 			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
@@ -339,6 +341,14 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 
 	/*
+	 * timer used to determine if the time should be counted as
+	 * steal time or consigned time.
+	 */
+	struct hrtimer steal_timer;
+	u64 current_consigned;
+	u64 consigned_limit;
+
+	/*
 	 * Paging state of the vcpu
 	 *
 	 * If the vcpu runs in guest mode with two level paging this still saves
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index d39e8d0..6db79f9 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -196,7 +196,7 @@ struct static_key;
 extern struct static_key paravirt_steal_enabled;
 extern struct static_key paravirt_steal_rq_enabled;
 
-static inline u64 paravirt_steal_clock(int cpu, u64 *steal, u64 *consigned)
+static inline void paravirt_steal_clock(int cpu, u64 *steal, u64 *consigned)
 {
 	PVOP_VCALL3(pv_time_ops.steal_clock, cpu, steal, consigned);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 801cfa8..469e748 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1535,13 +1535,32 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 static void accumulate_steal_time(struct kvm_vcpu *vcpu)
 {
 	u64 delta;
+	u64 steal_delta;
+	u64 consigned_delta;
 
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
 	delta = current->sched_info.run_delay - vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
-	vcpu->arch.st.accum_steal = delta;
+
+	/* split the delta into steal and consigned */
+	if (vcpu->arch.current_consigned < vcpu->arch.consigned_limit) {
+		vcpu->arch.current_consigned += delta;
+		if (vcpu->arch.current_consigned > vcpu->arch.consigned_limit) {
+			steal_delta = vcpu->arch.current_consigned
+						-  vcpu->arch.consigned_limit;
+			consigned_delta = delta - steal_delta;
+		} else {
+			consigned_delta = delta;
+			steal_delta = 0;
+		}
+	} else {
+		consigned_delta = 0;
+		steal_delta = delta;
+	}
+	vcpu->arch.st.accum_steal = steal_delta;
+	vcpu->arch.st.accum_consigned = consigned_delta;
 }
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
@@ -6187,11 +6206,25 @@ bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu)
 	return irqchip_in_kernel(vcpu->kvm) == (vcpu->arch.apic != NULL);
 }
 
+enum hrtimer_restart steal_timer_fn(struct hrtimer *data)
+{
+	struct kvm_vcpu *vcpu;
+	ktime_t now;
+
+	vcpu = container_of(data, struct kvm_vcpu, arch.steal_timer);
+	vcpu->arch.current_consigned = 0;
+	now = ktime_get();
+	hrtimer_forward(&vcpu->arch.steal_timer, now,
+			ktime_set(0, KVM_STEAL_TIMER_DELAY));
+	return HRTIMER_RESTART;
+}
+
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
 	struct kvm *kvm;
 	int r;
+	ktime_t ktime;
 
 	BUG_ON(vcpu->kvm == NULL);
 	kvm = vcpu->kvm;
@@ -6234,6 +6267,12 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_async_pf_hash_reset(vcpu);
 	kvm_pmu_init(vcpu);
+	/* Initialize and start a timer to capture steal and consigned time */
+	hrtimer_init(&vcpu->arch.steal_timer, CLOCK_MONOTONIC,
+			HRTIMER_MODE_REL);
+	vcpu->arch.steal_timer.function = &steal_timer_fn;
+	ktime = ktime_set(0, KVM_STEAL_TIMER_DELAY);
+	hrtimer_start(&vcpu->arch.steal_timer, ktime, HRTIMER_MODE_REL);
 
 	return 0;
 fail_free_mce_banks:
@@ -6252,6 +6291,7 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
+	hrtimer_cancel(&vcpu->arch.steal_timer);
 	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
 	kvm_free_lapic(vcpu);

