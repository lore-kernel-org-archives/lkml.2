Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0DIM4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 08:56:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:43153 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab0DIM4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 08:56:21 -0400
Date: Fri, 9 Apr 2010 14:56:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, Pavel Machek <pavel@ucw.cz>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Marcin Derlukiewicz <marcin@derlukiewicz.pl>
Subject: [PATCH] lis3lv02d: provide means to disable polled input interface
Message-ID: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lis3lv02d driver creates emulated joystick interface for events reported 
by the sensor.
Because of HW, this has to be implemented as polled input device, with
20Hz frequency.

This is reported to create 20% CPU usage increase (and proportionaly higher
power consumption) just for the ipolldevd kernel thread (which is used
to read the sensor).

As most users probably only use the freefall functionality of the driver
and not the joystick interface, provide means for disabling the registration
of joystick device altogether via module parameter.
(I'd rather make it default to 0, but this will break backwards compatibility).

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 
 drivers/hwmon/lis3lv02d.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index b2f2277..bfbc02c 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -41,6 +41,9 @@
 
 /* joystick device poll interval in milliseconds */
 #define MDPS_POLL_INTERVAL 50
+static int enable_joystick = 1;
+module_param_named(joystick, enable_joystick, int, 0400);
+MODULE_PARM_DESC(joystick, "Enable joystick emulation (0 = disable, 1 = enable). Default: 1");
 /*
  * The sensor can also generate interrupts (DRDY) but it's pretty pointless
  * because they are generated even if the data do not change. So it's better
@@ -434,14 +437,13 @@ EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
 
 void lis3lv02d_joystick_disable(void)
 {
-	if (!lis3_dev.idev)
-		return;
-
 	if (lis3_dev.irq)
 		misc_deregister(&lis3lv02d_misc_device);
-	input_unregister_polled_device(lis3_dev.idev);
-	input_free_polled_device(lis3_dev.idev);
-	lis3_dev.idev = NULL;
+	if (lis3_dev.idev) {
+		input_unregister_polled_device(lis3_dev.idev);
+		input_free_polled_device(lis3_dev.idev);
+		lis3_dev.idev = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
 
@@ -559,7 +561,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	lis3lv02d_add_fs(dev);
 	lis3lv02d_poweron(dev);
 
-	if (lis3lv02d_joystick_enable())
+	if (enable_joystick && lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
 
 	/* passing in platform specific data is purely optional and only
