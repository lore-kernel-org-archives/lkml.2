Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1EQU6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:58:03 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:24054 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756546Ab1EQU6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:58:01 -0400
Message-ID: <4DD2E158.7050300@bluewatersys.com>
Date: Wed, 18 May 2011 08:58:00 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Wu, Josh" <Josh.wu@atmel.com>
CC: mchehab@redhat.com, linux-kernel@vger.kernel.org,
        "Haring, Lars" <Lars.Haring@atmel.com>, g.liakhovetski@gmx.de,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>	<4DCC5040.6050300@bluewatersys.com> <4C79549CB6F772498162A641D92D532801B80D21@penmb01.corp.atmel.com>
In-Reply-To: <4C79549CB6F772498162A641D92D532801B80D21@penmb01.corp.atmel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 08:59 PM, Wu, Josh wrote:
> 
> On Friday, May 13, 2011 5:25 AM, Ryan Mallon wrote 
> 
>> On 05/12/2011 07:42 PM, Josh Wu wrote:
>>> This patch is to enable Atmel Image Sensor Interface (ISI) driver support. 
>>> - Using soc-camera framework with videobuf2 dma-contig allocator
>>> - Supporting video streaming of YUV packed format
>>> - Tested on AT91SAM9M10G45-EK with OV2640
> 
>> Hi Josh,
> 
>> Thansk for doing this. Overall the patch looks really good. A few
>> comments below.
> Hi, Ryan
> 
> Thank you for the comments.
> 
>>>
>>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>>> ---
>>> base on branch staging/for_v2.6.40
>>>
>>>  arch/arm/mach-at91/include/mach/at91_isi.h |  454 ++++++++++++
>>>  drivers/media/video/Kconfig                |   10 +
>>>  drivers/media/video/Makefile               |    1 +
>>>  drivers/media/video/atmel-isi.c            | 1089 ++++++++++++++++++++++++++++
>>>  4 files changed, 1554 insertions(+), 0 deletions(-)
>>>  create mode 100644 arch/arm/mach-at91/include/mach/at91_isi.h
>>>  create mode 100644 drivers/media/video/atmel-isi.c
> 
>>> [snip]
>>> +
>>> +/* Bit manipulation macros */
>>> +#define ISI_BIT(name)					\
>>> +	(1 << ISI_##name##_OFFSET)
>>> +#define ISI_BF(name, value)				\
>>> +	(((value) & ((1 << ISI_##name##_SIZE) - 1))	\
>>> +	 << ISI_##name##_OFFSET)
>>> +#define ISI_BFEXT(name, value)				\
>>> +	(((value) >> ISI_##name##_OFFSET)		\
>>> +	 & ((1 << ISI_##name##_SIZE) - 1))
>>> +#define ISI_BFINS(name, value, old)			\
>>> +	(((old) & ~(((1 << ISI_##name##_SIZE) - 1)	\
>>> +		    << ISI_##name##_OFFSET))\
>>> +	 | ISI_BF(name, value))
> 
>> I really dislike this kind of register access magic. Not sure how others
>> feel about it. These macros are really ugly.
> I understand this. So I will try to find a better way (static inline function) to solve this. :)

>>> +/* Register access macros */
>>> +#define isi_readl(port, reg)				\
>>> +	__raw_readl((port)->regs + ISI_##reg)
>>> +#define isi_writel(port, reg, value)			\
>>> +	__raw_writel((value), (port)->regs + ISI_##reg)

>> If the token pasting stuff gets dropped then these can be static inline
>> functions which is preferred.
> sure, I'll try.

Something like this is pretty common (should be moved into the .c file):

static inline unsigned atmel_isi_readl(struct atmel_isi *isi,
					 unsigned reg)
{
	return readl(isi->regs + reg);
}

static inline void atmel_isi_writel(struct atmel_isi *isi,
				 	unsigned reg, unsigned val)
{
	writel(val, isi->regs + reg);
}

Then for single bit values you can just do:

#define ISI_REG_CR		0x0000
#define ISI_CR_GRAYSCALE	(1 << 13)

cr = isi_readl(isi, ISI_REG_CR);
cr |= ISI_CR_GRAYSCALE;
isi_writel(isi, ISI_REG_CR, cr);

For bit-fields you could do something like:

static void atmel_isi_set_bitfield(struct atmel_isi *isi, unsigned reg,
					unsigned offset, unsigned mask,
					unsigned val)
{
	unsigned tmp;

	tmp = atmel_isi_readl(isi, reg);
	tmp &= ~(mask << offset);
	tmp |= (val & mask) << offset;
	atmel_isi_writel(isi, reg, tmp);
}

#define ISI_V2_VCC_SWAP_OFFSET		28
#define ISI_V2_VCC_SWAP_MASK		0x3

atmel_isi_set_bitfield(isi, ISI_REG_CR, ISI_V2_VCC_SWAP_OFFSET,
			ISI_V2_SWAP_MASK, 2);

There are only a handful of bit-field accesses in the driver so I don't
think this will make the driver much more verbose and it will remove a
number of _SIZE definitions for the single bit values.

<snip>

>>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>>> index d61414e..eae6005 100644
>>> --- a/drivers/media/video/Kconfig
>>> +++ b/drivers/media/video/Kconfig
>>> @@ -80,6 +80,16 @@ menuconfig VIDEO_CAPTURE_DRIVERS
>>>  	  Some of those devices also supports FM radio.
>>>  
>>>  if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
>>> +config VIDEO_ATMEL_ISI
>>> +	tristate "ATMEL Image Sensor Interface (ISI) support"
>>> +	depends on VIDEO_DEV && SOC_CAMERA
> 
>> Depends on AT91/AVR32?
> I think I will use AT91

Somebody else suggested leaving out the AT91 dependency to allow better
build coverage. The reason for having the AT91 dependency is so that it
doesn't show up in menuconfig for people on other platforms and
architectures who cannot use the driver. I've always made SoC drivers
depend on their architecture. Not sure what the correct answer is here?

>>> [snip]
>>> +
>>> +#include <media/videobuf2-dma-contig.h>
>>> +#include <media/soc_camera.h>
>>> +#include <media/soc_mediabus.h>
>>> +
>>> +#define ATMEL_ISI_VERSION	KERNEL_VERSION(1, 0, 0)
> 
>> Do we really need this version?
> Since we need set a version for v4l2_capability.version in function isi_camera_querycap(). So we use this macro.
> How about this?
> 	static int isi_camera_querycap(struct soc_camera_host *ici,
> 			       struct v4l2_capability *cap)
> 	{
> 		strcpy(cap->driver, "atmel-isi");
> 		strcpy(cap->card, "Atmel Image Sensor Interface");
> 		cap->version = KERNEL_VERSION(1, 0, 0);
> 		cap->capabilities = (V4L2_CAP_VIDEO_CAPTURE |
> 				V4L2_CAP_STREAMING);
> 		return 0;
> 	}

Not sure. Is cap->version meant to be a KERNEL_VERSION value or is it
arbitrary? If nothing from user-space cares then it could just be left
as zero?

<snip>

>>> +static int atmel_isi_init(struct atmel_isi *isi)
>>> +{
>>> +	/*
>>> +	 * The reset will only succeed if we have a
>>> +	 * pixel clock from the camera.
>>> +	 */
>>> +	isi_writel(isi, V2_CTRL, ISI_BIT(V2_SRST));
>>> +	isi_writel(isi, V2_INTDIS, ~0UL);
> 
>> Don't you need to wait for the reset bit to clear? Other implementations
>> I have used of the Atmel ISI driver do a wait_for_completition and have
>> the interrupt handler set a reset_complete flag.
> You are right. I just remove the reset_complete waiting part in this version.
> Actually I am thinking whether I need add such code again.

The driver should do the check since the reset can fail, and the caller
should be notified. This function should probably be called
atmel_isi_reset rather than atmel_isi_init to better reflect what it does.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
