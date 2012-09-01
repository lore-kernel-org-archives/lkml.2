Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2IATma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:42:30 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:51515 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2IATmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:42:12 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnxPAJVjQlBV5qoUPGdsb2JhbABEhRyFI7BfGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG6NxSKeociA5tHjRGBXw
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="180547486"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3 05/20] Input: Send events one packet at a time
Date: Sat,  1 Sep 2012 21:47:00 +0200
Message-Id: <1346528835-363-6-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346528835-363-1-git-send-email-rydberg@euromail.se>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On heavy event loads, such as a multitouch driver, the irqsoff latency
can be as high as 250 us.  By accumulating a frame worth of data
before passing it on, the latency can be dramatically reduced.  As a
side effect, the special EV_SYN handling can be removed, since the
frame is now atomic.

This patch adds the events() handler callback and uses it if it
exists. The latency is improved by 50 us even without the callback.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c | 176 +++++++++++++++++++++++++++++++++++---------------
 include/linux/input.h |  24 ++++++-
 2 files changed, 144 insertions(+), 56 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index a57c4a5..5b66b2f 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -47,6 +47,8 @@ static DEFINE_MUTEX(input_mutex);
 
 static struct input_handler *input_table[8];
 
+static const struct input_value input_value_sync = { EV_SYN, SYN_REPORT, 1 };
+
 static inline int is_event_supported(unsigned int code,
 				     unsigned long *bm, unsigned int max)
 {
@@ -90,46 +92,81 @@ static void input_stop_autorepeat(struct input_dev *dev)
  * filtered out, through all open handles. This function is called with
  * dev->event_lock held and interrupts disabled.
  */
-static void input_pass_event(struct input_dev *dev,
-			     unsigned int type, unsigned int code, int value)
+static unsigned int input_to_handler(struct input_handle *handle,
+			struct input_value *vals, unsigned int count)
 {
-	struct input_handler *handler;
-	struct input_handle *handle;
+	struct input_handler *handler = handle->handler;
+	struct input_value *end = vals;
+	struct input_value *v;
 
-	rcu_read_lock();
+	for (v = vals; v != vals + count; v++) {
+		if (handler->filter &&
+		    handler->filter(handle, v->type, v->code, v->value))
+			continue;
+		if (end != v)
+			*end = *v;
+		end++;
+	}
 
-	handle = rcu_dereference(dev->grab);
-	if (handle)
-		handle->handler->event(handle, type, code, value);
-	else {
-		bool filtered = false;
+	count = end - vals;
+	if (!count)
+		return 0;
 
-		list_for_each_entry_rcu(handle, &dev->h_list, d_node) {
-			if (!handle->open)
-				continue;
+	if (handler->events)
+		handler->events(handle, vals, count);
+	else
+		for (v = vals; v != end; v++)
+			handler->event(handle, v->type, v->code, v->value);
+
+	return count;
+}
 
-			handler = handle->handler;
-			if (!handler->filter) {
-				if (filtered)
-					break;
+/*
+ * Pass values first through all filters and then, if event has not been
+ * filtered out, through all open handles. This function is called with
+ * dev->event_lock held and interrupts disabled.
+ */
+static void input_pass_values(struct input_dev *dev,
+			      struct input_value *vals, unsigned int count)
+{
+	struct input_handle *handle;
+	struct input_value *v;
 
-				handler->event(handle, type, code, value);
+	if (!count)
+		return;
 
-			} else if (handler->filter(handle, type, code, value))
-				filtered = true;
-		}
+	rcu_read_lock();
+
+	handle = rcu_dereference(dev->grab);
+	if (handle) {
+		count = input_to_handler(handle, vals, count);
+	} else {
+		list_for_each_entry_rcu(handle, &dev->h_list, d_node)
+			if (handle->open)
+				count = input_to_handler(handle, vals, count);
 	}
 
 	rcu_read_unlock();
 
+	add_input_randomness(vals->type, vals->code, vals->value);
+
 	/* trigger auto repeat for key events */
-	if (type == EV_KEY && value != 2) {
-		if (value)
-			input_start_autorepeat(dev, code);
-		else
-			input_stop_autorepeat(dev);
+	for (v = vals; v != vals + count; v++) {
+		if (v->type == EV_KEY && v->value != 2) {
+			if (v->value)
+				input_start_autorepeat(dev, v->code);
+			else
+				input_stop_autorepeat(dev);
+		}
 	}
+}
+
+static void input_pass_event(struct input_dev *dev,
+			     unsigned int type, unsigned int code, int value)
+{
+	struct input_value vals[] = { { type, code, value } };
 
+	input_pass_values(dev, vals, ARRAY_SIZE(vals));
 }
 
 /*
@@ -146,18 +183,12 @@ static void input_repeat_key(unsigned long data)
 
 	if (test_bit(dev->repeat_key, dev->key) &&
 	    is_event_supported(dev->repeat_key, dev->keybit, KEY_MAX)) {
+		struct input_value vals[] =  {
+			{ EV_KEY, dev->repeat_key, 2 },
+			input_value_sync
+		};
 
-		input_pass_event(dev, EV_KEY, dev->repeat_key, 2);
-
-		if (dev->sync) {
-			/*
-			 * Only send SYN_REPORT if we are not in a middle
-			 * of driver parsing a new hardware packet.
-			 * Otherwise assume that the driver will send
-			 * SYN_REPORT once it's done.
-			 */
-			input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
-		}
+		input_pass_values(dev, vals, ARRAY_SIZE(vals));
 
 		if (dev->rep[REP_PERIOD])
 			mod_timer(&dev->timer, jiffies +
@@ -170,6 +201,8 @@ static void input_repeat_key(unsigned long data)
 #define INPUT_IGNORE_EVENT	0
 #define INPUT_PASS_TO_HANDLERS	1
 #define INPUT_PASS_TO_DEVICE	2
+#define INPUT_SLOT		4
+#define INPUT_FLUSH		8
 #define INPUT_PASS_TO_ALL	(INPUT_PASS_TO_HANDLERS | INPUT_PASS_TO_DEVICE)
 
 static int input_handle_abs_event(struct input_dev *dev,
@@ -215,14 +248,14 @@ static int input_handle_abs_event(struct input_dev *dev,
 	/* Flush pending "slot" event */
 	if (is_mt_event && dev->slot != input_abs_get_val(dev, ABS_MT_SLOT)) {
 		input_abs_set_val(dev, ABS_MT_SLOT, dev->slot);
-		input_pass_event(dev, EV_ABS, ABS_MT_SLOT, dev->slot);
+		return INPUT_PASS_TO_HANDLERS | INPUT_SLOT;
 	}
 
 	return INPUT_PASS_TO_HANDLERS;
 }
 
-static void input_handle_event(struct input_dev *dev,
-			       unsigned int type, unsigned int code, int value)
+static int input_get_disposition(struct input_dev *dev,
+			  unsigned int type, unsigned int code, int value)
 {
 	int disposition = INPUT_IGNORE_EVENT;
 
@@ -235,13 +268,9 @@ static void input_handle_event(struct input_dev *dev,
 			break;
 
 		case SYN_REPORT:
-			if (!dev->sync) {
-				dev->sync = true;
-				disposition = INPUT_PASS_TO_HANDLERS;
-			}
+			disposition = INPUT_PASS_TO_HANDLERS | INPUT_FLUSH;
 			break;
 		case SYN_MT_REPORT:
-			dev->sync = false;
 			disposition = INPUT_PASS_TO_HANDLERS;
 			break;
 		}
@@ -326,14 +355,48 @@ static void input_handle_event(struct input_dev *dev,
 		break;
 	}
 
-	if (disposition != INPUT_IGNORE_EVENT && type != EV_SYN)
-		dev->sync = false;
+	return disposition;
+}
+
+static void input_handle_event(struct input_dev *dev,
+			       unsigned int type, unsigned int code, int value)
+{
+	int disposition;
+
+	disposition = input_get_disposition(dev, type, code, value);
 
 	if ((disposition & INPUT_PASS_TO_DEVICE) && dev->event)
 		dev->event(dev, type, code, value);
 
-	if (disposition & INPUT_PASS_TO_HANDLERS)
-		input_pass_event(dev, type, code, value);
+	if (!dev->vals)
+		return;
+
+	if (disposition & INPUT_PASS_TO_HANDLERS) {
+		struct input_value *v;
+
+		if (disposition & INPUT_SLOT) {
+			v = &dev->vals[dev->num_vals++];
+			v->type = EV_ABS;
+			v->code = ABS_MT_SLOT;
+			v->value = dev->slot;
+		}
+
+		v = &dev->vals[dev->num_vals++];
+		v->type = type;
+		v->code = code;
+		v->value = value;
+	}
+
+	if (disposition & INPUT_FLUSH) {
+		if (dev->num_vals >= 2)
+			input_pass_values(dev, dev->vals, dev->num_vals);
+		dev->num_vals = 0;
+	} else if (dev->num_vals >= dev->max_vals - 2) {
+		dev->vals[dev->num_vals++] = input_value_sync;
+		input_pass_values(dev, dev->vals, dev->num_vals);
+		dev->num_vals = 0;
+	}
+
 }
 
 /**
@@ -361,7 +424,6 @@ void input_event(struct input_dev *dev,
 	if (is_event_supported(type, dev->evbit, EV_MAX)) {
 
 		spin_lock_irqsave(&dev->event_lock, flags);
-		add_input_randomness(type, code, value);
 		input_handle_event(dev, type, code, value);
 		spin_unlock_irqrestore(&dev->event_lock, flags);
 	}
@@ -840,10 +902,12 @@ int input_set_keycode(struct input_dev *dev,
 	if (test_bit(EV_KEY, dev->evbit) &&
 	    !is_event_supported(old_keycode, dev->keybit, KEY_MAX) &&
 	    __test_and_clear_bit(old_keycode, dev->key)) {
+		struct input_value vals[] =  {
+			{ EV_KEY, old_keycode, 0 },
+			input_value_sync
+		};
 
-		input_pass_event(dev, EV_KEY, old_keycode, 0);
-		if (dev->sync)
-			input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
+		input_pass_values(dev, vals, ARRAY_SIZE(vals));
 	}
 
  out:
@@ -1425,6 +1489,7 @@ static void input_dev_release(struct device *device)
 	input_ff_destroy(dev);
 	input_mt_destroy_slots(dev);
 	kfree(dev->absinfo);
+	kfree(dev->vals);
 	kfree(dev);
 
 	module_put(THIS_MODULE);
@@ -1845,6 +1910,11 @@ int input_register_device(struct input_dev *dev)
 	if (dev->hint_events_per_packet < packet_size)
 		dev->hint_events_per_packet = packet_size;
 
+	dev->max_vals = max(dev->hint_events_per_packet, packet_size) + 2;
+	dev->vals = kcalloc(dev->max_vals, sizeof(*dev->vals), GFP_KERNEL);
+	if (!dev->vals)
+		return -ENOMEM;
+
 	/*
 	 * If delay and period are pre-set by the driver, then autorepeating
 	 * is handled by the driver itself and we don't do it in input.c.
diff --git a/include/linux/input.h b/include/linux/input.h
index 76d6788..797f335 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1169,6 +1169,18 @@ struct ff_effect {
 #include <linux/mod_devicetable.h>
 
 /**
+ * struct input_value - input value representation
+ * @type: type of value (EV_KEY, EV_ABS, etc)
+ * @code: the value code
+ * @value: the value
+ */
+struct input_value {
+	__u16 type;
+	__u16 code;
+	__s32 value;
+};
+
+/**
  * struct input_dev - represents an input device
  * @name: name of the device
  * @phys: physical path to the device in the system hierarchy
@@ -1241,7 +1253,6 @@ struct ff_effect {
  *	last user closes the device
  * @going_away: marks devices that are in a middle of unregistering and
  *	causes input_open_device*() fail with -ENODEV.
- * @sync: set to %true when there were no new events since last EV_SYN
  * @dev: driver model's view of this device
  * @h_list: list of input handles associated with the device. When
  *	accessing the list dev->mutex must be held
@@ -1307,12 +1318,14 @@ struct input_dev {
 	unsigned int users;
 	bool going_away;
 
-	bool sync;
-
 	struct device dev;
 
 	struct list_head	h_list;
 	struct list_head	node;
+
+	unsigned int num_vals;
+	unsigned int max_vals;
+	struct input_value *vals;
 };
 #define to_input_dev(d) container_of(d, struct input_dev, dev)
 
@@ -1373,6 +1386,9 @@ struct input_handle;
  * @event: event handler. This method is being called by input core with
  *	interrupts disabled and dev->event_lock spinlock held and so
  *	it may not sleep
+ * @events: event sequence handler. This method is being called by
+ *	input core with interrupts disabled and dev->event_lock
+ *	spinlock held and so it may not sleep
  * @filter: similar to @event; separates normal event handlers from
  *	"filters".
  * @match: called after comparing device's id with handler's id_table
@@ -1409,6 +1425,8 @@ struct input_handler {
 	void *private;
 
 	void (*event)(struct input_handle *handle, unsigned int type, unsigned int code, int value);
+	void (*events)(struct input_handle *handle,
+		       const struct input_value *vals, unsigned int count);
 	bool (*filter)(struct input_handle *handle, unsigned int type, unsigned int code, int value);
 	bool (*match)(struct input_handler *handler, struct input_dev *dev);
 	int (*connect)(struct input_handler *handler, struct input_dev *dev, const struct input_device_id *id);
-- 
1.7.12

