Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1KAJ1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:27:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1KAJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:26:47 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: jkosina@suse.cz, oneukum@suse.de, bleung@chromium.org
Cc: stern@rowland.harvard.edu, olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 3/3] HID: usbhid: defer LED setting to a workqueue
Date: Tue,  1 Nov 2011 17:25:47 +0800
Message-Id: <1320139547-7921-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320139547-7921-1-git-send-email-djkurtz@chromium.org>
References: <1320139547-7921-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defer LED setting action to a workqueue.
This is more likely to perform all LED change events in a single URB.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/hid/hid-input.c       |   42 ++++++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/hid-core.c |   43 +++++++++++++++++++++++++++++++---------
 drivers/hid/usbhid/usbhid.h   |    2 +
 include/linux/hid.h           |    2 +
 4 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index f333139..ca2075d 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -861,6 +861,48 @@ int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int
 }
 EXPORT_SYMBOL_GPL(hidinput_find_field);
 
+struct hid_field *hidinput_get_led_field(struct hid_device *hid)
+{
+	struct hid_report *report;
+	struct hid_field *field;
+	int i, j;
+
+	list_for_each_entry(report,
+			    &hid->report_enum[HID_OUTPUT_REPORT].report_list,
+			    list) {
+		for (i = 0; i < report->maxfield; i++) {
+			field = report->field[i];
+			for (j = 0; j < field->maxusage; j++)
+				if (field->usage[j].type == EV_LED)
+					return field;
+		}
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(hidinput_get_led_field);
+
+unsigned int hidinput_count_leds(struct hid_device *hid)
+{
+	struct hid_report *report;
+	struct hid_field *field;
+	int i, j;
+	unsigned int count = 0;
+
+	list_for_each_entry(report,
+			    &hid->report_enum[HID_OUTPUT_REPORT].report_list,
+			    list) {
+		for (i = 0; i < report->maxfield; i++) {
+			field = report->field[i];
+			for (j = 0; j < field->maxusage; j++)
+				if (field->usage[j].type == EV_LED &&
+				    field->value[j])
+					count += 1;
+		}
+	}
+	return count;
+}
+EXPORT_SYMBOL_GPL(hidinput_count_leds);
+
 static int hidinput_open(struct input_dev *dev)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 7f67cfa..e5a3e5c 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -602,6 +602,28 @@ void usbhid_submit_report(struct hid_device *hid, struct hid_report *report, uns
 }
 EXPORT_SYMBOL_GPL(usbhid_submit_report);
 
+/* Workqueue routine to send requests to change LEDs */
+static void hid_led(struct work_struct *work)
+{
+	struct usbhid_device *usbhid =
+		container_of(work, struct usbhid_device, led_work);
+	struct hid_device *hid = usbhid->hid;
+	struct hid_field *field;
+	unsigned long flags;
+
+	field = hidinput_get_led_field(hid);
+	if (!field) {
+		hid_warn(hid, "LED event field not found\n");
+		return;
+	}
+
+	spin_lock_irqsave(&usbhid->lock, flags);
+	usbhid->ledcount = hidinput_count_leds(hid);
+	hid_warn(hid, "%s: New ledcount = %u\n", __func__, usbhid->ledcount);
+	__usbhid_submit_report(hid, field->report, USB_DIR_OUT);
+	spin_unlock_irqrestore(&usbhid->lock, flags);
+}
+
 static int usb_hidinput_input_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
@@ -621,17 +643,15 @@ static int usb_hidinput_input_event(struct input_dev *dev, unsigned int type, un
 		return -1;
 	}
 
+	spin_lock_irqsave(&usbhid->lock, flags);
 	hid_set_field(field, offset, value);
-	if (value) {
-		spin_lock_irqsave(&usbhid->lock, flags);
-		usbhid->ledcount++;
-		spin_unlock_irqrestore(&usbhid->lock, flags);
-	} else {
-		spin_lock_irqsave(&usbhid->lock, flags);
-		usbhid->ledcount--;
-		spin_unlock_irqrestore(&usbhid->lock, flags);
-	}
-	usbhid_submit_report(hid, field->report, USB_DIR_OUT);
+	spin_unlock_irqrestore(&usbhid->lock, flags);
+
+	/*
+	 * Defer performing requested LED action.
+	 * This is more likely gather all LED changes into a single URB.
+	 */
+	schedule_work(&usbhid->led_work);
 
 	return 0;
 }
@@ -1260,6 +1280,8 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 	setup_timer(&usbhid->io_retry, hid_retry_timeout, (unsigned long) hid);
 	spin_lock_init(&usbhid->lock);
 
+	INIT_WORK(&usbhid->led_work, hid_led);
+
 	ret = hid_add_device(hid);
 	if (ret) {
 		if (ret != -ENODEV)
@@ -1292,6 +1314,7 @@ static void hid_cancel_delayed_stuff(struct usbhid_device *usbhid)
 {
 	del_timer_sync(&usbhid->io_retry);
 	cancel_work_sync(&usbhid->reset_work);
+	cancel_work_sync(&usbhid->led_work);
 }
 
 static void hid_cease_io(struct usbhid_device *usbhid)
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index 2d8957c..cb8f703 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -96,6 +96,8 @@ struct usbhid_device {
 	struct work_struct reset_work;                                  /* Task context for resets */
 	wait_queue_head_t wait;						/* For sleeping */
 	int ledcount;							/* counting the number of active leds */
+
+	struct work_struct led_work;					/* Task context for setting LEDs */
 };
 
 #define	hid_to_usb_dev(hid_dev) \
diff --git a/include/linux/hid.h b/include/linux/hid.h
index deed5f9..0df7d62 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -711,6 +711,8 @@ extern void hidinput_disconnect(struct hid_device *);
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *, int type, u8 *, int, int);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
+struct hid_field *hidinput_get_led_field(struct hid_device *hid);
+unsigned int hidinput_count_leds(struct hid_device *hid);
 void hid_output_report(struct hid_report *report, __u8 *data);
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
-- 
1.7.3.1

