Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1EQI7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:59:38 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:23525 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab1EQI7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:59:34 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI) support
Date: Tue, 17 May 2011 16:59:05 +0800
Message-ID: <4C79549CB6F772498162A641D92D532801B80D21@penmb01.corp.atmel.com>
In-Reply-To: <4DCC5040.6050300@bluewatersys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI) support
Thread-Index: AcwQ6xye1cfhZ8p6S5mFKjc6BcAy+QDhDDbQ
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com> <4DCC5040.6050300@bluewatersys.com>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Ryan Mallon" <ryan@bluewatersys.com>
Cc: <mchehab@redhat.com>, <linux-media@vger.kernel.org>,
        "Haring, Lars" <Lars.Haring@atmel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <g.liakhovetski@gmx.de>
X-OriginalArrivalTime: 17 May 2011 08:59:09.0759 (UTC) FILETIME=[AF583CF0:01CC1470]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday, May 13, 2011 5:25 AM, Ryan Mallon wrote 

> On 05/12/2011 07:42 PM, Josh Wu wrote:
>> This patch is to enable Atmel Image Sensor Interface (ISI) driver support. 
>> - Using soc-camera framework with videobuf2 dma-contig allocator
>> - Supporting video streaming of YUV packed format
>> - Tested on AT91SAM9M10G45-EK with OV2640

> Hi Josh,

> Thansk for doing this. Overall the patch looks really good. A few
> comments below.
Hi, Ryan

Thank you for the comments.

>> 
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>> base on branch staging/for_v2.6.40
>> 
>>  arch/arm/mach-at91/include/mach/at91_isi.h |  454 ++++++++++++
>>  drivers/media/video/Kconfig                |   10 +
>>  drivers/media/video/Makefile               |    1 +
>>  drivers/media/video/atmel-isi.c            | 1089 ++++++++++++++++++++++++++++
>>  4 files changed, 1554 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/mach-at91/include/mach/at91_isi.h
>>  create mode 100644 drivers/media/video/atmel-isi.c

