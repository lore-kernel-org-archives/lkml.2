Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab1FIXr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:47:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36965 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab1FIXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Qj4Id+sOIkve4ejJmIitViA25B3Qv1pyDSZ313y6Z7mEcrSt+GH+VCOdLyqMFbVQyQ
         B3xMqwyapRGHDQ3+ukiDnoMSV1hkPaeMH0/7YUXUxI4Lzowlp+rYwiZlQ0ACAY9T5Xq2
         kSvJGyrnu6h+JLoA5xkUDxhom6ysgqSDHJgI8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>
Subject: [PATCH 1/4] rcu: Detect uses of rcu read side in extended quiescent states
Date: Fri, 10 Jun 2011 01:47:24 +0200
Message-Id: <1307663247-5397-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
References: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect uses of rcu that are not supposed to happen when we
are in an extended quiescent state.

This can happen for example if we use rcu between the time we
stop the tick and the time we restart it. Or inside an irq that
didn't use rcu_irq_enter,exit() or other possible kind of rcu API
misuse.

v2: Rebase against latest rcu changes, handle tiny RCU as well

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 include/linux/rcupdate.h |    9 +++++++++
 kernel/rcutiny.c         |   13 +++++++++++++
 kernel/rcutree.c         |   14 ++++++++++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9db50df..6cad1f3 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -388,6 +388,12 @@ extern int rcu_my_thread_group_empty(void);
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
+#if defined(CONFIG_PROVE_RCU) && defined(CONFIG_NO_HZ)
+extern bool rcu_check_extended_qs(void);
+#else
+static inline bool rcu_check_extended_qs(void) { return false; }
+#endif
+
 /*
  * Helper functions for rcu_dereference_check(), rcu_dereference_protected()
  * and rcu_assign_pointer().  Some of these could be folded into their
@@ -415,6 +421,9 @@ extern int rcu_my_thread_group_empty(void);
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
 		rcu_lockdep_assert(c, "suspicious rcu_dereference_check()" \
 				      " usage"); \
+		rcu_lockdep_assert(!rcu_check_extended_qs(), \
+				   "use of rcu_dereference_check() in an extended" \
+				   " quiescent state");	\
 		rcu_dereference_sparse(p, space); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 775d69a..44a2a15 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -76,6 +76,19 @@ void rcu_exit_nohz(void)
 	rcu_dynticks_nesting++;
 }
 
+
+#ifdef CONFIG_PROVE_RCU
+
+bool rcu_check_extended_qs(void)
+{
+	if (!rcu_dynticks_nesting)
+		return true;
+
+	return false;
+}
+
+#endif
+
 #endif /* #ifdef CONFIG_NO_HZ */
 
 /*
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 305dfae..8211527 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -432,6 +432,20 @@ void rcu_irq_exit(void)
 	rcu_enter_nohz();
 }
 
+#ifdef CONFIG_PROVE_RCU
+
+bool rcu_check_extended_qs(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (atomic_read(&rdtp->dynticks) & 0x1)
+		return false;
+
+	return true;
+}
+
+#endif /* CONFIG_PROVE_RCU */
+
 #ifdef CONFIG_SMP
 
 /*
-- 
1.7.5.4

