Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab2JISfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:35:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab2JISfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:35:45 -0400
Message-ID: <1349807739.2759.292.camel@ul30vt.home>
Subject: Re: [RFC PATCH 0/5] amd_iommu: Refactor IOMMU group and support
 virtual aliases
From: Alex Williamson <alex.williamson@redhat.com>
To: Florian Dazinger <florian@dazinger.net>
Cc: Joerg.Roedel@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Oct 2012 12:35:39 -0600
In-Reply-To: <20121009202738.7e047e64@brain.lan>
References: <20121009044057.16302.44577.stgit@bling.home>
	 <20121009202738.7e047e64@brain.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 20:27 +0200, Florian Dazinger wrote:
> Am Mon, 08 Oct 2012 22:49:28 -0600
> schrieb Alex Williamson <alex.williamson@redhat.com>:
> 
> > This series is meant to refactor IOMMU group support in amd_iommu
> > to properly support virtual aliases.  If multiple devices alias to
> > the same virtual alias, they should be grouped together.  This code
> > also verifies whether the alias should be the root of the group vs
> > devices above the alias.
> > 
> > This seems to do the right thing on my system, but that's not saying
> > a lot since it doesn't do anything interesting with aliases.  I'd
> > appreciate if Joerg and Florian could test this on their systems.
> > Thanks,
> > 
> > Alex
> > 
> > ---
> > 
> > Alex Williamson (5):
> >       amd_iommu: Properly account for virtual aliases in IOMMU groups
> >       amd_iommu: Split IOMMU group allocation and attach
> >       amd_iommu: Split upstream bus device lookup
> >       amd_iommu: Split IOMMU Group topology walk
> >       amd_iommu: Split IOMMU group initialization
> > 
> > 
> >  drivers/iommu/amd_iommu.c       |  184 ++++++++++++++++++++++++++++++---------
> >  drivers/iommu/amd_iommu_types.h |    1 
> >  2 files changed, 142 insertions(+), 43 deletions(-)
> > 
> 
> patch #5 does not apply cleanly on top of 3.6, I had to edit
> amd_iommu_types.h manually (easy enough), apart from that, it is
> working fine!

Thanks Florian.  Would you mind also reporting
'find /sys/kernel/iommu_groups' for both stock 3.6 and with this series
applied?  I think we want to find that devices 07:00.0 and 08:04.0 are
grouped together and I'd like to verify whether that actually works.
Thanks,

Alex

> dmesg:
> [    1.475665] pci 0000:01:00.0: Boot video device
> [    1.475762] PCI: CLS 64 bytes, default 64
> [    1.478371] AMD-Vi: device: 00:00.2 cap: 0040 seg: 0 flags: 3e info 1300
> [    1.478409] AMD-Vi:        mmio-addr: 00000000feb20000
> [    1.478487] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:00.0 flags: 00
> [    1.478521] AMD-Vi:   DEV_RANGE_END           devid: 00:00.2
> [    1.478555] AMD-Vi:   DEV_SELECT                      devid: 00:02.0 flags: 00
> [    1.478588] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 01:00.0 flags: 00
> [    1.478622] AMD-Vi:   DEV_RANGE_END           devid: 01:00.1
> [    1.478655] AMD-Vi:   DEV_SELECT                      devid: 00:04.0 flags: 00
> [    1.478688] AMD-Vi:   DEV_SELECT                      devid: 02:00.0 flags: 00
> [    1.478722] AMD-Vi:   DEV_SELECT                      devid: 00:05.0 flags: 00
> [    1.478755] AMD-Vi:   DEV_SELECT                      devid: 03:00.0 flags: 00
> [    1.478788] AMD-Vi:   DEV_SELECT                      devid: 00:06.0 flags: 00
> [    1.478822] AMD-Vi:   DEV_SELECT                      devid: 04:00.0 flags: 00
> [    1.478855] AMD-Vi:   DEV_SELECT                      devid: 00:07.0 flags: 00
> [    1.478888] AMD-Vi:   DEV_SELECT                      devid: 05:00.0 flags: 00
> [    1.478921] AMD-Vi:   DEV_SELECT                      devid: 00:09.0 flags: 00
> [    1.478955] AMD-Vi:   DEV_SELECT                      devid: 06:00.0 flags: 00
> [    1.478988] AMD-Vi:   DEV_SELECT                      devid: 00:0d.0 flags: 00
> [    1.479021] AMD-Vi:   DEV_SELECT                      devid: 07:00.0 flags: 00
> [    1.479055] AMD-Vi:   DEV_ALIAS_RANGE                 devid: 08:01.0 flags: 00 devid_to: 08:00.0
> [    1.479091] AMD-Vi:   DEV_RANGE_END           devid: 08:1f.7
> [    1.479128] AMD-Vi:   DEV_SELECT                      devid: 00:11.0 flags: 00
> [    1.479162] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:12.0 flags: 00
> [    1.479195] AMD-Vi:   DEV_RANGE_END           devid: 00:12.2
> [    1.479229] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:13.0 flags: 00
> [    1.479262] AMD-Vi:   DEV_RANGE_END           devid: 00:13.2
> [    1.479295] AMD-Vi:   DEV_SELECT                      devid: 00:14.0 flags: d7
> [    1.479329] AMD-Vi:   DEV_SELECT                      devid: 00:14.3 flags: 00
> [    1.479362] AMD-Vi:   DEV_SELECT                      devid: 00:14.4 flags: 00
> [    1.479396] AMD-Vi:   DEV_ALIAS_RANGE                 devid: 09:00.0 flags: 00 devid_to: 00:14.4
> [    1.479432] AMD-Vi:   DEV_RANGE_END           devid: 09:1f.7
> [    1.479478] AMD-Vi:   DEV_SELECT                      devid: 00:14.5 flags: 00
> [    1.479513] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:16.0 flags: 00
> [    1.479547] AMD-Vi:   DEV_RANGE_END           devid: 00:16.2
> [    1.533745] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
> [    1.533781] 
> [    1.533830] pci 0000:00:00.2: irq 72 for MSI/MSI-X
> [    1.542957] AMD-Vi: Lazy IO/TLB flushing enabled
> 
> lspci:
> 00:00.0 Host bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (external gfx0 port B) (rev 02)
> 00:00.2 IOMMU: Advanced Micro Devices [AMD] nee ATI RD990 I/O Memory Management Unit (IOMMU)
> 00:02.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port B)
> 00:04.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port D)
> 00:05.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port E)
> 00:06.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port F)
> 00:07.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port G)
> 00:09.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port H)
> 00:0d.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (external gfx1 port B)
> 00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40)
> 00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 42)
> 00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
> 00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to PCI Bridge (rev 40)
> 00:14.5 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
> 00:16.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:16.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI RV730XT [Radeon HD 4670]
> 01:00.1 Audio device: Advanced Micro Devices [AMD] nee ATI RV710/730 HDMI Audio [Radeon HD 4000 series]
> 02:00.0 SATA controller: ASMedia Technology Inc. ASM1062 Serial ATA Controller (rev 01)
> 03:00.0 Ethernet controller: Intel Corporation 82583V Gigabit Network Connection
> 04:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB Host Controller
> 05:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB Host Controller
> 06:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB Host Controller
> 07:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI Express-to-PCI Bridge (rev aa)
> 08:04.0 Multimedia audio controller: C-Media Electronics Inc CMI8788 [Oxygen HD Audio]



