Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab1DNTCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:02:42 -0400
Received: from the.earth.li ([46.43.34.31]:36302 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1DNTCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:02:41 -0400
Date: Thu, 14 Apr 2011 12:02:39 -0700
From: Jonathan McDowell <noodles@earth.li>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Cleanup pc87413 watchdog driver to use
 request_muxed_region for SuperIO area
Message-ID: <20110414190238.GI4835@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by Nat Gurumoorthy's recent patches for cleaning up the it87
drivers to use request_muxed_region for accessing the SuperIO area on
these chips, and the fact I have a GPIO driver for the pc8741x basically
ready for submission, here is a patch to cleanup the pc87413 watchdog
driver to use request_muxed_region for accessing the SuperIO area.

It also pulls out the details about the SWC IO area on initial driver
load, and properly does a request_region for that area - there's no
requirement to touch the SuperIO area after doing the initial watchdog
enable and IO base retrieval.

While I have hardware with a pc87413 on it it is not wired in a way that
allows the watchdog to reboot the machine, so I have not been able to
fully test these changes - I have checked that the driver correctly
initialises itself still and requests the SWC io region ok.

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-------
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index b7c1390..e78d899 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -56,6 +56,7 @@
 #define IO_DEFAULT	0x2E		/* Address used on Portwell Boards */
 
 static int io = IO_DEFAULT;
+static int swc_base_addr = -1;
 
 static int timeout = DEFAULT_TIMEOUT;	/* timeout value */
 static unsigned long timer_enabled;	/* is the timer enabled? */
@@ -116,9 +117,8 @@ static inline void pc87413_enable_swc(void)
 
 /* Read SWC I/O base address */
 
-static inline unsigned int pc87413_get_swc_base(void)
+static void pc87413_get_swc_base_addr(void)
 {
-	unsigned int  swc_base_addr = 0;
 	unsigned char addr_l, addr_h = 0;
 
 	/* Step 3: Read SWC I/O Base Address */
@@ -136,12 +136,11 @@ static inline unsigned int pc87413_get_swc_base(void)
 		"Read SWC I/O Base Address: low %d, high %d, res %d\n",
 						addr_l, addr_h, swc_base_addr);
 #endif
-	return swc_base_addr;
 }
 
 /* Select Bank 3 of SWC */
 
