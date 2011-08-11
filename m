Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1HKXgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 19:36:15 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58960 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1HKXgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 19:36:11 -0400
From: Alex Neronskiy <zakmagnus@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.org>
Subject: [PATCH v7 2/2] Output stall data in debugfs
Date: Thu, 11 Aug 2011 16:35:08 -0700
Message-Id: <1313105708-13331-2-git-send-email-zakmagnus@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313105708-13331-1-git-send-email-zakmagnus@chromium.org>
References: <1313105708-13331-1-git-send-email-zakmagnus@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using the log, use debugfs for output of both stall
lengths and stack traces. Printing to the log can result in
watchdog touches, distorting the very events being measured.
Additionally, the information will not distract from lockups
when users view the log.

A two-buffer system is used to ensure that the trace information
can always be recorded without contention.

Signed-off-by: Alex Neronskiy <zakmagnus@chromium.org>
---
Changes from last version per Peter's suggestions: different
locks, refactoring, ACCESS_ONCE.

 kernel/watchdog.c |  228 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 199 insertions(+), 29 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 8dd9ed4..cd95886 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -23,14 +23,39 @@
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
+struct stall_data {
+	unsigned long trace_entries[STALL_MAX_TRACE_DEPTH * 2];
+	struct stack_trace traces[2];
+	raw_spinlock_t locks[2];
+	struct mutex read_lock;
+	raw_spinlock_t write_lock;
+	int read_ind;
+};
+
+static struct stall_data softstall_data;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
@@ -46,7 +71,7 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_missed);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 
 unsigned long worst_hardstall;
-static DEFINE_SPINLOCK(hardstall_lock);
+static struct stall_data hardstall_data;
 
 /* The number of consecutive hard check failures before it's a lockup */
 #define hardlockup_thresh (5)
@@ -210,22 +235,28 @@ void touch_softlockup_watchdog_sync(void)
 /* watchdog detector functions */
 static void update_hardstall(unsigned long stall, int this_cpu)
 {
-	int update_stall = 0;
-
 	if (stall > hardstall_thresh && stall > worst_hardstall) {
-		unsigned long flags;
-		spin_lock_irqsave(&hardstall_lock, flags);
-		update_stall = stall > worst_hardstall;
-		if (update_stall)
-			worst_hardstall = stall;
-		spin_unlock_irqrestore(&hardstall_lock, flags);
-	}
+		raw_spin_lock(&hardstall_data.write_lock);
+		if (stall > worst_hardstall) {
+			int write_ind = hardstall_data.read_ind;
+			int locked = raw_spin_trylock(&hardstall_data.
+					locks[write_ind]);
+			/* cannot wait, so if there's contention,
+			 * switch buffers */
+			if (!locked)
+				write_ind = !write_ind;
 
-	if (update_stall) {
-		printk(KERN_WARNING "LOCKUP may be in progress!"
-			"Worst hard stall seen on CPU#%d: %lu interrupts missed\n",
-			this_cpu, stall);
-		dump_stack();
+			worst_hardstall = stall;
+			hardstall_data.traces[write_ind].nr_entries = 0;
+			save_stack_trace(&hardstall_data.traces[write_ind]);
+
+			/* tell readers to use the new buffer from now on */
+			hardstall_data.read_ind = write_ind;
+			if (locked)
+				raw_spin_unlock(&hardstall_data.
+						locks[write_ind]);
+		}
+		raw_spin_unlock(&hardstall_data.write_lock);
 	}
 }
 
@@ -252,22 +283,29 @@ static int is_hardlockup(int this_cpu)
 
 static void update_softstall(unsigned long stall, int this_cpu)
 {
-	int update_stall = 0;
 	if (stall > get_softstall_thresh() &&
 			stall > worst_softstall + softstall_diff_thresh) {
-		unsigned long flags;
-		spin_lock_irqsave(&softstall_lock, flags);
-		update_stall = stall > worst_softstall + softstall_diff_thresh;
-		if (update_stall)
-			worst_softstall = stall;
-		spin_unlock_irqrestore(&softstall_lock, flags);
-	}
+		raw_spin_lock(&softstall_data.write_lock);
+		if (stall > worst_softstall + softstall_diff_thresh) {
+			int write_ind = softstall_data.read_ind;
+			int locked = raw_spin_trylock(&softstall_data.
+					locks[write_ind]);
+			/* cannot wait, so if there's contention,
+			 * switch buffers */
+			if (!locked)
+				write_ind = !write_ind;
 
-	if (update_stall) {
-		printk(KERN_WARNING "LOCKUP may be in progress!"
-				"Worst soft stall seen on CPU#%d: %lums\n",
-				this_cpu, stall);
-		dump_stack();
+			worst_softstall = stall;
+			softstall_data.traces[write_ind].nr_entries = 0;
+			save_stack_trace(&softstall_data.traces[write_ind]);
+
+			/* tell readers to use the new buffer from now on */
+			softstall_data.read_ind = write_ind;
+			if (locked)
+				raw_spin_unlock(&softstall_data.
+						locks[write_ind]);
+		}
+		raw_spin_unlock(&softstall_data.write_lock);
 	}
 }
 
@@ -667,6 +705,102 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
+static int show_stall_trace(struct seq_file *f, void *v)
+{
+	int i, end, buf_ind;
+	int type = (int) f->private;
+	raw_spinlock_t *lock;
+	struct stack_trace *trace;
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
+		mutex_lock(&softstall_data.read_lock);
+
+		buf_ind = ACCESS_ONCE(softstall_data.read_ind);
+		lock = &softstall_data.locks[buf_ind];
+		trace = &softstall_data.traces[buf_ind];
+	} else {
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+		mutex_lock(&hardstall_data.read_lock);
+
+		buf_ind = ACCESS_ONCE(hardstall_data.read_ind);
+		lock = &hardstall_data.locks[buf_ind];
+		trace = &hardstall_data.traces[buf_ind];
+#endif
+	}
+
+	end = trace->nr_entries;
+	/* don't bother printing the trailing value */
+	if (end < trace->max_entries)
+		end--;
+
+	raw_spin_lock(lock); /* excludes writers */
+	for (i = 0; i < end; i++) {
+		seq_printf(f, "[<%pK>] %pS\n", (void *)trace->entries[i],
+				(void *)trace->entries[i]);
+	}
+	raw_spin_unlock(lock);
+
+	if (type == STALL_SOFT)
+		mutex_unlock(&softstall_data.read_lock);
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+	else
+		mutex_unlock(&hardstall_data.read_lock);
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
+void init_stall_data(struct stall_data *data)
+{
+	data->traces[0].nr_entries = 0;
+	data->traces[0].max_entries = STALL_MAX_TRACE_DEPTH;
+	data->traces[0].skip = 0;
+	data->traces[0].entries = data->trace_entries;
+	data->traces[1].nr_entries = 0;
+	data->traces[1].max_entries = STALL_MAX_TRACE_DEPTH;
+	data->traces[1].skip = 0;
+	data->traces[1].entries = data->trace_entries
+		+ STALL_MAX_TRACE_DEPTH;
+
+	raw_spin_lock_init(&data->locks[0]);
+	raw_spin_lock_init(&data->locks[1]);
+	raw_spin_lock_init(&data->write_lock);
+	mutex_init(&data->read_lock);
+	data->read_ind = 0;
+}
+
 void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
@@ -678,5 +812,41 @@ void __init lockup_detector_init(void)
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
+	init_stall_data(&softstall_data);
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+	init_stall_data(&hardstall_data);
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

