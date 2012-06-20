Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab2FTWsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:48:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:27107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758312Ab2FTWsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:48:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158866848"
Message-ID: <4FE25346.901@intel.com>
Date: Wed, 20 Jun 2012 15:48:38 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: IO_PAGE_FAULTS with igb or igbvf on AMD IOMMU system
References: <20120619102041.GI2624@amd.com> <4FE0C2A8.50602@intel.com> <20120620094844.GL2624@amd.com>
In-Reply-To: <20120620094844.GL2624@amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 02:48 AM, Joerg Roedel wrote:
> Hi Alexander,
>
> On Tue, Jun 19, 2012 at 11:19:20AM -0700, Alexander Duyck wrote:
>> Based on the faults it would look like accessing the descriptor rings is
>> probably triggering the errors.  We allocate the descriptor rings using
>> dma_alloc_coherent so the rings should be mapped correctly.
> Can this happen before the driver actually allocated the descriptors? As
> I said, the faults appear before any DMA-API call was made for that
> device (hence, domain=0x0000, because the domain is assigned on the
> first call to the DMA-API for a device).
>
> Also, I don't see the faults every time. One out of ten times
> (estimated) there are not faults. Is it possible that this is a race
> condition, e.g. that the card trys to access its descriptor rings before
> the driver allocated them (or something like that).
The descriptor rings are located in system memory so it shouldn't be
possible for the driver to start accessing anything without requesting
the address via the DMA-API calls.  As I said we use dma_alloc_coherent
to allocate the descriptor rings so I don't think it is possible for us
to configure the rings without calling the DMA-API.  You might try
double checking the timing on igbvf driver load versus the notifier
getting to the IOMMU.  I supposed this could be some sort of
initialization race between the driver and the IOMMU.  One way to verify
that would be to blacklist the VF driver and make sure it is unloaded
prior to loading the PF driver.  Load it manually via insmod after you
have have created the PCI devices by loading the PF module.  This way
you can guarantee that the igbvf load isn't somehow occuring prior to
the IOMMU notifier being triggered.

>> The PF and VF will end up being locked out since they are hung on an
>> uncompleted DMA transaction.  Normally we recommend that PCIe Advanced
>> Error Reporting be enabled if an IOMMU is enabled so the device can be
>> reset after triggering a page fault event.
>>
>> The first thing that pops into my head for possible issues would be that
>> maybe the VF pci_dev structure or the device structure isn't being
>> correctly initialized when SR-IOV is enabled on the igb interface.  Do
>> you know if there are any AMD IOMMU specific values on those structures,
>> such as the domain, that are supposed to be initialized prior to calling
>> the DMA API calls?  If so, have you tried adding debug output to verify
>> if those values are initialized on a VF prior to bringing up a VF interface?
> Well, when the device appears in the system the IOMMU driver gets
> notified about it using the device_change notifiers. It will then
> allocate all necessary data structures. I also verified that this works
> correctly while debugging this issue. So I am pretty sure the problem
> isn't there :)
You might want to try also adding some code to the dma_alloc_coherent
function in your kernel to verify that when the VF driver is allocating
the descriptor rings that the domain info is set-up correctly.

>> Also have you tried any other SR-IOV capable devices on this system? 
>> That would be a valuable data point because we could then exclude the
>> SR-IOV code as being a possible cause for the issues if other SR-IOV
>> devices are working without any issues.
> I have another SR-IOV device, but that fails to even enable SR-IOV
> because the BIOS did not let enough MMIO resources left. So I couldn't
> try it with that device. With the 82576 card enabling SR-IOV works fine
> but results in the faults from the VF.
If you are working on a recent kernel you should be able to overcome the
BIOS issues.  I believe there are the options "pci=assign-busses" if the
BIOS doesn't place enough buses on the bridge to support SR-IOV, and
there is "pci=realloc" which will reassign the MMIO resources to make
enough room for VF MMIO bars.

Thanks,

Alex


