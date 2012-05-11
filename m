Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab2EKEuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:50:05 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57099 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2EKEuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:50:03 -0400
Date: Fri, 11 May 2012 00:49:49 -0400 (EDT)
Message-Id: <20120511.004949.655300373402132371.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 08/17] net: Introduce sk_allocation() to allow addition
 of GFP flags depending on the individual socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336657510-24378-9-git-send-email-mgorman@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
	<1336657510-24378-9-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 21:49:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 10 May 2012 14:45:01 +0100

> Introduce sk_allocation(), this function allows to inject sock specific
> flags to each sock related allocation. It is only used on allocation
> paths that may be required for writing pages back to network storage.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

This is still a little bit more than it needs to be.

You are trying to propagate a single bit from sk->sk_allocation into
all of the annotated socket memory allocation sites.

But many of them use sk->sk_allocation already.  In fact all of them
that use a variable rather than a constant GFP_* satisfy this
invariant.

All of those annotations are therefore spurious, and probably end up
generating unnecessary |'s in of that special bit in at least some
cases.

What you really, therefore, care about are the GFP_FOO cases.  And in
fact those are all GFP_ATOMIC.  So make something that says what it
is that you want, a GFP_ATOMIC with some socket specified bits |'d
in.

Something like this:

static inline gfp_t sk_gfp_atomic(struct sock *sk)
{
	return GFP_ATOMIC | (sk->sk_allocation & __GFP_MEMALLOC);
}

You'll also have to make your networking patches conform to the
networking subsystem coding style.

For example:

> -	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15 + s_data_desired, 1, GFP_ATOMIC);
> +	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15 + s_data_desired, 1,
> +					sk_allocation(sk, GFP_ATOMIC));

The sk_allocation() argument has to line up with the first column
after the openning parenthesis of the function call.  You can't just
use all TAB characters.  And this all TABs thing looks extremely ugly
to boot.

> -		newnp->pktoptions = skb_clone(treq->pktopts, GFP_ATOMIC);
> +		newnp->pktoptions = skb_clone(treq->pktopts,
> +						sk_allocation(sk, GFP_ATOMIC));

Same here.

What's really funny to me is that in several cases elsewhere in this
pach you get it right.
