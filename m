Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0KOAub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:50:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47758 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab0KOAu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HE39f+a+q4u9ZGSL78L5bdX5v88qO+KifYcjbxUoPOR3kzkvMVZWpP4c4tm4vteYqi
         K7IZ5dgLWxdIPhtLEAAT9qaWdPtlpg5r5OMoN5YJQkGt3DfaPrHAYLTU19Rbq6hECv7K
         lO9idHtnH84mRXeMpNzu9FOJZCDvBGbhACugo=
Subject: Re: [PATCH] Reduce number of pointer dereferences in IPv6
 netfilter LOG module function dump_packet()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Netfilter Core Team <coreteam@netfilter.org>,
        Jan Rekorajski <baggins@pld.org.pl>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011142241260.1253@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011142241260.1253@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 01:50:15 +0100
Message-ID: <1289782215.2743.167.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 novembre 2010 à 22:47 +0100, Jesper Juhl a écrit :
> By adding two pointer variables to 
> net/ipv6/netfilter/ip6t_LOG.c::dump_packet() we can save 19 bytes of .text 
> and many pointer dereferences.
> 
> before:
>    text    data     bss     dec     hex filename
>    6258     600    3088    9946    26da net/ipv6/netfilter/ip6t_LOG.o
> 
> after:
>    text    data     bss     dec     hex filename
>    6239     600    3088    9927    26c7 net/ipv6/netfilter/ip6t_LOG.o
> 
> 
> Please Cc me on replies.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  ip6t_LOG.c |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
> index 09c8889..51d10a5 100644
> --- a/net/ipv6/netfilter/ip6t_LOG.c
> +++ b/net/ipv6/netfilter/ip6t_LOG.c
> @@ -46,6 +46,8 @@ static void dump_packet(struct sbuff *m,
>  	unsigned int ptr;
>  	unsigned int hdrlen = 0;
>  	unsigned int logflags;
> +	struct sock *sk;
> +	struct socket *sk_socket;
>  
>  	if (info->type == NF_LOG_TYPE_LOG)
>  		logflags = info->u.log.logflags;
> @@ -358,13 +360,15 @@ static void dump_packet(struct sbuff *m,
>  	}
>  
>  	/* Max length: 15 "UID=4294967295 " */
> -	if ((logflags & IP6T_LOG_UID) && recurse && skb->sk) {
> -		read_lock_bh(&skb->sk->sk_callback_lock);
> -		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
> +	sk = skb->sk;
> +	sk_socket = sk->sk_socket;
> +	if ((logflags & IP6T_LOG_UID) && recurse && sk) {
> +		read_lock_bh(&sk->sk_callback_lock);
> +		if (sk_socket && sk_socket->file)
>  			sb_add(m, "UID=%u GID=%u ",
> -				skb->sk->sk_socket->file->f_cred->fsuid,
> -				skb->sk->sk_socket->file->f_cred->fsgid);
> -		read_unlock_bh(&skb->sk->sk_callback_lock);
> +				sk_socket->file->f_cred->fsuid,
> +				sk_socket->file->f_cred->fsgid);
> +		read_unlock_bh(&sk->sk_callback_lock);
>  	}
>  
>  	/* Max length: 16 "MARK=0xFFFFFFFF " */
> 
> 
> 

Same comment than previous patch, you add a NULL dereference.



