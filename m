Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623Ab2FVPf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:35:57 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45452 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2FVPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:35:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 16/17] rcu: Disable preemption in rcu_blocking_is_gp()
Date: Fri, 22 Jun 2012 08:35:11 -0700
Message-Id: <1340379312-6684-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-1780-0000-0000-000006B6DB44
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00150294; UDB=6.00034140; UTC=2012-06-22
 15:35:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It is time to optimize CONFIG_TREE_PREEMPT_RCU's synchronize_rcu()
for uniprocessor optimization, which means that rcu_blocking_is_gp()
can no longer rely on RCU read-side critical sections having disabled
preemption.  This commit therefore disables preemption across
rcu_blocking_is_gp()'s scan of the cpu_online_mask.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ce175b6..c0cc41f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1978,28 +1978,13 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  * occasionally incorrectly indicate that there are multiple CPUs online
  * when there was in fact only one the whole time, as this just adds
  * some overhead: RCU still operates correctly.
- *
- * Of course, sampling num_online_cpus() with preemption enabled can
- * give erroneous results if there are concurrent CPU-hotplug operations.
- * For example, given a demonic sequence of preemptions in num_online_cpus()
- * and CPU-hotplug operations, there could be two or more CPUs online at
- * all times, but num_online_cpus() might well return one (or even zero).
- *
- * However, all such demonic sequences require at least one CPU-offline
- * operation.  Furthermore, rcu_blocking_is_gp() giving the wrong answer
- * is only a problem if there is an RCU read-side critical section executing
- * throughout.  But RCU-sched and RCU-bh read-side critical sections
- * disable either preemption or bh, which prevents a CPU from going offline.
- * Therefore, the only way that rcu_blocking_is_gp() can incorrectly return
- * that there is only one CPU when in fact there was more than one throughout
- * is when there were no RCU readers in the system.  If there are no
- * RCU readers, the grace period by definition can be of zero length,
- * regardless of the number of online CPUs.
  */
 static inline int rcu_blocking_is_gp(void)
 {
 	might_sleep();  /* Check for RCU read-side critical section. */
+	preempt_disable();
 	return num_online_cpus() <= 1;
+	preempt_enable();
 }
 
 /**
-- 
1.7.8

