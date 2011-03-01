Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1CAJPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:15:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47160 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1CAJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:15:50 -0500
Date: Tue, 1 Mar 2011 10:15:44 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/8] Add a mfd IPUv3 driver
Message-ID: <20110301091544.GK29521@pengutronix.de>
References: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de>
 <1298887229-7987-4-git-send-email-s.hauer@pengutronix.de>
 <201102281811.45277.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102281811.45277.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:35:24 up 12 days, 20:32, 16 users,  load average: 0.10, 0.28,
 0.36
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Feb 28, 2011 at 06:11:45PM +0100, Arnd Bergmann wrote:
> Hi Sascha,
> 
> I've had a brief look around the driver. It looks reasonable in general,
> but the division into subdrivers feels a bit ad-hoc. If all the components
> are built into a single module, I don't see the need for separating the
> data by functional units by file. It seems simple enough to turn this
> into a layered driver with multiple sub-devices each derived from a 
> platform_device on its own.

Ok, will do.

> 
> On Monday 28 February 2011, Sascha Hauer wrote:
> >  arch/arm/plat-mxc/include/mach/ipu-v3.h |   49 +++
> >  drivers/video/Kconfig                   |    2 +
> >  drivers/video/Makefile                  |    1 +
> >  drivers/video/imx-ipu-v3/Kconfig        |   10 +
> >  drivers/video/imx-ipu-v3/Makefile       |    3 +
> >  drivers/video/imx-ipu-v3/ipu-common.c   |  666 +++++++++++++++++++++++++++++++
> >  drivers/video/imx-ipu-v3/ipu-cpmem.c    |  612 ++++++++++++++++++++++++++++
> >  drivers/video/imx-ipu-v3/ipu-dc.c       |  364 +++++++++++++++++
> >  drivers/video/imx-ipu-v3/ipu-di.c       |  550 +++++++++++++++++++++++++
> >  drivers/video/imx-ipu-v3/ipu-dmfc.c     |  355 ++++++++++++++++
> >  drivers/video/imx-ipu-v3/ipu-dp.c       |  476 ++++++++++++++++++++++
> >  drivers/video/imx-ipu-v3/ipu-prv.h      |  216 ++++++++++
> >  include/video/imx-ipu-v3.h              |  219 ++++++++++
> 
> I wonder if this is something that would fit better in drivers/gpu instead
> of drivers/video. We recently discussed the benefits of KMS vs fb drivers,
> and I think it would be good to be prepared for making this a KMS driver
> in the long run, even if the immediate target has to be a simple frame buffer
> driver.

When turning this into a kms driver moving the source code will be the
smallest problem I guess.
I have no preference where to put this code. First it was in
drivers/mfd/ and it felt wrong because there seems to be too much code
in it a mfd maintainer shouldn't be bothered with. drivers/video/ seems
to be wrong because this code will probably support cameras which belong
to drivers/media/video/. So if there's consensus on drivers/gpu/ I will
happily put it there.
What directory do you suggest? drivers/gpu/ or some subdirectory
(drm/vga)?

