Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2GSJRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:17:53 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40287 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2GSJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:17:50 -0400
Date: Thu, 19 Jul 2012 14:45:31 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc: S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [RESEND PATCH RFC V3 0/3] kvm: Improving directed yield in PLE
 handler
Message-ID: <20120719091531.GA29888@linux.vnet.ibm.com>
Reply-To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
References: <20120712191712.30440.68944.sendpatchset@codeblue>
 <4FFF2440.40807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4FFF2440.40807@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071909-4242-0000-0000-0000025FF645
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Currently, on a large vcpu guests, there is a high probability of
yielding to the same vcpu who had recently done a pause-loop exit or
cpu relax intercepted. Such a yield can lead to the vcpu spinning
again and hence degrade the performance.

The patchset keeps track of the pause loop exit/cpu relax interception
and gives chance to a vcpu which:
 (a) Has not done pause loop exit or cpu relax intercepted at all
     (probably he is preempted lock-holder)
 (b) Was skipped in last iteration because it did pause loop exit or
     cpu relax intercepted, and probably has become eligible now
     (next eligible lock holder)

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
V2 was:
Reviewed-by: Rik van Riel <riel@redhat.com>

Changelog: Added comment on locking as suggested by Avi

 include/linux/kvm_host.h |    5 +++++
 virt/kvm/kvm_main.c      |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 34ce296..952427d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -923,6 +923,11 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 {
 }
 
+static inline bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
+{
+	return true;
+}
+
 #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
 #endif
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3d6ffc8..8fda756 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1571,6 +1571,43 @@ bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
 
+#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
+/*
+ * Helper that checks whether a VCPU is eligible for directed yield.
+ * Most eligible candidate to yield is decided by following heuristics:
+ *
+ *  (a) VCPU which has not done pl-exit or cpu relax intercepted recently
+ *  (preempted lock holder), indicated by @in_spin_loop.
+ *  Set at the beiginning and cleared at the end of interception/PLE handler.
+ *
+ *  (b) VCPU which has done pl-exit/ cpu relax intercepted but did not get
+ *  chance last time (mostly it has become eligible now since we have probably
+ *  yielded to lockholder in last iteration. This is done by toggling
+ *  @dy_eligible each time a VCPU checked for eligibility.)
+ *
+ *  Yielding to a recently pl-exited/cpu relax intercepted VCPU before yielding
+ *  to preempted lock-holder could result in wrong VCPU selection and CPU
+ *  burning. Giving priority for a potential lock-holder increases lock
+ *  progress.
+ *
+ *  Since algorithm is based on heuristics, accessing another VCPU data without
+ *  locking does not harm. It may result in trying to yield to same VCPU, fail
+ *  and continue with next VCPU and so on.
+ */
+bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
+{
+	bool eligible;
+
+	eligible = !vcpu->spin_loop.in_spin_loop ||
+			(vcpu->spin_loop.in_spin_loop &&
+			 vcpu->spin_loop.dy_eligible);
+
+	if (vcpu->spin_loop.in_spin_loop)
+		kvm_vcpu_set_dy_eligible(vcpu, !vcpu->spin_loop.dy_eligible);
+
+	return eligible;
+}
+#endif
 void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	struct kvm *kvm = me->kvm;
@@ -1599,6 +1636,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				continue;
 			if (waitqueue_active(&vcpu->wq))
 				continue;
+			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
+				continue;
 			if (kvm_vcpu_yield_to(vcpu)) {
 				kvm->last_boosted_vcpu = i;
 				yielded = 1;
@@ -1607,6 +1646,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 		}
 	}
 	kvm_vcpu_set_in_spin_loop(me, false);
+
+	/* Ensure vcpu is not eligible during next spinloop */
+	kvm_vcpu_set_dy_eligible(me, false);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 

