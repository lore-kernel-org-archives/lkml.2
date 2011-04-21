Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1DUMdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:33:09 -0400
Received: from thoth.sbs.de ([192.35.17.2]:27581 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab1DUMdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:33:08 -0400
Message-ID: <4DB023C7.5070007@siemens.com>
Date: Thu, 21 Apr 2011 14:32:07 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>,
        David Woodhouse <David.Woodhouse@intel.com>
CC: Sheng Yang <sheng@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH v2] intel-iommu: Fix use after release during device attach
References: <4CCFB84F.6050102@web.de> <201011021531.22886.sheng@linux.intel.com> <4CDFA96D.1060301@web.de> <4D01E677.5070702@siemens.com> <20101210184402.GE4040@sequoia.sous-sol.org> <4D22F9A4.3050807@web.de>
In-Reply-To: <4D22F9A4.3050807@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-04 11:42, Jan Kiszka wrote:
> Am 10.12.2010 19:44, Chris Wright wrote:
>> * Jan Kiszka (jan.kiszka@siemens.com) wrote:
>>>>>> --- a/drivers/pci/intel-iommu.c
>>>>>> +++ b/drivers/pci/intel-iommu.c
>>>>>> @@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(struct
>>>>>> iommu_domain *domain,
>>>>>>
>>>>>>  		pte = dmar_domain->pgd;
>>>>>>  		if (dma_pte_present(pte)) {
>>>>>> -			free_pgtable_page(dmar_domain->pgd);
>>>>>>  			dmar_domain->pgd = (struct dma_pte *)
>>>>>>  				phys_to_virt(dma_pte_addr(pte));
>>
>> While here, might as well remove the unnecessary cast.
>>
>>>>>> +			free_pgtable_page(pte);
>>>>>>  		}
>>>>>>  		dmar_domain->agaw--;
>>>>>>  	}
>>>>>
>>>>> Reviewed-by: Sheng Yang <sheng@linux.intel.com>
>>
>> Acked-by: Chris Wright <chrisw@sous-sol.org>
>>
>>>>> CC iommu mailing list and David.
>>>>
>>>> Ping...
>>>>
>>>> I think this fix also qualifies for stable (.35 and .36).
>>>>
>>>
>>> Still not merged?
>>
>> David, do you plan to pick this one up?
>>
>> thanks,
>> -chris
> 
> Hmm, still no reaction. Trying David's Intel address now...
> 
> Jan
> 

Walking through my old queues, I came across this one again.

Given the still lacking reaction from the official maintainer, I'm a
bit confused about the state of intel-iommu. Is it unmaintained? Should
this bug fix better be routed through the KVM tree as its only in-tree
user? Please enlighten me.

Note that the patch became stable material for 35..38 in the meantime,
and it should go into 39 before release as well.

Thanks,
Jan

-------8<--------

Obtain the new pgd pointer before releasing the page containing this
value. Remove unneeded cast at this chance as well.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/pci/intel-iommu.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

v1->v2: Clean up cast as suggested by Chris.

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 505c1c7..b3e5c43 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3607,9 +3607,8 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 
 		pte = dmar_domain->pgd;
 		if (dma_pte_present(pte)) {
-			free_pgtable_page(dmar_domain->pgd);
-			dmar_domain->pgd = (struct dma_pte *)
-				phys_to_virt(dma_pte_addr(pte));
+			dmar_domain->pgd = phys_to_virt(dma_pte_addr(pte));
+			free_pgtable_page(pte);
 		}
 		dmar_domain->agaw--;
 	}
-- 
1.7.1
