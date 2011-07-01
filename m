Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab1GAJfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:35:33 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:40029 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab1GAJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:29 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentincj@iksaif.net>, Nate Weibley <nweibley@gmail.com>,
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 06/16] asus-wmi: add keyboard backlight support
Date: Fri,  1 Jul 2011 11:34:31 +0200
Message-Id: <1309512881-2901-7-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentincj@iksaif.net>

Based on a patch from Nate Weibley. <nweibley@gmail.com>.

Cc: Nate Weibley <nweibley@gmail.com>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-wmi.c |  130 +++++++++++++++++++++++++++++++++-----
 1 files changed, 113 insertions(+), 17 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 688fcf7..619e3e3 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -66,6 +66,8 @@ MODULE_LICENSE("GPL");
 #define NOTIFY_BRNUP_MAX		0x1f
 #define NOTIFY_BRNDOWN_MIN		0x20
 #define NOTIFY_BRNDOWN_MAX		0x2e
+#define NOTIFY_KBD_BRTUP		0xc4
+#define NOTIFY_KBD_BRTDWN		0xc5
 
 /* WMI Methods */
 #define ASUS_WMI_METHODID_SPEC	        0x43455053 /* BIOS SPECification */
@@ -174,8 +176,11 @@ struct asus_wmi {
 
 	struct led_classdev tpd_led;
 	int tpd_led_wk;
+	struct led_classdev kbd_led;
+	int kbd_led_wk;
 	struct workqueue_struct *led_workqueue;
 	struct work_struct tpd_led_work;
+	struct work_struct kbd_led_work;
 
 	struct asus_rfkill wlan;
 	struct asus_rfkill bluetooth;
@@ -360,30 +365,79 @@ static enum led_brightness tpd_led_get(struct led_classdev *led_cdev)
 	return read_tpd_led_state(asus);
 }
 
-static int asus_wmi_led_init(struct asus_wmi *asus)
+static void kbd_led_update(struct work_struct *work)
 {
-	int rv;
+	int ctrl_param = 0;
+	struct asus_wmi *asus;
 
-	if (read_tpd_led_state(asus) < 0)
-		return 0;
+	asus = container_of(work, struct asus_wmi, kbd_led_work);
 
-	asus->led_workqueue = create_singlethread_workqueue("led_workqueue");
-	if (!asus->led_workqueue)
-		return -ENOMEM;
-	INIT_WORK(&asus->tpd_led_work, tpd_led_update);
+	/*
+	 * bits 0-2: level
+	 * bit 7: light on/off
+	 */
+	if (asus->kbd_led_wk > 0)
+		ctrl_param = 0x80 | (asus->kbd_led_wk & 0x7F);
 
-	asus->tpd_led.name = "asus::touchpad";
-	asus->tpd_led.brightness_set = tpd_led_set;
-	asus->tpd_led.brightness_get = tpd_led_get;
-	asus->tpd_led.max_brightness = 1;
+	asus_wmi_set_devstate(ASUS_WMI_DEVID_KBD_BACKLIGHT, ctrl_param, NULL);
+}
 
-	rv = led_classdev_register(&asus->platform_device->dev, &asus->tpd_led);
-	if (rv) {
-		destroy_workqueue(asus->led_workqueue);
-		return rv;
+static int kbd_led_read(struct asus_wmi *asus, int *level, int *env)
+{
+	int retval;
+
+	/*
+	 * bits 0-2: level
+	 * bit 7: light on/off
+	 * bit 8-10: environment (0: dark, 1: normal, 2: light)
+	 * bit 17: status unknown
+	 */
+	retval = asus_wmi_get_devstate_bits(asus, ASUS_WMI_DEVID_KBD_BACKLIGHT,
+					    0xFFFF);
+
+	if (retval == 0x8000)
+		retval = -ENODEV;
+
+	if (retval >= 0) {
+		if (level)
+			*level = retval & 0x80 ? retval & 0x7F : 0;
+		if (env)
+			*env = (retval >> 8) & 0x7F;
+		retval = 0;
 	}
 
-	return 0;
+	return retval;
+}
+
+static void kbd_led_set(struct led_classdev *led_cdev,
+			enum led_brightness value)
+{
+	struct asus_wmi *asus;
+
+	asus = container_of(led_cdev, struct asus_wmi, kbd_led);
+
+	if (value > asus->kbd_led.max_brightness)
+		value = asus->kbd_led.max_brightness;
+	else if (value < 0)
+		value = 0;
+
+	asus->kbd_led_wk = value;
+	queue_work(asus->led_workqueue, &asus->kbd_led_work);
+}
+
+static enum led_brightness kbd_led_get(struct led_classdev *led_cdev)
+{
+	struct asus_wmi *asus;
+	int retval, value;
+
+	asus = container_of(led_cdev, struct asus_wmi, kbd_led);
+
+	retval = kbd_led_read(asus, &value, NULL);
+
+	if (retval < 0)
+		return retval;
+
+	return value;
 }
 
 static void asus_wmi_led_exit(struct asus_wmi *asus)
@@ -394,6 +448,48 @@ static void asus_wmi_led_exit(struct asus_wmi *asus)
 		destroy_workqueue(asus->led_workqueue);
 }
 
+static int asus_wmi_led_init(struct asus_wmi *asus)
+{
+	int rv = 0;
+
+	asus->led_workqueue = create_singlethread_workqueue("led_workqueue");
+	if (!asus->led_workqueue)
+		return -ENOMEM;
+
+	if (read_tpd_led_state(asus) >= 0) {
+		INIT_WORK(&asus->tpd_led_work, tpd_led_update);
+
+		asus->tpd_led.name = "asus::touchpad";
+		asus->tpd_led.brightness_set = tpd_led_set;
+		asus->tpd_led.brightness_get = tpd_led_get;
+		asus->tpd_led.max_brightness = 1;
+
+		rv = led_classdev_register(&asus->platform_device->dev,
+					   &asus->tpd_led);
+		if (rv)
+			goto error;
+	}
+
+	if (kbd_led_read(asus, NULL, NULL) >= 0) {
+		INIT_WORK(&asus->kbd_led_work, kbd_led_update);
+
+		asus->kbd_led.name = "asus::kbd_backlight";
+		asus->kbd_led.brightness_set = kbd_led_set;
+		asus->kbd_led.brightness_get = kbd_led_get;
+		asus->kbd_led.max_brightness = 3;
+
+		rv = led_classdev_register(&asus->platform_device->dev,
+					   &asus->kbd_led);
+	}
+
+error:
+	if (rv)
+		asus_wmi_led_exit(asus);
+
+	return rv;
+}
+
+
 /*
  * PCI hotplug (for wlan rfkill)
  */
-- 
1.7.3.4

