Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1HWT4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:56:36 -0400
Received: from relay3.sgi.com ([192.48.152.1]:50128 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755781Ab1HWT4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:56:30 -0400
Date: Tue, 23 Aug 2011 14:56:28 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20110823195628.GB4533@sgi.com>
References: <20110817160759.GA3482@sgi.com>
 <alpine.LFD.2.02.1108171819120.2807@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1108171819120.2807@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 06:47:43PM +0200, Thomas Gleixner wrote:
> On Wed, 17 Aug 2011, Dimitri Sivanich wrote:
> 
> > Reposting this, as this was posted 2 weeks ago with no replies.
> 
> It's still in my vacation backlog :)

Thanks for the prompt reply to this last one.

> 
> > Jiffies updates are currently done by the tick_do_timer_cpu.  This has a
> > non-deterministic value that can be any running cpu on the system.  It
> > changes dynamically in nohz mode.  When nohz mode is off, it gets set to
> > a more static, but still non-deterministic value.
> > 
> > While the nohz behavior is necessary, is there a reason why the nohz off
> > case can't have a specific value, say 0 as it was on earlier kernels?
> 
> Yes, we had troubles when switching over to highres/oneshot mode when
> the first cpu which did the switch did not take the do_timer duty. See
> changelogs.
> 
> > If the cpu is offlined, let the value change at that time (note that the
> > x86 arch disallows offlining cpu 0).
> > 
> > There are certain cases where this would be advantageous, especially where
> > timely jiffies updates may not necessarily occur on specific processors.
> 
> Huch? How about fixing those long interrupt disabled regions instead?
> And honestly jiffies update being delayed for a bit is not really a
> problem.
> 
> > The following sample patch presents one way that this could be done.
> > Processors wait for the selected cpu to enter high resolution mode before
> > they do so.
> 
> That's a horrible hack.

Hopefully the patch below is more tolerable.

> 
> > Note that this patch is not hotplug aware (however, should the
> > tick_static_do_timer_cpu be offlined, the tick_do_timer_cpu simply becomes
> > another cpu anyway).
> > 
> > Comments on this idea, or the sample patch?
> 
> I still have no idea why a random assignment is so harmful. Also if
> there is really a reason to make that assignment static, what about
> using a sysfs file, which lets you read out the assignment and update
> it in the NOHZ off case ?

While not necessarily harmful, doing jiffies updates on an application cpu
does cause some extra overhead that HPC benchmarking people notice.  They
prefer to have OS activity isolated to certain cpus.  They like reproducibility
of results, and having jiffies updates bouncing around introduces variability.

Maybe this is useful for other folks as well?  It does give an indication
of which cpu is currently doing jiffies updates.

The patch below puts the file in /proc/sys/kernel, but if you think it should be in
/sys, please let me know where you'd like to see it.


Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 include/linux/tick.h        |    5 +++++
 kernel/sysctl.c             |    9 +++++++++
 kernel/time/tick-internal.h |    1 -
 kernel/time/tick-sched.c    |   23 +++++++++++++++++++++++
 4 files changed, 37 insertions(+), 1 deletion(-)

Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -57,6 +57,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/kmod.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -368,6 +369,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
 	},
+	{
+		.procname	= "sched_jiffies_cpu",
+		.data		= &tick_do_timer_cpu,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= tick_do_timer_cpu_handler,
+		.extra1		= &zero,
+	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
Index: linux/include/linux/tick.h
===================================================================
--- linux.orig/include/linux/tick.h
+++ linux/include/linux/tick.h
@@ -72,6 +72,11 @@ struct tick_sched {
 extern void __init tick_init(void);
 extern int tick_is_oneshot_available(void);
 extern struct tick_device *tick_get_device(int cpu);
+extern int tick_do_timer_cpu_handler(struct ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos);
+
+extern int tick_do_timer_cpu __read_mostly;
 
 # ifdef CONFIG_HIGH_RES_TIMERS
 extern int tick_init_highres(void);
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -815,6 +815,29 @@ void tick_cancel_sched_timer(int cpu)
 }
 #endif
 
+int tick_do_timer_cpu_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret, old_val;
+
+#ifdef CONFIG_NO_HZ
+	/* nohz mode not supported */
+	if (write && tick_nohz_enabled)
+		return -EINVAL;
+#endif
+
+	old_val = tick_do_timer_cpu;
+
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (!ret && write && !cpu_online(tick_do_timer_cpu)) {
+		tick_do_timer_cpu = old_val;
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
 /**
  * Async notification about clocksource changes
  */
Index: linux/kernel/time/tick-internal.h
===================================================================
--- linux.orig/kernel/time/tick-internal.h
+++ linux/kernel/time/tick-internal.h
@@ -12,7 +12,6 @@
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern ktime_t tick_next_period;
 extern ktime_t tick_period;
-extern int tick_do_timer_cpu __read_mostly;
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
