Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0KKOEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:04:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:14925 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0KKOD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:03:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,183,1288594800"; 
   d="scan'208";a="676521923"
From: "Lighthart, EricX" <ericx.lighthart@intel.com>
To: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "pb@handhelds.org" <pb@handhelds.org>,
        "ext-mika.1.westerberg@nokia.com" <ext-mika.1.westerberg@nokia.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Nov 2010 06:03:35 -0800
Subject: [PATCH] input: Add sysfs interface to on/off state of GPIO keys and
 switches
Thread-Topic: [PATCH] input: Add sysfs interface to on/off state of GPIO
 keys and switches
Thread-Index: AcuBqTuQR0+NZ8xqRfeJ+2VU62iZlA==
Message-ID: <E559D19195578B4E9ECB3919FF99F9792A585A8BB1@orsmsx509.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User space cannot learn the current state of a GPIO key or switch.
Input system reports only changes, not state.

Add two sysfs attributes, one each for keys and switches, that
report lists of keys or switches currently "on."

Signed-off-by: Eric Lighthart <ericx.lighthart@intel.com>
---
This is as much an RFC as a patch submission.  Is the user space
interface proposed here an OK thing?  I'd be equally happy to find
a better or already-existing solution.

 drivers/input/keyboard/gpio_keys.c |   68 ++++++++++++++++++++++++++++--------
 1 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 6069abe..7715837 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -1,6 +1,12 @@
 /*
  * Driver for keys on GPIO lines capable of generating interrupts.
  *
+ * Copyright (c) 2010 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
  * Copyright 2005 Phil Blundell
  *
  * This program is free software; you can redistribute it and/or modify
@@ -44,6 +50,10 @@ struct gpio_keys_drvdata {
 	struct gpio_button_data data[0];
 };
 
+#define OP_LIST		0
+#define OP_LIST_DISABLE	1
+#define OP_LIST_ON	2
+
 /*
  * SYSFS interface for enabling/disabling keys and switches:
  *
@@ -54,10 +64,15 @@ struct gpio_keys_drvdata {
  *	                         disabled
  *	disabled_keys [rw]     - bitmap of keys currently disabled
  *	disabled_switches [rw] - bitmap of switches currently disabled
+ *	on_keys [ro]           - bitmap of keys currently "on"
+ *	on_switches [ro]       - bitmap of switches currently "on"
+ *
+ * Userland can find switches and keys currently "on" (and deduce those that
+ * are therefore "off") via the on_* attrributes.
  *
- * Userland can change these values and hence disable event generation
- * for each key (or switch). Disabling a key means its interrupt line
- * is disabled.
+ * Userland can change the dislabled_* values and hence disable event
+ * generation for each key (or switch). Disabling a key means its interrupt
+ * line is disabled.
  *
  * For example, if we have following switches set up as gpio-keys:
  *	SW_DOCK = 5
@@ -152,8 +167,8 @@ static void gpio_keys_enable_button(struct gpio_button_data *bdata)
  * errno on failure.
  */
 static ssize_t gpio_keys_attr_show_helper(struct gpio_keys_drvdata *ddata,
-					  char *buf, unsigned int type,
-					  bool only_disabled)
+					 char *buf, unsigned int type,
+					 int op)
 {
 	int n_events = get_n_events_by_type(type);
 	unsigned long *bits;
@@ -170,10 +185,25 @@ static ssize_t gpio_keys_attr_show_helper(struct gpio_keys_drvdata *ddata,
 		if (bdata->button->type != type)
 			continue;
 
-		if (only_disabled && !bdata->disabled)
-			continue;
-
-		__set_bit(bdata->button->code, bits);
+		switch (op) {
+		case OP_LIST:
+			/* Just list all the buttons/switches */
+			__set_bit(bdata->button->code, bits);
+			break;
+
+		case OP_LIST_DISABLE:
+			/* List the disabled buttons/switches */
+			if (bdata->disabled)
+				__set_bit(bdata->button->code, bits);
+			break;
+
+		case OP_LIST_ON:
+			/* List the buttons/switches that are "on" */
+			if ((gpio_get_value(bdata->button->gpio) ? 1 : 0) ^
+						bdata->button->active_low)
+				__set_bit(bdata->button->code, bits);
+			break;
+		}
 	}
 
 	ret = bitmap_scnlistprintf(buf, PAGE_SIZE - 2, bits, n_events);
@@ -246,7 +276,7 @@ out:
 	return error;
 }
 
-#define ATTR_SHOW_FN(name, type, only_disabled)				\
+#define ATTR_SHOW_FN(name, type, op)				\
 static ssize_t gpio_keys_show_##name(struct device *dev,		\
 				     struct device_attribute *attr,	\
 				     char *buf)				\
@@ -255,22 +285,28 @@ static ssize_t gpio_keys_show_##name(struct device *dev,		\
 	struct gpio_keys_drvdata *ddata = platform_get_drvdata(pdev);	\
 									\
 	return gpio_keys_attr_show_helper(ddata, buf,			\
-					  type, only_disabled);		\
+					  type, op);			\
 }
 
-ATTR_SHOW_FN(keys, EV_KEY, false);
-ATTR_SHOW_FN(switches, EV_SW, false);
-ATTR_SHOW_FN(disabled_keys, EV_KEY, true);
-ATTR_SHOW_FN(disabled_switches, EV_SW, true);
+ATTR_SHOW_FN(keys, EV_KEY, OP_LIST);
+ATTR_SHOW_FN(switches, EV_SW, OP_LIST);
+ATTR_SHOW_FN(disabled_keys, EV_KEY, OP_LIST_DISABLE);
+ATTR_SHOW_FN(disabled_switches, EV_SW, OP_LIST_DISABLE);
+ATTR_SHOW_FN(on_keys, EV_KEY, OP_LIST_ON);
+ATTR_SHOW_FN(on_switches, EV_SW, OP_LIST_ON);
 
 /*
  * ATTRIBUTES:
  *
  * /sys/devices/platform/gpio-keys/keys [ro]
  * /sys/devices/platform/gpio-keys/switches [ro]
+ * /sys/devices/platform/gpio-keys/on_keys [ro]
+ * /sys/devices/platform/gpio-keys/on_switches [ro]
  */
 static DEVICE_ATTR(keys, S_IRUGO, gpio_keys_show_keys, NULL);
 static DEVICE_ATTR(switches, S_IRUGO, gpio_keys_show_switches, NULL);
+static DEVICE_ATTR(on_keys, S_IRUGO, gpio_keys_show_on_keys, NULL);
+static DEVICE_ATTR(on_switches, S_IRUGO, gpio_keys_show_on_switches, NULL);
 
 #define ATTR_STORE_FN(name, type)					\
 static ssize_t gpio_keys_store_##name(struct device *dev,		\
@@ -310,6 +346,8 @@ static struct attribute *gpio_keys_attrs[] = {
 	&dev_attr_switches.attr,
 	&dev_attr_disabled_keys.attr,
 	&dev_attr_disabled_switches.attr,
+	&dev_attr_on_keys.attr,
+	&dev_attr_on_switches.attr,
 	NULL,
 };
 
-- 
1.7.2.1

