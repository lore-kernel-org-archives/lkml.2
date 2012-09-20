Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2ITSti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:49:38 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43001 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab2ITStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:49:32 -0400
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
Subject: [PATCH tip/core/rcu 07/23] rcu: Prevent offline CPUs from executing RCU core code
Date: Thu, 20 Sep 2012 11:48:03 -0700
Message-Id: <1348166900-18716-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-5518-0000-0000-000007CEF513
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Earlier versions of RCU invoked the RCU core from the CPU_DYING notifier
in order to note a quiescent state for the outgoing CPU.  Because the
CPU is marked "offline" during the execution of the CPU_DYING notifiers,
the RCU core had to tolerate being invoked from an offline CPU.  However,
commit b1420f1c (Make rcu_barrier() less disruptive) left only tracing
code in the CPU_DYING notifier, so the RCU core need no longer execute
on offline CPUs.  This commit therefore enforces this restriction.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f061740..c5938e8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1890,6 +1890,8 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	struct rcu_state *rsp;
 
+	if (cpu_is_offline(smp_processor_id()))
+		return;
 	trace_rcu_utilization("Start RCU core");
 	for_each_rcu_flavor(rsp)
 		__rcu_process_callbacks(rsp);
-- 
1.7.8

