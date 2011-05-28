Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1E1UZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 16:25:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57889 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1E1UZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 16:25:12 -0400
Date: Sat, 28 May 2011 22:24:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Josh Wu <josh.wu@atmel.com>
cc: mchehab@redhat.com, Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lars.haring@atmel.com, ryan@bluewatersys.com, arnd@arndb.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
In-Reply-To: <1306496329-14535-1-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1105281911230.6780@axis700.grange>
References: <1306496329-14535-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:dy1HLRg4PxQIx8qBm6+IshSLq1rIc4VF2c598Oo/Kax
 HyNGnaDJ+g1bdJQM9MhEy7lNehEb9tFX26QBtFUo5hP30cJxgN
 1zaedjV81LP06S03mgLzcz33CJzuVK13iuoMMmNHYir/R9BYmp
 F3ObusapJQ13UKIMMgryyVr7iYhkNq51Efpch0KRFYlB63pJKR
 s/v7ETKNn+FczLOkymRv2vJXOrsh6YbBHQ2Z/YdlZ8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh

Thanks for the update. A general note: I much prefer the new IO accessors 
and register names and values - thanks for changing that!

On Fri, 27 May 2011, Josh Wu wrote:

> This patch is to enable Atmel Image Sensor Interface (ISI) driver support.
> - Using soc-camera framework with videobuf2 dma-contig allocator
> - Supporting video streaming of YUV packed format
> - Tested on AT91SAM9M10G45-EK with OV2640
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> Modified in V2 patch:
> move isi head file to include/media/atmel-isi.h, which make it possible share with AVR32.
> remove bit manipulation macro.
> using static isi_readl/writel functions.
> add time out for all endless loop.
> add dependency of AT91 since this version is not compatiable with AVR32.
> remove still image capture code since soc-camera is not supported.
> remove KERNEL_VERSION.
> correct clock api using.
> other minor fix.
> 
>  drivers/media/video/Kconfig     |    8 +
>  drivers/media/video/Makefile    |    1 +
>  drivers/media/video/atmel-isi.c | 1076 +++++++++++++++++++++++++++++++++++++++
>  include/media/atmel-isi.h       |  125 +++++
>  4 files changed, 1210 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/atmel-isi.c
>  create mode 100644 include/media/atmel-isi.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index bb53de7..93d1098 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -952,6 +952,14 @@ config  VIDEO_SAMSUNG_S5P_FIMC
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called s5p-fimc.
>  
> +config VIDEO_ATMEL_ISI
> +	tristate "ATMEL Image Sensor Interface (ISI) support"
> +	depends on VIDEO_DEV && SOC_CAMERA && ARCH_AT91
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  This module makes the ATMEL Image Sensor Interface available
> +	  as a v4l2 device.
> +
>  config VIDEO_S5P_MIPI_CSIS
>  	tristate "Samsung S5P and EXYNOS4 MIPI CSI receiver driver"
>  	depends on VIDEO_V4L2 && PM_RUNTIME && PLAT_S5P && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index f0fecd6..d9833f4 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -166,6 +166,7 @@ obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
>  obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
> +obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
>  
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
>  
> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
> new file mode 100644
> index 0000000..1dcf34c
> --- /dev/null
> +++ b/drivers/media/video/atmel-isi.c
> @@ -0,0 +1,1076 @@
> +/*
> + * Copyright (c) 2011 Atmel Corporation
> + * Josh Wu, <josh.wu@atmel.com>
> + *
> + * Based on previous work by Lars Haring, <lars.haring@atmel.com>
> + * and Sedji Gaouaou
> + * Based on the bttv driver for Bt848 with respective copyright holders
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/completion.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>

You had <linux/module.h> here in "v1," I think, it is needed for various 
MODULE_AUTHOR() etc. macros. Please, re-add.

> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +
> +#include <mach/board.h>
> +#include <mach/cpu.h>

I still don't understand, why you need these two. If unneeded, please, 
remove.

> +
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/soc_camera.h>
> +#include <media/soc_mediabus.h>
> +#include <media/atmel-isi.h>

Alphabetic order here too, please.

> +
> +#define MAX_BUFFER_NUMS			32

"NUM" above doesn't need an "S" at the end - it's just a "number of 
buffers," not "numbers."

> +#define MAX_SUPPORT_WIDTH		2048
> +#define MAX_SUPPORT_HEIGHT		2048
> +#define VID_LIMIT_BYTES			(16 * 1024 * 1024)
> +#define MIN_FRAME_RATE			15
> +#define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
> +
> +/* ISI states */
> +enum {
> +	ISI_STATE_IDLE = 0,
> +	ISI_STATE_READY,
> +	ISI_STATE_WAIT_SOF,
> +};
> +
> +/* Frame buffer descriptor */
> +struct fbd {
> +	/* Physical address of the frame buffer */
> +	u32 fb_address;
> +	/* DMA Control Register(only in HISI2) */
> +	u32 dma_ctrl;

Ok, several reviewers, including myself, asked you to remove #ifdef here, 
but at least I didn't realise at that moment, that this struct describes 
hareware-specific memory layout. So, how is it supposed to work now on 
platforms, that don't have this field, i.e., !CONFIG_ARCH_AT91SAM9G45 and 
!CONFIG_ARCH_AT91SAM9X5? Or are they not supported yet? Maybe you could 
define two structs - later, when you also support other CPUs, and use a 
union or something else?

> +	/* Physical address of the next fbd */
> +	u32 next_fbd_address;
> +};
> +
> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl)
> +{
> +	fb_desc->dma_ctrl = ctrl;
> +}
> +
> +/* Frame buffer data */
> +struct frame_buffer {
> +	struct vb2_buffer vb;
> +	struct fbd *p_fb_desc;
> +	u32 fb_desc_phys;
> +	struct list_head list;
> +};
> +
> +struct atmel_isi {
> +	/* Protects the access of variables shared with the ISR */
> +	spinlock_t			lock;
> +	void __iomem			*regs;
> +
> +	int				sequence;
> +	/* State of the ISI module in capturing mode */
> +	int				state;
> +
> +	/* Capture/streaming wait queue for waiting for SOF */
> +	wait_queue_head_t		capture_wq;
> +
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +
> +	/* Allocate descriptors for dma buffer use */
> +	struct fbd			*p_fb_descriptors;
> +	u32				fb_descriptors_phys;
> +	int				index_fb_desc;
> +
> +	struct completion		isi_complete;

You don't need to prefix members in structs, especially since you don't do 
this with others. Just leave "complete" or something similar.

> +	struct clk			*pclk;
> +	unsigned int			irq;
> +
> +	struct isi_platform_data	*pdata;
> +	unsigned long			platform_flags;
> +
> +	struct list_head		video_buffer_list;
> +	struct frame_buffer		*active;
> +
> +	struct soc_camera_device	*icd;
> +	struct soc_camera_host		soc_host;
> +};
> +
> +static void isi_writel(struct atmel_isi *isi, u32 reg, u32 val)
> +{
> +	writel(val, isi->regs + reg);
> +}
> +static u32 isi_readl(struct atmel_isi *isi, u32 reg)
> +{
> +	return readl(isi->regs + reg);
> +}
> +
> +static int configure_geometry(struct atmel_isi *isi, u32 width,
> +			u32 height, enum v4l2_mbus_pixelcode code)
> +{
> +	u32 cfg2, cr;
> +
> +	switch (code) {
> +	/* YUV, including grey */
> +	case V4L2_MBUS_FMT_Y8_1X8:
> +		cr = ISI_CFG2_GRAYSCALE;
> +		break;
> +	case V4L2_MBUS_FMT_UYVY8_2X8:
> +		cr = ISI_CFG2_YCC_SWAP_MODE_3;
> +		break;
> +	case V4L2_MBUS_FMT_VYUY8_2X8:
> +		cr = ISI_CFG2_YCC_SWAP_MODE_2;
> +		break;
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		cr = ISI_CFG2_YCC_SWAP_MODE_1;
> +		break;
> +	case V4L2_MBUS_FMT_YVYU8_2X8:
> +		cr = ISI_CFG2_YCC_SWAP_DEFAULT;
> +		break;
> +	/* RGB, TODO */
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> +
> +	cfg2 = isi_readl(isi, ISI_CFG2);
> +	cfg2 |= cr;
> +	/* Set width */
> +	cfg2 &= ~(ISI_CFG2_IM_HSIZE_MASK);
> +	cfg2 |= ((width - 1) << ISI_CFG2_IM_HSIZE_OFFSET) &
> +			ISI_CFG2_IM_HSIZE_MASK;
> +	/* Set height */
> +	cfg2 &= ~(ISI_CFG2_IM_VSIZE_MASK);
> +	cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
> +			& ISI_CFG2_IM_VSIZE_MASK;
> +	isi_writel(isi, ISI_CFG2, cfg2);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
> +{
> +	if (isi->active) {
> +		struct vb2_buffer *vb = &isi->active->vb;
> +		struct frame_buffer *buf = isi->active;
> +
> +		list_del_init(&buf->list);
> +		do_gettimeofday(&vb->v4l2_buf.timestamp);
> +		vb->v4l2_buf.sequence = isi->sequence++;
> +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +	}
> +
> +	if (list_empty(&isi->video_buffer_list)) {
> +		isi->active = NULL;
> +	} else {
> +		/* start next dma frame. */
> +		isi->active = list_entry(isi->video_buffer_list.next,
> +					struct frame_buffer, list);
> +		isi_writel(isi, ISI_DMA_C_DSCR, isi->active->fb_desc_phys);
> +		isi_writel(isi, ISI_DMA_C_CTRL,
> +			ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
> +		isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +/* ISI interrupt service routine */
> +static irqreturn_t isi_interrupt(int irq, void *dev_id)
> +{
> +	struct atmel_isi *isi = dev_id;
> +	u32 status, mask, pending;
> +	irqreturn_t ret = IRQ_NONE;
> +
> +	spin_lock(&isi->lock);
> +
> +	status = isi_readl(isi, ISI_STATUS);
> +	mask = isi_readl(isi, ISI_INTMASK);
> +	pending = status & mask;
> +
> +	if (pending & ISI_CTRL_SRST) {
> +		complete(&isi->isi_complete);
> +		isi_writel(isi, ISI_INTDIS, ISI_CTRL_SRST);
> +		ret = IRQ_HANDLED;
> +	}
> +	if (pending & ISI_CTRL_DIS) {
> +		complete(&isi->isi_complete);
> +		isi_writel(isi, ISI_INTDIS, ISI_CTRL_DIS);
> +		ret = IRQ_HANDLED;
> +	}
> +
> +	if (pending & ISI_SR_VSYNC) {
> +		switch (isi->state) {
> +		case ISI_STATE_IDLE:
> +			isi->state = ISI_STATE_READY;
> +			wake_up_interruptible(&isi->capture_wq);
> +			break;
> +		}
> +	} else if (likely(pending & ISI_SR_CXFR_DONE)) {
> +		ret = atmel_isi_handle_streaming(isi);
> +	}
> +
> +	spin_unlock(&isi->lock);
> +
> +	return ret;
> +}
> +
> +#define	WAIT_ISI_RESET		1
> +#define	WAIT_ISI_DISABLE	0
> +static int atmel_isi_wait_status(int wait_reset, struct atmel_isi *isi)
> +{
> +	unsigned long timeout;
> +	/*
> +	 * The reset or disable will only succeed if we have a
> +	 * pixel clock from the camera.
> +	 */
> +	init_completion(&isi->isi_complete);
> +
> +	if (wait_reset) {
> +		isi_writel(isi, ISI_INTEN, ISI_CTRL_SRST);
> +		isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
> +	} else {
> +		isi_writel(isi, ISI_INTEN, ISI_CTRL_DIS);
> +		isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> +	}
> +
> +	timeout = wait_for_completion_timeout(&isi->isi_complete,
> +			msecs_to_jiffies(100));
> +	if (timeout == 0)
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +/* ------------------------------------------------------------------
> +	Videobuf operations
> +   ------------------------------------------------------------------*/
> +static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> +				unsigned int *nplanes, unsigned long sizes[],
> +				void *alloc_ctxs[])
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	unsigned long size;
> +	int ret, bytes_per_line;
> +
> +	/* Reset ISI */
> +	ret = atmel_isi_wait_status(WAIT_ISI_RESET, isi);
> +	if (ret < 0) {
> +		dev_err(icd->dev.parent, "Reset ISI timed out\n");
> +		return ret;
> +	}
> +	/* Disable all interrupts */
> +	isi_writel(isi, ISI_INTDIS, ~0UL);
> +
> +	bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +						icd->current_fmt->host_fmt);
> +
> +	if (bytes_per_line < 0)
> +		return bytes_per_line;
> +
> +	size = bytes_per_line * icd->user_height;
> +
> +	if (*nbuffers == 0)
> +		*nbuffers = MAX_BUFFER_NUMS;
> +	if (*nbuffers > MAX_BUFFER_NUMS)
> +		*nbuffers = MAX_BUFFER_NUMS;
> +
> +	if (size * *nbuffers > VID_LIMIT_BYTES)
> +		*nbuffers = VID_LIMIT_BYTES / size;
> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +	alloc_ctxs[0] = isi->alloc_ctx;
> +
> +	isi->sequence = 0;
> +	isi->active = NULL;
> +
> +	dev_dbg(icd->dev.parent, "%s, count=%d, size=%ld\n", __func__,
> +		*nbuffers, size);
> +
> +	return 0;
> +}
> +
> +static int buffer_init(struct vb2_buffer *vb)
> +{
> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
> +
> +	buf->p_fb_desc = NULL;
> +	buf->fb_desc_phys = 0;
> +	INIT_LIST_HEAD(&buf->list);
> +
> +	return 0;
> +}
> +
> +static int buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	unsigned long size;
> +	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +						icd->current_fmt->host_fmt);
> +
> +	if (bytes_per_line < 0)
> +		return bytes_per_line;
> +
> +	size = bytes_per_line * icd->user_height;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		dev_err(icd->dev.parent, "%s data will not fit into plane (%lu < %lu)\n",
> +				__func__, vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(&buf->vb, 0, size);
> +
> +	if (!buf->p_fb_desc) {
> +		/* Initialize the dma descriptor */
> +		buf->p_fb_desc = &isi->p_fb_descriptors[isi->index_fb_desc];
> +		buf->fb_desc_phys = isi->fb_descriptors_phys +
> +				isi->index_fb_desc * sizeof(struct fbd);
> +
> +		buf->p_fb_desc->fb_address = vb2_dma_contig_plane_paddr(vb, 0);
> +		buf->p_fb_desc->next_fbd_address = 0;
> +		set_dma_ctrl(buf->p_fb_desc, ISI_DMA_CTRL_WB);
> +		isi->index_fb_desc++;
> +		if (isi->index_fb_desc > MAX_BUFFER_NUMS) {
> +			dev_err(icd->dev.parent, "Not enough dma descriptors.\n");

Don't you have to check overflow _before_ using the index? Pointing the 
hardware to an invalid location doesn't seem like a very good idea.

> +			return -EINVAL;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void buffer_cleanup(struct vb2_buffer *vb)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&isi->lock, flags);
> +	if (buf->p_fb_desc) {
> +		buf->p_fb_desc = NULL;
> +		buf->fb_desc_phys = 0;
> +		isi->index_fb_desc--;
> +		if (isi->index_fb_desc < 0)
> +			dev_err(icd->dev.parent, "Invalid descriptors index.\n");

...and this would break, if you start initialising and cleaning up buffers 
out of order. Maybe you could just extend your private data

struct isi_dmadesc {
	struct list_head	list;
	struct fbd		*fbd;
};

struct atmel_isi {
	...
	struct list_head	dmadesc_head;
	struct isi_dmadesc	dmadesc[MAX_BUFFER_NUM];
};

and then in your atmel_isi_probe()

	kzalloc(...);
	dma_alloc_coherent(...);
	for (i = 0; i < MAX_BUFFER_NUM; i++) {
		isi->dmadesc[i].fbd = isi->p_fb_descriptors + i;
		list_add(&isi->dmadesc[i].list, &isi->dmadesc_head);
	}

etc.

> +	}
> +	spin_unlock_irqrestore(&isi->lock, flags);
> +}
> +
> +static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
> +{
> +	u32 ctrl, cfg1;
> +
> +	cfg1 = isi_readl(isi, ISI_CFG1);
> +	/* Enable irq: cxfr for the codec path, pxfr for the preview path */
> +	isi_writel(isi, ISI_INTEN,
> +			ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
> +
> +	/* Check if already in a frame */
> +	if (isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) {
> +		dev_err(isi->icd->dev.parent, "Already in frame handling.\n");
> +		return;
> +	}
> +
> +	isi_writel(isi, ISI_DMA_C_DSCR, buffer->fb_desc_phys);
> +	isi_writel(isi, ISI_DMA_C_CTRL, ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
> +	isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
> +
> +	/* Enable linked list */
> +	cfg1 |= isi->pdata->frate | ISI_CFG1_DISCR;
> +
> +	/* Enable codec path and ISI */
> +	ctrl = ISI_CTRL_CDC | ISI_CTRL_EN;
> +	isi_writel(isi, ISI_CTRL, ctrl);
> +	isi_writel(isi, ISI_CFG1, cfg1);
> +}
> +
> +static void buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
> +	unsigned long flags = 0;
> +
> +	spin_lock_irqsave(&isi->lock, flags);
> +	list_add_tail(&buf->list, &isi->video_buffer_list);
> +
> +	if (isi->active == NULL) {
> +		isi->active = buf;
> +		start_dma(isi, buf);
> +	}
> +	spin_unlock_irqrestore(&isi->lock, flags);
> +}
> +
> +static int start_streaming(struct vb2_queue *vq)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +
> +	u32 sr = 0;
> +	int ret;
> +
> +	spin_lock_irq(&isi->lock);
> +	isi->state = ISI_STATE_IDLE;
> +
> +	/* Clear any pending SOF interrupt */
> +	sr = isi_readl(isi, ISI_STATUS);
> +	/* Enable VSYNC interrupt for SOF */
> +	isi_writel(isi, ISI_INTEN, ISI_SR_VSYNC);
> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_EN);
> +
> +	spin_unlock_irq(&isi->lock);
> +	dev_dbg(icd->dev.parent, "Waiting for SOF\n");
> +	ret = wait_event_interruptible(isi->capture_wq,
> +				       isi->state != ISI_STATE_IDLE);
> +	if (ret)
> +		return ret;
> +
> +	if (isi->state != ISI_STATE_READY)
> +		return -EIO;
> +
> +	spin_lock_irq(&isi->lock);
> +	isi->state = ISI_STATE_WAIT_SOF;
> +	isi_writel(isi, ISI_INTDIS, ISI_SR_VSYNC);
> +	spin_unlock_irq(&isi->lock);
> +
> +	return 0;
> +}
> +
> +/* abort streaming and wait for last buffer */
> +static int stop_streaming(struct vb2_queue *vq)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	struct list_head *pos, *node;
> +	struct frame_buffer *buf;
> +	int ret = 0;
> +	unsigned long timeout;
> +
> +	spin_lock_irq(&isi->lock);
> +	isi->active = NULL;
> +	/* Release all active buffers */
> +	list_for_each_safe(pos, node, &isi->video_buffer_list) {
> +		buf = list_entry(pos, struct frame_buffer, list);
> +		list_del_init(&buf->list);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);

list_for_entry_safe() would be even better;)

> +	}
> +	spin_unlock_irq(&isi->lock);
> +
> +	timeout = jiffies + FRAME_INTERVAL_MILLI_SEC * HZ;
> +	/* Wait until the end of the current frame. */
> +	while ((isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) &&
> +			time_before(jiffies, timeout))
> +		msleep(1);
> +
> +	if (time_after(jiffies, timeout)) {
> +		dev_err(icd->dev.parent,
> +			"Timeout waiting for finishing codec request\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	/* Disable interrupts */
> +	isi_writel(isi, ISI_INTDIS,
> +			ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
> +
> +	/* Disable ISI and wait for it is done */
> +	ret = atmel_isi_wait_status(WAIT_ISI_DISABLE, isi);
> +	if (ret < 0)
> +		dev_err(icd->dev.parent, "Disable ISI timed out\n");
> +
> +	return ret;
> +}
> +
> +static struct vb2_ops isi_video_qops = {
> +	.queue_setup		= queue_setup,
> +	.buf_init		= buffer_init,
> +	.buf_prepare		= buffer_prepare,
> +	.buf_cleanup		= buffer_cleanup,
> +	.buf_queue		= buffer_queue,
> +	.start_streaming	= start_streaming,
> +	.stop_streaming		= stop_streaming,
> +	.wait_prepare		= soc_camera_unlock,
> +	.wait_finish		= soc_camera_lock,
> +};
> +
> +/* ------------------------------------------------------------------
> +	SOC camera operations for the device
> +   ------------------------------------------------------------------*/
> +static int isi_camera_init_videobuf(struct vb2_queue *q,
> +				     struct soc_camera_device *icd)
> +{
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP;
> +	q->drv_priv = icd;
> +	q->buf_struct_size = sizeof(struct frame_buffer);
> +	q->ops = &isi_video_qops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +
> +	return vb2_queue_init(q);
> +}
> +
> +static int isi_camera_set_fmt(struct soc_camera_device *icd,
> +			      struct v4l2_format *f)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	const struct soc_camera_format_xlate *xlate;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct v4l2_mbus_framefmt mf;
> +	int ret;
> +
> +	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
> +	if (!xlate) {
> +		dev_warn(icd->dev.parent, "Format %x not found\n",
> +			 pix->pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(icd->dev.parent, "Plan to set format %dx%d\n",
> +			pix->width, pix->height);
> +
> +	mf.width	= pix->width;
> +	mf.height	= pix->height;
> +	mf.field	= pix->field;
> +	mf.colorspace	= pix->colorspace;
> +	mf.code		= xlate->code;
> +
> +	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (mf.code != xlate->code)
> +		return -EINVAL;
> +
> +	ret = configure_geometry(isi, pix->width, pix->height, xlate->code);
> +	if (ret < 0)
> +		return ret;
> +
> +	pix->width		= mf.width;
> +	pix->height		= mf.height;
> +	pix->field		= mf.field;
> +	pix->colorspace		= mf.colorspace;
> +	icd->current_fmt	= xlate;
> +
> +	dev_dbg(icd->dev.parent, "Finally set format %dx%d\n",
> +		pix->width, pix->height);
> +
> +	return ret;
> +}
> +
> +static int isi_camera_try_fmt(struct soc_camera_device *icd,
> +			      struct v4l2_format *f)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	const struct soc_camera_format_xlate *xlate;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct v4l2_mbus_framefmt mf;
> +	u32 pixfmt = pix->pixelformat;
> +	int ret;
> +
> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +	if (pixfmt && !xlate) {
> +		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
> +		return -EINVAL;
> +	}
> +
> +	/* limit to Atmel ISI hardware capabilities */
> +	if (pix->height > MAX_SUPPORT_HEIGHT)
> +		pix->height = MAX_SUPPORT_HEIGHT;
> +	if (pix->width > MAX_SUPPORT_WIDTH)
> +		pix->width = MAX_SUPPORT_WIDTH;
> +
> +	/* limit to sensor capabilities */
> +	mf.width	= pix->width;
> +	mf.height	= pix->height;
> +	mf.field	= pix->field;
> +	mf.colorspace	= pix->colorspace;
> +	mf.code		= xlate->code;
> +
> +	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
> +	if (ret < 0)
> +		return ret;
> +
> +	pix->width	= mf.width;
> +	pix->height	= mf.height;
> +	pix->colorspace	= mf.colorspace;
> +
> +	switch (mf.field) {
> +	case V4L2_FIELD_ANY:
> +		pix->field = V4L2_FIELD_NONE;
> +		break;
> +	case V4L2_FIELD_NONE:
> +		break;
> +	default:
> +		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
> +			mf.field);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct soc_mbus_pixelfmt isi_camera_formats[] = {
> +	{
> +		.fourcc			= V4L2_PIX_FMT_YUYV,
> +		.name			= "Packed YUV422 16 bit",
> +		.bits_per_sample	= 8,
> +		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +};
> +
> +/* This will be corrected as we get more formats */
> +static bool isi_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
> +{
> +	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
> +		(fmt->bits_per_sample == 8 &&
> +		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
> +		(fmt->bits_per_sample > 8 &&
> +		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
> +}
> +
> +static unsigned long make_bus_param(struct atmel_isi *isi)
> +{
> +	unsigned long flags;
> +	/*
> +	 * Platform specified synchronization and pixel clock polarities are
> +	 * only a recommendation and are only used during probing. Atmel ISI
> +	 * camera interface only works in master mode, i.e., uses HSYNC and
> +	 * VSYNC signals from the sensor
> +	 */
> +	flags = SOCAM_MASTER |
> +		SOCAM_HSYNC_ACTIVE_HIGH |
> +		SOCAM_HSYNC_ACTIVE_LOW |
> +		SOCAM_VSYNC_ACTIVE_HIGH |
> +		SOCAM_VSYNC_ACTIVE_LOW |
> +		SOCAM_PCLK_SAMPLE_RISING |
> +		SOCAM_PCLK_SAMPLE_FALLING |
> +		SOCAM_DATA_ACTIVE_HIGH;
> +
> +	if (isi->platform_flags & ISI_DATAWIDTH_10)
> +		flags |= SOCAM_DATAWIDTH_10;
> +
> +	if (isi->platform_flags & ISI_DATAWIDTH_8)
> +		flags |= SOCAM_DATAWIDTH_8;
> +
> +	if (flags & SOCAM_DATAWIDTH_MASK)
> +		return flags;
> +
> +	return 0;
> +}
> +
> +static int isi_camera_try_bus_param(struct soc_camera_device *icd,
> +				    unsigned char buswidth)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	unsigned long camera_flags;
> +	int ret;
> +
> +	camera_flags = icd->ops->query_bus_param(icd);
> +	ret = soc_camera_bus_param_compatible(camera_flags,
> +					make_bus_param(isi));
> +	if (!ret)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +
> +static int isi_camera_get_formats(struct soc_camera_device *icd,
> +				  unsigned int idx,
> +				  struct soc_camera_format_xlate *xlate)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	int formats = 0, ret;
> +	/* sensor format */
> +	enum v4l2_mbus_pixelcode code;
> +	/* soc camera host format */
> +	const struct soc_mbus_pixelfmt *fmt;
> +
> +	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
> +	if (ret < 0)
> +		/* No more formats */
> +		return 0;
> +
> +	fmt = soc_mbus_get_fmtdesc(code);
> +	if (!fmt) {
> +		dev_err(icd->dev.parent,
> +			"Invalid format code #%u: %d\n", idx, code);
> +		return 0;
> +	}
> +
> +	/* This also checks support for the requested bits-per-sample */
> +	ret = isi_camera_try_bus_param(icd, fmt->bits_per_sample);
> +	if (ret < 0) {
> +		dev_err(icd->dev.parent,
> +			"Fail to try the bus parameters.\n");
> +		return 0;
> +	}
> +
> +	switch (code) {
> +	case V4L2_MBUS_FMT_UYVY8_2X8:
> +	case V4L2_MBUS_FMT_VYUY8_2X8:
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +	case V4L2_MBUS_FMT_YVYU8_2X8:
> +		formats++;
> +		if (xlate) {
> +			xlate->host_fmt	= &isi_camera_formats[0];
> +			xlate->code	= code;
> +			xlate++;
> +			dev_dbg(icd->dev.parent, "Providing format %s using code %d\n",
> +				isi_camera_formats[0].name, code);
> +		}
> +		break;
> +	default:
> +		if (!isi_camera_packing_supported(fmt))
> +			return 0;
> +		if (xlate)
> +			dev_dbg(icd->dev.parent,
> +				"Providing format %s in pass-through mode\n",
> +				fmt->name);
> +	}
> +
> +	/* Generic pass-through */
> +	formats++;
> +	if (xlate) {
> +		xlate->host_fmt	= fmt;
> +		xlate->code	= code;
> +		xlate++;
> +	}
> +
> +	return formats;
> +}
> +
> +/* Called with .video_lock held */
> +static int isi_camera_add_device(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +
> +	if (isi->icd)
> +		return -EBUSY;
> +
> +	if (clk_enable(isi->pclk))
> +		return -EIO;

Better propagate error code from clk_enable().

> +
> +	isi->icd = icd;
> +	dev_dbg(icd->dev.parent, "Atmel ISI Camera driver attached to camera %d\n",
> +		 icd->devnum);
> +	return 0;
> +}
> +/* Called with .video_lock held */
> +static void isi_camera_remove_device(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +
> +	BUG_ON(icd != isi->icd);
> +
> +	clk_disable(isi->pclk);
> +	isi->icd = NULL;
> +
> +	dev_dbg(icd->dev.parent, "Atmel ISI Camera driver detached from camera %d\n",
> +		 icd->devnum);
> +}
> +
> +static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
> +{
> +	struct soc_camera_device *icd = file->private_data;
> +
> +	return vb2_poll(&icd->vb2_vidq, file, pt);
> +}
> +
> +static int isi_camera_querycap(struct soc_camera_host *ici,
> +			       struct v4l2_capability *cap)
> +{
> +	strcpy(cap->driver, "atmel-isi");
> +	strcpy(cap->card, "Atmel Image Sensor Interface");
> +	cap->capabilities = (V4L2_CAP_VIDEO_CAPTURE |
> +				V4L2_CAP_STREAMING);
> +	return 0;
> +}
> +
> +static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	unsigned long bus_flags, camera_flags, common_flags;
> +	int hsync_act_low, vsync_act_low, pclk_act_falling;
> +	int ret;
> +	u32 cfg1 = 0;
> +
> +	camera_flags = icd->ops->query_bus_param(icd);
> +
> +	bus_flags = make_bus_param(isi);
> +	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
> +	dev_dbg(icd->dev.parent, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
> +		camera_flags, bus_flags, common_flags);
> +	if (!common_flags)
> +		return -EINVAL;

Below seems overengineered;) In general, I think, your ISI controller 
supports both active low and high HSYNC and VSYNC and falling and rising 
PCLK. That's what your make_bus_param() is suggesting and those are the 
flags, that you send to the client. On top of that your platform data 
flags hsync_act_low, vsync_act_low, and pclk_act_falling are only 
recommendations for ambiguous cases, when the client also supports both 
polarities, right? Otherwise, if the client only supports, say, PCLK 
rising, it has precedence over the platform preference. Now, below you do 
something different

> +
> +	/* Make choises, based on platform preferences */
> +	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
> +		if (isi->pdata->hsync_act_low)
> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
> +		else
> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
> +	}
> +
> +	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
> +		if (isi->pdata->vsync_act_low)
> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
> +		else
> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
> +	}
> +
> +	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
> +	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
> +		if (isi->pdata->pclk_act_falling)
> +			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
> +		else
> +			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
> +	}

The three constructs above _already_ select all three polarities in the 
optimal way - in ambiguous cases they use platform preferences to select 
one of the two polarities. Now, all you need to do is use your 
common_flags to configure the ISI:

> +
> +	ret = icd->ops->set_bus_param(icd, common_flags);
> +	if (ret < 0) {
> +		dev_dbg(icd->dev.parent, "Camera set_bus_param(%lx) returned %d\n",
> +			common_flags, ret);
> +		return ret;
> +	}
> +
> +	/* set bus param for ISI */
> +	hsync_act_low = isi->pdata->hsync_act_low;
> +	vsync_act_low = isi->pdata->vsync_act_low;
> +	pclk_act_falling = isi->pdata->pclk_act_falling;

These variables are not needed at all.

> +
> +	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
> +		hsync_act_low = 1;
> +	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
> +		vsync_act_low = 1;
> +	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
> +		pclk_act_falling = 1;
> +
> +	if (hsync_act_low)
> +		cfg1 |= ISI_CFG1_HSYNC_POL_ACTIVE_LOW;

This should become

+	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
+		cfg1 |= ISI_CFG1_HSYNC_POL_ACTIVE_LOW;

similar for the other two.

> +	if (vsync_act_low)
> +		cfg1 |= ISI_CFG1_VSYNC_POL_ACTIVE_LOW;
> +	if (pclk_act_falling)
> +		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
> +	if (isi->pdata->has_emb_sync)
> +		cfg1 |= ISI_CFG1_EMB_SYNC;
> +	if (isi->pdata->isi_full_mode)
> +		cfg1 |= ISI_CFG1_FULL_MODE;
> +
> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> +	isi_writel(isi, ISI_CFG1, cfg1);
> +
> +	return 0;
> +}
> +
> +static struct soc_camera_host_ops isi_soc_camera_host_ops = {
> +	.owner		= THIS_MODULE,
> +	.add		= isi_camera_add_device,
> +	.remove		= isi_camera_remove_device,
> +	.set_fmt	= isi_camera_set_fmt,
> +	.try_fmt	= isi_camera_try_fmt,
> +	.get_formats	= isi_camera_get_formats,
> +	.init_videobuf2	= isi_camera_init_videobuf,
> +	.poll		= isi_camera_poll,
> +	.querycap	= isi_camera_querycap,
> +	.set_bus_param	= isi_camera_set_bus_param,
> +};
> +
> +/* -----------------------------------------------------------------------*/
> +static int __exit atmel_isi_remove(struct platform_device *pdev)

