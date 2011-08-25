Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1HYHYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:24:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37040 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1HYHYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:24:34 -0400
Date: Thu, 25 Aug 2011 00:24:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linux Input <linux-input@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFT] Input: i8042 - also perform controller reset when suspending
Message-ID: <20110825072429.GA24739@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to some laptops needing i8042 reset after resuming from S2R to
get their touchpads working there is another class of laptops - ones that
need i8042 reset before going to S2R, otherwise they will simply reboot
instead of resuming.

See https://bugzilla.kernel.org/show_bug.cgi?id=15612

This change forces reset of i8042 before doing S2R.

Reported-by: Stefan Koch <stefan_koch@gmx.net>
Tested-by: Alexander van Loon <a.vanloon@alexandervanloon.nl>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

Would appreciate more testing since this may affect more boxes.

Thanks!


 drivers/input/serio/i8042.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)


diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index d37a48e..8656441 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -991,7 +991,7 @@ static int i8042_controller_init(void)
  * Reset the controller and reset CRT to the original value set by BIOS.
  */
 
-static void i8042_controller_reset(void)
+static void i8042_controller_reset(bool force_reset)
 {
 	i8042_flush();
 
@@ -1016,7 +1016,7 @@ static void i8042_controller_reset(void)
  * Reset the controller if requested.
  */
 
-	if (i8042_reset)
+	if (i8042_reset || force_reset)
 		i8042_controller_selftest();
 
 /*
@@ -1139,9 +1139,9 @@ static int i8042_controller_resume(bool force_reset)
  * upsetting it.
  */
 
-static int i8042_pm_reset(struct device *dev)
+static int i8042_pm_suspend(struct device *dev)
 {
-	i8042_controller_reset();
+	i8042_controller_reset(true);
 
 	return 0;
 }
@@ -1163,13 +1163,20 @@ static int i8042_pm_thaw(struct device *dev)
 	return 0;
 }
 
+static int i8042_pm_reset(struct device *dev)
+{
+	i8042_controller_reset(false);
+
+	return 0;
+}
+
 static int i8042_pm_restore(struct device *dev)
 {
 	return i8042_controller_resume(false);
 }
 
 static const struct dev_pm_ops i8042_pm_ops = {
-	.suspend	= i8042_pm_reset,
+	.suspend	= i8042_pm_suspend,
 	.resume		= i8042_pm_resume,
 	.thaw		= i8042_pm_thaw,
 	.poweroff	= i8042_pm_reset,
@@ -1185,7 +1192,7 @@ static const struct dev_pm_ops i8042_pm_ops = {
 
 static void i8042_shutdown(struct platform_device *dev)
 {
-	i8042_controller_reset();
+	i8042_controller_reset(false);
 }
 
 static int __init i8042_create_kbd_port(void)
@@ -1424,7 +1431,7 @@ static int __init i8042_probe(struct platform_device *dev)
  out_fail:
 	i8042_free_aux_ports();	/* in case KBD failed but AUX not */
 	i8042_free_irqs();
-	i8042_controller_reset();
+	i8042_controller_reset(false);
 	i8042_platform_device = NULL;
 
 	return error;
@@ -1434,7 +1441,7 @@ static int __devexit i8042_remove(struct platform_device *dev)
 {
 	i8042_unregister_ports();
 	i8042_free_irqs();
-	i8042_controller_reset();
+	i8042_controller_reset(false);
 	i8042_platform_device = NULL;
 
 	return 0;
-- 
Dmitry
