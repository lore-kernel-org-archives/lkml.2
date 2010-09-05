Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0IEWzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 18:55:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15725 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab0IEWzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 18:55:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fIkPvKMMdhWFe5+c1qHRn42+YiZicT8BBMzuvAjSMrJuykhnfH8TOPoOGV/1LSId+
	oz3a2PbrHHNg+ji0nthsQ==
Date: Sun, 5 Sep 2010 15:55:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <aia21@cantab.net>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch v2 5/5] ntfs: remove dependency on __GFP_NOFAIL
In-Reply-To: <A326B3E1-DB22-4C25-9ED5-C6A5F25BF15E@cam.ac.uk>
Message-ID: <alpine.DEB.2.00.1009051548570.5003@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011801050.24694@chino.kir.corp.google.com> <A326B3E1-DB22-4C25-9ED5-C6A5F25BF15E@cam.ac.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Anton Altaparmakov wrote:

> > @@ -76,11 +76,19 @@ static inline void *ntfs_malloc_nofs(unsigned long size)
> >  * This function guarantees that the allocation will succeed.  It will sleep
> >  * for as long as it takes to complete the allocation.
> >  *
> > - * If there was insufficient memory to complete the request, return NULL.
> > + * NOTE: no new callers of this function should be implemented!
> > + * All memory allocations should be failable whenever possible.
> >  */
> > static inline void *ntfs_malloc_nofs_nofail(unsigned long size)
> > {
> > -	return __ntfs_malloc(size, GFP_NOFS | __GFP_HIGHMEM | __GFP_NOFAIL);
> > +	void *ret;
> > +
> > +	for (;;) {
> > +		ret = ntfs_malloc_nofs(size);
> > +		if (ret)
> > +			return ret;
> > +		WARN_ON_ONCE(get_order(size) > PAGE_ALLOC_COSTLY_ORDER);
> 
> What is the relevance of the above get_order check?  ntfs_malloc_nofs() 
> does a vmalloc() if size >= PAGE_SIZE so I cannot see how that has 
> anything to do with get_order()?
> 

It probably shouldn't be doing vmalloc() for size == PAGE_SIZE, but I can 
understand how it would use it for higher order allocations.  I didn't 
look at that specifically because I assumed these were going through the 
page allocator (and no current user should have any order less than 
PAGE_ALLOC_COSTLY_ORDER, correct me if I'm wrong).

I'm pretty sure we want some sort of warning emitted once if this has the 
potential to loop forever, so it should probably be changed to WARN_ONCE() 
in this patch only.  Thanks for pointing that out.

> Other than that patch looks fine.
> 
> Note the _nofail function is only called from one place and there will 
> be no more call sites for it.  One day we ought to work something out so 
> it is not needed at all but given it only gets called in very obscure 
> circumstances (definitely not in the general code paths) it shouldn't 
> matter too much...
> 

That would be great!
