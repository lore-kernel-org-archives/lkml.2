Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0LQSLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:11:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:42408 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab0LQSLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:11:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,189,1291622400"; 
   d="scan'208";a="869371605"
From: "Raj, Ashok" <ashok.raj@intel.com>
To: Cliff Wickman <cpw@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Li, Shaohua" <shaohua.li@intel.com>,
        "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Fri, 17 Dec 2010 10:11:35 -0800
Subject: RE: intel-iommu.c bug
Thread-Topic: intel-iommu.c bug
Thread-Index: Acud+5UB8WdIDo+PTNmSwafEsk9uqAAFuhqQ
Message-ID: <647EFE31A07A4A478691C20DABDFFCB125C3855230@orsmsx501.amr.corp.intel.com>
References: <E1PTbq3-00083L-Sp@eag09.americas.sgi.com>
In-Reply-To: <E1PTbq3-00083L-Sp@eag09.americas.sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cliff

Sending this to Suresh who is handling linux iommu.

Ashok


>-----Original Message-----
>From: Cliff Wickman [mailto:cpw@sgi.com]
>Sent: Friday, December 17, 2010 7:03 AM
>To: linux-kernel@vger.kernel.org
>Cc: Raj, Ashok; Li, Shaohua; Keshavamurthy, Anil S; Yu, Fenghua
>Subject: intel-iommu.c bug
>
>
>
>This bug was reported by Mike Habeck <habeck@sgi.com>.
>The test system was an SGI Altix UV.  These are Mike's words:
>
> It appears there is a bug in the iommu code that when 'forcedac' isn't used
> the nvidia driver is handed back a 44bit dma address even though it's
> dma_mask is set to 40bits.
>
> I added some debug to the intel_iommu code and I see:
>  intel_map_sg(): dma_addr_t=0xf81fffff000, pdev->dma_mask=0xffffffffff
>
> Note the dma_addr_t being handed back is 44bits even though the mask is 40bits.
> This results in the nvidia card generating a bad dma (i.e. the nvidia hw is
> only capable of generating a 40bit dma address so the upper 4 bits are lost
> and that results in the iommu hw detecting a bad dma access):
>
>   DRHD: handling fault status reg 2
>   DMAR:[DMA Read] Request device [36:00.0] fault addr 81fffff000
>   DMAR:[fault reason 06] PTE Read access is not set
>
> If I boot with 'forcedac' then the dma mask is honored and the dma_addr_t
> handed back is 40bits:
>
>   intel_map_sg(): dma_addr_t=0xfffffff000, pdev->dma_mask=0xffffffffff
>
> Without forcedac you'd expect these early maps being handed back to be 32bits.
> This is the first debug printf (so the first mapping the nvidia device has
> requested) so I'd expect it to be 0xfffff000... interesting that is what the
> lower 32bits are in this address being handed back... that 0xf81 upper bits
> appear to be garbage bits.  This might be a hint to help find the bug...
>