>> [snip]
>> +
>> +/* Bit manipulation macros */
>> +#define ISI_BIT(name)					\
>> +	(1 << ISI_##name##_OFFSET)
>> +#define ISI_BF(name, value)				\
>> +	(((value) & ((1 << ISI_##name##_SIZE) - 1))	\
>> +	 << ISI_##name##_OFFSET)
>> +#define ISI_BFEXT(name, value)				\
>> +	(((value) >> ISI_##name##_OFFSET)		\
>> +	 & ((1 << ISI_##name##_SIZE) - 1))
>> +#define ISI_BFINS(name, value, old)			\
>> +	(((old) & ~(((1 << ISI_##name##_SIZE) - 1)	\
>> +		    << ISI_##name##_OFFSET))\
>> +	 | ISI_BF(name, value))

> I really dislike this kind of register access magic. Not sure how others
> feel about it. These macros are really ugly.
I understand this. So I will try to find a better way (static inline function) to solve this. :)

>> +/* Register access macros */
>> +#define isi_readl(port, reg)				\
>> +	__raw_readl((port)->regs + ISI_##reg)
>> +#define isi_writel(port, reg, value)			\
>> +	__raw_writel((value), (port)->regs + ISI_##reg)

> If the token pasting stuff gets dropped then these can be static inline
> functions which is preferred.
sure, I'll try.

>> [snip]
>> +#define ISI_GS_2PIX_PER_WORD	0x00
>> +#define ISI_GS_1PIX_PER_WORD	0x01
>> +	u8 pixfmt;
>> +	u8 sfd;
>> +	u8 sld;
>> +	u8 thmask;
>> +#define ISI_BURST_4_8_16	0x00
>> +#define ISI_BURST_8_16		0x01
>> +#define ISI_BURST_16		0x02
>> +	u8 frate;
>> +#define ISI_FRATE_DIV_2		0x01
>> +#define ISI_FRATE_DIV_3		0x02
>> +#define ISI_FRATE_DIV_4		0x03
>> +#define ISI_FRATE_DIV_5		0x04
>> +#define ISI_FRATE_DIV_6		0x05
>> +#define ISI_FRATE_DIV_7		0x06
>> +#define ISI_FRATE_DIV_8		0x07
>> +};

> Might need some comments in this structure so that board file writers
> know what each of the fields are for.
I think this part will be change a little bit. Also I will add the updated comments.

>> +
>> +#endif /* __AT91_ISI_H__ */
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index d61414e..eae6005 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -80,6 +80,16 @@ menuconfig VIDEO_CAPTURE_DRIVERS
>>  	  Some of those devices also supports FM radio.
>>  
>>  if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
>> +config VIDEO_ATMEL_ISI
>> +	tristate "ATMEL Image Sensor Interface (ISI) support"
>> +	depends on VIDEO_DEV && SOC_CAMERA

> Depends on AT91/AVR32?
I think I will use AT91

>> [snip]
>> +
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/soc_camera.h>
>> +#include <media/soc_mediabus.h>
>> +
>> +#define ATMEL_ISI_VERSION	KERNEL_VERSION(1, 0, 0)

> Do we really need this version?
Since we need set a version for v4l2_capability.version in function isi_camera_querycap(). So we use this macro.
How about this?
	static int isi_camera_querycap(struct soc_camera_host *ici,
			       struct v4l2_capability *cap)
	{
		strcpy(cap->driver, "atmel-isi");
		strcpy(cap->card, "Atmel Image Sensor Interface");
		cap->version = KERNEL_VERSION(1, 0, 0);
		cap->capabilities = (V4L2_CAP_VIDEO_CAPTURE |
				V4L2_CAP_STREAMING);
		return 0;
	}

>> +#define MAX_BUFFER_NUMS		32
>> +#define MAX_SUPPORT_WIDTH	2048
>> +#define MAX_SUPPORT_HEIGHT	2048
>> +
>> +static unsigned int vid_limit = 16;

> This never gets changed so it can become a const/define. The value is
> MB, which is not clear from the name, and it gets multiplied out to
> bytes in its only usage, so maybe:

> #define VID_LIMIT_BYTES (16 * 1024 * 1024)
Your code is good. I will change according to your suggestion.

>> +
>> +enum isi_buffer_state {
>> +	ISI_BUF_NEEDS_INIT,
>> +	ISI_BUF_PREPARED,
>> +};

> Aren't there v4l2 constants for this already?

>	VIDEOBUF_NEEDS_INIT,
>	VIDEOBUF_PREPARED,

> Just reuse those.
I checked the code, above constants are used in videobuf not videobuf2. So I think I cannot use it.

>> +
>> +/* Single frame capturing states */
>> +enum {
>> +	STATE_IDLE = 0,
>> +	STATE_CAPTURE_READY,
>> +	STATE_CAPTURE_WAIT_SOF,
>> +	STATE_CAPTURE_IN_PROGRESS,
>> +	STATE_CAPTURE_DONE,
>> +	STATE_CAPTURE_ERROR,
>> +};
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

> I wouldn't bother with this ifdef. The memory cost is pretty
> insignificant and it makes the code easier to read without it. It also
> means you don't need to patch it up whenever a new at91 platform with
> isi dma support appears.
I will remove this #if. It is very disappointed to add some ARCH macro every time when any new platform support ISI added.

>> +	/* Physical address of the next fbd */
>> +	u32 next_fbd_address;
>> +};
>> +
>> +#if defined(CONFIG_ARCH_AT91SAM9G45) ||\
>> +	defined(CONFIG_ARCH_AT91SAM9X5)
>> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl)
>> +{
>> +	fb_desc->dma_ctrl = ctrl;
>> +}
>> +#else
>> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl) { }
>> +#endif

> Same here, get rid of the ifdefs.
I'll remove this.

>> [snip]
>> +	if (!isi->still_capture) {
>> +		if (pending & (ISI_BIT(V2_VSYNC))) {
>> +			switch (isi->state) {
>> +			case STATE_IDLE:
>> +				isi->state = STATE_CAPTURE_READY;
>> +				wake_up_interruptible(&isi->capture_wq);
>> +				break;
>> +			}
>> +		} else if (likely(pending & (ISI_BIT(V2_CXFR_DONE)))) {
>> +			ret = atmel_isi_handle_streaming(isi);
>> +		}
>> +	} else {
>> +		while (pending) {
>> +			if (pending & (ISI_BIT(V2_C_OVR) | ISI_BIT(V2_FR_OVR)))
>> +				printk(KERN_ERR "Overrun (status = 0x%x)\n",
>> +					status);

> dev_err(isi->v4l2_dev.dev, "Overrun...");
I will fix it.

>> [snip]
>> +
>> +static int atmel_isi_init(struct atmel_isi *isi)
>> +{
>> +	/*
>> +	 * The reset will only succeed if we have a
>> +	 * pixel clock from the camera.
>> +	 */
>> +	isi_writel(isi, V2_CTRL, ISI_BIT(V2_SRST));
>> +	isi_writel(isi, V2_INTDIS, ~0UL);

> Don't you need to wait for the reset bit to clear? Other implementations
> I have used of the Atmel ISI driver do a wait_for_completition and have
> the interrupt handler set a reset_complete flag.
You are right. I just remove the reset_complete waiting part in this version.
Actually I am thinking whether I need add such code again.

>> [snip]
>> +	if (bytes_per_line < 0)
>> +		return bytes_per_line;
>> +
>> +	size = bytes_per_line * icd->user_height;
>> +
>> +	if (0 == *nbuffers)

>	if (*nbuffers == 0)

> is the more commonly preferred style I believe.
I will fix it for consistency.

>> [snip]
>> +
>> +static int buffer_finish(struct vb2_buffer *vb)
>> +{
>> +	return 0;
>> +}

> Does soc-camera support having NULL function callbacks for functions
> that are not required?
I will remove this function at all. soc-camera can use default callback.

>> [snip]
>> +static inline void stride_align(u32 *width)
>> +{
>> +	if (((*width + 7) &  ~7) < 4096)
>> +		*width = (*width + 7) &  ~7;
>> +	else
>> +		*width = *width &  ~7;

> This looks like something that may already have a function to do it?
Yes. you are right. There is a function ALIGN(*width, 8).
And I think I can remove this function since ISI is not sensetive for this width alignment.

>> [snip]
>> +
>> +static int isi_camera_try_fmt(struct soc_camera_device *icd,
>> +			      struct v4l2_format *f)
>> +{
>> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +	const struct soc_camera_format_xlate *xlate;
>> +	struct v4l2_pix_format *pix = &f->fmt.pix;
>> +	struct v4l2_mbus_framefmt mf;
>> +	__u32 pixfmt = pix->pixelformat;

> u32 inside the kernel, __u32 is for code which is exposed to userspace
>(i.e. API headers).
I will fixed it. no __u32 anymore.

>> [snip]
>> +static int test_platform_param(struct atmel_isi *isi,
>> +			       unsigned char buswidth, unsigned long *flags)
>> +{
>> +	/*
>> +	 * Platform specified synchronization and pixel clock polarities are
>> +	 * only a recommendation and are only used during probing. Atmel ISI
>> +	 * camera interface only works in master mode, i.e., uses HSYNC and
>> +	 * VSYNC signals from the sensor
>> +	 */
>> +	*flags = SOCAM_MASTER |
>> +		SOCAM_HSYNC_ACTIVE_HIGH |
>> +		SOCAM_HSYNC_ACTIVE_LOW |
>> +		SOCAM_VSYNC_ACTIVE_HIGH |
>> +		SOCAM_VSYNC_ACTIVE_LOW |
>> +		SOCAM_PCLK_SAMPLE_RISING |
>> +		SOCAM_PCLK_SAMPLE_FALLING |
>> +		SOCAM_DATA_ACTIVE_HIGH;
>> +
>> +	/* If requested data width is supported by the platform, use it */
>> +	switch (buswidth) {
>> +	case 10:
>> +		if (!(isi->platform_flags & ISI_DATAWIDTH_10))
>> +			return -EINVAL;
>> +		*flags |= SOCAM_DATAWIDTH_10;
>> +		break;

> If you have specified the platform data width as 10 bits can you not do
> 8 bit transfers on it?
no, you cannot use 8 bit transfers. 
But normally we can specify the platform data width to support both 10 and 8.

>> [snip]
>> +static int isi_camera_querycap(struct soc_camera_host *ici,
>> +			       struct v4l2_capability *cap)
>> +{
>> +	strcpy(cap->driver, "atmel-isi");
>> +	strcpy(cap->card, "Atmel Image Sensor Interface");
>> +	cap->version = ATMEL_ISI_VERSION;
>> +
>> +	cap->capabilities = (V4L2_CAP_VIDEO_CAPTURE
>> +			     | V4L2_CAP_READWRITE
>> +			     | V4L2_CAP_STREAMING
>> +			     );

> In other places you have the |'s at the end of the line. Should be
> consistent within a file.
I will fix it. And I find the same mistake in other place. Thank you.

>> +	return 0;
>> +}
>> +
>> +static int isi_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)

> u32.
will be fix.

>> [snip]
>> +	if (dev->platform_data)
>> +		pdata = (struct isi_platform_data *) dev->platform_data;
>> +	else {
>> +		static struct isi_platform_data isi_default_data = {
>> +			.frate		= 0,
>> +			.has_emb_sync	= 0,
>> +			.emb_crc_sync	= 0,
>> +			.hsync_act_low	= 0,
>> +			.vsync_act_low	= 0,
>> +			.pclk_act_falling = 0,
>> +			.isi_full_mode	= 1,
>> +			/* to use codec and preview path simultaneously */
>> +			.flags = ISI_DATAWIDTH_8 |
>> +				ISI_DATAWIDTH_10,
>> +		};

> Move this struct definition outside of this function.
OK. I will change that.

>> +		dev_info(&pdev->dev,
>> +			"No config available using default values\n");
>> +		pdata = &isi_default_data;
>> +	}
>> +
>> +	isi->pdata = pdata;
>> +	isi->platform_flags = pdata->flags;
>> +	if (isi->platform_flags == 0)
>> +		isi->platform_flags = ISI_DATAWIDTH_8;

> We could be mean here an require that people get the flags correct, e.g.

>	if (!((isi->platform_flags & ISI_DATA_WIDTH_8) ||
>	      (isi->platform_flags & ISI_DATA_WIDTH_8))) {
>		dev_err(&pdev->dev, "No data width specified\n");
>		err = -ENOMEM;
>		goto fail;
>	}

> Which discourages sloppy coding in the board files.
now the isi->platform_flags only use for data width, so if it is 0, I will set is as default data width(ISI_DATA_WIDTH_8).
I think if we use platform_flags for more option (not only data width), then we need test it with a WIDTH_MASK.

>> [snip]

Best Regards,
Josh Wu
