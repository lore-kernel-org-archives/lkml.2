Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1HJSDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:03:22 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:61258 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1HJSDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:03:21 -0400
From: Alex Neronskiy <zakmagnus@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>,
        Alex Neronskiy <zakmagnus@chromium.org>
Subject: [PATCH v6 2/2] Output stall data in debugfs
Date: Wed, 10 Aug 2011 11:02:44 -0700
Message-Id: <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Neronskiy <zakmagnus@chromium.com>

Instead of using the log, use debugfs for output of both stall
lengths and stack traces. Printing to the log can result in
watchdog touches, distorting the very events being measured.
Additionally, the information will not distract from lockups
when users view the log.

A two-buffer system is used to ensure that the trace information
can always be recorded without contention.

Signed-off-by: Alex Neronskiy <zakmagnus@chromium.org>
---
I added comments to help explain how the two-buffer system
works. Also, compared to the last version, I removed some
redundant locking and global variables.
I also changed the volatile *_read_ind variables to
instead have read memory barriers after loads. I want to
avoid the local copy of the variable from just being treated
as an alias for the global variable, being read at different
times and getting different values. I'm not sure what the
correct way to ensure this is.

 kernel/sysctl.c   |   16 ----
 kernel/watchdog.c |  225 +++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 200 insertions(+), 41 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index a392952..b8620a2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -767,22 +767,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-	{
-		.procname       = "softstall_worst",
-		.data           = &worst_softstall,
-		.maxlen         = sizeof(unsigned long),
-		.mode           = 0644,
-		.proc_handler   = proc_doulongvec_minmax,
-	},
-#ifdef CONFIG_HARDLOCKUP_DETECTOR
-	{
-		.procname       = "hardstall_worst",
-		.data           = &worst_hardstall,
-		.maxlen         = sizeof(unsigned long),
-		.mode           = 0644,
-		.proc_handler   = proc_doulongvec_minmax,
-	},
-#endif /* CONFIG_HARDLOCKUP_DETECTOR */
 #endif /* CONFIG_LOCKUP_DETECTOR */
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 8dd9ed4..b908935 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -23,14 +23,35 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
+#include <linux/stacktrace.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
 
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
 
+#define STALL_SOFT (0)
+#define STALL_HARD (1)
+
+#define STALL_MAX_TRACE_DEPTH (50)
 int watchdog_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
 unsigned long worst_softstall;
-static DEFINE_SPINLOCK(softstall_lock);
+
+/* For output to debugfs, there are two buffers, each with their own
+ * lock. Only one can ever be locked at a time. The buffers are written
+ * to in interrupt context, but read in a system call, so the writers
+ * can't wait for the readers. Thus, if a writer is excluded from using
+ * a buffer, it will instead switch to the other, uncontended one.
+ * After it's done, it will indicate that the two buffers have switched
+ * roles.
+ */
+static unsigned long softstall_trace_entries[STALL_MAX_TRACE_DEPTH * 2];
+static struct stack_trace softstall_traces[2];
+static spinlock_t softstall_locks[2];
+static DEFINE_SPINLOCK(softstall_read_lock);
+static DEFINE_SPINLOCK(softstall_write_lock);
+static int soft_read_ind;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
@@ -46,7 +67,12 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_missed);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 
 unsigned long worst_hardstall;
-static DEFINE_SPINLOCK(hardstall_lock);
+static unsigned long hardstall_trace_entries[STALL_MAX_TRACE_DEPTH * 2];
+static struct stack_trace hardstall_traces[2];
+static spinlock_t hardstall_locks[2];
+static DEFINE_SPINLOCK(hardstall_read_lock);
+static DEFINE_SPINLOCK(hardstall_write_lock);
+static int hard_read_ind;
 
 /* The number of consecutive hard check failures before it's a lockup */
 #define hardlockup_thresh (5)
