Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab2EIIQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:16:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61306 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2EIIQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:16:28 -0400
Date: Wed, 9 May 2012 03:16:17 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Vijay Subramanian <subramanian.vijay@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 074/167] [PATCH 14/26] tcp: fix tcp_trim_head()
Message-ID: <20120509081617.GD32230@burratino>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055040.099618905@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509055040.099618905@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
[...]
> [ Upstream commit 4fa48bf3c75069d636fc8830743c929a062e80dc ]
>
> commit f07d960df3 (tcp: avoid frag allocation for small frames)
> breaked assumption in tcp stack that skb is either linear (skb->data_len
> == 0), or fully fragged (skb->data_len == skb->len)
>
> tcp_trim_head() made this assumption, we must fix it.

Is this needed in the context of 3.2.y (which does not include
f07d960df3)?

Curious,
Jonathan

> Thanks to Vijay for providing a very detailed explanation.
>
> Reported-by: Vijay Subramanian <subramanian.vijay@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  net/ipv4/tcp_output.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 097e0c7..7413437 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1093,6 +1093,13 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
>  {
>  	int i, k, eat;
>  
> +	eat = min_t(int, len, skb_headlen(skb));
> +	if (eat) {
> +		__skb_pull(skb, eat);
> +		len -= eat;
> +		if (!len)
> +			return;
> +	}
>  	eat = len;
>  	k = 0;
>  	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
> @@ -1124,11 +1131,7 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
>  	if (skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
>  		return -ENOMEM;
>  
> -	/* If len == headlen, we avoid __skb_pull to preserve alignment. */
> -	if (unlikely(len < skb_headlen(skb)))
> -		__skb_pull(skb, len);
> -	else
> -		__pskb_trim_head(skb, len - skb_headlen(skb));
> +	__pskb_trim_head(skb, len);
>  
>  	TCP_SKB_CB(skb)->seq += len;
>  	skb->ip_summed = CHECKSUM_PARTIAL;
> -- 
> 1.7.10
