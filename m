Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0C3Ur1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:47:27 -0400
Received: from legolas.restena.lu ([158.64.1.34]:54823 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab0C3Uq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:46:28 -0400
Date: Tue, 30 Mar 2010 22:43:28 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [PATCH v6 8/8] hid: add PM support to PicoLCD device
Message-ID: <20100330224328.685f74ef@neptune.home>
In-Reply-To: <20100330223224.18fe4f3e@neptune.home>
References: <20100324233707.7243b04d@neptune.home>
	<20100324234022.0361bd80@neptune.home>
	<20100326065656.GC26602@core.coreip.homeip.net>
	<20100326102951.3b9ecda1@neptune.home>
	<alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz>
	<20100327012245.0ace6a09@neptune.home>
	<alpine.LNX.2.00.1003291144350.24576@pobox.suse.cz>
	<20100329121611.0c22dcaf@pluto.restena.lu>
	<alpine.LNX.2.00.1003301010410.24576@pobox.suse.cz>
	<20100330223224.18fe4f3e@neptune.home>
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
 drivers/hid/hid-picolcd.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index fe1f772..daa7c5d 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -2255,6 +2255,43 @@ static int picolcd_raw_event(struct hid_device *hdev,
 	return 1;
 }
 
+#ifdef CONFIG_PM
+static int picolcd_suspend(struct hid_device *hdev)
+{
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
@@ -2530,6 +2567,11 @@ static struct hid_driver picolcd_driver = {
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

