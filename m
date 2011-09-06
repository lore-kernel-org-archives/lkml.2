Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab1IGGVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:21:33 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48767 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab1IGGUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 33/55] rcu: Improve rcu_assign_pointer() and RCU_INIT_POINTER() documentation
Date: Tue,  6 Sep 2011 11:00:27 -0700
Message-Id: <1315332049-2604-33-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The differences between rcu_assign_pointer() and RCU_INIT_POINTER() are
subtle, and it is easy to use the the cheaper RCU_INIT_POINTER() when
the more-expensive rcu_assign_pointer() should have been used instead.
The consequences of this mistake are quite severe.

This commit therefore carefully lays out the situations in which it it
permissible to use RCU_INIT_POINTER().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   47 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b2e5fe8..9873040 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -754,11 +754,18 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * any prior initialization.  Returns the value assigned.
  *
  * Inserts memory barriers on architectures that require them
- * (pretty much all of them other than x86), and also prevents
- * the compiler from reordering the code that initializes the
- * structure after the pointer assignment.  More importantly, this
- * call documents which pointers will be dereferenced by RCU read-side
- * code.
+ * (which is most of them), and also prevents the compiler from
+ * reordering the code that initializes the structure after the pointer
+ * assignment.  More importantly, this call documents which pointers
+ * will be dereferenced by RCU read-side code.
+ *
+ * In some special cases, you may use RCU_INIT_POINTER() instead
+ * of rcu_assign_pointer().  RCU_INIT_POINTER() is a bit faster due
+ * to the fact that it does not constrain either the CPU or the compiler.
+ * That said, using RCU_INIT_POINTER() when you should have used
+ * rcu_assign_pointer() is a very bad thing that results in
+ * impossible-to-diagnose memory corruption.  So please be careful.
+ * See the RCU_INIT_POINTER() comment header for details.
  */
 #define rcu_assign_pointer(p, v) \
 	__rcu_assign_pointer((p), (v), __rcu)
@@ -766,8 +773,34 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 /**
  * RCU_INIT_POINTER() - initialize an RCU protected pointer
  *
- * Initialize an RCU-protected pointer in such a way to avoid RCU-lockdep
- * splats.
+ * Initialize an RCU-protected pointer in special cases where readers
+ * do not need ordering constraints on the CPU or the compiler.  These
+ * special cases are:
+ *
+ * 1.	This use of RCU_INIT_POINTER() is NULLing out the pointer -or-
+ * 2.	The caller has taken whatever steps are required to prevent
+ *	RCU readers from concurrently accessing this pointer -or-
+ * 3.	The referenced data structure has already been exposed to
+ *	readers either at compile time or via rcu_assign_pointer() -and-
+ *	a.	You have not made -any- reader-visible changes to
+ *		this structure since then -or-
+ *	b.	It is OK for readers accessing this structure from its
+ *		new location to see the old state of the structure.  (For
+ *		example, the changes were to statistical counters or to
+ *		other state where exact synchronization is not required.)
+ *
+ * Failure to follow these rules governing use of RCU_INIT_POINTER() will
+ * result in impossible-to-diagnose memory corruption.  As in the structures
+ * will look OK in crash dumps, but any concurrent RCU readers might
+ * see pre-initialized values of the referenced data structure.  So
+ * please be very careful how you use RCU_INIT_POINTER()!!!
+ *
+ * If you are creating an RCU-protected linked structure that is accessed
+ * by a single external-to-structure RCU-protected pointer, then you may
+ * use RCU_INIT_POINTER() to initialize the internal RCU-protected
+ * pointers, but you must use rcu_assign_pointer() to initialize the
+ * external-to-structure pointer -after- you have completely initialized
+ * the reader-accessible portions of the linked structure.
  */
 #define RCU_INIT_POINTER(p, v) \
 		p = (typeof(*v) __force __rcu *)(v)
-- 
1.7.3.2

