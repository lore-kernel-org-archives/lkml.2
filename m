Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab0FTStY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 14:49:24 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:55004 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756766Ab0FTStV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 14:49:21 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: evdev: Use multi-reader buffer to save space (rev5)
Date: Sun, 20 Jun 2010 20:48:54 +0200
Message-Id: <1277059734-2939-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OQPZr-0003De-6W.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OQPZr-0003De-6W 2807a72c2fd508a1c0f83a51c796b927
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing for larger buffer needs, convert the current per-client
circular buffer to a single buffer with multiple clients. Ideally, there
should be a mechanism where clients wait during buffer collision only.
Meanwhile, let clients take the dev->event_lock, which is already held
during buffer writes.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Dmitry,

This is revision 5 of the evdev multi-reader buffer patch, fixing the
grab/ungrab bug mentioned in an earlier post.

Thanks,
Henrik

 drivers/input/evdev.c |   65 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2ee6c7a..da0fe3f 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -33,13 +33,13 @@ struct evdev {
 	spinlock_t client_lock; /* protects client_list */
 	struct mutex mutex;
 	struct device dev;
+	int head;
+	struct input_event buffer[EVDEV_BUFFER_SIZE];
 };
 
 struct evdev_client {
-	struct input_event buffer[EVDEV_BUFFER_SIZE];
 	int head;
 	int tail;
-	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
@@ -48,18 +48,13 @@ struct evdev_client {
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
+	/* sync the reader such that it never becomes empty */
+	if (client->tail != evdev->head)
+		client->head = evdev->head;
+	if (type == EV_SYN)
 		kill_fasync(&client->fasync, SIGIO, POLL_IN);
 }
 
@@ -78,14 +73,18 @@ static void evdev_event(struct input_handle *handle,
 	event.code = code;
 	event.value = value;
 
+	/* dev->event_lock held */
+	evdev->buffer[evdev->head] = event;
+	evdev->head = (evdev->head + 1) & (EVDEV_BUFFER_SIZE - 1);
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
 
@@ -149,11 +148,29 @@ static int evdev_grab(struct evdev *evdev, struct evdev_client *client)
 
 static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
 {
+	struct input_dev *dev = evdev->handle.dev;
+	int head, tail;
+
 	if (evdev->grab != client)
 		return  -EINVAL;
 
+	spin_lock_irq(&dev->event_lock);
+
+	head = client->head;
+	tail = client->tail;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(client, &evdev->client_list, node) {
+		client->head = head;
+		client->tail = tail;
+	}
+	rcu_read_unlock();
+
 	rcu_assign_pointer(evdev->grab, NULL);
 	synchronize_rcu();
+
+	spin_unlock_irq(&dev->event_lock);
+
 	input_release_device(&evdev->handle);
 
 	return 0;
@@ -162,6 +179,7 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
 static void evdev_attach_client(struct evdev *evdev,
 				struct evdev_client *client)
 {
+	client->head = client->tail = evdev->head;
 	spin_lock(&evdev->client_lock);
 	list_add_tail_rcu(&client->node, &evdev->client_list);
 	spin_unlock(&evdev->client_lock);
@@ -269,7 +287,6 @@ static int evdev_open(struct inode *inode, struct file *file)
 		goto err_put_evdev;
 	}
 
-	spin_lock_init(&client->buffer_lock);
 	client->evdev = evdev;
 	evdev_attach_client(evdev, client);
 
@@ -325,19 +342,27 @@ static ssize_t evdev_write(struct file *file, const char __user *buffer,
 }
 
 static int evdev_fetch_next_event(struct evdev_client *client,
+				  struct evdev *evdev,
 				  struct input_event *event)
 {
+	struct input_dev *dev = evdev->handle.dev;
 	int have_event;
 
-	spin_lock_irq(&client->buffer_lock);
+	/*
+	 * FIXME: taking event_lock protects against reentrant fops
+	 * reads and provides sufficient buffer locking. However,
+	 * clients should not block writes, and having multiple clients
+	 * waiting for each other is suboptimal.
+	 */
+	spin_lock_irq(&dev->event_lock);
 
 	have_event = client->head != client->tail;
 	if (have_event) {
-		*event = client->buffer[client->tail++];
+		*event = evdev->buffer[client->tail++];
 		client->tail &= EVDEV_BUFFER_SIZE - 1;
 	}
 
-	spin_unlock_irq(&client->buffer_lock);
+	spin_unlock_irq(&dev->event_lock);
 
 	return have_event;
 }
@@ -366,7 +391,7 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 		return -ENODEV;
 
 	while (retval + input_event_size() <= count &&
-	       evdev_fetch_next_event(client, &event)) {
+	       evdev_fetch_next_event(client, evdev, &event)) {
 
 		if (input_event_to_user(buffer + retval, &event))
 			return -EFAULT;
-- 
1.6.3.3

