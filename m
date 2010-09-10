Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0IJPsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:48:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:46982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0IJPsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:48:16 -0400
Date: Fri, 10 Sep 2010 15:47:37 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, jaxboe@fusionio.com,
        mingo@elte.hu, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, jaxboe@fusionio.com,
        mingo@elte.hu, venki@google.com
In-Reply-To: <20100910114729.GB2827@osiris.boeblingen.de.ibm.com>
References: <20100910114729.GB2827@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] generic-ipi: Fix deadlock in __smp_call_function_single
Message-ID: <tip-27c379f7f89a4d558c685b5d89b5ba2fe79ae701@git.kernel.org>
Git-Commit-ID: 27c379f7f89a4d558c685b5d89b5ba2fe79ae701
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 15:47:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27c379f7f89a4d558c685b5d89b5ba2fe79ae701
Gitweb:     http://git.kernel.org/tip/27c379f7f89a4d558c685b5d89b5ba2fe79ae701
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Fri, 10 Sep 2010 13:47:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Sep 2010 16:48:40 +0200

generic-ipi: Fix deadlock in __smp_call_function_single

Just got my 6 way machine to a state where cpu 0 is in an
endless loop within __smp_call_function_single.
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

__smp_call_function_single() got called from nohz_balancer_kick()
(inlined) with the remote cpu being 1, wait being 0 and the per
cpu variable remote_sched_softirq_cb (call_single_data) of the
current cpu (0).

Then it loops forever when it tries to grab the lock of the
call_single_data, since it is already locked and enqueued on cpu 0.

My theory how this could have happened: for some reason the
scheduler decided to call __smp_call_function_single() on it's own
cpu, and sends an IPI to itself. The interrupt stays pending
since IRQs are disabled. If then the hypervisor schedules the
cpu away it might happen that upon rescheduling both the IPI and
the timer IRQ are pending. If then interrupts are enabled again
it depends which one gets scheduled first.
If the timer interrupt gets delivered first we end up with the
local deadlock as seen in the calltrace above.

Let's make __smp_call_function_single() check if the target cpu is
the current cpu and execute the function immediately just like
smp_call_function_single does. That should prevent at least the
scenario described here.

It might also be that the scheduler is not supposed to call
__smp_call_function_single with the remote cpu being the current
cpu, but that is a different issue.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jens Axboe <jaxboe@fusionio.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100910114729.GB2827@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/smp.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 75c970c..ed6aacf 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -365,9 +365,10 @@ call:
 EXPORT_SYMBOL_GPL(smp_call_function_any);
 
 /**
- * __smp_call_function_single(): Run a function on another CPU
+ * __smp_call_function_single(): Run a function on a specific CPU
  * @cpu: The CPU to run on.
  * @data: Pre-allocated and setup data structure
+ * @wait: If true, wait until function has completed on specified CPU.
  *
  * Like smp_call_function_single(), but allow caller to pass in a
  * pre-allocated data structure. Useful for embedding @data inside
@@ -376,8 +377,10 @@ EXPORT_SYMBOL_GPL(smp_call_function_any);
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
@@ -387,7 +390,15 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
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
