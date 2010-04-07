Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab0DGSbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:31:42 -0400
Received: from legolas.restena.lu ([158.64.1.34]:33774 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab0DGSbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:31:41 -0400
Date: Wed, 7 Apr 2010 20:31:32 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rvinyard@cs.nmsu.edu
Subject: Re: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
Message-ID: <20100407203132.7fe2d0f1@neptune.home>
In-Reply-To: <20100407092010.4cd60ece.randy.dunlap@oracle.com>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
	<20100405220414.9d90da83.randy.dunlap@oracle.com>
	<alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz>
	<20100406105635.5384a087@pluto.restena.lu>
	<20100406082614.79aaf1c5.randy.dunlap@oracle.com>
	<20100406183535.7de3c628@neptune.home>
	<20100406095633.49ec957a.randy.dunlap@oracle.com>
	<20100406230434.1336c317@neptune.home>
	<20100407092010.4cd60ece.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID_PICOLCD should depend on LCD_CLASS_DEVICE, otherwise the
build fails when HID_PICOLCD=y and LCD_CLASS_DEVICE=m:

hid-picolcd.c:(.text+0x84523f): undefined reference to `lcd_device_unregister'
hid-picolcd.c:(.text+0x8478ab): undefined reference to `lcd_device_register'
hid-picolcd.c:(.text+0x84c15f): undefined reference to `lcd_device_unregister'

Same applies to FB, BACKLIGHT_CLASS_DEVICE and LEDS_CLASS.

Add suboptions for those features to handle the deps on kbuild side
and just check HID_PICOLCD_* in the code.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---

On Wed, 07 April 2010 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> All of these user-visible kconfig options need help text also...
> 

Here is a better patch, with added documentation and stripped
select clauses under HID_PICOLCD as they are handled by HID_PICOLCD_FB.




 drivers/hid/Kconfig       |   53 +++++++++++++++++++++++++++++++++++++-------
 drivers/hid/hid-picolcd.c |   40 +++++++++++++++++-----------------
 2 files changed, 64 insertions(+), 29 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a2ecd83..782a34e 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -265,11 +265,6 @@ config HID_PETALYNX
 config HID_PICOLCD
 	tristate "PicoLCD (graphic version)"
 	depends on USB_HID
-	select FB_DEFERRED_IO if FB
-	select FB_SYS_FILLRECT if FB
-	select FB_SYS_COPYAREA if FB
-	select FB_SYS_IMAGEBLIT if FB
-	select FB_SYS_FOPS if FB
 	---help---
 	  This provides support for Minibox PicoLCD devices, currently
 	  only the graphical ones are supported.
@@ -277,14 +272,54 @@ config HID_PICOLCD
 	  This includes support for the following device features:
 	  - Keypad
 	  - Switching between Firmware and Flash mode
-	  - Framebuffer for monochrome 256x64 display
-	  - Backlight control         (needs CONFIG_BACKLIGHT_CLASS_DEVICE)
-	  - Contrast control          (needs CONFIG_LCD_CLASS_DEVICE)
-	  - General purpose outputs   (needs CONFIG_LEDS_CLASS)
 	  - EEProm / Flash access     (via debugfs)
+	  Features to selectively enable:
+	  - Framebuffer for monochrome 256x64 display
+	  - Backlight control
+	  - Contrast control
+	  - General purpose outputs
 	  Features that are not (yet) supported:
 	  - IR
 
+config HID_PICOLCD_FB
+	bool "Framebuffer support"
+	default !EMBEDDED
+	depends on HID_PICOLCD
+	depends on HID_PICOLCD=FB || FB=y
+	select FB_DEFERRED_IO
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	---help---
+	  Provide access to PicoLCD's 256x64 monochrome display via a
+	  frambuffer device.
+
+config HID_PICOLCD_BACKLIGHT
+	bool "Backlight control"
+	default !EMBEDDED
+	depends on HID_PICOLCD
+	depends on HID_PICOLCD=BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=y
+	---help---
+	  Provide access to PicoLCD's backlight control via backlight
+	  class.
+
+config HID_PICOLCD_LCD
+	bool "Contrast control"
+	default !EMBEDDED
+	depends on HID_PICOLCD
+	depends on HID_PICOLCD=LCD_CLASS_DEVICE || LCD_CLASS_DEVICE=y
+	---help---
+	  Provide access to PicoLCD's LCD contrast via lcd class.
+
+config HID_PICOLCD_LEDS
+	bool "GPO via leds class"
+	default !EMBEDDED
+	depends on HID_PICOLCD
+	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
+	---help---
+	  Provide access to PicoLCD's GPO pins via leds class.
+
 config HID_QUANTA
 	tristate "Quanta Optical Touch"
 	depends on USB_HID
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 0eacc6b..0fbc7d3 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -77,7 +77,7 @@
 #define REPORT_HOOK_VERSION    0xf7 /* LCD: IN[2], OUT[1]   */
 #define REPORT_EXIT_FLASHER    0xff /*                      Bootloader: OUT[2]         */
 
-#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+#ifdef CONFIG_HID_PICOLCD_FB
 /* Framebuffer
  *
  * The PicoLCD use a Topway LCD module of 256x64 pixel
@@ -128,7 +128,7 @@ static const struct fb_var_screeninfo picolcdfb_var = {
 	.bits_per_pixel = 1,
 	.grayscale      = 1,
 };
-#endif /* CONFIG_FB */
+#endif /* CONFIG_HID_PICOLCD_FB */
 
 /* Input device
  *
@@ -183,7 +183,7 @@ struct picolcd_data {
 	struct input_dev *input_cir;
 	unsigned short keycode[PICOLCD_KEYS];
 
-#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+#ifdef CONFIG_HID_PICOLCD_FB
 	/* Framebuffer stuff */
 	u8 fb_update_rate;
 	u8 fb_bpp;
@@ -191,21 +191,21 @@ struct picolcd_data {
 	u8 *fb_bitmap;		/* framebuffer */
 	struct fb_info *fb_info;
 	struct fb_deferred_io fb_defio;
-#endif /* CONFIG_FB */
-#if defined(CONFIG_LCD_CLASS_DEVICE) || defined(CONFIG_LCD_CLASS_DEVICE_MODULE)
+#endif /* CONFIG_HID_PICOLCD_FB */
+#ifdef CONFIG_HID_PICOLCD_LCD
 	struct lcd_device *lcd;
 	u8 lcd_contrast;
-#endif
-#if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
+#endif /* CONFIG_HID_PICOLCD_LCD */
+#ifdef CONFIG_HID_PICOLCD_BACKLIGHT
 	struct backlight_device *backlight;
 	u8 lcd_brightness;
 	u8 lcd_power;
-#endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#endif /* CONFIG_HID_PICOLCD_BACKLIGHT */
+#ifdef CONFIG_HID_PICOLCD_LEDS
 	/* LED stuff */
 	u8 led_state;
 	struct led_classdev *led[8];
-#endif /* CONFIG_LEDS_CLASS */
+#endif /* CONFIG_HID_PICOLCD_LEDS */
 
 	/* Housekeeping stuff */
 	spinlock_t lock;
@@ -287,7 +287,7 @@ static struct picolcd_pending *picolcd_send_and_wait(struct hid_device *hdev,
 	return work;
 }
 
-#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+#ifdef CONFIG_HID_PICOLCD_FB
 /* Send a given tile to PicoLCD */
 static int picolcd_fb_send_tile(struct hid_device *hdev, int chip, int tile)
 {
@@ -766,9 +766,9 @@ static void picolcd_exit_framebuffer(struct picolcd_data *data)
 {
 }
 #define picolcd_fbinfo(d) NULL
-#endif /* CONFIG_FB */
+#endif /* CONFIG_HID_PICOLCD_FB */
 
-#if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
+#ifdef CONFIG_HID_PICOLCD_BACKLIGHT
 /*
  * backlight class device
  */
@@ -864,9 +864,9 @@ static inline int picolcd_resume_backlight(struct picolcd_data *data)
 {
 	return 0;
 }
-#endif /* CONFIG_BACKLIGHT_CLASS_DEVICE */
+#endif /* CONFIG_HID_PICOLCD_BACKLIGHT */
 
-#if defined(CONFIG_LCD_CLASS_DEVICE) || defined(CONFIG_LCD_CLASS_DEVICE_MODULE)
+#ifdef CONFIG_HID_PICOLCD_LCD
 /*
  * lcd class device
  */
@@ -957,9 +957,9 @@ static inline int picolcd_resume_lcd(struct picolcd_data *data)
 {
 	return 0;
 }
-#endif /* CONFIG_LCD_CLASS_DEVICE */
+#endif /* CONFIG_HID_PICOLCD_LCD */
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#ifdef CONFIG_HID_PICOLCD_LEDS
 /**
  * LED class device
  */
@@ -1104,7 +1104,7 @@ static inline int picolcd_leds_set(struct picolcd_data *data)
 {
 	return 0;
 }
-#endif /* CONFIG_LEDS_CLASS */
+#endif /* CONFIG_HID_PICOLCD_LEDS */
 
 /*
  * input class device
@@ -1243,10 +1243,10 @@ static int picolcd_reset(struct hid_device *hdev)
 
 	picolcd_resume_lcd(data);
 	picolcd_resume_backlight(data);
-#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+#ifdef CONFIG_HID_PICOLCD_FB
 	if (data->fb_info)
 		schedule_delayed_work(&data->fb_info->deferred_work, 0);
-#endif /* CONFIG_FB */
+#endif /* CONFIG_HID_PICOLCD_FB */
 
 	picolcd_leds_set(data);
 	return 0;
-- 
1.6.4.4

