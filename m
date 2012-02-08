Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2BHDZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 22:25:42 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57006 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab2BHDZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 22:25:40 -0500
From: Che-Liang Chiou <clchiou@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: [PATCH 2/5] Input: serio_raw - extract queue interface
Date: Wed,  8 Feb 2012 11:24:54 +0800
Message-Id: <1328671497-20880-3-git-send-email-clchiou@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
References: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
In-Reply-To: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
References: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serio_raw operates on an internal data queue that buffers input packets
from device interrupt.  As a queue is a generic data structure, it is
useful for implementing debugging facilities.  This patch extracts its
interface in preparation for implementing debugging facilities.

Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
---
 drivers/input/serio/serio_raw.c |  175 +++++++++++++++++++++++++++------------
 1 files changed, 121 insertions(+), 54 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 4494233..bc2a8c7 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -29,15 +29,19 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 #define SERIO_RAW_QUEUE_LEN	64
-struct serio_raw {
+struct queue {
 	unsigned char queue[SERIO_RAW_QUEUE_LEN];
 	unsigned int tail, head;
+	wait_queue_head_t wait;
+};
+
+struct serio_raw {
+	struct queue queue;
 
 	char name[16];
 	struct kref kref;
 	struct serio *serio;
 	struct miscdevice dev;
-	wait_queue_head_t wait;
 	struct list_head client_list;
 	struct list_head node;
 	bool dead;
@@ -53,6 +57,105 @@ static DEFINE_MUTEX(serio_raw_mutex);
 static LIST_HEAD(serio_raw_list);
 
 /*********************************************************************
+ *             Interface with queue                                  *
+ *********************************************************************/
+
+static void queue_init(struct queue *queue)
+{
+	init_waitqueue_head(&queue->wait);
+}
+
+static void queue_clear(struct queue *queue)
+{
+	queue->head = queue->tail = 0;
+}
+
+static bool queue_available(struct queue *queue)
+{
+	return queue->head != queue->tail;
+}
+
+static void queue_wakeup(struct queue *queue)
+{
+	wake_up_interruptible(&queue->wait);
+}
+
+static bool queue_fetch_byte(struct queue *queue, char *c)
+{
+	bool available;
+
+	available = queue_available(queue);
+	if (available) {
+		*c = queue->queue[queue->tail];
+		queue->tail = (queue->tail + 1) % SERIO_RAW_QUEUE_LEN;
+	}
+
+	return available;
+}
+
+static ssize_t queue_read(struct queue *queue,
+		char __user *buffer, size_t count, bool *dead, bool nonblock,
+		bool (*fetch_byte)(struct queue *, char *))
+{
+	char uninitialized_var(c);
+	ssize_t read = 0;
+	int retval;
+
+	if (*dead)
+		return -ENODEV;
+
+	if (!queue_available(queue) && nonblock)
+		return -EAGAIN;
+
+	retval = wait_event_interruptible(queue->wait,
+			queue_available(queue) || *dead);
+	if (retval)
+		return retval;
+
+	if (*dead)
+		return -ENODEV;
+
+	while (read < count && fetch_byte(queue, &c)) {
+		if (put_user(c, buffer++)) {
+			retval = -EFAULT;
+			break;
+		}
+		read++;
+	}
+
+	return read ?: retval;
+}
+
+static bool queue_write_byte(struct queue *queue, char c)
+{
+	unsigned int head;
+	bool may_write;
+
+	queue->queue[queue->head] = c;
+	head = (queue->head + 1) % SERIO_RAW_QUEUE_LEN;
+	may_write = head != queue->tail;
+	if (may_write)
+		queue->head = head;
+
+	return may_write;
+}
+
+static unsigned int queue_poll(struct queue *queue, struct file *file,
+		poll_table *wait, bool *dead)
+{
+	unsigned int mask;
+
+	poll_wait(file, &queue->wait, wait);
+
+	mask = *dead ? POLLHUP | POLLERR : POLLOUT | POLLWRNORM;
+	if (queue_available(queue))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+
+/*********************************************************************
  *             Interface with userspace (file operations)            *
  *********************************************************************/
 
@@ -141,21 +244,17 @@ static int serio_raw_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static bool serio_raw_fetch_byte(struct serio_raw *serio_raw, char *c)
+static bool serio_raw_fetch_byte(struct queue *queue, char *c)
 {
-	bool empty;
+	struct serio_raw *serio_raw;
+	bool available;
 
+	serio_raw = container_of(queue, struct serio_raw, queue);
 	serio_pause_rx(serio_raw->serio);
-
-	empty = serio_raw->head == serio_raw->tail;
-	if (!empty) {
-		*c = serio_raw->queue[serio_raw->tail];
-		serio_raw->tail = (serio_raw->tail + 1) % SERIO_RAW_QUEUE_LEN;
-	}
-
+	available = queue_fetch_byte(queue, c);
 	serio_continue_rx(serio_raw->serio);
 
-	return !empty;
+	return available;
 }
 
 static ssize_t serio_raw_read(struct file *file, char __user *buffer,
@@ -163,33 +262,11 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
 {
 	struct serio_raw_client *client = file->private_data;
 	struct serio_raw *serio_raw = client->serio_raw;
-	char uninitialized_var(c);
-	ssize_t read = 0;
-	int retval;
-
-	if (serio_raw->dead)
-		return -ENODEV;
-
-	if (serio_raw->head == serio_raw->tail && (file->f_flags & O_NONBLOCK))
-		return -EAGAIN;
-
-	retval = wait_event_interruptible(serio_raw->wait,
-			serio_raw->head != serio_raw->tail || serio_raw->dead);
-	if (retval)
-		return retval;
-
-	if (serio_raw->dead)
-		return -ENODEV;
+	struct queue *queue = &serio_raw->queue;
 
-	while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
-		if (put_user(c, buffer++)) {
-			retval = -EFAULT;
-			break;
-		}
-		read++;
-	}
-
-	return read ?: retval;
+	return queue_read(queue, buffer, count,
+			&serio_raw->dead, file->f_flags & O_NONBLOCK,
+			serio_raw_fetch_byte);
 }
 
 static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
@@ -234,15 +311,9 @@ static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
 {
 	struct serio_raw_client *client = file->private_data;
 	struct serio_raw *serio_raw = client->serio_raw;
-	unsigned int mask;
-
-	poll_wait(file, &serio_raw->wait, wait);
+	struct queue *queue = &serio_raw->queue;
 
-	mask = serio_raw->dead ? POLLHUP | POLLERR : POLLOUT | POLLWRNORM;
-	if (serio_raw->head != serio_raw->tail)
-		mask |= POLLIN | POLLRDNORM;
-
-	return mask;
+	return queue_poll(queue, file, wait, &serio_raw->dead);
 }
 
 static const struct file_operations serio_raw_fops = {
@@ -266,16 +337,12 @@ static irqreturn_t serio_raw_interrupt(struct serio *serio, unsigned char data,
 {
 	struct serio_raw *serio_raw = serio_get_drvdata(serio);
 	struct serio_raw_client *client;
-	unsigned int head = serio_raw->head;
 
 	/* we are holding serio->lock here so we are protected */
-	serio_raw->queue[head] = data;
-	head = (head + 1) % SERIO_RAW_QUEUE_LEN;
-	if (likely(head != serio_raw->tail)) {
-		serio_raw->head = head;
+	if (queue_write_byte(&serio_raw->queue, data)) {
 		list_for_each_entry(client, &serio_raw->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_IN);
-		wake_up_interruptible(&serio_raw->wait);
+		queue_wakeup(&serio_raw->queue);
 	}
 
 	return IRQ_HANDLED;
@@ -297,7 +364,7 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 		 "serio_raw%ld", (long)atomic_inc_return(&serio_raw_no) - 1);
 	kref_init(&serio_raw->kref);
 	INIT_LIST_HEAD(&serio_raw->client_list);
-	init_waitqueue_head(&serio_raw->wait);
+	queue_init(&serio_raw->queue);
 
 	serio_raw->serio = serio;
 	get_device(&serio->dev);
@@ -378,7 +445,7 @@ static void serio_raw_hangup(struct serio_raw *serio_raw)
 		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
 	serio_continue_rx(serio_raw->serio);
 
-	wake_up_interruptible(&serio_raw->wait);
+	queue_wakeup(&serio_raw->queue);
 }
 
 
-- 
1.7.7.3

