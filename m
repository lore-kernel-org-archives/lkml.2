Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517Ab2AJXHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:07:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60303 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934328Ab2AJXHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:07:11 -0500
Date: Tue, 10 Jan 2012 15:07:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: JJ Ding <jj_ding@emc.com.tw>, Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH TRIVIAL 1/5] Input: keyboard: use macro
 module_platform_driver()
Message-ID: <20120110230704.GA8886@core.coreip.homeip.net>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
 <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
 <CAMuHMdWVedppkaO5sF4WH78e8rdVJKXJknFVEZQo+VD2Rxmk=A@mail.gmail.com>
 <CAMuHMdU1fv-Qx1dRstFjBkqcKswWCu34Hkeusk1vW3ReXB7CDA@mail.gmail.com>
 <20120110222231.GA16702@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110222231.GA16702@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 02:22:31PM -0800, Dmitry Torokhov wrote:
> On Tue, Jan 10, 2012 at 09:57:08PM +0100, Geert Uytterhoeven wrote:
> > 
> > Still, setting up platform_driver.probe and removing __init from all probe
> > functions is not the right thing to do, as this make (non-__init) kernel code
> > size bigger, while none of these devices are hotpluggable and thus cannot
> > appear after bootup. That's why we have platform_driver_probe() in the
> > first place. So I think all of this should be reverted for non-hotpluggable
> > drivers.
> 
> Crap, I didn't notice we messed up platform_driver_probe() users; I'll
> revert changes to these drivers.
> 

So something like below should take care of the problem.

Thanks.

-- 
Dmitry

Input: revert some over-zealous conversions to module_platform_driver()

Recent conversion to module_platform_driver() went a bit too far and
converted not only drivers that used platform_driver_register() but
also ones using platform_driver_probe(), breaking them in process.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/amikbd.c             |   15 ++++++++++++++-
 drivers/input/keyboard/davinci_keyscan.c    |   13 ++++++++++++-
 drivers/input/keyboard/nomadik-ske-keypad.c |   13 ++++++++++++-
 drivers/input/misc/twl4030-pwrbutton.c      |   15 +++++++++++++--
 drivers/input/mouse/amimouse.c              |   16 ++++++++++++++--
 drivers/input/serio/at32psif.c              |   14 +++++++++++++-
 drivers/input/touchscreen/atmel-wm97xx.c    |   13 ++++++++++++-
 drivers/input/touchscreen/mc13783_ts.c      |   13 ++++++++++++-
 8 files changed, 102 insertions(+), 10 deletions(-)


diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
index 6df5f6a..79172af 100644
--- a/drivers/input/keyboard/amikbd.c
+++ b/drivers/input/keyboard/amikbd.c
@@ -259,6 +259,19 @@ static struct platform_driver amikbd_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-module_platform_driver(amikbd_driver);
+
+static int __init amikbd_init(void)
+{
+	return platform_driver_probe(&amikbd_driver, amikbd_probe);
+}
+
+module_init(amikbd_init);
+
+static void __exit amikbd_exit(void)
+{
+	platform_driver_unregister(&amikbd_driver);
+}
+
+module_exit(amikbd_exit);
 
 MODULE_ALIAS("platform:amiga-keyboard");
diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/keyboard/davinci_keyscan.c
index 4698252..9d82b3a 100644
--- a/drivers/input/keyboard/davinci_keyscan.c
+++ b/drivers/input/keyboard/davinci_keyscan.c
@@ -328,7 +328,18 @@ static struct platform_driver davinci_ks_driver = {
 	},
 	.remove	= __devexit_p(davinci_ks_remove),
 };
-module_platform_driver(davinci_ks_driver);
+
+static int __init davinci_ks_init(void)
+{
+	return platform_driver_probe(&davinci_ks_driver, davinci_ks_probe);
+}
+module_init(davinci_ks_init);
+
+static void __exit davinci_ks_exit(void)
+{
+	platform_driver_unregister(&davinci_ks_driver);
+}
+module_exit(davinci_ks_exit);
 
 MODULE_AUTHOR("Miguel Aguilar");
 MODULE_DESCRIPTION("Texas Instruments DaVinci Key Scan Driver");
diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index 5a71e55..e35566a 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -390,7 +390,18 @@ static struct platform_driver ske_keypad_driver = {
 	.probe = ske_keypad_probe,
 	.remove = __devexit_p(ske_keypad_remove),
 };
