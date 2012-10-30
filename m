Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab2J3QkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:40:12 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58575 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844Ab2J3QkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:40:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/4] srcu: Export process_srcu()
Date: Tue, 30 Oct 2012 09:38:08 -0700
Message-Id: <1351615090-24398-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351615090-24398-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030163650.GA23518@linux.vnet.ibm.com>
 <1351615090-24398-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-5806-0000-0000-00001B344686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Because process_srcu() will be used in DEFINE_SRCU(), which is a macro
that could be expanded pretty much anywhere, it can no longer be static.
Note that process_srcu() is still internal to srcu.h.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h |    2 ++
 kernel/srcu.c        |    6 ++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index a55ddb1..5cce128 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -78,6 +78,8 @@ int init_srcu_struct(struct srcu_struct *sp);
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+void process_srcu(struct work_struct *work);
+
 /**
  * call_srcu() - Queue a callback for invocation after an SRCU grace period
  * @sp: srcu_struct in queue the callback
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 0b99f27..b363b09 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -94,9 +94,6 @@ static inline void rcu_batch_move(struct rcu_batch *to, struct rcu_batch *from)
 	}
 }
 
-/* single-thread state-machine */
-static void process_srcu(struct work_struct *work);
-
 static int init_srcu_struct_fields(struct srcu_struct *sp)
 {
 	sp->completed = 0;
@@ -639,7 +636,7 @@ static void srcu_reschedule(struct srcu_struct *sp)
 /*
  * This is the work-queue function that handles SRCU grace periods.
  */
-static void process_srcu(struct work_struct *work)
+void process_srcu(struct work_struct *work)
 {
 	struct srcu_struct *sp;
 
@@ -650,3 +647,4 @@ static void process_srcu(struct work_struct *work)
 	srcu_invoke_callbacks(sp);
 	srcu_reschedule(sp);
 }
+EXPORT_SYMBOL_GPL(process_srcu);
-- 
1.7.8

