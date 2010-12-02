Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab0LBTtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:49:10 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:31383 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757253Ab0LBTtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:49:09 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJOF90xR8igG/2dsb2JhbACjJ3LDFA2FOgQ
Date: Thu, 2 Dec 2010 20:49:06 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Martyn Welch <martyn.welch@ge.com>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [GIT PULL REQUEST] watchdog - v2.6.37-rc5
Message-ID: <20101202194906.GB4007@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig       |    3 ++
 drivers/watchdog/bcm63xx_wdt.c |   42 +++++++++++------------------------------
 drivers/watchdog/gef_wdt.c     |    1 
 drivers/watchdog/iTCO_wdt.c    |    8 +++++--
 4 files changed, 22 insertions(+), 32 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Dec 2 14:03:29 2010 +0000

    watchdog: it8712f_wdt: add note to Kconfig
    
    On some motherboards the it8712f watchdog does not work unless
    the game port was enabled. see Bug 13140. We therefor add a note
    to Kconfig.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wolfram Sang & Martyn Welch <w.sang@pengutronix.de, martyn.welch@ge.com>
Date:   Thu Dec 2 00:11:16 2010 +0100

    watchdog: gef_wdt: include fs.h
    
    Add missing include "linux/fs.h".
    This fixes compile failure.
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Martyn Welch <martyn.welch@ge.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Oct 23 20:59:42 2010 +0000

    watchdog: bcm63xx_wdt: improve platform part.
    
    * fix devinit and devexit sections
    * fix platform removal code so that the iounmap happens after the removal of the timer.
    * changes the reboot_notifier by a platform shutdown method.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Seth Heasley <seth.heasley@intel.com>
Date:   Wed Nov 17 12:15:08 2010 -0700

    watchdog: iTCO_wdt: TCO Watchdog patch for Intel Patsburg PCH
    
    This patch adds an additional LPC Controller DeviceID for the Intel Patsburg PCH for TCO Watchdog.
    
    Signed-off-by: Seth Heasley <seth.heasley@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4a29104..a5ad77e 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -558,6 +558,9 @@ config IT8712F_WDT
 	  This is the driver for the built-in watchdog timer on the IT8712F
 	  Super I/0 chipset used on many motherboards.
 
+	  If the driver does not work, then make sure that the game port in
+	  the BIOS is enabled.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called it8712f_wdt.
 
diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index a1debc8..3c5045a 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -18,7 +18,6 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
@@ -220,14 +219,6 @@ static long bcm63xx_wdt_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-static int bcm63xx_wdt_notify_sys(struct notifier_block *this,
-				unsigned long code, void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		bcm63xx_wdt_pause();
-	return NOTIFY_DONE;
-}
-
 static const struct file_operations bcm63xx_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
@@ -243,12 +234,8 @@ static struct miscdevice bcm63xx_wdt_miscdev = {
 	.fops	= &bcm63xx_wdt_fops,
 };
 
-static struct notifier_block bcm63xx_wdt_notifier = {
-	.notifier_call = bcm63xx_wdt_notify_sys,
-};
 
-
-static int bcm63xx_wdt_probe(struct platform_device *pdev)
+static int __devinit bcm63xx_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct resource *r;
@@ -280,16 +267,10 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 			wdt_time);
 	}
 
-	ret = register_reboot_notifier(&bcm63xx_wdt_notifier);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register reboot_notifier\n");
-		goto unregister_timer;
-	}
-
 	ret = misc_register(&bcm63xx_wdt_miscdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register watchdog device\n");
-		goto unregister_reboot_notifier;
+		goto unregister_timer;
 	}
 
 	dev_info(&pdev->dev, " started, timer margin: %d sec\n",
@@ -297,8 +278,6 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 
 	return 0;
 
-unregister_reboot_notifier:
-	unregister_reboot_notifier(&bcm63xx_wdt_notifier);
 unregister_timer:
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
 unmap:
@@ -306,25 +285,28 @@ unmap:
 	return ret;
 }
 
-static int bcm63xx_wdt_remove(struct platform_device *pdev)
+static int __devexit bcm63xx_wdt_remove(struct platform_device *pdev)
 {
 	if (!nowayout)
 		bcm63xx_wdt_pause();
 
 	misc_deregister(&bcm63xx_wdt_miscdev);
-
-	iounmap(bcm63xx_wdt_device.regs);
-
-	unregister_reboot_notifier(&bcm63xx_wdt_notifier);
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
-
+	iounmap(bcm63xx_wdt_device.regs);
 	return 0;
 }
 
+static void bcm63xx_wdt_shutdown(struct platform_device *pdev)
+{
+	bcm63xx_wdt_pause();
+}
+
 static struct platform_driver bcm63xx_wdt = {
 	.probe	= bcm63xx_wdt_probe,
-	.remove = bcm63xx_wdt_remove,
+	.remove = __devexit_p(bcm63xx_wdt_remove),
+	.shutdown = bcm63xx_wdt_shutdown,
 	.driver = {
+		.owner = THIS_MODULE,
 		.name = "bcm63xx-wdt",
 	}
 };
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index 9c21d19..f6bd6f1 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
+#include <linux/fs.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index f7e90fe..b8838d2 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -32,6 +32,7 @@
  *	document number 322169-001, 322170-003: 5 Series, 3400 Series (PCH)
  *	document number 320066-003, 320257-008: EP80597 (IICH)
  *	document number TBD                   : Cougar Point (CPT)
+ *	document number TBD                   : Patsburg (PBG)
  */
 
 /*
@@ -146,7 +147,8 @@ enum iTCO_chipsets {
 	TCO_CPT29,	/* Cougar Point */
 	TCO_CPT30,	/* Cougar Point */
 	TCO_CPT31,	/* Cougar Point */
-	TCO_PBG,	/* Patsburg */
+	TCO_PBG1,	/* Patsburg */
+	TCO_PBG2,	/* Patsburg */
 };
 
 static struct {
@@ -235,6 +237,7 @@ static struct {
 	{"Cougar Point", 2},
 	{"Cougar Point", 2},
 	{"Patsburg", 2},
+	{"Patsburg", 2},
 	{NULL, 0}
 };
 
@@ -350,7 +353,8 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x1c5d,				TCO_CPT29)},
 	{ ITCO_PCI_DEVICE(0x1c5e,				TCO_CPT30)},
 	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
-	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG)},
+	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG1)},
+	{ ITCO_PCI_DEVICE(0x1d41,				TCO_PBG2)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
