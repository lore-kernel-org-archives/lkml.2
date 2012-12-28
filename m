Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab2L1TcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:32:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55521 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932350Ab2L1TTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:19 -0500
Message-Id: <20121228190342.730742230@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [ 060/173] rcu: Fix batch-limit size problem
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 878d7439d0f45a95869e417576774673d1fa243f upstream.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Module parameters remain hidden from sysfs]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/rcutree.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -202,13 +202,13 @@ DEFINE_PER_CPU(struct rcu_dynticks, rcu_
 };
 #endif /* #ifdef CONFIG_NO_HZ */
 
-static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
-static int qhimark = 10000;	/* If this many pending, ignore blimit. */
-static int qlowmark = 100;	/* Once only this many pending, use blimit. */
-
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
-module_param(qlowmark, int, 0);
+static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
+static long qhimark = 10000;	/* If this many pending, ignore blimit. */
+static long qlowmark = 100;	/* Once only this many pending, use blimit. */
+
+module_param(blimit, long, 0);
+module_param(qhimark, long, 0);
+module_param(qlowmark, long, 0);
 
 int rcu_cpu_stall_suppress __read_mostly;
 module_param(rcu_cpu_stall_suppress, int, 0644);
@@ -1260,7 +1260,7 @@ static void rcu_do_batch(struct rcu_stat
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count;
+	long bl, count;
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {


