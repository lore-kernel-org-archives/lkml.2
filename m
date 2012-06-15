Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab2FOS7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:59:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49973 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab2FOS7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:59:00 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/6] rcu: Test srcu_barrier() from rcutorture test suite
Date: Fri, 15 Jun 2012 11:57:51 -0700
Message-Id: <1339786674-25265-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061518-6148-0000-0000-000006BC9D98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

SRCU now has a call_srcu() and an srcu_barrier(), but rcutorture does
not test srcu_barrier().  This commit adds the machinery to allow
rcutorture's existing rcu_barrier() tests to apply to SRCU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 9850479..7b6935e 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -635,6 +635,17 @@ static void srcu_torture_synchronize(void)
 	synchronize_srcu(&srcu_ctl);
 }
 
+static void srcu_torture_call(struct rcu_head *head,
+			      void (*func)(struct rcu_head *head))
+{
+	call_srcu(&srcu_ctl, head, func);
+}
+
+static void srcu_torture_barrier(void)
+{
+	srcu_barrier(&srcu_ctl);
+}
+
 static int srcu_torture_stats(char *page)
 {
 	int cnt = 0;
@@ -661,8 +672,8 @@ static struct rcu_torture_ops srcu_ops = {
 	.completed	= srcu_torture_completed,
 	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
-	.call		= NULL,
-	.cb_barrier	= NULL,
+	.call		= srcu_torture_call,
+	.cb_barrier	= srcu_torture_barrier,
 	.stats		= srcu_torture_stats,
 	.name		= "srcu"
 };
-- 
1.7.8

