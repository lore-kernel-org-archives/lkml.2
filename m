Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3AJMs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:48:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36735 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab3AJMs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:48:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from platform data
Date: Thu, 10 Jan 2013 13:54:41 +0100
Message-ID: <2921304.SsX3sQo2BU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130110123837.GO13897@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com> <20130110095803.GJ13897@intel.com> <20130110123837.GO13897@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 10, 2013 02:38:37 PM Mika Westerberg wrote:
> On Thu, Jan 10, 2013 at 11:58:03AM +0200, Mika Westerberg wrote:
> > On Wed, Jan 09, 2013 at 11:07:26PM +0100, Rafael J. Wysocki wrote:
> > > We hardcode different kinds of information into the kernel anyway, but it
> > > would be good to be able to use some criteria to decide whether or not we need
> > > that information on the given system.
> > > 
> > > In this particular case, we'll only need the fixed clock rate for the SPI
> > > which is not present on other x86 systems to date.
> > > 
> > > Mika, do you have any idea what checks to apply to figure out whether or not
> > > the SPI clock will be necessary?
> > 
> > I've tried to figure out them but so far I have no ideas :-/
> > 
> > If we put that behind some config option, it 1) confuses users and 2)
> > distro makers will select it anyway, so I don't see this as an option.
> > 
> > > Perhaps we can add a check into acpi_create_platform_device()?  Something like
> > > "if the device ID is present in table X, then run function Y for the device"
> > > where Y will configure the clock if the SPI is matched?
> > 
> > That would work but then we must also make sure that if the device was
> > enumerated from PCI, it gets this clock via some other means.
> > 
> > The LPSS devices can be configured to either appear on PCI or ACPI and of
> > course ACPI has the advantage because then we can enumerate the slave
> > devices behind the bus as well. However, it might be possible that we need
> > to support PCI enumeration at some point.
> > 
> > Furthermore, the SPI controller has an existing PCI glue driver
> > (spi-pxa2xx-pci.c) that needs to pass this clock as well. This is for Intel
> > CE4100 platform and we must make sure that it still works after our change.
> 
> Here's one more proposal based on the discussion so far.
> 
> 	1. Enable CONFIG_COMMON_CLK on x86.
> 
> 	2. Create Lynxpoint specific clock driver and place it under
> 	   drivers/clk/x86/clk-lpt.c. This is a platform driver for
> 	   platform device named 'clk-lpt'.
> 
> 	3. We make the acpi_create_platform_device() match on, lets say
> 	   "INT33C" (a partial match), and in such case it assumes that we are
>            running on Lynxpoint. It will then create platform device for 'clk-lpt'.
> 
> 	4. Now the clk-lpt driver creates the clocks.
> 
> 	5. The SPI driver gets the clock it wants.

That sounds reasonable to me.  Mark, what do you think?

> In case of CE4100 we make drivers/clk/x86/clk-ce4100.c that exposes
> ce4100_clk_init(). This gets called from arch/x86/platform/ce4100/ce4100.c.
> 
> I'm not sure about the LPSS PCI case. Maybe we can forget that for now
> (except the CE4100 case which obviously must work)? Or add similar quirk to
> the PCI side that creates the platform device for clocks.

I would wait for now until we have evidence that the LPSS PCI will be used in
practice at all.  Then we can add a PCI quirk along the above lines, I think.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
