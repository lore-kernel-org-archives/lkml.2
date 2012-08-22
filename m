Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab2HVIy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:54:27 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:47269 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2HVIyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:54:24 -0400
Message-ID: <1345625663.29604.36.camel@vlad>
Subject: [PATCH] sched: optimize the locking in the rebalance_domains()
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Date: Wed, 22 Aug 2012 11:54:23 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't perform the locking in the rebalance_domains() when it's not needed.

rebalance_domains() tried to take a "balancing" spin-lock when SD_SERIALIZE 
flag was set (which is a default configuration for NUMA aware systems)
every time it was called. This is done regardless the fact that maybe
there hasn't passed enough time since the last re-balancing in which case
there is no need to take a lock the first place.

The above creates a heavy false sharing problem on the "balancing"
spin-lock on large SMP systems: try_lock() is implemented with an
(atomic) xchng instruction which invalidates the cache line "balancing"
belongs to and therefore creates an intensive cross-NUMA-nodes traffic.

The below patch will minimize the above phenomena to the time slots it's
really needed, namely when the "interval" time period has really passed 
since the last re-balancing.

Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 kernel/sched/fair.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c219bf8..298e201 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4754,6 +4754,13 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		interval = msecs_to_jiffies(interval);
 		interval = clamp(interval, 1UL, max_load_balance_interval);
 
+		/*
+		 * continue to the next domain if the current domain doesn't
+		 * need to be re-balanced yet
+		 */
+		if (time_before(jiffies, sd->last_balance + interval))
+			goto out;
+
 		need_serialize = sd->flags & SD_SERIALIZE;
 
 		if (need_serialize) {
@@ -4761,16 +4768,15 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 				goto out;
 		}
 
-		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance)) {
-				/*
-				 * We've pulled tasks over so either we're no
-				 * longer idle.
-				 */
-				idle = CPU_NOT_IDLE;
-			}
-			sd->last_balance = jiffies;
+		if (load_balance(cpu, rq, sd, idle, &balance)) {
+			/*
+			 * We've pulled tasks over so either we're no
+			 * longer idle.
+			 */
+			idle = CPU_NOT_IDLE;
 		}
+		sd->last_balance = jiffies;
+
 		if (need_serialize)
 			spin_unlock(&balancing);
 out:
-- 
1.7.9.5



