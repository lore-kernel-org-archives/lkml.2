Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab0JAOUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:20:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49320 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0JAOUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZsfbcU+aegayw14FaT4DDSPEyAg7QQ98XJEHg7M8H7TEc1QOiV3cdw0Em42Ba9XhRO
         FXWM1EewFerM1p3awDkrLGJoYFRJd97OdHVeFIw+Za6mFkoDj3/FDFT9wambssc/zLPE
         +U10XlM6Cuo89LU5ncXbSwH71n1OahKK8fxxc=
Date: Fri, 1 Oct 2010 16:20:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Wu, Xia" <xia.wu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhu, Daniel" <daniel.zhu@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: unnecessary timer interrupt of slab.c and bdi tasks when the
	system is in sleep state
Message-ID: <20101001141932.GA5467@nowhere>
References: <A24AE1FFE7AEC5489F83450EE98351BF221878E0FB@shsmsx502.ccr.corp.intel.com> <alpine.DEB.2.00.1009300908050.27201@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009300908050.27201@router.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 09:13:02AM -0500, Christoph Lameter wrote:
> On Thu, 30 Sep 2010, Wu, Xia wrote:
> 
> > I found some unnecessary timer interrupts when the system enter sleep state.
> > (1)     /mm/slab.c
> > cache_reap() clean up on allocated memory every 2s. If the system is in sleep state, the system is waked-up when this timer expires. In fact,
> > there isn't more slabs to been cleaned up in sleep state.
> 
> Right. We could switch off the timer when idle without much of an issue.
> The expiration of the caches wont occur and so we will have stale objects
> on the queues when we exit sleep state. You could flush the queues before
> switching off the timers?


May be flushing the queue everytime we enter nohz is too much, as that can
happen very often?

Another idea would be to disarm the scheduled work if it is the next timer
that will exit nohz and then in this case schedule it right now instead,
before entering idle.

Otherwise if this timer is after the time nohz will exit (ie: there is another
timer before), then we don't care, and that should probably cover most cases.

But we really need a quick way to know if cache_reap() is needed at any time,
this is really what we lack, so that we even further optimize with such state
machine:

enter nohz:

* cache reap not needed? just cancel the delayed work
* cache_reap needed and this is the timer that will wake up
  nohz? cancel the timer and schedule the work right now.
* otherwise don't change anything

exit_nohz:

* work was cancelled? reschedule it.


But for that we need a kind of need_cache_reap() that I'm not sure how
to implement as I don't know much the slab code.

Does that sound silly?

Here is how that could look like (untested, since that requires need_cache_reap()):


diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index b2f1a4d..34f2935 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -277,5 +277,13 @@ extern struct blocking_notifier_head reboot_notifier_list;
 #define VT_UPDATE		0x0004 /* A bigger update occurred */
 #define VT_PREWRITE		0x0005 /* A char is about to be written to the console */
 
+/* Dyntick events */
+#define NOHZ_ENTER_PREPARE	0x0001 /*
+					* Still have a chance here to wake up a task
+					* or change a timer state
+					*/
+#define NOHZ_ENTER		0x0002
+#define NOHZ_EXIT		0x0003
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..f4998cf 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -7,6 +7,7 @@
 #define _LINUX_TICK_H
 
 #include <linux/clockchips.h>
+#include <linux/notifier.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -121,12 +122,17 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
+extern int register_nohz_notifier(struct notifier_block *nb);
 extern void tick_nohz_stop_sched_tick(int inidle);
 extern void tick_nohz_restart_sched_tick(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
+static inline int register_nohz_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
 static inline ktime_t tick_nohz_get_sleep_length(void)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..7b0f5e0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -248,6 +248,24 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
+
+static RAW_NOTIFIER_HEAD(nohz_chain);
+
+int register_nohz_notifier(struct notifier_block *nb)
+{
+	return raw_notifier_chain_register(&nohz_chain, nb);
+}
+
+static int nohz_notify(unsigned long val, void *arg)
+{
+	int ret;
+
+	ret = __raw_notifier_call_chain(&nohz_chain, val, arg,
+					-1, NULL);
+
+	return notifier_to_errno(ret);
+}
+
 /**
  * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
  *
@@ -262,7 +280,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
-	int cpu;
+	int cpu, err;
 
 	local_irq_save(flags);
 
@@ -324,21 +342,29 @@ void tick_nohz_stop_sched_tick(int inidle)
 		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&xtime_lock, seq));
 
-	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
-		next_jiffies = last_jiffies + 1;
-		delta_jiffies = 1;
-	} else {
-		/* Get the next timer wheel timer */
-		next_jiffies = get_next_timer_interrupt(last_jiffies);
-		delta_jiffies = next_jiffies - last_jiffies;
-	}
-	/*
-	 * Do not stop the tick, if we are only one off
-	 * or if the cpu is required for rcu
-	 */
-	if (!ts->tick_stopped && delta_jiffies == 1)
-		goto out;
+	do {
+		if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
+		    arch_needs_cpu(cpu)) {
+			next_jiffies = last_jiffies + 1;
+			delta_jiffies = 1;
+		} else {
+			/* Get the next timer wheel timer */
+			next_jiffies = get_next_timer_interrupt(last_jiffies);
+			delta_jiffies = next_jiffies - last_jiffies;
+		}
+		/*
+		 * Do not stop the tick, if we are only one off
+		 * or if the cpu is required for rcu
+		 */
+		if (!ts->tick_stopped && delta_jiffies == 1)
+			goto out;
+
+		err = nohz_notify(NOHZ_ENTER_PREPARE, &next_jiffies);
+
+	} while (err == -EAGAIN));
+
+	if (err)
+		goto end;
 
 	/* Schedule the tick, if we are at least one jiffie off */
 	if ((long)delta_jiffies >= 1) {
@@ -410,6 +436,8 @@ void tick_nohz_stop_sched_tick(int inidle)
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
+
+			nohz_notify(NOHZ_ENTER, cpu);
 			rcu_enter_nohz();
 		}
 
