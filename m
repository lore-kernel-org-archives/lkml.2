Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031057Ab2CNV22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:28:28 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4962 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2CNV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:28:26 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=b/gStvK98Bs6YfhBwCpxRApoLO2qoBYaarCtclPE+68= c=1 sm=1
 a=WxnUcAgLoeoA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=n3DLBDIp2lSvWb96zoUu4Q==:17 a=47LbCVvxAAAA:8 a=ze6LGh-h4ytd5vF94nwA:9
 a=17bleJWlRZJabwXKCjwA:7 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>, Simon Wood <simon@mungewell.org>
Subject: [RFC] HID: hid-lg4ff g27 leds using LED subsystem
Date: Wed, 14 Mar 2012 14:28:19 -0700
Message-Id: <1331760499-28737-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1549268.LAjoPqsQ59@qosmio-x300>
References: <1549268.LAjoPqsQ59@qosmio-x300>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm posting this more as a 'Request for Comments' following on from Michal's patch
this morning.

As you can see there is are two blocks of alternative code (using current list approach
and the new structure approach - which is preferable but Michal is yet to submit that
code).

Once we get some feedback on Michals code I will re-submit this properly.

Simon.

PS. If you want to confirm the LED system works (at least doesn't crash) on another
wheel replace:
  if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_G27_WHEEL) {
with (or something):
  if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_WHEEL) {


---
 drivers/hid/hid-lg4ff.c |  183 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 182 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 1145292..1f75fd4 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -58,7 +58,8 @@ struct lg4ff_device_entry {
 	__u16 range;
 	__u16 min_range;
 	__u16 max_range;
-	__u8  leds;
+	__u8  led_state;
+	struct led_classdev *led[5];
 	struct list_head list;
 	void (*set_range)(struct hid_device *hid, u16 range);
 };
@@ -336,6 +337,124 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
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
+	struct device *dev;
+	struct hid_device *hid;
+	struct lg4ff_device_entry *uninitialized_var(entry);
+	int i, state = 0;
+
+#if 1	// old list based method
+	struct list_head *h;
+	dev = led_cdev->dev->parent;
+	hid = to_hid_device(dev);
+
+	list_for_each(h, &device_list.list) {
+		entry = list_entry(h, struct lg4ff_device_entry, list);
+		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0)
+			break;
+	}
+	if (h == &device_list.list) {
+		dbg_hid("Device not found!");
+		return;
+	}
+#else	//new method (prefered)
+	struct lg_drv_data* drv_data;
+	dev = led_cdev->dev->parent;
+	hid = container_of(dev, struct hid_device, dev);
+	drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
+
+	if (!drv_data) {
+		hid_err(hid, "Device data not found.");
+		return;
+	}
+
+	entry = (struct lg4ff_device_entry *)drv_data->dev_props; 
+#endif
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
+	struct device *dev;
+	struct hid_device *hid;
+	struct lg4ff_device_entry *uninitialized_var(entry);
+	int i, value = 0;
+
+#if 1	// old list based method
+	struct list_head *h;
+	dev = led_cdev->dev->parent;
+	hid = to_hid_device(dev);
+
+	list_for_each(h, &device_list.list) {
+		entry = list_entry(h, struct lg4ff_device_entry, list);
+		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0)
+			break;
+	}
+	if (h == &device_list.list) {
+		dbg_hid("Device not found!");
+		return LED_OFF;
+	}
+#else	//new method (prefered)
+	struct lg_drv_data* drv_data;
+	dev = led_cdev->dev->parent;
+	hid = container_of(dev, struct hid_device, dev);
+	drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
+
+	if (!drv_data) {
+		hid_err(hid, "Device data not found.");
+		return LED_OFF;
+	}
+
+	entry = (struct lg4ff_device_entry *)drv_data->dev_props; 
+#endif
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
@@ -347,6 +466,9 @@ int lg4ff_init(struct hid_device *hid)
 	struct usb_device_descriptor *udesc;
 	int error, i, j;
 	__u16 bcdDevice, rev_maj, rev_min;
+	struct led_classdev *led;
+	size_t name_sz;
+	char *name;
 
 	/* Find the report to use */
 	if (list_empty(report_list)) {
@@ -457,8 +579,55 @@ int lg4ff_init(struct hid_device *hid)
 	if (entry->set_range != NULL)
 		entry->set_range(hid, entry->range);
 
+	/* register led subsystem - G27 only */
+	entry->led_state = 0;
+	if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_G27_WHEEL) {
+		lg4ff_set_leds(hid, 0);
+
+		name_sz = strlen(dev_name(&hid->dev)) + 8;
+
+		for (i = 0; i < 5; i++) {
+			led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
+			if (!led) {
+				hid_err(hid, "can't allocate memory for LED %d\n", i);
+				error = -ENOMEM;
+				goto err;
+			}
+
+			name = (void *)(&led[1]);
+			snprintf(name, name_sz, "%s::RPM%d", dev_name(&hid->dev), i+1);
+			led->name = name;
+			led->brightness = 0;
+			led->max_brightness = 1;
+			led->brightness_get = lg4ff_led_get_brightness;
+			led->brightness_set = lg4ff_led_set_brightness;
+
+			entry->led[i] = led;
+			error = led_classdev_register(&hid->dev, led);
+			if (error) {
+				hid_err(hid, "failed to register LED %d. Aborting.\n", i);
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
+	for (i = 0; i < 5; i++) {
+		led = entry->led[i];
+		entry->led[i] = NULL;
+		if (!led)
+			continue;
+		led_classdev_unregister(led);
+		kfree(led);
+	}
+
+	return 0;
 }
 
 int lg4ff_deinit(struct hid_device *hid)
@@ -466,12 +635,24 @@ int lg4ff_deinit(struct hid_device *hid)
 	bool found = 0;
 	struct lg4ff_device_entry *entry;
 	struct list_head *h, *g;
+	int i;
+	struct led_classdev *led;
 	
 	device_remove_file(&hid->dev, &dev_attr_range);
 
 	list_for_each_safe(h, g, &device_list.list) {
 		entry = list_entry(h, struct lg4ff_device_entry, list);
 		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0) {
+			/* Deregister LEDs (if any) */
+			for (i = 0; i < 5; i++) {
+				led = entry->led[i];
+				entry->led[i] = NULL;
+				if (!led)
+					continue;
+				led_classdev_unregister(led);
+				kfree(led);
+			}
+
 			list_del(h);
 			kfree(entry->device_id);
 			kfree(entry);
-- 
1.7.4.1

