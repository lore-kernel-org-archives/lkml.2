Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0LLXsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36786 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab0LLXsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:25 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [197/223] nohz/s390: fix arch_needs_cpu() return value on offline cpus
Message-Id: <20101212234823.92217B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 398812159e328478ae49b4bd01f0d71efea96c39 upstream.

This fixes the same problem as described in the patch "nohz: fix
printk_needs_cpu() return value on offline cpus" for the arch_needs_cpu()
primitive:

arch_needs_cpu() may return 1 if called on offline cpus. When a cpu gets
offlined it schedules the idle process which, before killing its own cpu,
will call tick_nohz_stop_sched_tick().
That function in turn will call arch_needs_cpu() in order to check if the
local tick can be disabled. On offline cpus this function should naturally
return 0 since regardless if the tick gets disabled or not the cpu will be
dead short after. That is besides the fact that __cpu_disable() should already
have made sure that no interrupts on the offlined cpu will be delivered anyway.

In this case it prevents tick_nohz_stop_sched_tick() to call
select_nohz_load_balancer(). No idea if that really is a problem. However what
made me debug this is that on 2.6.32 the function get_nohz_load_balancer() is
used within __mod_timer() to select a cpu on which a timer gets enqueued.
If arch_needs_cpu() returns 1 then the nohz_load_balancer cpu doesn't get
updated when a cpu gets offlined. It may contain the cpu number of an offline
cpu. In turn timers get enqueued on an offline cpu and not very surprisingly
they never expire and cause system hangs.

This has been observed 2.6.32 kernels. On current kernels __mod_timer() uses
get_nohz_timer_target() which doesn't have that problem. However there might
be other problems because of the too early exit tick_nohz_stop_sched_tick()
in case a cpu goes offline.

This specific bug was indrocuded with 3c5d92a0 "nohz: Introduce
arch_needs_cpu".

In this case a cpu hotplug notifier is used to fix the issue in order to keep
the normal/fast path small. All we need to do is to clear the condition that
makes arch_needs_cpu() return 1 since it is just a performance improvement
which is supposed to keep the local tick running for a short period if a cpu
goes idle. Nothing special needs to be done except for clearing the condition.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/s390/kernel/vtime.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux/arch/s390/kernel/vtime.c
===================================================================
--- linux.orig/arch/s390/kernel/vtime.c
+++ linux/arch/s390/kernel/vtime.c
@@ -19,6 +19,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/rcupdate.h>
 #include <linux/posix-timers.h>
+#include <linux/cpu.h>
 
 #include <asm/s390_ext.h>
 #include <asm/timer.h>
@@ -565,6 +566,23 @@ void init_cpu_vtimer(void)
 	__ctl_set_bit(0,10);
 }
 
+static int __cpuinit s390_nohz_notify(struct notifier_block *self,
+				      unsigned long action, void *hcpu)
+{
+	struct s390_idle_data *idle;
+	long cpu = (long) hcpu;
+
+	idle = &per_cpu(s390_idle, cpu);
+	switch (action) {
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		idle->nohz_delay = 0;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 void __init vtime_init(void)
 {
 	/* request the cpu timer external interrupt */
@@ -573,5 +591,6 @@ void __init vtime_init(void)
 
 	/* Enable cpu timer interrupts on the boot cpu. */
 	init_cpu_vtimer();
+	cpu_notifier(s390_nohz_notify, 0);
 }
 
