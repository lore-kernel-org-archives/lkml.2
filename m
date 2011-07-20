Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1GTS20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:28:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38018 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1GTS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:28:24 -0400
Date: Wed, 20 Jul 2011 12:28:23 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm/dt: tegra devicetree support
Message-ID: <20110720182823.GD4642@ponder.secretlab.ca>
References: <20110719234158.2779.15394.stgit@ponder>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 08:37:19AM -0700, Stephen Warren wrote:
> Grant Likely wrote at Tuesday, July 19, 2011 5:43 PM:
> > Everything required to populate NVIDIA Tegra devices from the device
> > tree.  This patch adds a new DT_MACHINE_DESC() which matches against
> > a tegra20 device tree.  So far it only registers the on-chip devices,
> > but it will be refined in follow on patches to configure clocks and
> > pin IO from the device tree also.
> > 
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Oops, I merged patches, but missed some attribution.  This patch is
is also composed of work from John Bonesio and Stephen Warren.

> > ---
> > 
> > Hi all,
> > 
> > Similar to the versatile patch I just posted, this is certainly not
> > complete board support, but it is enough to be useful.  I'd like to
> > merge this for v3.1.  It should not break any existing board support.
> 
> > diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
> 
> tegra-*.dts don't include status="disable" for all the unused controllers.
> Should that be added?

I dropped that pattern since my preference has been to have boards
explicitly disable unused cores and that has generally been the
pattern on other DT platforms.

> 
> > +	sound {
> > +		compatible = "nvidia,harmony-sound", "nvidia,tegra-wm8903";
> 
> I thought the sound bindings were still somewhat experimental and not
> completely agreed upon. One issue I see is that Device Tree is
> supposed to represent pure HW, rather than driver-required abstractions,
> and at least the compatible name here is pretty Linux-driver-specific.
> 
> I think there are some devices missing from the DT file for audio too,
> e.g. the ALSA "PCM" (DMA) driver.
> 
> Also, the bindings for this aren't documented IIRC.
> 
> I'd suggest dropping the audio part of the DT file until the audio side
> is more mature.

Yes, I'll drop the audio bits from this patch. I had taken John's dts
file which includes the work he's performed on the audio.  Actually, I
haven't looked critically at this .dts, so there is probably a lot of
cruft that should be tightened up.

> > +		spkr-en-gpios = <&codec 2 0>;
> 
> Should that be "gpio" not "gpios", since there is only one?

Originally I though about that, but for consistency I think it is
better to have all gpio properties use a "gpios" suffix instead of a
mixture of "-gpio" and "-gpios".

> > +		hp-det-gpios = <&gpio 178 0>;
> > +		int-mic-en-gpios = <&gpio 184 0>;
> > +		ext-mic-en-gpios = <&gpio 185 0>;
> > +	};
> 
> > diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> ...
> > +/ {
> ...
> > +	amba {
> > +		compatible = "simple-bus";
> ...
> > +		intc: interrupt-controller@50041000 {
> ...
> > +		};
> > +	};
> ...
> > +	i2c@7000c000 {
> 
> I've always wondered why all the devices aren't included inside the amba
> node. Or put another way, if the devices are outside the amba node, why
> not move everything outside the amba node and remove the amba node?

It is sometimes convenient to have all the SoC devices contained in a
collection node, such as if there is shared clock or power management
contect, but it is certainly not required.  It is probabaly best if the
hierarchy reflects the actual bus layout of the SoC instead of an
anonymous "soc" or "amba" node.

> > diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> > index 823c703..6d3d695 100644
> > --- a/arch/arm/mach-tegra/Makefile
> > +++ b/arch/arm/mach-tegra/Makefile
> > @@ -30,5 +30,8 @@ obj-${CONFIG_MACH_PAZ00}		+= board-paz00-pinmux.o
> >  obj-${CONFIG_MACH_SEABOARD}             += board-seaboard.o
> >  obj-${CONFIG_MACH_SEABOARD}             += board-seaboard-pinmux.o
> > 
> > +obj-${CONFIG_MACH_TEGRA_DT}             += board-dt.o
> > +obj-${CONFIG_MACH_TEGRA_DT}             += board-harmony-pinmux.o
> 
> You need board-seaboard-pinmux.o here too.

Yes.  Actually, what I really need is a better way to handle pinmux,
and it isn't very sane to have board-*-pinmux.o added multiple times
to obj-y.  I'll tidy this up.

> 
> > diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
> ...
> > +static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
> > +	/* name		parent		rate		enabled */
> > +	{ "uartd",	"pll_p",	216000000,	true },
> > +	{ NULL,		NULL,		0,		0},
> > +};
> 
> For audio to work, you'll need more clock entries here currently; another
> reason I suggested to simply drop the audio stuff for now to keep things
> simple.

I've split the audio changes into a separate patch since that work
isn't complete yet.

> 
> > +static void __init tegra_dt_init(void)
> ...
> > +	if (of_machine_is_compatible("nvidia,harmony"))
> > +		harmony_pinmux_init();
> > +	else if (of_machine_is_compatible("nvidia,seaboard"))
> > +		seaboard_pinmux_init();
> 
> else error, or at least warn?

Yeah, at least until I can remove this ugly hunk entirely.

g.