@@ -210,22 +236,27 @@ void touch_softlockup_watchdog_sync(void)
 /* watchdog detector functions */
 static void update_hardstall(unsigned long stall, int this_cpu)
 {
-	int update_stall = 0;
-
 	if (stall > hardstall_thresh && stall > worst_hardstall) {
 		unsigned long flags;
-		spin_lock_irqsave(&hardstall_lock, flags);
-		update_stall = stall > worst_hardstall;
-		if (update_stall)
+		spin_lock_irqsave(&hardstall_write_lock, flags);
+		if (stall > worst_hardstall) {
+			int write_ind = hard_read_ind;
+			int locked = spin_trylock(&hardstall_locks[write_ind]);
+			/* cannot wait, so if there's contention,
+			 * switch buffers */
+			if (!locked)
+				write_ind = !write_ind;
+
 			worst_hardstall = stall;
-		spin_unlock_irqrestore(&hardstall_lock, flags);
-	}
+			hardstall_traces[write_ind].nr_entries = 0;
+			save_stack_trace(&hardstall_traces[write_ind]);
 
-	if (update_stall) {
-		printk(KERN_WARNING "LOCKUP may be in progress!"
-			"Worst hard stall seen on CPU#%d: %lu interrupts missed\n",
-			this_cpu, stall);
-		dump_stack();
+			/* tell readers to use the new buffer from now on */
+			hard_read_ind = write_ind;
+			if (locked)
+				spin_unlock(&hardstall_locks[write_ind]);
+		}
+		spin_unlock_irqrestore(&hardstall_write_lock, flags);
 	}
 }
 
@@ -252,22 +283,28 @@ static int is_hardlockup(int this_cpu)
 
 static void update_softstall(unsigned long stall, int this_cpu)
 {
-	int update_stall = 0;
 	if (stall > get_softstall_thresh() &&
 			stall > worst_softstall + softstall_diff_thresh) {
 		unsigned long flags;
-		spin_lock_irqsave(&softstall_lock, flags);
-		update_stall = stall > worst_softstall + softstall_diff_thresh;
-		if (update_stall)
+		spin_lock_irqsave(&softstall_write_lock, flags);
+		if (stall > worst_softstall + softstall_diff_thresh) {
+			int write_ind = soft_read_ind;
+			int locked = spin_trylock(&softstall_locks[write_ind]);
+			/* cannot wait, so if there's contention,
+			 * switch buffers */
+			if (!locked)
+				write_ind = !write_ind;
+
 			worst_softstall = stall;
-		spin_unlock_irqrestore(&softstall_lock, flags);
-	}
+			softstall_traces[write_ind].nr_entries = 0;
+			save_stack_trace(&softstall_traces[write_ind]);
 
-	if (update_stall) {
-		printk(KERN_WARNING "LOCKUP may be in progress!"
-				"Worst soft stall seen on CPU#%d: %lums\n",
-				this_cpu, stall);
-		dump_stack();
+			/* tell readers to use the new buffer from now on */
+			soft_read_ind = write_ind;
+			if (locked)
+				spin_unlock(&softstall_locks[write_ind]);
+		}
+		spin_unlock_irqrestore(&softstall_write_lock, flags);
 	}
 }
 
