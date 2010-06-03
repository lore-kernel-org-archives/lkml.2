Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0FCICP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:02:15 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:52345 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757973Ab0FCICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:02:08 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/4] input: evdev: Use multi-reader buffer to save space (rev3)
Date: Thu,  3 Jun 2010 10:01:00 +0200
Message-Id: <1275552062-8153-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275552062-8153-2-git-send-email-rydberg@euromail.se>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se>
 <1275552062-8153-2-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OK5Mo-0000lH-9d.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OK5Mo-0000lH-9d 0fe30b1dd082e2e883eae6f6d73fb906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing for larger buffer needs, convert the current per-client
circular buffer to a single buffer with multiple clients. Use the
buflock mechanism, where clients wait during buffer collision only.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/evdev.c |   57 ++++++++++++++++++++++++-------------------------
 1 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2ee6c7a..7f0c7da 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -21,6 +21,7 @@
 #include <linux/major.h>
 #include <linux/device.h>
 #include "input-compat.h"
+#include "buflock.h"
 
 struct evdev {
 	int exist;
@@ -33,13 +34,13 @@ struct evdev {
 	spinlock_t client_lock; /* protects client_list */
 	struct mutex mutex;
 	struct device dev;
+	struct buflock_writer writer;
+	struct input_event buffer[EVDEV_BUFFER_SIZE];
 };
 
 struct evdev_client {
-	struct input_event buffer[EVDEV_BUFFER_SIZE];
-	int head;
-	int tail;
-	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
+	struct buflock_reader reader;
+	spinlock_t entry_lock; /* protects reentrant fops reads */
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
@@ -48,18 +49,12 @@ struct evdev_client {
 static struct evdev *evdev_table[EVDEV_MINORS];
 static DEFINE_MUTEX(evdev_table_mutex);
 
-static void evdev_pass_event(struct evdev_client *client,
-			     struct input_event *event)
+static inline void evdev_sync_event(struct evdev_client *client,
+				    struct evdev *evdev, int type)
 {
-	/*
-	 * Interrupts are disabled, just acquire the lock
-	 */
-	spin_lock(&client->buffer_lock);
-	client->buffer[client->head++] = *event;
-	client->head &= EVDEV_BUFFER_SIZE - 1;
-	spin_unlock(&client->buffer_lock);
-
-	if (event->type == EV_SYN)
+	/* sync reader, no locks required */
+	buflock_sync_reader(client->reader, evdev->writer);
+	if (type == EV_SYN)
 		kill_fasync(&client->fasync, SIGIO, POLL_IN);
 }
 
@@ -78,14 +73,17 @@ static void evdev_event(struct input_handle *handle,
 	event.code = code;
 	event.value = value;
 
+	/* lock-less write */
+	buflock_write(evdev->writer, evdev->buffer, EVDEV_BUFFER_SIZE, event);
+
 	rcu_read_lock();
 
 	client = rcu_dereference(evdev->grab);
 	if (client)
-		evdev_pass_event(client, &event);
+		evdev_sync_event(client, evdev, type);
 	else
 		list_for_each_entry_rcu(client, &evdev->client_list, node)
-			evdev_pass_event(client, &event);
+			evdev_sync_event(client, evdev, type);
 
 	rcu_read_unlock();
 
@@ -269,7 +267,7 @@ static int evdev_open(struct inode *inode, struct file *file)
 		goto err_put_evdev;
 	}
 
-	spin_lock_init(&client->buffer_lock);
+	spin_lock_init(&client->entry_lock);
 	client->evdev = evdev;
 	evdev_attach_client(evdev, client);
 
@@ -325,19 +323,19 @@ static ssize_t evdev_write(struct file *file, const char __user *buffer,
 }
 
 static int evdev_fetch_next_event(struct evdev_client *client,
+				  struct evdev *evdev,
 				  struct input_event *event)
 {
 	int have_event;
 
-	spin_lock_irq(&client->buffer_lock);
+	spin_lock_irq(&client->entry_lock);
 
-	have_event = client->head != client->tail;
-	if (have_event) {
-		*event = client->buffer[client->tail++];
-		client->tail &= EVDEV_BUFFER_SIZE - 1;
-	}
+	have_event = !buflock_reader_empty(client->reader);
+	if (have_event)
+		buflock_read(client->reader, evdev->writer,
+			     evdev->buffer, EVDEV_BUFFER_SIZE, *event);
 
-	spin_unlock_irq(&client->buffer_lock);
+	spin_unlock_irq(&client->entry_lock);
 
 	return have_event;
 }
@@ -353,12 +351,12 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 	if (count < input_event_size())
 		return -EINVAL;
 
-	if (client->head == client->tail && evdev->exist &&
+	if (buflock_reader_empty(client->reader) && evdev->exist &&
 	    (file->f_flags & O_NONBLOCK))
 		return -EAGAIN;
 
 	retval = wait_event_interruptible(evdev->wait,
-		client->head != client->tail || !evdev->exist);
+		!buflock_reader_empty(client->reader) || !evdev->exist);
 	if (retval)
 		return retval;
 
@@ -366,7 +364,7 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 		return -ENODEV;
 
 	while (retval + input_event_size() <= count &&
-	       evdev_fetch_next_event(client, &event)) {
+	       evdev_fetch_next_event(client, evdev, &event)) {
 
 		if (input_event_to_user(buffer + retval, &event))
 			return -EFAULT;
@@ -384,7 +382,8 @@ static unsigned int evdev_poll(struct file *file, poll_table *wait)
 	struct evdev *evdev = client->evdev;
 
 	poll_wait(file, &evdev->wait, wait);
-	return ((client->head == client->tail) ? 0 : (POLLIN | POLLRDNORM)) |
+	return (buflock_reader_empty(client->reader) ? 0 :
+		(POLLIN | POLLRDNORM)) |
 		(evdev->exist ? 0 : (POLLHUP | POLLERR));
 }
 
-- 
1.6.3.3

