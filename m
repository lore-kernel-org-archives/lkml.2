Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1DBGzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:55:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47831 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1DBGy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:54:56 -0400
From: Jeff Brown <jeffbrown@android.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se, djkurtz@google.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Brown <jeffbrown@google.com>, jeffbrown@android.com
Subject: [PATCH v2 3/4] input: evdev: Indicate buffer overrun with SYN_DROPPED.
Date: Fri,  1 Apr 2011 23:54:18 -0700
Message-Id: <1301727259-5185-3-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Brown <jeffbrown@google.com>

Add a new EV_SYN code, SYN_DROPPED, to inform the client when input
events have been dropped from the evdev input buffer due to a
buffer overrun.  All subsequent events for the current packet are
also dropped so that the next packet starts right after SYN_DROPPED.

The client should use SYN_DROPPED as a hint to reset its internal state.

Slightly changed the signal condition when using fasync to send
the signal only for non-MT sync packets such that the signal is
only sent at the end of the packet.  This makes the code more
consistent in its handling of packet sync boundaries.

Signed-off-by: jeffbrown@android.com
---
 drivers/input/evdev.c |   45 +++++++++++++++++++++++++++++++++++----------
 include/linux/input.h |    1 +
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 7f42d3a..bd78dc0 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -41,6 +41,7 @@ struct evdev {
 struct evdev_client {
 	int head;
 	int tail;
+	bool drop_packet;
 	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
@@ -53,21 +54,42 @@ static struct evdev *evdev_table[EVDEV_MINORS];
 static DEFINE_MUTEX(evdev_table_mutex);
 
 static void evdev_pass_event(struct evdev_client *client,
-			     struct input_event *event)
+			     struct input_event *event, bool full_sync)
 {
+	int cur;
+
 	/*
 	 * Interrupts are disabled, just acquire the lock.
-	 * Make sure we don't leave with the client buffer
-	 * "empty" by having client->head == client->tail.
+	 * When the client buffer is full, drain the buffer and enqueue a
+	 * SYN_DROPPED event to let the client know that events were dropped
+	 * and the last packet was incomplete.  We then consume all remaining
+	 * events from the dropped packet until the next packet begins.
 	 */
 	spin_lock(&client->buffer_lock);
-	do {
-		client->buffer[client->head++] = *event;
-		client->head &= client->bufsize - 1;
-	} while (client->head == client->tail);
+	if (client->drop_packet) {
+		if (full_sync)
+			client->drop_packet = false;
+		spin_unlock(&client->buffer_lock);
+		return;
+	}
+	cur = client->head++;
+	client->head &= client->bufsize - 1;
+	if (likely(client->head != client->tail))
+		client->buffer[cur] = *event;
+	else {
+		client->buffer[cur].time = event->time;
+		client->buffer[cur].type = EV_SYN;
+		client->buffer[cur].code = SYN_DROPPED;
+		client->buffer[cur].value = 0;
+		client->tail = cur;
+		if (!full_sync) {
+			client->drop_packet = true;
+			full_sync = true;
+		}
+	}
 	spin_unlock(&client->buffer_lock);
 
-	if (event->type == EV_SYN)
+	if (full_sync)
 		kill_fasync(&client->fasync, SIGIO, POLL_IN);
 }
 
@@ -80,20 +102,23 @@ static void evdev_event(struct input_handle *handle,
 	struct evdev *evdev = handle->private;
 	struct evdev_client *client;
 	struct input_event event;
+	bool full_sync;
 
 	do_gettimeofday(&event.time);
 	event.type = type;
 	event.code = code;
 	event.value = value;
 
+	full_sync = (type == EV_SYN && code != SYN_MT_REPORT);
+
 	rcu_read_lock();
 
 	client = rcu_dereference(evdev->grab);
 	if (client)
-		evdev_pass_event(client, &event);
+		evdev_pass_event(client, &event, full_sync);
 	else
 		list_for_each_entry_rcu(client, &evdev->client_list, node)
-			evdev_pass_event(client, &event);
+			evdev_pass_event(client, &event, full_sync);
 
 	rcu_read_unlock();
 
diff --git a/include/linux/input.h b/include/linux/input.h
index f3a7794..71d3651 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -167,6 +167,7 @@ struct input_keymap_entry {
 #define SYN_REPORT		0
 #define SYN_CONFIG		1
 #define SYN_MT_REPORT		2
+#define SYN_DROPPED		3
 
 /*
  * Keys and buttons
-- 
1.7.0.4

