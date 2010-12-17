Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0LQPCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:02:34 -0500
Received: from relay3.sgi.com ([192.48.152.1]:44656 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755134Ab0LQPCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:02:33 -0500
To: linux-kernel@vger.kernel.org
Subject: intel-iommu.c bug
Cc: ashok.raj@intel.com, shaohua.li@intel.com, anil.s.keshavamurthy@intel.com,
        fenghua.yu@intel.com
Message-Id: <E1PTbq3-00083L-Sp@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 17 Dec 2010 09:03:19 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This bug was reported by Mike Habeck <habeck@sgi.com>.
The test system was an SGI Altix UV.  These are Mike's words:

 It appears there is a bug in the iommu code that when 'forcedac' isn't used
 the nvidia driver is handed back a 44bit dma address even though it's
 dma_mask is set to 40bits.
 
 I added some debug to the intel_iommu code and I see:
  intel_map_sg(): dma_addr_t=0xf81fffff000, pdev->dma_mask=0xffffffffff
 
 Note the dma_addr_t being handed back is 44bits even though the mask is 40bits.  
 This results in the nvidia card generating a bad dma (i.e. the nvidia hw is
 only capable of generating a 40bit dma address so the upper 4 bits are lost
 and that results in the iommu hw detecting a bad dma access):
 
   DRHD: handling fault status reg 2
   DMAR:[DMA Read] Request device [36:00.0] fault addr 81fffff000 
   DMAR:[fault reason 06] PTE Read access is not set
 
 If I boot with 'forcedac' then the dma mask is honored and the dma_addr_t
 handed back is 40bits:
 
   intel_map_sg(): dma_addr_t=0xfffffff000, pdev->dma_mask=0xffffffffff
 
 Without forcedac you'd expect these early maps being handed back to be 32bits.  
 This is the first debug printf (so the first mapping the nvidia device has
 requested) so I'd expect it to be 0xfffff000... interesting that is what the
 lower 32bits are in this address being handed back... that 0xf81 upper bits 
 appear to be garbage bits.  This might be a hint to help find the bug...
 
