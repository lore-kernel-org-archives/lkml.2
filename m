Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1DFS7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:59:15 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:44967 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756571Ab1DFS7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:59:13 -0400
Date: Wed, 6 Apr 2011 21:59:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Greg KH <gregkh@suse.de>, Grant Likely <grant.likely@secretlab.ca>,
        Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110406185902.GN25654@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
 <20110401235239.GE29397@sortiz-mobl>
 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
 <20110404100314.GC2751@sortiz-mobl>
 <20110405030428.GB29522@ponder.secretlab.ca>
 <20110406152322.GA2757@sortiz-mobl>
 <20110406155805.GA20095@suse.de>
 <20110406170537.GB2757@sortiz-mobl>
 <20110406175647.GA8048@suse.de>
 <20110406184733.GD2757@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406184733.GD2757@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 06, 2011 at 08:47:34PM +0200, Samuel Ortiz wrote:
> > > > What is a "MFD cell pointer" and why is it needed in struct device?
> > > An MFD cell is an MFD instantiated device.
> > > MFD (Multi Function Device) drivers instantiate platform devices. Those
> > > devices drivers sometimes need a platform data pointer, sometimes an MFD
> > > specific pointer, and sometimes both. Also, some of those drivers have been
> > > implemented as MFD sub drivers, while others know nothing about MFD and just
> > > expect a plain platform_data pointer.
> > 
> > That sounds like a bug in those drivers, why not fix them to properly
> > pass in the correct pointer?
> Because they're drivers for generic IPs, not MFD ones. By forcing them to use
> MFD specific structure and APIs, we make it more difficult for platform code
> to instantiate them.

I agree. What I do on those cases is to have a simple platform_device
for the core IP driver and use platform_device_id tables to do runtime
checks of the small differences. If one platform X doesn't use a
platform_bus, it uses e.g. PCI, then you make a PCI "bridge" which
allocates a platform_device with the correct name and adds that to the
driver model.

See [1] (for the core driver) and [2] (for a PCI bridge driver) for an
example of what I'm talking about.

> The timberdale MFD for example is built with a Xilinx SPI controller, and a
> Micrel ks8842 ethernet switch IP. Forcing those devices into being MFD devices
> would mean any platform willing to instantiate them would have to use the MFD
> APIs. That sounds a bit artificial to me.

do they share any address space ? If they do, then you'd need something
to synchronize, right ? If they don't, then you just add two separate
devices, they don't have to be MFD.

> Although there is currently no drivers instantiated by both an MFD driver
> and some platform code, Grant complaint about the Xilinx SPI driver moving
> from a platform driver to an MFD one makes sense to me. 

I don't think so. That's not really an MFD device is it ? It's just two
different IPs instantianted on the same ASIC/FPGA, right ? Unless they
share the register space, IMHO, there's no need to make them MFD.

[1] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/core.c
[2] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/dwc3-haps.c

-- 
balbi
