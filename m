Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1HDVsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:48:35 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:40805 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab1HDVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:48:30 -0400
From: Alex Neronskiy <zakmagnus@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>,
        Alex Neronskiy <zakmagnus@chromium.org>
Subject: [PATCH v3 2/2] Output stall traces in /proc
Date: Thu,  4 Aug 2011 14:48:06 -0700
Message-Id: <1312494486-26119-2-git-send-email-zakmagnus@chromium.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1312494486-26119-1-git-send-email-zakmagnus@chromium.com>
References: <1312494486-26119-1-git-send-email-zakmagnus@chromium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using the log, use files in /proc for trace output.
Printing to the log can result in watchdog touches, distorting the
very events being measured. Additionally, the information will not
distract from lockups when users view the log.

Signed-off-by: Alex Neronskiy <zakmagnus@chromium.org>
---
 kernel/watchdog.c |  107 ++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 86 insertions(+), 21 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 8dd9ed4..9cdc6bb 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -23,13 +23,24 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
+#include <linux/stacktrace.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
 
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
 
+#define STALL_MAX_TRACE_DEPTH 50
 int watchdog_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
 unsigned long worst_softstall;
+static unsigned long softstall_trace_entries[STALL_MAX_TRACE_DEPTH];
+static struct stack_trace softstall_trace = {
+	.nr_entries = 0,
+	.max_entries = STALL_MAX_TRACE_DEPTH,
+	.entries = softstall_trace_entries,
+	.skip = 0
+};
 static DEFINE_SPINLOCK(softstall_lock);
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
@@ -46,6 +57,13 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_missed);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 
 unsigned long worst_hardstall;
+static unsigned long hardstall_trace_entries[STALL_MAX_TRACE_DEPTH];
+static struct stack_trace hardstall_trace = {
+	.nr_entries = 0,
+	.max_entries = STALL_MAX_TRACE_DEPTH,
+	.entries = hardstall_trace_entries,
+	.skip = 0
+};
 static DEFINE_SPINLOCK(hardstall_lock);
 
 /* The number of consecutive hard check failures before it's a lockup */
@@ -210,23 +228,16 @@ void touch_softlockup_watchdog_sync(void)
 /* watchdog detector functions */
 static void update_hardstall(unsigned long stall, int this_cpu)
 {
-	int update_stall = 0;
-
 	if (stall > hardstall_thresh && stall > worst_hardstall) {
 		unsigned long flags;
 		spin_lock_irqsave(&hardstall_lock, flags);
-		update_stall = stall > worst_hardstall;
-		if (update_stall)
+		if (stall > worst_hardstall) {
 			worst_hardstall = stall;
+			hardstall_trace.nr_entries = 0;
+			save_stack_trace(&hardstall_trace);
+		}
 		spin_unlock_irqrestore(&hardstall_lock, flags);
 	}
-
-	if (update_stall) {
-		printk(KERN_WARNING "LOCKUP may be in progress!"
-			"Worst hard stall seen on CPU#%d: %lu interrupts missed\n",
-			this_cpu, stall);
-		dump_stack();
-	}
 }
 
 static int is_hardlockup(int this_cpu)
@@ -252,23 +263,17 @@ static int is_hardlockup(int this_cpu)
 
 static void update_softstall(unsigned long stall, int this_cpu)
 {
-	int update_stall = 0;
 	if (stall > get_softstall_thresh() &&
 			stall > worst_softstall + softstall_diff_thresh) {
 		unsigned long flags;
 		spin_lock_irqsave(&softstall_lock, flags);
-		update_stall = stall > worst_softstall + softstall_diff_thresh;
-		if (update_stall)
+		if (stall > worst_softstall + softstall_diff_thresh) {
 			worst_softstall = stall;
+			softstall_trace.nr_entries = 0;
+			save_stack_trace(&softstall_trace);
+		}
 		spin_unlock_irqrestore(&softstall_lock, flags);
 	}
-
-	if (update_stall) {
-		printk(KERN_WARNING "LOCKUP may be in progress!"
-				"Worst soft stall seen on CPU#%d: %lums\n",
-				this_cpu, stall);
-		dump_stack();
-	}
 }
 
 static int is_softlockup(unsigned long touch_ts, int this_cpu)
@@ -667,10 +672,63 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
+static int show_stall_trace(struct seq_file *f, void *v)
+{
+	int i, end;
+	struct stack_trace *trace = f->private;
+	spinlock_t *lock;
+	unsigned long flags;
+
+	if (trace == &softstall_trace)
+		lock = &softstall_lock;
+	else
+		lock = &hardstall_lock;
+
+	end = trace->nr_entries;
+	/* don't bother printing the trailing value */
+	if (end < trace->max_entries)
+		end--;
+
+	spin_lock_irqsave(lock, flags);
+	for (i = 0; i < end; i++) {
+		seq_printf(f, "[<%pK>] %pS\n", (void *)trace->entries[i],
+				(void *)trace->entries[i]);
+	}
+	spin_unlock_irqrestore(lock, flags);
+
+	return 0;
+}
+
+static int softstall_trace_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_stall_trace, &softstall_trace);
+}
+
+static int hardstall_trace_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_stall_trace, &hardstall_trace);
+}
+
+static struct file_operations softstall_trace_ops = {
+	.open = softstall_trace_open,
+	.read = seq_read,
+	.write = seq_write,
+	.llseek = seq_lseek,
+	.release = seq_release
+};
+static struct file_operations hardstall_trace_ops = {
+	.open = hardstall_trace_open,
+	.read = seq_read,
+	.write = seq_write,
+	.llseek = seq_lseek,
+	.release = seq_release
+};
+
 void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
+	struct proc_dir_entry *entry;
 
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 	WARN_ON(notifier_to_errno(err));
@@ -678,5 +736,12 @@ void __init lockup_detector_init(void)
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
+	entry = create_proc_entry("softstall_trace", 0444, NULL);
+	if (entry)
+		entry->proc_fops = &softstall_trace_ops;
+	entry = create_proc_entry("hardstall_trace", 0444, NULL);
+	if (entry)
+		entry->proc_fops = &hardstall_trace_ops;
+
 	return;
 }
-- 
1.7.3.1

