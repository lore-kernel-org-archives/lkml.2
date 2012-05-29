Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2E2HRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:17:33 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57666 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2E2HRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:17:31 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        nikunj@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, axboe@kernel.dk,
        mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        akpm@linux-foundation.org, srivatsa.bhat@linux.vnet.ibm.com,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [RFC PATCH 06/10] x86: smp: remove call to ipi_call_lock()/ipi_call_unlock()
Date: Tue, 29 May 2012 15:16:01 +0800
Message-Id: <1338275765-3217-7-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

1) call_function.lock used in smp_call_function_many() is just to protect
   call_function.queue and &data->refs, cpu_online_mask is outside of the
   lock. And it's not necessary to protect cpu_online_mask,
   because data->cpumask is pre-calculate and even if a cpu is brougt up
   when calling arch_send_call_function_ipi_mask(), it's harmless because
   validation test in generic_smp_call_function_interrupt() will take care
   of it.

2) For cpu down issue, stop_machine() will guarantee that no concurrent
   smp_call_fuction() is processing.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/kernel/smpboot.c |    9 ---------
 arch/x86/xen/smp.c        |    2 --
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 433529e..bfbe30e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -253,22 +253,13 @@ notrace static void __cpuinit start_secondary(void *unused)
 	check_tsc_sync_target();
 
 	/*
-	 * We need to hold call_lock, so there is no inconsistency
-	 * between the time smp_call_function() determines number of
-	 * IPI recipients, and the time when the determination is made
-	 * for which cpus receive the IPI. Holding this
-	 * lock helps us to not include this cpu in a currently in progress
-	 * smp_call_function().
-	 *
 	 * We need to hold vector_lock so there the set of online cpus
 	 * does not change while we are assigning vectors to cpus.  Holding
 	 * this lock ensures we don't half assign or remove an irq from a cpu.
 	 */
-	ipi_call_lock();
 	lock_vector_lock();
 	set_cpu_online(smp_processor_id(), true);
 	unlock_vector_lock();
-	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index afb250d..f58dca7 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -80,9 +80,7 @@ static void __cpuinit cpu_bringup(void)
 
 	notify_cpu_starting(cpu);
 
-	ipi_call_lock();
 	set_cpu_online(cpu, true);
-	ipi_call_unlock();
 
 	this_cpu_write(cpu_state, CPU_ONLINE);
 
-- 
1.7.5.4

