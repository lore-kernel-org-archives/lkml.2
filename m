Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2FTJs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:48:56 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:22054
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832Ab2FTJsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:48:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz98dI1432Izz1202hzz15d4Rz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M5WTX9-01-36S-02
X-M-MSG: 
Date: Wed, 20 Jun 2012 11:48:44 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        <e1000-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: IO_PAGE_FAULTS with igb or igbvf on AMD IOMMU system
Message-ID: <20120620094844.GL2624@amd.com>
References: <20120619102041.GI2624@amd.com>
 <4FE0C2A8.50602@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FE0C2A8.50602@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Tue, Jun 19, 2012 at 11:19:20AM -0700, Alexander Duyck wrote:
> Based on the faults it would look like accessing the descriptor rings is
> probably triggering the errors.  We allocate the descriptor rings using
> dma_alloc_coherent so the rings should be mapped correctly.

Can this happen before the driver actually allocated the descriptors? As
I said, the faults appear before any DMA-API call was made for that
device (hence, domain=0x0000, because the domain is assigned on the
first call to the DMA-API for a device).

Also, I don't see the faults every time. One out of ten times
(estimated) there are not faults. Is it possible that this is a race
condition, e.g. that the card trys to access its descriptor rings before
the driver allocated them (or something like that).

> The PF and VF will end up being locked out since they are hung on an
> uncompleted DMA transaction.  Normally we recommend that PCIe Advanced
> Error Reporting be enabled if an IOMMU is enabled so the device can be
> reset after triggering a page fault event.
> 
> The first thing that pops into my head for possible issues would be that
> maybe the VF pci_dev structure or the device structure isn't being
> correctly initialized when SR-IOV is enabled on the igb interface.  Do
> you know if there are any AMD IOMMU specific values on those structures,
> such as the domain, that are supposed to be initialized prior to calling
> the DMA API calls?  If so, have you tried adding debug output to verify
> if those values are initialized on a VF prior to bringing up a VF interface?

Well, when the device appears in the system the IOMMU driver gets
notified about it using the device_change notifiers. It will then
allocate all necessary data structures. I also verified that this works
correctly while debugging this issue. So I am pretty sure the problem
isn't there :)

> Also have you tried any other SR-IOV capable devices on this system? 
> That would be a valuable data point because we could then exclude the
> SR-IOV code as being a possible cause for the issues if other SR-IOV
> devices are working without any issues.

I have another SR-IOV device, but that fails to even enable SR-IOV
because the BIOS did not let enough MMIO resources left. So I couldn't
try it with that device. With the 82576 card enabling SR-IOV works fine
but results in the faults from the VF.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

