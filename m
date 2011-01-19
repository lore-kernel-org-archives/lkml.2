Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1ASJ1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:27:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1ASJ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:27:34 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Akinobu Mita <akinobu.mita@gmail.com>
Subject: [Patch] smp: move smp setup functions to kernel/smp.c
Date: Wed, 19 Jan 2011 17:26:15 +0800
Message-Id: <1295429183-9397-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves setup_nr_cpu_ids(), smp_init() and some other
SMP boot parameter setup functions from init/main.c to kenrel/smp.c,
saves some #ifdef CONFIG_SMP.

Compile tested.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
 include/linux/smp.h |    2 +
 init/main.c         |   90 +--------------------------------------------------
 kernel/smp.c        |   81 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+), 89 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 6dc95ca..48159dd 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -114,6 +114,8 @@ int on_each_cpu(smp_call_func_t func, void *info, int wait);
 void smp_prepare_boot_cpu(void);
 
 extern unsigned int setup_max_cpus;
+extern void __init setup_nr_cpu_ids(void);
+extern void __init smp_init(void);
 
 #else /* !SMP */
 
diff --git a/init/main.c b/init/main.c
index 00799c1..35d6ce6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -120,63 +120,6 @@ static char *static_command_line;
 static char *execute_command;
 static char *ramdisk_execute_command;
 
-#ifdef CONFIG_SMP
-/* Setup configured maximum number of CPUs to activate */
-unsigned int setup_max_cpus = NR_CPUS;
-EXPORT_SYMBOL(setup_max_cpus);
-
-
-/*
- * Setup routine for controlling SMP activation
- *
- * Command-line option of "nosmp" or "maxcpus=0" will disable SMP
- * activation entirely (the MPS table probe still happens, though).
- *
- * Command-line option of "maxcpus=<NUM>", where <NUM> is an integer
- * greater than 0, limits the maximum number of CPUs activated in
- * SMP mode to <NUM>.
- */
-
-void __weak arch_disable_smp_support(void) { }
-
-static int __init nosmp(char *str)
-{
-	setup_max_cpus = 0;
-	arch_disable_smp_support();
-
-	return 0;
-}
-
-early_param("nosmp", nosmp);
-
-/* this is hard limit */
-static int __init nrcpus(char *str)
-{
-	int nr_cpus;
-
-	get_option(&str, &nr_cpus);
-	if (nr_cpus > 0 && nr_cpus < nr_cpu_ids)
-		nr_cpu_ids = nr_cpus;
-
-	return 0;
-}
-
-early_param("nr_cpus", nrcpus);
-
-static int __init maxcpus(char *str)
-{
-	get_option(&str, &setup_max_cpus);
-	if (setup_max_cpus == 0)
-		arch_disable_smp_support();
-
-	return 0;
-}
-
-early_param("maxcpus", maxcpus);
-#else
-static const unsigned int setup_max_cpus = NR_CPUS;
-#endif
-
 /*
  * If set, this is an indication to the drivers that reset the underlying
  * device before going ahead with the initialization otherwise driver might
@@ -353,7 +296,7 @@ static int __init rdinit_setup(char *str)
 __setup("rdinit=", rdinit_setup);
 
 #ifndef CONFIG_SMP
-
+static const unsigned int setup_max_cpus = NR_CPUS;
 #ifdef CONFIG_X86_LOCAL_APIC
 static void __init smp_init(void)
 {
@@ -365,37 +308,6 @@ static void __init smp_init(void)
 
 static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
-
-#else
-
-/* Setup number of possible processor ids */
-int nr_cpu_ids __read_mostly = NR_CPUS;
-EXPORT_SYMBOL(nr_cpu_ids);
-
-/* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
-static void __init setup_nr_cpu_ids(void)
-{
-	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
-}
-
-/* Called by boot processor to activate the rest. */
-static void __init smp_init(void)
-{
-	unsigned int cpu;
-
-	/* FIXME: This should be done in userspace --RR */
-	for_each_present_cpu(cpu) {
-		if (num_online_cpus() >= setup_max_cpus)
-			break;
-		if (!cpu_online(cpu))
-			cpu_up(cpu);
-	}
-
-	/* Any cleanup work */
-	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
-	smp_cpus_done(setup_max_cpus);
-}
-
 #endif
 
 /*
diff --git a/kernel/smp.c b/kernel/smp.c
index 4ec30e0..d645a71 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -532,6 +532,87 @@ void ipi_call_unlock_irq(void)
 }
 #endif /* USE_GENERIC_SMP_HELPERS */
 
+/* Setup configured maximum number of CPUs to activate */
+unsigned int setup_max_cpus = NR_CPUS;
+EXPORT_SYMBOL(setup_max_cpus);
+
+
+/*
+ * Setup routine for controlling SMP activation
+ *
+ * Command-line option of "nosmp" or "maxcpus=0" will disable SMP
+ * activation entirely (the MPS table probe still happens, though).
+ *
+ * Command-line option of "maxcpus=<NUM>", where <NUM> is an integer
+ * greater than 0, limits the maximum number of CPUs activated in
+ * SMP mode to <NUM>.
+ */
+
+void __weak arch_disable_smp_support(void) { }
+
+static int __init nosmp(char *str)
+{
+	setup_max_cpus = 0;
+	arch_disable_smp_support();
+
+	return 0;
+}
+
+early_param("nosmp", nosmp);
+
+/* this is hard limit */
+static int __init nrcpus(char *str)
+{
+	int nr_cpus;
+
+	get_option(&str, &nr_cpus);
+	if (nr_cpus > 0 && nr_cpus < nr_cpu_ids)
+		nr_cpu_ids = nr_cpus;
+
+	return 0;
+}
+
+early_param("nr_cpus", nrcpus);
+
+static int __init maxcpus(char *str)
+{
+	get_option(&str, &setup_max_cpus);
+	if (setup_max_cpus == 0)
+		arch_disable_smp_support();
+
+	return 0;
+}
+
+early_param("maxcpus", maxcpus);
+
+/* Setup number of possible processor ids */
+int nr_cpu_ids __read_mostly = NR_CPUS;
+EXPORT_SYMBOL(nr_cpu_ids);
+
+/* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
+void __init setup_nr_cpu_ids(void)
+{
+	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
+}
+
+/* Called by boot processor to activate the rest. */
+void __init smp_init(void)
+{
+	unsigned int cpu;
+
+	/* FIXME: This should be done in userspace --RR */
+	for_each_present_cpu(cpu) {
+		if (num_online_cpus() >= setup_max_cpus)
+			break;
+		if (!cpu_online(cpu))
+			cpu_up(cpu);
+	}
+
+	/* Any cleanup work */
+	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
+	smp_cpus_done(setup_max_cpus);
+}
+
 /*
  * Call a function on all processors
  */
