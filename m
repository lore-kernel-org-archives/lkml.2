Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab0IRTQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:00 -0400
Received: from kroah.org ([198.145.64.141]:43723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab0IRTP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:58 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:05 2010
Message-Id: <20100918191305.147005266@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [091/129] Input: i8042 - reset keyboard controller wehen resuming from S2R
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 1ca56e513a9fd356d5a9e0de45dbe0e189e00386 upstream.

Some laptops, such as Lenovo 3000 N100, require keyboard controller reset
in order to have touchpad operable after suspend to RAM. Even if box does
not need the reset it should be safe to do so, so instead of chasing
after misbehaving boxes and grow DMI tables, let's reset the controller
unconditionally.

Reported-and-tested-by: Jerome Lacoste <jerome.lacoste@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042.c |   65 +++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 24 deletions(-)

--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -861,9 +861,6 @@ static int i8042_controller_selftest(voi
 	unsigned char param;
 	int i = 0;
 
-	if (!i8042_reset)
-		return 0;
-
 	/*
 	 * We try this 5 times; on some really fragile systems this does not
 	 * take the first time...
@@ -1020,7 +1017,8 @@ static void i8042_controller_reset(void)
  * Reset the controller if requested.
  */
 
-	i8042_controller_selftest();
+	if (i8042_reset)
+		i8042_controller_selftest();
 
 /*
  * Restore the original control register setting.
@@ -1094,23 +1092,11 @@ static void i8042_dritek_enable(void)
 #ifdef CONFIG_PM
 
 /*
- * Here we try to restore the original BIOS settings to avoid
- * upsetting it.
- */
-
-static int i8042_pm_reset(struct device *dev)
-{
-	i8042_controller_reset();
-
-	return 0;
-}
-
-/*
  * Here we try to reset everything back to a state we had
  * before suspending.
  */
 
-static int i8042_pm_restore(struct device *dev)
+static int i8042_controller_resume(bool force_reset)
 {
 	int error;
 
@@ -1118,9 +1104,11 @@ static int i8042_pm_restore(struct devic
 	if (error)
 		return error;
 
-	error = i8042_controller_selftest();
-	if (error)
-		return error;
+	if (i8042_reset || force_reset) {
+		error = i8042_controller_selftest();
+		if (error)
+			return error;
+	}
 
 /*
  * Restore original CTR value and disable all ports
@@ -1162,6 +1150,28 @@ static int i8042_pm_restore(struct devic
 	return 0;
 }
 
+/*
+ * Here we try to restore the original BIOS settings to avoid
+ * upsetting it.
+ */
+
+static int i8042_pm_reset(struct device *dev)
+{
+	i8042_controller_reset();
+
+	return 0;
+}
+
+static int i8042_pm_resume(struct device *dev)
+{
+	/*
+	 * On resume from S2R we always try to reset the controller
+	 * to bring it in a sane state. (In case of S2D we expect
+	 * BIOS to reset the controller for us.)
+	 */
+	return i8042_controller_resume(true);
+}
+
 static int i8042_pm_thaw(struct device *dev)
 {
 	i8042_interrupt(0, NULL);
@@ -1169,9 +1179,14 @@ static int i8042_pm_thaw(struct device *
 	return 0;
 }
 
+static int i8042_pm_restore(struct device *dev)
+{
+	return i8042_controller_resume(false);
+}
+
 static const struct dev_pm_ops i8042_pm_ops = {
 	.suspend	= i8042_pm_reset,
-	.resume		= i8042_pm_restore,
+	.resume		= i8042_pm_resume,
 	.thaw		= i8042_pm_thaw,
 	.poweroff	= i8042_pm_reset,
 	.restore	= i8042_pm_restore,
@@ -1389,9 +1404,11 @@ static int __init i8042_probe(struct pla
 
 	i8042_platform_device = dev;
 
-	error = i8042_controller_selftest();
-	if (error)
-		return error;
+	if (i8042_reset) {
+		error = i8042_controller_selftest();
+		if (error)
+			return error;
+	}
 
 	error = i8042_controller_init();
 	if (error)


