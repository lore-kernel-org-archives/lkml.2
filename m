Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2FTQvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:51:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:46397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab2FTQvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:51:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168085906"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: Joerg Roedel <joerg.roedel@amd.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: IO_PAGE_FAULTS with igb or igbvf on AMD IOMMU system
Thread-Topic: IO_PAGE_FAULTS with igb or igbvf on AMD IOMMU system
Thread-Index: AQHNTgU+lKeEBPkI2E+A1o6+OmqXspcCaWUAgAEDqwD///pesA==
Date: Wed, 20 Jun 2012 16:51:36 +0000
Message-ID: <C5551D9AAB213A418B7FD5E4A6F30A070C73A57E@ORSMSX106.amr.corp.intel.com>
References: <20120619102041.GI2624@amd.com> <4FE0C2A8.50602@intel.com>
 <20120620094844.GL2624@amd.com>
In-Reply-To: <20120620094844.GL2624@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joerg Roedel [mailto:joerg.roedel@amd.com]
> Sent: Wednesday, June 20, 2012 2:49 AM
> To: Duyck, Alexander H
> Cc: Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
> Carolyn; Skidmore, Donald C; Rose, Gregory V; Waskiewicz Jr, Peter P;
> Ronciak, John; e1000-devel@lists.sourceforge.net; linux-
> kernel@vger.kernel.org
> Subject: Re: IO_PAGE_FAULTS with igb or igbvf on AMD IOMMU system
> 
> Hi Alexander,
> 
> On Tue, Jun 19, 2012 at 11:19:20AM -0700, Alexander Duyck wrote:
> > Based on the faults it would look like accessing the descriptor rings
> > is probably triggering the errors.  We allocate the descriptor rings
> > using dma_alloc_coherent so the rings should be mapped correctly.
> 
> Can this happen before the driver actually allocated the descriptors? As I
> said, the faults appear before any DMA-API call was made for that device
> (hence, domain=0x0000, because the domain is assigned on the first call to
> the DMA-API for a device).
> 
> Also, I don't see the faults every time. One out of ten times
> (estimated) there are not faults. Is it possible that this is a race
> condition, e.g. that the card trys to access its descriptor rings before
> the driver allocated them (or something like that).
> 
> > The PF and VF will end up being locked out since they are hung on an
> > uncompleted DMA transaction.  Normally we recommend that PCIe Advanced
> > Error Reporting be enabled if an IOMMU is enabled so the device can be
> > reset after triggering a page fault event.
> >
> > The first thing that pops into my head for possible issues would be
> > that maybe the VF pci_dev structure or the device structure isn't
> > being correctly initialized when SR-IOV is enabled on the igb
> > interface.  Do you know if there are any AMD IOMMU specific values on
> > those structures, such as the domain, that are supposed to be
> > initialized prior to calling the DMA API calls?  If so, have you tried
> > adding debug output to verify if those values are initialized on a VF
> prior to bringing up a VF interface?
> 
> Well, when the device appears in the system the IOMMU driver gets notified
> about it using the device_change notifiers. It will then allocate all
> necessary data structures. I also verified that this works correctly while
> debugging this issue. So I am pretty sure the problem isn't there :)
> 
> > Also have you tried any other SR-IOV capable devices on this system?
> > That would be a valuable data point because we could then exclude the
> > SR-IOV code as being a possible cause for the issues if other SR-IOV
> > devices are working without any issues.
> 
> I have another SR-IOV device, but that fails to even enable SR-IOV because
> the BIOS did not let enough MMIO resources left. So I couldn't try it with
> that device. With the 82576 card enabling SR-IOV works fine but results in
> the faults from the VF.

That sounds very suspicious to me.  The 82576 might still seem to work because it only has less than 8 VFs, which might be why it isn't reporting the MMIO resources issue.  That doesn't mean it would work correctly and I suspect that the IO_PAGE_FAULT error is due to an MMIO access, not a DMA access.  MMIO resources for devices are page mapped and if your BIOS is broken that might not be done correctly.

I have the feeling the issue is the BIOS.  You probably want to contact your system vendor and make sure you have the correct BIOS installed or even whether they claim that the system is supposed to support SR-IOV.

- Greg

> 
> Regards,
> 
> 	Joerg
> 
> --
> AMD Operating System Research Center
> 
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach General
> Managers: Alberto Bozzo
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr.
> 43632

