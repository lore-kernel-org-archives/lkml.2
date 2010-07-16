Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965354Ab0GPM3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:29:14 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43466 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965342Ab0GPM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:29:10 -0400
Date: Fri, 16 Jul 2010 14:29:08 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Milton Miller <miltonm@bga.com>, David Woodhouse <dwmw2@infradead.org>,
        Mike Frysinger <vapier@gentoo.org>, Jiri Kosina <jkosina@suse.cz>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Alexander Kurz <linux@kbdbabel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/2] Removed redwood/mtd mapping
Message-ID: <ae6929d3206f6a282f2b0bf2621a05af45d892ff.1279282865.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <4f07b3092cafbbba37d61d367cc7484e24d18d2a.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <redwood56-reply-1-miltonm@bga.com>
 <cover.1279282865.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279282865.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the redwood mtd mapping driver, because all REDWOOD_[456]
configuration options were removed from the kernel, because they weren't
referenced anywhere.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/mtd/maps/Kconfig   |    8 ---
 drivers/mtd/maps/Makefile  |    1 -
 drivers/mtd/maps/redwood.c |  131 --------------------------------------------
 3 files changed, 0 insertions(+), 140 deletions(-)
 delete mode 100644 drivers/mtd/maps/redwood.c

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 6629d09..701d942 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -319,14 +319,6 @@ config MTD_CFI_FLAGADM
 	  Mapping for the Flaga digital module. If you don't have one, ignore
 	  this setting.
 
-config MTD_REDWOOD
-	tristate "CFI Flash devices mapped on IBM Redwood"
-	depends on MTD_CFI
-	help
-	  This enables access routines for the flash chips on the IBM
-	  Redwood board. If you have one of these boards and would like to
-	  use the flash chips on it, say 'Y'.
-
 config MTD_SOLUTIONENGINE
 	tristate "CFI Flash device mapped on Hitachi SolutionEngine"
 	depends on SUPERH && SOLUTION_ENGINE && MTD_CFI && MTD_REDBOOT_PARTS
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index bb035cd..f216bb5 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -44,7 +44,6 @@ obj-$(CONFIG_MTD_AUTCPU12)	+= autcpu12-nvram.o
 obj-$(CONFIG_MTD_EDB7312)	+= edb7312.o
 obj-$(CONFIG_MTD_IMPA7)		+= impa7.o
 obj-$(CONFIG_MTD_FORTUNET)	+= fortunet.o
-obj-$(CONFIG_MTD_REDWOOD)	+= redwood.o
 obj-$(CONFIG_MTD_UCLINUX)	+= uclinux.o
 obj-$(CONFIG_MTD_NETtel)	+= nettel.o
 obj-$(CONFIG_MTD_SCB2_FLASH)	+= scb2_flash.o
diff --git a/drivers/mtd/maps/redwood.c b/drivers/mtd/maps/redwood.c
deleted file mode 100644
index d2c9db0..0000000
--- a/drivers/mtd/maps/redwood.c
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * drivers/mtd/maps/redwood.c
- *
- * FLASH map for the IBM Redwood 4/5/6 boards.
- *
- * Author: MontaVista Software, Inc. <source@mvista.com>
- *
- * 2001-2003 (c) MontaVista, Software, Inc. This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/partitions.h>
-
-#include <asm/io.h>
-
-#define WINDOW_ADDR 0xffc00000
-#define WINDOW_SIZE 0x00400000
-
-#define RW_PART0_OF	0
-#define RW_PART0_SZ	0x10000
-#define RW_PART1_OF	RW_PART0_SZ
-#define RW_PART1_SZ	0x200000 - 0x10000
-#define RW_PART2_OF	0x200000
-#define RW_PART2_SZ	0x10000
-#define RW_PART3_OF	0x210000
-#define RW_PART3_SZ	0x200000 - (0x10000 + 0x20000)
-#define RW_PART4_OF	0x3e0000
-#define RW_PART4_SZ	0x20000
-
-static struct mtd_partition redwood_flash_partitions[] = {
-	{
-		.name = "Redwood OpenBIOS Vital Product Data",
-		.offset = RW_PART0_OF,
-		.size = RW_PART0_SZ,
-		.mask_flags = MTD_WRITEABLE	/* force read-only */
-	},
-	{
-		.name = "Redwood kernel",
-		.offset = RW_PART1_OF,
-		.size = RW_PART1_SZ
-	},
-	{
-		.name = "Redwood OpenBIOS non-volatile storage",
-		.offset = RW_PART2_OF,
-		.size = RW_PART2_SZ,
-		.mask_flags = MTD_WRITEABLE	/* force read-only */
-	},
-	{
-		.name = "Redwood filesystem",
-		.offset = RW_PART3_OF,
-		.size = RW_PART3_SZ
-	},
-	{
-		.name = "Redwood OpenBIOS",
-		.offset = RW_PART4_OF,
-		.size = RW_PART4_SZ,
-		.mask_flags = MTD_WRITEABLE	/* force read-only */
-	}
-};
-
-struct map_info redwood_flash_map = {
-	.name = "IBM Redwood",
-	.size = WINDOW_SIZE,
-	.bankwidth = 2,
-	.phys = WINDOW_ADDR,
-};
-
-
-#define NUM_REDWOOD_FLASH_PARTITIONS ARRAY_SIZE(redwood_flash_partitions)
-
-static struct mtd_info *redwood_mtd;
-
-static int __init init_redwood_flash(void)
-{
-	int err;
-
-	printk(KERN_NOTICE "redwood: flash mapping: %x at %x\n",
-			WINDOW_SIZE, WINDOW_ADDR);
-
-	redwood_flash_map.virt = ioremap(WINDOW_ADDR, WINDOW_SIZE);
-
-	if (!redwood_flash_map.virt) {
-		printk("init_redwood_flash: failed to ioremap\n");
-		return -EIO;
-	}
-	simple_map_init(&redwood_flash_map);
-
-	redwood_mtd = do_map_probe("cfi_probe",&redwood_flash_map);
-
-	if (redwood_mtd) {
-		redwood_mtd->owner = THIS_MODULE;
-		err = add_mtd_partitions(redwood_mtd,
-				redwood_flash_partitions,
-				NUM_REDWOOD_FLASH_PARTITIONS);
-		if (err) {
-			printk("init_redwood_flash: add_mtd_partitions failed\n");
-			iounmap(redwood_flash_map.virt);
-		}
-		return err;
-
-	}
-
-	iounmap(redwood_flash_map.virt);
-	return -ENXIO;
-}
-
-static void __exit cleanup_redwood_flash(void)
-{
-	if (redwood_mtd) {
-		del_mtd_partitions(redwood_mtd);
-		/* moved iounmap after map_destroy - armin */
-		map_destroy(redwood_mtd);
-		iounmap((void *)redwood_flash_map.virt);
-	}
-}
-
-module_init(init_redwood_flash);
-module_exit(cleanup_redwood_flash);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("MontaVista Software <source@mvista.com>");
-MODULE_DESCRIPTION("MTD map driver for the IBM Redwood reference boards");
-- 
1.7.0.4

