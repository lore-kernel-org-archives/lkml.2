Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2LCOhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:37:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43926 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755511Ab2LCOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:58 -0500
Message-Id: <20121203143151.799012126@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stefan Koch <stefan_koch@gmx.net>,
        Alexander van Loon <a.vanloon@alexandervanloon.nl>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [ 30/89] Input: i8042 - also perform controller reset when suspending
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 1729ad1f4f9e167ade84ca8b5269695c42351160 upstream.

In addition to some laptops needing i8042 reset after resuming from S2R to
get their touchpads working there is another class of laptops - ones that
need i8042 reset before going to S2R, otherwise they will simply reboot
instead of resuming.

See https://bugzilla.kernel.org/show_bug.cgi?id=15612

This change forces reset of i8042 before doing S2R.

Reported-by: Stefan Koch <stefan_koch@gmx.net>
Tested-by: Alexander van Loon <a.vanloon@alexandervanloon.nl>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/serio/i8042.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

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


