Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946024Ab2JaV0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:26:44 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:11022 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933899Ab2JaV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:26:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/en3Z4wkAL82fSuo65YVTE
Date: Wed, 31 Oct 2012 14:26:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121031212639.GQ12739@atomide.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com>
 <20121031175219.GH12739@atomide.com>
 <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com>
 <20121031180935.GL12739@atomide.com>
 <50918223.6080003@ti.com>
 <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [121031 13:14]:
> On Oct 31, 2012, at 9:55 PM, Benoit Cousson wrote:
> > 
> > Yeah, I do agree. I'm confused as well. Only OMAP IPs under PRCM control
> > could have an hwmod and thus must be handled by an omap_device.
> > 
> > Any devices that is created later cannot be omap_device. The DT core
> > will create regular platform_device for them.
> > 
> > Since cape is an external board, it should have nothing to do with
> > omap_device.
> > 
> > Looking at your patch:
> > da8xx-dt: Create da8xx DT adapter device
> > 
> > I understand why you do that, but in fact that patch does not make sense
> > to me :-(
> > 
> > Why do you have to create an omap_device from the driver probe?
> > 
> 
> The problem is that capes are not external boards in the normal sense
> as a PCI board is. In the PCI case the hardware that implements the 
> desired functionality is on the PCI board, while in the cape case the
> hardware module is in the SoC. The cape most of the times is quite
> simple and contains passive components, leds or some kind of I2C/SPI devices.

Ah now I see, you're talking about the beaglebone extension
boards :)

The way to deal with those properly is to just edit the
board .dts entry to include omap-beaglebone-cape-xyz.dtsi
whatever.

> You can't instantiate the omap_device early in the boot process like it was done up to 
> now in the board file. You can only do that later in the boot process (for built-in 
> cape drivers), or even after user-space has booted and the matching cape driver module
> has been loaded.

Yes you can, just edit the .dts file for the extension
board you have connected. This stuff should be DT
only for sure, let's not even start adding platform_data
entries for that.

The omap_device entries for the omap internal devices
will be created automatically during startup based on the
.dts. Note that you can set status = "disabled" for the
omap internal devices in the .dts file, the devices are
there in the hardware.

If you are sure the extension boards are safely hot
pluggable, then all you need is some interface to enable
and disable devices after booting. But that should be
done in Linux generic way.

So we should not export any omap_hwmod or omap_device
things, and want to keep it __init only, and local to
arch/arm/mach-omap2.

Regards,

Tony
