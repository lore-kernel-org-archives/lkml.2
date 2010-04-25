Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0DYUPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 16:15:50 -0400
Received: from legolas.restena.lu ([158.64.1.34]:47827 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab0DYUPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 16:15:47 -0400
Date: Sun, 25 Apr 2010 21:43:06 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nicu Pavel <npavel@ituner.com>, Jaya Kumar <jayakumar.lkml@gmail.com>,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Subject: [PATCH 2/2] hid: add PM support to PicoLCD device
Message-ID: <20100425214306.5d7be049@neptune.home>
In-Reply-To: <20100425214003.7e87c6a3@neptune.home>
References: <20100425214003.7e87c6a3@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PM support in order to turn off backlight on suspend, restore
it on resume and especially restore complete state on reset-resume.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd.c |   61 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index aa6f2e1..c652390 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -852,6 +852,20 @@ static inline int picolcd_resume_backlight(struct picolcd_data *data)
 	return picolcd_set_brightness(data->backlight);
 }
 
+#ifdef CONFIG_PM
+static void picolcd_suspend_backlight(struct picolcd_data *data)
+{
+	int bl_power = data->lcd_power;
+	if (!data->backlight)
+		return;
+
+	data->backlight->props.power = FB_BLANK_POWERDOWN;
+	picolcd_set_brightness(data->backlight);
+	data->lcd_power = data->backlight->props.power = bl_power;
+}
+#else
+#define picolcd_suspend_backlight(a)
+#endif /* CONFIG_PM */
 #else
 static inline int picolcd_init_backlight(struct picolcd_data *data,
 		struct hid_report *report)
@@ -865,6 +879,7 @@ static inline int picolcd_resume_backlight(struct picolcd_data *data)
 {
 	return 0;
 }
+#define picolcd_suspend_backlight(a)
 #endif /* CONFIG_HID_PICOLCD_BACKLIGHT */
 
 #ifdef CONFIG_HID_PICOLCD_LCD
@@ -2259,6 +2274,46 @@ static int picolcd_raw_event(struct hid_device *hdev,
 	return 1;
 }
 
+#ifdef CONFIG_PM
+static int picolcd_suspend(struct hid_device *hdev, pm_message_t message)
+{
+	if (message.event & PM_EVENT_AUTO)
+		return 0;
+
+	picolcd_suspend_backlight(hid_get_drvdata(hdev));
+	dbg_hid(PICOLCD_NAME " device ready for suspend\n");
+	return 0;
+}
+
+static int picolcd_resume(struct hid_device *hdev)
+{
+	int ret;
+	ret = picolcd_resume_backlight(hid_get_drvdata(hdev));
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring backlight failed: %d\n", ret);
+	return 0;
+}
+
+static int picolcd_reset_resume(struct hid_device *hdev)
+{
+	int ret;
+	ret = picolcd_reset(hdev);
+	if (ret)
+		dbg_hid(PICOLCD_NAME " resetting our device failed: %d\n", ret);
+	ret = picolcd_fb_reset(hid_get_drvdata(hdev), 0);
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring framebuffer content failed: %d\n", ret);
+	ret = picolcd_resume_lcd(hid_get_drvdata(hdev));
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring lcd failed: %d\n", ret);
+	ret = picolcd_resume_backlight(hid_get_drvdata(hdev));
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring backlight failed: %d\n", ret);
+	picolcd_leds_set(hid_get_drvdata(hdev));
+	return 0;
+}
+#endif
+
 /* initialize keypad input device */
 static int picolcd_init_keys(struct picolcd_data *data,
 		struct hid_report *report)
@@ -2544,6 +2599,11 @@ static struct hid_driver picolcd_driver = {
 	.probe =         picolcd_probe,
 	.remove =        picolcd_remove,
 	.raw_event =     picolcd_raw_event,
+#ifdef CONFIG_PM
+	.suspend =       picolcd_suspend,
+	.resume =        picolcd_resume,
+	.reset_resume =  picolcd_reset_resume,
+#endif
 };
 
 static int __init picolcd_init(void)
-- 
1.6.4.4

