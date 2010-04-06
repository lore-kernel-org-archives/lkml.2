Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab0DFVEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:04:48 -0400
Received: from legolas.restena.lu ([158.64.1.34]:52051 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab0DFVEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:04:41 -0400
Date: Tue, 6 Apr 2010 23:04:34 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rvinyard@cs.nmsu.edu
Subject: Re: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
Message-ID: <20100406230434.1336c317@neptune.home>
In-Reply-To: <20100406095633.49ec957a.randy.dunlap@oracle.com>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
	<20100405220414.9d90da83.randy.dunlap@oracle.com>
	<alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz>
	<20100406105635.5384a087@pluto.restena.lu>
	<20100406082614.79aaf1c5.randy.dunlap@oracle.com>
	<20100406183535.7de3c628@neptune.home>
	<20100406095633.49ec957a.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 April 2010 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > It triggers the issue by having PicoLCD built-in while one of the
> > optional dependencies as a module.
> 
> Yes, basically what the patch description said.

Oops, sorry I didn't completely read the patch description.

> > Any idea of how this can be solved with kbuild in order to keep the
> > dependencies optional?
> > 
> > Something that would satisfy the following pseudocode:
> >   if CONFIG_HID_PICOLCD == y
> >     assert(CONFIG_LCD_CLASS_DEVICE != m)
> > 
> 
> If you don't want the kconfig machinery to do that (it appears that you don't),
> then I guess that you'll need to expand the source code to handle
> CONFIG_LCD_CLASS_DEVICE=y and CONFIG_LCD_CLASS_DEVICE=m differently.
> Or only handle them differently if HID_PICOLCD=y.  :(

Below a patch (against 2.6.34-rc3 + Jiri's picolcd branch) which
should fix above issue keeping the deps optional.

With it it's not yet possible to select the deps from HID menu.

I did a few oldconfig and compile-tests with PICOLCD=y/m and same for
the deps (not switched FB for those tests).

Bruno





HID_PICOLCD should depend on LCD_CLASS_DEVICE, otherwise the
build fails when HID_PICOLCD=y and LCD_CLASS_DEVICE=m:

hid-picolcd.c:(.text+0x84523f): undefined reference to `lcd_device_unregister'
hid-picolcd.c:(.text+0x8478ab): undefined reference to `lcd_device_register'
hid-picolcd.c:(.text+0x84c15f): undefined reference to `lcd_device_unregister'

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a2ecd83..39df4f5 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -285,6 +285,35 @@ config HID_PICOLCD
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
+
+config HID_PICOLCD_BACKLIGHT
+	bool "Backlight control"
+	default !EMBEDDED
+	depends on HID_PICOLCD
+	depends on HID_PICOLCD=BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=y
+
+config HID_PICOLCD_LCD
+	bool "Contrast control"
+	default !EMBEDDED
+	depends on HID_PICOLCD
+	depends on HID_PICOLCD=LCD_CLASS_DEVICE || LCD_CLASS_DEVICE=y
+
+config HID_PICOLCD_LEDS
+	bool "GPO via leds class"
+	default !EMBEDDED
+	depends on HID_PICOLCD
+	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
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
