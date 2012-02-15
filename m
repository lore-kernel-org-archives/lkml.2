Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab2BOFAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:00:15 -0500
Received: from ozlabs.org ([203.10.76.45]:60353 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab2BOFAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:00:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Message-ID: <1329281883.31681.rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:03 +1030
Subject: [PATCH 1/12] arch/um: remove references to cpu_*_map.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: user-mode-linux-devel@lists.sourceforge.net
---
 arch/um/kernel/skas/process.c |    2 +-
 arch/um/kernel/smp.c          |    9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/um/kernel/skas/process.c b/arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c
+++ b/arch/um/kernel/skas/process.c
@@ -41,7 +41,7 @@ static int __init start_kernel_proc(void
 	cpu_tasks[0].pid = pid;
 	cpu_tasks[0].task = current;
 #ifdef CONFIG_SMP
-	cpu_online_map = cpumask_of_cpu(0);
+	init_cpu_online(get_cpu_mask(0));
 #endif
 	start_kernel();
 	return 0;
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -76,7 +76,7 @@ static int idle_proc(void *cpup)
 		cpu_relax();
 
 	notify_cpu_starting(cpu);
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	default_idle();
 	return 0;
 }
@@ -110,8 +110,7 @@ void smp_prepare_cpus(unsigned int maxcp
 	for (i = 0; i < ncpus; ++i)
 		set_cpu_possible(i, true);
 
-	cpu_clear(me, cpu_online_map);
-	cpu_set(me, cpu_online_map);
+	set_cpu_online(me, true);
 	cpu_set(me, cpu_callin_map);
 
 	err = os_pipe(cpu_data[me].ipi_pipe, 1, 1);
@@ -138,13 +137,13 @@ void smp_prepare_cpus(unsigned int maxcp
 
 void smp_prepare_boot_cpu(void)
 {
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 }
 
 int __cpu_up(unsigned int cpu)
 {
 	cpu_set(cpu, smp_commenced_mask);
-	while (!cpu_isset(cpu, cpu_online_map))
+	while (!cpu_online(cpu))
 		mb();
 	return 0;
 }

