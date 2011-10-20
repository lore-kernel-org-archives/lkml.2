Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab1JTLnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 07:43:15 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:44873 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1JTLmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 07:42:35 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        "Christian T. Steigies" <cts@debian.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ingo=20J=C3=BCrgensmann?= <ij@2011.bluespice.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/4] fbdev/cirrusfb: Rewrite Zorro graphics card probing
Date: Thu, 20 Oct 2011 13:42:23 +0200
Message-Id: <1319110945-25684-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319110945-25684-1-git-send-email-geert@linux-m68k.org>
References: <1319110945-25684-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As indicated by commit a7f4d00a82feb5b311f765bf9522bc55bee0684f ("zorro:
Defer device_register() until all devices have been identified"), cirrusfb
crashes if zorro_find_device() cannot find an expected device.

Rewrite the Zorro device probe code to make it more robust, easier to
understand, and more extensible.

Other logical changes:
  - For cards that show up as 2 Zorro devices, autoprobe graphics memory
    sizes based on the size of the Zorro device containing the graphics
    memory.
    Acording to the NetBSD sources, this is safe.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
--
Untested, due to lack of hardware
---
 drivers/video/cirrusfb.c |  241 ++++++++++++++++++++++-----------------------
 1 files changed, 118 insertions(+), 123 deletions(-)

diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 6df7c54..357139a 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -280,52 +280,63 @@ MODULE_DEVICE_TABLE(pci, cirrusfb_pci_table);
 #endif /* CONFIG_PCI */
 
 #ifdef CONFIG_ZORRO
-static const struct zorro_device_id cirrusfb_zorro_table[] = {
+struct zorrocl {
+	enum cirrus_board type;	/* Board type */
+	u32 regoffset;		/* Offset of registers in first Zorro device */
+	u32 ramsize;		/* Size of video RAM in first Zorro device */
+				/* If zero, use autoprobe on RAM device */
+	u32 ramoffset;		/* Offset of video RAM in first Zorro device */
+	zorro_id ramid;		/* Zorro ID of RAM device */
+};
+
+static const struct zorrocl zcl_sd64 __devinitconst = {
+	.type		= BT_SD64,
+	.ramid		= ZORRO_PROD_HELFRICH_SD64_RAM,
+};
+
+static const struct zorrocl zcl_piccolo __devinitconst = {
+	.type		= BT_PICCOLO,
+	.ramid		= ZORRO_PROD_HELFRICH_PICCOLO_RAM,
+};
+
+static const struct zorrocl zcl_picasso __devinitconst = {
+	.type		= BT_PICASSO,
+	.ramid		= ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_RAM,
+};
+
+static const struct zorrocl zcl_spectrum __devinitconst = {
+	.type		= BT_SPECTRUM,
+	.ramid		= ZORRO_PROD_GVP_EGS_28_24_SPECTRUM_RAM,
+};
+
+static const struct zorrocl zcl_picasso4_z3 __devinitconst = {
+	.type		= BT_PICASSO4,
+	.regoffset	= 0x00600000,
+	.ramsize	= 4 * MB_,
+	.ramoffset	= 0x01000000,
+};
+
+
+static const struct zorro_device_id cirrusfb_zorro_table[] __devinitconst = {
 	{
-		.id		= ZORRO_PROD_HELFRICH_SD64_RAM,
-		.driver_data	= BT_SD64,
+		.id		= ZORRO_PROD_HELFRICH_SD64_REG,
+		.driver_data	= (unsigned long)&zcl_sd64,
 	}, {
-		.id		= ZORRO_PROD_HELFRICH_PICCOLO_RAM,
-		.driver_data	= BT_PICCOLO,
+		.id		= ZORRO_PROD_HELFRICH_PICCOLO_REG,
+		.driver_data	= (unsigned long)&zcl_piccolo,
 	}, {
-		.id	= ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_RAM,
-		.driver_data	= BT_PICASSO,
+		.id	= ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_REG,
+		.driver_data	= (unsigned long)&zcl_picasso,
 	}, {
-		.id		= ZORRO_PROD_GVP_EGS_28_24_SPECTRUM_RAM,
-		.driver_data	= BT_SPECTRUM,
+		.id		= ZORRO_PROD_GVP_EGS_28_24_SPECTRUM_REG,
+		.driver_data	= (unsigned long)&zcl_spectrum,
 	}, {
 		.id		= ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z3,
-		.driver_data	= BT_PICASSO4,
+		.driver_data	= (unsigned long)&zcl_picasso4_z3,
 	},
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(zorro, cirrusfb_zorro_table);
-
-static const struct {
-	zorro_id id2;
-	unsigned long size;
-} cirrusfb_zorro_table2[] = {
-	[BT_SD64] = {
-		.id2	= ZORRO_PROD_HELFRICH_SD64_REG,
-		.size	= 0x400000
-	},
-	[BT_PICCOLO] = {
-		.id2	= ZORRO_PROD_HELFRICH_PICCOLO_REG,
-		.size	= 0x200000
-	},
-	[BT_PICASSO] = {
-		.id2	= ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_REG,
-		.size	= 0x200000
-	},
-	[BT_SPECTRUM] = {
-		.id2	= ZORRO_PROD_GVP_EGS_28_24_SPECTRUM_REG,
-		.size	= 0x200000
-	},
-	[BT_PICASSO4] = {
-		.id2	= 0,
-		.size	= 0x400000
-	}
-};
 #endif /* CONFIG_ZORRO */
 
 #ifdef CIRRUSFB_DEBUG
@@ -1956,16 +1967,12 @@ static void cirrusfb_zorro_unmap(struct fb_info *info)
 	struct cirrusfb_info *cinfo = info->par;
 	struct zorro_dev *zdev = to_zorro_dev(info->device);
 
-	zorro_release_device(zdev);
-
-	if (cinfo->btype == BT_PICASSO4) {
-		cinfo->regbase -= 0x600000;
-		iounmap((void *)cinfo->regbase);
+	if (info->fix.smem_start > 16 * MB_)
 		iounmap(info->screen_base);
-	} else {
-		if (zorro_resource_start(zdev) > 0x01000000)
-			iounmap(info->screen_base);
-	}
+	if (info->fix.mmio_start > 16 * MB_)
+		iounmap(cinfo->regbase);
+
+	zorro_release_device(zdev);
 }
 #endif /* CONFIG_ZORRO */
 
@@ -2222,115 +2229,102 @@ static struct pci_driver cirrusfb_pci_driver = {
 static int __devinit cirrusfb_zorro_register(struct zorro_dev *z,
 					     const struct zorro_device_id *ent)
 {
-	struct cirrusfb_info *cinfo;
 	struct fb_info *info;
+	int error;
+	const struct zorrocl *zcl;
 	enum cirrus_board btype;
-	struct zorro_dev *z2 = NULL;
-	unsigned long board_addr, board_size, size;
-	int ret;
-
-	btype = ent->driver_data;
-	if (cirrusfb_zorro_table2[btype].id2)
-		z2 = zorro_find_device(cirrusfb_zorro_table2[btype].id2, NULL);
-	size = cirrusfb_zorro_table2[btype].size;
+	unsigned long regbase, ramsize, rambase;
+	struct cirrusfb_info *cinfo;
 
 	info = framebuffer_alloc(sizeof(struct cirrusfb_info), &z->dev);
 	if (!info) {
 		printk(KERN_ERR "cirrusfb: could not allocate memory\n");
-		ret = -ENOMEM;
-		goto err_out;
+		return -ENOMEM;
 	}
 
-	dev_info(info->device, "%s board detected\n",
-		 cirrusfb_board_info[btype].name);
-
-	cinfo = info->par;
-	cinfo->btype = btype;
-
-	assert(z);
-	assert(btype != BT_NONE);
+	zcl = (const struct zorrocl *)ent->driver_data;
+	btype = zcl->type;
+	regbase = zorro_resource_start(z) + zcl->regoffset;
+	ramsize = zcl->ramsize;
+	if (ramsize) {
+		rambase = zorro_resource_start(z) + zcl->ramoffset;
+	} else {
+		struct zorro_dev *ram = zorro_find_device(zcl->ramid, NULL);
+		if (!ram || !zorro_resource_len(ram)) {
+			dev_err(info->device, "No video RAM found\n");
+			error = -ENODEV;
+			goto err_release_fb;
+		}
+		rambase = zorro_resource_start(ram);
+		ramsize = zorro_resource_len(ram);
+	}
 
-	board_addr = zorro_resource_start(z);
-	board_size = zorro_resource_len(z);
-	info->screen_size = size;
+	dev_info(info->device,
+		 "%s board detected, REG at 0x%lx, %lu MiB RAM at 0x%lx\n",
+		 cirrusfb_board_info[btype].name, regbase, ramsize / MB_,
+		 rambase);
 
 	if (!zorro_request_device(z, "cirrusfb")) {
-		dev_err(info->device, "cannot reserve region 0x%lx, abort\n",
-			board_addr);
-		ret = -EBUSY;
+		dev_err(info->device, "Cannot reserve %pR\n", &z->resource);
+		error = -EBUSY;
 		goto err_release_fb;
 	}
 
-	ret = -EIO;
-
-	if (btype == BT_PICASSO4) {
-		dev_info(info->device, " REG at $%lx\n", board_addr + 0x600000);
-
-		/* To be precise, for the P4 this is not the */
-		/* begin of the board, but the begin of RAM. */
-		/* for P4, map in its address space in 2 chunks (### TEST! ) */
-		/* (note the ugly hardcoded 16M number) */
-		cinfo->regbase = ioremap(board_addr, 16777216);
-		if (!cinfo->regbase)
-			goto err_release_region;
-
-		dev_dbg(info->device, "Virtual address for board set to: $%p\n",
-			cinfo->regbase);
-		cinfo->regbase += 0x600000;
-		info->fix.mmio_start = board_addr + 0x600000;
-
-		info->fix.smem_start = board_addr + 16777216;
-		info->screen_base = ioremap(info->fix.smem_start, 16777216);
-		if (!info->screen_base)
-			goto err_unmap_regbase;
-	} else {
-		dev_info(info->device, " REG at $%lx\n",
-			 (unsigned long) z2->resource.start);
-
-		info->fix.smem_start = board_addr;
-		if (board_addr > 0x01000000)
-			info->screen_base = ioremap(board_addr, board_size);
-		else
-			info->screen_base = (caddr_t) ZTWO_VADDR(board_addr);
-		if (!info->screen_base)
-			goto err_release_region;
+	cinfo = info->par;
+	cinfo->btype = btype;
 
-		/* set address for REG area of board */
-		cinfo->regbase = (caddr_t) ZTWO_VADDR(z2->resource.start);
-		info->fix.mmio_start = z2->resource.start;
+	info->fix.mmio_start = regbase;
+	cinfo->regbase = regbase > 16 * MB_ ? ioremap(regbase, 64 * 1024)
+					    : (caddr_t)ZTWO_VADDR(regbase);
+	if (!cinfo->regbase) {
+		dev_err(info->device, "Cannot map registers\n");
+		error = -EIO;
+		goto err_release_dev;
+	}
 
-		dev_dbg(info->device, "Virtual address for board set to: $%p\n",
-			cinfo->regbase);
+	info->fix.smem_start = rambase;
+	info->screen_size = ramsize;
+	info->screen_base = rambase > 16 * MB_ ? ioremap(rambase, ramsize)
+					       : (caddr_t)ZTWO_VADDR(rambase);
+	if (!info->screen_base) {
+		dev_err(info->device, "Cannot map video RAM\n");
+		error = -EIO;
+		goto err_unmap_reg;
 	}
+
 	cinfo->unmap = cirrusfb_zorro_unmap;
 
 	dev_info(info->device,
-		 "Cirrus Logic chipset on Zorro bus, RAM (%lu MB) at $%lx\n",
-		 board_size / MB_, board_addr);
-
-	zorro_set_drvdata(z, info);
+		 "Cirrus Logic chipset on Zorro bus, RAM (%lu MiB) at 0x%lx\n",
+		 ramsize / MB_, rambase);
 
 	/* MCLK select etc. */
 	if (cirrusfb_board_info[btype].init_sr1f)
 		vga_wseq(cinfo->regbase, CL_SEQR1F,
 			 cirrusfb_board_info[btype].sr1f);
 
-	ret = cirrusfb_register(info);
-	if (!ret)
-		return 0;
+	error = cirrusfb_register(info);
+	if (error) {
+		dev_err(info->device, "Failed to register device, error %d\n",
+			error);
+		goto err_unmap_ram;
+	}
 
-	if (btype == BT_PICASSO4 || board_addr > 0x01000000)
+	zorro_set_drvdata(z, info);
+	return 0;
+
+err_unmap_ram:
+	if (rambase > 16 * MB_)
 		iounmap(info->screen_base);
 
-err_unmap_regbase:
-	if (btype == BT_PICASSO4)
-		iounmap(cinfo->regbase - 0x600000);
-err_release_region:
-	release_region(board_addr, board_size);
+err_unmap_reg:
+	if (regbase > 16 * MB_)
+		iounmap(cinfo->regbase);
+err_release_dev:
+	zorro_release_device(z);
 err_release_fb:
 	framebuffer_release(info);
-err_out:
-	return ret;
+	return error;
 }
 
 void __devexit cirrusfb_zorro_unregister(struct zorro_dev *z)
@@ -2338,6 +2332,7 @@ void __devexit cirrusfb_zorro_unregister(struct zorro_dev *z)
 	struct fb_info *info = zorro_get_drvdata(z);
 
 	cirrusfb_cleanup(info);
+	zorro_set_drvdata(z, NULL);
 }
 
 static struct zorro_driver cirrusfb_zorro_driver = {
-- 
1.7.0.4

