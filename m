Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1BCVdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:33:38 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52054 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab1BCVdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:33:37 -0500
Subject: Re: [RFC][PATCH 2/6] pagewalk: only split huge pages when necessary
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <alpine.DEB.2.00.1102031257490.948@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel>
	 <20110201003359.8DDFF665@kernel>
	 <alpine.DEB.2.00.1102031257490.948@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 03 Feb 2011 13:33:32 -0800
Message-ID: <1296768812.8299.1644.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 13:22 -0800, David Rientjes wrote:
> > diff -puN mm/pagewalk.c~pagewalk-dont-always-split-thp mm/pagewalk.c
> > --- linux-2.6.git/mm/pagewalk.c~pagewalk-dont-always-split-thp	2011-01-27 10:57:02.309914973 -0800
> > +++ linux-2.6.git-dave/mm/pagewalk.c	2011-01-27 10:57:02.317914965 -0800
> > @@ -33,19 +33,35 @@ static int walk_pmd_range(pud_t *pud, un
> >  
> >  	pmd = pmd_offset(pud, addr);
> >  	do {
> > +	again:
> 
> checkpatch will warn about the indent.
> 
> >  		next = pmd_addr_end(addr, end);
> > -		split_huge_page_pmd(walk->mm, pmd);
> > -		if (pmd_none_or_clear_bad(pmd)) {
> > +		if (pmd_none(*pmd)) {
> 
> Not sure why this has been changed from pmd_none_or_clear_bad(), that's 
> been done even prior to THP.

The bad check will trigger on huge pmds.  We can not use it here.  We
can, however, use pmd_none().  The bad check was moved below to where we
actually dereference the pmd.

> >  			if (walk->pte_hole)
> >  				err = walk->pte_hole(addr, next, walk);
> >  			if (err)
> >  				break;
> >  			continue;
> >  		}
> > +		/*
> > +		 * This implies that each ->pmd_entry() handler
> > +		 * needs to know about pmd_trans_huge() pmds
> > +		 */
> 
> Probably needs to be documented somewhere for users of pagewalk?

Probably, but we don't currently have any central documentation for it.
Guess we could make some, or just ensure that all the users got updated.
Any ideas where to put it other than the mm_walk struct?

-- Dave

