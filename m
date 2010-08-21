Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0HUTaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 15:30:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46487 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752055Ab0HUTaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 15:30:17 -0400
Date: Sat, 21 Aug 2010 20:30:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH 1/2] spi/spi_s3c64xx: Make probe
	more robust against missing board config
Message-ID: <20100821193015.GA16455@opensource.wolfsonmicro.com>
References: <1282321028-32196-1-git-send-email-broonie@opensource.wolfsonmicro.com> <AANLkTimggbZqgv=eKe+wx8YvUX5vOppDfmwpLwTgxJFM@mail.gmail.com> <20100821100855.GA5545@opensource.wolfsonmicro.com> <AANLkTikbGR4wWUEHjR74UFu8P-w9us3ZpKgmG+yDukfC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikbGR4wWUEHjR74UFu8P-w9us3ZpKgmG+yDukfC@mail.gmail.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 10:58:36PM +0900, Jassi Brar wrote:
> On Sat, Aug 21, 2010 at 7:08 PM, Mark Brown
> > On Sat, Aug 21, 2010 at 10:45:56AM +0900, Jassi Brar wrote:

> >>      The movement of sci assignment and check doesn't make any
> >> difference because
> >>       we already check for presence of platform_data and DMA-Tx,Rx and
> >> IO base is
> >>       set irrespective of calling s3c64xx_spi_set_info()

> > While it does check for those things for at least the 6410 they're all
> > unconditionally set up by dev-spi.c so the tests all pass and we make it
> > down into to the clk_get() which then falls over horribly.

> Those parameters are SoC specific and hence will be always available to
> platform devices.
> Clock selection and num_cs(number of slaves attached to the SPI bus) are
> machine specific and hence responsibility of the machine developer to
> set appropriately via s3c64xx_spi_set_info()

Sure, the split does make sense - it's just that this means that we need
to do something to make sure that s3c64xx_spi_set_info() got called.

> > The problem with num_cs is that it gets interpreted by a custom function
> > provided by the board driver so we really can't say anything about what
> > it does.

> num_cs is passed on as such to the SPI core to master->num_chipselect
> which is strictly checked for before a master is created.

Ah, too many variables with similar functions.

> > support gpiolib chip selects - my first thought when I saw that stuff
> > was that it seemed like something that lots of SPI controllers would be
> > able to share but I didn't look at the overall SPI code for long enough
> > to figure out what was going on there.

> we have common spi bitbanging driver that takes only four gpio pins
> and work like a charm.

Though it does burn CPU rather a lot which makes them unsuitable for
some applications where SPI is used for bulk data transfers or CPU is
otherwise tight.  In general if you've got an actual SPI controller it's
much nicer to use it.

> In order to enable users use multiple CS per master, in spi_s3c64xx.c
> the single CS feature provided by the controller is deliberately left unused
> and the driver accepts a gpio per slave and manually controls it. Though
> the callbacks and arguments are designed so that a simple gpio number
> and gpio_set can be assigned by the machine code.

It did occur to me that a nice way of dealing with this would be to have
the driver default to using the built in chip select (even if driven as
a GPIO for the sake of code simplicity) but leave the current method
there as an override.  That way if people are using the IP block in the
"natural" manner they'd have less to set up.
