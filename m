Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2ITStZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:49:25 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57427 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2ITStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:49:22 -0400
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
Subject: [PATCH tip/core/rcu 14/23] rcu: Control grace-period duration from sysfs
Date: Thu, 20 Sep 2012 11:48:10 -0700
Message-Id: <1348166900-18716-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-2876-0000-0000-00000058A1D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Although almost everyone is well-served by the defaults, some uses of RCU
benefit from shorter grace periods, while others benefit more from the
greater efficiency provided by longer grace periods.  Situations requiring
a large number of grace periods to elapse (and wireshark startup has
been called out as an example of this) are helped by lower-latency
grace periods.  Furthermore, in some embedded applications, people are
willing to accept a small degradation in update efficiency (due to there
being more of the shorter grace-period operations) in order to gain the
lower latency.

In contrast, those few systems with thousands of CPUs need longer grace
periods because the CPU overhead of a grace period rises roughly
linearly with the number of CPUs.  Such systems normally do not make
much use of facilities that require large numbers of grace periods to
elapse, so this is a good tradeoff.

Therefore, this commit allows the durations to be controlled from sysfs.
There are two sysfs parameters, one named "jiffies_till_first_fqs" that
specifies the delay in jiffies from the end of grace-period initialization
until the first attempt to force quiescent states, and the other named
"jiffies_till_next_fqs" that specifies the delay (again in jiffies)
between subsequent attempts to force quiescent states.  They both default
to three jiffies, which is compatible with the old hard-coded behavior.

At some future time, it may be possible to automatically increase the
grace-period length with the number of CPUs, but we do not yet have
sufficient data to do a good job.  Preliminary data indicates that we
should add an addiitonal jiffy to each of the delays for every 200 CPUs
in the system, but more experimentation is needed.  For now, the number
of systems with more than 1,000 CPUs is small enough that this can be
relegated to boot-time hand tuning.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/kernel-parameters.txt |   11 +++++++++++
 kernel/rcutree.c                    |   25 ++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ad7e2e5..55ada04 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2385,6 +2385,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	rcutree.rcu_cpu_stall_timeout= [KNL,BOOT]
 			Set timeout for RCU CPU stall warning messages.
 
+	rcutree.jiffies_till_first_fqs= [KNL,BOOT]
+			Set delay from grace-period initialization to
+			first attempt to force quiescent states.
+			Units are jiffies, minimum value is zero,
+			and maximum value is HZ.
+
+	rcutree.jiffies_till_next_fqs= [KNL,BOOT]
+			Set delay between subsequent attempts to force
+			quiescent states.  Units are jiffies, minimum
+			value is one, and maximum value is HZ.
+
 	rcutorture.fqs_duration= [KNL,BOOT]
 			Set duration of force_quiescent_state bursts.
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5edbdf8..13ce38c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -226,6 +226,12 @@ int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
 module_param(rcu_cpu_stall_suppress, int, 0644);
 module_param(rcu_cpu_stall_timeout, int, 0644);
 
+static ulong jiffies_till_first_fqs = RCU_JIFFIES_TILL_FORCE_QS;
+static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
+
+module_param(jiffies_till_first_fqs, ulong, 0644);
+module_param(jiffies_till_next_fqs, ulong, 0644);
+
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
 static void force_quiescent_state(struct rcu_state *rsp);
 static int rcu_pending(int cpu);
@@ -1175,6 +1181,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 static int __noreturn rcu_gp_kthread(void *arg)
 {
 	int fqs_state;
+	unsigned long j;
 	int ret;
 	struct rcu_state *rsp = arg;
 	struct rcu_node *rnp = rcu_get_root(rsp);
@@ -1195,14 +1202,18 @@ static int __noreturn rcu_gp_kthread(void *arg)
 
 		/* Handle quiescent-state forcing. */
 		fqs_state = RCU_SAVE_DYNTICK;
+		j = jiffies_till_first_fqs;
+		if (j > HZ) {
+			j = HZ;
+			jiffies_till_first_fqs = HZ;
+		}
 		for (;;) {
-			rsp->jiffies_force_qs = jiffies +
-						RCU_JIFFIES_TILL_FORCE_QS;
+			rsp->jiffies_force_qs = jiffies + j;
 			ret = wait_event_interruptible_timeout(rsp->gp_wq,
 					(rsp->gp_flags & RCU_GP_FLAG_FQS) ||
 					(!ACCESS_ONCE(rnp->qsmask) &&
 					 !rcu_preempt_blocked_readers_cgp(rnp)),
-					RCU_JIFFIES_TILL_FORCE_QS);
+					j);
 			/* If grace period done, leave loop. */
 			if (!ACCESS_ONCE(rnp->qsmask) &&
 			    !rcu_preempt_blocked_readers_cgp(rnp))
@@ -1216,6 +1227,14 @@ static int __noreturn rcu_gp_kthread(void *arg)
 				cond_resched();
 				flush_signals(current);
 			}
+			j = jiffies_till_next_fqs;
+			if (j > HZ) {
+				j = HZ;
+				jiffies_till_next_fqs = HZ;
+			} else if (j < 1) {
+				j = 1;
+				jiffies_till_next_fqs = 1;
+			}
 		}
 
 		/* Handle grace-period end. */
-- 
1.7.8

