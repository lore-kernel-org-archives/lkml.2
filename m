Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab1FIWt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:49:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:8102 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab1FIWt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:49:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="12238284"
Subject: Re: [patch v2 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20110609095450.GC11773@htj.dyndns.org>
References: <20110607201411.791585562@sbsiddha-MOBL3.sc.intel.com>
	 <20110607201425.083758186@sbsiddha-MOBL3.sc.intel.com>
	 <20110609095450.GC11773@htj.dyndns.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 09 Jun 2011 15:50:02 -0700
Message-Id: <1307659802.2679.289.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 02:54 -0700, Tejun Heo wrote:
> First of all, I agree this is the correct thing to do but I don't
> agree with some of the details.  Also, this is slightly scary for
> -stable.  Maybe we should opt for something less intrusive for
> -stable?

Probably you noticed on the suse bug that I first proposed a simple non
intrusive patch to address this problem, before actually posting these
two complete patches. I am ok in pushing that simple patch (which is
appended below to this thread) for -stable and consider these two
patches for mainline.  Ingo, HPA, if we go that route, drop the -stable
tag from the v3 version of the patches.

But I do think these two patches are not that complex and if they are
good for mainline, they should be good aswell for -stable. Anyways I am
open either way (and appended the stable only patch in the end).

> 
> > +/**
> > + * __stop_cpus - stop multiple cpus
> > + * @cpumask: cpus to stop
> > + * @fn: function to execute
> > + * @arg: argument to @fn
> > + *
> > + * Execute @fn(@arg) on online cpus in @cpumask. If @cpumask is NULL, @fn
> > + * is run on all the online cpus including the current cpu (even if it
> > + * is not online).
> > + * On each target cpu, @fn is run in a process context (except when run on
> > + * the cpu that is in the process of coming online, in which case @fn is run
> > + * in the same context as __stop_cpus()) with the highest priority
> > + * preempting any task on the cpu and monopolizing it.  This function
> > + * returns after all executions are complete.
> > + */
> 
> It's minor but can you please follow the comment style in the same
> file?  ie. Blank line between paragraphs, separate CONTEXT: and
> RETURNS: sections.  At the second thought, why is this function even
> exported?  It doesn't seem to have any out-of-file user left.  Maybe
> best to make it static?

Made it static in v3.


> >  int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
> >  {
> > +	int online = percpu_read(cpu_stopper.enabled);
> > +	int include_this_offline = 0;
> >  	struct cpu_stop_work *work;
> >  	struct cpu_stop_done done;
> > +	unsigned int weight;
> >  	unsigned int cpu;
> >  
> > +	if (!cpumask) {
> > +		cpumask = cpu_online_mask;
> > +		include_this_offline = 1;
> > +	}
> 
> This seems a bit too subtle.  I would much prefer if it were much more
> explicit than using non-obvious combination of conditions to trigger
> this special behavior.

I first used cpu_callout_mask when I did the patches. But that is not
available for generic code. And ended up using NULL mask.

But v3 code uses cpu_all_mask, that should cleanup all this code.

> 
> Hmm... Wouldn't it be better to change cpu_stop_queue_work() consider
> whether the local CPU is offline and then add cpu_stop_wait_done()
> which does wait_for_completion() if local is online and otherwise
> execute fn locally, call cpu_stop_signal_done() and wait in busy loop?
> 
> That would make the whole thing much more generic and easier to
> describe.  The current implementation seems quite hacky/subtle and
> doesn't fit well with the rest.  It would be much better if we can
> just state "if used from local CPU which is not online and the target
> @cpumask includes the local CPU, the work item is executed on-stack
> and completion is waited in busy-loop" for all cpu_stop functions.

Did these changes in v3.

> 
> Also, it would be better to factor out work item execution and
> completion from cpu_stopper_thread() and call that instead of invoking
> fn(arg) directly.
> 

I was not sure if it was the right thing to call cpu_stopper_thread()
which was doing set_current_state() etc from an arbitrary context. I
don't see the point. Please review v3 and let me know if I missed
anything.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
To: stable@kernel.org
Subject: [stable only 2.6.35 - 2.6.39] x86, mtrr: lock stop machine during MTRR rendezvous sequence

MTRR rendezvous seqeuence using stop_one_cpu_nowait() can potentially
happen in parallel with another system wide rendezvous using
stop_machine(). This can lead to deadlock (The order in which
works are queued can be different on different cpu's. Some cpu's
will be running the first rendezvous handler and others will be running
the second rendezvous handler. Each set waiting for the other set to join
for the system wide rendezvous, leading to a deadlock).

MTRR rendezvous sequence is not implemened using stop_machine() as this
gets called both from the process context aswell as the cpu online paths
(where the cpu has not come online and the interrupts are disabled etc).
stop_machine() works with only online cpus.

For now, take the stop_machine mutex in the MTRR rendezvous sequence that
gets called from an online cpu (here we are in the process context
and can potentially sleep while taking the mutex). And the MTRR rendezvous
that gets triggered during cpu online doesn't need to take this stop_machine
lock (as the stop_machine() already ensures that there is no cpu hotplug
going on in parallel by doing get_online_cpus())

For mainline, we will pursue a cleaner solution of extending the stop_machine()
infrastructure to handle the case where the calling cpu is still not online and
use this for MTRR rendezvous sequence.

fixes: https://bugzilla.novell.com/show_bug.cgi?id=672008

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org    # v2.6.35 - v2.6.39
---
 arch/x86/kernel/cpu/mtrr/main.c |   16 +++++++++++++++-
 include/linux/stop_machine.h    |   11 +++++++++++
 kernel/stop_machine.c           |   10 ++++++++++
 3 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 929739a..eb06b5f 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -244,9 +244,21 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2)
 static void
 set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type type)
 {
+	int cpu = raw_smp_processor_id();
+	int online = cpu_online(cpu);
 	struct set_mtrr_data data;
 	unsigned long flags;
-	int cpu;
+
+	/*
+	 * If we are not yet online, then there can be no stop_machine() in
+	 * parallel. Stop machine ensures that there is no CPU hotplug
+	 * happening in parallel by using get_online_cpus().
+	 *
+	 * Otherwise, we need to prevent a stop_machine() happening in parallel
+	 * by taking this lock.
+	 */
+	if (online)
+		lock_stop_cpus();
 
 	preempt_disable();
 
@@ -330,6 +342,8 @@ set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type typ
 
 	local_irq_restore(flags);
 	preempt_enable();
+	if (online)
+		unlock_stop_cpus();
 }
 
 /**
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 092dc9b..caacea9 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -33,6 +33,9 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 int stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
 int try_stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
 
+void lock_stop_cpus(void);
+void unlock_stop_cpus(void);
+
 #else	/* CONFIG_SMP */
 
 #include <linux/workqueue.h>
@@ -88,6 +91,14 @@ static inline int try_stop_cpus(const struct cpumask *cpumask,
 	return stop_cpus(cpumask, fn, arg);
 }
 
+static inline void lock_stop_cpus(void)
+{
+}
+
+static inline void unlock_stop_cpus(void)
+{
+}
+
 #endif	/* CONFIG_SMP */
 
 /*
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e3516b2..abbe6e7 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -136,6 +136,16 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
+void lock_stop_cpus(void)
+{
+	mutex_lock(&stop_cpus_mutex);
+}
+
+void unlock_stop_cpus(void)
+{
+	mutex_unlock(&stop_cpus_mutex);
+}
+
 int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 {
 	struct cpu_stop_work *work;