__devexit

> +{
> +	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
> +	struct atmel_isi *isi = container_of(soc_host,
> +					struct atmel_isi, soc_host);
> +
> +	soc_camera_host_unregister(soc_host);
> +	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
> +	dma_free_coherent(&pdev->dev,
> +			sizeof(struct fbd) * MAX_BUFFER_NUMS,
> +			isi->p_fb_descriptors,
> +			isi->fb_descriptors_phys);
> +
> +	free_irq(isi->irq, isi);
> +	iounmap(isi->regs);
> +	clk_put(isi->pclk);
> +	kfree(isi);
> +
> +	return 0;
> +}
> +
> +static int __devinit atmel_isi_probe(struct platform_device *pdev)
> +{
> +	unsigned int irq;
> +	struct atmel_isi *isi;
> +	struct clk *pclk;
> +	struct resource *regs;
> +	int ret;
> +	struct device *dev = &pdev->dev;
> +	struct isi_platform_data *pdata;
> +	struct soc_camera_host *soc_host;
> +	static struct isi_platform_data isi_default_data;
> +
> +	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!regs)
> +		return -ENXIO;
> +
> +	pclk = clk_get(&pdev->dev, "isi_clk");
> +	if (IS_ERR(pclk))
> +		return PTR_ERR(pclk);
> +
> +	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
> +	if (!isi) {
> +		ret = -ENOMEM;
> +		dev_err(&pdev->dev, "Can't allocate interface!\n");
> +		goto err_alloc_isi;
> +	}
> +
> +	isi->pclk = pclk;
> +
> +	spin_lock_init(&isi->lock);
> +	init_waitqueue_head(&isi->capture_wq);
> +
> +	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
> +				sizeof(struct fbd) * MAX_BUFFER_NUMS,
> +				&isi->fb_descriptors_phys,
> +				GFP_KERNEL);
> +	if (!isi->p_fb_descriptors) {
> +		ret = -ENOMEM;
> +		dev_err(&pdev->dev, "Can't allocate descriptors!\n");
> +		goto err_alloc_descriptors;
> +	}
> +	isi->index_fb_desc = 0;
> +
> +	isi->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(isi->alloc_ctx)) {
> +		ret = PTR_ERR(isi->alloc_ctx);
> +		goto err_alloc_ctx;
> +	}
> +
> +	isi->regs = ioremap(regs->start, resource_size(regs));
> +	if (!isi->regs) {
> +		ret = -ENOMEM;
> +		goto err_ioremap;
> +	}
> +
> +	if (dev->platform_data) {
> +		pdata = (struct isi_platform_data *) dev->platform_data;

superfluous cast

> +	} else {
> +		/* Set default ISI platform data */
> +		isi_default_data.frate		= ISI_CFG1_FRATE_CAPTURE_ALL;
> +		isi_default_data.has_emb_sync	= 0;
> +		isi_default_data.emb_crc_sync	= 0;
> +		isi_default_data.hsync_act_low	= 0;
> +		isi_default_data.vsync_act_low	= 0;
> +		isi_default_data.pclk_act_falling = 0;
> +		isi_default_data.isi_full_mode	= 1;
> +		isi_default_data.data_width_flags = ISI_DATAWIDTH_8 |
> +				ISI_DATAWIDTH_10;

Well, I don't like it. Let's put it straight: please, remove this default 
platform data and make platform data compulsory. I don't think we're 
asking too much from platform developers with this. Maybe Oopsing without 
platform data, like some drivers do, is not very nice, but we can 
definitely just bail out with an error.

> +
> +		pdata = &isi_default_data;
> +		dev_info(&pdev->dev,
> +			"No config available using default values\n");
> +	}
> +
> +	isi->pdata = pdata;
> +	isi->platform_flags = pdata->data_width_flags;
> +	if (isi->platform_flags == 0)
> +		isi->platform_flags = ISI_DATAWIDTH_8;

