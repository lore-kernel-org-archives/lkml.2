Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2BHDZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 22:25:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46654 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab2BHDZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 22:25:47 -0500
From: Che-Liang Chiou <clchiou@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: [PATCH 5/5] Input: serio_raw - implement debugfs interface
Date: Wed,  8 Feb 2012 11:24:57 +0800
Message-Id: <1328671497-20880-6-git-send-email-clchiou@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
References: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
In-Reply-To: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
References: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugfs interface has two modes, 'monitor' and 'replay'. The
'monitor' mode is on by default. Writing '1' to the replay debugfs entry
to enter 'replay' mode.

In monitor mode, a 'Monitor Process' can monitor traffic between a
userspace client and a serio device. The 'user' debugfs entry echoes
data written from userspace, and the 'device' debugfs entry echoes data
sent from the device.

  Userland driver <--->---+
                          |
                   /dev/serio_raw0
                          |
                 +--------+--------+
                 |                 |
                 v   /sys/kernel/debug/serio_raw0/user
                 |                 |
                 |                 v
                 |          Monitor Process
                 |                 ^
                 |                 |
                 ^   /sys/kernel/debug/serio_raw0/device
                 |                 |
  device <--->---+-----------------+

In replay mode, a 'Replay Process' sits in the middle of all traffics.
Note that the 'user' and 'device' debugfs entry are now operated in full
duplex mode.

  Userland driver <--->---+
                          |
                   /dev/serio_raw0
                          |
            /sys/kernel/debug/serio_raw0/user
                          ^
                          |
                          v
                    Replay Process
                          ^
                          |
                          v
            /sys/kernel/debug/serio_raw0/device
                          |
  device <--->------------+

Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
---
 drivers/input/serio/serio_raw.c |  152 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 149 insertions(+), 3 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 7b02691..5865103 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -37,7 +37,7 @@ struct queue {
 };
 
 struct serio_raw {
-	struct queue queue;
+	struct queue queue, debug_user, debug_device;
 
 	char name[16];
 	struct kref kref;
@@ -46,6 +46,7 @@ struct serio_raw {
 	struct list_head client_list;
 	struct list_head node;
 	bool dead;
+	bool debug_user_opened, debug_device_opened;
 	u32 replay;  /* not bool because debugfs_create_bool() takes u32 */
 
 	struct dentry *dentry;
@@ -320,8 +321,11 @@ static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
 {
 	struct serio_raw_client *client = file->private_data;
 	struct serio_raw *serio_raw = client->serio_raw;
+	struct queue *queue = serio_raw->debug_user_opened ?
+			&serio_raw->debug_user : NULL;
 
-	return serio_raw_write_mainloop(serio_raw, buffer, count, true, NULL);
+	return serio_raw_write_mainloop(serio_raw, buffer, count,
+			!serio_raw->replay, queue);
 }
 
 static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
@@ -349,10 +353,144 @@ static const struct file_operations serio_raw_fops = {
  *             Interface with debugfs (file operations)              *
  *********************************************************************/
 
+static int debug_user_open(struct inode *inode, struct file *file)
+{
+	struct serio_raw *serio_raw = inode->i_private;
+
+	file->private_data = serio_raw;
+	queue_clear(&serio_raw->debug_user);
+	serio_raw->debug_user_opened = true;
+	kref_get(&serio_raw->kref);
+
+	return 0;
+}
+
+static int debug_device_open(struct inode *inode, struct file *file)
+{
+	struct serio_raw *serio_raw = inode->i_private;
+
+	file->private_data = serio_raw;
+	queue_clear(&serio_raw->debug_device);
+	serio_raw->debug_device_opened = true;
+	kref_get(&serio_raw->kref);
+
+	return 0;
+}
+
+static int debug_user_release(struct inode *inode, struct file *file)
+{
+	struct serio_raw *serio_raw = file->private_data;
+
+	file->private_data = NULL;
+	serio_raw->debug_user_opened = false;
+	kref_put(&serio_raw->kref, serio_raw_free);
+
+	return 0;
+}
+
+static int debug_device_release(struct inode *inode, struct file *file)
+{
+	struct serio_raw *serio_raw = file->private_data;
+
+	file->private_data = NULL;
+	serio_raw->debug_device_opened = false;
+	kref_put(&serio_raw->kref, serio_raw_free);
+
+	return 0;
+}
+
+static ssize_t debug_user_read(struct file *file,
+		char __user *buffer, size_t count, loff_t *ppos)
+{
+	struct serio_raw *serio_raw = file->private_data;
+	struct queue *queue = &serio_raw->debug_user;
+
+	return queue_read(queue, buffer, count,
+			&serio_raw->dead, file->f_flags & O_NONBLOCK,
+			queue_fetch_byte);
+}
+
+static ssize_t debug_device_read(struct file *file,
+		char __user *buffer, size_t count, loff_t *ppos)
+{
+	struct serio_raw *serio_raw = file->private_data;
+	struct queue *queue = &serio_raw->debug_device;
+
+	return queue_read(queue, buffer, count,
+			&serio_raw->dead, file->f_flags & O_NONBLOCK,
+			queue_fetch_byte);
+}
+
+static ssize_t debug_user_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
+{
+	struct serio_raw *serio_raw = file->private_data;
+	struct serio_raw_client *client;
+	size_t written = 0;
+
+	if (!serio_raw->replay)
+		return -EIO;
+
+	serio_pause_rx(serio_raw->serio);
+
+	for (written = 0; written < count; written++)
+		if (!queue_write_byte(&serio_raw->queue, buffer[written]))
+			break;
+	if (written) {
+		list_for_each_entry(client, &serio_raw->client_list, node)
+			kill_fasync(&client->fasync, SIGIO, POLL_IN);
+		queue_wakeup(&serio_raw->queue);
+	}
+
+	serio_continue_rx(serio_raw->serio);
+	return written ?: -EIO;
+}
+
+static ssize_t debug_device_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
+{
+	struct serio_raw *serio_raw = file->private_data;
+
+	if (!serio_raw->replay)
+		return -EIO;
+
+	return serio_raw_write_mainloop(serio_raw, buffer, count, true, NULL);
+}
+
+static unsigned int debug_user_poll(struct file *file, poll_table *wait)
+{
+	struct serio_raw *serio_raw = file->private_data;
+	struct queue *queue = &serio_raw->debug_user;
+
+	return queue_poll(queue, file, wait, &serio_raw->dead);
+}
+
+static unsigned int debug_device_poll(struct file *file, poll_table *wait)
+{
+	struct serio_raw *serio_raw = file->private_data;
+	struct queue *queue = &serio_raw->debug_device;
+
+	return queue_poll(queue, file, wait, &serio_raw->dead);
+}
+
 static const struct file_operations debug_user_fops = {
+	.owner		= THIS_MODULE,
+	.open		= debug_user_open,
+	.release	= debug_user_release,
+	.read		= debug_user_read,
+	.write		= debug_user_write,
+	.poll		= debug_user_poll,
+	.llseek		= noop_llseek,
 };
 
 static const struct file_operations debug_device_fops = {
+	.owner		= THIS_MODULE,
+	.open		= debug_device_open,
+	.release	= debug_device_release,
+	.read		= debug_device_read,
+	.write		= debug_device_write,
+	.poll		= debug_device_poll,
+	.llseek		= noop_llseek,
 };
 
 
@@ -367,7 +505,12 @@ static irqreturn_t serio_raw_interrupt(struct serio *serio, unsigned char data,
 	struct serio_raw_client *client;
 
 	/* we are holding serio->lock here so we are protected */
-	if (queue_write_byte(&serio_raw->queue, data)) {
+
+	if (serio_raw->debug_device_opened &&
+			queue_write_byte(&serio_raw->debug_device, data))
+		queue_wakeup(&serio_raw->debug_device);
+
+	if (!serio_raw->replay && queue_write_byte(&serio_raw->queue, data)) {
 		list_for_each_entry(client, &serio_raw->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_IN);
 		queue_wakeup(&serio_raw->queue);
@@ -394,6 +537,9 @@ static int serio_raw_debug_init(struct serio_raw *serio_raw)
 				&debug_device_fops))
 		goto err;
 
+	queue_init(&serio_raw->debug_user);
+	queue_init(&serio_raw->debug_device);
+
 	return 0;
 
 err:
-- 
1.7.7.3

