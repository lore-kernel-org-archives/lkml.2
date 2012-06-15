Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab2FOUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:16:27 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48876 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab2FOUNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:13:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/14] rcu: Remove function versions of __kfree_rcu and __is_kfree_rcu_offset
Date: Fri, 15 Jun 2012 13:13:11 -0700
Message-Id: <1339791195-26389-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061520-6148-0000-0000-000006BD37ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Commit d8169d4c (Make __kfree_rcu() less dependent on compiler choices)
added cpp macro versions of __kfree_rcu() and __is_kfree_rcu_offset(),
but failed to remove the old inline-function versions.  This commit does
this cleanup.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index f773a4a..4874d26 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -917,24 +917,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define INIT_RCU_POINTER(p, v) \
 		.p = (typeof(*v) __force __rcu *)(v)
 
-static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
-{
-	return offset < 4096;
-}
-
-static __always_inline
-void __kfree_rcu(struct rcu_head *head, unsigned long offset)
-{
-	typedef void (*rcu_callback)(struct rcu_head *);
-
-	BUILD_BUG_ON(!__builtin_constant_p(offset));
-
-	/* See the kfree_rcu() header comment. */
-	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
-
-	kfree_call_rcu(head, (rcu_callback)offset);
-}
-
 /*
  * Does the specified offset indicate that the corresponding rcu_head
  * structure can be handled by kfree_rcu()?
-- 
1.7.8

