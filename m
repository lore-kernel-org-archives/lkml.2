Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab0DVTy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:54:27 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52029 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654Ab0DVTyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:54:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 3/3] sched: protect __sched_setscheduler() access to cgroups
Date: Thu, 22 Apr 2010 12:54:07 -0700
Message-Id: <1271966047-9701-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100422195345.GA9639@linux.vnet.ibm.com>
References: <20100422195345.GA9639@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A given task's cgroups structures must remain while that task is running
due to reference counting, so this is presumably a false positive.
Updated to reflect feedback from Tetsuo Handa.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/sched.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 14c44ec..f425a2b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4575,9 +4575,13 @@ recheck:
 		 * Do not allow realtime tasks into groups that have no runtime
 		 * assigned.
 		 */
+		rcu_read_lock();
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0)
+				task_group(p)->rt_bandwidth.rt_runtime == 0) {
+			rcu_read_unlock();
 			return -EPERM;
+		}
+		rcu_read_unlock();
 #endif
 
 		retval = security_task_setscheduler(p, policy, param);
-- 
1.7.0

