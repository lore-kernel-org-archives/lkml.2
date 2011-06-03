Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1FCI27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 04:28:59 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:44007 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1FCI2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 04:28:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] [media] at91: add Atmel Image Sensor Interface (ISI) support
Date: Fri, 3 Jun 2011 16:28:27 +0800
Message-ID: <4C79549CB6F772498162A641D92D532801DAC94A@penmb01.corp.atmel.com>
In-Reply-To: <Pine.LNX.4.64.1105281911230.6780@axis700.grange>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] [media] at91: add Atmel Image Sensor Interface (ISI) support
Thread-Index: AcwddVf0FBWGzKtfRw6X/H64aM2EUQET9gnw
References: <1306496329-14535-1-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1105281911230.6780@axis700.grange>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <mchehab@redhat.com>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Haring, Lars" <Lars.Haring@atmel.com>, <ryan@bluewatersys.com>,
        <arnd@arndb.de>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
X-OriginalArrivalTime: 03 Jun 2011 08:28:33.0689 (UTC) FILETIME=[39FBF090:01CC21C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guennadi

Guennadi Liakhovetski wrote on May 29, 2011 4:25 AM

> Hi Josh

> Thanks for the update. A general note: I much prefer the new IO accessors and > register names and values - thanks for changing that!

Thank you for the reviewing. I also think this version is clearer. :)
Base on the suggestion from you and J.C, I will send out the version 3 soon.

> On Fri, 27 May 2011, Josh Wu wrote:

>> This patch is to enable Atmel Image Sensor Interface (ISI) driver support.
>> - Using soc-camera framework with videobuf2 dma-contig allocator
>> - Supporting video streaming of YUV packed format
>> - Tested on AT91SAM9M10G45-EK with OV2640
>> 
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>> Modified in V2 patch:
>> [snip]
>> +
>> +#include <linux/clk.h>
>> +#include <linux/completion.h>
>> +#include <linux/fs.h>
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/kernel.h>

> You had <linux/module.h> here in "v1," I think, it is needed for various
> MODULE_AUTHOR() etc. macros. Please, re-add.

I will add it.

>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/delay.h>
>> +
>> +#include <mach/board.h>
>> +#include <mach/cpu.h>

> I still don't understand, why you need these two. If unneeded, please, remove.

I forgot to remove it. I'll remove this.

>> +
>> +#include <media/videobuf2-dma-contig.h> #include <media/soc_camera.h> 
>> +#include <media/soc_mediabus.h> #include <media/atmel-isi.h>

> Alphabetic order here too, please.

I will change the order.

>> +
>> +#define MAX_BUFFER_NUMS			32

> "NUM" above doesn't need an "S" at the end - it's just a "number of buffers," > not "numbers."

sure, I will fix it.

