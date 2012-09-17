Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2IQAvE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33431 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab2IQAtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:47 -0400
Message-Id: <20120917003638.951812245@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@ZenIV.linux.org.uk>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 092/135] perf_event: Switch to internal refcount, fix race with close()
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit a6fa941d94b411bbd2b6421ffbde6db3c93e65ab upstream.

Don't mess with file refcounts (or keep a reference to file, for
that matter) in perf_event.  Use explicit refcount of its own
instead.  Deal with the race between the final reference to event
going away and new children getting created for it by use of
atomic_long_inc_not_zero() in inherit_event(); just have the
latter free what it had allocated and return NULL, that works
out just fine (children of siblings of something doomed are
created as singletons, same as if the child of leader had been
created and immediately killed).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120820135925.GG23464@ZenIV.linux.org.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/perf_event.h |    2 +-
 kernel/events/core.c       |   62 +++++++++++++++++++++++---------------------
 2 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7602ccb..ad04dfc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -926,7 +926,7 @@ struct perf_event {
 	struct hw_perf_event		hw;
 
 	struct perf_event_context	*ctx;
-	struct file			*filp;
+	atomic_long_t			refcount;
 
 	/*
 	 * These accumulate total time (in nanoseconds) that children
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b7935fc..efef428 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
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


