Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1CJEpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 23:45:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43918 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1CJEom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 23:44:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6280"; a="79075808"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 2/3] msm: Peripheral Image Loader (PIL) driver
Date: Wed,  9 Mar 2011 20:44:33 -0800
Message-Id: <1299732274-10742-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.203.g07873
In-Reply-To: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
References: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8660, the modem, dsp, and sensors peripherals require their
firmware to be loaded into memory before they can be properly
taken out of reset.

Drivers are expected to call pil_get() when they wish to load a
peripheral. This will initiate multiple firmware_request()s for
the metadata and image blobs for a peripheral. Once the image has
been loaded into memory, it is validated and brought out of reset
via the peripheral reset driver.

When drivers have completed using the peripheral they are
expected to call pil_put(). This decrements a reference count on
the peripheral and shuts down the device if it is no longer in
use.

This driver also exposes a debugfs interface. The top level
directory 'pil' contains a set of files (one file for each pil
device). Writing 'get' to a file will call pil_get() with the
device name. Writing 'put' to a file will call pil_put() with the
device. Reading the file will return the reference count for
the device.

The layout looks like this:

	- pil
	|- dsps
	|- q6
	|- modem

Change-Id: I041139464bbd3b646b82370ab540f40b0ac9af6b
Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig                          |   13 +
 arch/arm/mach-msm/Makefile                         |    2 +
 arch/arm/mach-msm/include/mach/peripheral-loader.h |   23 +
 arch/arm/mach-msm/peripheral-loader.c              |  402 +++++++++++++++
 arch/arm/mach-msm/peripheral-loader.h              |   38 ++
 arch/arm/mach-msm/peripheral-reset.c               |  528 ++++++++++++++++++++
 6 files changed, 1006 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/peripheral-loader.h
 create mode 100644 arch/arm/mach-msm/peripheral-loader.c
 create mode 100644 arch/arm/mach-msm/peripheral-loader.h
 create mode 100644 arch/arm/mach-msm/peripheral-reset.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 997c5bd..25b73b0 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -210,4 +210,17 @@ config IOMMU_API
 
 config MSM_SCM
 	bool
+
+config MSM_PIL
+	bool "Peripheral image loading (PIL)"
+	select FW_LOADER
+	select MSM_SCM
+	depends on ARCH_MSM8X60
+	help
+	  Some peripherals need to be loaded into memory before they can be
+	  brought out of reset.
+
+	  Say yes to support these devices.
+
+
 endif
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 86acfa3..cd5aa34 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -38,3 +38,5 @@ endif
 else
 obj-y	+= gpio.o
 endif
