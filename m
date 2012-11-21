Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2KUPdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:33:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40417 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2KUPdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:33:44 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [linux-keystone] Re: [linux-keystone] [PATCH] spi: davinci: add OF support for the spi controller
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-keystone@list.ti.com
In-Reply-To: <50A66AAE.3070707@ti.com>
References: <1352755702-21488-1-git-send-email-m-karicheri2@ti.com> <20121115162042.A24F13E194B@localhost> <50A66AAE.3070707@ti.com>
Date: Wed, 21 Nov 2012 15:33:39 +0000
Message-Id: <20121121153339.A4B233E0A47@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012 11:32:46 -0500, Murali Karicheri <m-karicheri2@ti.com> wrote:
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
> Will add "should be set to 1" as only once cell is used for this.
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
> Ok. Based on the ablve two comments, I think I will remove 
> davinci-spi-version property. So driver will add two compatibility 
> strings "ti,davinci-spi1" and "ti,davinci-spi2" amd match data for 
> ti,davinci-spi2 will have the version set to 2 so that driver can use it 
> to behave differently. This way DTS file for a board can set the 
> compatibility string to use different version of the IP for the driver. 
> Do you think I got you right?

Mostly, but what would be better is something like:

"ti,davinci(model)-spi" and "ti,keystone(model)-spi" replacing (model)
with the actual chip part number.

It is always better to use real part names than to make up meaninless
'1', '2' numbers. Newer devices can include the older compatible part
in the compatible property. For example:

	compatible = "ti,keystone-gen2-spi", "ti,keystone-original-spi";

(I'm making up part names here, but you get the idea). So a driver that
binds against "ti,keystone-original-spi" will work with a newer
keystone gen2.

> >> +- ti,davinci-spi-num-cs: Number of chip selects
> >> +- ti,davinci-spi-intr-line: interrupt line used to connect the SPI
> >> +	IP to the ARM interrupt controller withn the SoC. Possible values
> >> +	are 0 and 1.
> > ? Isn't that what the interrupts property is for? I don't understand why
> > this is needed from the description.
> Based on the IP manual, there are two interrupt lines coming from the IP 
> and only one of them is tied to the interrupt controller in a specific 
> SoC. There is a register to program which interrupt line is used based 
> on the SoC configuration. So this is different from interrupts.

Okay.

g.
