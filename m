Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1ERFJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:09:52 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:60521 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751759Ab1ERFJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:09:50 -0400
Date: Wed, 18 May 2011 06:58:27 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: "Wu, Josh" <Josh.wu@atmel.com>, mchehab@redhat.com,
        linux-kernel@vger.kernel.org, "Haring, Lars" <Lars.Haring@atmel.com>,
        g.liakhovetski@gmx.de, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
Message-ID: <20110518045827.GF18699@game.jcrosoft.org>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
 <4DCC5040.6050300@bluewatersys.com>
 <4C79549CB6F772498162A641D92D532801B80D21@penmb01.corp.atmel.com>
 <4DD2E158.7050300@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD2E158.7050300@bluewatersys.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6096185046027316146
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:58 Wed 18 May     , Ryan Mallon wrote:
> On 05/17/2011 08:59 PM, Wu, Josh wrote:
> > 
> > On Friday, May 13, 2011 5:25 AM, Ryan Mallon wrote 
> > 
> >> On 05/12/2011 07:42 PM, Josh Wu wrote:
> >>> This patch is to enable Atmel Image Sensor Interface (ISI) driver support. 
> >>> - Using soc-camera framework with videobuf2 dma-contig allocator
> >>> - Supporting video streaming of YUV packed format
> >>> - Tested on AT91SAM9M10G45-EK with OV2640
> > 
> >> Hi Josh,
> > 
> >> Thansk for doing this. Overall the patch looks really good. A few
> >> comments below.
> > Hi, Ryan
> > 
> > Thank you for the comments.
> > 
> >>>
> >>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> >>> ---
> >>> base on branch staging/for_v2.6.40
> >>>
> >>>  arch/arm/mach-at91/include/mach/at91_isi.h |  454 ++++++++++++
> >>>  drivers/media/video/Kconfig                |   10 +
> >>>  drivers/media/video/Makefile               |    1 +
> >>>  drivers/media/video/atmel-isi.c            | 1089 ++++++++++++++++++++++++++++
> >>>  4 files changed, 1554 insertions(+), 0 deletions(-)
> >>>  create mode 100644 arch/arm/mach-at91/include/mach/at91_isi.h
> >>>  create mode 100644 drivers/media/video/atmel-isi.c
> > 
> >>> [snip]
> >>> +
> >>> +/* Bit manipulation macros */
> >>> +#define ISI_BIT(name)					\
> >>> +	(1 << ISI_##name##_OFFSET)
> >>> +#define ISI_BF(name, value)				\
> >>> +	(((value) & ((1 << ISI_##name##_SIZE) - 1))	\
> >>> +	 << ISI_##name##_OFFSET)
> >>> +#define ISI_BFEXT(name, value)				\
> >>> +	(((value) >> ISI_##name##_OFFSET)		\
> >>> +	 & ((1 << ISI_##name##_SIZE) - 1))
> >>> +#define ISI_BFINS(name, value, old)			\
> >>> +	(((old) & ~(((1 << ISI_##name##_SIZE) - 1)	\
> >>> +		    << ISI_##name##_OFFSET))\
> >>> +	 | ISI_BF(name, value))
> > 
> >> I really dislike this kind of register access magic. Not sure how others
> >> feel about it. These macros are really ugly.
> > I understand this. So I will try to find a better way (static inline function) to solve this. :)
> 
> >>> +/* Register access macros */
> >>> +#define isi_readl(port, reg)				\
> >>> +	__raw_readl((port)->regs + ISI_##reg)
> >>> +#define isi_writel(port, reg, value)			\
> >>> +	__raw_writel((value), (port)->regs + ISI_##reg)
> 
> >> If the token pasting stuff gets dropped then these can be static inline
> >> functions which is preferred.
> > sure, I'll try.
> 
> Something like this is pretty common (should be moved into the .c file):
> 
> static inline unsigned atmel_isi_readl(struct atmel_isi *isi,
> 					 unsigned reg)
> {
> 	return readl(isi->regs + reg);
> }
> 
> static inline void atmel_isi_writel(struct atmel_isi *isi,
> 				 	unsigned reg, unsigned val)
> {
> 	writel(val, isi->regs + reg);
> }
really do not like it
and prefer the first implemetation
NACK for me
> 
> Then for single bit values you can just do:
> 
> #define ISI_REG_CR		0x0000
> #define ISI_CR_GRAYSCALE	(1 << 13)
> 
> cr = isi_readl(isi, ISI_REG_CR);
> cr |= ISI_CR_GRAYSCALE;
> isi_writel(isi, ISI_REG_CR, cr);
> 
> For bit-fields you could do something like:
> 
> static void atmel_isi_set_bitfield(struct atmel_isi *isi, unsigned reg,
> 					unsigned offset, unsigned mask,
> 					unsigned val)
> {
> 	unsigned tmp;
> 
> 	tmp = atmel_isi_readl(isi, reg);
> 	tmp &= ~(mask << offset);
> 	tmp |= (val & mask) << offset;
> 	atmel_isi_writel(isi, reg, tmp);
> }
>
stop to reinvent thinks
use the bitops of the kernel
> #define ISI_V2_VCC_SWAP_OFFSET		28
> #define ISI_V2_VCC_SWAP_MASK		0x3
> 
> atmel_isi_set_bitfield(isi, ISI_REG_CR, ISI_V2_VCC_SWAP_OFFSET,
> 			ISI_V2_SWAP_MASK, 2);
> 
> There are only a handful of bit-field accesses in the driver so I don't
> think this will make the driver much more verbose and it will remove a
> number of _SIZE definitions for the single bit values.
> 
> <snip>
> 
> >>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> >>> index d61414e..eae6005 100644
> >>> --- a/drivers/media/video/Kconfig
> >>> +++ b/drivers/media/video/Kconfig
> >>> @@ -80,6 +80,16 @@ menuconfig VIDEO_CAPTURE_DRIVERS
> >>>  	  Some of those devices also supports FM radio.
> >>>  
> >>>  if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
> >>> +config VIDEO_ATMEL_ISI
> >>> +	tristate "ATMEL Image Sensor Interface (ISI) support"
> >>> +	depends on VIDEO_DEV && SOC_CAMERA
> > 
> >> Depends on AT91/AVR32?
> > I think I will use AT91
> 
> Somebody else suggested leaving out the AT91 dependency to allow better
> build coverage. The reason for having the AT91 dependency is so that it
> doesn't show up in menuconfig for people on other platforms and
> architectures who cannot use the driver. I've always made SoC drivers
> depend on their architecture. Not sure what the correct answer is here?
no if the drivers is soc specific we MUST not enabled it on other soc
and avoid maintainancne issue

Best Regards,
J.
