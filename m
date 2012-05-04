Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab2EDStE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:49:04 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:44229 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321Ab2EDSs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:48:56 -0400
Date: Fri, 4 May 2012 11:48:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Francois Rigaut <frigaut@gmail.com>, linux-pci@vger.kernel.org
Cc: Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120504184851.GB11223@kroah.com>
References: <20120419163800.GB13977@schottelius.org>
 <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com>
 <20120502163629.GE928@schottelius.org>
 <20120502202509.GA26798@kroah.com>
 <20120503065003.GB13386@schottelius.org>
 <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com>
 <20120503153547.GD20334@kroah.com>
 <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com>
 <20120503233858.GA13453@kroah.com>
 <4FA358ED.1080705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA358ED.1080705@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 02:19:57PM +1000, Francois Rigaut wrote:
> Greg, Nico,
> 
> Thanks Greg for giving us some attention. I went ahead and collected
> a number of information that could be useful to track down our
> hotplug issue.
> 
> 1) Coldplug: Booting with the thunderbolt display attached. This
> works. Several devices (additional to what I get without the display
> attached) are listed. Here is the relevant info:
> 
> http://maumae.net/thunderbolt/coldplug_efi/log  -> kernel.log
> http://maumae.net/thunderbolt/coldplug_efi/lspci -> lspci and lspci -vv
> http://maumae.net/thunderbolt/coldplug_efi/lsmod
> http://maumae.net/thunderbolt/coldplug_efi/config_excerpt.txt
> full config @ http://maumae.net/thunderbolt/config.gz
> http://maumae.net/thunderbolt/coldplug_efi/disconnect -> message
> when disconnecting (pciehp loaded just before)
> 
> note that an attempt to reconnect leads to the same issue as
> described before, i.e. nothing happens.
> 
> 2) Booting with the display/device not plugged, just for reference:
> 
> http://maumae.net/thunderbolt/notplugged_efi/log
> http://maumae.net/thunderbolt/notplugged_efi/lsmod
> http://maumae.net/thunderbolt/notplugged_efi/misc
> http://maumae.net/thunderbolt/notplugged_efi/lspci

Ok, it looks like these are the devices that we are missing while
"hotplugging":
37:00.0 PCI bridge: Intel Corporation Device 1513
38:00.0 PCI bridge: Intel Corporation Device 1513
38:01.0 PCI bridge: Intel Corporation Device 1513
38:02.0 PCI bridge: Intel Corporation Device 1513
38:03.0 PCI bridge: Intel Corporation Device 1513
38:04.0 PCI bridge: Intel Corporation Device 1513
38:05.0 PCI bridge: Intel Corporation Device 1513
39:00.0 PCI bridge: Pericom Semiconductor Device 400c (rev 02)
3a:03.0 PCI bridge: Pericom Semiconductor Device 400c (rev 02)
3b:00.0 USB controller: Pericom Semiconductor Device 400e (rev 01)
3b:00.1 USB controller: Pericom Semiconductor Device 400e (rev 01)
3b:00.2 USB controller: Pericom Semiconductor Device 400f (rev 01)
3c:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57761 Gigabit Ethernet PCIe (rev 10)
3d:00.0 FireWire (IEEE 1394): nee Agere Systems nee Lucent
Microelectronics FW643 PCI Express 1394b Controller (PHY/Link) (rev 08)

Which is good, I was worried that there was a video controller out there
on the end of the thunderbolt link.

So, the problem really is two here:
  - your video card doesn't detect the new display
  - your pci devices do not show up

The first one probably needs to be reported to the Intel video driver
people, they can help you out the best.

The second one means that something is up with the pci hotplug
controller.  I've cced the linux-pci list, the people there should be
able to help out better than I, as I no longer have any PCI hotplug
hardware to work with anymore.

> 3) Again, I have tried to load pciehp and acpiphp with both EFI boot
> and BIOS emulation boot:
> - pciehp loads ok but as I said earlier, no message whatsoever in
> everything.log when I try to connect the thunderbolt display

If you load it with debugging enabled, do you get extra messages in the
log?

> - acpiphp: I was wrong yesterday. In fact, trying to load acpiphp
> gives me a message:
> [root@poliahu thunderbolt]# modprobe acpiphp
> ERROR: could not insert 'acpiphp': No such device

Again, can you load it with debugging (I think both load with "debug=1"
as a module option to do this).

> Not sure what to make of it. I have tried to also load acpiphp after
> a coldplug boot; same error message.
> 
> I've read somewhere that this error message may mean that the h/w
> doesn't support hotplugging. However, I think the coldplug lspci -vv
> above tells us the h/w does support pcie hotplug: all the pci
> bridges appear to have D3hot+ capability (and it certainly does, as
> this works under osx on the same machine).

Yes, it "should" work, but figuring out what the pci hotplug method that
is going on is going to be the main thing to solve here.

Oh, what exact machine is this?  Maybe I can ask around and see if I can
dig up one myself, and hey, I always need an excuse to get a new display
:)

thanks,

greg k-h
