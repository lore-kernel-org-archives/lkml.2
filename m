Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2FTMGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:06:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60914 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2FTMGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:06:44 -0400
Subject: Re: [PATCH 07/17] net: Introduce sk_gfp_atomic() to allow addition
 of GFP flags depending on the individual socket
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
In-Reply-To: <1340192652-31658-8-git-send-email-mgorman@suse.de>
References: <1340192652-31658-1-git-send-email-mgorman@suse.de>
	 <1340192652-31658-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jun 2012 14:06:39 +0200
Message-ID: <1340193999.4604.867.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 12:44 +0100, Mel Gorman wrote:
> Introduce sk_gfp_atomic(), this function allows to inject sock specific
> flags to each sock related allocation. It is only used on allocation
> paths that may be required for writing pages back to network storage.
> 
> [davem@davemloft.net: Use sk_gfp_atomic only when necessary]
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: David S. Miller <davem@davemloft.net>
> ---
>  include/net/sock.h    |    5 +++++
>  net/ipv4/tcp_output.c |    9 +++++----
>  net/ipv6/tcp_ipv6.c   |    8 +++++---
>  3 files changed, 15 insertions(+), 7 deletions(-)
> 

> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 803cbfe..440b47e 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2461,7 +2461,8 @@ struct sk_buff *tcp_make_synack(struct sock *sk, struct dst_entry *dst,
>  
>  	if (cvp != NULL && cvp->s_data_constant && cvp->s_data_desired)
>  		s_data_desired = cvp->s_data_desired;
> -	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15 + s_data_desired, 1, GFP_ATOMIC);
> +	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15 + s_data_desired, 1,
> +			   sk_gfp_atomic(sk, GFP_ATOMIC));
>  	if (skb == NULL)
>  

This bit no longer applies on net-next, sock_wmalloc() was changed to a
mere alloc_skb()


