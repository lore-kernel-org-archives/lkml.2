Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2BAToP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:44:15 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51819 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab2BAToE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:44:04 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 25/41] rcu: Make rcu_sleep_check() also check rcu_lock_map
Date: Wed,  1 Feb 2012 11:41:43 -0800
Message-Id: <1328125319-5205-25-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-7182-0000-0000-000000A32B3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Although it is OK to be preempted in an RCU read-side critical section
for TREE_PREEMPT_RCU, it is definitely not OK to be preempted, block,
or might_sleep() within an RCU read-side critical section for TREE_RCU.
Unfortunately, rcu_might_sleep() currently only checks for RCU-bh and
RCU-sched read-side critical sections.  This commit therefore makes
rcu_might_sleep() check for RCU read-side critical sections, but only
in TREE_RCU builds.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a67d5f1..6df0ae1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -381,8 +381,22 @@ extern int rcu_my_thread_group_empty(void);
 		}							\
 	} while (0)
 
+#if defined(CONFIG_PROVE_RCU) && !defined(CONFIG_PREEMPT_RCU)
+static inline void rcu_preempt_sleep_check(void)
+{
+	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
+			   "Illegal context switch in RCU read-side "
+			   "critical section");
+}
+#else /* #ifdef CONFIG_PROVE_RCU */
+static inline void rcu_preempt_sleep_check(void)
+{
+}
+#endif /* #else #ifdef CONFIG_PROVE_RCU */
+
 #define rcu_sleep_check()						\
 	do {								\
+		rcu_preempt_sleep_check();				\
 		rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),	\
 				   "Illegal context switch in RCU-bh"	\
 				   " read-side critical section");	\
-- 
1.7.8

