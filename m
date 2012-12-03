Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2LCPEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:04:13 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50548 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2LCPEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:04:11 -0500
Subject: [PATCH 9/9] goldfish: NAND flash driver
To: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
From: Alan Cox <alan@linux.intel.com>
Date: Mon, 03 Dec 2012 15:06:33 +0000
Message-ID: <20121203150622.16826.46798.stgit@bob.linux.org.uk>
In-Reply-To: <20121203150310.16826.3363.stgit@bob.linux.org.uk>
References: <20121203150310.16826.3363.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@google.com>

Fold together the NAND driver for Goldfish from Arve with cleanups by
Jun Nakajima and a tidy up to 3.7 and checkpatch.

Signed-off-by: Mike A. Chan <mikechan@google.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
[Ported to handle x86]
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Xiaohui Xin <xiaohui.xin@intel.com>
Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Bruce Beare <bruce.j.beare@intel.com>
[Ported to 3.4]
Signed-off-by: Tom Keel <thomas.keel@intel.com>
[Ported to 3.7 and tided for checkpatch etc]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mtd/devices/Kconfig             |    7 
 drivers/mtd/devices/Makefile            |    3 
 drivers/mtd/devices/goldfish_nand.c     |  475 +++++++++++++++++++++++++++++++
 drivers/mtd/devices/goldfish_nand_reg.h |   72 +++++
 4 files changed, 556 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mtd/devices/goldfish_nand.c
 create mode 100644 drivers/mtd/devices/goldfish_nand_reg.h


diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index c187342..7edecf0 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -342,4 +342,11 @@ config MTD_DOCPROBE_55AA
 	  LinuxBIOS or if you need to recover a DiskOnChip Millennium on which
 	  you have managed to wipe the first block.
 
+config MTD_GOLDFISH_NAND
+	tristate "Goldfish NAND device"
+	depends on GOLDFISH
+	help
+	  Drives the emulated NAND flash device on the Google Goldfish
+	  Android virtual device.
+
 endmenu
diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
index 395733a..36d4791 100644
--- a/drivers/mtd/devices/Makefile
+++ b/drivers/mtd/devices/Makefile
@@ -20,5 +20,6 @@ obj-$(CONFIG_MTD_M25P80)	+= m25p80.o
 obj-$(CONFIG_MTD_SPEAR_SMI)	+= spear_smi.o
 obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
 obj-$(CONFIG_MTD_BCM47XXSFLASH)	+= bcm47xxsflash.o
+obj-$(CONFIG_MTD_GOLDFISH_NAND)	+= goldfish_nand.o
 
