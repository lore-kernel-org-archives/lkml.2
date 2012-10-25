Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055Ab2JYRs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:48:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57166 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934964Ab2JYRsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:48:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/5] kvm: Directly account vtime to system on guest switch
Date: Thu, 25 Oct 2012 19:48:01 +0200
Message-Id: <1351187283-20715-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
References: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switching to or from guest context is done on ioctl context.
So by the time we call kvm_guest_enter() or kvm_guest_exit()
we know we are not running the idle task.

As a result, we can directly account the cputime using
vtime_account_system().

There are two good reasons to do this:

* We avoid some useless checks on guest switch. It optimizes
a bit this fast path.

* In the case of CONFIG_IRQ_TIME_ACCOUNTING, calling vtime_account()
checks for irq time to account. This is pointless since we know
we are not in an irq on guest switch. This is wasting cpu cycles
for no good reason. vtime_account_system() OTOH is a no-op in
this config option.

* We can remove the irq disable/enable around kvm guest switch in s390.

A further optimization may consist in introducing a vtime_account_guest()
that directly calls account_guest_time().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Xiantao Zhang <xiantao.zhang@intel.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/s390/kvm/kvm-s390.c |    4 ----
 include/linux/kvm_host.h |   12 ++++++++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ecced9d..d91a955 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -608,9 +608,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		kvm_s390_deliver_pending_interrupts(vcpu);
 
 	vcpu->arch.sie_block->icptcode = 0;
-	local_irq_disable();
 	kvm_guest_enter();
-	local_irq_enable();
 	VCPU_EVENT(vcpu, 6, "entering sie flags %x",
 		   atomic_read(&vcpu->arch.sie_block->cpuflags));
 	trace_kvm_s390_sie_enter(vcpu,
@@ -629,9 +627,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
 		   vcpu->arch.sie_block->icptcode);
 	trace_kvm_s390_sie_exit(vcpu, vcpu->arch.sie_block->icptcode);
-	local_irq_disable();
 	kvm_guest_exit();
-	local_irq_enable();
 
 	memcpy(&vcpu->run->s.regs.gprs[14], &vcpu->arch.sie_block->gg14, 16);
 	return rc;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 93bfc9f..0e2212f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -737,7 +737,11 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 static inline void kvm_guest_enter(void)
 {
 	BUG_ON(preemptible());
-	vtime_account(current);
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
 	current->flags |= PF_VCPU;
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
@@ -751,7 +755,11 @@ static inline void kvm_guest_enter(void)
 
 static inline void kvm_guest_exit(void)
 {
-	vtime_account(current);
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
 	current->flags &= ~PF_VCPU;
 }
 
-- 
1.7.5.4

