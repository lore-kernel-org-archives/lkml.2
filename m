Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1BAPCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:02:41 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44033 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1BAPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:02:40 -0500
Subject: Re: [RFC][PATCH 5/6] teach smaps_pte_range() about THP pmds
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <20110201101111.GK19534@cmpxchg.org>
References: <20110201003357.D6F0BE0D@kernel>
	 <20110201003403.736A24DF@kernel>  <20110201101111.GK19534@cmpxchg.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 01 Feb 2011 07:02:30 -0800
Message-ID: <1296572550.27022.2862.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 11:11 +0100, Johannes Weiner wrote:
> On Mon, Jan 31, 2011 at 04:34:03PM -0800, Dave Hansen wrote:
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
> >  	split_huge_page_pmd(walk->mm, pmd);
> 
> This line can go away now...?

I did this because I was unsure what keeps khugepaged away from the
newly-split ptes between the wait_split_huge_page() and the
reacquisition of the mm->page_table_lock.  mmap_sem, perhaps?

Looking at follow_page() and some of the other wait_split_huge_page(),
it looks like this is unnecessary.  

-- Dave

