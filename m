Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab1BPAeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:34:00 -0500
Received: from kroah.org ([198.145.64.141]:49723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab1BPAYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:48 2011
Message-Id: <20110216001448.193513511@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [231/272] Revert "Input: do not pass injected events back to the originating handler"
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 9ae4345a46bdb148e32a547e89ff29563a11e127 upstream.

This reverts commit 5fdbe44d033d059cc56c2803e6b4dbd8cb4e5e39.

Apparently there exist userspace programs that expect to be able to
"loop back" and distribute to readers events written into
/dev/input/eventX and this change made for the benefit of SysRq
handler broke them. Now that SysRq uses alternative method to suppress
filtering of the events it re-injects we can safely revert this change.

Reported-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/input.c |   37 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -73,7 +73,6 @@ static int input_defuzz_abs_event(int va
  * dev->event_lock held and interrupts disabled.
  */
 static void input_pass_event(struct input_dev *dev,
-			     struct input_handler *src_handler,
 			     unsigned int type, unsigned int code, int value)
 {
 	struct input_handler *handler;
@@ -92,15 +91,6 @@ static void input_pass_event(struct inpu
 				continue;
 
 			handler = handle->handler;
-
-			/*
-			 * If this is the handler that injected this
-			 * particular event we want to skip it to avoid
-			 * filters firing again and again.
-			 */
-			if (handler == src_handler)
-				continue;
-
 			if (!handler->filter) {
 				if (filtered)
 					break;
@@ -130,7 +120,7 @@ static void input_repeat_key(unsigned lo
 	if (test_bit(dev->repeat_key, dev->key) &&
 	    is_event_supported(dev->repeat_key, dev->keybit, KEY_MAX)) {
 
-		input_pass_event(dev, NULL, EV_KEY, dev->repeat_key, 2);
+		input_pass_event(dev, EV_KEY, dev->repeat_key, 2);
 
 		if (dev->sync) {
 			/*
@@ -139,7 +129,7 @@ static void input_repeat_key(unsigned lo
 			 * Otherwise assume that the driver will send
 			 * SYN_REPORT once it's done.
 			 */
-			input_pass_event(dev, NULL, EV_SYN, SYN_REPORT, 1);
+			input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
 		}
 
 		if (dev->rep[REP_PERIOD])
@@ -172,7 +162,6 @@ static void input_stop_autorepeat(struct
 #define INPUT_PASS_TO_ALL	(INPUT_PASS_TO_HANDLERS | INPUT_PASS_TO_DEVICE)
 
 static int input_handle_abs_event(struct input_dev *dev,
-				  struct input_handler *src_handler,
 				  unsigned int code, int *pval)
 {
 	bool is_mt_event;
@@ -216,15 +205,13 @@ static int input_handle_abs_event(struct
 	/* Flush pending "slot" event */
 	if (is_mt_event && dev->slot != input_abs_get_val(dev, ABS_MT_SLOT)) {
 		input_abs_set_val(dev, ABS_MT_SLOT, dev->slot);
-		input_pass_event(dev, src_handler,
-				 EV_ABS, ABS_MT_SLOT, dev->slot);
+		input_pass_event(dev, EV_ABS, ABS_MT_SLOT, dev->slot);
 	}
 
 	return INPUT_PASS_TO_HANDLERS;
 }
 
 static void input_handle_event(struct input_dev *dev,
-			       struct input_handler *src_handler,
 			       unsigned int type, unsigned int code, int value)
 {
 	int disposition = INPUT_IGNORE_EVENT;
@@ -277,8 +264,7 @@ static void input_handle_event(struct in
 
 	case EV_ABS:
 		if (is_event_supported(code, dev->absbit, ABS_MAX))
-			disposition = input_handle_abs_event(dev, src_handler,
-							     code, &value);
+			disposition = input_handle_abs_event(dev, code, &value);
 
 		break;
 
@@ -336,7 +322,7 @@ static void input_handle_event(struct in
 		dev->event(dev, type, code, value);
 
 	if (disposition & INPUT_PASS_TO_HANDLERS)
-		input_pass_event(dev, src_handler, type, code, value);
+		input_pass_event(dev, type, code, value);
 }
 
 /**
@@ -365,7 +351,7 @@ void input_event(struct input_dev *dev,
 
 		spin_lock_irqsave(&dev->event_lock, flags);
 		add_input_randomness(type, code, value);
-		input_handle_event(dev, NULL, type, code, value);
+		input_handle_event(dev, type, code, value);
 		spin_unlock_irqrestore(&dev->event_lock, flags);
 	}
 }
@@ -395,8 +381,7 @@ void input_inject_event(struct input_han
 		rcu_read_lock();
 		grab = rcu_dereference(dev->grab);
 		if (!grab || grab == handle)
-			input_handle_event(dev, handle->handler,
-					   type, code, value);
+			input_handle_event(dev, type, code, value);
 		rcu_read_unlock();
 
 		spin_unlock_irqrestore(&dev->event_lock, flags);
@@ -609,10 +594,10 @@ static void input_dev_release_keys(struc
 		for (code = 0; code <= KEY_MAX; code++) {
 			if (is_event_supported(code, dev->keybit, KEY_MAX) &&
 			    __test_and_clear_bit(code, dev->key)) {
-				input_pass_event(dev, NULL, EV_KEY, code, 0);
+				input_pass_event(dev, EV_KEY, code, 0);
 			}
 		}
-		input_pass_event(dev, NULL, EV_SYN, SYN_REPORT, 1);
+		input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
 	}
 }
 
@@ -887,9 +872,9 @@ int input_set_keycode(struct input_dev *
 	    !is_event_supported(old_keycode, dev->keybit, KEY_MAX) &&
 	    __test_and_clear_bit(old_keycode, dev->key)) {
 
-		input_pass_event(dev, NULL, EV_KEY, old_keycode, 0);
+		input_pass_event(dev, EV_KEY, old_keycode, 0);
 		if (dev->sync)
-			input_pass_event(dev, NULL, EV_SYN, SYN_REPORT, 1);
+			input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
 	}
 
  out:


