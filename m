Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2CMEpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:45:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35143 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2CMEpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:45:39 -0400
Date: Mon, 12 Mar 2012 21:45:08 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-5fbd036b552f633abb394a319f7c62a5c86a9cd7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, stepanm@codeaurora.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stepanm@codeaurora.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323965362.18942.71.camel@twins>
References: <1323965362.18942.71.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Cleanup cpu_active madness
Git-Commit-ID: 5fbd036b552f633abb394a319f7c62a5c86a9cd7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:45:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5fbd036b552f633abb394a319f7c62a5c86a9cd7
Gitweb:     http://git.kernel.org/tip/5fbd036b552f633abb394a319f7c62a5c86a9cd7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 15 Dec 2011 17:09:22 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:43:15 +0100

sched: Cleanup cpu_active madness

Stepan found:

CPU0		CPUn

_cpu_up()
  __cpu_up()

		boostrap()
		  notify_cpu_starting()
		  set_cpu_online()
		  while (!cpu_active())
		    cpu_relax()

<PREEMPT-out>

smp_call_function(.wait=1)
  /* we find cpu_online() is true */
  arch_send_call_function_ipi_mask()

  /* wait-forever-more */

<PREEMPT-in>
		  local_irq_enable()

  cpu_notify(CPU_ONLINE)
    sched_cpu_active()
      set_cpu_active()

Now the purpose of cpu_active is mostly with bringing down a cpu, where
we mark it !active to avoid the load-balancer from moving tasks to it
while we tear down the cpu. This is required because we only update the
sched_domain tree after we brought the cpu-down. And this is needed so
that some tasks can still run while we bring it down, we just don't want
new tasks to appear.

On cpu-up however the sched_domain tree doesn't yet include the new cpu,
so its invisible to the load-balancer, regardless of the active state.
So instead of setting the active state after we boot the new cpu (and
consequently having to wait for it before enabling interrupts) set the
cpu active before we set it online and avoid the whole mess.

Reported-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1323965362.18942.71.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/smp.c     |    7 -------
 arch/hexagon/kernel/smp.c |    2 --
 arch/s390/kernel/smp.c    |    6 ------
 arch/x86/kernel/smpboot.c |   13 -------------
 kernel/sched/core.c       |    2 +-
 5 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index cdeb727..d616ed5 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -295,13 +295,6 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	 */
 	percpu_timer_setup();
 
-	while (!cpu_active(cpu))
-		cpu_relax();
-
-	/*
-	 * cpu_active bit is set, so it's safe to enalbe interrupts
-	 * now.
-	 */
 	local_irq_enable();
 	local_fiq_enable();
 
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index c871a2c..0123c63 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -179,8 +179,6 @@ void __cpuinit start_secondary(void)
 	printk(KERN_INFO "%s cpu %d\n", __func__, current_thread_info()->cpu);
 
 	set_cpu_online(cpu, true);
-	while (!cpumask_test_cpu(cpu, cpu_active_mask))
-		cpu_relax();
 	local_irq_enable();
 
 	cpu_idle();
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 2398ce6..b0e28c4 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -550,12 +550,6 @@ int __cpuinit start_secondary(void *cpuvoid)
 	S390_lowcore.restart_psw.addr =
 		PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
 	__ctl_set_bit(0, 28); /* Enable lowcore protection */
-	/*
-	 * Wait until the cpu which brought this one up marked it
-	 * active before enabling interrupts.
-	 */
-	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
-		cpu_relax();
 	local_irq_enable();
 	/* cpu_idle will call schedule for us */
 	cpu_idle();
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..58f7816 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -291,19 +291,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
-	/*
-	 * Wait until the cpu which brought this one up marked it
-	 * online before enabling interrupts. If we don't do that then
-	 * we can end up waking up the softirq thread before this cpu
-	 * reached the active state, which makes the scheduler unhappy
-	 * and schedule the softirq thread on the wrong cpu. This is
-	 * only observable with forced threaded interrupts, but in
-	 * theory it could also happen w/o them. It's just way harder
-	 * to achieve.
-	 */
-	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
-		cpu_relax();
-
 	/* enable local interrupts */
 	local_irq_enable();
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9554512..b1ccce8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5410,7 +5410,7 @@ static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_ONLINE:
+	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
