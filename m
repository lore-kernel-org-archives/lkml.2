Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2DIQJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:09:14 -0400
Received: from host171.canaca.com ([67.55.55.225]:53334 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab2DIQJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:09:13 -0400
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>, Simon Wood <simon@mungewell.org>
Subject: [PATCH] HID: hid-lg4ff: Add support for G27 LEDs
Date: Mon,  9 Apr 2012 09:08:54 -0700
Message-Id: <1333987734-8217-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1649210.pcO5IpzBEF@qosmio-x300>
References: <1649210.pcO5IpzBEF@qosmio-x300>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds supports for controlling the LED 'tachometer' on
the G27 wheel, via the LED subsystem.

The 5 LEDs are arranged from right (1=grn, 2=grn, 3=yel, 4=yel, 5=red)
and 'mirrored' to the left (10 LEDs in total).

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c |  149 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 148 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 32c173f..8960347 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -55,7 +55,8 @@ struct lg4ff_device_entry {
 	__u16 range;
 	__u16 min_range;
 	__u16 max_range;
-	__u8  leds;
+	__u8  led_state;
+	struct led_classdev *led[5];
 	struct list_head list;
 	void (*set_range)(struct hid_device *hid, u16 range);
 };
@@ -335,6 +336,86 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
 	return count;
 }
 
+static void lg4ff_set_leds(struct hid_device *hid, __u8 leds)
+{
+	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
+
+	report->field[0]->value[0] = 0xf8;
+	report->field[0]->value[1] = 0x12;
+	report->field[0]->value[2] = leds;
+	report->field[0]->value[3] = 0x00;
+	report->field[0]->value[4] = 0x00;
+	report->field[0]->value[5] = 0x00;
+	report->field[0]->value[6] = 0x00;
+	usbhid_submit_report(hid, report, USB_DIR_OUT);
+}
+
+static void lg4ff_led_set_brightness(struct led_classdev *led_cdev,
+			enum led_brightness value)
+{
+	struct device *dev = led_cdev->dev->parent;
+	struct hid_device *hid = container_of(dev, struct hid_device, dev);
+	struct lg_drv_data *drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
+	struct lg4ff_device_entry *entry;
+	int i, state = 0;
+
+	if (!drv_data) {
+		hid_err(hid, "Device data not found.");
+		return;
+	}
+
+	entry = (struct lg4ff_device_entry *)drv_data->device_props;
+
+	if (!entry) {
+		hid_err(hid, "Device properties not found.");
+		return;
+	}
+
+	for (i = 0; i < 5; i++) {
+		if (led_cdev != entry->led[i])
+			continue;
+		state = (entry->led_state >> i) & 1;
+		if (value == LED_OFF && state) {
+			entry->led_state &= ~(1 << i);
+			lg4ff_set_leds(hid, entry->led_state);
+		} else if (value != LED_OFF && !state) {
+			entry->led_state |= 1 << i;
+			lg4ff_set_leds(hid, entry->led_state);
+		}
+		break;
+	}
+}
+
+static enum led_brightness lg4ff_led_get_brightness(struct led_classdev *led_cdev)
+{
+	struct device *dev = led_cdev->dev->parent;
+	struct hid_device *hid = container_of(dev, struct hid_device, dev);
+	struct lg_drv_data *drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
+	struct lg4ff_device_entry *entry;
+	int i, value = 0;
+
+	if (!drv_data) {
+		hid_err(hid, "Device data not found.");
+		return LED_OFF;
+	}
+
+	entry = (struct lg4ff_device_entry *)drv_data->device_props;
+
+	if (!entry) {
+		hid_err(hid, "Device properties not found.");
+		return LED_OFF;
+	}
+
+	for (i = 0; i < 5; i++)
+		if (led_cdev == entry->led[i]) {
+			value = (entry->led_state >> i) & 1;
+			break;
+		}
+
+	return value ? LED_FULL : LED_OFF;
+}
+
 int lg4ff_init(struct hid_device *hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
@@ -347,6 +428,9 @@ int lg4ff_init(struct hid_device *hid)
 	struct usb_device_descriptor *udesc;
 	int error, i, j;
 	__u16 bcdDevice, rev_maj, rev_min;
+	struct led_classdev *led;
+	size_t name_sz;
+	char *name;
 
 	/* Find the report to use */
 	if (list_empty(report_list)) {
@@ -453,14 +537,66 @@ int lg4ff_init(struct hid_device *hid)
 	if (entry->set_range != NULL)
 		entry->set_range(hid, entry->range);
 
+	/* register led subsystem - G27 only */
+	entry->led_state = 0;
+	for (j = 0; j < 5; j++)
+		entry->led[j] = NULL;
+
+	if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_G27_WHEEL) {
+		lg4ff_set_leds(hid, 0);
+
+		name_sz = strlen(dev_name(&hid->dev)) + 8;
+
+		for (j = 0; j < 5; j++) {
+			led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
+			if (!led) {
+				hid_err(hid, "can't allocate memory for LED %d\n", j);
+				error = -ENOMEM;
+				goto err;
+			}
+
+			name = (void *)(&led[1]);
+			snprintf(name, name_sz, "%s::RPM%d", dev_name(&hid->dev), j+1);
+			led->name = name;
+			led->brightness = 0;
+			led->max_brightness = 1;
+			led->brightness_get = lg4ff_led_get_brightness;
+			led->brightness_set = lg4ff_led_set_brightness;
+
+			entry->led[j] = led;
+			error = led_classdev_register(&hid->dev, led);
+			if (error) {
+				hid_err(hid, "failed to register LED %d. Aborting.\n", j);
+				goto err;
+			}
+		}
+
+		dbg_hid("sysfs interface created for leds\n");
+	}
+
 	hid_info(hid, "Force feedback for Logitech Speed Force Wireless by Simon Wood <simon@mungewell.org>\n");
 	return 0;
+
+err:
+	/* Deregister LEDs (if any) but let the driver continue */
+	for (j = 0; j < 5; j++) {
+		led = entry->led[j];
+		entry->led[j] = NULL;
+		if (!led)
+			continue;
+		led_classdev_unregister(led);
+		kfree(led);
+	}
+
+	return 0;
 }
 
 int lg4ff_deinit(struct hid_device *hid)
 {
 	struct lg4ff_device_entry *entry;
 	struct lg_drv_data *drv_data;
+	int j;
+	struct led_classdev *led;
 
 	device_remove_file(&hid->dev, &dev_attr_range);
 
@@ -474,6 +610,17 @@ int lg4ff_deinit(struct hid_device *hid)
 		hid_err(hid, "Error while deinitializing device, no device properties data.\n");
 		return -1;
 	}
+
+	/* Deregister LEDs (if any) */
+	for (j = 0; j < 5; j++) {
+		led = entry->led[j];
+		entry->led[j] = NULL;
+		if (!led)
+			continue;
+		led_classdev_unregister(led);
+		kfree(led);
+	}
+
 	/* Deallocate memory */
 	kfree(entry);
 
-- 
1.7.4.1

