Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab1KQE4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 23:56:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58078 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab1KQE4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 23:56:07 -0500
Date: Wed, 16 Nov 2011 20:56:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] hugetlb: Provide a default HPAGE_SHIFT if
 !CONFIG_HUGETLB_PAGE
In-Reply-To: <4EC45CAE.1000704@gmail.com>
Message-ID: <alpine.DEB.2.00.1111162047170.13603@chino.kir.corp.google.com>
References: <1321472611-13283-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111161327180.16596@chino.kir.corp.google.com> <4EC43488.3070400@gmail.com> <alpine.DEB.2.00.1111161512371.16596@chino.kir.corp.google.com> <4EC44AD0.5070800@gmail.com>
 <alpine.DEB.2.00.1111161552450.25089@chino.kir.corp.google.com> <4EC45CAE.1000704@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, David Daney wrote:

> > > It is a well established kernel idiom to supply dummy values for symbols
> > > that
> > > are required to be defined in order to form a syntactically correct C
> > > program,
> > > but that are known by the programmer to be used only on dead code paths.
> > > 
> > > This is exactly what we are doing here.
> > > 
> > > To do otherwise requires that code be cluttered with #ifdefery.
> > > 
> > 
> > You're wrong,
> 
> Ok, then please tell me why:
> 
> 1) the dummy version of is_vm_hugetlb_page() exists in hugetlb_inline.h?
> 2) the dummy version of PageHuge() exists in hugetlb.h
> 3) the dummy version of reset_vma_resv_huge_pages()
> 4) the dummy version of hugetlb_total_pages() exists in hugetlb.h
> 5) the dummy version of follow_hugetlb_page() exists in hugetlb.h
> 6) the dummy version of follow_huge_addr() exists in hugetlb.h
> 7) the dummy version of copy_hugetlb_page_range() exists in hugetlb.h
> 8) the dummy version of hugetlb_prefault() exists in hugetlb.h
> 9) the dummy version of unmap_hugepage_range() exists in hugetlb.h
> 10) the dummy version of hugetlb_report_meminfo() exists in hugetlb.h
> 11) the dummy version of hugetlb_report_node_meminfo() exists in hugetlb.h
> 12) the dummy version of follow_huge_pmd() exists in hugetlb.h
> 13) the dummy version of follow_huge_pud() exists in hugetlb.h
> 14) the dummy version of prepare_hugepage_range() exists in hugetlb.h
> 15) the dummy version of pmd_huge() exists in hugetlb.h
> 16) the dummy version of pud_huge() exists in hugetlb.h
> 17) the dummy version of is_hugepage_only_range() exists in hugetlb.h
> 17) the dummy version of hugetlb_free_pgd_range() exists in hugetlb.h
> 18) the dummy version of hugetlb_fault() exists in hugetlb.h
> 19) the dummy version of huge_pte_offset() exists in hugetlb.h
> 20) the dummy version of dequeue_hwpoisoned_huge_page() exists in hugetlb.h
> 21) the dummy version of copy_huge_page() exists in hugetlb.h
> 22) the dummy version of hugetlb_change_protection() exists in hugetlb.h
> .
> .
> .
> [Other non HUGETLB_PAGE examples omitted for conciseness]
> 

To avoid the #ifdef's, but you'll notice that they return either NULL, 0, 
or are a no-op.  We don't substitute real values in dummy functions where 
they could be used in generic code as though they were valid.  That's the 
problem with defining HPAGE_SHIFT to be PAGE_SHIFT and, yes, defining 
HPAGE_MASK and HPAGE_SIZE as well shouldn't be done and should be removed.  

We expect HPAGE_* to represent hugepages, not the native page size of the 
bare metal.  This is why we do things like

	#define HPAGE_PMD_SHIFT ({ BUG(); 0; })
	#define HPAGE_PMD_MASK ({ BUG(); 0; })
	#define HPAGE_PMD_SIZE ({ BUG(); 0; })

for CONFIG_TRANSPARENT_HUGEPAGE=n.  We don't want to pretend that they're 
valid outside the context of hugepages.

We also never use HPAGE_SHIFT, HPAGE_MASK, or HPAGE_SIZE in generic code 
that isn't dependent on CONFIG_HUGETLB_PAGE.  If you'd like to submit a 
patch to fix this in the mips tree, then that would be good, and if you'd 
like to submit a patch to remove these dummy definitions all together by 
auditing other arch code, then that would be great.
