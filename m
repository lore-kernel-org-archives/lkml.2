Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab1LCSgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:36:05 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38069 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1LCSfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:35:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 2/7] rcu: Irq nesting is always 0 on rcu_enter_idle_common
Date: Sat,  3 Dec 2011 10:34:37 -0800
Message-Id: <1322937282-19846-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111203183417.GA18914@linux.vnet.ibm.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
x-cbid: 11120318-5930-0000-0000-000002DA8101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Because tasks don't nest, the ->dyntick_nesting must always be zero upon
entry to rcu_idle_enter_common().  Therefore, pass "0" rather than the
counter itself.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 860c02c..c0ed376 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -350,12 +350,11 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
  */
 static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 {
-	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
+	trace_rcu_dyntick("Start", oldval, 0);
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-		trace_rcu_dyntick("Error on entry: not idle task",
-				   oldval, rdtp->dynticks_nesting);
+		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
-- 
1.7.3.2

