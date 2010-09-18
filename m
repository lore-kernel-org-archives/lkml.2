Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab0IRTIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:08:17 -0400
Received: from kroah.org ([198.145.64.141]:51859 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab0IRTCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:25 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:02 2010
Message-Id: <20100918190002.336066740@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Anton Blanchard <anton@samba.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>, Mike Galbraith <efault@gmx.de>
Subject: [111/123] sched: cpuacct: Use bigger percpu counter batch values for stats counters
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

commit fa535a77bd3fa32b9215ba375d6a202fe73e1dd6 upstream

When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are
enabled we can call cpuacct_update_stats with values much larger
than percpu_counter_batch.  This means the call to
percpu_counter_add will always add to the global count which is
protected by a spinlock and we end up with a global spinlock in
the scheduler.

Based on an idea by KOSAKI Motohiro, this patch scales the batch
value by cputime_one_jiffy such that we have the same batch
limit as we would if CONFIG_VIRT_CPU_ACCOUNTING was disabled.
His patch did this once at boot but that initialisation happened
too early on PowerPC (before time_init) and it was never updated
at runtime as a result of a hotplug cpu add/remove.

This patch instead scales percpu_counter_batch by
cputime_one_jiffy at runtime, which keeps the batch correct even
after cpu hotplug operations.  We cap it at INT_MAX in case of
overflow.

For architectures that do not support
CONFIG_VIRT_CPU_ACCOUNTING, cputime_one_jiffy is the constant 1
and gcc is smart enough to optimise min(s32
percpu_counter_batch, INT_MAX) to just percpu_counter_batch at
least on x86 and PowerPC.  So there is no need to add an #ifdef.

On a 64 thread PowerPC box with CONFIG_VIRT_CPU_ACCOUNTING and
CONFIG_CGROUP_CPUACCT enabled, a context switch microbenchmark
is 234x faster and almost matches a CONFIG_CGROUP_CPUACCT
disabled kernel:

 CONFIG_CGROUP_CPUACCT disabled:   16906698 ctx switches/sec
 CONFIG_CGROUP_CPUACCT enabled:       61720 ctx switches/sec
 CONFIG_CGROUP_CPUACCT + patch:	   16663217 ctx switches/sec

Tested with:

 wget http://ozlabs.org/~anton/junkcode/context_switch.c
 make context_switch
 for i in `seq 0 63`; do taskset -c $i ./context_switch & done
 vmstat 1

Signed-off-by: Anton Blanchard <anton@samba.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -10934,12 +10934,30 @@ static void cpuacct_charge(struct task_s
 }
 
 /*
+ * When CONFIG_VIRT_CPU_ACCOUNTING is enabled one jiffy can be very large
+ * in cputime_t units. As a result, cpuacct_update_stats calls
+ * percpu_counter_add with values large enough to always overflow the
+ * per cpu batch limit causing bad SMP scalability.
+ *
+ * To fix this we scale percpu_counter_batch by cputime_one_jiffy so we
+ * batch the same amount of time with CONFIG_VIRT_CPU_ACCOUNTING disabled
+ * and enabled. We cap it at INT_MAX which is the largest allowed batch value.
+ */
+#ifdef CONFIG_SMP
+#define CPUACCT_BATCH	\
+	min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX)
+#else
+#define CPUACCT_BATCH	0
+#endif
+
+/*
  * Charge the system/user time to the task's accounting group.
  */
 static void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val)
 {
 	struct cpuacct *ca;
+	int batch = CPUACCT_BATCH;
 
 	if (unlikely(!cpuacct_subsys.active))
 		return;
@@ -10948,7 +10966,7 @@ static void cpuacct_update_stats(struct
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, batch);
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();


