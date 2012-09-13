Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab2IMOjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:39:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34642 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab2IMOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:39:38 -0400
Date: Thu, 13 Sep 2012 16:39:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120913143907.GA16307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: e4390fa632d7c592e68e8106b7daea923ac995f5 Merge branch 'urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile into perf/urgent

This tree includes various fixes.

 Thanks,

	Ingo

------------------>
Al Viro (1):
      perf_event: Switch to internal refcount, fix race with close()

K.Prasad (1):
      perf/hwpb: Invoke __perf_event_disable() if interrupts are already disabled

Robert Richter (1):
      oprofile, s390: Fix uninitialized memory access when writing to oprofilefs

Stephane Eranian (2):
      perf/x86: Fix microcode revision check for SNB-PEBS
      perf/x86: Enable Intel Cedarview Atom suppport


 arch/s390/oprofile/init.c                  | 10 ++---
 arch/x86/kernel/cpu/perf_event_intel.c     |  1 +
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  3 +-
 arch/x86/kernel/microcode_core.c           |  3 ++
 include/linux/perf_event.h                 |  4 +-
 kernel/events/core.c                       | 64 ++++++++++++++++--------------
 kernel/events/hw_breakpoint.c              | 11 ++++-
 7 files changed, 58 insertions(+), 38 deletions(-)

diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index a1e9d69..584b936 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -169,7 +169,7 @@ static ssize_t hw_interval_write(struct file *file, char const __user *buf,
 	if (*offset)
 		return -EINVAL;
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 	if (val < oprofile_min_interval)
 		oprofile_hw_interval = oprofile_min_interval;
@@ -212,7 +212,7 @@ static ssize_t hwsampler_zero_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 	if (val != 0)
 		return -EINVAL;
@@ -243,7 +243,7 @@ static ssize_t hwsampler_kernel_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (val != 0 && val != 1)
@@ -278,7 +278,7 @@ static ssize_t hwsampler_user_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (val != 0 && val != 1)
@@ -317,7 +317,7 @@ static ssize_t timer_enabled_write(struct file *file, char const __user *buf,
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (val != 0 && val != 1)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 7f2739e..0d3d63a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2008,6 +2008,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 28: /* Atom */
+	case 54: /* Cedariew */
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 520b426..da02e9c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -686,7 +686,8 @@ void intel_pmu_lbr_init_atom(void)
 	 * to have an operational LBR which can freeze
 	 * on PMU interrupt
 	 */
-	if (boot_cpu_data.x86_mask < 10) {
+	if (boot_cpu_data.x86_model == 28
+	    && boot_cpu_data.x86_mask < 10) {
 		pr_cont("LBR disabled due to erratum");
 		return;
 	}
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 4873e62..9e5bcf1 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -225,6 +225,9 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 	if (do_microcode_update(buf, len) == 0)
 		ret = (ssize_t)len;
 
+	if (ret > 0)
+		perf_check_microcode();
+
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7602ccb..33ed9d6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -926,7 +926,7 @@ struct perf_event {
 	struct hw_perf_event		hw;
 
 	struct perf_event_context	*ctx;
-	struct file			*filp;
+	atomic_long_t			refcount;
 
 	/*
 	 * These accumulate total time (in nanoseconds) that children
@@ -1296,6 +1296,7 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
 #else
 static inline void
@@ -1334,6 +1335,7 @@ static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
+static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
 #endif
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b7935fc..7fee567 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1253,7 +1253,7 @@ retry:
 /*
  * Cross CPU call to disable a performance event
  */
-static int __perf_event_disable(void *info)
+int __perf_event_disable(void *info)
 {
 	struct perf_event *event = info;
 	struct perf_event_context *ctx = event->ctx;
@@ -2935,12 +2935,12 @@ EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 /*
  * Called when the last reference to the file is gone.
  */
-static int perf_release(struct inode *inode, struct file *file)
+static void put_event(struct perf_event *event)
 {
-	struct perf_event *event = file->private_data;
 	struct task_struct *owner;
 
-	file->private_data = NULL;
+	if (!atomic_long_dec_and_test(&event->refcount))
+		return;
 
 	rcu_read_lock();
 	owner = ACCESS_ONCE(event->owner);
@@ -2975,7 +2975,13 @@ static int perf_release(struct inode *inode, struct file *file)
 		put_task_struct(owner);
 	}
 
-	return perf_event_release_kernel(event);
+	perf_event_release_kernel(event);
+}
+
+static int perf_release(struct inode *inode, struct file *file)
+{
+	put_event(file->private_data);
+	return 0;
 }
 
 u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
@@ -3227,7 +3233,7 @@ unlock:
 
 static const struct file_operations perf_fops;
 
-static struct perf_event *perf_fget_light(int fd, int *fput_needed)
+static struct file *perf_fget_light(int fd, int *fput_needed)
 {
 	struct file *file;
 
@@ -3241,7 +3247,7 @@ static struct perf_event *perf_fget_light(int fd, int *fput_needed)
 		return ERR_PTR(-EBADF);
 	}
 
-	return file->private_data;
+	return file;
 }
 
 static int perf_event_set_output(struct perf_event *event,
@@ -3273,19 +3279,21 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	case PERF_EVENT_IOC_SET_OUTPUT:
 	{
+		struct file *output_file = NULL;
 		struct perf_event *output_event = NULL;
 		int fput_needed = 0;
 		int ret;
 
 		if (arg != -1) {
-			output_event = perf_fget_light(arg, &fput_needed);
-			if (IS_ERR(output_event))
-				return PTR_ERR(output_event);
+			output_file = perf_fget_light(arg, &fput_needed);
+			if (IS_ERR(output_file))
+				return PTR_ERR(output_file);
+			output_event = output_file->private_data;
 		}
 
 		ret = perf_event_set_output(event, output_event);
 		if (output_event)
-			fput_light(output_event->filp, fput_needed);
+			fput_light(output_file, fput_needed);
 
 		return ret;
 	}
@@ -5950,6 +5958,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	mutex_init(&event->mmap_mutex);
 
+	atomic_long_set(&event->refcount, 1);
 	event->cpu		= cpu;
 	event->attr		= *attr;
 	event->group_leader	= group_leader;
@@ -6260,12 +6269,12 @@ SYSCALL_DEFINE5(perf_event_open,
 		return event_fd;
 
 	if (group_fd != -1) {
-		group_leader = perf_fget_light(group_fd, &fput_needed);
-		if (IS_ERR(group_leader)) {
-			err = PTR_ERR(group_leader);
+		group_file = perf_fget_light(group_fd, &fput_needed);
+		if (IS_ERR(group_file)) {
+			err = PTR_ERR(group_file);
 			goto err_fd;
 		}
-		group_file = group_leader->filp;
+		group_leader = group_file->private_data;
 		if (flags & PERF_FLAG_FD_OUTPUT)
 			output_event = group_leader;
 		if (flags & PERF_FLAG_FD_NO_GROUP)
@@ -6402,7 +6411,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		put_ctx(gctx);
 	}
 
-	event->filp = event_file;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 
@@ -6496,7 +6504,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err_free;
 	}
 
-	event->filp = NULL;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
@@ -6578,7 +6585,7 @@ static void sync_child_event(struct perf_event *child_event,
 	 * Release the parent event, if this was the last
 	 * reference to it.
 	 */
-	fput(parent_event->filp);
+	put_event(parent_event);
 }
 
 static void
@@ -6654,9 +6661,8 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 *
 	 *   __perf_event_exit_task()
 	 *     sync_child_event()
-	 *       fput(parent_event->filp)
-	 *         perf_release()
-	 *           mutex_lock(&ctx->mutex)
+	 *       put_event()
+	 *         mutex_lock(&ctx->mutex)
 	 *
 	 * But since its the parent context it won't be the same instance.
 	 */
@@ -6724,7 +6730,7 @@ static void perf_free_event(struct perf_event *event,
 	list_del_init(&event->child_list);
 	mutex_unlock(&parent->child_mutex);
 
-	fput(parent->filp);
+	put_event(parent);
 
 	perf_group_detach(event);
 	list_del_event(event, ctx);
@@ -6804,6 +6810,12 @@ inherit_event(struct perf_event *parent_event,
 				           NULL, NULL);
 	if (IS_ERR(child_event))
 		return child_event;
+
+	if (!atomic_long_inc_not_zero(&parent_event->refcount)) {
+		free_event(child_event);
+		return NULL;
+	}
+
 	get_ctx(child_ctx);
 
 	/*
@@ -6845,14 +6857,6 @@ inherit_event(struct perf_event *parent_event,
 	raw_spin_unlock_irqrestore(&child_ctx->lock, flags);
 
 	/*
-	 * Get a reference to the parent filp - we will fput it
-	 * when the child event exits. This is safe to do because
-	 * we are in the parent and we know that the filp still
-	 * exists and has a nonzero count:
-	 */
-	atomic_long_inc(&parent_event->filp->f_count);
-
-	/*
 	 * Link this into the parent event's child list
 	 */
 	WARN_ON_ONCE(parent_event->ctx->parent_ctx);
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index bb38c4d..9a7b487 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -453,7 +453,16 @@ int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *att
 	int old_type = bp->attr.bp_type;
 	int err = 0;
 
-	perf_event_disable(bp);
+	/*
+	 * modify_user_hw_breakpoint can be invoked with IRQs disabled and hence it
+	 * will not be possible to raise IPIs that invoke __perf_event_disable.
+	 * So call the function directly after making sure we are targeting the
+	 * current task.
+	 */
+	if (irqs_disabled() && bp->ctx && bp->ctx->task == current)
+		__perf_event_disable(bp);
+	else
+		perf_event_disable(bp);
 
 	bp->attr.bp_addr = attr->bp_addr;
 	bp->attr.bp_type = attr->bp_type;
