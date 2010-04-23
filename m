Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0DWIDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:03:06 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:50390 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab0DWIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 12/14] m68k: amiga - Serial port platform device conversion
Date: Fri, 23 Apr 2010 10:00:33 +0200
Message-Id: <1272009635-6504-13-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-12-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-5-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-6-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-7-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-8-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-9-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-10-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-11-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-12-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c |    3 ++
 drivers/char/amiserial.c   |   61 +++++++++++++++++++++++++------------------
 2 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 269bafc..52aa62d 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -168,6 +168,9 @@ static int __init amiga_init_devices(void)
 	if (AMIGAHW_PRESENT(AMI_MOUSE))
 		platform_device_register_simple("amiga-mouse", -1, NULL, 0);
 
+	if (AMIGAHW_PRESENT(AMI_SERIAL))
+		platform_device_register_simple("amiga-serial", -1, NULL, 0);
+
 	return 0;
 }
 
diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 56b2767..4f8d60c 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -84,6 +84,7 @@ static char *serial_version = "4.30";
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/platform_device.h>
 
 #include <asm/setup.h>
 
@@ -1954,29 +1955,16 @@ static const struct tty_operations serial_ops = {
 /*
  * The serial driver boot-time initialization code!
  */
-static int __init rs_init(void)
+static int __init amiga_serial_probe(struct platform_device *pdev)
 {
 	unsigned long flags;
 	struct serial_state * state;
 	int error;
 
-	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(AMI_SERIAL))
-		return -ENODEV;
-
 	serial_driver = alloc_tty_driver(1);
 	if (!serial_driver)
 		return -ENOMEM;
 
-	/*
-	 *  We request SERDAT and SERPER only, because the serial registers are
-	 *  too spreaded over the custom register space
-	 */
-	if (!request_mem_region(CUSTOM_PHYSADDR+0x30, 4,
-				"amiserial [Paula]")) {
-		error = -EBUSY;
-		goto fail_put_tty_driver;
-	}
-
 	IRQ_ports = NULL;
 
 	show_serial_version();
@@ -1998,7 +1986,7 @@ static int __init rs_init(void)
 
 	error = tty_register_driver(serial_driver);
 	if (error)
-		goto fail_release_mem_region;
+		goto fail_put_tty_driver;
 
 	state = rs_table;
 	state->magic = SSTATE_MAGIC;
@@ -2050,23 +2038,24 @@ static int __init rs_init(void)
 	ciab.ddra |= (SER_DTR | SER_RTS);   /* outputs */
 	ciab.ddra &= ~(SER_DCD | SER_CTS | SER_DSR);  /* inputs */
 
+	platform_set_drvdata(pdev, state);
+
 	return 0;
 
 fail_free_irq:
 	free_irq(IRQ_AMIGA_TBE, state);
 fail_unregister:
 	tty_unregister_driver(serial_driver);
-fail_release_mem_region:
-	release_mem_region(CUSTOM_PHYSADDR+0x30, 4);
 fail_put_tty_driver:
 	put_tty_driver(serial_driver);
 	return error;
 }
 
-static __exit void rs_exit(void) 
+static int __exit amiga_serial_remove(struct platform_device *pdev)
 {
 	int error;
-	struct async_struct *info = rs_table[0].info;
+	struct serial_state *state = platform_get_drvdata(pdev);
+	struct async_struct *info = state->info;
 
 	/* printk("Unloading %s: version %s\n", serial_name, serial_version); */
 	tasklet_kill(&info->tlet);
@@ -2075,19 +2064,38 @@ static __exit void rs_exit(void)
 		       error);
 	put_tty_driver(serial_driver);
 
-	if (info) {
-	  rs_table[0].info = NULL;
-	  kfree(info);
-	}
+	rs_table[0].info = NULL;
+	kfree(info);
 
 	free_irq(IRQ_AMIGA_TBE, rs_table);
 	free_irq(IRQ_AMIGA_RBF, rs_table);
 
-	release_mem_region(CUSTOM_PHYSADDR+0x30, 4);
+	platform_set_drvdata(pdev, NULL);
+
+	return error;
+}
+
+static struct platform_driver amiga_serial_driver = {
+	.remove = __exit_p(amiga_serial_remove),
+	.driver   = {
+		.name	= "amiga-serial",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init amiga_serial_init(void)
+{
+	return platform_driver_probe(&amiga_serial_driver, amiga_serial_probe);
+}
+
+module_init(amiga_serial_init);
+
+static void __exit amiga_serial_exit(void)
+{
+	platform_driver_unregister(&amiga_serial_driver);
 }
 
-module_init(rs_init)
-module_exit(rs_exit)
+module_exit(amiga_serial_exit);
 
 
 #if defined(CONFIG_SERIAL_CONSOLE) && !defined(MODULE)
@@ -2154,3 +2162,4 @@ console_initcall(amiserial_console_init);
 #endif /* CONFIG_SERIAL_CONSOLE && !MODULE */
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:amiga-serial");
-- 
1.6.0.4

