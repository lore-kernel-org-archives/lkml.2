Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163Ab1ENUeP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:34:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab1ENUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:34:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI) support
Date: Fri, 13 May 2011 21:18:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Josh Wu <josh.wu@atmel.com>, mchehab@redhat.com,
        linux-media@vger.kernel.org, lars.haring@atmel.com,
        linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105132118.32590.arnd@arndb.de>
X-Provags-ID: V02:K0:g5ZjGlNICtpgPQwiglIldDNl1TyraYxuqUs90zeka8S
 PcVUlYcNXm33PdA//HFhiivuxFadir9xUWDahoLAGP1WCwoK4O
 7h2Zo2hG+174caxfg8tmxE8PtbiyCwapyPEaZu9FOgk7Xzp+yW
 wpLzxFSQD9P/dJV30d9VRqmLRsAUaKR7To6u4g1K2YbYuid8nB
 ttkytxPQIW4szWQmT79bQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 May 2011, Josh Wu wrote:
> This patch is to enable Atmel Image Sensor Interface (ISI) driver support. 
> - Using soc-camera framework with videobuf2 dma-contig allocator
> - Supporting video streaming of YUV packed format
> - Tested on AT91SAM9M10G45-EK with OV2640
>
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

This looks like a very well written driver for the most part. I have a few
comments, mainly regarding maintainability that you should probably look
into.
 
>  arch/arm/mach-at91/include/mach/at91_isi.h |  454 ++++++++++++
>  drivers/media/video/Kconfig                |   10 +
>  drivers/media/video/Makefile               |    1 +
>  drivers/media/video/atmel-isi.c            | 1089 ++++++++++++++++++++++++++++

So you have a mach specific header file that is used by a single driver?
That does not lean itself it code reuse. Better move the header file into
the same directory as the driver, or (better) merge its contents into the
same file.

This is especially important if the driver is possibly shared with avr32
socs.

> +/* Constants for RGB_CFG */
> +#define ISI_RGB_CFG_DEFAULT			0
> +#define ISI_RGB_CFG_MODE_1			1
> +#define ISI_RGB_CFG_MODE_2			2
> +#define ISI_RGB_CFG_MODE_3			3
> +
> +/* Constants for RGB_CFG(ISI_V2) */
> +#define ISI_V2_RGB_CFG_DEFAULT			0
> +#define ISI_V2_RGB_CFG_MODE_1			1
> +#define ISI_V2_RGB_CFG_MODE_2			2
> +#define ISI_V2_RGB_CFG_MODE_3			3
> +
> +/* Bit manipulation macros */
> +#define ISI_BIT(name)					\
> +	(1 << ISI_##name##_OFFSET)
> +#define ISI_BF(name, value)				\
> +	(((value) & ((1 << ISI_##name##_SIZE) - 1))	\
> +	 << ISI_##name##_OFFSET)
> +#define ISI_BFEXT(name, value)				\
> +	(((value) >> ISI_##name##_OFFSET)		\
> +	 & ((1 << ISI_##name##_SIZE) - 1))
> +#define ISI_BFINS(name, value, old)			\
> +	(((old) & ~(((1 << ISI_##name##_SIZE) - 1)	\
> +		    << ISI_##name##_OFFSET))\
> +	 | ISI_BF(name, value))

A much better way to express the above would be to define the constants as
mask values rather than using the macros with bit numbers. There are
conflicting views on how bits are counted, plus the use of macros
makes it harder to grep for the idenfiers.

For example, do

#define ISI_RGB_CFG_DEFAULT	0x0001
#define ISI_RGB_CFG_MODE_1	0x0002
#define ISI_RGB_CFG_MODE_2	0x0004
#define ISI_RGB_CFG_MODE_3	0x0008

For the two examples I quoted, the values are actually the same,
so you might also want to name them so that you don't have to
define multiple versions but can simply reuse the same macros.

Some people also prefer the use of enum over #define, but I
leave that to your judgement

> +/* Register access macros */
> +#define isi_readl(port, reg)				\
> +	__raw_readl((port)->regs + ISI_##reg)
> +#define isi_writel(port, reg, value)			\
> +	__raw_writel((value), (port)->regs + ISI_##reg)

Please explain why you use __raw_* instead of the proper
accessors in the comment. Normal drivers should always
use readl/writel.

Better don't concatenate identifiers, in order to make
grep and ctags work on the arguments.

> +
> +#define ATMEL_ISI_VERSION	KERNEL_VERSION(1, 0, 0)

Don't use KERNEL_VERSION() here, it means something else.

Better yet, don't define a version at all. It is not acceptable
to make any user space interface depend on specific versions,
this is a compatibility nightmare.

> +/* Frame buffer descriptor
> + *  Used by the ISI module as a linked list for the DMA controller.
> + */
> +struct fbd {
> +	/* Physical address of the frame buffer */
> +	u32 fb_address;
> +#if defined(CONFIG_ARCH_AT91SAM9G45) ||\
> +	defined(CONFIG_ARCH_AT91SAM9X5)
> +	/* DMA Control Register(only in HISI2) */
> +	u32 dma_ctrl;
> +#endif
> +	/* Physical address of the next fbd */
> +	u32 next_fbd_address;
> +};
> +
> +#if defined(CONFIG_ARCH_AT91SAM9G45) ||\
> +	defined(CONFIG_ARCH_AT91SAM9X5)
> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl)
> +{
> +	fb_desc->dma_ctrl = ctrl;
> +}
> +#else
> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl) { }
> +#endif

Make these runtime checks, not compile-time. Best define different
identifiers for the platform device, then key the differences off
the device, not the platform.

> +struct atmel_isi {
> +	/* ISI module spin lock. Protects against concurrent access of variables
> +	 * that are shared with the ISR */
> +	spinlock_t			lock;
> +	void __iomem			*regs;
> +
> +	/*  If set ISI is in still capture mode */
> +	int				still_capture;
> +	int				sequence;
> +	/* State of the ISI module in capturing mode */
> +	int				state;
> +
> +	/* Capture/streaming wait queue for waiting for SOF */
> +	wait_queue_head_t		capture_wq;
> +
> +	struct v4l2_device		v4l2_dev;
> +
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +
> +	struct clk			*pclk;
> +	struct platform_device		*pdev;

pdev is unused?

> +	spin_lock_irq(&isi->lock);
> +	isi->still_capture = 0;
> +	isi->active = NULL;
> +
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_CDC))
> +		cpu_relax();

A busy loop with interrupts disabled is rather nasty.
Is there a guaranteed upper bound on how long this can take?

You have the same loop in other places, maybe you can move
it into a separate function with a comment explaining what
you wait for and how long it can take.

	Arnd

