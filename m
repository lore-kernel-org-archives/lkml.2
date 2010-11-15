Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab0KOAt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:49:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64675 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab0KOAtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:49:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DnOP2YbOeaFDwd0Ll6lhC7sn6qdAvyNov0YLlHOsP+GnoYK4in/lVuMfyMqLljeBzJ
         kutZTAVH5jMOE94LqYHKK2m//rtzeFQenqIZDlOBHx3VCutmFX1oBXsbKDHQzJol8JMv
         kBCTfJDB4IkGZuwWDsr8XSeF+C/8fL/E9ZJNo=
Subject: Re: [PATCH] Reduce number of pointer dereferences in IPv4
 netfilter LOG module function dump_packet()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Netfilter Core Team <coreteam@netfilter.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <alpine.LNX.2.00.1011142212310.1253@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011142212310.1253@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 01:49:40 +0100
Message-ID: <1289782180.2743.166.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 novembre 2010 à 22:35 +0100, Jesper Juhl a écrit :
> By adding two pointer variables to 
> net/ipv4/netfilter/ipt_LOG.c::dump_packet() we can save 16 bytes of .text 
> and 9 pointer dereferences.
> 
> before this patch we did 20 pointer dereferences and had this object file 
> size:
>    text    data     bss     dec     hex filename
>    6233     600    3080    9913    26b9 net/ipv4/netfilter/ipt_LOG.o
> 
> after this patch we do just 11 pointer dereferences and have this object 
> file size:
>    text    data     bss     dec     hex filename
>    6217     600    3080    9897    26a9 net/ipv4/netfilter/ipt_LOG.o
> 
> 
> Please Cc me on replies.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  ipt_LOG.c |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
> index 72ffc8f..02a92de 100644
> --- a/net/ipv4/netfilter/ipt_LOG.c
> +++ b/net/ipv4/netfilter/ipt_LOG.c
> @@ -39,6 +39,8 @@ static void dump_packet(struct sbuff *m,
>  	struct iphdr _iph;
>  	const struct iphdr *ih;
>  	unsigned int logflags;
> +	struct sock *sk;
> +	struct socket *sk_socket;
>  
>  	if (info->type == NF_LOG_TYPE_LOG)
>  		logflags = info->u.log.logflags;
> @@ -335,13 +337,15 @@ static void dump_packet(struct sbuff *m,
>  	}
>  
>  	/* Max length: 15 "UID=4294967295 " */
> -	if ((logflags & IPT_LOG_UID) && !iphoff && skb->sk) {
> -		read_lock_bh(&skb->sk->sk_callback_lock);
> -		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
> +	sk = skb->sk;
> +	sk_socket = sk->sk_socket;

Really ? sk can be NULL, so you add a NULL dereference.

> +	if ((logflags & IPT_LOG_UID) && !iphoff && sk) {
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

Most of these "dereferences" are compiler optimized.

You added a bug in your patch, and make ipt_LOG slower if rule is not
asking for IPT_LOG_UID



