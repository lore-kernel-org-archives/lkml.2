Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0KBGwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 02:52:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:58031 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab0KBGwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 02:52:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,279,1286175600"; 
   d="scan'208";a="673306566"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: Crash in intel_iommu_assign_device
Date: Tue, 2 Nov 2010 14:52:19 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4CCEA761.90501@web.de>
In-Reply-To: <4CCEA761.90501@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011021452.19525.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 November 2010 19:41:21 Jan Kiszka wrote:
> Hi Sheng,
> 
> I'm not claiming to understand the details, but this looks like use
> (dereference of pte via dma_pte_addr) after release (free_pgtable_page
> of dmar_domain->pgd aka pte) to me:
> 
> static int intel_iommu_attach_device(struct iommu_domain *domain,
> 				     struct device *dev)
> {
> 	[...]
> 		pte = dmar_domain->pgd;
> 		if (dma_pte_present(pte)) {
> 			free_pgtable_page(dmar_domain->pgd);
> 			dmar_domain->pgd = (struct dma_pte *)
> 				phys_to_virt(dma_pte_addr(pte));
> 		}
> 
> At least it crashes here right on pte->val access. Swap both lines?

I think code is right.

The comment above indicate the case: the code want to decrease the level of page 
table. Mostly it is a 4 level page table, and the code would turn it into 3 levels 
pagetable. What the code did is just get the first entry of the old pagetable level 
4, then free the level 4 pagetable's page, and make the pagetable to a level 3 
pagetable.

Seems it make no sense to swap the lines...

--
regards
Yang, Sheng

> 
> Jan
