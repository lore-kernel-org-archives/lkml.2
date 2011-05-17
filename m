Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1EQGgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 02:36:23 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:16570 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1EQGgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 02:36:21 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI) support
Date: Tue, 17 May 2011 14:35:59 +0800
Message-ID: <4C79549CB6F772498162A641D92D532801B80C20@penmb01.corp.atmel.com>
In-Reply-To: <20110512114530.GE18952@game.jcrosoft.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI) support
Thread-Index: AcwQm6IcCN4BxHaWS52To49x3I0fqwDv+hbg
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com> <20110512114530.GE18952@game.jcrosoft.org>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Cc: <mchehab@redhat.com>, <linux-media@vger.kernel.org>,
        "Haring, Lars" <Lars.Haring@atmel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <g.liakhovetski@gmx.de>
X-OriginalArrivalTime: 17 May 2011 06:36:05.0657 (UTC) FILETIME=[B2D23890:01CC145C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, JC

>> +struct atmel_isi;
> do we really this here?
Not really. I'll remove this.

>> +
>> [snip]
>>  
>>  if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
>> +config VIDEO_ATMEL_ISI
>> +	tristate "ATMEL Image Sensor Interface (ISI) support"
>> +	depends on VIDEO_DEV && SOC_CAMERA
> depends on AT91 if the drivers is at91 specific or avr32 otherwise
I'll add that. I think now it is only supported AT91. I am not sure for the AVR32 part

>> +	select VIDEOBUF2_DMA_CONTIG
>> +	default n
> it's n by default  please remove
I'll change that.

>> [snip]
>> +
>> +/* Frame buffer descriptor
>> + *  Used by the ISI module as a linked list for the DMA controller.
>> + */
>> +struct fbd {
>> +	/* Physical address of the frame buffer */
>> +	u32 fb_address;
>> +#if defined(CONFIG_ARCH_AT91SAM9G45) ||\
>> +	defined(CONFIG_ARCH_AT91SAM9X5)
>> +	/* DMA Control Register(only in HISI2) */
>> +	u32 dma_ctrl;
>> +#endif
> no ifdef in the struct
I'll remove this #if. I think for the non-HISI2 version, like AT91SAM9263, we should define another FBD structure which not includes dma_ctrl.

>> +	/* Physical address of the next fbd */
>> +	u32 next_fbd_address;
>> +};
>> +
>> +#if defined(CONFIG_ARCH_AT91SAM9G45) ||\
>> +	defined(CONFIG_ARCH_AT91SAM9X5)
>> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl) {
>> +	fb_desc->dma_ctrl = ctrl;
>> +}
>> +#else
>> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl) { } #endif
> no ifdef here also as we want to have multi soc support
I'll remove this #if also.

>> [snip]
>> +	/* State of the ISI module in capturing mode */
>> +	int				state;
>> +
>> +	/* Capture/streaming wait queue for waiting for SOF */
>> +	wait_queue_head_t		capture_wq;
>> +
>> +	struct v4l2_device		v4l2_dev;
>> +
>> +	struct vb2_alloc_ctx		*alloc_ctx;
>> +
>> +	struct clk			*pclk;
>> +	struct platform_device		*pdev;
> do you really need to store the pdev?
I'll remove this. It is no use.