>> +#define MAX_SUPPORT_WIDTH		2048
>> +#define MAX_SUPPORT_HEIGHT		2048
>> +#define VID_LIMIT_BYTES			(16 * 1024 * 1024)
>> +#define MIN_FRAME_RATE			15
>> +#define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
>> +
>> +/* ISI states */
>> +enum {
>> +	ISI_STATE_IDLE = 0,
>> +	ISI_STATE_READY,
>> +	ISI_STATE_WAIT_SOF,
>> +};
>> +
>> +/* Frame buffer descriptor */
>> +struct fbd {
>> +	/* Physical address of the frame buffer */
>> +	u32 fb_address;
>> +	/* DMA Control Register(only in HISI2) */
>> +	u32 dma_ctrl;

> Ok, several reviewers, including myself, asked you to remove #ifdef here, but > at least I didn't realise at that moment, that this struct describes >hareware-specific memory layout. So, how is it supposed to work now on platforms, >that don't have this field, i.e., !CONFIG_ARCH_AT91SAM9G45 >and !CONFIG_ARCH_AT91SAM9X5? Or are they not supported yet? Maybe you could >define two structs - later, when you also support other CPUs, and use a union >or something else?

This dma_ctrl is hardware related memory layout. In the ISI_V1 hardware (AT91SAM9263, AVR32, etc), there is no dma_ctrl in the descriptor. In the future I prefer to add another ISI_V1 fbd structure and a function to handle these two structures according to hardware. But in this version I think ISI_V1 hardware platform is not supported.

>> +	/* Physical address of the next fbd */
>> +	u32 next_fbd_address;
>> +};
>> +
>> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl) {
>> +	fb_desc->dma_ctrl = ctrl;
>> +}
>> +
>> +/* Frame buffer data */
>> +struct frame_buffer {
>> +	struct vb2_buffer vb;
>> +	struct fbd *p_fb_desc;
>> +	u32 fb_desc_phys;
>> +	struct list_head list;
>> +};
>> +
>> +struct atmel_isi {
>> +	/* Protects the access of variables shared with the ISR */
>> +	spinlock_t			lock;
>> +	void __iomem			*regs;
>> +
>> +	int				sequence;
>> +	/* State of the ISI module in capturing mode */
>> +	int				state;
>> +
>> +	/* Capture/streaming wait queue for waiting for SOF */
>> +	wait_queue_head_t		capture_wq;
>> +
>> +	struct vb2_alloc_ctx		*alloc_ctx;
>> +
>> +	/* Allocate descriptors for dma buffer use */
>> +	struct fbd			*p_fb_descriptors;
>> +	u32				fb_descriptors_phys;
>> +	int				index_fb_desc;
>> +
>> +	struct completion		isi_complete;

> You don't need to prefix members in structs, especially since you don't do this > with others. Just leave "complete" or something similar.

I will change the name.

>> [snip]
>> +
>> +	if (!buf->p_fb_desc) {
>> +		/* Initialize the dma descriptor */
>> +		buf->p_fb_desc = &isi->p_fb_descriptors[isi->index_fb_desc];
>> +		buf->fb_desc_phys = isi->fb_descriptors_phys +
>> +				isi->index_fb_desc * sizeof(struct fbd);
>> +
>> +		buf->p_fb_desc->fb_address = vb2_dma_contig_plane_paddr(vb, 0);
>> +		buf->p_fb_desc->next_fbd_address = 0;
>> +		set_dma_ctrl(buf->p_fb_desc, ISI_DMA_CTRL_WB);
>> +		isi->index_fb_desc++;
>> +		if (isi->index_fb_desc > MAX_BUFFER_NUMS) {
>> +			dev_err(icd->dev.parent, "Not enough dma descriptors.\n");

> Don't you have to check overflow _before_ using the index? Pointing the hardware > to an invalid location doesn't seem like a very good idea.

You are right. I will fix this.

>> +			return -EINVAL;
>> +		}
>> +	}
>> +	return 0;
>> +}
>> +
>> +static void buffer_cleanup(struct vb2_buffer *vb) {
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> +	struct atmel_isi *isi = ici->priv;
>> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&isi->lock, flags);
>> +	if (buf->p_fb_desc) {
>> +		buf->p_fb_desc = NULL;
>> +		buf->fb_desc_phys = 0;
>> +		isi->index_fb_desc--;
>> +		if (isi->index_fb_desc < 0)
>> +			dev_err(icd->dev.parent, "Invalid descriptors index.\n");

> ...and this would break, if you start initialising and cleaning up buffers out of order. Maybe you could just extend your private data

> struct isi_dmadesc {
> 	struct list_head	list;
>	struct fbd		*fbd;
> };

> struct atmel_isi {
> 	...
>	struct list_head	dmadesc_head;
>	struct isi_dmadesc	dmadesc[MAX_BUFFER_NUM];
>};

> and then in your atmel_isi_probe()

>	kzalloc(...);
>	dma_alloc_coherent(...);
>	for (i = 0; i < MAX_BUFFER_NUM; i++) {
>		isi->dmadesc[i].fbd = isi->p_fb_descriptors + i;
>		list_add(&isi->dmadesc[i].list, &isi->dmadesc_head);
>	}

> etc.

It seems no problem if the initializing buffer numbers is the same as cleaning buffers numbers. For example, if we initialized 4 buffers for video buffer queue. It should be ok as long as we cleaned 4 buffers. No matter the order of the buffers to be cleaned up.

And yes, add a list to track the buffer descriptor is better way, I will change this. The list is look like following:
struct isi_dma_desc {
	struct list_head list;
	struct fbd *p_fbd;
	u32 fbd_phys;
};
The fbd_phys is physical address of the structure fbd.

>> +	}
>> +	spin_unlock_irqrestore(&isi->lock, flags); }
>> +
>> [snip]
>> +	spin_lock_irq(&isi->lock);
>> +	isi->active = NULL;
>> +	/* Release all active buffers */
>> +	list_for_each_safe(pos, node, &isi->video_buffer_list) {
>> +		buf = list_entry(pos, struct frame_buffer, list);
>> +		list_del_init(&buf->list);
>> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);

> list_for_entry_safe() would be even better;)

oh, I don't notice this function yet. I'll use it.

>> +	}
>> +	spin_unlock_irq(&isi->lock);
>> +
>> +	timeout = jiffies + FRAME_INTERVAL_MILLI_SEC * HZ;
>> +	/* Wait until the end of the current frame. */
>> +	while ((isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) &&
>> [snip]
>> +	if (isi->icd)
>> +		return -EBUSY;
>> +
>> +	if (clk_enable(isi->pclk))
>> +		return -EIO;

> Better propagate error code from clk_enable().

Sure. I will fix it

>> [snip]
>> +
>> +	bus_flags = make_bus_param(isi);
>> +	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
>> +	dev_dbg(icd->dev.parent, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
>> +		camera_flags, bus_flags, common_flags);
>> +	if (!common_flags)
>> +		return -EINVAL;

> Below seems overengineered;) In general, I think, your ISI controller supports > both active low and high HSYNC and VSYNC and falling and rising PCLK. That's > what your make_bus_param() is suggesting and those are the flags, that you send > to the client. On top of that your platform data flags hsync_act_low, >vsync_act_low, and pclk_act_falling are only recommendations for ambiguous >cases, when the client also supports both polarities, right? 

Right. That is exact what I want to do.

> Otherwise, if the client only supports, say, PCLK rising, it has precedence >over the platform preference. Now, below you do something different

