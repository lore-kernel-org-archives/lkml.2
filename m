Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab0FEVMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 17:12:41 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:48406 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab0FEVMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 17:12:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rpurdie@rpsys.net
Cc: akpm@linux-foundation.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/1] LEDS: leds-input, fix sleep inside atomic
Date: Sat,  5 Jun 2010 23:12:22 +0200
Message-Id: <1275772342-25094-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

input_led_connect creates an atomic context by spin_lock_irqsave and
calls functions which then perform sleeping operations. For example
GFP_KERNEL allocations in led_classdev_register.

So LOCKDEP complains then like:
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2469 lockdep_trace_alloc+0xbc/0xd0()
Pid: 1, comm: swapper Not tainted 2.6.34-mm1_64+ #5
Call Trace:
...
 [<ffffffff8109359c>] lockdep_trace_alloc+0xbc/0xd0
 [<ffffffff810f65b2>] kmem_cache_alloc+0x32/0xf0
 [<ffffffff81324826>] device_create_vargs+0x56/0x110
 [<ffffffff8132490c>] device_create+0x2c/0x30
 [<ffffffff8142068c>] led_classdev_register+0x2c/0xe0
 [<ffffffff814213de>] input_led_connect+0x21e/0x2c0
...

Fix this by changing the spinlock to mutex as it is used only in
input_handler->connect and ->disconnect and it is safe to sleep
there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/leds-input.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-input.c b/drivers/leds/leds-input.c
index 93ab5ae..794155a 100644
--- a/drivers/leds/leds-input.c
+++ b/drivers/leds/leds-input.c
@@ -92,7 +92,7 @@ static struct led_trigger input_led_triggers[LED_CNT] = {
 	DEFINE_INPUT_LED_TRIGGER(LED_CHARGING, "charging"),
 };
 /* Lock for registration coherency */
-static DEFINE_SPINLOCK(input_led_registered_lock);
+static DEFINE_MUTEX(input_led_registered_lock);
 /* Which global LED classes and triggers are registered */
 static unsigned long input_led_registered[BITS_TO_LONGS(LED_CNT)];
 
@@ -159,7 +159,6 @@ static int input_led_connect(struct input_handler *handler,
 {
 	struct input_handle *handle;
 	int i, error = 0;
-	unsigned long flags;
 	struct led_classdev *leds;
 
 	if (!test_bit(EV_LED, dev->keybit))
@@ -187,7 +186,7 @@ static int input_led_connect(struct input_handler *handler,
 		goto err;
 
 	/* lazily register missing global input LEDs */
-	spin_lock_irqsave(&input_led_registered_lock, flags);
+	mutex_lock(&input_led_registered_lock);
 	for (i = 0; i < LED_CNT; i++)
 		if (input_leds[i].name
 				&& !test_bit(i, input_led_registered)
@@ -199,7 +198,7 @@ static int input_led_connect(struct input_handler *handler,
 			else
 				led_trigger_unregister(&input_led_triggers[i]);
 		}
-	spin_unlock_irqrestore(&input_led_registered_lock, flags);
+	mutex_unlock(&input_led_registered_lock);
 
 	/* and register this device's LEDs */
 	for (i = 0; i < LED_CNT; i++)
@@ -239,7 +238,6 @@ err:
 static void input_led_disconnect(struct input_handle *handle)
 {
 	int unregister, i;
-	unsigned long flags;
 	struct led_classdev *leds = handle->private;
 
 	for (i = 0; i < LED_CNT; i++)
@@ -249,7 +247,7 @@ static void input_led_disconnect(struct input_handle *handle)
 	input_unregister_handle(handle);
 	input_led_delete_handle(handle);
 
-	spin_lock_irqsave(&input_led_registered_lock, flags);
+	mutex_lock(&input_led_registered_lock);
 	for (i = 0; i < LED_CNT; i++) {
 		if (!test_bit(i, input_led_registered))
 			continue;
@@ -268,7 +266,7 @@ static void input_led_disconnect(struct input_handle *handle)
 		led_trigger_unregister(&input_led_triggers[i]);
 		clear_bit(i, input_led_registered);
 	}
-	spin_unlock_irqrestore(&input_led_registered_lock, flags);
+	mutex_unlock(&input_led_registered_lock);
 }
 
 /* Only handle input devices which have LEDs */
-- 
1.7.1