+
+obj-$(CONFIG_MSM_PIL) += peripheral-loader.o peripheral-reset.o
diff --git a/arch/arm/mach-msm/include/mach/peripheral-loader.h b/arch/arm/mach-msm/include/mach/peripheral-loader.h
new file mode 100644
index 0000000..a1e5ceb
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/peripheral-loader.h
@@ -0,0 +1,23 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __MACH_PERIPHERAL_LOADER_H
+#define __MACH_PERIPHERAL_LOADER_H
+
+#ifdef CONFIG_MSM_PIL
+extern void *pil_get(const char *name);
+extern void pil_put(void *peripheral_handle);
+#else
+static inline void *pil_get(const char *name) { return NULL; }
+static inline void pil_put(void *peripheral_handle) { }
+#endif
+
+#endif
diff --git a/arch/arm/mach-msm/peripheral-loader.c b/arch/arm/mach-msm/peripheral-loader.c
new file mode 100644
index 0000000..0253106
--- /dev/null
+++ b/arch/arm/mach-msm/peripheral-loader.c
@@ -0,0 +1,402 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/firmware.h>
+#include <linux/io.h>
+#include <linux/debugfs.h>
+#include <linux/elf.h>
+#include <linux/mutex.h>
+#include <linux/memblock.h>
+
+#include <asm/uaccess.h>
+#include <asm/setup.h>
+
+#include "peripheral-loader.h"
+
+static DEFINE_MUTEX(pil_list_lock);
+static LIST_HEAD(pil_list);
+
+static struct pil_device *__find_peripheral(const char *str)
+{
+	struct pil_device *dev;
+
+	list_for_each_entry(dev, &pil_list, list)
+		if (!strcmp(dev->name, str))
+			return dev;
+	return NULL;
+}
+
+static struct pil_device *find_peripheral(const char *str)
+{
+	struct pil_device *dev;
+
+	if (!str)
+		return NULL;
+
+	mutex_lock(&pil_list_lock);
+	dev = __find_peripheral(str);
+	mutex_unlock(&pil_list_lock);
+
+	return dev;
+}
+
+#define IOMAP_SIZE SZ_4M
+
+static int load_segment(const struct elf32_phdr *phdr, unsigned num,
+		struct pil_device *pil)
+{
+	int ret, count, paddr;
+	char fw_name[30];
+	const struct firmware *fw = NULL;
+	const u8 *data;
+
+	if (memblock_is_region_memory(phdr->p_paddr, phdr->p_memsz)) {
+		dev_err(&pil->pdev.dev, "Kernel memory would be overwritten\n");
+		return -EPERM;
+	}
+
+	if (phdr->p_filesz) {
+		snprintf(fw_name, ARRAY_SIZE(fw_name), "%s.b%02d", pil->name,
+				num);
+		ret = request_firmware(&fw, fw_name, &pil->pdev.dev);
+		if (ret) {
+			dev_err(&pil->pdev.dev, "Failed to locate blob %s\n",
+					fw_name);
+			return ret;
+		}
+
+		if (fw->size != phdr->p_filesz) {
+			dev_err(&pil->pdev.dev,
+					"Blob size %u doesn't match %u\n",
+					fw->size, phdr->p_filesz);
+			ret = -EPERM;
+			goto release_fw;
+		}
+	}
+
+	/* Load the segment into memory */
+	count = phdr->p_filesz;
+	paddr = phdr->p_paddr;
+	data = fw ? fw->data : NULL;
+	while (count > 0) {
+		int size;
+		u8 __iomem *buf;
+
+		size = min_t(size_t, IOMAP_SIZE, count);
+		buf = ioremap(paddr, size);
+		if (!buf) {
+			dev_err(&pil->pdev.dev, "Failed to map memory\n");
+			ret = -ENOMEM;
+			goto release_fw;
+		}
+		memcpy(buf, data, size);
+		iounmap(buf);
+
+		count -= size;
+		paddr += size;
+		data += size;
+	}
+
+	/* Zero out trailing memory */
+	count = phdr->p_memsz - phdr->p_filesz;
+	while (count > 0) {
+		int size;
+		u8 __iomem *buf;
+
+		size = min_t(size_t, IOMAP_SIZE, count);
+		buf = ioremap(paddr, size);
+		if (!buf) {
+			dev_err(&pil->pdev.dev, "Failed to map memory\n");
+			ret = -ENOMEM;
+			goto release_fw;
+		}
+		memset(buf, 0, size);
+		iounmap(buf);
+
+		count -= size;
+		paddr += size;
+	}
+
+	ret = pil->ops->verify_blob(phdr->p_paddr, phdr->p_memsz);
+	if (ret)
+		dev_err(&pil->pdev.dev, "Blob %u failed verification\n", num);
+
+release_fw:
+	release_firmware(fw);
+	return ret;
+}
+
+#define segment_is_hash(flag) (((flag) & (0x7 << 24)) == (0x2 << 24))
+
+static int segment_is_loadable(const struct elf32_phdr *p)
+{
+	return (p->p_type & PT_LOAD) && !segment_is_hash(p->p_flags);
+}
+
+static int load_image(struct pil_device *pil)
+{
+	int i, ret;
+	char fw_name[30];
+	struct elf32_hdr *ehdr;
+	const struct elf32_phdr *phdr;
+	const struct firmware *fw;
+
+	snprintf(fw_name, sizeof(fw_name), "%s.mdt", pil->name);
+	ret = request_firmware(&fw, fw_name, &pil->pdev.dev);
+	if (ret) {
+		dev_err(&pil->pdev.dev, "Failed to locate %s\n", fw_name);
+		goto out;
+	}
+
+	if (fw->size < sizeof(*ehdr)) {
+		dev_err(&pil->pdev.dev, "Not big enough to be an elf header\n");
+		ret = -EIO;
+		goto release_fw;
+	}
+
+	ehdr = (struct elf32_hdr *)fw->data;
+	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG)) {
+		dev_err(&pil->pdev.dev, "Not an elf header\n");
+		ret = -EIO;
+		goto release_fw;
+	}
+
+	if (ehdr->e_phnum == 0) {
+		dev_err(&pil->pdev.dev, "No loadable segments\n");
+		ret = -EIO;
+		goto release_fw;
+	}
+	if (ehdr->e_phoff > fw->size) {
+		dev_err(&pil->pdev.dev, "Program header beyond size of mdt\n");
+		ret = -EIO;
+		goto release_fw;
+	}
+
+	ret = pil->ops->init_image(fw->data, fw->size);
+	if (ret) {
+		dev_err(&pil->pdev.dev, "Invalid firmware metadata\n");
+		goto release_fw;
+	}
+
+	phdr = (const struct elf32_phdr *)(fw->data + ehdr->e_phoff);
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		if (!segment_is_loadable(phdr))
+			continue;
+
+		ret = load_segment(phdr, i, pil);
+		if (ret) {
+			dev_err(&pil->pdev.dev, "Failed to load segment %d\n",
+					i);
+			goto release_fw;
+		}
+	}
+
+	ret = pil->ops->auth_and_reset();
+	if (ret) {
+		dev_err(&pil->pdev.dev, "Failed to bring out of reset\n");
+		goto release_fw;
+	}
+
+release_fw:
+	release_firmware(fw);
+out:
+	return ret;
+}
+
+/**
+ * pil_get() - Load a peripheral into memory and take it out of reset
+ * @name: pointer to a string containing the name of the peripheral to load
+ *
+ * This function returns a pointer if it succeeds. If an error occurs an
+ * ERR_PTR is returned.
+ *
+ * If PIL is not enabled in the kernel, the value %NULL will be returned.
+ */
+void *pil_get(const char *name)
+{
+	int ret;
+	struct pil_device *pil;
+	struct pil_device *pil_d;
+	void *retval;
+
+	pil = retval = find_peripheral(name);
+	if (!pil)
+		return ERR_PTR(-ENODEV);
+
+	pil_d = find_peripheral(pil->depends_on);
+	if (pil_d) {
+		void *p = pil_get(pil_d->name);
+		if (IS_ERR(p))
+			return p;
+	}
+
+	mutex_lock(&pil->lock);
+	if (pil->count) {
+		pil->count++;
+		goto unlock;
+	}
+
+	ret = load_image(pil);
+	if (ret) {
+		retval = ERR_PTR(ret);
+		goto unlock;
+	}
+
+	pil->count++;
+unlock:
+	mutex_unlock(&pil->lock);
+	return retval;
+}
+EXPORT_SYMBOL(pil_get);
+
+/**
+ * pil_put() - Inform PIL the peripheral no longer needs to be active
+ * @peripheral_handle: pointer from a previous call to pil_get()
+ *
+ * This doesn't imply that a peripheral is shutdown or in reset since another
+ * driver could be using the peripheral.
+ */
+void pil_put(void *peripheral_handle)
+{
+	struct pil_device *pil_d;
+	struct pil_device *pil = peripheral_handle;
+	if (!pil || IS_ERR(pil)) {
+		WARN(1, "Invalid peripheral handle\n");
+		return;
+	}
+
+	mutex_lock(&pil->lock);
+	WARN(!pil->count, "%s: Reference count mismatch\n", __func__);
+	if (pil->count)
+		pil->count--;
+	if (pil->count == 0)
+		pil->ops->shutdown();
+	mutex_unlock(&pil->lock);
+
+	pil_d = find_peripheral(pil->depends_on);
+	if (pil_d)
+		pil_put(pil_d);
+}
+EXPORT_SYMBOL(pil_put);
+
+#ifdef CONFIG_DEBUG_FS
+int msm_pil_debugfs_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t msm_pil_debugfs_read(struct file *filp, char __user *ubuf,
+		size_t cnt, loff_t *ppos)
+{
+	int r;
+	char buf[40];
+	struct pil_device *pil = filp->private_data;
+
+	mutex_lock(&pil->lock);
+	r = snprintf(buf, sizeof(buf), "%d\n", pil->count);
+	mutex_unlock(&pil->lock);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t msm_pil_debugfs_write(struct file *filp,
+		const char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct pil_device *pil = filp->private_data;
+	char buf[4];
+
+	if (cnt > sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	if (!strncmp(buf, "get", 3)) {
+		if (IS_ERR(pil_get(pil->name)))
+			return -EIO;
+	} else if (!strncmp(buf, "put", 3))
+		pil_put(pil);
+	else
+		return -EINVAL;
+
+	return cnt;
+}
+
+static const struct file_operations msm_pil_debugfs_fops = {
+	.open	= msm_pil_debugfs_open,
+	.read	= msm_pil_debugfs_read,
+	.write	= msm_pil_debugfs_write,
+};
+
+static struct dentry *pil_base_dir;
+
+static int msm_pil_debugfs_init(void)
+{
+	pil_base_dir = debugfs_create_dir("pil", NULL);
+	if (!pil_base_dir) {
+		pil_base_dir = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+arch_initcall(msm_pil_debugfs_init);
+
+static int msm_pil_debugfs_add(struct pil_device *pil)
+{
+	if (!pil_base_dir)
+		return -ENOMEM;
+
+	if (!debugfs_create_file(pil->name, S_IRUGO | S_IWUSR, pil_base_dir,
+				pil, &msm_pil_debugfs_fops))
+		return -ENOMEM;
+	return 0;
+}
+#else
+static int msm_pil_debugfs_add(struct pil_device *pil) { return 0; }
+#endif
+
+static int msm_pil_shutdown_at_boot(void)
+{
+	struct pil_device *pil;
+
+	mutex_lock(&pil_list_lock);
+	list_for_each_entry(pil, &pil_list, list)
+		pil->ops->shutdown();
+	mutex_unlock(&pil_list_lock);
+
+	return 0;
+}
+late_initcall(msm_pil_shutdown_at_boot);
+
+int msm_pil_add_device(struct pil_device *pil)
+{
+	int ret;
+	ret = platform_device_register(&pil->pdev);
+	if (ret)
+		return ret;
+
+	mutex_init(&pil->lock);
+
+	mutex_lock(&pil_list_lock);
+	list_add(&pil->list, &pil_list);
+	mutex_unlock(&pil_list_lock);
+
+	msm_pil_debugfs_add(pil);
+	return 0;
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Load peripheral images and bring peripherals out of reset");
diff --git a/arch/arm/mach-msm/peripheral-loader.h b/arch/arm/mach-msm/peripheral-loader.h
new file mode 100644
index 0000000..139749f
--- /dev/null
+++ b/arch/arm/mach-msm/peripheral-loader.h
@@ -0,0 +1,38 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __MACH_PERIPHERAL_LOADER_H
+#define __MACH_PERIPHERAL_LOADER_H
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+
+struct pil_reset_ops {
+	int (*init_image)(const u8 *metadata, size_t size);
+	int (*verify_blob)(u32 phy_addr, size_t size);
+	int (*auth_and_reset)(void);
+	int (*shutdown)(void);
+};
+
+struct pil_device {
+	const char *name;
+	const char *depends_on;
+	int count;
+	struct mutex lock;
+	struct platform_device pdev;
+	struct list_head list;
+	struct pil_reset_ops *ops;
+};
+
+extern int msm_pil_add_device(struct pil_device *pil);
+
+#endif
diff --git a/arch/arm/mach-msm/peripheral-reset.c b/arch/arm/mach-msm/peripheral-reset.c
new file mode 100644
index 0000000..650f40c
--- /dev/null
+++ b/arch/arm/mach-msm/peripheral-reset.c
@@ -0,0 +1,528 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/elf.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <mach/msm_iomap.h>
+
+#include "peripheral-loader.h"
+#include "scm.h"
+
+#define MSM_MMS_REGS_BASE		0x10200000
+#define MSM_LPASS_QDSP6SS_BASE		0x28800000
+
+#define MARM_RESET			(MSM_CLK_CTL_BASE + 0x2BD4)
+#define MARM_BOOT_CONTROL		(msm_mms_regs_base + 0x0010)
+#define MAHB0_SFAB_PORT_RESET		(MSM_CLK_CTL_BASE + 0x2304)
+#define MARM_CLK_BRANCH_ENA_VOTE	(MSM_CLK_CTL_BASE + 0x3000)
+#define MARM_CLK_SRC0_NS		(MSM_CLK_CTL_BASE + 0x2BC0)
+#define MARM_CLK_SRC1_NS		(MSM_CLK_CTL_BASE + 0x2BC4)
+#define MARM_CLK_SRC_CTL		(MSM_CLK_CTL_BASE + 0x2BC8)
+#define MARM_CLK_CTL			(MSM_CLK_CTL_BASE + 0x2BCC)
+#define SFAB_MSS_S_HCLK_CTL		(MSM_CLK_CTL_BASE + 0x2C00)
+#define MSS_MODEM_CXO_CLK_CTL		(MSM_CLK_CTL_BASE + 0x2C44)
+#define MSS_SLP_CLK_CTL			(MSM_CLK_CTL_BASE + 0x2C60)
+#define MSS_MARM_SYS_REF_CLK_CTL	(MSM_CLK_CTL_BASE + 0x2C64)
+#define MAHB0_CLK_CTL			(MSM_CLK_CTL_BASE + 0x2300)
+#define MAHB1_CLK_CTL			(MSM_CLK_CTL_BASE + 0x2BE4)
+#define MAHB2_CLK_CTL			(MSM_CLK_CTL_BASE + 0x2C20)
+#define MAHB1_NS			(MSM_CLK_CTL_BASE + 0x2BE0)
+#define MARM_CLK_FS			(MSM_CLK_CTL_BASE + 0x2BD0)
+#define MAHB2_CLK_FS			(MSM_CLK_CTL_BASE + 0x2C24)
+#define PLL_ENA_MARM			(MSM_CLK_CTL_BASE + 0x3500)
+
+#define LCC_Q6_FUNC			(MSM_LPASS_CLK_CTL_BASE + 0x001C)
+#define QDSP6SS_RST_EVB			(msm_lpass_qdsp6ss_base + 0x0000)
+#define QDSP6SS_STRAP_TCM		(msm_lpass_qdsp6ss_base + 0x001C)
+#define QDSP6SS_STRAP_AHB		(msm_lpass_qdsp6ss_base + 0x0020)
+
+#define PPSS_RESET			(MSM_CLK_CTL_BASE + 0x2594)
+
+#define PAS_MODEM	0
+#define PAS_Q6		1
+#define PAS_DSPS	2
+
+#define PAS_INIT_IMAGE_CMD	1
+#define PAS_MEM_CMD		2
+#define PAS_AUTH_AND_RESET_CMD	5
+#define PAS_SHUTDOWN_CMD	6
+
+struct pas_init_image_req {
+	u32	proc;
+	u32	image_addr;
+};
+
+struct pas_init_image_resp {
+	u32	image_valid;
+};
+
+struct pas_auth_image_req {
+	u32	proc;
+};
+
+struct pas_auth_image_resp {
+	u32	reset_initiated;
+};
+
+struct pas_shutdown_req {
+	u32	proc;
+};
+
+struct pas_shutdown_resp {
+	u32	success;
+};
+
+static int modem_start, q6_start, dsps_start;
+static void __iomem *msm_mms_regs_base;
+static void __iomem *msm_lpass_qdsp6ss_base;
+
+static int init_image_trusted(int id, const u8 *metadata, size_t size)
+{
+	int ret;
+	struct pas_init_image_req request;
+	struct pas_init_image_resp resp = {0};
+	void *mdata_buf;
+
+	/* Make memory physically contiguous */
+	mdata_buf = kmemdup(metadata, size, GFP_KERNEL);
+	if (!mdata_buf)
+		return -ENOMEM;
+
+	request.proc = id;
+	request.image_addr = virt_to_phys(mdata_buf);
+
+	ret = scm_call(SCM_SVC_PIL, PAS_INIT_IMAGE_CMD, &request,
+			sizeof(request), &resp, sizeof(resp));
+	kfree(mdata_buf);
+
+	if (ret)
+		return ret;
+	return resp.image_valid;
+}
+
+static int init_image_modem_trusted(const u8 *metadata, size_t size)
+{
+	return init_image_trusted(PAS_MODEM, metadata, size);
+}
+
+static int init_image_modem_untrusted(const u8 *metadata, size_t size)
+{
+	struct elf32_hdr *ehdr = (struct elf32_hdr *)metadata;
+	modem_start = ehdr->e_entry;
+	return 0;
+}
+
+static int init_image_q6_trusted(const u8 *metadata, size_t size)
+{
+	return init_image_trusted(PAS_Q6, metadata, size);
+}
+
+static int init_image_q6_untrusted(const u8 *metadata, size_t size)
+{
+	struct elf32_hdr *ehdr = (struct elf32_hdr *)metadata;
+	q6_start = ehdr->e_entry;
+	return 0;
+}
+
+static int init_image_dsps_trusted(const u8 *metadata, size_t size)
+{
+	return init_image_trusted(PAS_DSPS, metadata, size);
+}
+
+static int init_image_dsps_untrusted(const u8 *metadata, size_t size)
+{
+	struct elf32_hdr *ehdr = (struct elf32_hdr *)metadata;
+	dsps_start = ehdr->e_entry;
+	return 0;
+}
+
+static int verify_blob(u32 phy_addr, size_t size)
+{
+	return 0;
+}
+
+static int auth_and_reset_trusted(int id)
+{
+	int ret;
+	struct pas_auth_image_req request;
+	struct pas_auth_image_resp resp = {0};
+
+	request.proc = id;
+	ret = scm_call(SCM_SVC_PIL, PAS_AUTH_AND_RESET_CMD, &request,
+			sizeof(request), &resp, sizeof(resp));
+	if (ret)
+		return ret;
+
+	return resp.reset_initiated;
+}
+
+static int reset_modem_untrusted(void)
+{
+	u32 reg;
+
+	/* Put modem AHB0,1,2 clocks into reset */
+	writel(BIT(0) | BIT(1), MAHB0_SFAB_PORT_RESET);
+	writel(BIT(7), MAHB1_CLK_CTL);
+	writel(BIT(7), MAHB2_CLK_CTL);
+
+	/* Vote for pll8 on behalf of the modem */
+	reg = readl(PLL_ENA_MARM);
+	reg |= BIT(8);
+	writel(reg, PLL_ENA_MARM);
+
+	/* Set MAHB1 divider to Div-5 to run MAHB1,2 and sfab at 79.8 Mhz*/
+	writel(0x4, MAHB1_NS);
+
+	/* Vote for modem AHB1 and 2 clocks to be on on behalf of the modem */
+	reg = readl(MARM_CLK_BRANCH_ENA_VOTE);
+	reg |= BIT(0) | BIT(1);
+	writel(reg, MARM_CLK_BRANCH_ENA_VOTE);
+
+	/* Source marm_clk off of PLL8 */
+	reg = readl(MARM_CLK_SRC_CTL);
+	if ((reg & 0x1) == 0) {
+		writel(0x3, MARM_CLK_SRC1_NS);
+		reg |= 0x1;
+	} else {
+		writel(0x3, MARM_CLK_SRC0_NS);
+		reg &= ~0x1;
+	}
+	writel(reg | 0x2, MARM_CLK_SRC_CTL);
+
+	/*
+	 * Force core on and periph on signals to remain active during halt
+	 * for marm_clk and mahb2_clk
+	 */
+	writel(0x6F, MARM_CLK_FS);
+	writel(0x6F, MAHB2_CLK_FS);
+
+	/*
+	 * Enable all of the marm_clk branches, cxo sourced marm branches,
+	 * and sleep clock branches
+	 */
+	writel(0x10, MARM_CLK_CTL);
+	writel(0x10, MAHB0_CLK_CTL);
+	writel(0x10, SFAB_MSS_S_HCLK_CTL);
+	writel(0x10, MSS_MODEM_CXO_CLK_CTL);
+	writel(0x10, MSS_SLP_CLK_CTL);
+	writel(0x10, MSS_MARM_SYS_REF_CLK_CTL);
+
+	/* Take MAHB0,1,2 clocks out of reset */
+	writel(0x0, MAHB2_CLK_CTL);
+	writel(0x0, MAHB1_CLK_CTL);
+	writel(0x0, MAHB0_SFAB_PORT_RESET);
+
+	/* Wait for above clocks to be turned on */
+	mb();
+	/* Setup exception vector table base address */
+	writel(modem_start | 0x1, MARM_BOOT_CONTROL);
+
+	/* Wait for vector table to be setup */
+	mb();
+
+	/* Bring modem out of reset */
+	writel(0x0, MARM_RESET);
+
+	return 0;
+}
+
+static int reset_modem_trusted(void)
+{
+	return auth_and_reset_trusted(PAS_MODEM);
+}
+
+static int shutdown_trusted(int id)
+{
+	int ret;
+	struct pas_shutdown_req request;
+	struct pas_shutdown_resp resp = {0};
+
+	request.proc = id;
+	ret = scm_call(SCM_SVC_PIL, PAS_SHUTDOWN_CMD, &request, sizeof(request),
+			&resp, sizeof(resp));
+	if (ret)
+		return ret;
+
+	return resp.success;
+}
+
+static int shutdown_modem_untrusted(void)
+{
+	u32 reg;
+
+	/* Put modem into reset */
+	writel(0x1, MARM_RESET);
+
+	/* Put modem AHB0,1,2 clocks into reset */
+	writel(BIT(0) | BIT(1), MAHB0_SFAB_PORT_RESET);
+	writel(BIT(7), MAHB1_CLK_CTL);
+	writel(BIT(7), MAHB2_CLK_CTL);
+
+	/*
+	 * Disable all of the marm_clk branches, cxo sourced marm branches,
+	 * and sleep clock branches
+	 */
+	writel(0x0, MARM_CLK_CTL);
+	writel(0x0, MAHB0_CLK_CTL);
+	writel(0x0, SFAB_MSS_S_HCLK_CTL);
+	writel(0x0, MSS_MODEM_CXO_CLK_CTL);
+	writel(0x0, MSS_SLP_CLK_CTL);
+	writel(0x0, MSS_MARM_SYS_REF_CLK_CTL);
+
+	/* Disable marm_clk */
+	reg = readl(MARM_CLK_SRC_CTL);
+	reg &= ~0x2;
+	writel(reg, MARM_CLK_SRC_CTL);
+
+	/* Clear modem's votes for ahb clocks */
+	writel(0x0, MARM_CLK_BRANCH_ENA_VOTE);
+
+	/* Clear modem's votes for PLLs */
+	writel(0x0, PLL_ENA_MARM);
+	return 0;
+}
+
+static int shutdown_modem_trusted(void)
+{
+	return shutdown_trusted(PAS_MODEM);
+}
+
+#define LV_EN			BIT(27)
+#define STOP_CORE		BIT(26)
+#define CLAMP_IO		BIT(25)
+#define Q6SS_PRIV_ARES		BIT(24)
+#define Q6SS_SS_ARES		BIT(23)
+#define Q6SS_ISDB_ARES		BIT(22)
+#define Q6SS_ETM_ARES		BIT(21)
+#define Q6_JTAG_CRC_EN		BIT(20)
+#define Q6_JTAG_INV_EN		BIT(19)
+#define Q6_JTAG_CXC_EN		BIT(18)
+#define Q6_PXO_CRC_EN		BIT(17)
+#define Q6_PXO_INV_EN		BIT(16)
+#define Q6_PXO_CXC_EN		BIT(15)
+#define Q6_PXO_SLEEP_EN		BIT(14)
+#define Q6_SLP_CRC_EN		BIT(13)
+#define Q6_SLP_INV_EN		BIT(12)
+#define Q6_SLP_CXC_EN		BIT(11)
+#define CORE_ARES		BIT(10)
+#define CORE_L1_MEM_CORE_EN	BIT(9)
+#define CORE_TCM_MEM_CORE_EN	BIT(8)
+#define CORE_TCM_MEM_PERPH_EN	BIT(7)
+#define CORE_GFM4_CLK_EN	BIT(2)
+#define CORE_GFM4_RES		BIT(1)
+#define RAMP_PLL_SRC_SEL	BIT(0)
+
+#define Q6_STRAP_AHB_UPPER	(0x290 << 12)
+#define Q6_STRAP_AHB_LOWER	0x280
+#define Q6_STRAP_TCM_BASE	(0x28C << 15)
+#define Q6_STRAP_TCM_CONFIG	0x28B
+
+static int reset_q6_untrusted(void)
+{
+	u32 reg;
+
+	/* TODO: Vote for pll 4 */
+
+	/* Put Q6 into reset */
+	reg = readl(LCC_Q6_FUNC);
+	reg |= Q6SS_SS_ARES | Q6SS_ISDB_ARES | Q6SS_ETM_ARES | STOP_CORE |
+		CORE_ARES;
+	reg &= ~CORE_GFM4_CLK_EN;
+	writel(reg, LCC_Q6_FUNC);
+
+	/* Wait 8 AHB cycles for Q6 to be fully reset (AHB = 1.5Mhz) */
+	usleep_range(20, 30);
+
+	/* Turn on Q6 memory */
+	reg |= CORE_GFM4_CLK_EN | CORE_L1_MEM_CORE_EN | CORE_TCM_MEM_CORE_EN |
+		CORE_TCM_MEM_PERPH_EN;
+	writel(reg, LCC_Q6_FUNC);
+
+	/* Turn on Q6 core clocks and take core out of reset */
+	reg &= ~(CLAMP_IO | Q6SS_SS_ARES | Q6SS_ISDB_ARES | Q6SS_ETM_ARES |
+			CORE_ARES);
+	writel(reg, LCC_Q6_FUNC);
+
+	/* Wait for clocks to be enabled */
+	mb();
+	/* Program boot address */
+	writel((q6_start >> 12) & 0xFFFFF, QDSP6SS_RST_EVB);
+
+	writel(Q6_STRAP_TCM_CONFIG | Q6_STRAP_TCM_BASE, QDSP6SS_STRAP_TCM);
+	writel(Q6_STRAP_AHB_UPPER | Q6_STRAP_AHB_LOWER, QDSP6SS_STRAP_AHB);
+
+	/* Wait for addresses to be programmed before starting Q6 */
+	mb();
+
+	/* Start Q6 instruction execution */
+	reg &= ~STOP_CORE;
+	writel(reg, LCC_Q6_FUNC);
+
+	return 0;
+}
+
+static int reset_q6_trusted(void)
+{
+	/* TODO: Vote for PLL4 */
+	return auth_and_reset_trusted(PAS_Q6);
+}
+
+static int shutdown_q6_untrusted(void)
+{
+	u32 reg;
+
+	reg = readl(LCC_Q6_FUNC);
+	/* Halt clocks and turn off memory */
+	reg &= ~(CORE_L1_MEM_CORE_EN | CORE_TCM_MEM_CORE_EN |
+		CORE_TCM_MEM_PERPH_EN);
+	reg |= CLAMP_IO | CORE_GFM4_CLK_EN;
+	writel(reg, LCC_Q6_FUNC);
+	return 0;
+}
+
+static int shutdown_q6_trusted(void)
+{
+	return shutdown_trusted(PAS_Q6);
+}
+
+static int reset_dsps_untrusted(void)
+{
+	/* Bring DSPS out of reset */
+	writel(0x0, PPSS_RESET);
+	return 0;
+}
+
+static int reset_dsps_trusted(void)
+{
+	return auth_and_reset_trusted(PAS_DSPS);
+}
+
+static int shutdown_dsps_trusted(void)
+{
+	return shutdown_trusted(PAS_DSPS);
+}
+
+static int shutdown_dsps_untrusted(void)
+{
+	writel(0x3, PPSS_RESET);
+	return 0;
+}
+
+struct pil_reset_ops pil_modem_ops = {
+	.init_image = init_image_modem_untrusted,
+	.verify_blob = verify_blob,
+	.auth_and_reset = reset_modem_untrusted,
+	.shutdown = shutdown_modem_untrusted,
+};
+
+struct pil_reset_ops pil_q6_ops = {
+	.init_image = init_image_q6_untrusted,
+	.verify_blob = verify_blob,
+	.auth_and_reset = reset_q6_untrusted,
+	.shutdown = shutdown_q6_untrusted,
+};
+
+struct pil_reset_ops pil_dsps_ops = {
+	.init_image = init_image_dsps_untrusted,
+	.verify_blob = verify_blob,
+	.auth_and_reset = reset_dsps_untrusted,
+	.shutdown = shutdown_dsps_untrusted,
+};
+
+static struct pil_device peripherals[] = {
+	{
+		.name = "modem",
+		.depends_on = "q6",
+		.pdev = {
+			.name = "pil_modem",
+			.id = -1,
+		},
+		.ops = &pil_modem_ops,
+	},
+	{
+		.name = "q6",
+		.pdev = {
+			.name = "pil_q6",
+			.id = -1,
+		},
+		.ops = &pil_q6_ops,
+	},
+	{
+		.name = "dsps",
+		.pdev = {
+			.name = "pil_dsps",
+			.id = -1,
+		},
+		.ops = &pil_dsps_ops,
+	},
+};
+
+
+#ifdef CONFIG_MSM_SECURE_PIL
+#define SECURE_PIL 1
+#else
+#define SECURE_PIL 0
+#endif
+
+static int __init msm_peripheral_reset_init(void)
+{
+	unsigned i;
+
+	msm_mms_regs_base = ioremap(MSM_MMS_REGS_BASE, SZ_256);
+	if (!msm_mms_regs_base)
+		goto err;
+
+	msm_lpass_qdsp6ss_base = ioremap(MSM_LPASS_QDSP6SS_BASE, SZ_256);
+	if (!msm_lpass_qdsp6ss_base)
+		goto err;
+
+	if (SECURE_PIL) {
+		pil_modem_ops.init_image = init_image_modem_trusted;
+		pil_modem_ops.auth_and_reset = reset_modem_trusted;
+		pil_modem_ops.shutdown = shutdown_modem_trusted;
+
+		pil_q6_ops.init_image = init_image_q6_trusted;
+		pil_q6_ops.auth_and_reset = reset_q6_trusted;
+		pil_q6_ops.shutdown = shutdown_q6_trusted;
+
+		pil_dsps_ops.init_image = init_image_dsps_trusted;
+		pil_dsps_ops.auth_and_reset = reset_dsps_trusted;
+		pil_dsps_ops.shutdown = shutdown_dsps_trusted;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(peripherals); i++)
+		msm_pil_add_device(&peripherals[i]);
+
+	return 0;
+
+err:
+	iounmap(msm_mms_regs_base);
+	return -ENOMEM;
+}
+
+static void __exit msm_peripheral_reset_exit(void)
+{
+	iounmap(msm_mms_regs_base);
+	iounmap(msm_lpass_qdsp6ss_base);
+}
+
+arch_initcall(msm_peripheral_reset_init);
+module_exit(msm_peripheral_reset_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Validate and bring peripherals out of reset");
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

