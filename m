Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1K1VZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:25:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44383 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1K1VY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:24:56 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 1/4] rcu: Don't check irq nesting from rcu idle entry/exit
Date: Mon, 28 Nov 2011 22:24:44 +0100
Message-Id: <1322515487-18690-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_idle_enter() and rcu_idle_exit() don't need to check
the irq nesting as they are not called from irq.

Only check dyntick_nesting from rcu_irq_enter() and
rcu_irq_exit().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 28f8f92..c2aaadf 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -350,10 +350,6 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
  */
 static void rcu_idle_enter_common(struct rcu_dynticks *rdtp)
 {
-	if (rdtp->dynticks_nesting) {
-		trace_rcu_dyntick("--=", rdtp->dynticks_nesting);
-		return;
-	}
 	trace_rcu_dyntick("Start", rdtp->dynticks_nesting);
 	if (!idle_cpu(smp_processor_id())) {
 		WARN_ON_ONCE(1);	/* must be idle task! */
@@ -417,7 +413,10 @@ void rcu_irq_exit(void)
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
-	rcu_idle_enter_common(rdtp);
+	if (rdtp->dynticks_nesting)
+		trace_rcu_dyntick("--=", rdtp->dynticks_nesting);
+	else
+		rcu_idle_enter_common(rdtp);
 	local_irq_restore(flags);
 }
 
@@ -430,10 +429,6 @@ void rcu_irq_exit(void)
  */
 static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 {
-	if (oldval) {
-		trace_rcu_dyntick("++=", rdtp->dynticks_nesting);
-		return;
-	}
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
@@ -503,7 +498,10 @@ void rcu_irq_enter(void)
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
-	rcu_idle_exit_common(rdtp, oldval);
+	if (oldval)
+		trace_rcu_dyntick("++=", rdtp->dynticks_nesting);
+	else
+		rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 
-- 
1.7.5.4

