Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1LBJOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:14:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab1LBJOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:14:32 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 7/7] media: video: introduce omap4 face detection module driver
Date: Fri,  2 Dec 2011 17:12:58 +0800
Message-Id: <1322817178-8931-8-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch introduces one face detection device driver for
driving face detection hardware on omap4[1].

Most things of the driver are dealing with omap4 face detection
hardware.

This driver is platform independent, so in theory it can
be used to drive same IP module on other platforms.

[1], Ch9 of OMAP4 Technical Reference Manual

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/video/fdif/Kconfig      |    6 +
 drivers/media/video/fdif/Makefile     |    1 +
 drivers/media/video/fdif/fdif_omap4.c |  663 +++++++++++++++++++++++++++++++++
 3 files changed, 670 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/fdif/fdif_omap4.c

diff --git a/drivers/media/video/fdif/Kconfig b/drivers/media/video/fdif/Kconfig
index e214cb4..0482a83 100644
--- a/drivers/media/video/fdif/Kconfig
+++ b/drivers/media/video/fdif/Kconfig
@@ -5,3 +5,9 @@ config FDIF
 	help
 	  The FDIF is a face detection module, which can be integrated into
 	  some SoCs to detect the location of faces in one image or video.
+
+config FDIF_OMAP4
+	depends on FDIF
+	tristate "OMAP4 Face Detection module"
+	help
+	  OMAP4 face detection support
diff --git a/drivers/media/video/fdif/Makefile b/drivers/media/video/fdif/Makefile
index ba1e4c8..3744ced 100644
--- a/drivers/media/video/fdif/Makefile
+++ b/drivers/media/video/fdif/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_FDIF)		+= fdif.o
+obj-$(CONFIG_FDIF_OMAP4)	+= fdif_omap4.o
diff --git a/drivers/media/video/fdif/fdif_omap4.c b/drivers/media/video/fdif/fdif_omap4.c
new file mode 100644
index 0000000..956ec51
--- /dev/null
+++ b/drivers/media/video/fdif/fdif_omap4.c
@@ -0,0 +1,663 @@
+/*
+ *      fdif_omap4.c  --  face detection module driver
+ *
+ *      Copyright (C) 2011  Ming Lei (ming.lei@canonical.com)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ *      This program is distributed in the hope that it will be useful,
+ *      but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *      GNU General Public License for more details.
+ *
+ *      You should have received a copy of the GNU General Public License
+ *      along with this program; if not, write to the Free Software
+ *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+/*****************************************************************************/
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/signal.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/delay.h>
+#include <linux/user_namespace.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include "fdif.h"
+#include <asm/uaccess.h>
+#include <asm/byteorder.h>
+#include <asm/io.h>
+
+#undef DEBUG
+
+#define PICT_SIZE_X     320
+#define PICT_SIZE_Y     240
+
+#define	WORK_MEM_SIZE	(52*1024)
+
+/* 9.5 FDIF Register Manua of TI OMAP4 TRM */
+#define FDIF_REVISION		0x0
+#define FDIF_HWINFO		0x4
+#define FDIF_SYSCONFIG		0x10
+#define SOFTRESET		(1 << 0)
+
+#define FDIF_IRQSTATUS_RAW_j	(0x24 + 2*0x10)
+#define FDIF_IRQSTATUS_j	(0x28 + 2*0x10)
+#define FDIF_IRQENABLE_SET_j	(0x2c + 2*0x10)
+#define FDIF_IRQENABLE_CLR_j	(0x30 + 2*0x10)
+#define FINISH_IRQ		(1 << 8)
+#define ERR_IRQ			(1 << 0)
+
+#define FDIF_PICADDR		0x60
+#define FDIF_CTRL		0x64
+#define CTRL_MAX_TAGS		0x0A
+
+#define FDIF_WKADDR		0x68
+#define FD_CTRL			0x80
+#define CTRL_FINISH		(1 << 2)
+#define CTRL_RUN		(1 << 1)
+#define CTRL_SRST		(1 << 0)
+
+
+#define FD_DNUM			0x84
+#define FD_DCOND		0x88
+#define FD_STARTX		0x8c
+#define FD_STARTY		0x90
+#define FD_SIZEX		0x94
+#define FD_SIZEY		0x98
+#define FD_LHIT			0x9c
+#define FD_CENTERX_i		0x160
+#define FD_CENTERY_i		0x164
+#define FD_CONFSIZE_i		0x168
+#define FD_ANGLE_i		0x16c
+
+static inline void fd_writel(void __iomem *base, u32 reg, u32 val)
+{
+	__raw_writel(val, base + reg);
+}
+
+static inline u32 fd_readl(void __iomem *base, u32 reg)
+{
+	return __raw_readl(base + reg);
+}
+
+struct fdif_qvga {
+	struct fdif_dev *dev;
+
+	/*should be removed*/
+	struct platform_device	*pdev;
+	int			irq;
+	void __iomem		*base;
+
+	void			*work_mem_addr;
+	dma_addr_t 		work_dma;
+	dma_addr_t 		pict_dma;
+	unsigned long 		pict_mem_len;
+
+	struct fdif_buffer	*pending;
+	spinlock_t		lock;
+};
+
+struct fdif_fmt qvga_fmt[] = {
+	{
+		.name		= "8  Greyscale",
+		.fourcc		= V4L2_PIX_FMT_GREY,
+		.depth		= 8,
+		.width		= PICT_SIZE_X,
+		.height		= PICT_SIZE_Y,
+	},
+};
+
+
+#ifdef DEBUG
+static void dump_fdif_setting(struct fdif_qvga *fdif, const char *func)
+{
+	printk("%s: %s\n", func, __func__);
+	printk("work mem addr:%8p\n", fdif->work_mem_addr);
+	printk("face size=%2d, face dir=%2d, lhit=%d\n",
+			fdif->dev->s.min_face_size, fdif->dev->s.face_dir,
+			fdif->dev->s.lhit);
+	printk("startx =%4d starty=%4d sizex=%4d sizey=%4d\n",
+			fdif->dev->s.startx, fdif->dev->s.starty,
+			fdif->dev->s.sizex, fdif->dev->s.sizey);
+}
+
+static void dump_fdif_results(struct v4l2_fdif_result *fdif, const char *func)
+{
+	int idx;
+
+	printk("%s: %s\n", func, __func__);
+
+	printk("found %d faces, but index:%d\n", fdif->face_cnt,
+			fdif->index);
+	for(idx=0; idx < fdif->face_cnt; idx++) {
+		struct v4l2_fd_detection *fr = &fdif->faces[idx];
+		printk("	No.%d x=%3d y=%2d sz=%2d ang=%3d conf=%2d\n",
+				idx, fr->face.centerx, fr->face.centery,
+				fr->face.sizex, fr->face.angle,
+				fr->face.confidence);
+	}
+}
+
+static void dump_fdif_regs(struct fdif_qvga *fdif, const char *func)
+{
+	printk("%s:%s\n", __func__, func);
+	printk("FDIF_CTRL=%08x FDIF_SYSCONFIG=%08x\n",
+			fd_readl(fdif->base, FDIF_CTRL),
+			fd_readl(fdif->base, FDIF_SYSCONFIG));
+	printk("FDIF_IRQSTATUS_RAW_j=%08x FDIF_IRQSTATUS_j=%08x\n",
+			fd_readl(fdif->base, FDIF_IRQSTATUS_RAW_j),
+			fd_readl(fdif->base, FDIF_IRQSTATUS_j));
+	printk("FDIF_PICADDR=%08x FDIF_WKADDR=%08x\n",
+			fd_readl(fdif->base, FDIF_PICADDR),
+			fd_readl(fdif->base, FDIF_WKADDR));
+	printk("FD_CTRL=%04x, FDIF_IRQENABLE_SET_j=%04x\n",
+			fd_readl(fdif->base, FD_CTRL),
+			fd_readl(fdif->base, FDIF_IRQENABLE_SET_j));
+}
+
+#else
+static inline void dump_fdif_setting(struct fdif_qvga *fdif, const char *func)
+{
+}
+static inline void dump_fdif_results(struct v4l2_fdif_result *fdif, const char *func)
+{
+}
+static inline void dump_fdif_regs(struct fdif_qvga *fdif, const char *func)
+{
+}
+#endif
+
+static void install_default_setting(struct fdif_qvga *fdif)
+{
+	fdif->dev->s.fmt		= &qvga_fmt[0];
+	fdif->dev->s.field		= V4L2_FIELD_NONE;
+
+	fdif->dev->s.min_face_size	= FACE_SIZE_25_PIXELS;
+	fdif->dev->s.face_dir		= FACE_DIR_UP;
+	fdif->dev->s.startx		= 0;
+	fdif->dev->s.starty		= 0;
+	fdif->dev->s.sizex		= 0x140;
+	fdif->dev->s.sizey		= 0xf0;
+	fdif->dev->s.lhit		= 0x5;
+
+	fdif->dev->s.width		= PICT_SIZE_X;
+	fdif->dev->s.height		= PICT_SIZE_Y;
+}
+
+static void commit_image_setting(struct fdif_qvga *fdif)
+{
+	unsigned long conf;
+	struct vb2_buffer *vb = &fdif->pending->vb;
+	void *pict_vaddr = vb2_plane_vaddr(vb, 0);
+
+	fdif->pict_mem_len = vb2_plane_size(vb, 0);
+	fdif->pict_dma = dma_map_single(&fdif->pdev->dev,
+				pict_vaddr,
+				fdif->pict_mem_len,
+				DMA_TO_DEVICE);
+
+	fd_writel(fdif->base, FDIF_PICADDR, fdif->pict_dma);
+
+	conf = (fdif->dev->s.min_face_size & 0x3) ||
+		((fdif->dev->s.face_dir & 0x3) << 2);
+	fd_writel(fdif->base, FD_DCOND, conf);
+
+	fd_writel(fdif->base, FD_STARTX, fdif->dev->s.startx);
+	fd_writel(fdif->base, FD_STARTY, fdif->dev->s.starty);
+	fd_writel(fdif->base, FD_SIZEX, fdif->dev->s.sizex);
+	fd_writel(fdif->base, FD_SIZEY, fdif->dev->s.sizey);
+	fd_writel(fdif->base, FD_LHIT, fdif->dev->s.lhit);
+}
+
+
+/*softreset fdif*/
+static int softreset_fdif(struct fdif_qvga *fdif)
+{
+	unsigned long conf;
+	int to = 0;
+
+	conf = fd_readl(fdif->base, FDIF_SYSCONFIG);
+	conf |= SOFTRESET;
+	fd_writel(fdif->base, FDIF_SYSCONFIG, conf);
+
+	while ((conf & SOFTRESET) && to++ < 2000) {
+		conf = fd_readl(fdif->base, FDIF_SYSCONFIG);
+		udelay(2);
+	}
+
+	if (to == 2000)
+		dev_err(&fdif->pdev->dev, "%s: reset failed\n", __func__);
+
+	return to == 2000;
+}
+
+static void __start_detect(struct fdif_qvga *fdif)
+{
+	unsigned long conf;
+
+	dump_fdif_setting(fdif, __func__);
+
+	commit_image_setting(fdif);
+
+	/*enable finish irq*/
+	conf = FINISH_IRQ;
+	fd_writel(fdif->base, FDIF_IRQENABLE_SET_j, conf);
+
+	/*set RUN flag*/
+	conf = CTRL_RUN;
+	fd_writel(fdif->base, FD_CTRL, conf);
+
+	dump_fdif_regs(fdif, __func__);
+}
+
+static void __stop_detect(struct fdif_qvga *fdif)
+{
+	unsigned long conf;
+
+	dump_fdif_regs(fdif, __func__);
+
+	dma_unmap_single(&fdif->pdev->dev, fdif->pict_dma,
+				fdif->pict_mem_len,
+				DMA_TO_DEVICE);
+	/*disable finish irq*/
+	conf = FINISH_IRQ;
+	fd_writel(fdif->base, FDIF_IRQENABLE_CLR_j, conf);
+
+	/*mark FINISH flag*/
+	conf = CTRL_FINISH;
+	fd_writel(fdif->base, FD_CTRL, conf);
+}
+
+static int read_faces(struct fdif_qvga *fdif, int is_err)
+{
+	int cnt, idx = 0;
+	struct v4l2_fdif_result *v4l2_fr;
+	struct fdif_dev *dev = fdif->dev;
+	struct fdif_buffer *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fdif->lock, flags);
+
+	buf = fdif->pending;
+	if (!buf) {
+		WARN_ON(1);
+		cnt = -EIO;
+		goto out;
+	}
+
+	buf->vb.v4l2_buf.sequence++;
+
+	if (!is_err)
+		cnt = fd_readl(fdif->base, FD_DNUM) & 0x3f;
+	else
+		cnt = 0;
+
+	v4l2_fr = kzalloc(sizeof(*v4l2_fr), GFP_ATOMIC);
+	if (!v4l2_fr) {
+		cnt = -ENOMEM;
+		goto out;
+	}
+	if (cnt)
+		v4l2_fr->faces =
+			kmalloc(sizeof(struct v4l2_fd_detection) * cnt,
+				GFP_ATOMIC);
+
+	if (cnt && !v4l2_fr->faces) {
+		cnt = -ENOMEM;
+		goto out_err;
+	}
+
+	v4l2_fr->face_cnt = cnt;
+	v4l2_fr->index = buf->vb.v4l2_buf.index;
+
+	while(idx < cnt) {
+		struct v4l2_fd_detection *fr = &v4l2_fr->faces[idx];
+
+		fr->flag = V4L2_FD_HAS_FACE;
+
+		fr->face.centerx = fd_readl(fdif->base,
+				FD_CENTERX_i + idx * 0x10) & 0x1ff;
+		fr->face.centery = fd_readl(fdif->base,
+				FD_CENTERY_i + idx * 0x10) & 0xff;
+		fr->face.angle = fd_readl(fdif->base,
+				FD_ANGLE_i + idx * 0x10) & 0x1ff;
+		fr->face.sizex = fd_readl(fdif->base,
+				FD_CONFSIZE_i + idx * 0x10);
+		fr->face.confidence = (fr->face.sizex >> 8) & 0xf;
+		fr->face.sizey = fr->face.sizex = fr->face.sizex & 0xff;
+
+		idx++;
+	}
+
+	__stop_detect(fdif);
+	fdif->pending = NULL;
+	spin_unlock_irqrestore(&fdif->lock, flags);
+
+	dump_fdif_results(v4l2_fr, __func__);
+
+	/*queue the detection result to complete queue*/
+	fdif_add_detection(dev, v4l2_fr);
+
+	if (is_err)
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	else
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+
+	wake_up(&dev->fdif_dq.wq);
+
+	return cnt;
+
+out_err:
+	kfree(v4l2_fr);
+out:
+	spin_unlock_irqrestore(&fdif->lock, flags);
+	return cnt;
+}
+
+static int __submit_detection(struct fdif_qvga *fdif)
+{
+	struct fdif_dev *dev = fdif->dev;
+	struct fdif_buffer *buf;
+	unsigned long flags;
+	unsigned int ret = 0;
+
+	buf = fdif_get_buffer(dev);
+	if (!buf)
+		goto out;
+
+	spin_lock_irqsave(&fdif->lock, flags);
+	if (fdif->pending) {
+		spin_unlock_irqrestore(&fdif->lock, flags);
+		ret = -EBUSY;
+		goto out;
+	}
+	fdif->pending = buf;
+	__start_detect(fdif);
+	spin_unlock_irqrestore(&fdif->lock, flags);
+
+	return 0;
+
+out:
+	return ret;
+}
+
+static irqreturn_t handle_detection(int irq, void *__fdif)
+{
+	unsigned long irqsts;
+	struct fdif_qvga *fdif = __fdif;
+	irqreturn_t ret = IRQ_HANDLED;
+
+	/*clear irq status*/
+	irqsts = fd_readl(fdif->base, FDIF_IRQSTATUS_j);
+
+	if (irqsts & (FINISH_IRQ | ERR_IRQ)) {
+		int is_err = irqsts & ERR_IRQ;
+
+		fd_writel(fdif->base, FDIF_IRQSTATUS_j, irqsts);
+
+		read_faces(fdif, is_err);
+		if (is_err)
+			softreset_fdif(fdif);
+
+		__submit_detection(fdif);
+	} else {
+		ret = IRQ_NONE;
+	}
+
+	return ret;
+}
+
+static void fdif_global_init(struct fdif_qvga *fdif)
+{
+	unsigned long conf;
+	struct device *dev = &fdif->pdev->dev;
+
+	/*softreset fdif*/
+	softreset_fdif(fdif);
+
+	/*set max tags*/
+	conf = fd_readl(fdif->base, FDIF_CTRL);
+	conf &= ~0x1e;
+	conf |= (CTRL_MAX_TAGS << 1);
+	fd_writel(fdif->base, FDIF_CTRL, conf);
+
+	/*enable error irq*/
+	conf = ERR_IRQ;
+	fd_writel(fdif->base, FDIF_IRQENABLE_SET_j, conf);
+
+	fdif->work_dma = dma_map_single(dev,
+				fdif->work_mem_addr,
+		                WORK_MEM_SIZE,
+				DMA_TO_DEVICE);
+	fd_writel(fdif->base, FDIF_WKADDR, fdif->work_dma);
+}
+
+static void fdif_global_deinit(struct fdif_qvga *fdif)
+{
+	unsigned long conf;
+	struct device *dev = &fdif->pdev->dev;
+
+	/*enable error irq*/
+	conf = ERR_IRQ;
+	fd_writel(fdif->base, FDIF_IRQENABLE_CLR_j, conf);
+
+	dma_unmap_single(dev, fdif->work_dma,
+			WORK_MEM_SIZE, DMA_TO_DEVICE);
+}
+
+
+static int start_detect(struct fdif_dev *dev)
+{
+	struct fdif_qvga *fdif = dev_get_drvdata(dev->dev);
+
+	pm_runtime_get_sync(dev->dev);
+	fdif_global_init(fdif);
+
+	return  __submit_detection(fdif);
+}
+
+static int stop_detect(struct fdif_dev *dev)
+{
+	struct fdif_qvga *fdif = dev_get_drvdata(dev->dev);
+	unsigned long flags, irqsts;
+	struct fdif_buffer	*buf;
+
+	spin_lock_irqsave(&fdif->lock, flags);
+
+	/*stop current transfer first*/
+	__stop_detect(fdif);
+
+	buf = fdif->pending;
+	fdif->pending = NULL;
+
+	/*clear irq status in case that it is set*/
+	irqsts = fd_readl(fdif->base, FDIF_IRQSTATUS_j);
+	fd_writel(fdif->base, FDIF_IRQSTATUS_j, irqsts);
+
+	spin_unlock_irqrestore(&fdif->lock, flags);
+
+	if (buf)
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+
+	fdif_global_deinit(fdif);
+	pm_runtime_put(dev->dev);
+	return 0;
+}
+
+static int submit_detect(struct fdif_dev *dev)
+{
+	struct fdif_qvga *fdif = dev_get_drvdata(dev->dev);
+
+	__submit_detection(fdif);
+
+	return 0;
+}
+
+static struct fdif_ops qvga_ops = {
+	.table	= qvga_fmt,
+	.fmt_cnt = 1,
+	.start_detect = start_detect,
+	.stop_detect = stop_detect,
+	.submit_detect = submit_detect,
+};
+
+static int fdif_probe(struct platform_device *pdev)
+{
+	struct device	*dev = &pdev->dev;
+	struct fdif_qvga *fdif;
+	struct fdif_dev *fdev;
+	struct resource *res;
+	int ret, order;
+
+	ret = fdif_create_instance(dev, sizeof(struct fdif_qvga),
+			&qvga_ops, &fdev);
+	if (ret) {
+		dev_err(dev, "fdif_create_instance failed:%d\n", ret);
+		goto end_probe;
+	}
+
+	fdif = (struct fdif_qvga *)fdev->priv;
+	fdif->dev = fdev;
+
+	spin_lock_init(&fdif->lock);
+	fdif->pdev = pdev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "fdif get resource failed\n");
+		ret = -ENODEV;
+		goto err_iomap;
+	}
+
+	fdif->base = ioremap(res->start, resource_size(res));
+	if (!fdif->base) {
+		dev_err(dev, "fdif ioremap failed\n");
+		ret = -ENOMEM;
+		goto err_iomap;
+	}
+
+	fdif->irq = platform_get_irq(pdev, 0);
+	if (fdif->irq < 0) {
+		dev_err(dev, "fdif get irq failed\n");
+		ret = -ENODEV;
+		goto err_get_irq;
+	}
+
+	ret = request_irq(fdif->irq, handle_detection, 0, "fdif-qvga",
+			fdif);
+	if (ret) {
+		dev_err(dev, "request_irq failed:%d\n", ret);
+		goto err_get_irq;
+	}
+
+	order = get_order(WORK_MEM_SIZE);
+	fdif->work_mem_addr = (void *)__get_free_pages(GFP_KERNEL, order);
+	if (!fdif->work_mem_addr) {
+		dev_err(dev, "fdif buffer allocation(%d) failed\n", order);
+		ret = -ENOMEM;
+		goto err_work_mem;
+	}
+
+	install_default_setting(fdif);
+
+	platform_set_drvdata(pdev, fdif);
+
+	pm_suspend_ignore_children(dev, true);
+	pm_runtime_get_sync(dev);
+	dev_info(dev, "fdif version=%8x hwinfo=%08x\n",
+			fd_readl(fdif->base, FDIF_REVISION),
+			fd_readl(fdif->base, FDIF_HWINFO));
+	pm_runtime_put(dev);
+
+	return 0;
+
+err_work_mem:
+	free_irq(fdif->irq, fdif);
+err_get_irq:
+	iounmap(fdif->base);
+err_iomap:
+	kref_put(&fdif->dev->ref, fdif_release);
+end_probe:
+	return ret;
+}
+
+static int fdif_remove(struct platform_device *pdev)
+{
+	struct fdif_qvga *fdif = platform_get_drvdata(pdev);
+	int order;
+
+	platform_set_drvdata(pdev, NULL);
+
+	free_irq(fdif->irq, fdif);
+
+	order = get_order(WORK_MEM_SIZE);
+	free_pages((unsigned long)fdif->work_mem_addr, order);
+
+	iounmap(fdif->base);
+
+	kref_put(&fdif->dev->ref, fdif_release);
+
+	return 0;
+}
+
+static int fdif_suspend(struct platform_device *pdev, pm_message_t msg)
+{
+	return 0;
+}
+
+static int fdif_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_device_id fdif_device_ids[] = {
+	{.name = "fdif"},
+	{},
+};
+
+struct platform_driver fdif_driver = {
+	.probe =	fdif_probe,
+	.remove =	fdif_remove,
+	.suspend =	fdif_suspend,
+	.resume =	fdif_resume,
+	.driver = {
+		.name  =	"fdif",
+		.owner =	THIS_MODULE,
+	},
+	.id_table = 	fdif_device_ids,
+};
+
+static int __init omap4_fdif_init(void)
+{
+	int retval;
+	retval = platform_driver_register(&fdif_driver);
+	if (retval) {
+		printk(KERN_ERR "Unable to register fdif driver\n");
+		return retval;
+	}
+	return 0;
+}
+
+static void omap4_fdif_cleanup(void)
+{
+	platform_driver_unregister(&fdif_driver);
+}
+
+module_init(omap4_fdif_init);
+module_exit(omap4_fdif_cleanup);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:fdif");
+MODULE_AUTHOR("Ming Lei");
-- 
1.7.5.4

