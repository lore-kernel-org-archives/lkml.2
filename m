Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab0EaHTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:19:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:44355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab0EaHTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:19:39 -0400
Date: Mon, 31 May 2010 07:19:11 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix races and clean up perf_event and perf_mmap_data interaction
Message-ID: <tip-ac9721f3f54b27a16c7e1afb2481e7ee95a70318@git.kernel.org>
Git-Commit-ID: ac9721f3f54b27a16c7e1afb2481e7ee95a70318
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 07:19:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac9721f3f54b27a16c7e1afb2481e7ee95a70318
Gitweb:     http://git.kernel.org/tip/ac9721f3f54b27a16c7e1afb2481e7ee95a70318
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 27 May 2010 12:54:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 May 2010 08:46:08 +0200

perf_events: Fix races and clean up perf_event and perf_mmap_data interaction

In order to move toward separate buffer objects, rework the whole
perf_mmap_data construct to be a more self-sufficient entity, one
with its own lifetime rules.

This greatly sanitizes the whole output redirection code, which
was riddled with bugs and races.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    5 +-
 kernel/perf_event.c        |  224 +++++++++++++++++++++++++-------------------
 2 files changed, 129 insertions(+), 100 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fb6c91e..4906985 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -585,6 +585,7 @@ enum perf_event_active_state {
 struct file;
 
 struct perf_mmap_data {
+	atomic_t			refcount;
 	struct rcu_head			rcu_head;
 #ifdef CONFIG_PERF_USE_VMALLOC
 	struct work_struct		work;
@@ -592,7 +593,6 @@ struct perf_mmap_data {
 #endif
 	int				nr_pages;	/* nr of data pages  */
 	int				writable;	/* are we writable   */
-	int				nr_locked;	/* nr pages mlocked  */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
 
@@ -643,7 +643,6 @@ struct perf_event {
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
-	struct perf_event		*output;
 	const struct pmu		*pmu;
 
 	enum perf_event_active_state	state;
@@ -704,6 +703,8 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
+	int				mmap_locked;
+	struct user_struct		*mmap_user;
 	struct perf_mmap_data		*data;
 
 	/* poll related */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index bd7ce8c..848d49a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1841,6 +1841,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void perf_pending_sync(struct perf_event *event);
+static void perf_mmap_data_put(struct perf_mmap_data *data);
 
 static void free_event(struct perf_event *event)
 {
@@ -1856,9 +1857,9 @@ static void free_event(struct perf_event *event)
 			atomic_dec(&nr_task_events);
 	}
 
-	if (event->output) {
-		fput(event->output->filp);
-		event->output = NULL;
+	if (event->data) {
+		perf_mmap_data_put(event->data);
+		event->data = NULL;
 	}
 
 	if (event->destroy)
@@ -2175,7 +2176,27 @@ unlock:
 	return ret;
 }
 
-static int perf_event_set_output(struct perf_event *event, int output_fd);
+static const struct file_operations perf_fops;
+
+static struct perf_event *perf_fget_light(int fd, int *fput_needed)
+{
+	struct file *file;
+
+	file = fget_light(fd, fput_needed);
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	if (file->f_op != &perf_fops) {
+		fput_light(file, *fput_needed);
+		*fput_needed = 0;
+		return ERR_PTR(-EBADF);
+	}
+
+	return file->private_data;
+}
+
+static int perf_event_set_output(struct perf_event *event,
+				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -2202,7 +2223,23 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return perf_event_period(event, (u64 __user *)arg);
 
 	case PERF_EVENT_IOC_SET_OUTPUT:
-		return perf_event_set_output(event, arg);
+	{
+		struct perf_event *output_event = NULL;
+		int fput_needed = 0;
+		int ret;
+
+		if (arg != -1) {
+			output_event = perf_fget_light(arg, &fput_needed);
+			if (IS_ERR(output_event))
+				return PTR_ERR(output_event);
+		}
+
+		ret = perf_event_set_output(event, output_event);
+		if (output_event)
+			fput_light(output_event->filp, fput_needed);
+
+		return ret;
+	}
 
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
@@ -2335,8 +2372,6 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 	unsigned long size;
 	int i;
 
-	WARN_ON(atomic_read(&event->mmap_count));
-
 	size = sizeof(struct perf_mmap_data);
 	size += nr_pages * sizeof(void *);
 
@@ -2452,8 +2487,6 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 	unsigned long size;
 	void *all_buf;
 
-	WARN_ON(atomic_read(&event->mmap_count));
-
 	size = sizeof(struct perf_mmap_data);
 	size += sizeof(void *);
 
@@ -2536,7 +2569,7 @@ perf_mmap_data_init(struct perf_event *event, struct perf_mmap_data *data)
 	if (!data->watermark)
 		data->watermark = max_size / 2;
 
-
+	atomic_set(&data->refcount, 1);
 	rcu_assign_pointer(event->data, data);
 }
 
@@ -2548,13 +2581,26 @@ static void perf_mmap_data_free_rcu(struct rcu_head *rcu_head)
 	perf_mmap_data_free(data);
 }
 
-static void perf_mmap_data_release(struct perf_event *event)
+static struct perf_mmap_data *perf_mmap_data_get(struct perf_event *event)
 {
-	struct perf_mmap_data *data = event->data;
+	struct perf_mmap_data *data;
+
+	rcu_read_lock();
+	data = rcu_dereference(event->data);
+	if (data) {
+		if (!atomic_inc_not_zero(&data->refcount))
+			data = NULL;
+	}
+	rcu_read_unlock();
+
+	return data;
+}
 
-	WARN_ON(atomic_read(&event->mmap_count));
+static void perf_mmap_data_put(struct perf_mmap_data *data)
+{
+	if (!atomic_dec_and_test(&data->refcount))
+		return;
 
-	rcu_assign_pointer(event->data, NULL);
 	call_rcu(&data->rcu_head, perf_mmap_data_free_rcu);
 }
 
@@ -2569,15 +2615,18 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	WARN_ON_ONCE(event->ctx->parent_ctx);
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
 		unsigned long size = perf_data_size(event->data);
-		struct user_struct *user = current_user();
+		struct user_struct *user = event->mmap_user;
+		struct perf_mmap_data *data = event->data;
 
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
-		vma->vm_mm->locked_vm -= event->data->nr_locked;
-		perf_mmap_data_release(event);
+		vma->vm_mm->locked_vm -= event->mmap_locked;
+		rcu_assign_pointer(event->data, NULL);
 		mutex_unlock(&event->mmap_mutex);
+
+		perf_mmap_data_put(data);
+		free_uid(user);
 	}
 }
 
@@ -2629,13 +2678,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	mutex_lock(&event->mmap_mutex);
-	if (event->output) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	if (atomic_inc_not_zero(&event->mmap_count)) {
-		if (nr_pages != event->data->nr_pages)
+	if (event->data) {
+		if (event->data->nr_pages == nr_pages)
+			atomic_inc(&event->data->refcount);
+		else
 			ret = -EINVAL;
 		goto unlock;
 	}
@@ -2667,21 +2713,23 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	WARN_ON(event->data);
 
 	data = perf_mmap_data_alloc(event, nr_pages);
-	ret = -ENOMEM;
-	if (!data)
+	if (!data) {
+		ret = -ENOMEM;
 		goto unlock;
+	}
 
-	ret = 0;
 	perf_mmap_data_init(event, data);
-
-	atomic_set(&event->mmap_count, 1);
-	atomic_long_add(user_extra, &user->locked_vm);
-	vma->vm_mm->locked_vm += extra;
-	event->data->nr_locked = extra;
 	if (vma->vm_flags & VM_WRITE)
 		event->data->writable = 1;
 
+	atomic_long_add(user_extra, &user->locked_vm);
+	event->mmap_locked = extra;
+	event->mmap_user = get_current_user();
+	vma->vm_mm->locked_vm += event->mmap_locked;
+
 unlock:
+	if (!ret)
+		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
 	vma->vm_flags |= VM_RESERVED;
@@ -2993,7 +3041,6 @@ int perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size,
 		      int nmi, int sample)
 {
-	struct perf_event *output_event;
 	struct perf_mmap_data *data;
 	unsigned long tail, offset, head;
 	int have_lost;
@@ -3010,10 +3057,6 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (event->parent)
 		event = event->parent;
 
-	output_event = rcu_dereference(event->output);
-	if (output_event)
-		event = output_event;
-
 	data = rcu_dereference(event->data);
 	if (!data)
 		goto out;
@@ -4912,39 +4955,17 @@ err_size:
 	goto out;
 }
 
-static int perf_event_set_output(struct perf_event *event, int output_fd)
+static int
+perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct perf_event *output_event = NULL;
-	struct file *output_file = NULL;
-	struct perf_event *old_output;
-	int fput_needed = 0;
+	struct perf_mmap_data *data = NULL, *old_data = NULL;
 	int ret = -EINVAL;
 
-	/*
-	 * Don't allow output of inherited per-task events. This would
-	 * create performance issues due to cross cpu access.
-	 */
-	if (event->cpu == -1 && event->attr.inherit)
-		return -EINVAL;
-
-	if (!output_fd)
+	if (!output_event)
 		goto set;
 
-	output_file = fget_light(output_fd, &fput_needed);
-	if (!output_file)
-		return -EBADF;
-
-	if (output_file->f_op != &perf_fops)
-		goto out;
-
-	output_event = output_file->private_data;
-
-	/* Don't chain output fds */
-	if (output_event->output)
-		goto out;
-
-	/* Don't set an output fd when we already have an output channel */
-	if (event->data)
+	/* don't allow circular references */
+	if (event == output_event)
 		goto out;
 
 	/*
@@ -4959,26 +4980,28 @@ static int perf_event_set_output(struct perf_event *event, int output_fd)
 	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
 		goto out;
 
-	atomic_long_inc(&output_file->f_count);
-
 set:
 	mutex_lock(&event->mmap_mutex);
-	old_output = event->output;
-	rcu_assign_pointer(event->output, output_event);
-	mutex_unlock(&event->mmap_mutex);
+	/* Can't redirect output if we've got an active mmap() */
+	if (atomic_read(&event->mmap_count))
+		goto unlock;
 
-	if (old_output) {
-		/*
-		 * we need to make sure no existing perf_output_*()
-		 * is still referencing this event.
-		 */
-		synchronize_rcu();
-		fput(old_output->filp);
+	if (output_event) {
+		/* get the buffer we want to redirect to */
+		data = perf_mmap_data_get(output_event);
+		if (!data)
+			goto unlock;
 	}
 
+	old_data = event->data;
+	rcu_assign_pointer(event->data, data);
 	ret = 0;
+unlock:
+	mutex_unlock(&event->mmap_mutex);
+
+	if (old_data)
+		perf_mmap_data_put(old_data);
 out:
-	fput_light(output_file, fput_needed);
 	return ret;
 }
 
@@ -4994,7 +5017,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		struct perf_event_attr __user *, attr_uptr,
 		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
 {
-	struct perf_event *event, *group_leader;
+	struct perf_event *event, *group_leader = NULL, *output_event = NULL;
 	struct perf_event_attr attr;
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
@@ -5034,19 +5057,25 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_fd;
 	}
 
+	if (group_fd != -1) {
+		group_leader = perf_fget_light(group_fd, &fput_needed);
+		if (IS_ERR(group_leader)) {
+			err = PTR_ERR(group_leader);
+			goto err_put_context;
+		}
+		group_file = group_leader->filp;
+		if (flags & PERF_FLAG_FD_OUTPUT)
+			output_event = group_leader;
+		if (flags & PERF_FLAG_FD_NO_GROUP)
+			group_leader = NULL;
+	}
+
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
-	group_leader = NULL;
-	if (group_fd != -1 && !(flags & PERF_FLAG_FD_NO_GROUP)) {
+	if (group_leader) {
 		err = -EINVAL;
-		group_file = fget_light(group_fd, &fput_needed);
-		if (!group_file)
-			goto err_put_context;
-		if (group_file->f_op != &perf_fops)
-			goto err_put_context;
 
-		group_leader = group_file->private_data;
 		/*
 		 * Do not allow a recursive hierarchy (this new sibling
 		 * becoming part of another group-sibling):
@@ -5068,9 +5097,16 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	event = perf_event_alloc(&attr, cpu, ctx, group_leader,
 				     NULL, NULL, GFP_KERNEL);
-	err = PTR_ERR(event);
-	if (IS_ERR(event))
+	if (IS_ERR(event)) {
+		err = PTR_ERR(event);
 		goto err_put_context;
+	}
+
+	if (output_event) {
+		err = perf_event_set_output(event, output_event);
+		if (err)
+			goto err_free_put_context;
+	}
 
 	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event, O_RDWR);
 	if (IS_ERR(event_file)) {
@@ -5078,12 +5114,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_free_put_context;
 	}
 
-	if (flags & PERF_FLAG_FD_OUTPUT) {
-		err = perf_event_set_output(event, group_fd);
-		if (err)
-			goto err_fput_free_put_context;
-	}
-
 	event->filp = event_file;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
@@ -5101,8 +5131,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	fd_install(event_fd, event_file);
 	return event_fd;
 
-err_fput_free_put_context:
-	fput(event_file);
 err_free_put_context:
 	free_event(event);
 err_put_context:
