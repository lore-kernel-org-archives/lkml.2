Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0CYBXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:23:32 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:55119 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab0CYBXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:23:31 -0400
Date: Thu, 25 Mar 2010 02:23:16 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 5/5] mincore: transparent huge page support
Message-ID: <20100325012316.GB27304@cmpxchg.org>
References: <1269354902-18975-1-git-send-email-hannes@cmpxchg.org> <1269354902-18975-6-git-send-email-hannes@cmpxchg.org> <20100324224858.GP10659@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324224858.GP10659@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 11:48:58PM +0100, Andrea Arcangeli wrote:
> On Tue, Mar 23, 2010 at 03:35:02PM +0100, Johannes Weiner wrote:
> > +static int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> > +			unsigned long addr, unsigned long end,
> > +			unsigned char *vec)
> > +{
> > +	int huge = 0;
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	spin_lock(&vma->vm_mm->page_table_lock);
> > +	if (likely(pmd_trans_huge(*pmd))) {
> > +		huge = !pmd_trans_splitting(*pmd);
> 
> Under mmap_sem (read or write) a hugepage can't materialize under
> us. So here the pmd_trans_huge can be lockless and run _before_ taking
> the page_table_lock. That's the invariant I used to keep identical
> performance for all fast paths.

Wait, there _is_ an unlocked fast-path pmd_trans_huge()
in mincore_pmd_range(), maybe you missed it?

This function is never called if the pmd is not huge.

So the above is the _second check_ under lock to get a stable
read on the entry that could be splitting or already have been
split while we checked locklessly.
