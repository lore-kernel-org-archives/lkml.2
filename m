Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1B1RMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:12:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54611 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab1B1RMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:12:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/8] Add a mfd IPUv3 driver
Date: Mon, 28 Feb 2011 18:11:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
References: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de> <1298887229-7987-4-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1298887229-7987-4-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281811.45277.arnd@arndb.de>
X-Provags-ID: V02:K0:Do5GdVCh+uUtzLE39c5vR7Mc1bwGOB9AYp+Tl01vPO/
 c5zqcU5aZD/Kvw4YgZ9ld7wlWnNZUOHYo4b+USoj4X0WsHjCgt
 LoFD3Ua4R0x6Jc5OAAMXJLhn1fFcMNMfn1OEH+As6TxGKwdDwP
 gjAfIwdqMpq6ox8hYoVFTw3yrGw0wQOhhakvI2wTd19Bn6BNZJ
 5S8bctmI2rihrpzg3t9mA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

I've had a brief look around the driver. It looks reasonable in general,
but the division into subdrivers feels a bit ad-hoc. If all the components
are built into a single module, I don't see the need for separating the
data by functional units by file. It seems simple enough to turn this
into a layered driver with multiple sub-devices each derived from a 
platform_device on its own.

On Monday 28 February 2011, Sascha Hauer wrote:
>  arch/arm/plat-mxc/include/mach/ipu-v3.h |   49 +++
>  drivers/video/Kconfig                   |    2 +
>  drivers/video/Makefile                  |    1 +
>  drivers/video/imx-ipu-v3/Kconfig        |   10 +
>  drivers/video/imx-ipu-v3/Makefile       |    3 +
>  drivers/video/imx-ipu-v3/ipu-common.c   |  666 +++++++++++++++++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-cpmem.c    |  612 ++++++++++++++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-dc.c       |  364 +++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-di.c       |  550 +++++++++++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-dmfc.c     |  355 ++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-dp.c       |  476 ++++++++++++++++++++++
>  drivers/video/imx-ipu-v3/ipu-prv.h      |  216 ++++++++++
>  include/video/imx-ipu-v3.h              |  219 ++++++++++

I wonder if this is something that would fit better in drivers/gpu instead
of drivers/video. We recently discussed the benefits of KMS vs fb drivers,
and I think it would be good to be prepared for making this a KMS driver
in the long run, even if the immediate target has to be a simple frame buffer
driver.

> +#include "ipu-prv.h"
> +
> +static struct clk *ipu_clk;
> +static struct device *ipu_dev;
> +
> +static DEFINE_SPINLOCK(ipu_lock);
> +static DEFINE_MUTEX(ipu_channel_lock);
> +void __iomem *ipu_cm_reg;
> +void __iomem *ipu_idmac_reg;
> +
> +static int ipu_use_count;
> +
> +static struct ipu_channel channels[64];

Keeping these global limits you to just one ipu, and makes
understanding the code a little harder. How about moving
these variables into a struct ipu_data (or similar) that
is referenced from the platform_device?

> +EXPORT_SYMBOL(ipu_idmac_put);

Why not EXPORT_SYMBOL_GPL?

> +static LIST_HEAD(ipu_irq_handlers);
> +
> +static void ipu_irq_update_irq_mask(void)
> +{
> +	struct ipu_irq_handler *handler;
> +	int i;
> +
> +	DECLARE_IPU_IRQ_BITMAP(irqs);
> +
> +	bitmap_zero(irqs, IPU_IRQ_COUNT);
> +
> +	list_for_each_entry(handler, &ipu_irq_handlers, list)
> +		bitmap_or(irqs, irqs, handler->ipu_irqs, IPU_IRQ_COUNT);
> +
> +	for (i = 0; i < BITS_TO_LONGS(IPU_IRQ_COUNT); i++)
> +		ipu_cm_write(irqs[i], IPU_INT_CTRL(i + 1));
> +}
> +
> +int ipu_irq_add_handler(struct ipu_irq_handler *ipuirq)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ipu_lock, flags);
> +
> +	list_add_tail(&ipuirq->list, &ipu_irq_handlers);
> +	ipu_irq_update_irq_mask();
> +
> +	spin_unlock_irqrestore(&ipu_lock, flags);
> +	return 0;
> +}
> +EXPORT_SYMBOL(ipu_irq_add_handler);

The interrupt logic needs some comments. What are you trying to achieve here?

> +int ipu_wait_for_interrupt(int interrupt, int timeout_ms)
> +{
> +	struct ipu_irq_handler handler;
> +	DECLARE_COMPLETION_ONSTACK(completion);
> +	int ret;
> +
> +	bitmap_zero(handler.ipu_irqs, IPU_IRQ_COUNT);
> +	bitmap_set(handler.ipu_irqs, interrupt, 1);
> +
> +	ipu_cm_write(1 << (interrupt % 32), IPU_INT_STAT(interrupt / 32 + 1));
> +
> +	handler.handler = ipu_completion_handler;
> +	handler.context = &completion;
> +	ipu_irq_add_handler(&handler);
> +
> +	ret = wait_for_completion_timeout(&completion,
> +			msecs_to_jiffies(timeout_ms));
> +
> +	ipu_irq_remove_handler(&handler);
> +
> +	if (ret > 0)
> +		ret = 0;
> +	else
> +		ret = -ETIMEDOUT;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ipu_wait_for_interrupt);