@@ -521,6 +549,7 @@ void tick_nohz_restart_sched_tick(void)
 	ts->inidle = 0;
 
 	rcu_exit_nohz();
+	nohz_notify(NOHZ_EXIT, cpu);
 
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
diff --git a/mm/slab.c b/mm/slab.c
index fcae981..662a341 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -115,6 +115,7 @@
 #include	<linux/debugobjects.h>
 #include	<linux/kmemcheck.h>
 #include	<linux/memory.h>
+#include	<linux/tick.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -1323,10 +1324,64 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
 	return notifier_from_errno(err);
 }
 
-static struct notifier_block __cpuinitdata cpucache_notifier = {
+static struct notifier_block __cpuinitdata cpucache_cpu_notifier = {
 	&cpuup_callback, NULL, 0
 };
 
+#ifdef CONFIG_NO_HZ
+static int nohz_callback(struct notifier_block *nfb,
+			 unsigned long action, void *arg)
+{
+	struct delayed_work *work = &__get_cpu_var(slab_reap_work, cpu);
+	int err = 0;
+
+	switch (action) {
+	case NOHZ_ENTER_PREPARE:
+		unsigned long nohz_exit = (unsigned long)arg;
+
+		if (!delayed_work_pending(work))
+			goto end;
+
+		/*
+		 * Nothing to flush. Cancel the work and force
+		 * tick_nohz_stop_sched_tick to re-find
+		 * the next timer interrupt.
+		 *
+		 * need_cache_reap() has yet to be implemented :-)
+		 */
+		if (!need_cache_reap(smp_processor_id())) {
+			cancel_delayed_work(work);
+			err = -EAGAIN;
+			goto end;
+		}
+
+		/*
+		 * Something to flush and the next timer is _likely_ us.
+		 * Cancel nohz and schedule the work right now to avoid
+		 * breaking long idle cycles.
+		 */
+		if (time_before_eq(work->timer.expires, nohz_exit)) {
+			cancel_delayed_work(work);
+			schedule_delayed_work(work, 0);
+			err = -EBUSY;
+		}
+		break;
+
+	case NOHZ_EXIT:
+		if (!delayed_work_pending(work))
+			schedule_delayed_work(work, round_jiffies_relative(REAPTIMEOUT_CPUC));
+		break;
+	}
+
+end:
+	return notifier_from_errno(0);
+}
+
+static struct notifier_block cpucache_nohz_notifier = {
+	&nohz_callback, NULL, 0
+};
+#endif
+
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
 /*
  * Drains freelist for a node on each slab cache, used for memory hot-remove.
@@ -1638,7 +1693,11 @@ void __init kmem_cache_init_late(void)
 	 * Register a cpu startup notifier callback that initializes
 	 * cpu_cache_get for all new cpus
 	 */
-	register_cpu_notifier(&cpucache_notifier);
+	register_cpu_notifier(&cpucache_cpu_notifier);
+
+#ifdef CONFIG_NO_HZ
+	register_nohz_notifier(&cpucache_nohz_notifier);
+#endif
 
 #ifdef CONFIG_NUMA
 	/*
@@ -4118,6 +4177,9 @@ static void cache_reap(struct work_struct *w)
 	int node = numa_mem_id();
 	struct delayed_work *work = to_delayed_work(w);
 
+	if (!need_cache_reap(smp_processor_id()))
+		return;
+
 	if (!mutex_trylock(&cache_chain_mutex))
 		/* Give up. Setup the next iteration. */
 		goto out;

