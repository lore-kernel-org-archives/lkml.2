Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1FLUoX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 16:44:23 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59843 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab1FLUoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 16:44:20 -0400
Date: Sun, 12 Jun 2011 13:44:07 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Ball <cjb@laptop.org>, "S, Venkatraman" <svenkatr@ti.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sdhci-pci fails on 3.0.0-rc1 on Dell E6510
Message-ID: <20110612204406.GC30738@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <4DEBCA3F.8050205@hartkopp.net>
 <BANLkTin_WHuy5MExNBHdeLiDmdmn7SZYkg@mail.gmail.com>
 <4DED05C4.7050903@hartkopp.net>
 <m3hb82wx6m.fsf@pullcord.laptop.org>
 <4DEE6FC6.9040308@hartkopp.net>
 <4DEE84AD.6050104@hartkopp.net>
 <4DEEA3CD.30507@kernel.org>
 <4DEF1606.5030803@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEF1606.5030803@hartkopp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 08:26:14AM +0200, Oliver Hartkopp wrote:
> On 08.06.2011 00:18, Yinghai Lu wrote:
> > thanks.
> > 
> > second report.
> > 
> > can you send out whole boot log.
> 
> See attached dmesg output. The 'dirty' is due to the revert test of the sd/mmc
> stuff (see below) - the rest is plain 3.0.0-rc2.
> 
> Good luck :-)

Looks like the kernel; by default, tries to allocate mem resource of size
0x4000000 each to the BARs of the cardbus bridge. This cannot be satisfied
meeting all the constraints. The BIOS had not allocated the resource to
begin with.

Anyone knows if the default value can be reduced to something smaller?
Or Should the resource requirements of cardbus bridge be made nice-to-have?

> 
> Oliver
> 
> > 
> > On 06/07/2011 01:06 PM, Oliver Hartkopp wrote:
> >> On 07.06.2011 20:36, Oliver Hartkopp wrote:
> >> Hi all,
> >>
> >> the commit "PCI: update bridge resources to get more big ranges when allocating space (again)"
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da7822e5ad71ec9b745b412639f1e5e0ba795a20
> >>
> >> kills my SD-Card and the PCMCIA slot on a Dell E6510 with the latest 3.0.0-rc2 ...
> >>

....
RP
> >> When i revert the commit both the MMC/SD stuff and the PCMCIA re-appears.
> >>
> >> Any idea?
> >>
> >> See my attached boot.diff / kernel config 
> >>
> >> Regards,
> >> Oliver
> >>
> >>
> >>
> >>
> >>> On 06.06.2011 21:56, Chris Ball wrote:
> >>>> Hi Oliver,
> >>>>
> >>>> On Mon, Jun 06 2011, Oliver Hartkopp wrote:
> >>>>>>> dmesg is a bit more detailed:
> >>>>>>> [    6.242510] sdhci-pci 0000:03:00.1: SDHCI controller found [1180:e822] (rev 3)
> >>>>>>> [    6.244168] sdhci-pci 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> >>>>>>> [    6.245788] sdhci-pci 0000:03:00.1: BAR 0 is not iomem. Aborting.
> >>>>>>> [    6.247609] sdhci-pci 0000:03:00.1: PCI INT B disabled
> >>>>
> >>>> If you get a chance to do some bisecting, that would be extremely
> >>>> helpful -- even just building 3.0 from *before* the MMC tree was
> >>>> merged would help a lot, since if the problem still happens before
> >>>> the MMC merge we might be looking at some kind of generic PCI bug.
> >>>>
> >>>
> >>>
> >>> Hi Chris,
> >>>
> >>> i just reverted this pull of your merge window patches in my 3.0.0-rc2 tree:
> >>>
> >>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8c1c77ff9be27137fa7cbbf51efedef1a2ae915b;hp=f3ae1c75203535f65448517e46c8dd70a56b6c71
> >>>
> >>> And you were right: The problem still exists. So it might be from the PCI subsystem :-(
> >>>
> >>> [    6.167106] sdhci: Secure Digital Host Controller Interface driver
> >>> [    6.167108] sdhci: Copyright(c) Pierre Ossman
> >>> [    6.194731] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
> >>> [    6.195140] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf6970000
> >>> [    6.196423] sdhci-pci 0000:03:00.1: SDHCI controller found [1180:e822] (rev 3)
> >>> [    6.196429] sdhci-pci 0000:03:00.1: found 1 slot(s)
> >>> [    6.196447] sdhci-pci 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> >>> [    6.196451] sdhci-pci 0000:03:00.1: BAR 0 is not iomem. Aborting.
> >>> [    6.196459] sdhci-pci 0000:03:00.1: PCI INT B disabled
> >>>
> >>> Well then, i'll reset my tree and look for differences in the PCI boot messages.
> >>>
> >>> Thanks,
> >>> Oliver
> >>
> > 
> 

...snip...
RP
