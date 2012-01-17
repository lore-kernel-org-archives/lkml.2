Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2AQOCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:02:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53132 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab2AQOCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:02:10 -0500
Date: Tue, 17 Jan 2012 22:13:24 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: Pinmux bindings proposal
Message-ID: <20120117141322.GA31687@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 09:46:42AM +0000, Dong Aisheng-B29396 wrote:
...
> I guess Stephen's idea is to retrieving the function name and group name
> From the pinctrl driver since Tagre prefers to define those things in driver
> Rather than in board file or soc.dts file.
> But it does not fit for IMX since we define it in soc.dts.
> 
Hmm, when he came up with this proposal and said it should work for
Tegra, I assume he plans to move those from Tegra pinctrl driver into
device tree.  Stephen?

...

> > Considering the different pinctrl configurations for the same client device
> > usually share the same pinmux and only pinconf varies. 
> I have the same doubts before.
> Is there a real case that device has the different pinmux in different state?
> Stephen?
> 
> > It may worth introducing
> > another level phandle reference.  Something like the following:
> > 
> > 	pinmux_sdhci: pinmux-sdhci {
> > 		mux =
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> > 	};
> > 
> > 	pinconf_sdhci_active: pinconf-sdhci-active {
> > 		config =
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > 	};
> > 
> > 	pinconf_sdhci_suspend: pinconf-sdhci-suspend {
> > 		config =
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > 	};
> > 
> The config makes sense to me.
> The only question is how to get group name to match with the predefined groups.
> 
I still incline to say there should not be any predefined groups for
DT case, if we choose to find the group in use only when pinmux_get()
gets called.  Even if you insist to have a global scanning on device
tree for all groups to create the pinmux mapping table, those predefined
groups can only be created by your scanning code, so you should know
how the name comes from device tree, and you should be able to recreate
the name when you are trying to matching the name in the table you
created before.

> Besides per pin group configuration support, we may also want per pin configuration
> Support as the latest patch sent by Linus.
> http://www.spinics.net/lists/arm-kernel/msg155712.html
> 
This binding proposal has covered both pin and group configuration,
as the second parameter of 'config' property could be either a pin
or group which depends the on whether the configurable entity at HW
level is a pin or group.

...

> > > If "muxable entities" is pins on IMX, I'm wondering how we define the
> > > predefined Functions and groups or if we still need to do that.
> > >
> > Let's put this in the example below.
> > 
> > 	pinmux_usdhc1: pinmux-usdhc1 {
> > 		mux = <IMX6Q_PAD_SD1_DAT1 0>
> > 		      <IMX6Q_PAD_SD1_DAT2 0>
> > 		      ...
> > 	};
> > 
> Yes, I agree.
> And in this way we're still using virtual groups.
> It has no big difference as we did before like:
> pinmux-groups {
>         uart4grp: group@0 {
>                 grp-name = "uart4grp";
>                 grp-pins = <107 108>;
>                 grp-mux = <4 4>;
>         };
> 
>         sd4grp: group@1 {
>                 grp-name = "sd4grp";
>                 grp-pins = <170 171 180 181 182 183 184 185 186 187>;
>                 grp-mux = <0 0 1 1 1 1 1 1 1 1>;
>         };
> };
> 
You are right.  They are fundamentally same and just in different
format.

> The real problem is do we need to support individual pin mux
> Or still using virtual pin group?
> For the way Stephen proposed, we can only support individual pin mux
> Since IMX pins are not grouped together in HW.
> 
I do not see any problem here.  If you look at the first column of
'mux' property of node pinmux-usdhc1, it is a group of pins for usdhc1.
Isn't it one virtual pin group for usdhc1?

> > 	pinconf_usdhc1_50mhz: pinconf-usdhc1-50mhz {
> > 		config = <IMX6Q_PAD_SD1_DAT1 IMX6Q_PAD_CONF_ALL 0x834>
> > 			 <IMX6Q_PAD_SD1_DAT2 IMX6Q_PAD_CONF_ALL 0x834>
> > 			 ...
> > 	};
> > 
> > 	pinconf_usdhc1_100mhz: pinconf-usdhc1-100mhz {
> > 		config = <IMX6Q_PAD_SD1_DAT1 IMX6Q_PAD_CONF_ALL 0x330>
> > 			 <IMX6Q_PAD_SD1_DAT2 IMX6Q_PAD_CONF_ALL 0x330>
> > 			 ...
> > 	};
> > 
> > 	pinconf_usdhc1_200mhz: pinconf-usdhc1-200mhz {
> > 		config = <IMX6Q_PAD_SD1_DAT1 IMX6Q_PAD_CONF_ALL 0x334>
> > 			 <IMX6Q_PAD_SD1_DAT2 IMX6Q_PAD_CONF_ALL 0x334>
> > 			 ...
> > 	};
> > 
> > 	pinctrl_usdhc1_50mhz: pinctrl-usdhc1-50mhz {
> > 		pinmux = <&pinmux_usdhc1>;
> > 		pinconf = <&pinconf_usdhc1_50mhz>;
> > 	};
> > 
> > 	pinctrl_usdhc1_100mhz: pinctrl-usdhc1-100mhz {
> > 		pinmux = <&pinmux_usdhc1>;
> > 		pinconf = <&pinconf_usdhc1_100mhz>;
> > 	};
> > 
> > 	pinctrl_usdhc1_200mhz: pinctrl-usdhc1-200mhz {
> > 		pinmux = <&pinmux_usdhc1>;
> > 		pinconf = <&pinconf_usdhc1_200mhz>;
> > 	};
> > 
> > 	usdhc@02190000 { /* uSDHC1 */
> > 		...
> > 		pinctrl = <&usdhc1_50mhz>, <&usdhc1_100mhz>, <&usdhc1_200mhz>;
> > 		pinctrl-names = "usdhc1-50mhz", "usdhc1-100mhz", "usdhc1-200mhz";
> > 	};
> > 
> > In this example, we have 3 functions/states for client device usdhc1, "usdhc1-
> > 50mhz", "usdhc1-100mhz", and "usdhc1-200mhz".  The group is being defined by
> > enumerating the pins in property 'mux' of node pinmux_usdhc1.
> > 
> Yes, It's still under development by Linus.
> The last patch Linus sent still does not support state change for specific device.
> But the method is ok to me.
> 
Yes, we need per device state switch.

-- 
Regards,
Shawn
