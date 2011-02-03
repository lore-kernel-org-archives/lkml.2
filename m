Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1BCVqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:46:34 -0500
Received: from smtp-out.google.com ([74.125.121.67]:49681 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1BCVqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:46:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=LPESlGD5Xi6XlqAHYqe1Tzn2fAVNAv7loHHCVE8YOizZk/onw6LB0CK1fOW+TOCMU8
         /6GVBWq9NIoMOgXkUX+A==
Date: Thu, 3 Feb 2011 13:46:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 2/6] pagewalk: only split huge pages when
 necessary
In-Reply-To: <1296768812.8299.1644.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1102031343530.1307@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel> <20110201003359.8DDFF665@kernel> <alpine.DEB.2.00.1102031257490.948@chino.kir.corp.google.com> <1296768812.8299.1644.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011, Dave Hansen wrote:

> > > diff -puN mm/pagewalk.c~pagewalk-dont-always-split-thp mm/pagewalk.c
> > > --- linux-2.6.git/mm/pagewalk.c~pagewalk-dont-always-split-thp	2011-01-27 10:57:02.309914973 -0800
> > > +++ linux-2.6.git-dave/mm/pagewalk.c	2011-01-27 10:57:02.317914965 -0800
> > > @@ -33,19 +33,35 @@ static int walk_pmd_range(pud_t *pud, un
> > >  
> > >  	pmd = pmd_offset(pud, addr);
> > >  	do {
> > > +	again:
> > 
> > checkpatch will warn about the indent.
> > 
> > >  		next = pmd_addr_end(addr, end);
> > > -		split_huge_page_pmd(walk->mm, pmd);
> > > -		if (pmd_none_or_clear_bad(pmd)) {
> > > +		if (pmd_none(*pmd)) {
> > 
> > Not sure why this has been changed from pmd_none_or_clear_bad(), that's 
> > been done even prior to THP.
> 
> The bad check will trigger on huge pmds.  We can not use it here.  We
> can, however, use pmd_none().  The bad check was moved below to where we
> actually dereference the pmd.
> 

Ah, right, thanks.

> > >  			if (walk->pte_hole)
> > >  				err = walk->pte_hole(addr, next, walk);
> > >  			if (err)
> > >  				break;
> > >  			continue;
> > >  		}
> > > +		/*
> > > +		 * This implies that each ->pmd_entry() handler
> > > +		 * needs to know about pmd_trans_huge() pmds
> > > +		 */
> > 
> > Probably needs to be documented somewhere for users of pagewalk?
> 
> Probably, but we don't currently have any central documentation for it.
> Guess we could make some, or just ensure that all the users got updated.
> Any ideas where to put it other than the mm_walk struct?
> 

I think noting it where struct mm_walk is declared would be best (just a 
"/* must handle pmd_trans_huge() */" would be sufficient) although 
eventually it might be cleaner to add a ->pmd_huge_entry().
