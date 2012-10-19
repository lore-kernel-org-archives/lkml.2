Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030389Ab2JSNu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:50:28 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:45079 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab2JSNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:50:25 -0400
Date: Fri, 19 Oct 2012 09:51:47 -0400
From: Matt Porter <mporter@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: "Philip, Avinash" <avinashphilip@ti.com>, linux@arm.linux.org.uk,
        tony@atomide.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH v2] arm/dts: AM33XX: Add SPI device tree data
Message-ID: <20121019135147.GF25164@beef>
References: <1347946228-25874-1-git-send-email-avinashphilip@ti.com>
 <50810E2F.5@ti.com>
 <20121019113016.GE25164@beef>
 <50814A5A.8070206@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50814A5A.8070206@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 02:40:58PM +0200, Benoit Cousson wrote:
> Hi Matt,
> 
> On 10/19/2012 01:30 PM, Matt Porter wrote:
> > On Fri, Oct 19, 2012 at 10:24:15AM +0200, Benoit Cousson wrote:
> >> Hi Avinash,
> >>
> >> This look good to me except the: status = "disabled".
> >>
> >> The "disabled" should be reserved for variant that does not contain the IP.
> >> Is it the case here?
> > 
> > http://comments.gmane.org/gmane.linux.drivers.devicetree/18968 is what
> > I've been going by with the DTS support in the EDMA dmaengine series. It
> > does make the most sense to only enable what you need in the
> > <board>.dts.
> 
> Thanks, I missed that thread. That being said, there is no real rational
> :-)
> It seems to be a preference more than anything else.

Ok, agreed. Here's an example to attempt to illustrate why the one true
preference is to default to disabled. :) Let's say I'm a system developer
with a custom board in the default enabled model. My board makes use of,
say, mmc1 and uart1 on am33xx (oh yes, we must fix the numbering that
doesn't match the TRM) only. In that case, I develop a board.dts
with:

	uart2: serial@foo {
		status = "disabled";
	};
	.
	.
	.
	uart6: serial@bar {
		status = "disabled";
	};

	&mmc1 {
        	vmmc-supply = <&ldo3_reg>;
	};

	&mmc2 {
		status = "disabled";
	};

	&mmc3 {
		status = "disabled";
	};

In the "positive logic" case I would have a board.dts with:

	uart1: serial@foo {
		status = "okay";
	};

	&mmc1 {
		status = "okay";
        	vmmc-supply = <&ldo3_reg>;
	};
	
In the first case, the fact that there's a board specific property
present for mmc1 can almost get lost in the sea of disabled peripherals.
Extend that out to all the other devices that would be disabled in a
full board.dts and it becomes clear (at least to me) as to how ugly the
board.dts will become. My concern is that this hardware description will
quickly become unreadable to a human.

You might say it's unnecessary to disable everything, but in a
production system the developer is not going to want all these
unused devices to be instantiated. They may have a common family of
boards with a common kernel image, all with a separate dtb so they
can precisely control which items are enabled such that unused drivers
are not loaded.

So then look at the second case. At least for me, I can look at that in
the board.dts and I know that this board uses uart1 and mmc1...and
nothing else. That's a clear and concise hardware description at a
board level, but I understand that can be just considered a
preference.

> I'm curious now, why powerpc was not really using that approach?

Good question.

> I'd rather explicitly disable an IP than assuming than it is disabled by
> default and then enabling it in the board file. But again it is just a
> different view point, since at the end it will have the same effect.

Well, there's functionality then there's production usability. I'm
pointing out that there are many cases where the readability (and
therefore) usability for someone creating a new board is reduced when
devices default to enabled.

> If we really want the disabled state to be the default state, why is it
> not disabled in the DT fmwk by default?

I think it's simply answered by the fact that powerpc always took the
negative logic approach.

-Matt

> >> On 09/18/2012 07:30 AM, Philip, Avinash wrote:
> >>> Add McSPI data node to AM33XX device tree file. The McSPI module (and so
> >>> as the driver) is reused from OMAP4.
> >>>
> >>> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> >>> Tested-by: Matt Porter <mporter@ti.com>
> >>> ---
> >>> Changes since v1:
> >>>         - Corrected reg offset in reg DT entry.
> >>>
> >>> :100644 100644 ff3badb... 065fd54... M	arch/arm/boot/dts/am33xx.dtsi
> >>>  arch/arm/boot/dts/am33xx.dtsi |   25 +++++++++++++++++++++++++
> >>>  1 files changed, 25 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> >>> index ff3badb..065fd54 100644
> >>> --- a/arch/arm/boot/dts/am33xx.dtsi
> >>> +++ b/arch/arm/boot/dts/am33xx.dtsi
> >>> @@ -219,5 +219,30 @@
> >>>  			interrupt-parent = <&intc>;
> >>>  			interrupts = <91>;
> >>>  		};
> >>> +
> >>> +		spi0: spi@48030000 {
> >>> +			compatible = "ti,omap4-mcspi";
> >>> +			#address-cells = <1>;
> >>> +			#size-cells = <0>;
> >>> +			reg = <0x48030000 0x400>;
> >>> +			interrupt-parent = <&intc>;
> >>> +			interrupt = <65>;
> >>> +			ti,spi-num-cs = <2>;
> >>> +			ti,hwmods = "spi0";
> >>> +			status = "disabled";
> >>> +
> >>> +		};
> >>> +
> >>> +		spi1: spi@481a0000 {
> >>> +			compatible = "ti,omap4-mcspi";
> >>> +			#address-cells = <1>;
> >>> +			#size-cells = <0>;
> >>> +			reg = <0x481a0000 0x400>;
> >>> +			interrupt-parent = <&intc>;
> >>> +			interrupt = <125>;
> >>> +			ti,spi-num-cs = <2>;
> >>> +			ti,hwmods = "spi1";
> >>> +			status = "disabled";
> >>> +		};
> >>>  	};
> >>>  };
> >>>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
