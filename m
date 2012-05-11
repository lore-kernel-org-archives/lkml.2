Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129Ab2EKOMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:12:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759976Ab2EKOMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:12:38 -0400
Date: Fri, 11 May 2012 15:12:32 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 08/17] net: Introduce sk_allocation() to allow addition
 of GFP flags depending on the individual socket
Message-ID: <20120511141232.GR11435@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
 <1336657510-24378-9-git-send-email-mgorman@suse.de>
 <20120511.004949.655300373402132371.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120511.004949.655300373402132371.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 12:49:49AM -0400, David Miller wrote:
> From: Mel Gorman <mgorman@suse.de>
> Date: Thu, 10 May 2012 14:45:01 +0100
> 
> > Introduce sk_allocation(), this function allows to inject sock specific
> > flags to each sock related allocation. It is only used on allocation
> > paths that may be required for writing pages back to network storage.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> This is still a little bit more than it needs to be.
> 
> You are trying to propagate a single bit from sk->sk_allocation into
> all of the annotated socket memory allocation sites.
> 
> But many of them use sk->sk_allocation already.  In fact all of them
> that use a variable rather than a constant GFP_* satisfy this
> invariant.
> 
> All of those annotations are therefore spurious, and probably end up
> generating unnecessary |'s in of that special bit in at least some
> cases.
> 

Yes, you're completely correct here.

> What you really, therefore, care about are the GFP_FOO cases.  And in
> fact those are all GFP_ATOMIC.  So make something that says what it
> is that you want, a GFP_ATOMIC with some socket specified bits |'d
> in.
> 
> Something like this:
> 
> static inline gfp_t sk_gfp_atomic(struct sock *sk)
> {
> 	return GFP_ATOMIC | (sk->sk_allocation & __GFP_MEMALLOC);
> }
> 

I went with this.

> You'll also have to make your networking patches conform to the
> networking subsystem coding style.
> 
> For example:
> 
> > -	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15 + s_data_desired, 1, GFP_ATOMIC);
> > +	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15 + s_data_desired, 1,
> > +					sk_allocation(sk, GFP_ATOMIC));
> 
> The sk_allocation() argument has to line up with the first column
> after the openning parenthesis of the function call.  You can't just
> use all TAB characters.  And this all TABs thing looks extremely ugly
> to boot.
> 

I was not aware of the networking subsystem coding style. I'll fix it
up.

> > -		newnp->pktoptions = skb_clone(treq->pktopts, GFP_ATOMIC);
> > +		newnp->pktoptions = skb_clone(treq->pktopts,
> > +						sk_allocation(sk, GFP_ATOMIC));
> 
> Same here.
> 
> What's really funny to me is that in several cases elsewhere in this
> pach you get it right.

Whether I got it right or not would be effectively random. I tried
myself to see what pattern I was using thinking it would be "always"
tab but nope, no pattern :)

-- 
Mel Gorman
SUSE Labs
