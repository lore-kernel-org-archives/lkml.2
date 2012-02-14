Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334Ab2BNWww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:52:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56811 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760862Ab2BNWwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:52:50 -0500
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tony Luck <tony.luck@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 3/3] um: Avoid raw handling of cpu_online_map
Date: Tue, 14 Feb 2012 14:49:44 -0800
Message-Id: <1329259784-20592-4-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329259784-20592-1-git-send-email-venki@google.com>
References: <87wr7pbwbz.fsf@rustcorp.com.au>
 <1329259784-20592-1-git-send-email-venki@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use init_cpu_online and set_cpu_online instead.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/um/kernel/skas/process.c |    2 +-
 arch/um/kernel/smp.c          |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/um/kernel/skas/process.c b/arch/um/kernel/skas/process.c
index 2e9852c..5daa0f5 100644
--- a/arch/um/kernel/skas/process.c
+++ b/arch/um/kernel/skas/process.c
@@ -41,7 +41,7 @@ static int __init start_kernel_proc(void *unused)
 	cpu_tasks[0].pid = pid;
 	cpu_tasks[0].task = current;
 #ifdef CONFIG_SMP
-	cpu_online_map = cpumask_of_cpu(0);
+	init_cpu_online(cpumask_of(0));
 #endif
 	start_kernel();
 	return 0;
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index 155206a..b5d2ca9 100644
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
@@ -110,8 +110,8 @@ void smp_prepare_cpus(unsigned int maxcpus)
 	for (i = 0; i < ncpus; ++i)
 		set_cpu_possible(i, true);
 
-	cpu_clear(me, cpu_online_map);
-	cpu_set(me, cpu_online_map);
+	set_cpu_online(me, false);
+	set_cpu_online(me, true);
 	cpu_set(me, cpu_callin_map);
 
 	err = os_pipe(cpu_data[me].ipi_pipe, 1, 1);
@@ -138,7 +138,7 @@ void smp_prepare_cpus(unsigned int maxcpus)
 
 void smp_prepare_boot_cpu(void)
 {
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 }
 
 int __cpu_up(unsigned int cpu)
-- 
1.7.7.3