If I understand this correctly, this is a very complicated way to implement
something that could be done with a single wait_event_timeout() and
wake_up_interruptible_all() from the irq handler.

> +static irqreturn_t ipu_irq_handler(int irq, void *desc)
> +{
> +	DECLARE_IPU_IRQ_BITMAP(status);
> +	struct ipu_irq_handler *handler;
> +	int i;
> +
> +	for (i = 0; i < BITS_TO_LONGS(IPU_IRQ_COUNT); i++) {
> +		status[i] = ipu_cm_read(IPU_INT_STAT(i + 1));
> +		ipu_cm_write(status[i], IPU_INT_STAT(i + 1));
> +	}
> +
> +	list_for_each_entry(handler, &ipu_irq_handlers, list) {
> +		DECLARE_IPU_IRQ_BITMAP(tmp);
> +		if (bitmap_and(tmp, status, handler->ipu_irqs, IPU_IRQ_COUNT))
> +			handler->handler(tmp, handler->context);
> +	}
> +
> +	return IRQ_HANDLED;
> +}

This needs to take spin_lock_irqsave before walking the ipu_irq_handlers
list, in order to prevent another CPU from modifying the list
while you are in the handler.

> +static int ipu_reset(void)
> +{
> +	int timeout = 10000;
> +	u32 val;
> +
> +	/* hard reset the IPU */
> +	val = readl(MX51_IO_ADDRESS(MX51_SRC_BASE_ADDR));
> +	val |= 1 << 3;
> +	writel(val, MX51_IO_ADDRESS(MX51_SRC_BASE_ADDR));
> +
> +	ipu_cm_write(0x807FFFFF, IPU_MEM_RST);
> +
> +	while (ipu_cm_read(IPU_MEM_RST) & 0x80000000) {
> +		if (!timeout--)
> +			return -ETIME;
> +		udelay(100);
> +	}

You have a timeout of over one second with udelay, which
is not acceptable on many systems. AFAICT, the function 
can sleep, so you can replace udelay with msleep(1), and
you should use a better logic to determine the end of the
loop:

	unsigned long timeout = jiffies + msecs_to_jiffies(1000);

	while (ipu_cm_read(IPU_MEM_RST) & 0x80000000) {
		if (time_after(jiffies, timeout))
			return -ETIME;
		msleep(1);
	}

> +static u32 *ipu_cpmem_base;
> +static struct device *ipu_dev;
> +
> +struct ipu_ch_param_word {
> +	u32 data[5];
> +	u32 res[3];
> +};
> +
> +struct ipu_ch_param {
> +	struct ipu_ch_param_word word[2];
> +};

Same comment as for the previous file
> +
> +static void __iomem *ipu_dc_reg;
> +static void __iomem *ipu_dc_tmpl_reg;
> +static struct device *ipu_dev;
> +
> +struct ipu_dc {
> +	unsigned int di; /* The display interface number assigned to this dc channel */
> +	unsigned int channel_offset;
> +};
> +
> +static struct ipu_dc dc_channels[10];

And here again.

> +static void ipu_dc_link_event(int chan, int event, int addr, int priority)
> +{
> +	u32 reg;
> +
> +	reg = __raw_readl(DC_RL_CH(chan, event));
> +	reg &= ~(0xFFFF << (16 * (event & 0x1)));
> +	reg |= ((addr << 8) | priority) << (16 * (event & 0x1));
> +	__raw_writel(reg, DC_RL_CH(chan, event));
> +}

Better use readl/writel instead of __raw_readl/__raw_writel, throughout the
code.

> +int ipu_di_init(struct platform_device *pdev, int id, unsigned long base,
> +		u32 module, struct clk *ipu_clk);
> +void ipu_di_exit(struct platform_device *pdev, int id);
> +
> +int ipu_dmfc_init(struct platform_device *pdev, unsigned long base,
> +		struct clk *ipu_clk);
> +void ipu_dmfc_exit(struct platform_device *pdev);
> +
> +int ipu_dp_init(struct platform_device *pdev, unsigned long base);
> +void ipu_dp_exit(struct platform_device *pdev);
> +
> +int ipu_dc_init(struct platform_device *pdev, unsigned long base,
> +		unsigned long template_base);
> +void ipu_dc_exit(struct platform_device *pdev);
> +
> +int ipu_cpmem_init(struct platform_device *pdev, unsigned long base);
> +void ipu_cpmem_exit(struct platform_device *pdev);

If you make the main driver an mfd device, the sub-drivers could become
real platform drivers, which can structure the layering in a more modular
way.
E.g. instead of a single module init function, each subdriver can be
a module by itself and look at the resources associated with the
platform device it matches.

	Arnd
