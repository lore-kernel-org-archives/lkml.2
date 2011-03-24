Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab1CXHJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:09:12 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:37137 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab1CXHJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:09:06 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 2/5] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
Date: Thu, 24 Mar 2011 03:08:25 -0400
Message-id: <b048802b0285a5ff28e74a4309d833116174904a.1300950095.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
In-reply-to: <1300950508-22746-1-git-send-email-lenb@kernel.org>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
In-reply-to: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1300950095.git.len.brown@intel.com>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1300950095.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

hlt_works_ok was X86_32 only, initialized to 1, and never cleared.

On 32-bit kernels, this deletes a line from /proc/cpuinfo: "hlt_bug : no"

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/processor.h |    5 -----
 arch/x86/kernel/cpu/bugs.c       |    5 +----
 arch/x86/kernel/cpu/proc.c       |    2 --
 arch/x86/kernel/process.c        |    2 +-
 arch/x86/kernel/setup.c          |    4 ++--
 arch/x86/xen/setup.c             |    3 ---
 6 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 45636ce..b5c83f1 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -67,7 +67,6 @@ struct cpuinfo_x86 {
 	char			wp_works_ok;	/* It doesn't on 386's */
 
 	/* Problems on some 486Dx4's and old 386's: */
-	char			hlt_works_ok;
 	char			hard_math;
 	char			rfu;
 	char			fdiv_bug;
@@ -150,11 +149,7 @@ extern const struct seq_operations cpuinfo_op;
 
 static inline int hlt_works(int cpu)
 {
-#ifdef CONFIG_X86_32
-	return cpu_data(cpu).hlt_works_ok;
-#else
 	return 1;
-#endif
 }
 
 #define cache_line_size()	(boot_cpu_data.x86_cache_alignment)
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4c91631..b5e2910 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -82,10 +82,7 @@ static void __init check_hlt(void)
 		return;
 
 	printk(KERN_INFO "Checking 'hlt' instruction... ");
-	if (!boot_cpu_data.hlt_works_ok) {
-		printk("disabled\n");
-		return;
-	}
+
 	halt();
 	halt();
 	halt();
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 62ac8cb..203feb7 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -33,7 +33,6 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 	int fpu_exception = c->hard_math && (ignore_fpu_irq || cpu_has_fpu);
 	seq_printf(m,
 		   "fdiv_bug\t: %s\n"
-		   "hlt_bug\t\t: %s\n"
 		   "f00f_bug\t: %s\n"
 		   "coma_bug\t: %s\n"
 		   "fpu\t\t: %s\n"
@@ -41,7 +40,6 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "cpuid level\t: %d\n"
 		   "wp\t\t: %s\n",
 		   c->fdiv_bug ? "yes" : "no",
-		   c->hlt_works_ok ? "no" : "yes",
 		   c->f00f_bug ? "yes" : "no",
 		   c->coma_bug ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ff45541..4966c7e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -362,7 +362,7 @@ EXPORT_SYMBOL(enable_hlt);
 
 static inline int hlt_use_halt(void)
 {
-	return (!hlt_counter && boot_cpu_data.hlt_works_ok);
+	return (!hlt_counter);
 }
 #else
 static inline int hlt_use_halt(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3cfe26..fab5631 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -175,9 +175,9 @@ static struct resource bss_resource = {
 
 #ifdef CONFIG_X86_32
 /* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 0, 0, -1};
 /* common cpu data for all cpus */
-struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 1, 0, 0, -1};
+struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 0, 0, -1};
 EXPORT_SYMBOL(boot_cpu_data);
 static void set_mca_bus(int x)
 {
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index a8a66a5..97d2fbd 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -351,9 +351,6 @@ void __init xen_arch_setup(void)
 	       COMMAND_LINE_SIZE : MAX_GUEST_CMDLINE);
 
 	/* Set up idle, making sure it calls safe_halt() pvop */
-#ifdef CONFIG_X86_32
-	boot_cpu_data.hlt_works_ok = 1;
-#endif
 	pm_idle = default_idle;
 	boot_option_idle_override = IDLE_HALT;
 
-- 
1.7.4.1.343.ga91df

