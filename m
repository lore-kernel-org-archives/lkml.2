Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab2H3VS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:18:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47514 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2H3VOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/26] rcu: Make RCU_FAST_NO_HZ handle adaptive ticks
Date: Thu, 30 Aug 2012 14:05:20 -0700
Message-Id: <1346360743-3628-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-7408-0000-0000-0000080B574A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The current implementation of RCU_FAST_NO_HZ tries reasonably hard to rid
the current CPU of RCU callbacks.  This is appropriate when the CPU is
entering idle, where it doesn't have much useful to do anyway, but is most
definitely not what you want when transitioning to user-mode execution.
This commit therefore detects the adaptive-tick case, and refrains from
burning CPU time getting rid of RCU callbacks in that case.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 7f3244c..b0f09d6 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1997,6 +1997,26 @@ static void rcu_prepare_for_idle(int cpu)
 	if (!tne)
 		return;
 
+	/* Adaptive-tick mode, where usermode execution is idle to RCU. */
+	if (!is_idle_task(current)) {
+		rdtp->dyntick_holdoff = jiffies - 1;
+		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
+			trace_rcu_prep_idle("User dyntick with callbacks");
+			rdtp->idle_gp_timer_expires =
+				round_up(jiffies + RCU_IDLE_GP_DELAY,
+					 RCU_IDLE_GP_DELAY);
+		} else if (rcu_cpu_has_callbacks(cpu)) {
+			rdtp->idle_gp_timer_expires =
+				round_jiffies(jiffies + RCU_IDLE_LAZY_GP_DELAY);
+			trace_rcu_prep_idle("User dyntick with lazy callbacks");
+		} else {
+			return;
+		}
+		tp = &rdtp->idle_gp_timer;
+		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
+		return;
+	}
+
 	/*
 	 * If this is an idle re-entry, for example, due to use of
 	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
-- 
1.7.8

