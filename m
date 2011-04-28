Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1D1FXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 01:23:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41860 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1D1FXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 01:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=N9vC6naQ5kN59v7ZlSs6jLm3WGe/qS/o5cFjCo6emVk06OFX1hfph62MbxfyoDxwqa
         5EnBEIoHs/x68q1XpK69t4QTdXSNmCdyrc/25vrtHp+/2daNqSJeURr8LQMo4OJJ7yQw
         pU+St7Kv5Hgkg5PGChOraJc8SmKGqE9KSWsm0=
Subject: [PATCH] rcu: optimize rcutiny
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 07:23:45 +0200
Message-ID: <1303968225.2587.602.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_sched_qs() currently calls local_irq_save()/local_irq_restore() up
to three times.

Remove irq masking from rcu_qsctr_help() / invoke_rcu_kthread()
and do it once in rcu_sched_qs() / rcu_bh_qs()

This generates smaller code as well.

# size kernel/rcutiny.old.o kernel/rcutiny.new.o
   text	   data	    bss	    dec	    hex	filename
   2314	    156	     24	   2494	    9be	kernel/rcutiny.old.o
   2250	    156	     24	   2430	    97e	kernel/rcutiny.new.o

Fix an outdated comment for rcu_qsctr_help()
Move invoke_rcu_kthread() definition before its use.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 kernel/rcutiny.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 0c343b9..29eb349 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -40,7 +40,6 @@
 static struct task_struct *rcu_kthread_task;
 static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
 static unsigned long have_rcu_kthread_work;
-static void invoke_rcu_kthread(void);
 
 /* Forward declarations for rcutiny_plugin.h. */
 struct rcu_ctrlblk;
@@ -79,36 +78,45 @@ void rcu_exit_nohz(void)
 #endif /* #ifdef CONFIG_NO_HZ */
 
 /*
- * Helper function for rcu_qsctr_inc() and rcu_bh_qsctr_inc().
- * Also disable irqs to avoid confusion due to interrupt handlers
+ * Helper function for rcu_sched_qs() and rcu_bh_qs().
+ * Also irqs are disabled to avoid confusion due to interrupt handlers
  * invoking call_rcu().
  */
 static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
 	if (rcp->rcucblist != NULL &&
 	    rcp->donetail != rcp->curtail) {
 		rcp->donetail = rcp->curtail;
-		local_irq_restore(flags);
 		return 1;
 	}
-	local_irq_restore(flags);
 
 	return 0;
 }
 
 /*
+ * Wake up rcu_kthread() to process callbacks now eligible for invocation
+ * or to boost readers.
+ */
+static void invoke_rcu_kthread(void)
+{
+	have_rcu_kthread_work = 1;
+	wake_up(&rcu_kthread_wq);
+}
+
+/*
  * Record an rcu quiescent state.  And an rcu_bh quiescent state while we
  * are at it, given that any rcu quiescent state is also an rcu_bh
  * quiescent state.  Use "+" instead of "||" to defeat short circuiting.
  */
 void rcu_sched_qs(int cpu)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
 		invoke_rcu_kthread();
+	local_irq_restore(flags);
 }
 
 /*
@@ -116,8 +124,12 @@ void rcu_sched_qs(int cpu)
  */
 void rcu_bh_qs(int cpu)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
 		invoke_rcu_kthread();
+	local_irq_restore(flags);
 }
 
 /*
@@ -208,20 +220,6 @@ static int rcu_kthread(void *arg)
 }
 
 /*
- * Wake up rcu_kthread() to process callbacks now eligible for invocation
- * or to boost readers.
- */
-static void invoke_rcu_kthread(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	have_rcu_kthread_work = 1;
-	wake_up(&rcu_kthread_wq);
-	local_irq_restore(flags);
-}
-
-/*
  * Wait for a grace period to elapse.  But it is illegal to invoke
  * synchronize_sched() from within an RCU read-side critical section.
  * Therefore, any legal call to synchronize_sched() is a quiescent


