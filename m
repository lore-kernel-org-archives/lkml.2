Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab1LWUom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:44:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37230 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab1LWUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:44:39 -0500
Date: Fri, 23 Dec 2011 21:44:28 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@suse.de>, kernel@pengutronix.de,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial/efm32: add new driver
Message-ID: <20111223204428.GI24496@pengutronix.de>
References: <20111221202847.4ffeba10@bob.linux.org.uk>
 <1324561092-1945-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <201112231035.23215.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201112231035.23215.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On Fri, Dec 23, 2011 at 10:35:22AM +0000, Arnd Bergmann wrote:
> On Thursday 22 December 2011, Uwe Kleine-König wrote:
> 
> > @@ -0,0 +1,14 @@
> > +* Energymicro efm32 UART
> > +
> > +Required properties:
> > +- compatible : Should be "efm32,usart"
> > +- reg : Address and length of the register set
> > +- interrupts : Should contain uart interrupt
> > +
> > +Example:
> > +
> > +uart@0x4000c400 {
> > +	compatible = "efm32,usart";
> > +	reg = <0x4000c400 0x400>;
> > +	interrupts = <15>;
> > +};
> 
> Do you know if the usart was actually designed by energymicro or licensed
> from another party? If it is a licensed part, it would be better to
> list the "compatible" value under the company name that made it.
I don't know so I passed the question to them.
 
> I would suggest that you also support the "clock-frequency" and/or
> "current-speed" properties that are defined for serial ports, see the
> of_serial driver.
I will have a look to find out what they mean and update the patch
accordingly.
 
> > diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> > index 925a1e5..cfeb0f3 100644
> > --- a/drivers/tty/serial/Kconfig
> > +++ b/drivers/tty/serial/Kconfig
> > @@ -1610,4 +1610,14 @@ config SERIAL_XILINX_PS_UART_CONSOLE
> >  	help
> >  	  Enable a Xilinx PS UART port to be the system console.
> >  
> > +config SERIAL_EFM32_USART
> > +	bool "EFM32 USART port."
> > +	depends on ARCH_EFM32
> > +	select SERIAL_CORE
> 
> Why not tristate? If it's not a console, you should be able to use
> it as a module.
Hmm, in theory yes. (In practice modules on mmu are not that trivial,
see the corresponding thread on lakml.) I will update but I guess I can
only build test that configuration.
 
> I would generally prefer not to make the driver depend on the
> platform, so we can get better compile time coverage. I think a better
> set of dependencies would be
> 
> 	depends on HAVE_CLK
> 	depends on OF
> 	default ARCH_EFM32
I'd prefer something like:

	depends on HAVE_CLK
	depends on ARCH_EFM32 || I_DO_BUILD_COVERAGE_TESTING

This would make it easier for Joe User to pick the right options for his
kernel (assuming he found out to better keep I_DO_BUILD_COVERAGE_TESTING
disabled). There is no hard dependency on OF in the driver and I guess
at least the in-production (and out-of-tree) usage will still stick to
non-OF because it saves some RAM. So I'd prefer not to add that.
(And it would help build coverage testing ;-)

> > +static void efm32_usart_write32(struct efm32_usart_port *efm_port,
> > +		u32 value, unsigned offset)
> > +{
> > +	__raw_writel(value, efm_port->port.membase + offset);
> > +}
> > +
> > +static u32 efm32_usart_read32(struct efm32_usart_port *efm_port,
> > +		unsigned offset)
> > +{
> > +	return __raw_readl(efm_port->port.membase + offset);
> > +}
> 
> Please use writel_relaxed() instead of __raw_writel().
ok

> > +static int __devinit efm32_usart_probe(struct platform_device *pdev)
> > +{
> > +	struct efm32_usart_port *efm_port;
> > +	struct resource *res;
> > +	int ret;
> > +
> > +	efm_port = kzalloc(sizeof(*efm_port), GFP_KERNEL);
> > +	if (!efm_port) {
> > +		dev_dbg(&pdev->dev, "failed to allocate private data\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res) {
> > +		ret = -ENODEV;
> > +		dev_dbg(&pdev->dev, "failed to determine base address\n");
> > +		goto err_get_base;
> > +	}
> > +
> > +	if (resource_size(res) < 60) {
> > +		ret = -EINVAL;
> > +		dev_dbg(&pdev->dev, "memory resource too small\n");
> > +		goto err_too_small;
> > +	}
> 
> of_iomap() would be simpler here. I think you can leave out the assignment to 
> mapbase, and go straight to membase here.
but ioremap is only done in .request_port, so it's necessary to have two
steps here, isn't it?
 
> checking the resource size should not be necessary, because that would imply
> having an invalid device tree, which you don't have to check at run time.
hmm, I prefer an error message over an access to unmapped memory even if
that can only happen when the device tree is broken.

Best regards and thanks for your comments,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
