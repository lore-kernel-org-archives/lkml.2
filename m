Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab2DOT5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 15:57:45 -0400
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:36363 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2DOT5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 15:57:44 -0400
Date: Sun, 15 Apr 2012 21:57:42 +0200
From: David Madore <david+ml@madore.org>
To: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: [PATCH] iTCO_wdt: restore watchdog state and timeout after resume
Message-ID: <20120415195741.GA25635@aldebaran.gro-tsen.net>
References: <20120415163130.GA12802@aldebaran.gro-tsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120415163130.GA12802@aldebaran.gro-tsen.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iTCO_wdt watchdog state and timeout (heartbeat) need to be
restored after resume.  Use pm_ops to do this.

Signed-off-by: David A. Madore <david+linux@madore.org>

---

--- old/drivers/watchdog/iTCO_wdt.c	2012-04-13 18:42:02.000000000 +0200
+++ new/drivers/watchdog/iTCO_wdt.c	2012-04-15 20:43:39.609718697 +0200
@@ -56,6 +56,7 @@
 #include <linux/kernel.h>		/* For printk/panic/... */
 #include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
 							(WATCHDOG_MINOR) */
+#include <linux/pm.h>			/* For struct dev_pm_ops */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/init.h>			/* For __init/__exit/... */
 #include <linux/fs.h>			/* For file operations */
@@ -400,6 +401,8 @@ static struct {		/* this is private data
 	spinlock_t io_lock;
 	/* the PCI-device */
 	struct pci_dev *pdev;
+	/* whether the timer is started */
+	char is_started;
 } iTCO_wdt_private;
 
 /* the watchdog platform device */
@@ -506,6 +509,7 @@ static int iTCO_wdt_start(void)
 	val &= 0xf7ff;
 	outw(val, TCO1_CNT);
 	val = inw(TCO1_CNT);
+	iTCO_wdt_private.is_started = 1;
 	spin_unlock(&iTCO_wdt_private.io_lock);
 
 	if (val & 0x0800)
@@ -530,6 +534,8 @@ static int iTCO_wdt_stop(void)
 	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
 	iTCO_wdt_set_NO_REBOOT_bit();
 
+	iTCO_wdt_private.is_started = 0;
+
 	spin_unlock(&iTCO_wdt_private.io_lock);
 
 	if ((val & 0x0800) == 0)
@@ -965,6 +971,35 @@ static void iTCO_wdt_shutdown(struct pla
 	iTCO_wdt_stop();
 }
 
+#ifdef CONFIG_PM
+static int iTCO_wdt_suspend(struct device *dev)
+{
+	char save_is_started = iTCO_wdt_private.is_started;
+	iTCO_wdt_stop();
+	iTCO_wdt_private.is_started = save_is_started;
+	return 0;
+}
+
+static int iTCO_wdt_resume(struct device *dev)
+{
+	iTCO_wdt_set_heartbeat(heartbeat);
+	iTCO_wdt_keepalive();
+	if (iTCO_wdt_private.is_started) {
+		printk(KERN_INFO PFX "Watchdog restarted after resume.\n");
+		iTCO_wdt_start();
+	} else {
+		printk(KERN_INFO PFX "Watchdog stopped after resume.\n");
+		iTCO_wdt_stop();
+	}
+	return 0;
+}
+
+static const struct dev_pm_ops iTCO_wdt_pm_ops = {
+	.suspend        = iTCO_wdt_suspend,
+	.resume         = iTCO_wdt_resume,
+};
+#endif /* CONFIG_PM */
+
 static struct platform_driver iTCO_wdt_driver = {
 	.probe          = iTCO_wdt_probe,
 	.remove         = __devexit_p(iTCO_wdt_remove),
@@ -972,6 +1007,9 @@ static struct platform_driver iTCO_wdt_d
 	.driver         = {
 		.owner  = THIS_MODULE,
 		.name   = DRV_NAME,
+#ifdef CONFIG_PM
+		.pm     = &iTCO_wdt_pm_ops,
+#endif /* CONFIG_PM */
 	},
 };
 

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
