Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab0EBOFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 10:05:21 -0400
Received: from legolas.restena.lu ([158.64.1.34]:33199 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab0EBOFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 10:05:19 -0400
Date: Sun, 2 May 2010 16:05:05 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oliver@neukum.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nicu Pavel <npavel@ituner.com>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Subject: Re: [PATCH 2/2] hid: add PM support to PicoLCD device
Message-ID: <20100502160505.4acc9f1c@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1004272256160.9849@pobox.suse.cz>
References: <20100425214003.7e87c6a3@neptune.home>
	<20100425214306.5d7be049@neptune.home>
	<alpine.LNX.2.00.1004271525330.9849@pobox.suse.cz>
	<20100427221648.39735c41@neptune.home>
	<alpine.LNX.2.00.1004272256160.9849@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 April 2010 Jiri Kosina <jkosina@suse.cz> wrote:
> > Yeah, I could drop the #else branch (of #ifconfig CONFIG_PM).
> 
> Yup, please do so.
> 
> > Is gcc quiet about defined but unused static inline functions?
> 
> Yup, -Wunused-function doesn't warn about unused static inline function.

Ok, below is an updated patch, which also adds missing 'inline' keyword
for a few stubs and replaces #define f(a,b) to nothing with equivalent
stubs.
Is it ok to have all of this in a single patch or is it better to split
it into two (one for PM and one for cleaning up)?

Thanks,
Bruno


---
Add PM support in order to turn off backlight on suspend, restore
it on resume and especially restore complete state on reset-resume.

v2:
  Don't define stub to nothing but use static inline stubs
  Don't define picolcd_suspend_backlight() at all in !CONFIG_PM case

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd.c |   79 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index aa6f2e1..95253b3 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -763,7 +763,7 @@ static inline int picolcd_init_framebuffer(struct picolcd_data *data)
 {
 	return 0;
 }
-static void picolcd_exit_framebuffer(struct picolcd_data *data)
+static inline void picolcd_exit_framebuffer(struct picolcd_data *data)
 {
 }
 #define picolcd_fbinfo(d) NULL
@@ -852,6 +852,18 @@ static inline int picolcd_resume_backlight(struct picolcd_data *data)
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
+#endif /* CONFIG_PM */
 #else
 static inline int picolcd_init_backlight(struct picolcd_data *data,
 		struct hid_report *report)
@@ -865,6 +877,9 @@ static inline int picolcd_resume_backlight(struct picolcd_data *data)
 {
 	return 0;
 }
+static inline void picolcd_suspend_backlight(struct picolcd_data *data)
+{
+}
 #endif /* CONFIG_HID_PICOLCD_BACKLIGHT */
 
 #ifdef CONFIG_HID_PICOLCD_LCD
@@ -1098,7 +1113,7 @@ static inline int picolcd_init_leds(struct picolcd_data *data,
 {
 	return 0;
 }
-static void picolcd_exit_leds(struct picolcd_data *data)
+static inline void picolcd_exit_leds(struct picolcd_data *data)
 {
 }
 static inline int picolcd_leds_set(struct picolcd_data *data)
@@ -2214,9 +2229,18 @@ static void picolcd_exit_devfs(struct picolcd_data *data)
 	mutex_destroy(&data->mutex_flash);
 }
 #else
-#define picolcd_debug_raw_event(data, hdev, report, raw_data, size)
-#define picolcd_init_devfs(data, eeprom_r, eeprom_w, flash_r, flash_w, reset)
-static void picolcd_exit_devfs(struct picolcd_data *data)
+static inline void picolcd_debug_raw_event(struct picolcd_data *data,
+		struct hid_device *hdev, struct hid_report *report,
+		u8 *raw_data, int size)
+{
+}
+static inline void picolcd_init_devfs(struct picolcd_data *data,
+		struct hid_report *eeprom_r, struct hid_report *eeprom_w,
+		struct hid_report *flash_r, struct hid_report *flash_w,
+		struct hid_report *reset)
+{
+}
+static inline void picolcd_exit_devfs(struct picolcd_data *data)
 {
 }
 #endif /* CONFIG_DEBUG_FS */
@@ -2259,6 +2283,46 @@ static int picolcd_raw_event(struct hid_device *hdev,
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
@@ -2544,6 +2608,11 @@ static struct hid_driver picolcd_driver = {
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