> 
> > +#include "ipu-prv.h"
> > +
> > +static struct clk *ipu_clk;
> > +static struct device *ipu_dev;
> > +
> > +static DEFINE_SPINLOCK(ipu_lock);
> > +static DEFINE_MUTEX(ipu_channel_lock);
> > +void __iomem *ipu_cm_reg;
> > +void __iomem *ipu_idmac_reg;
> > +
> > +static int ipu_use_count;
> > +
> > +static struct ipu_channel channels[64];
> 
> Keeping these global limits you to just one ipu, and makes
> understanding the code a little harder. How about moving
> these variables into a struct ipu_data (or similar) that
> is referenced from the platform_device?
> 
> > +EXPORT_SYMBOL(ipu_idmac_put);
> 
> Why not EXPORT_SYMBOL_GPL?
> 
> > +static LIST_HEAD(ipu_irq_handlers);
> > +
> > +static void ipu_irq_update_irq_mask(void)
> > +{
> > +	struct ipu_irq_handler *handler;
> > +	int i;
> > +
> > +	DECLARE_IPU_IRQ_BITMAP(irqs);
> > +
> > +	bitmap_zero(irqs, IPU_IRQ_COUNT);
> > +
> > +	list_for_each_entry(handler, &ipu_irq_handlers, list)
> > +		bitmap_or(irqs, irqs, handler->ipu_irqs, IPU_IRQ_COUNT);
> > +
> > +	for (i = 0; i < BITS_TO_LONGS(IPU_IRQ_COUNT); i++)
> > +		ipu_cm_write(irqs[i], IPU_INT_CTRL(i + 1));
> > +}
> > +
> > +int ipu_irq_add_handler(struct ipu_irq_handler *ipuirq)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&ipu_lock, flags);
> > +
> > +	list_add_tail(&ipuirq->list, &ipu_irq_handlers);
> > +	ipu_irq_update_irq_mask();
> > +
> > +	spin_unlock_irqrestore(&ipu_lock, flags);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ipu_irq_add_handler);
> 
> The interrupt logic needs some comments. What are you trying to achieve here?

The IPU has 463 status bits which can trigger an interrupt. Most
of them are associated to channels, some are general interrupts. My
problem is that I don't know how the interrupts will be used by drivers
later. Most drivers will probably use only one interrupt but others
will be interested in a larger group of interrupts. So I decided to
use a bitmap allowing each driver to register for groups of event
it is interested in.

