Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1LIRYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:24:20 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25757 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752974Ab1LIRYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:24:16 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/xG4UJQ9cjZypt12ZGzyVK
Date: Fri, 9 Dec 2011 09:24:08 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32
 SoCs
Message-ID: <20111209172407.GP31337@atomide.com>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
 <20111209010147.GH7913@S2100-06.ap.freescale.net>
 <4EE18403.30604@nvidia.com>
 <20111209043220.GJ7913@S2100-06.ap.freescale.net>
 <4EE192DC.3080209@nvidia.com>
 <CAA+hA=Sx=tmnjsY_7EF8NciZO4PvgYOCgRNK9WsGpKmJ8X-r3g@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17518604C3@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17518604C3@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [111209 08:17]:
> Dong Aisheng wrote at Friday, December 09, 2011 8:03 AM:
> ...
> > I agree that parsing data from device tree increases much effort
> > because we can not using any help functions like microes in dts file and we have
> > to construct the structure we need in driver by parsing that data.
> > And it will increase dtsi file's size a lot when after adding all functions.
> > 
> > I wonder if we can define that data as a pdata in a .c file and only
> > get a pointer from dts file. That would make life much easier.
> 
> You can't get pointers themselves directly from a .dts file, since the
> .dts file author has no idea what the memory layout (or even which OS)
> is present on the running system.
> 
> An alternative is to key off the compatible flag in the device tree,
> and use that to index a table that points at the various structures you
> want pointers to.
> 
> struct of_device_id's .data field, and the function of_match_device()
> are for exactly that purpose; see the way the Tegra pinctrl driver that
> I posted uses them for an example of mapping compatible flag to per-
> SoC initialization function pointers.

For letting a device do it's pingroup in DT, I've played with the
following:

	/*      mux func phandle mux func name    hw initial flags */
	pins = <&uart3_rx_irrx>, "uart3_rx_irrx", <0xdeadbeef>,
		<&uart3_tx_irtx>, "uart3_tx_irtx", <0xdeadbeef>;

But it seems that doing mixed-property arrays gets nasty as any
data after a string has a high likelihood of getting misaligned
since a mixed-property array is a string array with the string
embedded in it with the registers. That leads into nasty string
parsing that can be extremely flakey with buggy DT data. So it
seems that using a string there is only safe as the last element,
which means we can't use names for multiple pins.

So I've pretty much come to the conclusion that we would have to
use something like this instead:

	/*      phandle        f hw specific initial flags */
	pins = <&uart3_rx_irrx 0 0xdeadbeef
		&uart3_tx_irtx 0 0xdeadbeef>;

This however has a problem for cases where we may not have a phandle
in DT for the mux function. For example, let's assume that we'll have
tens of thousands of lines of mux data for omaps (we already have
over 6k LOC) and just want to load that from /lib/firmware to avoid
bloating the kernel. In that case we won't have the phandle for the
mux function in DT.

It would be _really_nice_ to use DT in the missing phandle case also
for doing the device to mux function mapping based on a function name
when no phandle is available.

But so far I have not found a good way of doing both phandle and
optional name type thing. Anybody got some good ideas for that?

BTW, this same problem applies also to clock framwork where we may
have multiple sources of clocks to register and map to devices.

Regards,

Tony
