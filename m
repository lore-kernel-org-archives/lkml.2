Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0CWQYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:24:16 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51610 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab0CWQXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:23:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC 09/15] PM / Hibernate: user, implement user_ops writer
Date: Tue, 23 Mar 2010 17:17:37 +0100
Message-Id: <1269361063-3341-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch /dev/snapshot writer to sws_module_ops approach so that we
can transparently rewrite the rest of the snapshot from pages pulling
to their pushing through layers.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/user.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 20bf34c..748567d 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -66,15 +66,82 @@ static struct snapshot_data {
 
 atomic_t snapshot_device_available = ATOMIC_INIT(1);
 
+static void *to_do_buf;
+static struct workqueue_struct *suspend_worker;
+static DECLARE_WAIT_QUEUE_HEAD(to_do_wait);
+static DECLARE_WAIT_QUEUE_HEAD(to_do_done);
+static DECLARE_BITMAP(to_do_flags, 10);
+
+#define TODO_WORK	1
+#define TODO_FINISH	2
+#define TODO_CLOSED	3
+#define TODO_ERROR	4
+
 static unsigned long user_storage_available(void)
 {
 	return ~0UL; /* we have no idea, maybe we will fail later */
 }
 
+static int get_user_writer(void)
+{
+	return 0;
+}
+
+static int user_write_page(void *buf, struct bio **bio_chain)
+{
+	int err = 0;
+
+	if (test_bit(TODO_CLOSED, to_do_flags))
+		return -EIO;
+
+	to_do_buf = buf;
+	wmb();
+	set_bit(TODO_WORK, to_do_flags);
+	wake_up_interruptible(&to_do_wait);
+
+	wait_event(to_do_done, !test_bit(TODO_WORK, to_do_flags) ||
+			(err = test_bit(TODO_CLOSED, to_do_flags)));
+
+	return err ? -EIO : 0;
+}
+
+static int put_user_writer(unsigned int flags, int error)
+{
+	int err = 0;
+
+	if (error)
+		set_bit(TODO_ERROR, to_do_flags);
+	set_bit(TODO_FINISH, to_do_flags);
+	wake_up_interruptible(&to_do_wait);
+
+	wait_event(to_do_done, !test_bit(TODO_FINISH, to_do_flags) ||
+			(err = test_bit(TODO_CLOSED, to_do_flags)));
+
+	if (!error && err)
+		error = -EIO;
+
+	return error;
+}
+
 struct sws_module_ops user_ops = {
 	.storage_available = user_storage_available,
+
+	.get_writer = get_user_writer,
+	.put_writer = put_user_writer,
+	.write_page = user_write_page,
 };
 
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
@@ -132,6 +199,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	data->frozen = 0;
 	data->ready = 0;
 	data->platform_support = 0;
+	memset(to_do_flags, 0, sizeof(*to_do_flags));
 
  Unlock:
 	mutex_unlock(&pm_mutex);
@@ -145,6 +213,10 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 
 	mutex_lock(&pm_mutex);
 
+	set_bit(TODO_CLOSED, to_do_flags);
+	wake_up(&to_do_done);
+	flush_workqueue(suspend_worker);
+
 	swsusp_free();
 	free_basic_memory_bitmaps();
 	data = filp->private_data;
@@ -167,6 +239,7 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 	struct snapshot_data *data;
 	ssize_t res;
 	loff_t pg_offp = *offp & ~PAGE_MASK;
+	int fin = 0;
 
 	mutex_lock(&pm_mutex);
 
@@ -176,17 +249,29 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 		goto Unlock;
 	}
 	if (!pg_offp) { /* on page boundary? */
-		res = snapshot_read_next(&data->handle);
-		if (res <= 0)
+		res = wait_event_interruptible(to_do_wait,
+			test_bit(TODO_WORK, to_do_flags) ||
+			(fin = test_and_clear_bit(TODO_FINISH, to_do_flags)));
+		if (res)
 			goto Unlock;
-	} else
-		res = PAGE_SIZE - pg_offp;
+		if (test_bit(TODO_ERROR, to_do_flags)) {
+			res = -EIO;
+			goto Unlock;
+		}
+		if (fin)
+			goto wake;
+	}
+	res = PAGE_SIZE - pg_offp;
 
-	res = simple_read_from_buffer(buf, count, &pg_offp,
-			data_of(data->handle), res);
+	res = simple_read_from_buffer(buf, count, &pg_offp, to_do_buf, res);
 	if (res > 0)
 		*offp += res;
 
+	if (!(pg_offp & ~PAGE_MASK)) {
+		clear_bit(TODO_WORK, to_do_flags);
+wake:
+		wake_up(&to_do_done);
+	}
  Unlock:
 	mutex_unlock(&pm_mutex);
 
@@ -291,8 +376,11 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		error = hibernation_snapshot(data->platform_support);
 		if (!error)
 			error = put_user(in_suspend, (int __user *)arg);
-		if (!error)
+		if (!error) {
+			if (in_suspend)
+				queue_work(suspend_worker, &snapshot_writer_w);
 			data->ready = 1;
+		}
 		break;
 
 	case SNAPSHOT_ATOMIC_RESTORE:
@@ -486,7 +574,16 @@ static struct miscdevice snapshot_device = {
 
 static int __init snapshot_device_init(void)
 {
-	return misc_register(&snapshot_device);
+	int ret;
+
+	suspend_worker = create_singlethread_workqueue("suspend_worker");
+	if (!suspend_worker)
+		return -ENOMEM;
+
+	ret = misc_register(&snapshot_device);
+	if (ret)
+		destroy_workqueue(suspend_worker);
+	return ret;
 };
 
 device_initcall(snapshot_device_init);
-- 
1.7.0.2


