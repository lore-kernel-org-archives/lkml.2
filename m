Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2KZNRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:17:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3970 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2KZNQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:16:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 26 Nov 2012 05:16:15 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [RFC v2 4/8] video: tegra: Add debug support
Date: Mon, 26 Nov 2012 15:19:10 +0200
Message-ID: <1353935954-13763-5-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for host1x debugging. Adds debugfs entries, and dumps
channel state to UART in case of stuck submit.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/video/tegra/host/Makefile               |    1 +
 drivers/video/tegra/host/bus_client.c           |    3 +
 drivers/video/tegra/host/chip_support.h         |   16 +
 drivers/video/tegra/host/debug.c                |  252 ++++++++++++++
 drivers/video/tegra/host/debug.h                |   50 +++
 drivers/video/tegra/host/host1x/host1x.c        |    3 +
 drivers/video/tegra/host/host1x/host1x01.c      |    2 +
 drivers/video/tegra/host/host1x/host1x_cdma.c   |    3 +
 drivers/video/tegra/host/host1x/host1x_debug.c  |  405 +++++++++++++++++++++++
 drivers/video/tegra/host/host1x/host1x_syncpt.c |    1 +
 drivers/video/tegra/host/nvhost_cdma.c          |    1 +
 drivers/video/tegra/host/nvhost_syncpt.c        |    2 +
 12 files changed, 739 insertions(+)
 create mode 100644 drivers/video/tegra/host/debug.c
 create mode 100644 drivers/video/tegra/host/debug.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x_debug.c

diff --git a/drivers/video/tegra/host/Makefile b/drivers/video/tegra/host/Makefile
index 128ad03..9553b3a 100644
--- a/drivers/video/tegra/host/Makefile
+++ b/drivers/video/tegra/host/Makefile
@@ -8,6 +8,7 @@ nvhost-objs = \
 	nvhost_channel.o \
 	nvhost_job.o \
 	dev.o \
+	debug.o \
 	bus_client.o \
 	chip_support.o \
 	nvhost_memmgr.o \
diff --git a/drivers/video/tegra/host/bus_client.c b/drivers/video/tegra/host/bus_client.c
index 3986185..1b02836 100644
--- a/drivers/video/tegra/host/bus_client.c
+++ b/drivers/video/tegra/host/bus_client.c
@@ -35,6 +35,7 @@
 
 #include <linux/nvhost.h>
 
+#include "debug.h"
 #include "dev.h"
 #include "nvhost_memmgr.h"
 #include "chip_support.h"
@@ -68,6 +69,8 @@ int nvhost_client_device_init(struct platform_device *dev)
 	if (err)
 		goto fail;
 
+	nvhost_device_debug_init(dev);
+
 	dev_info(&dev->dev, "initialized\n");
 
 	return 0;
diff --git a/drivers/video/tegra/host/chip_support.h b/drivers/video/tegra/host/chip_support.h
index ff141ed..efc8c10 100644
--- a/drivers/video/tegra/host/chip_support.h
+++ b/drivers/video/tegra/host/chip_support.h
@@ -76,6 +76,21 @@ struct nvhost_pushbuffer_ops {
 	u32 (*putptr)(struct push_buffer *);
 };
 