@@ -667,6 +704,86 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
+static int show_stall_trace(struct seq_file *f, void *v)
+{
+	int i, end, buf_ind;
+	int type = (int) f->private;
+	spinlock_t *lock;
+	struct stack_trace *trace;
+	unsigned long flags;
+
+	/* The buf_ind is saved locally because the global read_ind
+	 * variable can be changed at any time. Using a stale value
+	 * is okay but reading inconsistent values is not, as it can
+	 * result in locking one buffer and reading the other.
+	 * For this reason, reads are also serialized (via the
+	 * read_lock); otherwise two readers can lock both buffers
+	 * at once, and then a writer will not be able to write
+	 * without contention.
+	 */
+	if (type == STALL_SOFT) {
+		spin_lock_irqsave(&softstall_read_lock, flags);
+
+		buf_ind = soft_read_ind;
+		rmb();
+		lock = &softstall_locks[buf_ind];
+		trace = &softstall_traces[buf_ind];
+	} else {
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+		spin_lock_irqsave(&hardstall_read_lock, flags);
+
+		buf_ind = hard_read_ind;
+		rmb();
+		lock = &hardstall_locks[buf_ind];
+		trace = &hardstall_traces[buf_ind];
+#endif
+	}
+
+	end = trace->nr_entries;
+	/* don't bother printing the trailing value */
+	if (end < trace->max_entries)
+		end--;
+
+	spin_lock(lock); /* excludes writers */
+	for (i = 0; i < end; i++) {
+		seq_printf(f, "[<%pK>] %pS\n", (void *)trace->entries[i],
+				(void *)trace->entries[i]);
+	}
+	spin_unlock(lock);
+
+	if (type == STALL_SOFT)
+		spin_unlock_irqrestore(&softstall_read_lock, flags);
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+	else
+		spin_unlock_irqrestore(&hardstall_read_lock, flags);
+#endif
+
+	return 0;
+}
+
+static int softstall_trace_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_stall_trace, (void *)STALL_SOFT);
+}
+
+static int hardstall_trace_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_stall_trace, (void *)STALL_HARD);
+}
+
+static const struct file_operations softstall_trace_ops = {
+	.open = softstall_trace_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release
+};
+static const struct file_operations hardstall_trace_ops = {
+	.open = hardstall_trace_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release
+};
+
 void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
@@ -678,5 +795,63 @@ void __init lockup_detector_init(void)
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
+	softstall_traces[0].nr_entries = 0;
+	softstall_traces[0].max_entries = STALL_MAX_TRACE_DEPTH;
+	softstall_traces[0].skip = 0;
+	softstall_traces[0].entries = softstall_trace_entries;
+	softstall_traces[1].nr_entries = 0;
+	softstall_traces[1].max_entries = STALL_MAX_TRACE_DEPTH;
+	softstall_traces[1].skip = 0;
+	softstall_traces[1].entries = softstall_trace_entries
+		+ STALL_MAX_TRACE_DEPTH;
+
+	spin_lock_init(&softstall_locks[0]);
+	spin_lock_init(&softstall_locks[1]);
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+	hardstall_traces[0].nr_entries = 0;
+	hardstall_traces[0].max_entries = STALL_MAX_TRACE_DEPTH;
+	hardstall_traces[0].skip = 0;
+	hardstall_traces[0].entries = hardstall_trace_entries;
+	hardstall_traces[1].nr_entries = 0;
+	hardstall_traces[1].max_entries = STALL_MAX_TRACE_DEPTH;
+	hardstall_traces[1].skip = 0;
+	hardstall_traces[1].entries = hardstall_trace_entries
+		+ STALL_MAX_TRACE_DEPTH;
+
+	spin_lock_init(&hardstall_locks[0]);
+	spin_lock_init(&hardstall_locks[1]);
+#endif
+
 	return;
 }
+
+/* Must be called after debugfs_init() */
+static int __init lockup_detector_debugfs_init(void)
+{
+	struct dentry *parent = debugfs_create_dir("lockup_watchdog", NULL);
+	if (parent) {
+		debugfs_create_file("softstall_trace", 0444, parent, NULL,
+				&softstall_trace_ops);
+		if (sizeof(worst_softstall) == sizeof(u32))
+			debugfs_create_u32("softstall_worst", 0644, parent,
+					(u32 *) &worst_softstall);
+		else if (sizeof(worst_softstall) == sizeof(u64))
+			debugfs_create_u64("softstall_worst", 0644, parent,
+					(u64 *) &worst_softstall);
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+		debugfs_create_file("hardstall_trace", 0444, parent, NULL,
+				&hardstall_trace_ops);
+		if (sizeof(worst_hardstall) == sizeof(u32))
+			debugfs_create_u32("hardstall_worst", 0644, parent,
+					(u32 *) &worst_hardstall);
+		else if (sizeof(worst_hardstall) == sizeof(u64))
+			debugfs_create_u64("hardstall_worst", 0644, parent,
+					(u64 *) &worst_hardstall);
+#endif
+	}
+
+	return 0;
+}
+postcore_initcall(lockup_detector_debugfs_init);
-- 
1.7.3.1

