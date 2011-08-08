Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1HHS1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:27:20 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1522 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1HHS1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:27:19 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Brian Norris" <computersforpeace@gmail.com>
To: "Artem Bityutskiy" <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>, avorontsov@ru.mvista.com,
        axel.lin@gmail.com
Subject: [PATCH] mtd: plat_nand: fix `bbt_options' compile error
Date: Mon, 8 Aug 2011 11:26:33 -0700
Message-ID: <1312827993-19163-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
X-WSS-ID: 625EF43F3W42800298-13-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a bug in commit 86cb232d4e6b589be3daef8d570d1921c05be962
("mtd: nand: consolidate redundant flash-based BBT flags"). The problem
was reported by Axel Lin at:

  http://lists.infradead.org/pipermail/linux-mtd/2011-August/037340.html

In restructuring a few of the fields in `struct nand_chip' and similar, I
overlooked my reference to a field in `struct platform_nand_chip' that
didn't exist. He discovered the bug via an ARM build that I didn't test:

  make orion5x_defconfig
  make

    CC      arch/arm/mach-orion5x/ts78xx-setup.o
  arch/arm/mach-orion5x/ts78xx-setup.c:278: error: unknown field 'bbt_options' specified in initializer
  make[1]: *** [arch/arm/mach-orion5x/ts78xx-setup.o] Error 1
  make: *** [arch/arm/mach-orion5x] Error 2

The fix is simply to add the new `bbt_options' field to
`platform_nand_chip' and to pass those options on to `nand_chip' during
its initialization.

I re-reviewed the rest of my previous commit and didn't find any other
similar errors.

Based on:

  git://git.infradead.org/users/dedekind/l2-mtd-2.6.git

Reported-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 drivers/mtd/nand/plat_nand.c |    1 +
 include/linux/mtd/nand.h     |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index e62468b..ea8e123 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -77,6 +77,7 @@ static int __devinit plat_nand_probe(struct platform_device *pdev)
 	data->chip.read_buf = pdata->ctrl.read_buf;
 	data->chip.chip_delay = pdata->chip.chip_delay;
 	data->chip.options |= pdata->chip.options;
+	data->chip.bbt_options |= pdata->chip.bbt_options;
 
 	data->chip.ecc.hwctl = pdata->ctrl.hwcontrol;
 	data->chip.ecc.layout = pdata->chip.ecclayout;
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index ebd806f..f4fdb1e 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -604,6 +604,7 @@ extern int nand_do_read(struct mtd_info *mtd, loff_t from, size_t len,
  * @partitions:		mtd partition list
  * @chip_delay:		R/B delay value in us
  * @options:		Option flags, e.g. 16bit buswidth
+ * @bbt_options:	BBT option flags, e.g. NAND_BBT_USE_FLASH
  * @ecclayout:		ECC layout info structure
  * @part_probe_types:	NULL-terminated array of probe types
  */
@@ -615,6 +616,7 @@ struct platform_nand_chip {
 	struct nand_ecclayout *ecclayout;
 	int chip_delay;
 	unsigned int options;
+	unsigned int bbt_options;
 	const char **part_probe_types;
 };
 
-- 
1.7.0.4


