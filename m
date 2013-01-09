Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab3AIWBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:01:45 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36165 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627Ab3AIWBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:01:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from platform data
Date: Wed, 09 Jan 2013 23:07:26 +0100
Message-ID: <4412354.TD27KzhhVJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130109122550.GA20956@opensource.wolfsonmicro.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com> <50EC90C3.2090604@intel.com> <20130109122550.GA20956@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 09, 2013 12:25:50 PM Mark Brown wrote:
> On Tue, Jan 08, 2013 at 10:33:55PM +0100, Rafael J. Wysocki wrote:
> > On 1/8/2013 2:10 PM, Mark Brown wrote:
> > >On Tue, Jan 08, 2013 at 02:41:53PM +0200, Mika Westerberg wrote:
> 
> > >>Do you mean enabling CONFIG_COMMON_CLK on x86?
> 
> > >Yes.
> 
> > Why so?  x86 doesn't have a notion of direct clock control, at least
> > not on the ACPI systems.
> 
> So, a couple of things here.  One is that your SFI systems *do* have
> user controllable clocks so they really should be using the clock API.

Well, fair enough.

> The other is that even if the CPU doesn't want to use clocks off-CPU
> devices may wish to - for example, a PCI card using off the shelf
> components or in this case a device on the SPI bus on the laptop which
> requires a clock and wants to manage it at runtime if possible.  We
> should be able to arrange things so that drivers can work with clocks
> using the standard clock API.  I'm really hopinng that having the clock
> API will eventually enable us to work with clocks in off-SoC devices but
> right now the only option is open coding.
> 
> > >I'm sure it's not beyond the bounds of possibility that we could solve
> > >this problem...
> 
> > No, it isn't.  Any suggestions?
> 
> Well, the most obvious solution would be to just hard code this
> information in the kernel and set it up based on what you do know.  For
> example if this is a SoC-internal clock then set it up based on knowing
> the SoC (this seems to be basically what Mika is suggesting).

Yes, it seems that we just happen to know the right value.  Sigh.

> > >It is something that needs to be resolved for your smartphone SoCs for
> 
> > We're not talking about smartphones and even not about SoCs here, sorry.
> 
> > This is a laptop CPU that happens to have an SPI controller integrated.
> 
> These are still x86 systems so are part of why it seems like a good idea
> to make the clock API available on x86.
> 
> > >this and for other things like platform data for external chips, what's
> > >actually happening in practical systems here is that people are just
> > >hacking the arch code as there's no mechanism for providing
> > >configuration at present.
> 
> > I'm not sure what you're referring to, but here we have ACPI as a
> > configuration mechanism.
> 
> > Which doesn't allow us to control clocks directly.
> 
> Right, and because the BIOS guys don't provide any mechanism for
> handling this stuff using the BIOS information what people actually
> deploying systems are doing is just hacking the arch code which gets us
> the worst of both worlds - we have to put things into the BIOS but we
> then have to put extra information into the kernel to actually make
> things functional.

We hardcode different kinds of information into the kernel anyway, but it
would be good to be able to use some criteria to decide whether or not we need
that information on the given system.

In this particular case, we'll only need the fixed clock rate for the SPI
which is not present on other x86 systems to date.

Mika, do you have any idea what checks to apply to figure out whether or not
the SPI clock will be necessary?

Perhaps we can add a check into acpi_create_platform_device()?  Something like
"if the device ID is present in table X, then run function Y for the device"
where Y will configure the clock if the SPI is matched?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