Same here. Datawidth is only known to the platform, so, it _must_ be set. 
And you don't need this extra field isi->platform_flags - you have the 
complete pdata always with you.

> +
> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		ret = irq;
> +		goto err_req_irq;
> +	}
> +
> +	ret = request_irq(irq, isi_interrupt, 0, "isi", isi);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
> +		goto err_req_irq;
> +	}
> +	isi->irq = irq;
> +
> +	INIT_LIST_HEAD(&isi->video_buffer_list);
> +	isi->active = NULL;
> +
> +	soc_host		= &isi->soc_host;
> +	soc_host->drv_name	= "isi-camera";
> +	soc_host->ops		= &isi_soc_camera_host_ops;
> +	soc_host->priv		= isi;
> +	soc_host->v4l2_dev.dev	= &pdev->dev;
> +	soc_host->nr		= pdev->id;
> +
> +	ret = soc_camera_host_register(soc_host);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to register soc camera host\n");
> +		goto err_register_soc_camera_host;
> +	}
> +	return 0;
> +
> +err_register_soc_camera_host:
> +	free_irq(isi->irq, isi);
> +err_req_irq:
> +	iounmap(isi->regs);
> +err_ioremap:
> +	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
> +err_alloc_ctx:
> +	dma_free_coherent(&pdev->dev,
> +			sizeof(struct fbd) * MAX_BUFFER_NUMS,
> +			isi->p_fb_descriptors,
> +			isi->fb_descriptors_phys);
> +err_alloc_descriptors:
> +	kfree(isi);
> +err_alloc_isi:
> +	clk_put(isi->pclk);
> +
> +	return ret;
> +}
> +
> +static struct platform_driver atmel_isi_driver = {
> +	.probe		= atmel_isi_probe,
> +	.remove		= __exit_p(atmel_isi_remove),

__devexit_p()

> +	.driver		= {
> +		.name = "atmel_isi",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init atmel_isi_init_module(void)
> +{
> +	return  platform_driver_probe(&atmel_isi_driver, &atmel_isi_probe);
> +}
> +
> +static void __exit atmel_isi_exit(void)
> +{
> +	platform_driver_unregister(&atmel_isi_driver);
> +}
> +module_init(atmel_isi_init_module);
> +module_exit(atmel_isi_exit);
> +
> +MODULE_AUTHOR("Josh Wu <josh.wu@atmel.com>");
> +MODULE_DESCRIPTION("The V4L2 driver for Atmel Linux");
> +MODULE_LICENSE("GPL");
> +MODULE_SUPPORTED_DEVICE("video");
> diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
> new file mode 100644
> index 0000000..f09e7ab
> --- /dev/null
> +++ b/include/media/atmel-isi.h
> @@ -0,0 +1,125 @@
> +/*
> + * Register definitions for the Atmel Image Sensor Interface.
> + *
> + * Copyright (C) 2011 Atmel Corporation
> + * Josh Wu, <josh.wu@atmel.com>
> + *
> + * Based on previous work by Lars Haring, <lars.haring@atmel.com>
> + * and Sedji Gaouaou
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __ATMEL_ISI_H__
> +#define __ATMEL_ISI_H__
> +
> +#include <linux/types.h>
> +
> +/* ISI_V2 register offsets */
> +#define ISI_CFG1				0x0000
> +#define ISI_CFG2				0x0004
> +#define ISI_PSIZE				0x0008
> +#define ISI_PDECF				0x000c
> +#define ISI_Y2R_SET0				0x0010
> +#define ISI_Y2R_SET1				0x0014
> +#define ISI_R2Y_SET0				0x0018
> +#define ISI_R2Y_SET1				0x001C
> +#define ISI_R2Y_SET2				0x0020
> +#define ISI_CTRL				0x0024
> +#define ISI_STATUS				0x0028
> +#define ISI_INTEN				0x002C
> +#define ISI_INTDIS				0x0030
> +#define ISI_INTMASK				0x0034
> +#define ISI_DMA_CHER				0x0038
> +#define ISI_DMA_CHDR				0x003C
> +#define ISI_DMA_CHSR				0x0040
> +#define ISI_DMA_P_ADDR			0x0044
> +#define ISI_DMA_P_CTRL			0x0048
> +#define ISI_DMA_P_DSCR			0x004C
> +#define ISI_DMA_C_ADDR			0x0050
> +#define ISI_DMA_C_CTRL			0x0054
> +#define ISI_DMA_C_DSCR			0x0058
> +
> +/* Bitfields in CFG1 */
> +#define ISI_CFG1_HSYNC_POL_ACTIVE_LOW		(1 << 2)
> +#define ISI_CFG1_VSYNC_POL_ACTIVE_LOW		(1 << 3)
> +#define ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING	(1 << 4)
> +#define ISI_CFG1_EMB_SYNC			(1 << 6)
> +#define ISI_CFG1_CRC_SYNC			(1 << 7)
> +/* Constants for FRATE(ISI_V2) */
> +#define		ISI_CFG1_FRATE_CAPTURE_ALL	(0 << 8)
> +#define		ISI_CFG1_FRATE_DIV_2		(1 << 8)
> +#define		ISI_CFG1_FRATE_DIV_3		(2 << 8)
> +#define		ISI_CFG1_FRATE_DIV_4		(3 << 8)
> +#define		ISI_CFG1_FRATE_DIV_5		(4 << 8)
> +#define		ISI_CFG1_FRATE_DIV_6		(5 << 8)
> +#define		ISI_CFG1_FRATE_DIV_7		(6 << 8)
> +#define		ISI_CFG1_FRATE_DIV_8		(7 << 8)
> +#define ISI_CFG1_DISCR				(1 << 11)
> +#define ISI_CFG1_FULL_MODE			(1 << 12)
> +
> +/* Bitfields in CFG2 */
> +#define ISI_CFG2_GRAYSCALE			(1 << 13)
> +/* Constants for YCC_SWAP(ISI_V2) */
> +#define		ISI_CFG2_YCC_SWAP_DEFAULT	(0 << 28)
> +#define		ISI_CFG2_YCC_SWAP_MODE_1	(1 << 28)
> +#define		ISI_CFG2_YCC_SWAP_MODE_2	(2 << 28)
> +#define		ISI_CFG2_YCC_SWAP_MODE_3	(3 << 28)
> +#define ISI_CFG2_IM_VSIZE_OFFSET		0
> +#define ISI_CFG2_IM_HSIZE_OFFSET		16
> +#define ISI_CFG2_IM_VSIZE_MASK		(0x7FF << ISI_CFG2_IM_VSIZE_OFFSET)
> +#define ISI_CFG2_IM_HSIZE_MASK		(0x7FF << ISI_CFG2_IM_HSIZE_OFFSET)
> +
> +/* Bitfields in CTRL */
> +/* Also using in SR(ISI_V2) */
> +#define ISI_CTRL_EN				(1 << 0)
> +#define ISI_CTRL_CDC				(1 << 8)
> +/* Also using in SR/IER/IDR/IMR(ISI_V2) */
> +#define ISI_CTRL_DIS				(1 << 1)
> +#define ISI_CTRL_SRST				(1 << 2)
> +
> +/* Bitfields in SR */
> +#define ISI_SR_SIP				(1 << 19)
> +/* Also using in SR/IER/IDR/IMR */
> +#define ISI_SR_VSYNC				(1 << 10)
> +#define ISI_SR_PXFR_DONE			(1 << 16)
> +#define ISI_SR_CXFR_DONE			(1 << 17)
> +#define ISI_SR_P_OVR				(1 << 24)
> +#define ISI_SR_C_OVR				(1 << 25)
> +#define ISI_SR_CRC_ERR				(1 << 26)
> +#define ISI_SR_FR_OVR				(1 << 27)
> +
> +/* Bitfields in DMA_C_CTRL & in DMA_P_CTRL */
> +#define ISI_DMA_CTRL_FETCH			(1 << 0)
> +#define ISI_DMA_CTRL_WB				(1 << 1)
> +#define ISI_DMA_CTRL_IEN			(1 << 2)
> +#define ISI_DMA_CTRL_DONE			(1 << 3)
> +
> +/* Bitfields in DMA_CHSR/CHER/CHDR */
> +#define ISI_DMA_CHSR_P_CH			(1 << 0)
> +#define ISI_DMA_CHSR_C_CH			(1 << 1)
> +
> +/* Definition for isi_platform_data */
> +#define ISI_DATAWIDTH_8		0x40
> +#define ISI_DATAWIDTH_10	0x80

Hm, why don't you begin with 0x01, 0x02?

> +struct isi_platform_data {
> +	u8 has_emb_sync;
> +	u8 emb_crc_sync;
> +	u8 hsync_act_low;
> +	u8 vsync_act_low;
> +	u8 pclk_act_falling;
> +	u8 isi_full_mode;
> +	u32 data_width_flags;
> +	/* Using for ISI_CFG1 */
> +	u32 frate;
> +
> +	/* TODO: not support yet */
> +	u8 gs_mode;
> +	u8 pixfmt;
> +	u8 sfd;
> +	u8 sld;
> +	u8 thmask;

Please, remove these, if unused.

> +};
> +
> +#endif /* __ATMEL_ISI_H__ */
> -- 
> 1.6.3.3
> 

Looks much better now!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
