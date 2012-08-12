Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2HLVkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:40:45 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:57844 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2HLVjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:43 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1OAHUhKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDxAISTkKFAYBEogRtjoUkS8DmzaNBg
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="168687020"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 07/19] Input: evdev - Add the events() callback
Date: Sun, 12 Aug 2012 23:42:25 +0200
Message-Id: <1344807757-2217-8-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By sending a full frame of events at the same time, the irqsoff
latency at heavy load is brought down from 200 us to 100 us.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/evdev.c | 68 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index a0692c5..1bf4ce5 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -54,16 +54,9 @@ struct evdev_client {
 static struct evdev *evdev_table[EVDEV_MINORS];
 static DEFINE_MUTEX(evdev_table_mutex);
 
-static void evdev_pass_event(struct evdev_client *client,
-			     struct input_event *event,
-			     ktime_t mono, ktime_t real)
+static void __pass_event(struct evdev_client *client,
+			 const struct input_event *event)
 {
-	event->time = ktime_to_timeval(client->clkid == CLOCK_MONOTONIC ?
-					mono : real);
-
-	/* Interrupts are disabled, just acquire the lock. */
-	spin_lock(&client->buffer_lock);
-
 	client->buffer[client->head++] = *event;
 	client->head &= client->bufsize - 1;
 
@@ -86,42 +79,74 @@ static void evdev_pass_event(struct evdev_client *client,
 		client->packet_head = client->head;
 		kill_fasync(&client->fasync, SIGIO, POLL_IN);
 	}
+}
+
+static void evdev_pass_values(struct evdev_client *client,
+			      const struct input_value *vals, size_t count,
+			      ktime_t mono, ktime_t real)
+{
+	struct evdev *evdev = client->evdev;
+	const struct input_value *v;
+	struct input_event event;
+	bool wakeup = false;
+
+	event.time = ktime_to_timeval(client->clkid == CLOCK_MONOTONIC ?
+				      mono : real);
+
+	/* Interrupts are disabled, just acquire the lock. */
+	spin_lock(&client->buffer_lock);
+
+	for (v = vals; v != vals + count; v++) {
+		event.type = v->type;
+		event.code = v->code;
+		event.value = v->value;
+		__pass_event(client, &event);
+		if (v->type == EV_SYN && v->code == SYN_REPORT)
+			wakeup = true;
+	}
 
 	spin_unlock(&client->buffer_lock);
+
+	if (wakeup)
+		wake_up_interruptible(&evdev->wait);
 }
 
 /*
- * Pass incoming event to all connected clients.
+ * Pass incoming events to all connected clients.
  */
-static void evdev_event(struct input_handle *handle,
-			unsigned int type, unsigned int code, int value)
+static void evdev_events(struct input_handle *handle,
+			 const struct input_value *vals, size_t count)
 {
 	struct evdev *evdev = handle->private;
 	struct evdev_client *client;
-	struct input_event event;
 	ktime_t time_mono, time_real;
 
 	time_mono = ktime_get();
 	time_real = ktime_sub(time_mono, ktime_get_monotonic_offset());
 
-	event.type = type;
-	event.code = code;
-	event.value = value;
-
 	rcu_read_lock();
 
 	client = rcu_dereference(evdev->grab);
 
 	if (client)
-		evdev_pass_event(client, &event, time_mono, time_real);
+		evdev_pass_values(client, vals, count, time_mono, time_real);
 	else
 		list_for_each_entry_rcu(client, &evdev->client_list, node)
-			evdev_pass_event(client, &event, time_mono, time_real);
+			evdev_pass_values(client, vals, count,
+					  time_mono, time_real);
 
 	rcu_read_unlock();
+}
 
-	if (type == EV_SYN && code == SYN_REPORT)
-		wake_up_interruptible(&evdev->wait);
+/*
+ * Pass incoming event to all connected clients.
+ */
+static void evdev_event(struct input_handle *handle,
+			unsigned int type, unsigned int code, int value)
+{
+	struct input_value vals[] = { { type, code, value } };
+
+	evdev_events(handle, vals, 1);
 }
 
 static int evdev_fasync(int fd, struct file *file, int on)
@@ -1050,6 +1075,7 @@ MODULE_DEVICE_TABLE(input, evdev_ids);
 
 static struct input_handler evdev_handler = {
 	.event		= evdev_event,
+	.events		= evdev_events,
 	.connect	= evdev_connect,
 	.disconnect	= evdev_disconnect,
 	.fops		= &evdev_fops,
-- 
1.7.11.4