>> +	unsigned int			irq;
>> +
>> +	struct isi_platform_data	*pdata;
>> +	unsigned long			platform_flags;
>> +
>> +	struct list_head		video_buffer_list;
>> +	struct frame_buffer		*active;
>> +
>> +	struct soc_camera_device	*icd;
>> +	struct soc_camera_host		soc_host;
>> +};
>> +
>> +static int configure_geometry(struct atmel_isi *isi, u32 width,
>> +			u32 height, enum v4l2_mbus_pixelcode code) {
>> +	u32 cfg2, cr, ctrl;
>> +
>> +	cr = 0;
> please move this in default
I'll remove this cr line. Seems it is not needed. cr will be initialized by the following code.

>> [snip]
>> +
>> +	size = bytes_per_line * icd->user_height;
>> +
>> +	if (0 == *nbuffers)
> please invert the test
I'll fix it.

>> +		*nbuffers = MAX_BUFFER_NUMS;
>> +	if (*nbuffers > MAX_BUFFER_NUMS)
>> +		*nbuffers = MAX_BUFFER_NUMS;
>> +
>> +	while (size * *nbuffers > vid_limit * 1024 * 1024)
>> +		(*nbuffers)--;
>> +
>> +	*nplanes = 1;
>> +	sizes[0] = size;
>> +	alloc_ctxs[0] = dev->alloc_ctx;
>> +
>> +	dev->sequence = 0;
>> +	dev->active = NULL;
>> +
>> +	dev_dbg(icd->dev.parent, "%s, count=%d, size=%ld\n", __func__,
>> +		*nbuffers, size);
>> +
>> +	return 0;
>> +}
>> +
>> +
>> +static void start_dma(struct atmel_isi *isi, struct frame_buffer 
>> +*buffer) {
>> +	u32 ctrl, cfg1;
> please add ine ligne here
OK. I'll change that.

>> +	ctrl = isi_readl(isi, V2_CTRL);
>> +	cfg1 = isi_readl(isi, V2_CFG1);
>> +	/* Enable irq: cxfr for the codec path, pxfr for the preview path */
>> +	isi_writel(isi, V2_INTEN,
>> +			ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE));
>> +
>> +	/* Enable codec path */
>> +	ctrl |= ISI_BIT(V2_CDC);
>> +	/* Check if already in a frame */
>> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_CDC))
>> +		cpu_relax();
> no timeout?
I'll add time out code and test it.

>> +
>> +	/* Write the address of the first frame buffer in the C_ADDR reg
>> +	* write the address of the first descriptor(link list of buffer)
>> +	* in the C_DSCR reg, and enable dma channel.
>> +	*/
>> +	isi_writel(isi, V2_DMA_C_DSCR, (__pa(&(buffer->fb_desc))));
>> +	isi_writel(isi, V2_DMA_C_CTRL,
>> +			ISI_BIT(V2_DMA_FETCH) | ISI_BIT(V2_DMA_DONE));
>> +	isi_writel(isi, V2_DMA_CHER, ISI_BIT(V2_DMA_C_CH_EN));
>> +
>> +	/* Enable linked list */
>> +	cfg1 |= ISI_BF(V2_FRATE, isi->pdata->frate) | ISI_BIT(V2_DISCR);
>> +
>> +	/* Enable ISI module*/
>> +	ctrl |= ISI_BIT(V2_ENABLE);
>> +	isi_writel(isi, V2_CTRL, ctrl);
>> +	isi_writel(isi, V2_CFG1, cfg1);
>> +}
>> +
>> +
>> +/* abort streaming and wait for last buffer */ static int 
>> +stop_streaming(struct vb2_queue *vq) {
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +
>> +	spin_lock_irq(&isi->lock);
>> +	isi->still_capture = 0;
>> +	isi->active = NULL;
>> +
>> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_CDC))
>> +		cpu_relax();
> ditto
I'll fix it too.

>> +
>> +	/* Disble codec path */
>> +	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) & (~ISI_BIT(V2_CDC)));
>> +	/* Disable interrupts */
>> +	isi_writel(isi, V2_INTDIS,
>> +			ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE));
>> +	/* Disable ISI module*/
>> +	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) | ISI_BIT(V2_DIS));
>> +

>> +
>> +static int __init atmel_isi_probe(struct platform_device *pdev) {
>> +	unsigned int irq;
>> +	struct atmel_isi *isi;
>> +	struct clk *pclk;
>> +	struct resource *regs;
>> +	int ret;
>> +	struct device *dev = &pdev->dev;
>> +	struct isi_platform_data *pdata;
>> +	struct soc_camera_host *soc_host;
>> +
>> +	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!regs)
>> +		return -ENXIO;
>> +
>> +	pclk = clk_get(&pdev->dev, "isi_clk");
>> +	if (IS_ERR(pclk))
>> +		return PTR_ERR(pclk);
>> +
>> +	clk_enable(pclk);
> do we really need to always enable the clock?
> normally we need to enable it just when we use the device and disable asap
Yes, you are right. I will move such code to the camera_add_device/camera_remove_device functions

> do you plane toadd the pm?
You mean the power resume/suspend function for ISI, right? Not planned yet. But if I have time I will try this.

Thank you for the comments. I will fix it in V2 patch.

Best Regards,
Josh Wu
