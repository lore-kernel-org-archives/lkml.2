Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0G0XxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:53:23 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44619 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab0G0XwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:52:01 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 14/15] Make NMI decoding a compile-time option
Date: Tue, 27 Jul 2010 17:51:02 -0600
Message-Id: <1280274663-9160-15-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpwdt is quite functional without the NMI decoding feature.
This change lets users disable the NMI portion at compile-time
via the new HPWDT_NMI_DECODING config option.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/Kconfig |   20 ++++++++++++++------
 drivers/watchdog/hpwdt.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index fc3d6b5..3d77697 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -560,12 +560,20 @@ config HP_WATCHDOG
 	depends on X86
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
-	  will detect lockups and provide a stack trace. Also, when an NMI
-	  occurs this driver will make the necessary BIOS calls to log
-	  the cause of the NMI. This is a driver that will only load on a
-	  HP ProLiant system with a minimum of iLO2 support.
-	  To compile this driver as a module, choose M here: the
-	  module will be called hpwdt.
+	  will detect lockups and provide a stack trace. This is a driver that
+	  will only load on a HP ProLiant system with a minimum of iLO2 support.
+	  To compile this driver as a module, choose M here: the module will be
+	  called hpwdt.
+
+if HP_WATCHDOG
+
+config HPWDT_NMI_DECODING
+       bool "NMI decoding support for the HP ProLiant iLO Hardware Watchdog Timer"
+       help
+	 When an NMI occurs this feature will make the necessary BIOS calls to
+	 log the cause of the NMI.
+
+endif
 
 config SC1200_WDT
 	tristate "National Semiconductor PC87307/PC97307 (ala SC1200) Watchdog"
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 00aea69..68f5e37 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -27,18 +27,21 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
+#ifdef CONFIG_HPWDT_NMI_DECODING
 #include <linux/dmi.h>
 #include <linux/spinlock.h>
 #include <linux/nmi.h>
 #include <linux/kdebug.h>
 #include <linux/notifier.h>
 #include <asm/cacheflush.h>
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 
 #define SECS_TO_TICKS(secs) ((secs) * 1000 / 128)
 #define TICKS_TO_SECS(ticks) ((ticks) * 128 / 1000)
 #define HPWDT_MAX_TIMER	TICKS_TO_SECS(65535)
 #define HPWDT_VERSION			"1.1.1"
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
 #define CRU_BIOS_SIGNATURE_VALUE	0x55524324
 #define PCI_BIOS32_PARAGRAPH_LEN	16
@@ -107,6 +110,7 @@ struct cmn_registers {
 	u16 res;
 	u32 reflags;
 }  __attribute__((packed));
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 
 #define DEFAULT_MARGIN	30
 static unsigned int soft_margin = DEFAULT_MARGIN;	/* in seconds */
@@ -127,6 +131,7 @@ static struct pci_device_id hpwdt_devices[] = {
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
 static unsigned int hpwdt_nmi_decoding;
 static unsigned int priority;		/* hpwdt at end of die_notify list */
 static DEFINE_SPINLOCK(rom_lock);
@@ -406,6 +411,7 @@ static int __devinit detect_cru_service(void)
 	return ((cru_rom_addr != NULL) ? 0 : -ENODEV);
 }
 #endif /* CONFIG_X86_64 */
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 
 /*
  *	Watchdog operations
@@ -454,6 +460,7 @@ static int hpwdt_change_timer(int new_margin)
 	return 0;
 }
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
 /*
  *	NMI Handler
  */
@@ -486,6 +493,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 out:
 	return NOTIFY_OK;
 }
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 
 /*
  *	/dev/watchdog handling
@@ -623,15 +631,18 @@ static struct miscdevice hpwdt_miscdev = {
 	.fops = &hpwdt_fops,
 };
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
 static struct notifier_block die_notifier = {
 	.notifier_call = hpwdt_pretimeout,
 	.priority = 0,
 };
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 
 /*
  *	Init & Exit
  */
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
 #ifdef ARCH_HAS_NMI_WATCHDOG
 static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
 {
@@ -652,13 +663,21 @@ static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
 	dev_warn(&dev->dev, "NMI decoding is disabled. "
 		"Your kernel does not support a NMI Watchdog.\n");
 }
-#endif
+#endif /* ARCH_HAS_NMI_WATCHDOG */
+#else /* !CONFIG_HPWDT_NMI_DECODING */
+static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
+{
+}
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 
 static int __devinit hpwdt_init_one(struct pci_dev *dev,
 					const struct pci_device_id *ent)
 {
 	int retval;
 	char *buf;
+#ifdef CONFIG_HPWDT_NMI_DECODING
+	char *tmp;
+#endif
 
 	/*
 	 * Check if we can do NMI decoding or not
@@ -697,6 +716,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	if (hpwdt_change_timer(soft_margin))
 		hpwdt_change_timer(DEFAULT_MARGIN);
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
 	/*
 	 * We need to map the ROM to get the CRU service.
 	 * For 32 bit Operating Systems we need to go through the 32 Bit
@@ -733,6 +753,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 			retval);
 		goto error_die_notifier;
 	}
+#endif
 
 	retval = misc_register(&hpwdt_miscdev);
 	if (retval < 0) {
@@ -744,23 +765,31 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 
 	buf = kasprintf(GFP_KERNEL, "hp Watchdog Timer Driver: %s"
 			", timer margin: %d seconds (nowayout=%d)"
-			", allow kernel dump: %s (default = 0/OFF)"
-			", priority: %s (default = 0/LAST)",
+			", allow kernel dump: %s (default = 0/OFF)",
 			HPWDT_VERSION, soft_margin, nowayout,
-			(allow_kdump == 0) ? "OFF" : "ON",
-			(priority == 0) ? "LAST" : "FIRST");
+			(allow_kdump == 0) ? "OFF" : "ON");
 	if (!buf)
 		goto error_nomem;
+#ifdef CONFIG_HPWDT_NMI_DECODING
+	tmp = buf;
+	buf = kasprintf(GFP_KERNEL, "%s, priority: %s (default = 0/LAST)",
+			buf, (priority == 0) ? "LAST" : "FIRST");
+	kfree(tmp);
+	if (!buf)
+		goto error_nomem;
+#endif
 	dev_info(&dev->dev, "%s.\n", buf);
 
 	return 0;
 
 error_misc_register:
+#ifdef CONFIG_HPWDT_NMI_DECODING
 	unregister_die_notifier(&die_notifier);
 error_die_notifier:
 	if (cru_rom_addr)
 		iounmap(cru_rom_addr);
 error_get_cru:
+#endif
 	pci_iounmap(dev, pci_mem_addr);
 error_pci_iomap:
 	pci_disable_device(dev);
@@ -774,10 +803,12 @@ static void __devexit hpwdt_exit(struct pci_dev *dev)
 		hpwdt_stop();
 
 	misc_deregister(&hpwdt_miscdev);
+#ifdef CONFIG_HPWDT_NMI_DECODING
 	unregister_die_notifier(&die_notifier);
 
 	if (cru_rom_addr)
 		iounmap(cru_rom_addr);
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 	pci_iounmap(dev, pci_mem_addr);
 	pci_disable_device(dev);
 }
@@ -815,9 +846,11 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 module_param(allow_kdump, int, 0);
 MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
 module_param(priority, int, 0);
 MODULE_PARM_DESC(priority, "The hpwdt driver handles NMIs first or last"
 		" (default = 0/Last)\n");
+#endif
 
 module_init(hpwdt_init);
 module_exit(hpwdt_cleanup);
-- 
1.7.1

