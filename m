Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2ATU3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:29:21 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17230 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2ATU3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:29:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Jan 2012 12:28:56 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
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
Date: Fri, 20 Jan 2012 12:28:55 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczSMvpNTKYWSKFeSLCZTyHqrIN5SAB+76JwAD04RoAACvoLgAAAhMwAABzEW6AAexDrYA==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB445@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D22F5@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885095125@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <7FE21149F4667147B645348EC6057885095125@039-SN2MPN1-013.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Aisheng wrote at Wednesday, January 18, 2012 4:06 AM:
> Stephen Warren wrote at Wednesday, January 18, 2012 3:29 AM:
> > Dong Aisheng wrote at Tuesday, January 17, 2012 2:47 AM:
> > > Shawn Guo wrote at Tuesday, January 17, 2012 4:24 PM:
> > > > On Mon, Jan 16, 2012 at 12:50:02PM +0000, Dong Aisheng-B29396 wrote:
> > > > > Stephen Warren wrote:
...
> Now i'm still thinking if the mux way we discussed here fits IMX.
> For example:
>
> > 	pinmux_sdhci: pinmux-sdhci {
> > 		mux =
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> > 	};
>
> It may work well for Tegra.
> When pinctrl core parsing the mux proterty, it will creat each maps
> For each entry in the list.
> But for IMX like:
>
> > > 	pinmux_usdhc1: pinmux-usdhc1 {
> > > 		mux = <IMX6Q_PAD_SD1_DAT1 0>
> > > 		      <IMX6Q_PAD_SD1_DAT2 0>
> > > 		      ...
> > > 	};
>
> Each entry in the list is PIN rather than group.
> So we cannot create each map for each entry in the list except we treat the PIN as
> A group(this will cause a huge maps and predefined groups and functions).

Linusw has NAKd the idea that we should not use these "virtual groups",
i.e. he believes they're fine to use if you wish.

Given that, I think what you should do is:

* Your pinctrl driver should enumerate whatever kind of groups it wishes.

* Use the same sets of groups for both board-based and DT-based systems
  (well, that's true irrespective of anything else)

* The mux properties above would not refer to pins, but whatever muxable
  entities your pinctrl driver exposes.

  For Tegra20, I'll use the raw HW pin groups.

  For Tegra30, I'll use raw HW pins here, since each pin is individually
  muxable. In the pinctrl driver, pin IDs and these mux group IDs will
  be equivalent, since there will be 1 group per pin.

  For IMX, you can use "virtual group" IDs in the DT properties.

> A little different way I'm thinking now is cover the mux difference(pin or group)
> between Tegra and IMX in Pinctrl driver, then we may not need the second mux value
> (e.g: TEGRA_PMX_MUX_1)in the standard mux property:
> The mux property can become:
>
> pinmux_sdhci: pinmux-sdhci {
> 	mux =
> 		<&tegra_pmx TEGRA_PMX_PG_DTA_X>
> 		<&tegra_pmx TEGRA_PMX_PG_DTD_Y>;
> };

I definitely don't like putting the group ID and mux function into a
single value; this seems redundant.

However, since I'm leaning towards it being up to the individual pinctrl
driver to convert the DT property values into the group/function values
that the pinctrl core uses, you are free to define your binding however
you wish.

-- 
nvpublic

