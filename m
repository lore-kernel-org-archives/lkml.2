Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab0DWIBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:01:19 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:40828 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab0DWIAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-ide@vger.kernel.org
Subject: [PATCH 09/14] m68k: amiga - Amiga Gayle IDE platform device conversion
Date: Fri, 23 Apr 2010 10:00:30 +0200
Message-Id: <1272009635-6504-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-9-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-5-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-6-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-7-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-8-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-9-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-ide@vger.kernel.org
---
 arch/m68k/amiga/platform.c       |   63 ++++++++++++++++-
 arch/m68k/include/asm/amigayle.h |    6 ++
 drivers/ide/gayle.c              |  150 +++++++++++++++++++++----------------
 3 files changed, 153 insertions(+), 66 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 027e4ca..907f6f5 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -11,6 +11,7 @@
 #include <linux/zorro.h>
 
 #include <asm/amigahw.h>
+#include <asm/amigayle.h>
 
 
 #ifdef CONFIG_ZORRO
@@ -55,7 +56,24 @@ static int __init amiga_init_bus(void)
 
 subsys_initcall(amiga_init_bus);
 
-#endif /* CONFIG_ZORRO */
+
+static int z_dev_present(zorro_id id)
+{
+	unsigned int i;
+
+	for (i = 0; i < zorro_num_autocon; i++)
+		if (zorro_autocon[i].rom.er_Manufacturer == ZORRO_MANUF(id) &&
+		    zorro_autocon[i].rom.er_Product == ZORRO_PROD(id))
+			return 1;
+
+	return 0;
+}
+
+#else /* !CONFIG_ZORRO */
+
+static inline int z_dev_present(zorro_id id) { return 0; }
+
+#endif /* !CONFIG_ZORRO */
 
 
 static const struct resource a3000_scsi_resource __initconst = {
@@ -72,8 +90,36 @@ static const struct resource a4000t_scsi_resource __initconst = {
 };
 
 
+static const struct resource a1200_ide_resource __initconst = {
+	.start	= 0xda0000,
+	.end	= 0xda1fff,
+	.flags	= IORESOURCE_MEM,
+};
+
+static const struct gayle_ide_platform_data a1200_ide_pdata __initconst = {
+	.base		= 0xda0000,
+	.irqport	= 0xda9000,
+	.explicit_ack	= 1,
+};
+
+
+static const struct resource a4000_ide_resource __initconst = {
+	.start	= 0xdd2000,
+	.end	= 0xdd3fff,
+	.flags	= IORESOURCE_MEM,
+};
+
+static const struct gayle_ide_platform_data a4000_ide_pdata __initconst = {
+	.base		= 0xdd2020,
+	.irqport	= 0xdd3020,
+	.explicit_ack	= 0,
+};
+
+
 static int __init amiga_init_devices(void)
 {
+	struct platform_device *pdev;
+
 	if (!MACH_IS_AMIGA)
 		return -ENODEV;
 
@@ -99,6 +145,21 @@ static int __init amiga_init_devices(void)
 		platform_device_register_simple("amiga-a4000t-scsi", -1,
 						&a4000t_scsi_resource, 1);
 
+	if (AMIGAHW_PRESENT(A1200_IDE) ||
+	    z_dev_present(ZORRO_PROD_MTEC_VIPER_MK_V_E_MATRIX_530_SCSI_IDE)) {
+		pdev = platform_device_register_simple("amiga-gayle-ide", -1,
+						       &a1200_ide_resource, 1);
+		platform_device_add_data(pdev, &a1200_ide_pdata,
+					 sizeof(a1200_ide_pdata));
+	}
+
+	if (AMIGAHW_PRESENT(A4000_IDE)) {
+		pdev = platform_device_register_simple("amiga-gayle-ide", -1,
+						       &a4000_ide_resource, 1);
+		platform_device_add_data(pdev, &a4000_ide_pdata,
+					 sizeof(a4000_ide_pdata));
+	}
+
 	return 0;
 }
 
diff --git a/arch/m68k/include/asm/amigayle.h b/arch/m68k/include/asm/amigayle.h
index bb5a6aa..a01453d 100644
--- a/arch/m68k/include/asm/amigayle.h
+++ b/arch/m68k/include/asm/amigayle.h
@@ -104,4 +104,10 @@ struct GAYLE {
 #define GAYLE_CFG_250NS		0x00
 #define GAYLE_CFG_720NS		0x0c
 
+struct gayle_ide_platform_data {
+	unsigned long base;
+	unsigned long irqport;
+	int explicit_ack;	/* A1200 IDE needs explicit ack */
+};
+
 #endif /* asm-m68k/amigayle.h */
diff --git a/drivers/ide/gayle.c b/drivers/ide/gayle.c
index b9e517d..1d4c18e 100644
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/zorro.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 
 #include <asm/setup.h>
 #include <asm/amigahw.h>
@@ -24,15 +25,6 @@
 
 
     /*
-     *  Bases of the IDE interfaces
-     */
-
-#define GAYLE_BASE_4000	0xdd2020	/* A4000/A4000T */
-#define GAYLE_BASE_1200	0xda0000	/* A1200/A600 and E-Matrix 530 */
-
-#define GAYLE_IDEREG_SIZE	0x2000
-
-    /*
      *  Offsets from one of the above bases
      */
 
@@ -68,20 +60,20 @@ MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
 
 static int gayle_test_irq(ide_hwif_t *hwif)
 {
-    unsigned char ch;
+	unsigned char ch;
 
-    ch = z_readb(hwif->io_ports.irq_addr);
-    if (!(ch & GAYLE_IRQ_IDE))
-	return 0;
-    return 1;
+	ch = z_readb(hwif->io_ports.irq_addr);
+	if (!(ch & GAYLE_IRQ_IDE))
+		return 0;
+	return 1;
 }
 
 static void gayle_a1200_clear_irq(ide_drive_t *drive)
 {
-    ide_hwif_t *hwif = drive->hwif;
+	ide_hwif_t *hwif = drive->hwif;
 
-    (void)z_readb(hwif->io_ports.status_addr);
-    z_writeb(0x7c, hwif->io_ports.irq_addr);
+	(void)z_readb(hwif->io_ports.status_addr);
+	z_writeb(0x7c, hwif->io_ports.irq_addr);
 }
 
 static void __init gayle_setup_ports(struct ide_hw *hw, unsigned long base,
@@ -122,64 +114,92 @@ static const struct ide_port_info gayle_port_info = {
      *  Probe for a Gayle IDE interface (and optionally for an IDE doubler)
      */
 
-static int __init gayle_init(void)
+static int __init amiga_gayle_ide_probe(struct platform_device *pdev)
 {
-    unsigned long phys_base, res_start, res_n;
-    unsigned long base, ctrlport, irqport;
-    int a4000, i, rc;
-    struct ide_hw hw[GAYLE_NUM_HWIFS], *hws[GAYLE_NUM_HWIFS];
-    struct ide_port_info d = gayle_port_info;
-
-    if (!MACH_IS_AMIGA)
-	return -ENODEV;
-
-    if ((a4000 = AMIGAHW_PRESENT(A4000_IDE)) || AMIGAHW_PRESENT(A1200_IDE))
-	goto found;
-
-#ifdef CONFIG_ZORRO
-    if (zorro_find_device(ZORRO_PROD_MTEC_VIPER_MK_V_E_MATRIX_530_SCSI_IDE,
-			  NULL))
-	goto found;
-#endif
-    return -ENODEV;
-
-found:
-	printk(KERN_INFO "ide: Gayle IDE controller (A%d style%s)\n",
-			 a4000 ? 4000 : 1200,
-			 ide_doubler ? ", IDE doubler" : "");
-
-	if (a4000) {
-	    phys_base = GAYLE_BASE_4000;
-	    irqport = (unsigned long)ZTWO_VADDR(GAYLE_IRQ_4000);
-	    d.port_ops = &gayle_a4000_port_ops;
-	} else {
-	    phys_base = GAYLE_BASE_1200;
-	    irqport = (unsigned long)ZTWO_VADDR(GAYLE_IRQ_1200);
-	    d.port_ops = &gayle_a1200_port_ops;
+	struct resource *res;
+	struct gayle_ide_platform_data *pdata;
+	unsigned long base, ctrlport, irqport;
+	unsigned int i;
+	int error;
+	struct ide_hw hw[GAYLE_NUM_HWIFS], *hws[GAYLE_NUM_HWIFS];
+	struct ide_port_info d = gayle_port_info;
+	struct ide_host *host;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	if (!request_mem_region(res->start, resource_size(res), "IDE"))
+		return -EBUSY;
+
+	pdata = pdev->dev.platform_data;
+	pr_info("ide: Gayle IDE controller (A%u style%s)\n",
+		pdata->explicit_ack ? 1200 : 4000,
+		ide_doubler ? ", IDE doubler" : "");
+
+	base = (unsigned long)ZTWO_VADDR(pdata->base);
+	ctrlport = 0;
+	irqport = (unsigned long)ZTWO_VADDR(pdata->irqport);
+{
+	// FIXME
+	if (pdata->explicit_ack)
+		d.port_ops = &gayle_a1200_port_ops;
+	else
+		d.port_ops = &gayle_a4000_port_ops;
+}
+
+	for (i = 0; i < GAYLE_NUM_PROBE_HWIFS; i++, base += GAYLE_NEXT_PORT) {
+		if (GAYLE_HAS_CONTROL_REG)
+			ctrlport = base + GAYLE_CONTROL;
+
+		gayle_setup_ports(&hw[i], base, ctrlport, irqport);
+		hws[i] = &hw[i];
 	}
 
-	res_start = ((unsigned long)phys_base) & ~(GAYLE_NEXT_PORT-1);
-	res_n = GAYLE_IDEREG_SIZE;
+	error = ide_host_add(&d, hws, i, &host);
+	if (error)
+		goto out;
 
-	if (!request_mem_region(res_start, res_n, "IDE"))
-		return -EBUSY;
+	platform_set_drvdata(pdev, host);
+	return 0;
+
+out:
+	release_mem_region(res->start, resource_size(res));
+	return error;
+}
+
+static int __exit amiga_gayle_ide_remove(struct platform_device *pdev)
+{
+	struct ide_host *host = platform_get_drvdata(pdev);
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-    for (i = 0; i < GAYLE_NUM_PROBE_HWIFS; i++) {
-	base = (unsigned long)ZTWO_VADDR(phys_base + i * GAYLE_NEXT_PORT);
-	ctrlport = GAYLE_HAS_CONTROL_REG ? (base + GAYLE_CONTROL) : 0;
+	ide_host_remove(host);
+	release_mem_region(res->start, resource_size(res));
+	return 0;
+}
 
-	gayle_setup_ports(&hw[i], base, ctrlport, irqport);
+static struct platform_driver amiga_gayle_ide_driver = {
+	.remove = __exit_p(amiga_gayle_ide_remove),
+	.driver   = {
+		.name	= "amiga-gayle-ide",
+		.owner	= THIS_MODULE,
+	},
+};
 
-	hws[i] = &hw[i];
-    }
+static int __init amiga_gayle_ide_init(void)
+{
+	return platform_driver_probe(&amiga_gayle_ide_driver,
+				     amiga_gayle_ide_probe);
+}
 
-    rc = ide_host_add(&d, hws, i, NULL);
-    if (rc)
-	release_mem_region(res_start, res_n);
+module_init(amiga_gayle_ide_init);
 
-    return rc;
+static void __exit amiga_gayle_ide_exit(void)
+{
+	platform_driver_unregister(&amiga_gayle_ide_driver);
 }
 
-module_init(gayle_init);
+module_exit(amiga_gayle_ide_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:amiga-gayle-ide");
-- 
1.6.0.4

