Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2EUGsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:48:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39288 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2EUGsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:48:53 -0400
Date: Mon, 21 May 2012 14:49:05 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] DT clk binding support
Message-ID: <20120521064901.GE8140@S2101-09.ap.freescale.net>
References: <4FB80F32.5090309@gmail.com>
 <20120520030653.GB5810@S2100-06.ap.freescale.net>
 <4FB9A5E7.2070000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB9A5E7.2070000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 09:18:15PM -0500, Rob Herring wrote:
> > As I said, any clock in the clock tree except root clock is not only
> > a clock provider but also a consumer.  If you define "clocks" as a
> > required property for clock consumers, you are essentially asking users
> > to either define the whole clock tree in the device tree or stay away
> > from device tree completely.
> 
> So what are you proposing that a clock consumer have? The very
> definition of a clock consumer is that it has a clocks property.
> 
To support the cases that the clock tree is defined by clock driver
and device tree together, the "clocks" property could be reasonably
absent in case the parent clock (provider) is being defined in driver
than DT.  And for such clocks, the "clock-names" than "clocks" should
be required to find the clock provider/parent.

I do not like the idea to look for clock with name too much, but I
do not see other way around to support those platforms that have clock
tree definition split in clock driver and device tree. 

> > 
> > Are you sure this is the right thing to do?  If I remember correctly,
> > Grant's position is it should be pretty reasonable to have most of
> > the clock tree defined in clock driver and only define those leaf
> > clocks which are very likely to become the clock providers for other
> > peripherals.
> 
> The minimum is you have to have a provider and consumer. It may be a
> single provider that provides all clocks for a chip. If you don't want a
> provider, then just define a clock-frequency property.
> > 
> > Let me put a terrible example here.  Since clock tree is actually SoC
> > specific, I can reasonably choose to define the entire imx6q clock tree
> > and all the clk lookups for imx6q peripherals in clk-imx6q driver.
> > On imx6q-sabrelite board, the audio codec sgtl5000 uses cko (an imx6q
> > clock available on pad) as the clock source.  That said, I need a board
> > specific clk lookup here, which should be the best user of clock DT
> > bindings.  But sadly, with the current bindings, I can not give the
> > required "clocks" property for sgtl5000 node.
> 
> I don't understand your example. For the sgtl5000 on the sabrelite, you
> would provide a phandle and cell entry that is interpreted as the cko
> pin.

With the bindings here, I need something like below in device tree to
replace the clk lookup registration that is currently done in imx6q
sabrelite specific setup code.  However the problem here is I have cko
defined in clock driver, and thus I can not give phandle to cko in
device tree.  What I suggest is for such cases, we could require
clock-names = "cko" than clocks = <&cko>, and of_clk_get() should also
be able to find the clock with looking for the clk name.

imx6q-sabrelite.dts:

	codec: sgtl5000@0a {
		compatible = "fsl,sgtl5000";
		reg = <0x0a>;
		clocks = <&cko>;
	};

mach-imx6q.c, imx6q_sabrelite_cko1_setup(): 

        cko1 = clk_get_sys(NULL, "cko1");
        clk_register_clkdev(cko1, NULL, "0-000a");

Regards,
Shawn
