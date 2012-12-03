Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2LCOvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:51:15 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53685 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2LCOgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:11 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [linux-keystone] Re: [linux-keystone] [PATCH] spi: davinci: add OF support for the spi controller
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-keystone@list.ti.com
In-Reply-To: <50B939E2.6010901@ti.com>
References: <1352755702-21488-1-git-send-email-m-karicheri2@ti.com> <20121115162042.A24F13E194B@localhost> <50B939E2.6010901@ti.com>
Date: Mon, 03 Dec 2012 14:36:03 +0000
Message-Id: <20121203143603.B8E9C3E0A4C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 17:57:38 -0500, Murali Karicheri <m-karicheri2@ti.com> wrote:
> On 11/15/2012 11:20 AM, Grant Likely wrote:
> > On Mon, 12 Nov 2012 16:28:22 -0500, Murali Karicheri <m-karicheri2@ti.com> wrote:
> >> This adds OF support to DaVinci SPI controller to configure platform
> >> data through device bindings.
> >>
> >> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> > Hi Murali,
> >
> > Comments below...
> >
> >> ---
> >>   .../devicetree/bindings/spi/spi-davinci.txt        |   50 ++++++++++++
> >>   drivers/spi/spi-davinci.c                          |   80 +++++++++++++++++++-
> >>   2 files changed, 126 insertions(+), 4 deletions(-)
> >>   create mode 100644 Documentation/devicetree/bindings/spi/spi-davinci.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/spi/spi-davinci.txt b/Documentation/devicetree/bindings/spi/spi-davinci.txt
> >> new file mode 100644
> >> index 0000000..0369369
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/spi/spi-davinci.txt
> >> @@ -0,0 +1,50 @@
> >> +Davinci SPI controller device bindings
> >> +
> >> +Required properties:
> >> +- #address-cells: number of cells required to define a chip select
> >> +	address on the SPI bus.
> > Will this *ever* be something other than '1'?
> >
> >> +- #size-cells: should be zero.
> >> +- compatible:
> >> +	- "ti,davinci-spi"
> > Please use the actual model of the chip here. Don't try to be generic
> > with the compatible string. A driver can bind against more than one
> > compatible value and new devices can claim compatiblity with old by
> > including the old compatible string in this list.
> >
> >> +- reg: Offset and length of SPI controller register space
> >> +- ti,davinci-spi-version: SPI version :- "1.0" or "2.0"
> > Usually this is determined from the compatible value directly (which is
> > why compatible strings shouldn't be generic). Don't use a separate
> > property for it.
> >
> >> +- ti,davinci-spi-num-cs: Number of chip selects
> >> +- ti,davinci-spi-intr-line: interrupt line used to connect the SPI
> >> +	IP to the ARM interrupt controller withn the SoC. Possible values
> >> +	are 0 and 1.
> > ? Isn't that what the interrupts property is for? I don't understand why
> > this is needed from the description.
> >
> >> +- interrupts: interrupt number offset at the irq parent
> >> +- clocks: spi clk phandle
> >> +
> >> +Example of a NOR flash slave device (n25q032) connected to DaVinci
> >> +SPI controller device over the SPI bus.
> >> +
> >> +spi:spi0@20BF0000 {
> > spi@20BF0000  (use 'spi' not 'spi0')
> >
> >> +	#address-cells			= <1>;
> >> +	#size-cells			= <0>;
> >> +	compatible			= "ti,davinci-spi";
> >> +	reg				= <0x20BF0000 0x1000>;
> >> +	ti,davinci-spi-version		= "1.0";
> >> +	ti,davinci-spi-num-cs		= <4>;
> >> +	ti,davinci-spi-intr-line	= <0>;
> >> +	interrupts			= <338>;
> >> +	clocks				= <&clkspi>;
> >> +
> >> +	flash: n25q032@0 {
> >> +		#address-cells = <1>;
> >> +		#size-cells = <1>;
> >> +		compatible = "st,m25p32";
> >> +		spi-max-frequency = <25000000>;
> >> +		reg = <0>;
> >> +
> >> +		partition@0 {
> >> +			label = "u-boot-spl";
> >> +			reg = <0x0 0x80000>;
> >> +			read-only;
> >> +		};
> >> +
> >> +		partition@1 {
> >> +			label = "test";
> >> +			reg = <0x80000 0x380000>;
> >> +		};
> >> +	};
> >> +};
> >> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
> >> index 71a6423..0f50319 100644
> >> --- a/drivers/spi/spi-davinci.c
> >> +++ b/drivers/spi/spi-davinci.c
> >> @@ -26,6 +26,9 @@
> >>   #include <linux/err.h>
> >>   #include <linux/clk.h>
> >>   #include <linux/dma-mapping.h>
> >> +#include <linux/of.h>
> >> +#include <linux/of_device.h>
> >> +#include <linux/of_irq.h>
> >>   #include <linux/spi/spi.h>
> >>   #include <linux/spi/spi_bitbang.h>
> >>   #include <linux/slab.h>
> >> @@ -788,6 +791,69 @@ rx_dma_failed:
> >>   	return r;
> >>   }
> >>   
> >> +#if defined(CONFIG_OF)
> >> +static const struct of_device_id davinci_spi_of_match[] = {
> >> +	{
> >> +		.compatible = "ti,davinci-spi",
> >> +	},
> >> +	{ },
> >> +};
> >> +MODULE_DEVICE_TABLE(of, davini_spi_of_match);
> >> +
> >> +/**
> >> + * spi_davinci_get_pdata - Get platform_data from DTS binding
> >> + * @pdev: ptr to platform data
> >> + *
> >> + * Parses and populate platform_data from device tree bindings.
> >> + *
> >> + * NOTE: Not all platform_data params are supported currently.
> >> + */
> >> +static struct davinci_spi_platform_data
> >> +	*spi_davinci_get_pdata(struct platform_device *pdev)
> >> +{
> >> +	struct device_node *node = pdev->dev.of_node;
> >> +	struct davinci_spi_platform_data *pdata;
> >> +	unsigned int num_cs, intr_line = 0;
> >> +	const char *version;
> >> +
> >> +	if (pdev->dev.platform_data)
> >> +		return pdev->dev.platform_data;
> >> +
> >> +	if (!pdev->dev.of_node)
> >> +		return NULL;
> >> +
> >> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> >> +	pdev->dev.platform_data = pdata;
> >> +	if (!pdata)
> >> +		return NULL;
> > Since pdata must always be present, roll it directly into struct
> > spi_davinci and get rid of the kzmalloc here. It is less expensive and
> > is simpler code.
> Grant,
> 
> Could you elaborate a bit? What you mean by rolling pdata into 
> spi_davinci? I believe you are referring
> to davinci_spi. Are you saying change following:-
> 
> struct davinci_spi {
> 
> ...
> struct davinci_spi_platform_data *pdata; <= to struct 
> davinci_spi_platform_data pdata
> 
> };

Not quite. I mean adding this:
struct davinci_spi {
	...
	struct davinci_spi_platform_data pdata;
};

And then in the probe path do something like:
{
	struct davinci_spi_platform_data *pdata = pdev.dev.platform_data;
...

	if (pdata)
		dspi->pdata = *pdata; /* Copy from platform_data */
	else
		spi_davinci_get_pdata(pdev); /* decode from DT */
};

My point is that the driver needs a copy of the pdata. By embedding it
into struct davinci_spi it doesn't need to be allocated with a separate
devm_kzalloc() call.

This is a minor point though. You could do it either way.

*However* make sure that the driver *does not* save the pointer into
pdev->dev.platform_data. That field is read-only for drivers. If a
driver allocates a separate pdata structure, then it needs to store the
pointer to it inside its private data structure.

g.
