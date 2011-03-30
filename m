Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1C3TJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:09:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40812 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1C3TJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:09:19 -0400
Date: Wed, 30 Mar 2011 20:08:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>, devel@linuxdriverproject.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] new module for amba axi on-chip interconnect
Message-ID: <20110330190857.GC2939@n2100.arm.linux.org.uk>
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <201103301509.04899.arnd@arndb.de> <20110330174010.GA2939@n2100.arm.linux.org.uk> <201103302024.49921.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103302024.49921.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 08:24:49PM +0200, Arnd Bergmann wrote:
> On Wednesday 30 March 2011 19:40:10 Russell King - ARM Linux wrote:
> 
> > The reason we don't do automatic scanning (which we could on the various
> > ARM platforms) is because of the platform data necessary to make some of
> > the primecell drivers work.
> > 
> > Unfortunately, these buses are not as simple as PCI, where a device
> > typically sits on its own card and is totally self-contained.  With
> > primecell stuff, there's normally some interdependencies between the
> > various primecells.
> > 
> > That doesn't stop there being an automatic enumeration layer, but such
> > a layer would need some way of attaching platform specific data to
> > specific amba devices.
> 
> Right, I understand that this would not completely remove the need for
> platform devices, but I think it would be a great step in the right
> direction if we could scan all simple devices automatically, or
> possibly even all devices in some simple machines.

I'm not talking about platform devices at all.  I'm talking about the data
which platforms need to supply to their drivers in order for the drivers
to work.

Eg, how the DMA is connected (or indeed whether the DMA signals are even
connected in the first place).  Where the card detect signal is for the
MMC slot for the particular controller we've found, etc.

It's not as simple as (eg) detecting a MMC controller and immediately
pointing it at the GPIO number - the "simple" ARM dev platforms normally
have two MMC controllers so that needs to be distinguished.

This kind of data is precisely why I went down the static declaration
route for all ARM dev platforms, despite most devices being trivially
discoverable.  I couldn't work out a decent way to automatically scan
the devices while ensuring that the right platform specific driver data
was attached to its correct device.

> The device tree work has shown that it's possible to describe very
> complex hardware in simple data structures, but it would be much
> better if we needed neither a device tree nor a board file for this.

The device tree goes against automatic device discovery - unless you
have a shim which runs before the kernel executes to adjust the device
tree appropriately.  Otherwise, I can't see anyway you could cope with
(eg) a platform having MMC controllers at 0x10004000 and 0x10008000,
and another with just one MMC controller at 0x10008000 but using the
card detect lines from 0x10004000.

> I remember PCI cards
> from the 1990s that could not be probed properly and required
> setting a lot of module parameters copied from a web site depending
> on what hardware you had bought. The reason we don't have that 
> as much today is that the manufacturers realized that it's impossible
> to write proper drivers if you cannot detect the hardware.

I think you're going to be waiting a very long time for that to happen.
No SoC vendor adds device IDs to their on-chip devices to allow them to
be automatically discovered - it's only through ARM Ltd's development of
their Primecells, and then vendors integrating those into their SoC (maybe
with their own modifications) that we've started to see this kind of ID
system appearing.

Outside of the Primecell stuff, I'm unaware of anyone adding any kind
of discovery mechanism to SoC based devices.

So, all in all I don't think that the automatic discovery idea is worth
the effort.  All that I can see is it causing lots of problems.
