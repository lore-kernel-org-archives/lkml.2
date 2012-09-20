Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2ITADW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 20:03:22 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57259 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab2ITADU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 20:03:20 -0400
Date: Wed, 19 Sep 2012 17:03:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: RCU lockup in the SMP idle thread, help...
Message-ID: <20120920000313.GH2455@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CACRpkdYgxsF1G7Dc_xCcQcFV9G+foz1czOCmROcMQ5NfR-ziCA@mail.gmail.com>
 <50520E8A.9030408@linaro.org>
 <20120913165844.GW4257@linux.vnet.ibm.com>
 <CACRpkdatjfk_eUof5G4fwa-Qf8SoF_NvSUJQAZ7U8yjcSYFuTA@mail.gmail.com>
 <20120914175322.GI4257@linux.vnet.ibm.com>
 <CACRpkdbw+VgaV26U6uZeKr9g28ax2shrieQSxFuj-Pi9RXPtLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbw+VgaV26U6uZeKr9g28ax2shrieQSxFuj-Pi9RXPtLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092000-7182-0000-0000-000002A9767F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 11:10:30AM +0200, Linus Walleij wrote:
> On Fri, Sep 14, 2012 at 7:53 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Could you please try reproducing with CONFIG_RCU_CPU_STALL_INFO=y?
> 
> Yep: looks like this:
> 
> INFO: rcu_preempt detected stalls on CPUs/tasks:
>         0: (0 ticks this GP) idle=458/0/0
>         (detected by 1, t=29904 jiffies)
> [<c0014710>] (unwind_backtrace+0x0/0xf8) from [<c00687dc>]
> (rcu_check_callbacks+0x6f8/0x730)
> [<c00687dc>] (rcu_check_callbacks+0x6f8/0x730) from [<c0029cbc>]
> (update_process_times+0x38/0x4c)
> [<c0029cbc>] (update_process_times+0x38/0x4c) from [<c0055088>]
> (tick_sched_timer+0x80/0xe4)
> [<c0055088>] (tick_sched_timer+0x80/0xe4) from [<c003c120>]
> (__run_hrtimer.isra.18+0x44/0xd0)
> [<c003c120>] (__run_hrtimer.isra.18+0x44/0xd0) from [<c003cae0>]
> (hrtimer_interrupt+0x118/0x2b4)
> [<c003cae0>] (hrtimer_interrupt+0x118/0x2b4) from [<c0013658>]
> (twd_handler+0x30/0x44)
> [<c0013658>] (twd_handler+0x30/0x44) from [<c00638c8>]
> (handle_percpu_devid_irq+0x80/0xa0)
> [<c00638c8>] (handle_percpu_devid_irq+0x80/0xa0) from [<c00603b8>]
> (generic_handle_irq+0x20/0x30)
> [<c00603b8>] (generic_handle_irq+0x20/0x30) from [<c000ef58>]
> (handle_IRQ+0x4c/0xac)
> [<c000ef58>] (handle_IRQ+0x4c/0xac) from [<c00084bc>] (gic_handle_irq+0x24/0x58)
> [<c00084bc>] (gic_handle_irq+0x24/0x58) from [<c000dc80>] (__irq_svc+0x40/0x70)
> Exception stack(0xcf865f88 to 0xcf865fd0)
> 5f80:                   00000020 c05c0a20 00000001 00000000 cf864000 cf864000
> 5fa0: c05dfe48 c02de0b4 c05c3e90 412fc091 cf864000 00000000 01000000 cf865fd0
> 5fc0: c000f234 c000f238 60000013 ffffffff
> [<c000dc80>] (__irq_svc+0x40/0x70) from [<c000f238>] (default_idle+0x28/0x30)
> [<c000f238>] (default_idle+0x28/0x30) from [<c000f438>] (cpu_idle+0x98/0xe4)
> [<c000f438>] (cpu_idle+0x98/0xe4) from [<002d3114>] (0x2d3114)

Ah!!!  If I understand correctly, ARM does not implement the NMI-based
trigger_all_cpu_backtrace() facility that RCU uses to get stack backtraces
out of all CPUs.  In this case, trigger_all_cpu_backtrace() returns
failure, so RCU falls back to dumping a stack trace of the current CPU,
which in this case is CPU 1.  Unfortunately, this stack backtrace says
nothing about the state of CPU 0, which is the one that is stalling.

So, yes, CPU 1 was interrupted out of idle, but it was CPU 0 that was
responsible for the stall.

I could hack together something that used IPIs to get the backtrace, but
this is unlikely to work.  The thing is that RCU waits an additional
two jiffies before allowing a CPU to complain about some other CPU's
stall.  This means that unless CPU 0 halted the scheduling-clock
interrupt, the most likely failure mode is that CPU 0 was spinning
with interrupts disabled, which would render IPIs ineffective.  Which is
why trigger_all_cpu_backtrace() uses NMIs.

Any thoughts on the feasibility of implementing NMI-based stack backtraces
for ARM?

In the meantime, a crude fallback is for the CPU that detected the stall
to trace the stack of the task running on the other CPU.  See below for
a crude (and untested) patch.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Print remote CPU's stacks in stall warnings

The RCU CPU stall warnings rely on trigger_all_cpu_backtrace() to
do NMI-based dump of the stack traces of all CPUs.  Unfortunately, a
number of architectures do not implement trigger_all_cpu_backtrace(), in
which case RCU falls back to just dumping the stack of the running CPU.
This is unhelpful in the case where the running CPU has detected that
some other CPU has stalled.

This commit therefore makes the running CPU dump the stacks of the
tasks running on the stalled CPUs.

Not-yet-signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cdaeeff..02df81a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -149,6 +149,8 @@ extern void update_cpu_load_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
+extern void dump_cpu_task(int cpu);
+
 struct seq_file;
 struct cfs_rq;
 struct task_group;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6eff63d..ea42da1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -851,6 +851,29 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
 }
 
+/*
+ * Dump stacks of all tasks running on stalled CPUs.  This is a fallback
+ * for architectures that do not implement trigger_all_cpu_backtrace().
+ * The NMI-triggered stack traces are more accurate because they are
+ * printed by the target CPU.
+ */
+static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
+{
+	int cpu;
+	unsigned long flags;
+	struct rcu_node *rnp;
+
+	rcu_for_each_leaf_node(rsp, rnp) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		if (rnp->qsmask != 0) {
+			for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
+				if (rnp->qsmask & (1UL << cpu))
+					dump_cpu_task(rnp->grplo + cpu);
+		}
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+}
+
 static void print_other_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
@@ -907,7 +930,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	if (ndetected == 0)
 		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
-		dump_stack();
+		rcu_dump_cpu_stacks(rsp);
 
 	/* Complain about tasks blocking the grace period. */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ce685da..b5c27a7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8610,3 +8610,9 @@ struct cgroup_subsys cpuacct_subsys = {
 	.base_cftypes = files,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+void dump_cpu_task(int cpu)
+{
+	pr_info("Task dump for CPU %d:\n", cpu);
+	sched_show_task(cpu_curr(cpu));
+}