-module_platform_driver(ske_keypad_driver);
+
+static int __init ske_keypad_init(void)
+{
+	return platform_driver_probe(&ske_keypad_driver, ske_keypad_probe);
+}
+module_init(ske_keypad_init);
+
+static void __exit ske_keypad_exit(void)
+{
+	platform_driver_unregister(&ske_keypad_driver);
+}
+module_exit(ske_keypad_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Naveen Kumar <naveen.gaddipati@stericsson.com> / Sundar Iyer <sundar.iyer@stericsson.com>");
diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index 19a6882..38e4b50 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -107,14 +107,25 @@ static int __exit twl4030_pwrbutton_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver twl4030_pwrbutton_driver = {
-	.probe		= twl4030_pwrbutton_probe,
 	.remove		= __exit_p(twl4030_pwrbutton_remove),
 	.driver		= {
 		.name	= "twl4030_pwrbutton",
 		.owner	= THIS_MODULE,
 	},
 };
-module_platform_driver(twl4030_pwrbutton_driver);
+
+static int __init twl4030_pwrbutton_init(void)
+{
+	return platform_driver_probe(&twl4030_pwrbutton_driver,
+			twl4030_pwrbutton_probe);
+}
+module_init(twl4030_pwrbutton_init);
+
+static void __exit twl4030_pwrbutton_exit(void)
+{
+	platform_driver_unregister(&twl4030_pwrbutton_driver);
+}
+module_exit(twl4030_pwrbutton_exit);
 
 MODULE_ALIAS("platform:twl4030_pwrbutton");
 MODULE_DESCRIPTION("Triton2 Power Button");
diff --git a/drivers/input/mouse/amimouse.c b/drivers/input/mouse/amimouse.c
index 39be7b8..ff5f61a 100644
--- a/drivers/input/mouse/amimouse.c
+++ b/drivers/input/mouse/amimouse.c
@@ -140,13 +140,25 @@ static int __exit amimouse_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver amimouse_driver = {
-	.probe = amimouse_probe,
 	.remove = __exit_p(amimouse_remove),
 	.driver   = {
 		.name	= "amiga-mouse",
 		.owner	= THIS_MODULE,
 	},
 };
-module_platform_driver(amimouse_driver);
+
+static int __init amimouse_init(void)
+{
+	return platform_driver_probe(&amimouse_driver, amimouse_probe);
+}
+
+module_init(amimouse_init);
+
+static void __exit amimouse_exit(void)
+{
+	platform_driver_unregister(&amimouse_driver);
+}
+
+module_exit(amimouse_exit);
 
 MODULE_ALIAS("platform:amiga-mouse");
diff --git a/drivers/input/serio/at32psif.c b/drivers/input/serio/at32psif.c
index 421a744..95280f9 100644
--- a/drivers/input/serio/at32psif.c
+++ b/drivers/input/serio/at32psif.c
@@ -358,7 +358,19 @@ static struct platform_driver psif_driver = {
 	.suspend	= psif_suspend,
 	.resume		= psif_resume,
 };
-module_platform_driver(psif_driver);
+
+static int __init psif_init(void)
+{
+	return platform_driver_probe(&psif_driver, psif_probe);
+}
+
+static void __exit psif_exit(void)
+{
+	platform_driver_unregister(&psif_driver);
+}
+
+module_init(psif_init);
+module_exit(psif_exit);
 
 MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("Atmel AVR32 PSIF PS/2 driver");
diff --git a/drivers/input/touchscreen/atmel-wm97xx.c b/drivers/input/touchscreen/atmel-wm97xx.c
index d016cb2..8034cbb 100644
--- a/drivers/input/touchscreen/atmel-wm97xx.c
+++ b/drivers/input/touchscreen/atmel-wm97xx.c
@@ -429,7 +429,18 @@ static struct platform_driver atmel_wm97xx_driver = {
 	.suspend	= atmel_wm97xx_suspend,
 	.resume		= atmel_wm97xx_resume,
 };
-module_platform_driver(atmel_wm97xx_driver);
+
+static int __init atmel_wm97xx_init(void)
+{
+	return platform_driver_probe(&atmel_wm97xx_driver, atmel_wm97xx_probe);
+}
+module_init(atmel_wm97xx_init);
+
+static void __exit atmel_wm97xx_exit(void)
+{
+	platform_driver_unregister(&atmel_wm97xx_driver);
+}
+module_exit(atmel_wm97xx_exit);
 
 MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("wm97xx continuous touch driver for Atmel AT91 and AVR32");
diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
index 68f86f7..ede0274 100644
--- a/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -240,7 +240,18 @@ static struct platform_driver mc13783_ts_driver = {
 		.name	= MC13783_TS_NAME,
 	},
 };
-module_platform_driver(mc13783_ts_driver);
+
+static int __init mc13783_ts_init(void)
+{
+	return platform_driver_probe(&mc13783_ts_driver, &mc13783_ts_probe);
+}
+module_init(mc13783_ts_init);
+
+static void __exit mc13783_ts_exit(void)
+{
+	platform_driver_unregister(&mc13783_ts_driver);
+}
+module_exit(mc13783_ts_exit);
 
 MODULE_DESCRIPTION("MC13783 input touchscreen driver");
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