+struct nvhost_debug_ops {
+	void (*debug_init)(struct dentry *de);
+	void (*show_channel_cdma)(struct nvhost_master *,
+				  struct nvhost_channel *,
+				  struct output *,
+				  int chid);
+	void (*show_channel_fifo)(struct nvhost_master *,
+				  struct nvhost_channel *,
+				  struct output *,
+				  int chid);
+	void (*show_mlocks)(struct nvhost_master *m,
+			    struct output *o);
+
+};
+
 struct nvhost_syncpt_ops {
 	void (*reset)(struct nvhost_syncpt *, u32 id);
 	void (*reset_wait_base)(struct nvhost_syncpt *, u32 id);
@@ -113,6 +128,7 @@ struct nvhost_chip_support {
 	struct nvhost_channel_ops channel;
 	struct nvhost_cdma_ops cdma;
 	struct nvhost_pushbuffer_ops push_buffer;
+	struct nvhost_debug_ops debug;
 	struct nvhost_syncpt_ops syncpt;
 	struct nvhost_intr_ops intr;
 	struct nvhost_dev_ops nvhost_dev;
diff --git a/drivers/video/tegra/host/debug.c b/drivers/video/tegra/host/debug.c
new file mode 100644
index 0000000..496c5a1
--- /dev/null
+++ b/drivers/video/tegra/host/debug.c
@@ -0,0 +1,252 @@
+/*
+ * drivers/video/tegra/host/debug.c
+ *
+ * Copyright (C) 2010 Google, Inc.
+ * Author: Erik Gilling <konkers@android.com>
+ *
+ * Copyright (C) 2011-2012 NVIDIA Corporation
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
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+
+#include <linux/io.h>
+
+#include "dev.h"
+#include "debug.h"
+#include "nvhost_acm.h"
+#include "nvhost_channel.h"
+#include "chip_support.h"
+
+pid_t nvhost_debug_null_kickoff_pid;
+
+pid_t nvhost_debug_force_timeout_pid;
+u32 nvhost_debug_force_timeout_val;
+u32 nvhost_debug_force_timeout_channel;
+
+void nvhost_debug_output(struct output *o, const char *fmt, ...)
+{
+	va_list args;
+	int len;
+
+	va_start(args, fmt);
+	len = vsnprintf(o->buf, sizeof(o->buf), fmt, args);
+	va_end(args);
+	o->fn(o->ctx, o->buf, len);
+}
+
+static int show_channels(struct platform_device *pdev, void *data)
+{
+	struct nvhost_channel *ch;
+	struct output *o = data;
+	struct nvhost_master *m;
+	struct nvhost_device_data *pdata;
+
+	if (pdev == NULL)
+		return 0;
+
+	pdata = platform_get_drvdata(pdev);
+	m = nvhost_get_host(pdev);
+	ch = pdata->channel;
+	if (ch) {
+		mutex_lock(&ch->reflock);
+		if (ch->refcount) {
+			mutex_lock(&ch->cdma.lock);
+			nvhost_get_chip_ops()->debug.show_channel_fifo(
+				m, ch, o, pdata->index);
+			nvhost_get_chip_ops()->debug.show_channel_cdma(
+				m, ch, o, pdata->index);
+			mutex_unlock(&ch->cdma.lock);
+		}
+		mutex_unlock(&ch->reflock);
+	}
+
+	return 0;
+}
+
+static void show_syncpts(struct nvhost_master *m, struct output *o)
+{
+	int i;
+	nvhost_debug_output(o, "---- syncpts ----\n");
+	for (i = 0; i < nvhost_syncpt_nb_pts(&m->syncpt); i++) {
+		u32 max = nvhost_syncpt_read_max(&m->syncpt, i);
+		u32 min = nvhost_syncpt_update_min(&m->syncpt, i);
+		if (!min && !max)
+			continue;
+		nvhost_debug_output(o, "id %d (%s) min %d max %d\n",
+			i, nvhost_get_chip_ops()->syncpt.name(&m->syncpt, i),
+			min, max);
+	}
+
+	for (i = 0; i < nvhost_syncpt_nb_bases(&m->syncpt); i++) {
+		u32 base_val;
+		base_val = nvhost_syncpt_read_wait_base(&m->syncpt, i);
+		if (base_val)
+			nvhost_debug_output(o, "waitbase id %d val %d\n",
+					i, base_val);
+	}
+
+	nvhost_debug_output(o, "\n");
+}
+
+static void show_all(struct nvhost_master *m, struct output *o)
+{
+	nvhost_module_busy(m->dev);
+
+	nvhost_get_chip_ops()->debug.show_mlocks(m, o);
+	show_syncpts(m, o);
+	nvhost_debug_output(o, "---- channels ----\n");
+	nvhost_device_list_for_all(o, show_channels);
+
+	nvhost_module_idle(m->dev);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int show_channels_no_fifo(struct platform_device *pdev, void *data)
+{
+	struct nvhost_channel *ch;
+	struct output *o = data;
+	struct nvhost_master *m;
+	struct nvhost_device_data *pdata;
+
+	if (pdev == NULL)
+		return 0;
+
+	pdata = platform_get_drvdata(pdev);
+	m = nvhost_get_host(pdev);
+	ch = pdata->channel;
+	if (ch) {
+		mutex_lock(&ch->reflock);
+		if (ch->refcount) {
+			mutex_lock(&ch->cdma.lock);
+			nvhost_get_chip_ops()->debug.show_channel_cdma(m,
+					ch, o, pdata->index);
+			mutex_unlock(&ch->cdma.lock);
+		}
+		mutex_unlock(&ch->reflock);
+	}
+
+	return 0;
+}
+
+static void show_all_no_fifo(struct nvhost_master *m, struct output *o)
+{
+	nvhost_module_busy(m->dev);
+
+	nvhost_get_chip_ops()->debug.show_mlocks(m, o);
+	show_syncpts(m, o);
+	nvhost_debug_output(o, "---- channels ----\n");
+	nvhost_device_list_for_all(o, show_channels_no_fifo);
+
+	nvhost_module_idle(m->dev);
+}
+
+static int nvhost_debug_show_all(struct seq_file *s, void *unused)
+{
+	struct output o = {
+		.fn = write_to_seqfile,
+		.ctx = s
+	};
+	show_all(s->private, &o);
+	return 0;
+}
+
+static int nvhost_debug_show(struct seq_file *s, void *unused)
+{
+	struct output o = {
+		.fn = write_to_seqfile,
+		.ctx = s
+	};
+	show_all_no_fifo(s->private, &o);
+	return 0;
+}
+
+static int nvhost_debug_open_all(struct inode *inode, struct file *file)
+{
+	return single_open(file, nvhost_debug_show_all, inode->i_private);
+}
+
+static const struct file_operations nvhost_debug_all_fops = {
+	.open		= nvhost_debug_open_all,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int nvhost_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nvhost_debug_show, inode->i_private);
+}
+
+static const struct file_operations nvhost_debug_fops = {
+	.open		= nvhost_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+void nvhost_device_debug_init(struct platform_device *dev)
+{
+	struct dentry *de = NULL;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	de = debugfs_create_dir(dev->name, de);
+
+	pdata->debugfs = de;
+}
+
+void nvhost_debug_init(struct nvhost_master *master)
+{
+	struct nvhost_device_data *pdata;
+	struct dentry *de = debugfs_create_dir("tegra_host", NULL);
+
+	if (!de)
+		return;
+
+	pdata = platform_get_drvdata(master->dev);
+
+	/* Store the created entry */
+	pdata->debugfs = de;
+
+	debugfs_create_file("status", S_IRUGO, de,
+			master, &nvhost_debug_fops);
+	debugfs_create_file("status_all", S_IRUGO, de,
+			master, &nvhost_debug_all_fops);
+
+	debugfs_create_u32("null_kickoff_pid", S_IRUGO|S_IWUSR, de,
+			&nvhost_debug_null_kickoff_pid);
+
+	if (nvhost_get_chip_ops()->debug.debug_init)
+		nvhost_get_chip_ops()->debug.debug_init(de);
+
+	debugfs_create_u32("force_timeout_pid", S_IRUGO|S_IWUSR, de,
+			&nvhost_debug_force_timeout_pid);
+	debugfs_create_u32("force_timeout_val", S_IRUGO|S_IWUSR, de,
+			&nvhost_debug_force_timeout_val);
+	debugfs_create_u32("force_timeout_channel", S_IRUGO|S_IWUSR, de,
+			&nvhost_debug_force_timeout_channel);
+}
+#else
+void nvhost_debug_init(struct nvhost_master *master)
+{
+}
+#endif
+
+void nvhost_debug_dump(struct nvhost_master *master)
+{
+	struct output o = {
+		.fn = write_to_printk
+	};
+	show_all(master, &o);
+}
diff --git a/drivers/video/tegra/host/debug.h b/drivers/video/tegra/host/debug.h
new file mode 100644
index 0000000..c484a46
--- /dev/null
+++ b/drivers/video/tegra/host/debug.h
@@ -0,0 +1,50 @@
+/*
+ * drivers/video/tegra/host/debug.h
+ *
+ * Tegra host1x Debug
+ *
+ * Copyright (c) 2011-2012 NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __NVHOST_DEBUG_H
+#define __NVHOST_DEBUG_H
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+struct nvhost_master;
+
+struct output {
+	void (*fn)(void *ctx, const char *str, size_t len);
+	void *ctx;
+	char buf[256];
+};
+
+static inline void write_to_seqfile(void *ctx, const char *str, size_t len)
+{
+	seq_write((struct seq_file *)ctx, str, len);
+}
+
+static inline void write_to_printk(void *ctx, const char *str, size_t len)
+{
+	pr_info("%s", str);
+}
+
+void nvhost_debug_output(struct output *o, const char *fmt, ...);
+
+void nvhost_debug_init(struct nvhost_master *master);
+void nvhost_device_debug_init(struct platform_device *dev);
+void nvhost_debug_dump(struct nvhost_master *master);
+
+#endif /*__NVHOST_DEBUG_H */
diff --git a/drivers/video/tegra/host/host1x/host1x.c b/drivers/video/tegra/host/host1x/host1x.c
index 8033b2d..fb2a0d2 100644
--- a/drivers/video/tegra/host/host1x/host1x.c
+++ b/drivers/video/tegra/host/host1x/host1x.c
@@ -31,6 +31,7 @@
 
 #include "dev.h"
 #include "host1x/host1x.h"
+#include "debug.h"
 #include "nvhost_acm.h"
 #include "nvhost_channel.h"
 #include "chip_support.h"
@@ -184,6 +185,8 @@ static int __devinit nvhost_probe(struct platform_device *dev)
 	if (err)
 		goto fail;
 
+	nvhost_debug_init(host);
+
 	dev_info(&dev->dev, "initialized\n");
 
 	return 0;
diff --git a/drivers/video/tegra/host/host1x/host1x01.c b/drivers/video/tegra/host/host1x/host1x01.c
index cd97339..2c69200 100644
--- a/drivers/video/tegra/host/host1x/host1x01.c
+++ b/drivers/video/tegra/host/host1x/host1x01.c
@@ -48,6 +48,7 @@ struct nvhost_channel *t20_alloc_nvhost_channel(struct platform_device *dev)
 
 #include "host1x/host1x_channel.c"
 #include "host1x/host1x_cdma.c"
+#include "host1x/host1x_debug.c"
 #include "host1x/host1x_syncpt.c"
 #include "host1x/host1x_intr.c"
 
@@ -57,6 +58,7 @@ int nvhost_init_host1x01_support(struct nvhost_master *host,
 	op->channel = host1x_channel_ops;
 	op->cdma = host1x_cdma_ops;
 	op->push_buffer = host1x_pushbuffer_ops;
+	op->debug = host1x_debug_ops;
 	host->sync_aperture = host->aperture + HOST1X_CHANNEL_SYNC_REG_BASE;
 	op->syncpt = host1x_syncpt_ops;
 	op->intr = host1x_intr_ops;
diff --git a/drivers/video/tegra/host/host1x/host1x_cdma.c b/drivers/video/tegra/host/host1x/host1x_cdma.c
index 07f0758..bbc021e 100644
--- a/drivers/video/tegra/host/host1x/host1x_cdma.c
+++ b/drivers/video/tegra/host/host1x/host1x_cdma.c
@@ -25,6 +25,7 @@
 #include "nvhost_cdma.h"
 #include "nvhost_channel.h"
 #include "dev.h"
+#include "debug.h"
 #include "chip_support.h"
 #include "nvhost_memmgr.h"
 
@@ -413,6 +414,8 @@ static void cdma_timeout_handler(struct work_struct *work)
 	sp = &dev->syncpt;
 	ch = cdma_to_channel(cdma);
 
+	nvhost_debug_dump(cdma_to_dev(cdma));
+
 	mutex_lock(&cdma->lock);
 
 	if (!cdma->timeout.clientid) {
diff --git a/drivers/video/tegra/host/host1x/host1x_debug.c b/drivers/video/tegra/host/host1x/host1x_debug.c
new file mode 100644
index 0000000..27f696cd
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x_debug.c
@@ -0,0 +1,405 @@
+/*
+ * drivers/video/tegra/host/host1x/host1x_debug.c
+ *
+ * Copyright (C) 2010 Google, Inc.
+ * Author: Erik Gilling <konkers@android.com>
+ *
+ * Copyright (C) 2011 NVIDIA Corporation
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
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+
+#include <linux/io.h>
+
+#include "dev.h"
+#include "debug.h"
+#include "nvhost_cdma.h"
+#include "nvhost_channel.h"
+#include "chip_support.h"
+#include "nvhost_memmgr.h"
+
+#define NVHOST_DEBUG_MAX_PAGE_OFFSET 102400
+
+enum {
+	NVHOST_DBG_STATE_CMD = 0,
+	NVHOST_DBG_STATE_DATA = 1,
+	NVHOST_DBG_STATE_GATHER = 2
+};
+
+static int show_channel_command(struct output *o, u32 addr, u32 val, int *count)
+{
+	unsigned mask;
+	unsigned subop;
+
+	switch (val >> 28) {
+	case 0x0:
+		mask = val & 0x3f;
+		if (mask) {
+			nvhost_debug_output(o,
+				"SETCL(class=%03x, offset=%03x, mask=%02x, [",
+				val >> 6 & 0x3ff, val >> 16 & 0xfff, mask);
+			*count = hweight8(mask);
+			return NVHOST_DBG_STATE_DATA;
+		} else {
+			nvhost_debug_output(o, "SETCL(class=%03x)\n",
+				val >> 6 & 0x3ff);
+			return NVHOST_DBG_STATE_CMD;
+		}
+
+	case 0x1:
+		nvhost_debug_output(o, "INCR(offset=%03x, [",
+			val >> 16 & 0xfff);
+		*count = val & 0xffff;
+		return NVHOST_DBG_STATE_DATA;
+
+	case 0x2:
+		nvhost_debug_output(o, "NONINCR(offset=%03x, [",
+			val >> 16 & 0xfff);
+		*count = val & 0xffff;
+		return NVHOST_DBG_STATE_DATA;
+
+	case 0x3:
+		mask = val & 0xffff;
+		nvhost_debug_output(o, "MASK(offset=%03x, mask=%03x, [",
+			   val >> 16 & 0xfff, mask);
+		*count = hweight16(mask);
+		return NVHOST_DBG_STATE_DATA;
+
+	case 0x4:
+		nvhost_debug_output(o, "IMM(offset=%03x, data=%03x)\n",
+			   val >> 16 & 0xfff, val & 0xffff);
+		return NVHOST_DBG_STATE_CMD;
+
+	case 0x5:
+		nvhost_debug_output(o, "RESTART(offset=%08x)\n", val << 4);
+		return NVHOST_DBG_STATE_CMD;
+
+	case 0x6:
+		nvhost_debug_output(o,
+			"GATHER(offset=%03x, insert=%d, type=%d, count=%04x, addr=[",
+			val >> 16 & 0xfff, val >> 15 & 0x1, val >> 14 & 0x1,
+			val & 0x3fff);
+		*count = val & 0x3fff; /* TODO: insert */
+		return NVHOST_DBG_STATE_GATHER;
+
+	case 0xe:
+		subop = val >> 24 & 0xf;
+		if (subop == 0)
+			nvhost_debug_output(o, "ACQUIRE_MLOCK(index=%d)\n",
+				val & 0xff);
+		else if (subop == 1)
+			nvhost_debug_output(o, "RELEASE_MLOCK(index=%d)\n",
+				val & 0xff);
+		else
+			nvhost_debug_output(o, "EXTEND_UNKNOWN(%08x)\n", val);
+		return NVHOST_DBG_STATE_CMD;
+
+	default:
+		return NVHOST_DBG_STATE_CMD;
+	}
+}
+
+static void show_channel_gather(struct output *o, u32 addr,
+		phys_addr_t phys_addr, u32 words, struct nvhost_cdma *cdma);
+
+static void show_channel_word(struct output *o, int *state, int *count,
+		u32 addr, u32 val, struct nvhost_cdma *cdma)
+{
+	static int start_count, dont_print;
+
+	switch (*state) {
+	case NVHOST_DBG_STATE_CMD:
+		if (addr)
+			nvhost_debug_output(o, "%08x: %08x:", addr, val);
+		else
+			nvhost_debug_output(o, "%08x:", val);
+
+		*state = show_channel_command(o, addr, val, count);
+		dont_print = 0;
+		start_count = *count;
+		if (*state == NVHOST_DBG_STATE_DATA && *count == 0) {
+			*state = NVHOST_DBG_STATE_CMD;
+			nvhost_debug_output(o, "])\n");
+		}
+		break;
+
+	case NVHOST_DBG_STATE_DATA:
+		(*count)--;
+		if (start_count - *count < 64)
+			nvhost_debug_output(o, "%08x%s",
+				val, *count > 0 ? ", " : "])\n");
+		else if (!dont_print && (*count > 0)) {
+			nvhost_debug_output(o, "[truncated; %d more words]\n",
+				*count);
+			dont_print = 1;
+		}
+		if (*count == 0)
+			*state = NVHOST_DBG_STATE_CMD;
+		break;
+
+	case NVHOST_DBG_STATE_GATHER:
+		*state = NVHOST_DBG_STATE_CMD;
+		nvhost_debug_output(o, "%08x]):\n", val);
+		if (cdma) {
+			show_channel_gather(o, addr, val,
+					*count, cdma);
+		}
+		break;
+	}
+}
+
+static void do_show_channel_gather(struct output *o,
+		phys_addr_t phys_addr,
+		u32 words, struct nvhost_cdma *cdma,
+		phys_addr_t pin_addr, u32 *map_addr)
+{
+	/* Map dmaget cursor to corresponding mem handle */
+	u32 offset;
+	int state, count, i;
+
+	offset = phys_addr - pin_addr;
+	/*
+	 * Sometimes we're given different hardware address to the same
+	 * page - in these cases the offset will get an invalid number and
+	 * we just have to bail out.
+	 */
+	if (offset > NVHOST_DEBUG_MAX_PAGE_OFFSET) {
+		nvhost_debug_output(o, "[address mismatch]\n");
+	} else {
+		/* GATHER buffer starts always with commands */
+		state = NVHOST_DBG_STATE_CMD;
+		for (i = 0; i < words; i++)
+			show_channel_word(o, &state, &count,
+					phys_addr + i * 4,
+					*(map_addr + offset/4 + i),
+					cdma);
+	}
+}
+
+static void show_channel_gather(struct output *o, u32 addr,
+		phys_addr_t phys_addr,
+		u32 words, struct nvhost_cdma *cdma)
+{
+	/* Map dmaget cursor to corresponding mem handle */
+	struct push_buffer *pb = &cdma->push_buffer;
+	u32 cur = addr - pb->phys;
+	struct mem_handle *mem = pb->handle[cur/8];
+	u32 *map_addr, offset;
+	struct sg_table *sgt;
+
+	if (!mem) {
+		nvhost_debug_output(o, "[already deallocated]\n");
+		return;
+	}
+
+	map_addr = nvhost_memmgr_mmap(mem);
+	if (!map_addr) {
+		nvhost_debug_output(o, "[could not mmap]\n");
+		return;
+	}
+
+	/* Get base address from mem */
+	sgt = nvhost_memmgr_pin(mem);
+	if (IS_ERR(sgt)) {
+		nvhost_debug_output(o, "[couldn't pin]\n");
+		nvhost_memmgr_munmap(mem, map_addr);
+		return;
+	}
+
+	offset = phys_addr - sg_dma_address(sgt->sgl);
+	do_show_channel_gather(o, phys_addr, words, cdma,
+			sg_dma_address(sgt->sgl), map_addr);
+	nvhost_memmgr_unpin(mem, sgt);
+	nvhost_memmgr_munmap(mem, map_addr);
+}
+
+static void show_channel_gathers(struct output *o, struct nvhost_cdma *cdma)
+{
+	struct nvhost_job *job;
+
+	list_for_each_entry(job, &cdma->sync_queue, list) {
+		int i;
+		nvhost_debug_output(o, "\n%p: JOB, syncpt_id=%d, syncpt_val=%d,"
+				" first_get=%08x, timeout=%d"
+				" num_slots=%d, num_handles=%d\n",
+				job,
+				job->syncpt_id,
+				job->syncpt_end,
+				job->first_get,
+				job->timeout,
+				job->num_slots,
+				job->num_unpins);
+
+		for (i = 0; i < job->num_gathers; i++) {
+			struct nvhost_job_gather *g = &job->gathers[i];
+			u32 *mapped = nvhost_memmgr_mmap(g->ref);
+			if (!mapped) {
+				nvhost_debug_output(o, "[could not mmap]\n");
+				continue;
+			}
+
+			nvhost_debug_output(o,
+				"    GATHER at %08x+%04x, %d words\n",
+				g->mem_base, g->offset, g->words);
+
+			do_show_channel_gather(o, g->mem_base + g->offset,
+					g->words, cdma, g->mem_base, mapped);
+			nvhost_memmgr_munmap(g->ref, mapped);
+		}
+	}
+}
+
+static void host1x_debug_show_channel_cdma(struct nvhost_master *m,
+	struct nvhost_channel *ch, struct output *o, int chid)
+{
+	struct nvhost_channel *channel = ch;
+	struct nvhost_cdma *cdma = &channel->cdma;
+	u32 dmaput, dmaget, dmactrl;
+	u32 cbstat, cbread;
+	u32 val, base, baseval;
+	struct nvhost_device_data *pdata = platform_get_drvdata(channel->dev);
+
+	dmaput = readl(channel->aperture + host1x_channel_dmaput_r());
+	dmaget = readl(channel->aperture + host1x_channel_dmaget_r());
+	dmactrl = readl(channel->aperture + host1x_channel_dmactrl_r());
+	cbread = readl(m->sync_aperture + host1x_sync_cbread0_r() + 4 * chid);
+	cbstat = readl(m->sync_aperture + host1x_sync_cbstat_0_r() + 4 * chid);
+
+	nvhost_debug_output(o, "%d-%s (%d): ", chid,
+			    channel->dev->name,
+			    pdata->refcount);
+
+	if (host1x_channel_dmactrl_dmastop_v(dmactrl)
+		|| !channel->cdma.push_buffer.mapped) {
+		nvhost_debug_output(o, "inactive\n\n");
+		return;
+	}
+
+	switch (cbstat) {
+	case 0x00010008:
+		nvhost_debug_output(o, "waiting on syncpt %d val %d\n",
+			cbread >> 24, cbread & 0xffffff);
+		break;
+
+	case 0x00010009:
+		base = (cbread >> 16) & 0xff;
+		baseval = readl(m->sync_aperture +
+				host1x_sync_syncpt_base_0_r() + 4 * base);
+		val = cbread & 0xffff;
+		nvhost_debug_output(o, "waiting on syncpt %d val %d "
+			  "(base %d = %d; offset = %d)\n",
+			cbread >> 24, baseval + val,
+			base, baseval, val);
+		break;
+
+	default:
+		nvhost_debug_output(o,
+				"active class %02x, offset %04x, val %08x\n",
+				host1x_sync_cbstat_0_cbclass0_v(cbstat),
+				host1x_sync_cbstat_0_cboffset0_v(cbstat),
+				cbread);
+		break;
+	}
+
+	nvhost_debug_output(o, "DMAPUT %08x, DMAGET %08x, DMACTL %08x\n",
+		dmaput, dmaget, dmactrl);
+	nvhost_debug_output(o, "CBREAD %08x, CBSTAT %08x\n", cbread, cbstat);
+
+	show_channel_gathers(o, cdma);
+	nvhost_debug_output(o, "\n");
+}
+
+static void host1x_debug_show_channel_fifo(struct nvhost_master *m,
+	struct nvhost_channel *ch, struct output *o, int chid)
+{
+	u32 val, rd_ptr, wr_ptr, start, end;
+	struct nvhost_channel *channel = ch;
+	int state, count;
+
+	nvhost_debug_output(o, "%d: fifo:\n", chid);
+
+	val = readl(channel->aperture + host1x_channel_fifostat_r());
+	nvhost_debug_output(o, "FIFOSTAT %08x\n", val);
+	if (host1x_channel_fifostat_cfempty_v(val)) {
+		nvhost_debug_output(o, "[empty]\n");
+		return;
+	}
+
+	writel(0x0, m->sync_aperture + host1x_sync_cfpeek_ctrl_r());
+	writel(host1x_sync_cfpeek_ctrl_cfpeek_ena_f(1)
+			| host1x_sync_cfpeek_ctrl_cfpeek_channr_f(chid),
+		m->sync_aperture + host1x_sync_cfpeek_ctrl_r());
+
+	val = readl(m->sync_aperture + host1x_sync_cfpeek_ptrs_r());
+	rd_ptr = host1x_sync_cfpeek_ptrs_cf_rd_ptr_v(val);
+	wr_ptr = host1x_sync_cfpeek_ptrs_cf_wr_ptr_v(val);
+
+	val = readl(m->sync_aperture + host1x_sync_cf0_setup_r() + 4 * chid);
+	start = host1x_sync_cf0_setup_cf0_base_v(val);
+	end = host1x_sync_cf0_setup_cf0_limit_v(val);
+
+	state = NVHOST_DBG_STATE_CMD;
+
+	do {
+		writel(0x0, m->sync_aperture + host1x_sync_cfpeek_ctrl_r());
+		writel(host1x_sync_cfpeek_ctrl_cfpeek_ena_f(1)
+				| host1x_sync_cfpeek_ctrl_cfpeek_channr_f(chid)
+				| host1x_sync_cfpeek_ctrl_cfpeek_addr_f(rd_ptr),
+			m->sync_aperture + host1x_sync_cfpeek_ctrl_r());
+		val = readl(m->sync_aperture + host1x_sync_cfpeek_read_r());
+
+		show_channel_word(o, &state, &count, 0, val, NULL);
+
+		if (rd_ptr == end)
+			rd_ptr = start;
+		else
+			rd_ptr++;
+	} while (rd_ptr != wr_ptr);
+
+	if (state == NVHOST_DBG_STATE_DATA)
+		nvhost_debug_output(o, ", ...])\n");
+	nvhost_debug_output(o, "\n");
+
+	writel(0x0, m->sync_aperture + host1x_sync_cfpeek_ctrl_r());
+}
+
+static void host1x_debug_show_mlocks(struct nvhost_master *m, struct output *o)
+{
+	u32 __iomem *mlo_regs = m->sync_aperture +
+		host1x_sync_mlock_owner_0_r();
+	int i;
+
+	nvhost_debug_output(o, "---- mlocks ----\n");
+	for (i = 0; i < NV_HOST1X_NB_MLOCKS; i++) {
+		u32 owner = readl(mlo_regs + i);
+		if (host1x_sync_mlock_owner_0_mlock_ch_owns_0_v(owner))
+			nvhost_debug_output(o, "%d: locked by channel %d\n",
+				i,
+				host1x_sync_mlock_owner_0_mlock_owner_chid_0_f(
+					owner));
+		else if (host1x_sync_mlock_owner_0_mlock_cpu_owns_0_v(owner))
+			nvhost_debug_output(o, "%d: locked by cpu\n", i);
+		else
+			nvhost_debug_output(o, "%d: unlocked\n", i);
+	}
+	nvhost_debug_output(o, "\n");
+}
+
+static const struct nvhost_debug_ops host1x_debug_ops = {
+	.show_channel_cdma = host1x_debug_show_channel_cdma,
+	.show_channel_fifo = host1x_debug_show_channel_fifo,
+	.show_mlocks = host1x_debug_show_mlocks,
+};
diff --git a/drivers/video/tegra/host/host1x/host1x_syncpt.c b/drivers/video/tegra/host/host1x/host1x_syncpt.c
index e47bd71..eadb8cf 100644
--- a/drivers/video/tegra/host/host1x/host1x_syncpt.c
+++ b/drivers/video/tegra/host/host1x/host1x_syncpt.c
@@ -100,6 +100,7 @@ static void host1x_syncpt_cpu_incr(struct nvhost_syncpt *sp, u32 id)
 		dev_err(&syncpt_to_dev(sp)->dev->dev,
 			"Trying to increment syncpoint id %d beyond max\n",
 			id);
+		nvhost_debug_dump(syncpt_to_dev(sp));
 		return;
 	}
 	writel(BIT_MASK(id), dev->sync_aperture +
diff --git a/drivers/video/tegra/host/nvhost_cdma.c b/drivers/video/tegra/host/nvhost_cdma.c
index e581836..50b1e7d 100644
--- a/drivers/video/tegra/host/nvhost_cdma.c
+++ b/drivers/video/tegra/host/nvhost_cdma.c
@@ -21,6 +21,7 @@
 #include "nvhost_cdma.h"
 #include "nvhost_channel.h"
 #include "dev.h"
+#include "debug.h"
 #include "nvhost_memmgr.h"
 #include "chip_support.h"
 #include <asm/cacheflush.h>
diff --git a/drivers/video/tegra/host/nvhost_syncpt.c b/drivers/video/tegra/host/nvhost_syncpt.c
index f61b924..fc1c19c 100644
--- a/drivers/video/tegra/host/nvhost_syncpt.c
+++ b/drivers/video/tegra/host/nvhost_syncpt.c
@@ -24,6 +24,7 @@
 #include "nvhost_syncpt.h"
 #include "nvhost_acm.h"
 #include "host1x/host1x.h"
+#include "debug.h"
 #include "chip_support.h"
 
 #define MAX_SYNCPT_LENGTH	5
@@ -222,6 +223,7 @@ int nvhost_syncpt_wait_timeout(struct nvhost_syncpt *sp, u32 id,
 						"is timeout %d too low?\n",
 						low_timeout);
 				}
+				nvhost_debug_dump(syncpt_to_dev(sp));
 			}
 			check_count++;
 		}
-- 
1.7.9.5

