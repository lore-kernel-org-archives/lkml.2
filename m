Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965637Ab2FBS63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 14:58:29 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51873 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965424Ab2FBS62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 14:58:28 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] sched/cpu hotplug: Don't traverse sched domain tree of cpus
 going offline
To: a.p.zijlstra@chello.nl, mingo@kernel.org
Cc: pjt@google.com, suresh.b.siddha@intel.com, seto.hidetoshi@jp.fujitsu.com,
        rostedt@goodmis.org, tglx@linutronix.de, dhillf@gmail.com, rjw@sisk.pl,
        linux-kernel@vger.kernel.org
Date: Sun, 03 Jun 2012 00:27:21 +0530
Message-ID: <20120602185721.5559.65562.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060218-3864-0000-0000-00000328FABE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu_active_mask is used to help the scheduler make the right decisions
during CPU hotplug transitions, and thereby enable CPU hotplug operations to
run smoothly.

However there are a few places where the scheduler doesn't consult the
cpu_active_mask and hence can trip over during CPU hotplug operations, by
making decisions based on stale data structures.

In particular, the call to partition_sched_domains() in the CPU offline path
sets cpu_rq(dying_cpu)->sd (sched domain pointer) to NULL. However, until
we get to that point, it remains non-NULL. And during that time period,
the scheduler could end up traversing that non-NULL sched domain tree and
making decisions based on that, which could lead to undesirable consequences.

For example, commit 8f2f748 (CPU hotplug, cpusets, suspend: Don't touch
cpusets during suspend/resume) caused suspend hangs at the CPU hotplug stage,
in some configurations. And the root-cause of that hang was that the
scheduler was traversing the sched domain trees of cpus going offline, thereby
messing up its decisions. The analysis of that hang can be found in:
http://marc.info/?l=linux-kernel&m=133518704022532&w=4

In short, our assumption that we are good to go (even with stale sched
domains) as long as the dying cpu was not in the cpu_active_mask, was wrong.
Because, there are several places where the scheduler code doesn't really
check the cpu_active_mask, but instead traverses the sched domains directly
to do stuff.

Anyway, that commit got reverted. However, that same problem could very well
occur during regular CPU hotplug too, even now. Ideally, we would want the
scheduler to make all its decisions during the CPU hotplug transition, by
looking up the cpu_active_mask (which is updated very early during CPU
Hotplug) to avoid such disasters. So, strengthen the scheduler by making it
consult the cpu_active_mask as a validity check before traversing the sched
domain tree.

Here we are specifically fixing the 2 known instances: idle_balance() and
find_lowest_rq().

1. kernel/sched/core.c and fair.c:
   schedule()
	__schedule()
		idle_balance()

idle_balance() can end up doing:

for_each_domain(dying_cpu, sd) {
	...
}

2. kernel/sched/core.c and rt.c:

migration_call()
	sched_ttwu_pending()
		ttwu_do_activate()
			ttwu_do_wakeup()
				task_woken()
					task_woken_rt()
						push_rt_tasks()
							find_lowest_rq()

find_lowest_rq() can end up doing:

for_each_domain(dying_cpu, sd) {
	...
}

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |    5 +++++
 kernel/sched/rt.c   |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 940e6d1..72cc7c6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4402,6 +4402,10 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	raw_spin_unlock(&this_rq->lock);
 
 	update_shares(this_cpu);
+
+	if (!cpu_active(this_cpu))
+		goto out;
+
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -4426,6 +4430,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	}
 	rcu_read_unlock();
 
+ out:
 	raw_spin_lock(&this_rq->lock);
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c5565c3..8cbafcd 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1488,6 +1488,9 @@ static int find_lowest_rq(struct task_struct *task)
 	if (!cpumask_test_cpu(this_cpu, lowest_mask))
 		this_cpu = -1; /* Skip this_cpu opt if not among lowest */
 
+	if (!cpu_active(cpu))
+		goto out;
+
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		if (sd->flags & SD_WAKE_AFFINE) {
@@ -1513,6 +1516,7 @@ static int find_lowest_rq(struct task_struct *task)
 	}
 	rcu_read_unlock();
 
+ out:
 	/*
 	 * And finally, if there were no matches within the domains
 	 * just give the caller *something* to work with from the compatible

