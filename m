Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2BUR7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:59:50 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:40919 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2BUR7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:59:45 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/4] rcu: Hold off RCU_FAST_NO_HZ after timer posted
Date: Tue, 21 Feb 2012 09:58:27 -0800
Message-Id: <1329847110-10897-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1329847110-10897-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120221175810.GA10708@linux.vnet.ibm.com>
 <1329847110-10897-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022117-5518-0000-0000-000002678D9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit handles workloads that transition quickly between idle and
non-idle, and where the CPU's callbacks cannot be invoked, but where
RCU does not have anything immediate for the CPU to do.  Without this
patch, the RCU_FAST_NO_HZ code can be invoked repeatedly on each entry
to idle.  The commit sets the per-CPU rcu_dyntick_holdoff variable to
hold off further attempts for a tick.

Reported-by: "Abou Gazala, Neven M" <neven.m.abou.gazala@intel.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 392a651..c023464 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2138,7 +2138,7 @@ static void rcu_prepare_for_idle(int cpu)
 		/* Can we go dyntick-idle despite still having callbacks? */
 		trace_rcu_prep_idle("Dyntick with callbacks");
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
-		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
 		if (rcu_cpu_has_nonlazy_callbacks(cpu))
 			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
 				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
-- 
1.7.8