>> +
>> +	/* Make choises, based on platform preferences */
>> +	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
>> +	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
>> +		if (isi->pdata->hsync_act_low)
>> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
>> +		else
>> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
>> +	}
>> +
>> +	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
>> +	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
>> +		if (isi->pdata->vsync_act_low)
>> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
>> +		else
>> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
>> +	}
>> +
>> +	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
>> +	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
>> +		if (isi->pdata->pclk_act_falling)
>> +			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
>> +		else
>> +			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
>> +	}

> The three constructs above _already_ select all three polarities in the optimal > way - in ambiguous cases they use platform preferences to select one of the > two polarities. Now, all you need to do is use your common_flags to configure > the ISI:

>> +
>> +	ret = icd->ops->set_bus_param(icd, common_flags);
>> +	if (ret < 0) {
>> +		dev_dbg(icd->dev.parent, "Camera set_bus_param(%lx) returned %d\n",
>> +			common_flags, ret);
>> +		return ret;
>> +	}
>> +
>> +	/* set bus param for ISI */
>> +	hsync_act_low = isi->pdata->hsync_act_low;
>> +	vsync_act_low = isi->pdata->vsync_act_low;
>> +	pclk_act_falling = isi->pdata->pclk_act_falling;

> These variables are not needed at all.

I will remove this.

>> +
>> +	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
>> +		hsync_act_low = 1;
>> +	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
>> +		vsync_act_low = 1;
>> +	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
>> +		pclk_act_falling = 1;
>> +
>> +	if (hsync_act_low)
>> +		cfg1 |= ISI_CFG1_HSYNC_POL_ACTIVE_LOW;

> This should become

> +	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
> +		cfg1 |= ISI_CFG1_HSYNC_POL_ACTIVE_LOW;

> similar for the other two.

You are right. I will change the code.

>> [snip]
>> +---------------------------------------------------------------------
>> +--*/ static int __exit atmel_isi_remove(struct platform_device *pdev)

> __devexit

I will fix it.

>> [snip]
>> +	if (dev->platform_data) {
>> +		pdata = (struct isi_platform_data *) dev->platform_data;

> superfluous cast

I will remove it.

>> +	} else {
>> +		/* Set default ISI platform data */
>> +		isi_default_data.frate		= ISI_CFG1_FRATE_CAPTURE_ALL;
>> +		isi_default_data.has_emb_sync	= 0;
>> +		isi_default_data.emb_crc_sync	= 0;
>> +		isi_default_data.hsync_act_low	= 0;
>> +		isi_default_data.vsync_act_low	= 0;
>> +		isi_default_data.pclk_act_falling = 0;
>> +		isi_default_data.isi_full_mode	= 1;
>> +		isi_default_data.data_width_flags = ISI_DATAWIDTH_8 |
>> +				ISI_DATAWIDTH_10;

> Well, I don't like it. Let's put it straight: please, remove this default >platform data and make platform data compulsory. I don't think we're asking too >much from platform developers with this. Maybe Oopsing without platform data, >like some drivers do, is not very nice, but we can definitely just bail out with >an error.

Yes. I will do this way, if no platform_data provide, I will return an error directly.

>> +
>> +		pdata = &isi_default_data;
>> +		dev_info(&pdev->dev,
>> +			"No config available using default values\n");
>> +	}
>> +
>> +	isi->pdata = pdata;
>> +	isi->platform_flags = pdata->data_width_flags;
>> +	if (isi->platform_flags == 0)
>> +		isi->platform_flags = ISI_DATAWIDTH_8;

> Same here. Datawidth is only known to the platform, so, it _must_ be set. 
> And you don't need this extra field isi->platform_flags - you have the 
> complete pdata always with you.

ditto. And I will remove the isi->platform_flags too.

>> [snip]
>> +static struct platform_driver atmel_isi_driver = {
>> +	.probe		= atmel_isi_probe,
>> +	.remove		= __exit_p(atmel_isi_remove),

> __devexit_p()

I will fix it.

>> [snip]
>> +
>> +/* Definition for isi_platform_data */
>> +#define ISI_DATAWIDTH_8		0x40
>> +#define ISI_DATAWIDTH_10	0x80

> Hm, why don't you begin with 0x01, 0x02?

I'll fix it.

>> +struct isi_platform_data {
>> +	u8 has_emb_sync;
>> +	u8 emb_crc_sync;
>> +	u8 hsync_act_low;
>> +	u8 vsync_act_low;
>> +	u8 pclk_act_falling;
>> +	u8 isi_full_mode;
>> +	u32 data_width_flags;
>> +	/* Using for ISI_CFG1 */
>> +	u32 frate;
>> +
>> +	/* TODO: not support yet */
>> +	u8 gs_mode;
>> +	u8 pixfmt;
>> +	u8 sfd;
>> +	u8 sld;
>> +	u8 thmask;

> Please, remove these, if unused.

Ok, I will remove it.

>> +};
>> +
>> +#endif /* __ATMEL_ISI_H__ */
>> -- 
>> 1.6.3.3
>> 

> Looks much better now!

Thanks you again.

Best Regards,
Josh Wu


