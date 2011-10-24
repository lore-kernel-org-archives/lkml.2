Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1JXHlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:41:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49111 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1JXHl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:41:29 -0400
Date: Mon, 24 Oct 2011 09:41:24 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: DeviceTree and children devices
Message-ID: <20111024074124.GB8708@ponder.secretlab.ca>
References: <20111024064227.GW5453@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024064227.GW5453@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 09:42:28AM +0300, Felipe Balbi wrote:
> Hi Grant,
> 
> I have a question about how DeviceTree should be written in case a
> device has a child device.
> 
> The way things are integrated on OMAP is that we will always have a
> parent device which is a wrapper around an IP core in order to
> integrate with the OMAP context (clocks, power management, etc).
> 
> That wrapper has its own address space and its own IRQ number
> (generally). On my dwc3 driver I have modeled the OMAP wrapper as a
> parent device which allocates a child device for the core IP driver.
> This makes it a lot easier to re-use the core IP driver on other SoCs or
> PCI (there's a glue layer for PCI too).
> 
> So I wonder if we should describe that on DeviceTree and not have the
> OMAP glue layer allocate the core IP driver. Just to illustrate, here's
> what we have:
> 
> static int dwc3_omap_probe(struct platform_device *pdev)
> {
> 	struct platform_device	*dwc3;
> 	struct resource		res[2];
> 
> 	dwc3 = platform_device_alloc("dwc3", -1);
> 	/* check*/
> 
> 	dwc3->dev.parent = &pdev->dev;
> 
> 	/* copy DMA fields from parent too */
> 
> 	res[0].start = start_address;
> 	res[0].end = end_address;
> 	res[0].flags = IORESOURCE_MEM;
> 
> 	res[1].start = irq_number;
> 	res[1].flags = IORESOURCE_IRQ;
> 
> 	ret = platform_add_resources(dwc3, res, ARRAY_SIZE(res));
> 	/* check */
> 
> 	return platform_add_device(dwc3);
> }
> 
> and I wonder if I should have a DeviceTree like so:
> 
> usb@xxxxx {
> 	compatible = "ti,dwc3-omap";		// This is TI OMAP
> 						// wrapper
> 	range = <....>;
> 
> 	...
> 
> 	usb@yyyy {
> 		compatible = "synopsys,dwc3",	// This is core IP
> 						// inside wrapper
> 
> 		...
> 	};
> };
> 
> then I can drop the dwc3 platform_device allocation and all of that
> resource copying, etc.
> 
> What do you think ?

Looks reasonable to me.  of_platform_populate() should be able to
handle the device generation for you here.

g.

