Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab2JHWg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:36:26 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47531 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab2JHWgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:36:20 -0400
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
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] kvm: Directly account vtime to system on guest switch
Date: Tue,  9 Oct 2012 00:36:06 +0200
Message-Id: <1349735768-17586-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1349735768-17586-1-git-send-email-fweisbec@gmail.com>
References: <1349735768-17586-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switching to or from guest context is done on ioctl context.
So by the time we call kvm_guest_enter() or kvm_guest_exit()
we know we are not running the idle task.

As a result, we can directly account the cputime using
vtime_account_system().

There are two good reasons to do this:

* We avoid one indirect call and some useless checks on guest switch.
It optimizes a bit this fast path.

* In the case of CONFIG_IRQ_TIME_ACCOUNTING, calling vtime_account()
checks for irq time to account. This is pointless since we know
we are not in an irq on guest switch. This is wasting cpu cycles
for no good reason. vtime_account_system() OTOH is a no-op in
this config option.

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
---
 arch/ia64/kernel/time.c     |    1 +
 arch/powerpc/kernel/time.c  |    1 +
 arch/s390/kernel/vtime.c    |    4 ++++
 include/linux/kernel_stat.h |    1 +
 include/linux/kvm_host.h    |   12 ++++++++++--
 5 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 80ff9ac..3337e97 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -141,6 +141,7 @@ void vtime_account_system(struct task_struct *tsk)
 
 	account_system_time(tsk, 0, delta, delta);
 }
+EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void vtime_account_idle(struct task_struct *tsk)
 {
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index eaa9d0e..5547452 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -345,6 +345,7 @@ void vtime_account_system(struct task_struct *tsk)
 	if (stolen)
 		account_steal_time(stolen);
 }
+EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void vtime_account_idle(struct task_struct *tsk)
 {
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index cb5093c..972082d 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -140,6 +140,10 @@ void vtime_account(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 
+void vtime_account_system(struct task_struct *tsk)
+__attribute__((alias("vtime_account")));
+EXPORT_SYMBOL_GPL(vtime_account_system);
+
 void __kprobes vtime_stop_cpu(void)
 {
 	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 36d12f0..6747d4b 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -136,6 +136,7 @@ extern void vtime_account_system(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
 #else
 static inline void vtime_task_switch(struct task_struct *prev) { }
+static inline void vtime_account_system(struct task_struct *tsk) { }
 #endif
 
 #endif /* _LINUX_KERNEL_STAT_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8a59e0a..148db3e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -685,7 +685,11 @@ static inline int kvm_deassign_device(struct kvm *kvm,
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
@@ -699,7 +703,11 @@ static inline void kvm_guest_enter(void)
 
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

