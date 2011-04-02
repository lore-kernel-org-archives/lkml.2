Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1DBHC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 03:02:28 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:59186 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1DBHCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 03:02:00 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [PATCH 13/18] 2.6.40: x86 idle: remove deprecated "hlt_bug: no" in
 32-bit /proc/cpuinfo
Date: Sat, 02 Apr 2011 02:22:55 -0400
Message-id: <b499d75b1c21e1f3183001847172b6b71baf1c8b.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Now that the "no-hlt" cmdline param is gone...

cpuinfo_x86.hlt_works_ok, halt_works() and the
"hlt_bug: no" line in 32-bit /proc/cpuinfo are NOPS.

remove them.

cc: x86@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/processor.h |   10 ----------
 arch/x86/kernel/cpu/bugs.c       |    5 +----
 arch/x86/kernel/cpu/proc.c       |    2 --
 arch/x86/kernel/process.c        |    5 ++---
 arch/x86/kernel/setup.c          |    4 ++--
 arch/x86/xen/setup.c             |    3 ---
 6 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fd02787..10cdee8 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -67,7 +67,6 @@ struct cpuinfo_x86 {
 	char			wp_works_ok;	/* It doesn't on 386's */
 
 	/* Problems on some 486Dx4's and old 386's: */
-	char			hlt_works_ok;
 	char			hard_math;
 	char			rfu;
 	char			fdiv_bug;
@@ -148,15 +147,6 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 
 extern const struct seq_operations cpuinfo_op;
 
-static inline int hlt_works(int cpu)
-{
-#ifdef CONFIG_X86_32
-	return cpu_data(cpu).hlt_works_ok;
-#else
-	return 1;
-#endif
-}
-
 #define cache_line_size()	(boot_cpu_data.x86_cache_alignment)
 
 extern void cpu_detect(struct cpuinfo_x86 *c);
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
index 579c78f..c485629 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -364,7 +364,7 @@ EXPORT_SYMBOL(enable_hlt);
 
 static inline int hlt_use_halt(void)
 {
-	return (!hlt_counter && boot_cpu_data.hlt_works_ok);
+	return !hlt_counter;
 }
 #else
 static inline int hlt_use_halt(void)
@@ -416,8 +416,7 @@ void stop_this_cpu(void *dummy)
 	disable_local_APIC();
 
 	for (;;) {
-		if (hlt_works(smp_processor_id()))
-			halt();
+		halt();
 	}
 }
 
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
index aa02cce..32069fb 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -352,9 +352,6 @@ void __init xen_arch_setup(void)
 	       COMMAND_LINE_SIZE : MAX_GUEST_CMDLINE);
 
 	/* Set up idle, making sure it calls safe_halt() pvop */
-#ifdef CONFIG_X86_32
-	boot_cpu_data.hlt_works_ok = 1;
-#endif
 	disable_cpuidle();
 	boot_option_idle_override = IDLE_HALT;
 
-- 
1.7.5.rc0

