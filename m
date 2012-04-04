Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2DDBfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 21:35:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59096 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2DDBe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 21:34:28 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 4/5] mtd: remove ixp2000 map device
Date: Tue,  3 Apr 2012 20:34:02 -0500
Message-Id: <1333503243-7702-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
References: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The platform is removed, so there are no users of this driver.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/maps/Kconfig   |    9 --
 drivers/mtd/maps/Makefile  |    1 -
 drivers/mtd/maps/ixp2000.c |  253 --------------------------------------------
 3 files changed, 0 insertions(+), 263 deletions(-)
 delete mode 100644 drivers/mtd/maps/ixp2000.c

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 8af67cf..ddb2935 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -356,15 +356,6 @@ config MTD_IXP4XX
 	  IXDP425 and Coyote. If you have an IXP4xx based board and
 	  would like to use the flash chips on it, say 'Y'.
 
-config MTD_IXP2000
-	tristate "CFI Flash device mapped on Intel IXP2000 based systems"
-	depends on MTD_CFI && MTD_COMPLEX_MAPPINGS && ARCH_IXP2000
-	help
-	  This enables MTD access to flash devices on platforms based
-	  on Intel's IXP2000 family of network processors. If you have an
-	  IXP2000 based board and would like to use the flash chips on it,
-	  say 'Y'.
-
 config MTD_FORTUNET
 	tristate "CFI Flash device mapped on the FortuNet board"
 	depends on MTD_CFI && SA1100_FORTUNET
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 68a9a91..cfa110c 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -46,7 +46,6 @@ obj-$(CONFIG_MTD_NETtel)	+= nettel.o
 obj-$(CONFIG_MTD_SCB2_FLASH)	+= scb2_flash.o
 obj-$(CONFIG_MTD_H720X)		+= h720x-flash.o
 obj-$(CONFIG_MTD_IXP4XX)	+= ixp4xx.o
-obj-$(CONFIG_MTD_IXP2000)	+= ixp2000.o
 obj-$(CONFIG_MTD_WRSBC8260)	+= wr_sbc82xx_flash.o
 obj-$(CONFIG_MTD_DMV182)	+= dmv182.o
 obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
