Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab0HQSCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:02:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34429 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0HQSCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:02:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=iOrn3rIOZxhjaxyQ02oXAtbdUD3Tw+NfO3fiHcYSnK9rxnjYVJZcjXkRITGq3skR7
	fmSZeMHOLV19OWPeVcXOQ==
Date: Tue, 17 Aug 2010 11:02:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <alpine.DEB.2.00.1008171217440.11915@router.home>
Message-ID: <alpine.DEB.2.00.1008171052500.6486@chino.kir.corp.google.com>
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com> <alpine.DEB.2.00.1008041115500.11084@router.home> <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com> <alpine.DEB.2.00.1008051231400.6787@router.home>
 <alpine.DEB.2.00.1008151627450.27137@chino.kir.corp.google.com> <alpine.DEB.2.00.1008171217440.11915@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Christoph Lameter wrote:

> > Ok, so this is panicking because of the error handling when trying to
> > create sysfs directories with the same name (in this case, :dt-0000064).
> > I'll look into while this isn't failing gracefully later, but I isolated
> > this to the new code that statically allocates the DMA caches in
> > kmem_cache_init_late().
> 
> Hmm.... Strange. The DMA caches should create a distinct pattern there.
> 

They do after patch 11 when you introduce dynamically sized kmalloc 
caches, but not after only patches 1-8 were applied.  Since this wasn't 
booting on my system, I bisected the problem to patch 8 where 
kmem_cache_init_late() would create two DMA caches of size 64 bytes: one 
becauses of kmalloc_caches[0] (kmem_cache_node) and one because of 
kmalloc_caches[6] (2^6 = 64).  So my fixes are necessary for patch 8 but 
obsoleted later, and then the shared cache support panics on memset().

> >  - the entire iteration in kmem_cache_init_late() needs to be protected by
> >    slub_lock.  The comment in create_kmalloc_cache() should be revised
> >    since you're no longer calling it only with irqs disabled.
> >    kmem_cache_init_late() has irqs enabled and, thus, slab_caches must be
> >    protected.
> 
> I moved it to kmem_cache_init() which is run when we only have one
> execution thread. That takes care of the issue and ensures that the dma
> caches are available as early as before.
> 

I didn't know if that was a debugging patch for me or if you wanted to 
push that as part of your series, I'm not sure if you actually need to 
move it to kmem_cache_init() now that slub_state is protected by 
slub_lock.  I'm not sure if we want to allocate DMA objects between 
kmem_cache_init() and kmem_cache_init_late().