-CFLAGS_docg3.o			+= -I$(src)
\ No newline at end of file
+CFLAGS_docg3.o			+= -I$(src)
diff --git a/drivers/mtd/devices/goldfish_nand.c b/drivers/mtd/devices/goldfish_nand.c
new file mode 100644
index 0000000..5b932ba
--- /dev/null
+++ b/drivers/mtd/devices/goldfish_nand.c
@@ -0,0 +1,475 @@
+/*
+ * drivers/mtd/devices/goldfish_nand.c
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (C) 2012 Intel, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/ioport.h>
+#include <linux/vmalloc.h>
+#include <linux/init.h>
+#include <linux/mtd/mtd.h>
+#include <linux/platform_device.h>
+
+#include <asm/div64.h>
+
+#include "goldfish_nand_reg.h"
+
+struct goldfish_nand {
+	spinlock_t              lock;
+	unsigned char __iomem  *base;
+	struct cmd_params       *cmd_params;
+	size_t                  mtd_count;
+	struct mtd_info         mtd[0];
+};
+
+static u32 goldfish_nand_cmd_with_params(struct mtd_info *mtd,
+			enum nand_cmd cmd, u64 addr, u32 len,
+			void *ptr, u32 *rv)
+{
+	u32 cmdp;
+	struct goldfish_nand *nand = mtd->priv;
+	struct cmd_params *cps = nand->cmd_params;
+	unsigned char __iomem  *base = nand->base;
+
+	if (cps == NULL)
+		return -1;
+
+	switch (cmd) {
+	case NAND_CMD_ERASE:
+		cmdp = NAND_CMD_ERASE_WITH_PARAMS;
+		break;
+	case NAND_CMD_READ:
+		cmdp = NAND_CMD_READ_WITH_PARAMS;
+		break;
+	case NAND_CMD_WRITE:
+		cmdp = NAND_CMD_WRITE_WITH_PARAMS;
+		break;
+	default:
+		return -1;
+	}
+	cps->dev = mtd - nand->mtd;
+	cps->addr_high = (u32)(addr >> 32);
+	cps->addr_low = (u32)addr;
+	cps->transfer_size = len;
+	cps->data = (u32)ptr;
+	writel(cmdp, base + NAND_COMMAND);
+	*rv = cps->result;
+	return 0;
+}
+
+static u32 goldfish_nand_cmd(struct mtd_info *mtd, enum nand_cmd cmd,
+				u64 addr, u32 len, void *ptr)
+{
+	struct goldfish_nand *nand = mtd->priv;
+	u32 rv;
+	unsigned long irq_flags;
+	unsigned char __iomem  *base = nand->base;
+
+	spin_lock_irqsave(&nand->lock, irq_flags);
+	if (goldfish_nand_cmd_with_params(mtd, cmd, addr, len, ptr, &rv)) {
+		writel(mtd - nand->mtd, base + NAND_DEV);
+		writel((u32)(addr >> 32), base + NAND_ADDR_HIGH);
+		writel((u32)addr, base + NAND_ADDR_LOW);
+		writel(len, base + NAND_TRANSFER_SIZE);
+		writel((u32)ptr, base + NAND_DATA);
+		writel(cmd, base + NAND_COMMAND);
+		rv = readl(base + NAND_RESULT);
+	}
+	spin_unlock_irqrestore(&nand->lock, irq_flags);
+	return rv;
+}
+
+static int goldfish_nand_erase(struct mtd_info *mtd, struct erase_info *instr)
+{
+	loff_t ofs = instr->addr;
+	u32 len = instr->len;
+	u32 rem;
+
+	if (ofs + len > mtd->size)
+		goto invalid_arg;
+	rem = do_div(ofs, mtd->writesize);
+	if (rem)
+		goto invalid_arg;
+	ofs *= (mtd->writesize + mtd->oobsize);
+
+	if (len % mtd->writesize)
+		goto invalid_arg;
+	len = len / mtd->writesize * (mtd->writesize + mtd->oobsize);
+
+	if (goldfish_nand_cmd(mtd, NAND_CMD_ERASE, ofs, len, NULL) != len) {
+		pr_err("goldfish_nand_erase: erase failed, start %llx, len %x, dev_size %llx, erase_size %x\n",
+			ofs, len, mtd->size, mtd->erasesize);
+		return -EIO;
+	}
+
+	instr->state = MTD_ERASE_DONE;
+	mtd_erase_callback(instr);
+
+	return 0;
+
+invalid_arg:
+	pr_err("goldfish_nand_erase: invalid erase, start %llx, len %x, dev_size %llx, erase_size %x\n",
+		ofs, len, mtd->size, mtd->erasesize);
+	return -EINVAL;
+}
+
+static int goldfish_nand_read_oob(struct mtd_info *mtd, loff_t ofs,
+				struct mtd_oob_ops *ops)
+{
+	u32 rem;
+
+	if (ofs + ops->len > mtd->size)
+		goto invalid_arg;
+	if (ops->datbuf && ops->len && ops->len != mtd->writesize)
+		goto invalid_arg;
+	if (ops->ooblen + ops->ooboffs > mtd->oobsize)
+		goto invalid_arg;
+
+	rem = do_div(ofs, mtd->writesize);
+	if (rem)
+		goto invalid_arg;
+	ofs *= (mtd->writesize + mtd->oobsize);
+
+	if (ops->datbuf)
+		ops->retlen = goldfish_nand_cmd(mtd, NAND_CMD_READ, ofs,
+						ops->len, ops->datbuf);
+	ofs += mtd->writesize + ops->ooboffs;
+	if (ops->oobbuf)
+		ops->oobretlen = goldfish_nand_cmd(mtd, NAND_CMD_READ, ofs,
+						ops->ooblen, ops->oobbuf);
+	return 0;
+
+invalid_arg:
+	pr_err("goldfish_nand_read_oob: invalid read, start %llx, len %x, ooblen %x, dev_size %llx, write_size %x\n",
+		ofs, ops->len, ops->ooblen, mtd->size, mtd->writesize);
+	return -EINVAL;
+}
+
+static int goldfish_nand_write_oob(struct mtd_info *mtd, loff_t ofs,
+				struct mtd_oob_ops *ops)
+{
+	u32 rem;
+
+	if (ofs + ops->len > mtd->size)
+		goto invalid_arg;
+	if (ops->len && ops->len != mtd->writesize)
+		goto invalid_arg;
+	if (ops->ooblen + ops->ooboffs > mtd->oobsize)
+		goto invalid_arg;
+
+	rem = do_div(ofs, mtd->writesize);
+	if (rem)
+		goto invalid_arg;
+	ofs *= (mtd->writesize + mtd->oobsize);
+
+	if (ops->datbuf)
+		ops->retlen = goldfish_nand_cmd(mtd, NAND_CMD_WRITE, ofs,
+						ops->len, ops->datbuf);
+	ofs += mtd->writesize + ops->ooboffs;
+	if (ops->oobbuf)
+		ops->oobretlen = goldfish_nand_cmd(mtd, NAND_CMD_WRITE, ofs,
+						ops->ooblen, ops->oobbuf);
+	return 0;
+
+invalid_arg:
+	pr_err("goldfish_nand_write_oob: invalid write, start %llx, len %x, ooblen %x, dev_size %llx, write_size %x\n",
+		ofs, ops->len, ops->ooblen, mtd->size, mtd->writesize);
+	return -EINVAL;
+}
+
+static int goldfish_nand_read(struct mtd_info *mtd, loff_t from, size_t len,
+				size_t *retlen, u_char *buf)
+{
+	u32 rem;
+
+	if (from + len > mtd->size)
+		goto invalid_arg;
+	if (len != mtd->writesize)
+		goto invalid_arg;
+
+	rem = do_div(from, mtd->writesize);
+	if (rem)
+		goto invalid_arg;
+	from *= (mtd->writesize + mtd->oobsize);
+
+	*retlen = goldfish_nand_cmd(mtd, NAND_CMD_READ, from, len, buf);
+	return 0;
+
+invalid_arg:
+	pr_err("goldfish_nand_read: invalid read, start %llx, len %x, dev_size %llx, write_size %x\n",
+		from, len, mtd->size, mtd->writesize);
+	return -EINVAL;
+}
+
+static int goldfish_nand_write(struct mtd_info *mtd, loff_t to, size_t len,
+				size_t *retlen, const u_char *buf)
+{
+	u32 rem;
+
+	if (to + len > mtd->size)
+		goto invalid_arg;
+	if (len != mtd->writesize)
+		goto invalid_arg;
+
+	rem = do_div(to, mtd->writesize);
+	if (rem)
+		goto invalid_arg;
+	to *= (mtd->writesize + mtd->oobsize);
+
+	*retlen = goldfish_nand_cmd(mtd, NAND_CMD_WRITE, to, len, (void *)buf);
+	return 0;
+
+invalid_arg:
+	pr_err("goldfish_nand_write: invalid write, start %llx, len %x, dev_size %llx, write_size %x\n",
+		to, len, mtd->size, mtd->writesize);
+	return -EINVAL;
+}
+
+static int goldfish_nand_block_isbad(struct mtd_info *mtd, loff_t ofs)
+{
+	u32 rem;
+
+	if (ofs >= mtd->size)
+		goto invalid_arg;
+
+	rem = do_div(ofs, mtd->erasesize);
+	if (rem)
+		goto invalid_arg;
+	ofs *= mtd->erasesize / mtd->writesize;
+	ofs *= (mtd->writesize + mtd->oobsize);
+
+	return goldfish_nand_cmd(mtd, NAND_CMD_BLOCK_BAD_GET, ofs, 0, NULL);
+
+invalid_arg:
+	pr_err("goldfish_nand_block_isbad: invalid arg, ofs %llx, dev_size %llx, write_size %x\n",
+		ofs, mtd->size, mtd->writesize);
+	return -EINVAL;
+}
+
+static int goldfish_nand_block_markbad(struct mtd_info *mtd, loff_t ofs)
+{
+	u32 rem;
+
+	if (ofs >= mtd->size)
+		goto invalid_arg;
+
+	rem = do_div(ofs, mtd->erasesize);
+	if (rem)
+		goto invalid_arg;
+	ofs *= mtd->erasesize / mtd->writesize;
+	ofs *= (mtd->writesize + mtd->oobsize);
+
+	if (goldfish_nand_cmd(mtd, NAND_CMD_BLOCK_BAD_SET, ofs, 0, NULL) != 1)
+		return -EIO;
+	return 0;
+
+invalid_arg:
+	pr_err("goldfish_nand_block_markbad: invalid arg, ofs %llx, dev_size %llx, write_size %x\n",
+		ofs, mtd->size, mtd->writesize);
+	return -EINVAL;
+}
+
+static int nand_setup_cmd_params(struct goldfish_nand *nand)
+{
+	u64 paddr;
+	unsigned char __iomem  *base = nand->base;
+
+	nand->cmd_params = kmalloc(sizeof(struct cmd_params), GFP_KERNEL);
+	if (!nand->cmd_params)
+		return -1;
+
+	paddr = __pa(nand->cmd_params);
+	writel((u32)(paddr >> 32), base + NAND_CMD_PARAMS_ADDR_HIGH);
+	writel((u32)paddr, base + NAND_CMD_PARAMS_ADDR_LOW);
+	return 0;
+}
+
+static int goldfish_nand_init_device(struct goldfish_nand *nand, int id)
+{
+	u32 name_len;
+	u32 result;
+	u32 flags;
+	unsigned long irq_flags;
+	unsigned char __iomem  *base = nand->base;
+	struct mtd_info *mtd = &nand->mtd[id];
+	char *name;
+
+	spin_lock_irqsave(&nand->lock, irq_flags);
+	writel(id, base + NAND_DEV);
+	flags = readl(base + NAND_DEV_FLAGS);
+	name_len = readl(base + NAND_DEV_NAME_LEN);
+	mtd->writesize = readl(base + NAND_DEV_PAGE_SIZE);
+	mtd->size = readl(base + NAND_DEV_SIZE_LOW);
+	mtd->size |= (u64)readl(base + NAND_DEV_SIZE_HIGH) << 32;
+	mtd->oobsize = readl(base + NAND_DEV_EXTRA_SIZE);
+	mtd->oobavail = mtd->oobsize;
+	mtd->erasesize = readl(base + NAND_DEV_ERASE_SIZE) /
+			(mtd->writesize + mtd->oobsize) * mtd->writesize;
+	do_div(mtd->size, mtd->writesize + mtd->oobsize);
+	mtd->size *= mtd->writesize;
+	pr_debug("goldfish nand dev%d: size %llx, page %d, extra %d, erase %d\n",
+	       id, mtd->size, mtd->writesize, mtd->oobsize, mtd->erasesize);
+	spin_unlock_irqrestore(&nand->lock, irq_flags);
+
+	mtd->priv = nand;
+
+	mtd->name = name = kmalloc(name_len + 1, GFP_KERNEL);
+	if (name == NULL)
+		return -ENOMEM;
+
+	result = goldfish_nand_cmd(mtd, NAND_CMD_GET_DEV_NAME, 0, name_len,
+									name);
+	if (result != name_len) {
+		kfree(mtd->name);
+		mtd->name = NULL;
+		pr_err("goldfish_nand_init_device failed to get dev name %d != %d\n",
+		       result, name_len);
+		return -ENODEV;
+	}
+	((char *) mtd->name)[name_len] = '\0';
+
+	/* Setup the MTD structure */
+	mtd->type = MTD_NANDFLASH;
+	mtd->flags = MTD_CAP_NANDFLASH;
+	if (flags & NAND_DEV_FLAG_READ_ONLY)
+		mtd->flags &= ~MTD_WRITEABLE;
+	if (flags & NAND_DEV_FLAG_CMD_PARAMS_CAP)
+		nand_setup_cmd_params(nand);
+
+	mtd->owner = THIS_MODULE;
+	mtd->_erase = goldfish_nand_erase;
+	mtd->_read = goldfish_nand_read;
+	mtd->_write = goldfish_nand_write;
+	mtd->_read_oob = goldfish_nand_read_oob;
+	mtd->_write_oob = goldfish_nand_write_oob;
+	mtd->_block_isbad = goldfish_nand_block_isbad;
+	mtd->_block_markbad = goldfish_nand_block_markbad;
+
+	if (mtd_device_register(mtd, NULL, 0)) {
+		kfree(mtd->name);
+		mtd->name = NULL;
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int goldfish_nand_probe(struct platform_device *pdev)
+{
+	u32 num_dev;
+	int i;
+	int err;
+	u32 num_dev_working;
+	u32 version;
+	struct resource *r;
+	struct goldfish_nand *nand;
+	unsigned char __iomem  *base;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		err = -ENODEV;
+		goto err_no_io_base;
+	}
+
+	base = ioremap(r->start, PAGE_SIZE);
+	if (base == NULL) {
+		err = -ENOMEM;
+		goto err_ioremap;
+	}
+	version = readl(base + NAND_VERSION);
+	if (version != NAND_VERSION_CURRENT) {
+		pr_err("goldfish_nand_init: version mismatch, got %d, expected %d\n",
+			version, NAND_VERSION_CURRENT);
+		err = -ENODEV;
+		goto err_no_dev;
+	}
+	num_dev = readl(base + NAND_NUM_DEV);
+	if (num_dev == 0) {
+		err = -ENODEV;
+		goto err_no_dev;
+	}
+
+	nand = kzalloc(sizeof(*nand) + sizeof(struct mtd_info) * num_dev,
+								GFP_KERNEL);
+	if (nand == NULL) {
+		err = -ENOMEM;
+		goto err_nand_alloc_failed;
+	}
+	spin_lock_init(&nand->lock);
+	nand->base = base;
+	nand->mtd_count = num_dev;
+	platform_set_drvdata(pdev, nand);
+
+	num_dev_working = 0;
+	for (i = 0; i < num_dev; i++) {
+		err = goldfish_nand_init_device(nand, i);
+		if (err == 0)
+			num_dev_working++;
+	}
+	if (num_dev_working == 0) {
+		err = -ENODEV;
+		goto err_no_working_dev;
+	}
+	return 0;
+
+err_no_working_dev:
+	kfree(nand);
+err_nand_alloc_failed:
+err_no_dev:
+	iounmap(base);
+err_ioremap:
+err_no_io_base:
+	return err;
+}
+
+static int goldfish_nand_remove(struct platform_device *pdev)
+{
+	struct goldfish_nand *nand = platform_get_drvdata(pdev);
+	int i;
+	for (i = 0; i < nand->mtd_count; i++) {
+		if (nand->mtd[i].name) {
+			mtd_device_unregister(&nand->mtd[i]);
+			kfree(nand->mtd[i].name);
+		}
+	}
+	kfree(nand->cmd_params);
+	iounmap(nand->base);
+	kfree(nand);
+	return 0;
+}
+
+static struct platform_driver goldfish_nand_driver = {
+	.probe		= goldfish_nand_probe,
+	.remove		= goldfish_nand_remove,
+	.driver = {
+		.name = "goldfish_nand"
+	}
+};
+
+static int __init goldfish_nand_init(void)
+{
+	return platform_driver_register(&goldfish_nand_driver);
+}
+
+static void __exit goldfish_nand_exit(void)
+{
+	platform_driver_unregister(&goldfish_nand_driver);
+}
+
+
+module_init(goldfish_nand_init);
+module_exit(goldfish_nand_exit);
diff --git a/drivers/mtd/devices/goldfish_nand_reg.h b/drivers/mtd/devices/goldfish_nand_reg.h
new file mode 100644
index 0000000..956c6c3
--- /dev/null
+++ b/drivers/mtd/devices/goldfish_nand_reg.h
@@ -0,0 +1,72 @@
+/* drivers/mtd/devices/goldfish_nand_reg.h
+**
+** Copyright (C) 2007 Google, Inc.
+**
+** This software is licensed under the terms of the GNU General Public
+** License version 2, as published by the Free Software Foundation, and
+** may be copied, distributed, and modified under those terms.
+**
+** This program is distributed in the hope that it will be useful,
+** but WITHOUT ANY WARRANTY; without even the implied warranty of
+** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+** GNU General Public License for more details.
+**
+*/
+
+#ifndef GOLDFISH_NAND_REG_H
+#define GOLDFISH_NAND_REG_H
+
+enum nand_cmd {
+	NAND_CMD_GET_DEV_NAME,  /* Write device name for NAND_DEV to NAND_DATA (vaddr) */
+	NAND_CMD_READ,
+	NAND_CMD_WRITE,
+	NAND_CMD_ERASE,
+	NAND_CMD_BLOCK_BAD_GET, /* NAND_RESULT is 1 if block is bad, 0 if it is not */
+	NAND_CMD_BLOCK_BAD_SET,
+	NAND_CMD_READ_WITH_PARAMS,
+	NAND_CMD_WRITE_WITH_PARAMS,
+	NAND_CMD_ERASE_WITH_PARAMS
+};
+
+enum nand_dev_flags {
+	NAND_DEV_FLAG_READ_ONLY = 0x00000001,
+	NAND_DEV_FLAG_CMD_PARAMS_CAP = 0x00000002,
+};
+
+#define NAND_VERSION_CURRENT (1)
+
+enum nand_reg {
+	/* Global */
+	NAND_VERSION        = 0x000,
+	NAND_NUM_DEV        = 0x004,
+	NAND_DEV            = 0x008,
+
+	/* Dev info */
+	NAND_DEV_FLAGS      = 0x010,
+	NAND_DEV_NAME_LEN   = 0x014,
+	NAND_DEV_PAGE_SIZE  = 0x018,
+	NAND_DEV_EXTRA_SIZE = 0x01c,
+	NAND_DEV_ERASE_SIZE = 0x020,
+	NAND_DEV_SIZE_LOW   = 0x028,
+	NAND_DEV_SIZE_HIGH  = 0x02c,
+
+	/* Command */
+	NAND_RESULT         = 0x040,
+	NAND_COMMAND        = 0x044,
+	NAND_DATA           = 0x048,
+	NAND_TRANSFER_SIZE  = 0x04c,
+	NAND_ADDR_LOW       = 0x050,
+	NAND_ADDR_HIGH      = 0x054,
+	NAND_CMD_PARAMS_ADDR_LOW = 0x058,
+	NAND_CMD_PARAMS_ADDR_HIGH = 0x05c,
+};
+
+struct cmd_params {
+	uint32_t dev;
+	uint32_t addr_low;
+	uint32_t addr_high;
+	uint32_t transfer_size;
+	uint32_t data;
+	uint32_t result;
+};
+#endif

