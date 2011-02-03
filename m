Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1BCVe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:34:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37035 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1BCVe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:34:56 -0500
Subject: Re: [RFC][PATCH 5/6] teach smaps_pte_range() about THP pmds
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <alpine.DEB.2.00.1102031319070.1307@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel>
	 <20110201003403.736A24DF@kernel>
	 <alpine.DEB.2.00.1102031319070.1307@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 03 Feb 2011 13:34:50 -0800
Message-ID: <1296768890.8299.1648.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 13:22 -0800, David Rientjes wrote:
> > @@ -385,6 +386,17 @@ static int smaps_pte_range(pmd_t *pmd, u
> >  	pte_t *pte;
> >  	spinlock_t *ptl;
> >  
> > +	if (pmd_trans_huge(*pmd)) {
> > +		if (pmd_trans_splitting(*pmd)) {
> > +			spin_unlock(&walk->mm->page_table_lock);
> > +			wait_split_huge_page(vma->anon_vma, pmd);
> > +			spin_lock(&walk->mm->page_table_lock);
> > +			goto normal_ptes;
> > +		}
> > +		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
> > +		return 0;
> > +	}
> > +normal_ptes:
> 
> Small nitpick: the label isn't necessary, just use an else-clause on your 
> nested conditional.

Works for me.

> >  	split_huge_page_pmd(walk->mm, pmd);
> >  
> >  	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > diff -puN mm/vmscan.c~teach-smaps_pte_range-about-thp-pmds mm/vmscan.c
> > diff -puN include/trace/events/vmscan.h~teach-smaps_pte_range-about-thp-pmds include/trace/events/vmscan.h
> > diff -puN mm/pagewalk.c~teach-smaps_pte_range-about-thp-pmds mm/pagewalk.c
> > diff -puN mm/huge_memory.c~teach-smaps_pte_range-about-thp-pmds mm/huge_memory.c
> > diff -puN mm/memory.c~teach-smaps_pte_range-about-thp-pmds mm/memory.c
> > diff -puN include/linux/huge_mm.h~teach-smaps_pte_range-about-thp-pmds include/linux/huge_mm.h
> > diff -puN mm/internal.h~teach-smaps_pte_range-about-thp-pmds mm/internal.h
> > _
> 
> What are all these?

Junk.  I'll pull them out.

-- Dave