diff --git a/drivers/mtd/maps/ixp2000.c b/drivers/mtd/maps/ixp2000.c
deleted file mode 100644
index 4a41ced..0000000
--- a/drivers/mtd/maps/ixp2000.c
+++ /dev/null
@@ -1,253 +0,0 @@
-/*
- * drivers/mtd/maps/ixp2000.c
- *
- * Mapping for the Intel XScale IXP2000 based systems
- *
- * Copyright (C) 2002 Intel Corp.
- * Copyright (C) 2003-2004 MontaVista Software, Inc.
- *
- * Original Author: Naeem M Afzal <naeem.m.afzal@intel.com>
- * Maintainer: Deepak Saxena <dsaxena@plexity.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/ioport.h>
-#include <linux/device.h>
-#include <linux/platform_device.h>
-
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/partitions.h>
-
-#include <asm/io.h>
-#include <mach/hardware.h>
-#include <asm/mach/flash.h>
-
-#include <linux/reboot.h>
-
-struct ixp2000_flash_info {
-	struct		mtd_info *mtd;
-	struct		map_info map;
-	struct		resource *res;
-};
-
-static inline unsigned long flash_bank_setup(struct map_info *map, unsigned long ofs)
-{
-	unsigned long (*set_bank)(unsigned long) =
-		(unsigned long(*)(unsigned long))map->map_priv_2;
-
-	return (set_bank ? set_bank(ofs) : ofs);
-}
-
-#ifdef __ARMEB__
-/*
- * Rev A0 and A1 of IXP2400 silicon have a broken addressing unit which
- * causes the lower address bits to be XORed with 0x11 on 8 bit accesses
- * and XORed with 0x10 on 16 bit accesses. See the spec update, erratum 44.
- */
-static int erratum44_workaround = 0;
-
-static inline unsigned long address_fix8_write(unsigned long addr)
-{
-	if (erratum44_workaround) {
-		return (addr ^ 3);
-	}
-	return addr;
-}
-#else
-
-#define address_fix8_write(x)	(x)
-#endif
-
-static map_word ixp2000_flash_read8(struct map_info *map, unsigned long ofs)
-{
-	map_word val;
-
-	val.x[0] =  *((u8 *)(map->map_priv_1 + flash_bank_setup(map, ofs)));
-	return val;
-}
-
-/*
- * We can't use the standard memcpy due to the broken SlowPort
- * address translation on rev A0 and A1 silicon and the fact that
- * we have banked flash.
- */
-static void ixp2000_flash_copy_from(struct map_info *map, void *to,
-			      unsigned long from, ssize_t len)
-{
-	from = flash_bank_setup(map, from);
-	while(len--)
-		*(__u8 *) to++ = *(__u8 *)(map->map_priv_1 + from++);
-}
-
-static void ixp2000_flash_write8(struct map_info *map, map_word d, unsigned long ofs)
-{
-	*(__u8 *) (address_fix8_write(map->map_priv_1 +
-				      flash_bank_setup(map, ofs))) = d.x[0];
-}
-
-static void ixp2000_flash_copy_to(struct map_info *map, unsigned long to,
-			    const void *from, ssize_t len)
-{
-	to = flash_bank_setup(map, to);
-	while(len--) {
-		unsigned long tmp = address_fix8_write(map->map_priv_1 + to++);
-		*(__u8 *)(tmp) = *(__u8 *)(from++);
-	}
-}
-
-
-static int ixp2000_flash_remove(struct platform_device *dev)
-{
-	struct flash_platform_data *plat = dev->dev.platform_data;
-	struct ixp2000_flash_info *info = platform_get_drvdata(dev);
-
-	platform_set_drvdata(dev, NULL);
-
-	if(!info)
-		return 0;
-
-	if (info->mtd) {
-		mtd_device_unregister(info->mtd);
-		map_destroy(info->mtd);
-	}
-	if (info->map.map_priv_1)
-		iounmap((void *) info->map.map_priv_1);
-
-	if (info->res) {
-		release_resource(info->res);
-		kfree(info->res);
-	}
-
-	if (plat->exit)
-		plat->exit();
-
-	return 0;
-}
-
-
-static int ixp2000_flash_probe(struct platform_device *dev)
-{
-	static const char *probes[] = { "RedBoot", "cmdlinepart", NULL };
-	struct ixp2000_flash_data *ixp_data = dev->dev.platform_data;
-	struct flash_platform_data *plat;
-	struct ixp2000_flash_info *info;
-	unsigned long window_size;
-	int err = -1;
-
-	if (!ixp_data)
-		return -ENODEV;
-
-	plat = ixp_data->platform_data;
-	if (!plat)
-		return -ENODEV;
-
-	window_size = resource_size(dev->resource);
-	dev_info(&dev->dev, "Probe of IXP2000 flash(%d banks x %dMiB)\n",
-		 ixp_data->nr_banks, ((u32)window_size >> 20));
-
-	if (plat->width != 1) {
-		dev_err(&dev->dev, "IXP2000 MTD map only supports 8-bit mode, asking for %d\n",
-			plat->width * 8);
-		return -EIO;
-	}
-
-	info = kzalloc(sizeof(struct ixp2000_flash_info), GFP_KERNEL);
-	if(!info) {
-		err = -ENOMEM;
-		goto Error;
-	}
-
-	platform_set_drvdata(dev, info);
-
-	/*
-	 * Tell the MTD layer we're not 1:1 mapped so that it does
-	 * not attempt to do a direct access on us.
-	 */
-	info->map.phys = NO_XIP;
-
-	info->map.size = ixp_data->nr_banks * window_size;
-	info->map.bankwidth = 1;
-
-	/*
- 	 * map_priv_2 is used to store a ptr to the bank_setup routine
- 	 */
-	info->map.map_priv_2 = (unsigned long) ixp_data->bank_setup;
-
-	info->map.name = dev_name(&dev->dev);
-	info->map.read = ixp2000_flash_read8;
-	info->map.write = ixp2000_flash_write8;
-	info->map.copy_from = ixp2000_flash_copy_from;
-	info->map.copy_to = ixp2000_flash_copy_to;
-
-	info->res = request_mem_region(dev->resource->start,
-				       resource_size(dev->resource),
-				       dev_name(&dev->dev));
-	if (!info->res) {
-		dev_err(&dev->dev, "Could not reserve memory region\n");
-		err = -ENOMEM;
-		goto Error;
-	}
-
-	info->map.map_priv_1 =
-		(unsigned long)ioremap(dev->resource->start,
-				       resource_size(dev->resource));
-	if (!info->map.map_priv_1) {
-		dev_err(&dev->dev, "Failed to ioremap flash region\n");
-		err = -EIO;
-		goto Error;
-	}
-
-#if defined(__ARMEB__)
-	/*
-	 * Enable erratum 44 workaround for NPUs with broken slowport
-	 */
-
-	erratum44_workaround = ixp2000_has_broken_slowport();
-	dev_info(&dev->dev, "Erratum 44 workaround %s\n",
-	       erratum44_workaround ? "enabled" : "disabled");
-#endif
-
-	info->mtd = do_map_probe(plat->map_name, &info->map);
-	if (!info->mtd) {
-		dev_err(&dev->dev, "map_probe failed\n");
-		err = -ENXIO;
-		goto Error;
-	}
-	info->mtd->owner = THIS_MODULE;
-
-	err = mtd_device_parse_register(info->mtd, probes, NULL, NULL, 0);
-	if (err)
-		goto Error;
-
-	return 0;
-
-Error:
-	ixp2000_flash_remove(dev);
-	return err;
-}
-
-static struct platform_driver ixp2000_flash_driver = {
-	.probe		= ixp2000_flash_probe,
-	.remove		= ixp2000_flash_remove,
-	.driver		= {
-		.name	= "IXP2000-Flash",
-		.owner	= THIS_MODULE,
-	},
-};
-
-module_platform_driver(ixp2000_flash_driver);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
-MODULE_ALIAS("platform:IXP2000-Flash");
-- 
1.7.5.4

