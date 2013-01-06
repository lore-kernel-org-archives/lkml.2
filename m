Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3AFRfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 12:35:53 -0500
Received: from 1wt.eu ([62.212.114.60]:37708 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab3AFRfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 12:35:50 -0500
Date: Sun, 6 Jan 2013 18:35:43 +0100
From: Willy Tarreau <w@1wt.eu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Major network performance regression in 3.7
Message-ID: <20130106173543.GB22432@1wt.eu>
References: <1357437086.1678.5135.camel@edumazet-glaptop> <1357438591.1678.5205.camel@edumazet-glaptop> <20130106025256.GY16031@1wt.eu> <1357457724.1678.5941.camel@edumazet-glaptop> <20130106092435.GZ16031@1wt.eu> <1357484342.6919.61.camel@edumazet-glaptop> <20130106155123.GB16031@1wt.eu> <1357490393.6919.267.camel@edumazet-glaptop> <20130106164416.GF16031@1wt.eu> <1357492255.6919.336.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357492255.6919.336.camel@edumazet-glaptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 09:10:55AM -0800, Eric Dumazet wrote:
> On Sun, 2013-01-06 at 17:44 +0100, Willy Tarreau wrote:
> > On Sun, Jan 06, 2013 at 08:39:53AM -0800, Eric Dumazet wrote:
> > > Hmm, I'll have to check if this really can be reverted without hurting
> > > vmsplice() again.
> > 
> > Looking at the code I've been wondering whether we shouldn't transform
> > the condition to perform the push if we can't push more segments, but
> > I don't know what to rely on. It would be something like this :
> > 
> >        if (copied &&
> >           (!(flags & MSG_SENDPAGE_NOTLAST) || cant_push_more))
> >                 tcp_push(sk, flags, mss_now, tp->nonagle);
> 
> Good point !
> 
> Maybe the following fix then ?
> 
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 1ca2536..7ba0717 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -941,8 +941,10 @@ out:
>  	return copied;
>  
>  do_error:
> -	if (copied)
> +	if (copied) {
> +		flags &= ~MSG_SENDPAGE_NOTLAST;
>  		goto out;
> +	}
>  out_err:
>  	return sk_stream_error(sk, flags, err);
>  }

Unfortunately it does not work any better, which means to me
that we don't leave via this code path. I tried other tricks
which failed too. I need to understand this part better before
randomly fiddling with it.

Willy

