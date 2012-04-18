Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2DRHDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:03:24 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54691 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2DRHDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:03:23 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=zu4PKjlF+9DoPrG/TPTQ4CC8dREy1gI1uGhqrRhVwqE= c=1 sm=1
 a=WfSpWzy0sTQA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=47LbCVvxAAAA:8 a=t_UTetj8Tjv4-yJ4BZQA:9
 a=Ca1vQv3fmSHPJCucvE0A:7 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>, Simon Wood <simon@mungewell.org>
Subject: [PATCH 1/2] HID: hid-lg4ff: Add support for G27 LEDs
Date: Wed, 18 Apr 2012 00:03:07 -0700
Message-Id: <1334732588-9351-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <alpine.LNX.2.00.1204131458290.16373@pobox.suse.cz>
References: <alpine.LNX.2.00.1204131458290.16373@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds supports for controlling the LED 'tachometer' on
the G27 wheel, via the LED subsystem.

The 5 LEDs are arranged from right (1=grn, 2=grn, 3=yel, 4=yel, 5=red)
and 'mirrored' to the left (10 LEDs in total).

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c |  155 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 154 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 32c173f..ab5232e 100644
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
@@ -335,6 +336,88 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
 	return count;
 }
 
+#ifdef CONFIG_LEDS_CLASS
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
+#endif
+
 int lg4ff_init(struct hid_device *hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
@@ -453,6 +536,57 @@ int lg4ff_init(struct hid_device *hid)
 	if (entry->set_range != NULL)
 		entry->set_range(hid, entry->range);
 
+	/* register led subsystem - G27 only */
+	entry->led_state = 0;
+	for (j = 0; j < 5; j++)
+		entry->led[j] = NULL;
+
+#ifdef CONFIG_LEDS_CLASS
+	if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_G27_WHEEL) {
+		struct led_classdev *led;
+		size_t name_sz;
+		char *name;
+
+		lg4ff_set_leds(hid, 0);
+
+		name_sz = strlen(dev_name(&hid->dev)) + 8;
+
+		for (j = 0; j < 5; j++) {
+			led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
+			if (!led) {
+				hid_err(hid, "can't allocate memory for LED %d\n", j);
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
+
+			if (error) {
+				hid_err(hid, "failed to register LED %d. Aborting.\n", j);
+err:
+				/* Deregister LEDs (if any) but let the driver continue */
+				for (j = 0; j < 5; j++) {
+					led = entry->led[j];
+					entry->led[j] = NULL;
+					if (!led)
+						continue;
+					led_classdev_unregister(led);
+				kfree(led);
+				}
+				break;	/* Don't create any more LEDs */
+			}
+		}
+	}
+#endif
+
 	hid_info(hid, "Force feedback for Logitech Speed Force Wireless by Simon Wood <simon@mungewell.org>\n");
 	return 0;
 }
@@ -474,6 +608,25 @@ int lg4ff_deinit(struct hid_device *hid)
 		hid_err(hid, "Error while deinitializing device, no device properties data.\n");
 		return -1;
 	}
+
+#ifdef CONFIG_LEDS_CLASS
+	{
+		int j;
+		struct led_classdev *led;
+
+		/* Deregister LEDs (if any) */
+		for (j = 0; j < 5; j++) {
+
+			led = entry->led[j];
+			entry->led[j] = NULL;
+			if (!led)
+				continue;
+			led_classdev_unregister(led);
+			kfree(led);
+		}
+	}
+#endif
+
 	/* Deallocate memory */
 	kfree(entry);
 
-- 
1.7.4.1

