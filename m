Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2GJTeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:34:10 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:32963 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2GJTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:34:08 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 11 Jul 2012 01:01:39 +0530
Message-Id: <20120710193138.16440.31791.sendpatchset@codeblue>
In-Reply-To: <20120710193056.16440.40112.sendpatchset@codeblue>
References: <20120710193056.16440.40112.sendpatchset@codeblue>
Subject: [PATCH RFC V2 2/2] kvm PLE handler: Choose better candidate for directed yield
x-cbid: 12071010-3568-0000-0000-0000021D4A63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Currently PLE handler can repeatedly do a directed yield to same vcpu
that has recently done PL exit. This can degrade the performance.

Try to yield to most eligible guy instead by alternate yielding.
Precisely, give chance to a VCPU which has:
 (a) Not done PLE exit at all (probably he is preempted lock-holder)
 (b) VCPU skipped in last iteration because it did PL exit, and probably
 has become eligible now (next eligible lock holder)

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---

 arch/s390/include/asm/kvm_host.h |    5 +++++
 arch/x86/include/asm/kvm_host.h  |    2 +-
 arch/x86/kvm/x86.c               |   30 ++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c              |    3 +++
 4 files changed, 39 insertions(+), 1 deletions(-)


diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index dd17537..884f2c4 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -256,5 +256,10 @@ struct kvm_arch{
 	struct gmap *gmap;
 };
 
+static inline bool kvm_arch_vcpu_check_and_update_eligible(struct kvm_vcpu *v)
+{
+	return true;
+}
+
 extern int sie64a(struct kvm_s390_sie_block *, u64 *);
 #endif
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 386f3e6..77c1358 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -966,7 +966,7 @@ extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 void kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
 
 int kvm_is_in_guest(void);
-
+bool kvm_arch_vcpu_check_and_update_eligible(struct kvm_vcpu *vcpu);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 void kvm_pmu_reset(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b30c310..bf92ffc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6623,6 +6623,36 @@ bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
 			kvm_x86_ops->interrupt_allowed(vcpu);
 }
 
+/*
+ * Helper that checks whether a VCPU is eligible for directed yield.
+ * Most eligible candidate to yield is decided by following heuristics:
+ *
+ *  (a) VCPU which has not done PL exit recently (preempted lock holder),
+ *      indicated by @pause_loop_exited. Cleared just before guest_enter()
+ *
+ *  (b) VCPU which has done PL exit but did not get chance last time.
+ *      (mostly it has become eligible now since we have probably
+ *      yielded to lockholder in last iteration. This is done by toggling
+ *      @dy_eligible each time a VCPU checked for eligibility.)
+ *
+ *   Yielding to a recently PL exited VCPU before yielding to preempted
+ *   lock-holder results in uneligible VCPU burning CPU. Giving priority
+ *   for a potential lock-holder increases lock progress chance.
+ */
+bool kvm_arch_vcpu_check_and_update_eligible(struct kvm_vcpu *vcpu)
+{
+	bool eligible;
+
+	eligible = !vcpu->arch.ple.pause_loop_exited ||
+			(vcpu->arch.ple.pause_loop_exited &&
+			 vcpu->arch.ple.dy_eligible);
+
+	if (vcpu->arch.ple.pause_loop_exited)
+		vcpu->arch.ple.dy_eligible = !vcpu->arch.ple.dy_eligible;
+
+	return eligible;
+}
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7e14068..519321a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1595,6 +1595,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				continue;
 			if (waitqueue_active(&vcpu->wq))
 				continue;
+			if (!kvm_arch_vcpu_check_and_update_eligible(vcpu)) {
+				continue;
+			}
 			if (kvm_vcpu_yield_to(vcpu)) {
 				kvm->last_boosted_vcpu = i;
 				yielded = 1;

