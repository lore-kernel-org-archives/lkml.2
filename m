Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1DBGzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:55:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40464 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1DBGy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:54:58 -0400
From: Jeff Brown <jeffbrown@android.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se, djkurtz@google.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Brown <jeffbrown@android.com>
Subject: [PATCH v2 4/4] input: evdev: Make device readable only when it contains a complete packet.
Date: Fri,  1 Apr 2011 23:54:19 -0700
Message-Id: <1301727259-5185-4-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies evdev so that it only becomes readable when
the buffer contains an EV_SYN event other than SYN_MT_REPORT.

On SMP systems, it is possible for an evdev client blocked on poll()
to wake up and read events from the evdev ring buffer at the same
rate as they are enqueued.  This can result in high CPU usage,
particularly for MT devices, because the client ends up reading
events one at a time instead of reading complete packets.

We eliminate this problem by making the device readable only when
the buffer contains at least one complete packet.  This causes
clients to block until the entire packet is available.

Signed-off-by: jeffbrown@android.com
---
 drivers/input/evdev.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index bd78dc0..fc1d907 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -41,6 +41,7 @@ struct evdev {
 struct evdev_client {
 	int head;
 	int tail;
+	int end; /* index one past the last readable event */
 	bool drop_packet;
 	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
 	struct fasync_struct *fasync;
@@ -74,14 +75,17 @@ static void evdev_pass_event(struct evdev_client *client,
 	}
 	cur = client->head++;
 	client->head &= client->bufsize - 1;
-	if (likely(client->head != client->tail))
+	if (likely(client->head != client->tail)) {
 		client->buffer[cur] = *event;
-	else {
+		if (full_sync)
+			client->end = client->head;
+	} else {
 		client->buffer[cur].time = event->time;
 		client->buffer[cur].type = EV_SYN;
 		client->buffer[cur].code = SYN_DROPPED;
 		client->buffer[cur].value = 0;
 		client->tail = cur;
+		client->end = client->head;
 		if (!full_sync) {
 			client->drop_packet = true;
 			full_sync = true;
@@ -122,7 +126,8 @@ static void evdev_event(struct input_handle *handle,
 
 	rcu_read_unlock();
 
-	wake_up_interruptible(&evdev->wait);
+	if (full_sync)
+		wake_up_interruptible(&evdev->wait);
 }
 
 static int evdev_fasync(int fd, struct file *file, int on)
@@ -381,7 +386,7 @@ static int evdev_fetch_next_event(struct evdev_client *client,
 
 	spin_lock_irq(&client->buffer_lock);
 
-	have_event = client->head != client->tail;
+	have_event = client->end != client->tail;
 	if (have_event) {
 		*event = client->buffer[client->tail++];
 		client->tail &= client->bufsize - 1;
@@ -403,12 +408,12 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 	if (count < input_event_size())
 		return -EINVAL;
 
-	if (client->head == client->tail && evdev->exist &&
+	if (client->end == client->tail && evdev->exist &&
 	    (file->f_flags & O_NONBLOCK))
 		return -EAGAIN;
 
 	retval = wait_event_interruptible(evdev->wait,
-		client->head != client->tail || !evdev->exist);
+		client->end != client->tail || !evdev->exist);
 	if (retval)
 		return retval;
 
@@ -437,7 +442,7 @@ static unsigned int evdev_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &evdev->wait, wait);
 
 	mask = evdev->exist ? POLLOUT | POLLWRNORM : POLLHUP | POLLERR;
-	if (client->head != client->tail)
+	if (client->end != client->tail)
 		mask |= POLLIN | POLLRDNORM;
 
 	return mask;
-- 
1.7.0.4

