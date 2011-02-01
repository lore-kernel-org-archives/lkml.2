Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1BAQJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:09:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab1BAQJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:09:48 -0500
Date: Tue, 1 Feb 2011 17:09:32 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
Subject: Re: [RFC][PATCH 5/6] teach smaps_pte_range() about THP pmds
Message-ID: <20110201160932.GY16981@random.random>
References: <20110201003357.D6F0BE0D@kernel>
 <20110201003403.736A24DF@kernel>
 <20110201101111.GK19534@cmpxchg.org>
 <1296572550.27022.2862.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296572550.27022.2862.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 07:02:30AM -0800, Dave Hansen wrote:
> On Tue, 2011-02-01 at 11:11 +0100, Johannes Weiner wrote:
> > On Mon, Jan 31, 2011 at 04:34:03PM -0800, Dave Hansen wrote:
> > > +	if (pmd_trans_huge(*pmd)) {
> > > +		if (pmd_trans_splitting(*pmd)) {
> > > +			spin_unlock(&walk->mm->page_table_lock);
> > > +			wait_split_huge_page(vma->anon_vma, pmd);
> > > +			spin_lock(&walk->mm->page_table_lock);
> > > +			goto normal_ptes;
> > > +		}
> > > +		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
> > > +		return 0;
> > > +	}
> > > +normal_ptes:
> > >  	split_huge_page_pmd(walk->mm, pmd);
> > 
> > This line can go away now...?
> 
> I did this because I was unsure what keeps khugepaged away from the
> newly-split ptes between the wait_split_huge_page() and the
> reacquisition of the mm->page_table_lock.  mmap_sem, perhaps?

Any of mmap_sem read mode, PG_lock and anon_vma_lock keeps khugepaged
away.

> Looking at follow_page() and some of the other wait_split_huge_page(),
> it looks like this is unnecessary.  

When wait_split_huge_page returns after the pmd was splitting, the pmd
can't return huge under you as long as you hold any of the above.
