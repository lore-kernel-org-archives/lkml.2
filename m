Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2BCRVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:21:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41511 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2BCRVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:21:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120203140238.GC12915@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
	<20120201143530.GA2203@S2101-09.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF178E124AC5@HQMAIL01.nvidia.com>
	<CAA+hA=RpkP-FFAr8wqVPjSKEMvO_sRHmOK_9nUYfuW=ps0O_=Q@mail.gmail.com>
	<20120203140238.GC12915@S2101-09.ap.freescale.net>
Date: Sat, 4 Feb 2012 01:21:39 +0800
Message-ID: <CAA+hA=TYt7iFbLkSLfOMe8z1-dJGufqFDuZGarRx-ioHkf3sRw@mail.gmail.com>
Subject: Re: Pinmux bindings proposal V2
From: Dong Aisheng <dongas86@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 10:02 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Fri, Feb 03, 2012 at 04:07:23AM +0800, Dong Aisheng wrote:
> ...
>> However If IMX uses the data model i described above, the binding is
>> then a little different from tegra. that means we may need to change
>> to  let each soc's pinctrl driver do real pinmux map parsing (maybe
>> add a callback in pinctrl.ops) based on their soc specific pinctrl
>> configuration node like pmx_usdhc4 above instread of let pinctrl core
>> do a standard pinmux map parsing which is our target we discussed so
>> long for.
>>
> Yeah, this seems a reasonable alternative to me.  Pushing the pinmux_map
> construction down to individual pinctrl driver, who can interpret 'mux'
> property best, will relieve the pinctrl core from understanding the
> property for different cases, so that we can even save the property
> 'mux-unit' I asked for.  And doing so somehow aligns with non-dt case,
> where the pinmux_map is constructed by individual pinctrl driver too
> (with help from PINMUX_MAP_* macros in board file).
>
Yes, that's i think may be right way we should go now.
The reasons are as we met so many issues and discussed so long, we
feel like that it's hard to make a standard dt binding in pintrl core
based on one mux property format to cover all the differences for
different SOCs likeTegra(using HW group) and IMX(using virtual group).
We need to fix these issues on a higher level that each SOC pinctrl
driver implements their pinmux map parsing function, pinctrl core
calls these functions to get the pinmux maps the driver parsed instead
of pinctrl core parsing itself.
It could be something like:
in pinmux_get() {
    struct pinmux_map *maps;
    u32 num;
    ...
    maps = pinctrl.ops.get_pinmux_map(pinmux_node, &num);
    ret = pinmux_map_register(maps, num);
    ...
    ret = pinmux_enable_maps(maps, num);
}

The basic binding idea for this way is:
1) pinctrl core is only responsible for the pinmux map parsing.
Each pinctrl driver is responsible for the function and group creation
no matter whether they're defined in drivers or parsed from device
tree.
2) The pinctrl driver is responsible for their pinmux node definitions
to cover their hw difference. However we prefer to reference the
format as Stephen proposed to align each SOC best. And each pinctrl
driver is responsible for the real pinmux map parsing by implementing
the pinmux_map_parse callback function.
3) when calling pinmux_get, we dynamically parse and create the pinmux
map table for each device.
4) the hog_on_boot map nodes are defined under SoC's pinctrl device node.
The pinctrl driver is responsible for parsing and register them.

Generally speaking, this way is very flexible and can cover most
differences between each SoCs.
It should work for both IMX and Tegra well. Tegra can still do on the
same binding as before as Stephen proposed. The only difference is
that the real pinmux map parsing is moved from pinctrl core to Tegra
pinctrl driver. And IMX can still use virtual group as we wished(i
think this is correct since pinctrl subsystem does not have a
restriction that user can only use pure hw group).
For other SOCs, i guess it should also work.

Regards
Dong Aisheng
