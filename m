Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab1DBKVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 06:21:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46000 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab1DBKV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 06:21:28 -0400
Date: Sat, 2 Apr 2011 12:21:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20110402102114.GA15391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Paul E. McKenney (1):
      rcu: create new rcu_access_index() and use in mce

Steven Rostedt (1):
      WARN_ON_SMP(): Add comment to explain ({0;})


 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 include/asm-generic/bug.h        |    7 +++++++
 include/linux/rcupdate.h         |   20 ++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a05ef6..3385ea2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1626,7 +1626,7 @@ out:
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference_check_mce(mcelog.next))
+	if (rcu_access_index(mcelog.next))
 		return POLLIN | POLLRDNORM;
 	if (!mce_apei_read_done && apei_check_mce())
 		return POLLIN | POLLRDNORM;
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index f2d2faf..e5a3f58 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -194,6 +194,13 @@ extern void warn_slowpath_null(const char *file, const int line);
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
+/*
+ * Use of ({0;}) because WARN_ON_SMP(x) may be used either as
+ * a stand alone line statement or as a condition in an if ()
+ * statement.
+ * A simple "0" would cause gcc to give a "statement has no effect"
+ * warning.
+ */
 # define WARN_ON_SMP(x)			({0;})
 #endif
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index af56148..ff422d2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -339,6 +339,12 @@ extern int rcu_my_thread_group_empty(void);
 		((typeof(*p) __force __kernel *)(p)); \
 	})
 
+#define __rcu_access_index(p, space) \
+	({ \
+		typeof(p) _________p1 = ACCESS_ONCE(p); \
+		rcu_dereference_sparse(p, space); \
+		(_________p1); \
+	})
 #define __rcu_dereference_index_check(p, c) \
 	({ \
 		typeof(p) _________p1 = ACCESS_ONCE(p); \
@@ -429,6 +435,20 @@ extern int rcu_my_thread_group_empty(void);
 #define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
 
 /**
+ * rcu_access_index() - fetch RCU index with no dereferencing
+ * @p: The index to read
+ *
+ * Return the value of the specified RCU-protected index, but omit the
+ * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
+ * when the value of this index is accessed, but the index is not
+ * dereferenced, for example, when testing an RCU-protected index against
+ * -1.  Although rcu_access_index() may also be used in cases where
+ * update-side locks prevent the value of the index from changing, you
+ * should instead use rcu_dereference_index_protected() for this use case.
+ */
+#define rcu_access_index(p) __rcu_access_index((p), __rcu)
+
+/**
  * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
  * @p: The pointer to read, prior to dereferencing
  * @c: The conditions under which the dereference will take place
