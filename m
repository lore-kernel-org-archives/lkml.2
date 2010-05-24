Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0EXGX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:23:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:36654 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab0EXGX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:23:56 -0400
Date: Mon, 24 May 2010 16:23:48 +1000
From: Nick Piggin <npiggin@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cache last free vmap_area to avoid restarting beginning
Message-ID: <20100524062347.GS2516@laptop>
References: <1271350270.2013.29.camel@barrios-desktop>
 <1271427056.7196.163.camel@localhost.localdomain>
 <1271603649.2100.122.camel@barrios-desktop>
 <1271681929.7196.175.camel@localhost.localdomain>
 <h2g28c262361004190712v131bf7a3q2a82fd1168faeefe@mail.gmail.com>
 <1272548602.7196.371.camel@localhost.localdomain>
 <1272821394.2100.224.camel@barrios-desktop>
 <1273063728.7196.385.camel@localhost.localdomain>
 <20100505161632.GB5378@laptop>
 <1274522033.1953.21.camel@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274522033.1953.21.camel@barrios-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 06:53:53PM +0900, Minchan Kim wrote:
> Hi, Nick.
> Sorry for late review. 

No problem, thanks for reviewing.

 
> On Thu, 2010-05-06 at 02:16 +1000, Nick Piggin wrote:
> > On Wed, May 05, 2010 at 01:48:48PM +0100, Steven Whitehouse wrote:
> > @@ -348,11 +354,23 @@ retry:
> >  	if (addr + size - 1 < addr)
> >  		goto overflow;
> >  
> > -	/* XXX: could have a last_hole cache */
> > -	n = vmap_area_root.rb_node;
> > -	if (n) {
> > -		struct vmap_area *first = NULL;
> > +	if (size <= cached_hole_size || addr < cached_start || !free_vmap_cache) {
> 
> Do we need !free_vmap_cache check?
> In __free_vmap_area, we already reset whole of variables when free_vmap_cache = NULL.

You're right.


> > +		cached_hole_size = 0;
> > +		cached_start = addr;
> > +		free_vmap_cache = NULL;
> > +	}
> >  
> > +	/* find starting point for our search */
> > +	if (free_vmap_cache) {
> > +		first = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
> > +		addr = ALIGN(first->va_end + PAGE_SIZE, align);
> > +
> > +	} else {
> > +		n = vmap_area_root.rb_node;
> > +		if (!n)
> > +			goto found;
> > +
> > +		first = NULL;
> >  		do {
> >  			struct vmap_area *tmp;
> >  			tmp = rb_entry(n, struct vmap_area, rb_node);
> > @@ -369,26 +387,36 @@ retry:
> >  		if (!first)
> >  			goto found;
> >  
> > -		if (first->va_end < addr) {
> > +		if (first->va_start < addr) {
> 
> I can't understand your intention.
> Why do you change va_end with va_start?

Because we don't want an area which is spanning the start address. And
it makes subsequent logic simpler.

 
> > +			BUG_ON(first->va_end < addr);
> 
> And Why do you put this BUG_ON in here?
> Could you elaborate on logic?

It seems this is wrong, so I've removed it. This is the BUG that
Steven hit, but there is another bug in there that my stress tester
wasn't triggering.

> 
> >  			n = rb_next(&first->rb_node);
> > +			addr = ALIGN(first->va_end + PAGE_SIZE, align);
> >  			if (n)
> >  				first = rb_entry(n, struct vmap_area, rb_node);
> >  			else
> >  				goto found;
> >  		}
> > +		BUG_ON(first->va_start < addr);
> 
> Ditto. 

Don't want an area spanning start address, as above.


> >  	rb_erase(&va->rb_node, &vmap_area_root);
> >  	RB_CLEAR_NODE(&va->rb_node);
> >  	list_del_rcu(&va->list);
> 
> Hmm. I will send refactoring version soon. 
> If you don't mind, let's discuss in there. :)

I just reworked the initial patch a little bit and fixed a bug in it,
if we could instead do the refactoring on top of it, that would save
me having to rediff?

I'll post it shortly.

Thanks,
Nick
