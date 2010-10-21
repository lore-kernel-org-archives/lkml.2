Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0JUXNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:13:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab0JUXNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:13:14 -0400
Date: Thu, 21 Oct 2010 16:12:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyril Chemparathy <cyril@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Subject: Re: [PATCH v3 01/12] misc: add driver for sequencer serial port
Message-Id: <20101021161224.b4c0b623.akpm@linux-foundation.org>
In-Reply-To: <1287694873-12904-2-git-send-email-cyril@ti.com>
References: <1287694873-12904-1-git-send-email-cyril@ti.com>
	<1287694873-12904-2-git-send-email-cyril@ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 17:01:02 -0400
Cyril Chemparathy <cyril@ti.com> wrote:

> TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
> device.  It has a built-in programmable execution engine that can be programmed
> to operate as almost any serial bus (I2C, SPI, EasyScale, and others).
> 
> This patch adds a driver for this controller device.  The driver does not
> expose a user-land interface.  Protocol drivers built on top of this layer are
> expected to remain in-kernel.
> 
>
> ...
>
> +struct ti_ssp_dev_data {
> +	const char	*dev_name;
> +	unsigned long	iosel; /* see note below */
> +	unsigned long	config;
> +	const void	*pdata;
> +	int		pdata_sz;


I suppose this really should have type size_t.  Also a better name is
"pdata_size" - we prefer to avoid this random omission of vowels from
kernel identifiers.  Just spell it out; it makes it easier to remember.

> +};
> +
> +struct ti_ssp_data {
> +	unsigned long		out_clock;
> +	struct ti_ssp_dev_data	dev_data[2];
> +};
> +
>
> ...
>
> +config TI_SSP
> +	depends on ARCH_DAVINCI_TNETV107X
> +	tristate "Sequencer Serial Port support"
> +	default y

Was `y' a good choice?

> +	---help---
> +	  Say Y here if you want support for the Sequencer Serial Port
> +	  in a Texas Instruments TNETV107X SoC.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ti_ssp.
>
> ...
>
> +#define dev2ssp(dev)	dev_get_drvdata(dev->parent)
> +#define dev2port(dev)	(to_platform_device(dev)->id)

These could be implemented as C funtions.  That's superior because of
the typechecking.  At present dev2ssp() will happily compile and fail
at runtime if passed anystructure which has a 'const struct device
*parent'.

> +/* Register Access Helpers */
> +static inline u32 ssp_read(struct ti_ssp *ssp, int reg)
> +{
> +	return __raw_readl(ssp->regs + reg);
> +}
> +
> +static inline void ssp_write(struct ti_ssp *ssp, int reg, u32 val)
> +{
> +	__raw_writel(val, ssp->regs + reg);
> +}

Why are the __raw functions used here?

> +static inline void ssp_rmw(struct ti_ssp *ssp, int reg, u32 mask, u32 bits)
> +{
> +	u32 val = ssp_read(ssp, reg);
> +	val &= ~mask;
> +	val |= bits;
> +	ssp_write(ssp, reg, val);
> +}

Locking?  Perhaps this function must be called under ssp->lock?  If so,
that should be documented here and it appears that not all callsites
actually do that correctly.

>
> ...
>
> +static int __set_iosel(struct ti_ssp *ssp, int port, u32 iosel)
> +{
> +	unsigned val;
> +
> +	/* IOSEL1 gets the least significant 16 bits */
> +	val = ssp_read(ssp, REG_IOSEL_1);
> +	val &= 0xffff << (port ? 0 : 16);
> +	val |= (iosel & 0xffff) << (port ? 16 : 0);
> +	ssp_write(ssp, REG_IOSEL_1, val);
> +
> +	/* IOSEL2 gets the most significant 16 bits */
> +	val = ssp_read(ssp, REG_IOSEL_2);
> +	val &= 0x0007 << (port ? 0 : 16);
> +	val |= (iosel & 0x00070000) >> (port ? 0 : 16);
> +	ssp_write(ssp, REG_IOSEL_2, val);

More rmw's which need locking.  It should be documented please.  Both
callers get it right this time.

> +	return 0;
> +}
> +
>
> ...
>
> +int ti_ssp_run(struct device *dev, u32 pc, u32 input, u32 *output)
> +{
> +	struct ti_ssp *ssp = dev2ssp(dev);
> +	int port = dev2port(dev);
> +	int count;
> +
> +	if (pc & ~(0x3f))
> +		return -EINVAL;
> +
> +	ssp_port_write(ssp, port, PORT_ADDR, input >> 16);
> +	ssp_port_write(ssp, port, PORT_DATA, input & 0xffff);
> +	ssp_port_rmw(ssp, port, PORT_CFG_1, 0x3f, pc);
> +
> +	ssp_port_set_bits(ssp, port, PORT_CFG_1, SSP_START);
> +
> +	for (count = 10000; count; count--) {
> +		if ((ssp_port_read(ssp, port, PORT_CFG_1) & SSP_BUSY) == 0)
> +			break;
> +		udelay(1);
> +	}
> +
> +	if (output) {
> +		*(output) = (ssp_port_read(ssp, port, PORT_ADDR) << 16) |
> +			    (ssp_port_read(ssp, port, PORT_DATA) &  0xffff);
> +	}
> +
> +	if (!count) {
> +		dev_err(ssp->dev, "timed out waiting for SSP operation\n");
> +		return -EIO;
> +	}

There doesn't seem much point in writing to *output if the port_read()
timed out?

>
> ...
>

That's all fairly minor stuff.  It looks Good Enough For Linux to me.