-static inline void pc87413_swc_bank3(unsigned int swc_base_addr)
+static inline void pc87413_swc_bank3(void)
 {
 	/* Step 4: Select Bank3 of SWC */
 	outb_p(inb(swc_base_addr + 0x0f) | 0x03, swc_base_addr + 0x0f);
@@ -152,8 +151,7 @@ static inline void pc87413_swc_bank3(unsigned int swc_base_addr)
 
 /* Set watchdog timeout to x minutes */
 
-static inline void pc87413_programm_wdto(unsigned int swc_base_addr,
-					 char pc87413_time)
+static inline void pc87413_programm_wdto(char pc87413_time)
 {
 	/* Step 5: Programm WDTO, Twd. */
 	outb_p(pc87413_time, swc_base_addr + WDTO);
@@ -164,7 +162,7 @@ static inline void pc87413_programm_wdto(unsigned int swc_base_addr,
 
 /* Enable WDEN */
 
-static inline void pc87413_enable_wden(unsigned int swc_base_addr)
+static inline void pc87413_enable_wden(void)
 {
 	/* Step 6: Enable WDEN */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x01, swc_base_addr + WDCTL);
@@ -174,7 +172,7 @@ static inline void pc87413_enable_wden(unsigned int swc_base_addr)
 }
 
 /* Enable SW_WD_TREN */
-static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
+static inline void pc87413_enable_sw_wd_tren(void)
 {
 	/* Enable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) | 0x80, swc_base_addr + WDCFG);
@@ -185,7 +183,7 @@ static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
 
 /* Disable SW_WD_TREN */
 
-static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
+static inline void pc87413_disable_sw_wd_tren(void)
 {
 	/* Disable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) & 0x7f, swc_base_addr + WDCFG);
@@ -196,7 +194,7 @@ static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
 
 /* Enable SW_WD_TRG */
 
-static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
+static inline void pc87413_enable_sw_wd_trg(void)
 {
 	/* Enable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x80, swc_base_addr + WDCTL);
@@ -207,7 +205,7 @@ static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
 
 /* Disable SW_WD_TRG */
 
-static inline void pc87413_disable_sw_wd_trg(unsigned int swc_base_addr)
+static inline void pc87413_disable_sw_wd_trg(void)
 {
 	/* Disable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) & 0x7f, swc_base_addr + WDCTL);
@@ -222,18 +220,13 @@ static inline void pc87413_disable_sw_wd_trg(unsigned int swc_base_addr)
 
 static void pc87413_enable(void)
 {
-	unsigned int swc_base_addr;
-
 	spin_lock(&io_lock);
 
-	pc87413_select_wdt_out();
-	pc87413_enable_swc();
-	swc_base_addr = pc87413_get_swc_base();
-	pc87413_swc_bank3(swc_base_addr);
-	pc87413_programm_wdto(swc_base_addr, timeout);
-	pc87413_enable_wden(swc_base_addr);
-	pc87413_enable_sw_wd_tren(swc_base_addr);
-	pc87413_enable_sw_wd_trg(swc_base_addr);
+	pc87413_swc_bank3();
+	pc87413_programm_wdto(timeout);
+	pc87413_enable_wden();
+	pc87413_enable_sw_wd_tren();
+	pc87413_enable_sw_wd_trg();
 
 	spin_unlock(&io_lock);
 }
@@ -242,17 +235,12 @@ static void pc87413_enable(void)
 
 static void pc87413_disable(void)
 {
-	unsigned int swc_base_addr;
-
 	spin_lock(&io_lock);
 
-	pc87413_select_wdt_out();
-	pc87413_enable_swc();
-	swc_base_addr = pc87413_get_swc_base();
-	pc87413_swc_bank3(swc_base_addr);
-	pc87413_disable_sw_wd_tren(swc_base_addr);
-	pc87413_disable_sw_wd_trg(swc_base_addr);
-	pc87413_programm_wdto(swc_base_addr, 0);
+	pc87413_swc_bank3();
+	pc87413_disable_sw_wd_tren();
+	pc87413_disable_sw_wd_trg();
+	pc87413_programm_wdto(0);
 
 	spin_unlock(&io_lock);
 }
@@ -261,20 +249,15 @@ static void pc87413_disable(void)
 
 static void pc87413_refresh(void)
 {
-	unsigned int swc_base_addr;
-
 	spin_lock(&io_lock);
 
-	pc87413_select_wdt_out();
-	pc87413_enable_swc();
-	swc_base_addr = pc87413_get_swc_base();
-	pc87413_swc_bank3(swc_base_addr);
-	pc87413_disable_sw_wd_tren(swc_base_addr);
-	pc87413_disable_sw_wd_trg(swc_base_addr);
-	pc87413_programm_wdto(swc_base_addr, timeout);
-	pc87413_enable_wden(swc_base_addr);
-	pc87413_enable_sw_wd_tren(swc_base_addr);
-	pc87413_enable_sw_wd_trg(swc_base_addr);
+	pc87413_swc_bank3();
+	pc87413_disable_sw_wd_tren();
+	pc87413_disable_sw_wd_trg();
+	pc87413_programm_wdto(timeout);
+	pc87413_enable_wden();
+	pc87413_enable_sw_wd_tren();
+	pc87413_enable_sw_wd_trg();
 
 	spin_unlock(&io_lock);
 }
@@ -528,7 +511,8 @@ static int __init pc87413_init(void)
 	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n",
 							WDT_INDEX_IO_PORT);
 
-	/* request_region(io, 2, "pc87413"); */
+	if (!request_muxed_region(io, 2, MODNAME))
+		return -EBUSY;
 
 	ret = register_reboot_notifier(&pc87413_notifier);
 	if (ret != 0) {
@@ -541,12 +525,32 @@ static int __init pc87413_init(void)
 		printk(KERN_ERR PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
-		unregister_reboot_notifier(&pc87413_notifier);
-		return ret;
+		goto reboot_unreg;
 	}
 	printk(KERN_INFO PFX "initialized. timeout=%d min \n", timeout);
+
+	pc87413_select_wdt_out();
+	pc87413_enable_swc();
+	pc87413_get_swc_base_addr();
+
+	if (!request_region(swc_base_addr, 0x20, MODNAME)) {
+		printk(KERN_ERR PFX
+			"cannot request SWC region at 0x%x\n", swc_base_addr);
+		ret = -EBUSY;
+		goto misc_unreg;
+	}
+
 	pc87413_enable();
+
+	release_region(io, 2);
 	return 0;
+
+misc_unreg:
+	misc_deregister(&pc87413_miscdev);
+reboot_unreg:
+	unregister_reboot_notifier(&pc87413_notifier);
+	release_region(io, 2);
+	return ret;
 }
 
 /**
@@ -569,7 +573,7 @@ static void __exit pc87413_exit(void)
 
 	misc_deregister(&pc87413_miscdev);
 	unregister_reboot_notifier(&pc87413_notifier);
-	/* release_region(io, 2); */
+	release_region(swc_base_addr, 0x20);
 
 	printk(KERN_INFO MODNAME " watchdog component driver removed.\n");
 }

-------

J.

-- 
"It only counts as a lie-in if you don't get dressed before tea time."
-- Steve Willison
