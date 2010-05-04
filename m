Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab0EDUW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:22:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52370 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933809Ab0EDUUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:20:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/48] rcu: ignore offline CPUs in last non-dyntick-idle CPU check
Date: Tue,  4 May 2010 13:19:15 -0700
Message-Id: <1273004398-19760-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100504201934.GA19234@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Offline CPUs are not in nohz_cpu_mask, but can be ignored when checking
for the last non-dyntick-idle CPU.  This patch therefore only checks
online CPUs for not being dyntick idle, allowing fast entry into
full-system dyntick-idle state even when there are some offline CPUs.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 79b53bd..687c4e9 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1016,7 +1016,7 @@ int rcu_needs_cpu(int cpu)
 
 	/* Don't bother unless we are the last non-dyntick-idle CPU. */
 	for_each_cpu_not(thatcpu, nohz_cpu_mask)
-		if (thatcpu != cpu) {
+		if (cpu_online(thatcpu) && thatcpu != cpu) {
 			per_cpu(rcu_dyntick_drain, cpu) = 0;
 			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 			return rcu_needs_cpu_quick_check(cpu);
-- 
1.7.0

