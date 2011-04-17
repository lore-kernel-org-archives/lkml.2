Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1DQJ6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:58:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1DQJ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:58:05 -0400
Message-Id: <20110417095506.818055829@chello.nl>
User-Agent: quilt/0.48-1
Date: Sun, 17 Apr 2011 11:45:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/7] lockdep: Implement extra recursive-read lock tests
References: <20110417094505.865828233@chello.nl>
Content-Disposition: inline; filename=lockdep-test-recursive-read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep is not able to detect simple rw deadlocks because it is not
tracking recursive read dependencies:

        read_lock(A) --> spin_lock(B)
        spin_lock(B) --> write_lock(A) /* should fail */

Furthermore, the following should not result in a deadlock for
recursive read locks:

        read_lock(A) --> spin_lock(B)
        spin_lock(B) --> read_lock(A) /* success */

Add these checks so that we may improve lockdep to accurately track
recursive read locks and report the correct answers.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 lib/locking-selftest.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

Index: tip/lib/locking-selftest.c
===================================================================
--- tip.orig/lib/locking-selftest.c
+++ tip/lib/locking-selftest.c
@@ -185,13 +185,16 @@ static void init_shared_classes(void)
 
 #define ML(x)			mutex_lock(&mutex_##x)
 #define MU(x)			mutex_unlock(&mutex_##x)
+#define MLU(x)			ML(x); MU(x)
 #define MI(x)			mutex_init(&mutex_##x)
 
 #define WSL(x)			down_write(&rwsem_##x)
 #define WSU(x)			up_write(&rwsem_##x)
+#define WSLU(x)			WSL(x); WSU(x)
 
 #define RSL(x)			down_read(&rwsem_##x)
 #define RSU(x)			up_read(&rwsem_##x)
+#define RSLU(x)			RSL(x); RSU(x)
 #define RWSI(x)			init_rwsem(&rwsem_##x)
 
 #define LOCK_UNLOCK_2(x,y)	LOCK(x); LOCK(y); UNLOCK(y); UNLOCK(x)
@@ -300,6 +303,50 @@ static void rsem_AA3(void)
 	RSL(X2); // this one should fail
 }
 
+static void rwlock_spinlock_ABBA(void)
+{
+	RL(A);
+	LU(B);
+	RU(A);
+
+	L(B);
+	WLU(A);	/* fail */
+	U(B);
+}
+
+static void rlock_spinlock_ABBA(void)
+{
+	RL(A);
+	LU(B);
+	RU(A);
+
+	L(B);
+	RLU(A); /* not fail */
+	U(B);
+}
+
+static void rwsem_mutex_ABBA(void)
+{
+	RSL(A);
+	MLU(B);
+	RSU(A);
+
+	ML(B);
+	WSLU(A); /* fail */
+	MU(B);
+}
+
+static void rsem_mutex_ABBA(void)
+{
+	RSL(A);
+	MLU(B);
+	RSU(A);
+
+	ML(B);
+	RSLU(A); /* fail */
+	MU(B);
+}
+
 /*
  * ABBA deadlock:
  */
@@ -1174,6 +1221,20 @@ void locking_selftest(void)
 	dotest(rsem_AA3, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
 
+	print_testname("mixed write-spin-read-lock");
+	printk("             |");
+	dotest(rwlock_spinlock_ABBA, FAILURE, LOCKTYPE_RWLOCK);
+	printk("             |");
+	dotest(rwsem_mutex_ABBA, FAILURE, LOCKTYPE_RWSEM);
+	printk("\n");
+
+	print_testname("mixed read-spin-read-lock");
+	printk("             |");
+	dotest(rlock_spinlock_ABBA, SUCCESS, LOCKTYPE_RWLOCK);
+	printk("             |");
+	dotest(rsem_mutex_ABBA, FAILURE, LOCKTYPE_RWSEM);
+	printk("\n");
+
 	printk("  --------------------------------------------------------------------------\n");
 
 	/*