> 
> > +int ipu_wait_for_interrupt(int interrupt, int timeout_ms)
> > +{
> > +	struct ipu_irq_handler handler;
> > +	DECLARE_COMPLETION_ONSTACK(completion);
> > +	int ret;
> > +
> > +	bitmap_zero(handler.ipu_irqs, IPU_IRQ_COUNT);
> > +	bitmap_set(handler.ipu_irqs, interrupt, 1);
> > +
> > +	ipu_cm_write(1 << (interrupt % 32), IPU_INT_STAT(interrupt / 32 + 1));
> > +
> > +	handler.handler = ipu_completion_handler;
> > +	handler.context = &completion;
> > +	ipu_irq_add_handler(&handler);
> > +
> > +	ret = wait_for_completion_timeout(&completion,
> > +			msecs_to_jiffies(timeout_ms));
> > +
> > +	ipu_irq_remove_handler(&handler);
> > +
> > +	if (ret > 0)
> > +		ret = 0;
> > +	else
> > +		ret = -ETIMEDOUT;
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(ipu_wait_for_interrupt);
> 
> If I understand this correctly, this is a very complicated way to implement
> something that could be done with a single wait_event_timeout() and
> wake_up_interruptible_all() from the irq handler.

I added this as a convenience function for a common usecase: wait until
a frame is done or wait until some FIFOs are drained.
I think I can switch this into wait_event_timeout(), but lets first see
if my bitmap-irq implementation survives the review.

> 
> > +static irqreturn_t ipu_irq_handler(int irq, void *desc)
> > +{
> > +	DECLARE_IPU_IRQ_BITMAP(status);
> > +	struct ipu_irq_handler *handler;
> > +	int i;
> > +
> > +	for (i = 0; i < BITS_TO_LONGS(IPU_IRQ_COUNT); i++) {
> > +		status[i] = ipu_cm_read(IPU_INT_STAT(i + 1));
> > +		ipu_cm_write(status[i], IPU_INT_STAT(i + 1));
> > +	}
> > +
> > +	list_for_each_entry(handler, &ipu_irq_handlers, list) {
> > +		DECLARE_IPU_IRQ_BITMAP(tmp);
> > +		if (bitmap_and(tmp, status, handler->ipu_irqs, IPU_IRQ_COUNT))
> > +			handler->handler(tmp, handler->context);
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> 
> This needs to take spin_lock_irqsave before walking the ipu_irq_handlers
> list, in order to prevent another CPU from modifying the list
> while you are in the handler.

ok.

> 
> > +static int ipu_reset(void)
> > +{
> > +	int timeout = 10000;
> > +	u32 val;
> > +
> > +	/* hard reset the IPU */
> > +	val = readl(MX51_IO_ADDRESS(MX51_SRC_BASE_ADDR));
> > +	val |= 1 << 3;
> > +	writel(val, MX51_IO_ADDRESS(MX51_SRC_BASE_ADDR));
> > +
> > +	ipu_cm_write(0x807FFFFF, IPU_MEM_RST);
> > +
> > +	while (ipu_cm_read(IPU_MEM_RST) & 0x80000000) {
> > +		if (!timeout--)
> > +			return -ETIME;
> > +		udelay(100);
> > +	}
> 
> You have a timeout of over one second with udelay, which
> is not acceptable on many systems. AFAICT, the function 
> can sleep, so you can replace udelay with msleep(1), and
> you should use a better logic to determine the end of the
> loop:
> 
> 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
> 
> 	while (ipu_cm_read(IPU_MEM_RST) & 0x80000000) {
> 		if (time_after(jiffies, timeout))
> 			return -ETIME;
> 		msleep(1);
> 	}

ok.

> 
> > +static u32 *ipu_cpmem_base;
> > +static struct device *ipu_dev;
> > +
> > +struct ipu_ch_param_word {
> > +	u32 data[5];
> > +	u32 res[3];
> > +};
> > +
> > +struct ipu_ch_param {
> > +	struct ipu_ch_param_word word[2];
> > +};
> 
> Same comment as for the previous file
> > +
> > +static void __iomem *ipu_dc_reg;
> > +static void __iomem *ipu_dc_tmpl_reg;
> > +static struct device *ipu_dev;
> > +
> > +struct ipu_dc {
> > +	unsigned int di; /* The display interface number assigned to this dc channel */
> > +	unsigned int channel_offset;
> > +};
> > +
> > +static struct ipu_dc dc_channels[10];
> 
> And here again.
> 
> > +static void ipu_dc_link_event(int chan, int event, int addr, int priority)
> > +{
> > +	u32 reg;
> > +
> > +	reg = __raw_readl(DC_RL_CH(chan, event));
> > +	reg &= ~(0xFFFF << (16 * (event & 0x1)));
> > +	reg |= ((addr << 8) | priority) << (16 * (event & 0x1));
> > +	__raw_writel(reg, DC_RL_CH(chan, event));
> > +}
> 
> Better use readl/writel instead of __raw_readl/__raw_writel, throughout the
> code.
> 
> > +int ipu_di_init(struct platform_device *pdev, int id, unsigned long base,
> > +		u32 module, struct clk *ipu_clk);
> > +void ipu_di_exit(struct platform_device *pdev, int id);
> > +
> > +int ipu_dmfc_init(struct platform_device *pdev, unsigned long base,
> > +		struct clk *ipu_clk);
> > +void ipu_dmfc_exit(struct platform_device *pdev);
> > +
> > +int ipu_dp_init(struct platform_device *pdev, unsigned long base);
> > +void ipu_dp_exit(struct platform_device *pdev);
> > +
> > +int ipu_dc_init(struct platform_device *pdev, unsigned long base,
> > +		unsigned long template_base);
> > +void ipu_dc_exit(struct platform_device *pdev);
> > +
> > +int ipu_cpmem_init(struct platform_device *pdev, unsigned long base);
> > +void ipu_cpmem_exit(struct platform_device *pdev);
> 
> If you make the main driver an mfd device, the sub-drivers could become
> real platform drivers, which can structure the layering in a more modular
> way.
> E.g. instead of a single module init function, each subdriver can be
> a module by itself and look at the resources associated with the
> platform device it matches.

ok.


Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
