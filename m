Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0IINu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:50:56 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:47771 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0IINuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:50:54 -0400
Date: Thu, 9 Sep 2010 15:50:50 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
Message-ID: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Just got my 6 way machine to a state where cpu 0 is in an endless loop
within __smp_call_function_single.
All other cpus are idle.

The call trace on cpu 0 looks like this:

__smp_call_function_single
scheduler_tick
update_process_times
tick_sched_timer
__run_hrtimer
hrtimer_interrupt
clock_comparator_work
do_extint
ext_int_handler
----> timer irq
cpu_idle

__smp_call_function_single got called from nohz_balancer_kick (inlined)
with the remote cpu being 1, wait being 0 and the per cpu variable
remote_sched_softirq_cb (call_single_data) of the current cpu (0).

Then it loops forever when it tries to grab the lock of the
call_single_data, since it is already locked and enqueued on cpu 0.

My theory how this could have happened: for some reason the scheduler
decided to call __smp_call_function_single on it's own cpu, and sends
an IPI to itself. The interrupt stays pending since IRQs are disabled.
If then the hypervisor schedules the cpu away it might happen that upon
rescheduling both the IPI and the timer IRQ are pending.
If then interrupts are enabled again it depends which one gets scheduled
first.
If the timer interrupt gets delivered first we end up with the local
deadlock as seen in the calltrace above.

Let's make __smp_call_function_single check if the target cpu is the
current cpu and execute the function immediately just like
smp_call_function_single does. That should prevent at least the
scenario described here.

It might also be that the scheduler is not supposed to call
__smp_call_function_single with the remote cpu being the current cpu,
but that is a different issue.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/smp.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 75c970c..f1427d8 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -376,8 +376,10 @@ EXPORT_SYMBOL_GPL(smp_call_function_any);
 void __smp_call_function_single(int cpu, struct call_single_data *data,
 				int wait)
 {
-	csd_lock(data);
+	unsigned int this_cpu;
+	unsigned long flags;
 
+	this_cpu = get_cpu();
 	/*
 	 * Can deadlock when called with interrupts disabled.
 	 * We allow cpu's that are not yet online though, as no one else can
@@ -387,7 +389,15 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
 	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
 		     && !oops_in_progress);
 
-	generic_exec_single(cpu, data, wait);
+	if (cpu == this_cpu) {
+		local_irq_save(flags);
+		data->func(data->info);
+		local_irq_restore(flags);
+	} else {
+		csd_lock(data);
+		generic_exec_single(cpu, data, wait);
+	}
+	put_cpu();
 }
 
 /**
