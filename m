Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1LCSe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:34:56 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38327 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1LCSex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:34:53 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 1/7] rcu: Don't check irq nesting from rcu idle entry/exit
Date: Sat,  3 Dec 2011 10:34:36 -0800
Message-Id: <1322937282-19846-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111203183417.GA18914@linux.vnet.ibm.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
x-cbid: 11120318-8974-0000-0000-000003E43D3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Because tasks do not nest, rcu_idle_enter() and rcu_idle_exit() do
not need to check for nesting.  This commit therefore moves nesting
checks from rcu_idle_enter_common() to rcu_irq_exit() and from
rcu_idle_exit_common() to rcu_irq_enter().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index bf085d7..860c02c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -350,10 +350,6 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
  */
 static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 {
-	if (rdtp->dynticks_nesting) {
-		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
-		return;
-	}
 	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
@@ -426,7 +422,10 @@ void rcu_irq_exit(void)
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
-	rcu_idle_enter_common(rdtp, oldval);
+	if (rdtp->dynticks_nesting)
+		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
+	else
+		rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 
@@ -439,10 +438,6 @@ void rcu_irq_exit(void)
  */
 static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 {
-	if (oldval) {
-		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
-		return;
-	}
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
@@ -518,7 +513,10 @@ void rcu_irq_enter(void)
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
-	rcu_idle_exit_common(rdtp, oldval);
+	if (oldval)
+		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
+	else
+		rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
 
-- 
1.7.3.2

