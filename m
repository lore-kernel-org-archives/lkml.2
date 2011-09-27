Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1I0M0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:26:51 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48309 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1I0M0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:26:50 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.46.211]
In-Reply-To: <20110927100505.GH2138@amd.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-2-git-send-email-ohad@wizery.com> <20110927100505.GH2138@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 27 Sep 2011 15:26:29 +0300
Message-ID: <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 1:05 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> On Fri, Sep 16, 2011 at 01:51:41PM -0400, Ohad Ben-Cohen wrote:
>>  int iommu_map(struct iommu_domain *domain, unsigned long iova,
>> -             phys_addr_t paddr, int gfp_order, int prot)
>> +             phys_addr_t paddr, size_t size, int prot)
>>  {
>> -       size_t size;
>> +       int ret = 0;
>> +
>> +       /*
>> +        * both the virtual address and the physical one, as well as
>> +        * the size of the mapping, must be aligned (at least) to the
>> +        * size of the smallest page supported by the hardware
>> +        */
>> +       if (!IS_ALIGNED(iova | paddr | size, iommu_min_pagesz)) {
>> +               pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%lx min_pagesz "
>> +                       "0x%x\n", iova, (unsigned long)paddr,
>> +                       (unsigned long)size, iommu_min_pagesz);
>> +               return -EINVAL;
>> +       }
>> +
>> +       pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
>> +                               (unsigned long)paddr, (unsigned long)size);
>> +
>> +       while (size) {
>> +               unsigned long pgsize = iommu_min_pagesz;
>> +               unsigned long idx = iommu_min_page_idx;
>> +               unsigned long addr_merge = iova | paddr;
>> +               int order;
>> +
>> +               /* find the max page size with which iova, paddr are aligned */
>> +               for (;;) {
>> +                       unsigned long try_pgsize;
>> +
>> +                       idx = find_next_bit(iommu_pgsize_bitmap,
>> +                                               iommu_nr_page_bits, idx + 1);
>> +
>> +                       /* no more pages to check ? */
>> +                       if (idx >= iommu_nr_page_bits)
>> +                               break;
>> +
>> +                       try_pgsize = 1 << idx;
>>
>> -       size         = 0x1000UL << gfp_order;
>> +                       /* page too big ? addresses not aligned ? */
>> +                       if (size < try_pgsize ||
>> +                                       !IS_ALIGNED(addr_merge, try_pgsize))
>> +                               break;
>>
>> -       BUG_ON(!IS_ALIGNED(iova | paddr, size));
>> +                       pgsize = try_pgsize;
>> +               }
>
> With an unsigned long you can use plain and fast bit_ops instead of the
> full bitmap functions.

Not sure I follow; the only bit operation I'm using while mapping is
find_next_bit() (which is a bitops.h method).

What other faster variant are you referring to ?

Thanks,
Ohad.
