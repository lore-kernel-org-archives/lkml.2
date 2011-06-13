Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab1FMJxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:53:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40495 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1FMJxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:53:38 -0400
Date: Mon, 13 Jun 2011 11:53:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110613095328.GA22630@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
GuoWen Li (1):
      ftrace: Fix possible undefined return code

Robert Richter (4):
      oprofile, x86: Add comments to IBS LVT offset initialization
      oprofile: Free potentially owned tasks in case of errors
      oprofile: Fix locking dependency in sync_start()
      oprofile, dcookies: Fix possible circular locking dependency

Steven Rostedt (2):
      kprobes/trace: Fix kprobe selftest for gcc 4.6
      ftrace: Revert 8ab2b7efd ftrace: Remove unnecessary disabling of irqs


 arch/x86/kernel/apic/apic.c      |    3 ++-
 arch/x86/oprofile/op_model_amd.c |   13 +++++++++----
 drivers/oprofile/buffer_sync.c   |   21 +++++++++++----------
 fs/dcookies.c                    |    3 +++
 kernel/trace/ftrace.c            |    9 ++++++++-
 kernel/trace/trace_kprobe.c      |    8 ++++++--
 6 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b961af8..b9338b8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -390,7 +390,8 @@ static unsigned int reserve_eilvt_offset(int offset, unsigned int new)
 
 /*
  * If mask=1, the LVT entry does not generate interrupts while mask=0
- * enables the vector. See also the BKDGs.
+ * enables the vector. See also the BKDGs. Must be called with
+ * preemption disabled.
  */
 
 int setup_APIC_eilvt(u8 offset, u8 vector, u8 msg_type, u8 mask)
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 9fd8a56..9cbb710 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -609,16 +609,21 @@ static int setup_ibs_ctl(int ibs_eilvt_off)
 	return 0;
 }
 
+/*
+ * This runs only on the current cpu. We try to find an LVT offset and
+ * setup the local APIC. For this we must disable preemption. On
+ * success we initialize all nodes with this offset. This updates then
+ * the offset in the IBS_CTL per-node msr. The per-core APIC setup of
+ * the IBS interrupt vector is called from op_amd_setup_ctrs()/op_-
+ * amd_cpu_shutdown() using the new offset.
+ */
 static int force_ibs_eilvt_setup(void)
 {
 	int offset;
 	int ret;
 
-	/*
-	 * find the next free available EILVT entry, skip offset 0,
-	 * pin search to this cpu
-	 */
 	preempt_disable();
+	/* find the next free available EILVT entry, skip offset 0 */
 	for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
 		if (get_eilvt(offset))
 			break;
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index a3984f4..f34b5b2 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -141,6 +141,13 @@ static struct notifier_block module_load_nb = {
 	.notifier_call = module_load_notify,
 };
 
+static void free_all_tasks(void)
+{
+	/* make sure we don't leak task structs */
+	process_task_mortuary();
+	process_task_mortuary();
+}
+
 int sync_start(void)
 {
 	int err;
@@ -148,8 +155,6 @@ int sync_start(void)
 	if (!zalloc_cpumask_var(&marked_cpus, GFP_KERNEL))
 		return -ENOMEM;
 
-	mutex_lock(&buffer_mutex);
-
 	err = task_handoff_register(&task_free_nb);
 	if (err)
 		goto out1;
@@ -166,7 +171,6 @@ int sync_start(void)
 	start_cpu_work();
 
 out:
-	mutex_unlock(&buffer_mutex);
 	return err;
 out4:
 	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
@@ -174,6 +178,7 @@ out3:
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 out2:
 	task_handoff_unregister(&task_free_nb);
+	free_all_tasks();
 out1:
 	free_cpumask_var(marked_cpus);
 	goto out;
@@ -182,20 +187,16 @@ out1:
 
 void sync_stop(void)
 {
-	/* flush buffers */
-	mutex_lock(&buffer_mutex);
 	end_cpu_work();
 	unregister_module_notifier(&module_load_nb);
 	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 	task_handoff_unregister(&task_free_nb);
-	mutex_unlock(&buffer_mutex);
-	flush_cpu_work();
+	barrier();			/* do all of the above first */
 
-	/* make sure we don't leak task structs */
-	process_task_mortuary();
-	process_task_mortuary();
+	flush_cpu_work();
 
+	free_all_tasks();
 	free_cpumask_var(marked_cpus);
 }
 
diff --git a/fs/dcookies.c b/fs/dcookies.c
index a21cabd..dda0dc7 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -178,6 +178,8 @@ SYSCALL_DEFINE(lookup_dcookie)(u64 cookie64, char __user * buf, size_t len)
 	/* FIXME: (deleted) ? */
 	path = d_path(&dcs->path, kbuf, PAGE_SIZE);
 
+	mutex_unlock(&dcookie_mutex);
+
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
 		goto out_free;
@@ -194,6 +196,7 @@ SYSCALL_DEFINE(lookup_dcookie)(u64 cookie64, char __user * buf, size_t len)
 
 out_free:
 	kfree(kbuf);
+	return err;
 out:
 	mutex_unlock(&dcookie_mutex);
 	return err;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ee417f..908038f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2740,7 +2740,7 @@ static int ftrace_process_regex(struct ftrace_hash *hash,
 {
 	char *func, *command, *next = buff;
 	struct ftrace_func_command *p;
-	int ret;
+	int ret = -EINVAL;
 
 	func = strsep(&next, ":");
 
@@ -3330,6 +3330,7 @@ static int ftrace_process_locs(struct module *mod,
 {
 	unsigned long *p;
 	unsigned long addr;
+	unsigned long flags;
 
 	mutex_lock(&ftrace_lock);
 	p = start;
@@ -3346,7 +3347,13 @@ static int ftrace_process_locs(struct module *mod,
 		ftrace_record_ip(addr);
 	}
 
+	/*
+	 * Disable interrupts to prevent interrupts from executing
+	 * code that is being modified.
+	 */
+	local_irq_save(flags);
 	ftrace_update_code(mod);
+	local_irq_restore(flags);
 	mutex_unlock(&ftrace_lock);
 
 	return 0;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f925c45..27d13b3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1870,8 +1870,12 @@ fs_initcall(init_kprobe_trace);
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 
-static int kprobe_trace_selftest_target(int a1, int a2, int a3,
-					int a4, int a5, int a6)
+/*
+ * The "__used" keeps gcc from removing the function symbol
+ * from the kallsyms table.
+ */
+static __used int kprobe_trace_selftest_target(int a1, int a2, int a3,
+					       int a4, int a5, int a6)
 {
 	return a1 + a2 + a3 + a4 + a5 + a6;
 }
