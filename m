Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871Ab2J3QlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:41:21 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38952 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588Ab2J3Qjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/6] rcu: Fix batch-limit size problem
Date: Tue, 30 Oct 2012 09:27:51 -0700
Message-Id: <1351614475-22895-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030162728.GA22648@linux.vnet.ibm.com>
 <1351614475-22895-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-7408-0000-0000-000009C554B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Commit 29c00b4a1d9e27 (rcu: Add event-tracing for RCU callback
invocation) added a regression in rcu_do_batch()

Under stress, RCU is supposed to allow to process all items in queue,
instead of a batch of 10 items (blimit), but an integer overflow makes
the effective limit being 1.  So, unless there is frequent idle periods
(during which RCU ignores batch limits), RCU can be forced into a
state where it cannot keep up with the callback-generation rate,
eventually resulting in OOM.

This commit therefore converts a few variables in rcu_do_batch() from
int to long to fix this problem, along with the module parameters
controlling the batch limits.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> # 3.2 +
---
 kernel/rcutree.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 93d6871..e4c2192 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -212,13 +212,13 @@ DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 #endif
 };
 
-static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
-static int qhimark = 10000;	/* If this many pending, ignore blimit. */
-static int qlowmark = 100;	/* Once only this many pending, use blimit. */
+static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
+static long qhimark = 10000;	/* If this many pending, ignore blimit. */
+static long qlowmark = 100;	/* Once only this many pending, use blimit. */
 
-module_param(blimit, int, 0444);
-module_param(qhimark, int, 0444);
-module_param(qlowmark, int, 0444);
+module_param(blimit, long, 0444);
+module_param(qhimark, long, 0444);
+module_param(qlowmark, long, 0444);
 
 int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
 int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
@@ -1791,7 +1791,8 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count, count_lazy, i;
+	long bl, count, count_lazy;
+	int i;
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
-- 
1.7.8

