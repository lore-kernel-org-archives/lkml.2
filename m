Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0LQS35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:29:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:2478 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab0LQS3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:29:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,189,1291622400"; 
   d="scan'208";a="363242132"
Subject: RE: intel-iommu.c bug
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Raj, Ashok" <ashok.raj@intel.com>
Cc: Cliff Wickman <cpw@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>
In-Reply-To: <647EFE31A07A4A478691C20DABDFFCB125C3855230@orsmsx501.amr.corp.intel.com>
References: <E1PTbq3-00083L-Sp@eag09.americas.sgi.com>
	 <647EFE31A07A4A478691C20DABDFFCB125C3855230@orsmsx501.amr.corp.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 17 Dec 2010 10:28:03 -0800
Message-Id: <1292610483.2674.1.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 10:11 -0800, Raj, Ashok wrote:
> Hi Cliff
> 
> Sending this to Suresh who is handling linux iommu.

No. It is David Woodhouse (added).

> 
> Ashok
> 
> 
> >-----Original Message-----
> >From: Cliff Wickman [mailto:cpw@sgi.com]
> >Sent: Friday, December 17, 2010 7:03 AM
> >To: linux-kernel@vger.kernel.org
> >Cc: Raj, Ashok; Li, Shaohua; Keshavamurthy, Anil S; Yu, Fenghua
> >Subject: intel-iommu.c bug
> >
> >
> >
> >This bug was reported by Mike Habeck <habeck@sgi.com>.
> >The test system was an SGI Altix UV.  These are Mike's words:
> >
> > It appears there is a bug in the iommu code that when 'forcedac' isn't used
> > the nvidia driver is handed back a 44bit dma address even though it's
> > dma_mask is set to 40bits.
> >
> > I added some debug to the intel_iommu code and I see:
> >  intel_map_sg(): dma_addr_t=0xf81fffff000, pdev->dma_mask=0xffffffffff
> >
> > Note the dma_addr_t being handed back is 44bits even though the mask is 40bits.
> > This results in the nvidia card generating a bad dma (i.e. the nvidia hw is
> > only capable of generating a 40bit dma address so the upper 4 bits are lost
> > and that results in the iommu hw detecting a bad dma access):
> >
> >   DRHD: handling fault status reg 2
> >   DMAR:[DMA Read] Request device [36:00.0] fault addr 81fffff000
> >   DMAR:[fault reason 06] PTE Read access is not set
> >
> > If I boot with 'forcedac' then the dma mask is honored and the dma_addr_t
> > handed back is 40bits:
> >
> >   intel_map_sg(): dma_addr_t=0xfffffff000, pdev->dma_mask=0xffffffffff
> >
> > Without forcedac you'd expect these early maps being handed back to be 32bits.
> > This is the first debug printf (so the first mapping the nvidia device has
> > requested) so I'd expect it to be 0xfffff000... interesting that is what the
> > lower 32bits are in this address being handed back... that 0xf81 upper bits
> > appear to be garbage bits.  This might be a hint to help find the bug...
> >

