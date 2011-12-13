Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1LMAmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:42:36 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:35092 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1LMAmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:42:35 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 1/6] rcu: Add rcutorture tests for srcu_read_lock_raw()
Date: Mon, 12 Dec 2011 16:42:19 -0800
Message-Id: <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20111213004144.GA32120@linux.vnet.ibm.com>
References: <20111213004144.GA32120@linux.vnet.ibm.com>
x-cbid: 11121300-7408-0000-0000-00000138C469
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds simple rcutorture tests for srcu_read_lock_raw() and
srcu_read_unlock_raw().  It does not test doing srcu_read_lock_raw()
in an exception handler and releasing it in the corresponding process
context.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 186ead9..88f17b8 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -632,6 +632,30 @@ static struct rcu_torture_ops srcu_ops = {
 	.name		= "srcu"
 };
 
+static int srcu_torture_read_lock_raw(void) __acquires(&srcu_ctl)
+{
+	return srcu_read_lock_raw(&srcu_ctl);
+}
+
+static void srcu_torture_read_unlock_raw(int idx) __releases(&srcu_ctl)
+{
+	srcu_read_unlock_raw(&srcu_ctl, idx);
+}
+
+static struct rcu_torture_ops srcu_raw_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock_raw,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock_raw,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_raw"
+};
+
 static void srcu_torture_synchronize_expedited(void)
 {
 	synchronize_srcu_expedited(&srcu_ctl);
@@ -1591,7 +1615,7 @@ rcu_torture_init(void)
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
 		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
-		  &srcu_ops, &srcu_expedited_ops,
+		  &srcu_ops, &srcu_raw_ops, &srcu_expedited_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
-- 
1.7.8

