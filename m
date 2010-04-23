Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0DWIGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:06:20 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:48713 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab0DWIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:05:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 13/14] m68k: amiga - Parallel port platform device conversion
Date: Fri, 23 Apr 2010 10:00:34 +0200
Message-Id: <1272009635-6504-14-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-13-git-send-email-geert@linux-m68k.org>
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
 <1272009635-6504-13-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c      |    3 ++
 drivers/parport/parport_amiga.c |   64 ++++++++++++++++++++++++--------------
 2 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 52aa62d..c985db0 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -171,6 +171,9 @@ static int __init amiga_init_devices(void)
 	if (AMIGAHW_PRESENT(AMI_SERIAL))
 		platform_device_register_simple("amiga-serial", -1, NULL, 0);
 
+	if (AMIGAHW_PRESENT(AMI_PARALLEL))
+		platform_device_register_simple("amiga-parallel", -1, NULL, 0);
+
 	return 0;
 }
 
diff --git a/drivers/parport/parport_amiga.c b/drivers/parport/parport_amiga.c
index 1586e1c..8bef6d6 100644
--- a/drivers/parport/parport_amiga.c
+++ b/drivers/parport/parport_amiga.c
@@ -18,6 +18,8 @@
 #include <linux/parport.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
+
 #include <asm/setup.h>
 #include <asm/amigahw.h>
 #include <asm/irq.h>
@@ -31,7 +33,6 @@
 #define DPRINTK(x...)	do { } while (0)
 #endif
 
-static struct parport *this_port = NULL;
 
 static void amiga_write_data(struct parport *p, unsigned char data)
 {
@@ -227,18 +228,11 @@ static struct parport_operations pp_amiga_ops = {
 
 /* ----------- Initialisation code --------------------------------- */
 
-static int __init parport_amiga_init(void)
+static int __init amiga_parallel_probe(struct platform_device *pdev)
 {
 	struct parport *p;
 	int err;
 
-	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(AMI_PARALLEL))
-		return -ENODEV;
-
-	err = -EBUSY;
-	if (!request_mem_region(CIAA_PHYSADDR-1+0x100, 0x100, "parallel"))
-		goto out_mem;
-
 	ciaa.ddrb = 0xff;
 	ciab.ddra &= 0xf8;
 	mb();
@@ -246,41 +240,63 @@ static int __init parport_amiga_init(void)
 	p = parport_register_port((unsigned long)&ciaa.prb, IRQ_AMIGA_CIAA_FLG,
 				   PARPORT_DMA_NONE, &pp_amiga_ops);
 	if (!p)
-		goto out_port;
+		return -EBUSY;
 
-	err = request_irq(IRQ_AMIGA_CIAA_FLG, parport_irq_handler, 0, p->name, p);
+	err = request_irq(IRQ_AMIGA_CIAA_FLG, parport_irq_handler, 0, p->name,
+			  p);
 	if (err)
 		goto out_irq;
 
-	this_port = p;
 	printk(KERN_INFO "%s: Amiga built-in port using irq\n", p->name);
 	/* XXX: set operating mode */
 	parport_announce_port(p);
 
+	platform_set_drvdata(pdev, p);
+
 	return 0;
 
 out_irq:
 	parport_put_port(p);
-out_port:
-	release_mem_region(CIAA_PHYSADDR-1+0x100, 0x100);
-out_mem:
 	return err;
 }
 
-static void __exit parport_amiga_exit(void)
+static int __exit amiga_parallel_remove(struct platform_device *pdev)
+{
+	struct parport *port = platform_get_drvdata(pdev);
+
+	parport_remove_port(port);
+	if (port->irq != PARPORT_IRQ_NONE)
+		free_irq(IRQ_AMIGA_CIAA_FLG, port);
+	parport_put_port(port);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver amiga_parallel_driver = {
+	.remove = __exit_p(amiga_parallel_remove),
+	.driver   = {
+		.name	= "amiga-parallel",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init amiga_parallel_init(void)
+{
+	return platform_driver_probe(&amiga_parallel_driver,
+				     amiga_parallel_probe);
+}
+
+module_init(amiga_parallel_init);
+
+static void __exit amiga_parallel_exit(void)
 {
-	parport_remove_port(this_port);
-	if (this_port->irq != PARPORT_IRQ_NONE)
-		free_irq(IRQ_AMIGA_CIAA_FLG, this_port);
-	parport_put_port(this_port);
-	release_mem_region(CIAA_PHYSADDR-1+0x100, 0x100);
+	platform_driver_unregister(&amiga_parallel_driver);
 }
 
+module_exit(amiga_parallel_exit);
 
 MODULE_AUTHOR("Joerg Dorchain <joerg@dorchain.net>");
 MODULE_DESCRIPTION("Parport Driver for Amiga builtin Port");
 MODULE_SUPPORTED_DEVICE("Amiga builtin Parallel Port");
 MODULE_LICENSE("GPL");
-
-module_init(parport_amiga_init)
-module_exit(parport_amiga_exit)
+MODULE_ALIAS("platform:amiga-parallel");
-- 
1.6.0.4

