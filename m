Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0FBIyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:54:18 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:59184 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab0FBIxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:53:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 3/9] PM / Hibernate: user, implement user_ops writer
Date: Wed,  2 Jun 2010 10:52:42 +0200
Message-Id: <1275468768-28229-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch /dev/snapshot writer to hibernate_io_ops approach so that we
can do whatever we want with snapshot processing code. All the later
code changes will be transparent and needn't care about different
readers/writers.

In this patch only writer is implemented -- for better bisectability
if something breaks. (The development was easier too, because one
could break only one part, not both.)

Also, when using this interface, switch to the ops on open/release,
so they are used.

There are explicit barriers protecting to_do_buffer, because it is
all done in a producer-consumer fashion:
PRODUCER (snapshot layer)
1) to_do_buffer is set
2) set TODO bit
3) wake CONSUMER
4) wait for TODO bit _clear_

CONSUMER (fops->read)
1) wait for TODO bit
2) pass to_do_buffer to userspace
3) clear TODO bit
4) wake PRODUCER

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/user.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 132 insertions(+), 8 deletions(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index e819e17..b4610c3 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -23,6 +23,8 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/mutex.h>
+#include <linux/wait.h>
 #include <scsi/scsi_scan.h>
 
 #include <asm/uaccess.h>
@@ -61,10 +63,93 @@ static struct snapshot_data {
 	char frozen;
 	char ready;
 	char platform_support;
+	struct hibernate_io_ops *prev_ops;
 } snapshot_state;
 
 atomic_t snapshot_device_available = ATOMIC_INIT(1);
 
+static struct {
+	void *buffer; /* buffer to pass through */
+	struct workqueue_struct *worker; /* the thread initiating read/write */
+	wait_queue_head_t wait; /* wait for buffer */
+	wait_queue_head_t done; /* read/write done? */
+	struct mutex lock; /* protection for buffer */
+
+#define TODO_WORK	1
+#define TODO_FINISH	2
+#define TODO_CLOSED	3
+#define TODO_ERROR	4
+	DECLARE_BITMAP(flags, 10); /* TODO_* flags defined above */
+} to_do;
+
+static unsigned long user_free_space(void)
+{
+	return ~0UL; /* we have no idea, maybe we will fail later */
+}
+
+static struct hibernate_io_handle *user_writer_start(void)
+{
+	return hib_io_handle_alloc(0) ? : ERR_PTR(-ENOMEM);
+}
+
+static int user_write_page(struct hibernate_io_handle *io_handle, void *buf,
+		struct bio **bio_chain)
+{
+	int err = 0;
+
+	if (test_bit(TODO_CLOSED, to_do.flags))
+		return -EIO;
+
+	mutex_lock(&to_do.lock);
+	to_do.buffer = buf;
+	mutex_unlock(&to_do.lock);
+	set_bit(TODO_WORK, to_do.flags);
+	wake_up_interruptible(&to_do.wait);
+
+	wait_event(to_do.done, !test_bit(TODO_WORK, to_do.flags) ||
+			(err = test_bit(TODO_CLOSED, to_do.flags)));
+
+	return err ? -EIO : 0;
+}
+
+static int user_writer_finish(struct hibernate_io_handle *io_handle,
+		unsigned int flags, int error)
+{
+	int err = 0;
+
+	if (error)
+		set_bit(TODO_ERROR, to_do.flags);
+	set_bit(TODO_FINISH, to_do.flags);
+	wake_up_interruptible(&to_do.wait);
+
+	wait_event(to_do.done, !test_bit(TODO_FINISH, to_do.flags) ||
+			(err = test_bit(TODO_CLOSED, to_do.flags)));
+
+	if (!error && err)
+		error = -EIO;
+
+	return error;
+}
+
+struct hibernate_io_ops user_ops = {
+	.free_space = user_free_space,
+
+	.writer_start = user_writer_start,
+	.writer_finish = user_writer_finish,
+	.write_page = user_write_page,
+};
+
+static void snapshot_writer(struct work_struct *work)
+{
+	int ret;
+
+	ret = swsusp_write(0);
+	if (ret)
+		printk(KERN_ERR "PM: write failed with %d\n", ret);
+}
+
+static DECLARE_WORK(snapshot_writer_w, snapshot_writer);
+
 static int snapshot_open(struct inode *inode, struct file *filp)
 {
 	struct snapshot_data *data;
@@ -115,9 +200,17 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	}
 	if (error)
 		atomic_inc(&snapshot_device_available);
+	else {
+		data->prev_ops = hibernate_io_ops;
+		hibernate_io_ops = &user_ops;
+	}
 	data->frozen = 0;
 	data->ready = 0;
 	data->platform_support = 0;
+	memset(to_do.flags, 0, sizeof(*to_do.flags));
+	init_waitqueue_head(&to_do.wait);
+	init_waitqueue_head(&to_do.done);
+	mutex_init(&to_do.lock);
 
  Unlock:
 	mutex_unlock(&pm_mutex);
@@ -131,6 +224,10 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 
 	mutex_lock(&pm_mutex);
 
+	set_bit(TODO_CLOSED, to_do.flags);
+	wake_up(&to_do.done);
+	flush_workqueue(to_do.worker);
+
 	swsusp_free();
 	free_basic_memory_bitmaps();
 	data = filp->private_data;
@@ -139,6 +236,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 		thaw_processes();
 	pm_notifier_call_chain(data->mode == O_WRONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
+	hibernate_io_ops = data->prev_ops;
 	atomic_inc(&snapshot_device_available);
 
 	mutex_unlock(&pm_mutex);
@@ -152,6 +250,7 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 	struct snapshot_data *data;
 	ssize_t res;
 	loff_t pg_offp = *offp & ~PAGE_MASK;
+	int fin = 0;
 
 	mutex_lock(&pm_mutex);
 
@@ -161,18 +260,31 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 		goto Unlock;
 	}
 	if (!pg_offp) { /* on page boundary? */
-		res = snapshot_read_next(&data->handle);
-		if (res <= 0)
+		res = wait_event_interruptible(to_do.wait,
+			test_bit(TODO_WORK, to_do.flags) ||
+			(fin = test_and_clear_bit(TODO_FINISH, to_do.flags)));
+		if (res)
 			goto Unlock;
-	} else {
-		res = PAGE_SIZE - pg_offp;
+		if (test_bit(TODO_ERROR, to_do.flags)) {
+			res = -EIO;
+			goto Unlock;
+		}
+		if (fin)
+			goto wake;
 	}
+	res = PAGE_SIZE - pg_offp;
 
-	res = simple_read_from_buffer(buf, count, &pg_offp,
-			data_of(data->handle), res);
+	mutex_lock(&to_do.lock);
+	res = simple_read_from_buffer(buf, count, &pg_offp, to_do.buffer, res);
+	mutex_unlock(&to_do.lock);
 	if (res > 0)
 		*offp += res;
 
+	if (!(pg_offp & ~PAGE_MASK)) {
+		clear_bit(TODO_WORK, to_do.flags);
+wake:
+		wake_up(&to_do.done);
+	}
  Unlock:
 	mutex_unlock(&pm_mutex);
 
@@ -278,8 +390,11 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		error = hibernation_snapshot(data->platform_support);
 		if (!error)
 			error = put_user(in_suspend, (int __user *)arg);
-		if (!error)
+		if (!error) {
+			if (in_suspend)
+				queue_work(to_do.worker, &snapshot_writer_w);
 			data->ready = 1;
+		}
 		break;
 
 	case SNAPSHOT_ATOMIC_RESTORE:
@@ -473,7 +588,16 @@ static struct miscdevice snapshot_device = {
 
 static int __init snapshot_device_init(void)
 {
-	return misc_register(&snapshot_device);
+	int ret;
+
+	to_do.worker = create_singlethread_workqueue("suspend_worker");
+	if (!to_do.worker)
+		return -ENOMEM;
+
+	ret = misc_register(&snapshot_device);
+	if (ret)
+		destroy_workqueue(to_do.worker);
+	return ret;
 };
 
 device_initcall(snapshot_device_init);
-- 
1.7.1


