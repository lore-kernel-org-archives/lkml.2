Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1AQJeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 04:34:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63654 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AQJdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 04:33:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LZOZcGbuDqolGlWwrBxCsa4FSp8oKvYjG4jM8O0d7n0kdMikhhVdDXFtxjTXKzhDjr
         7nyuLLErJIoHzuN6YPXPwYiyRepYKw0O/qtMAhurZPAArMNUn7g5rslo97ylnonXudKz
         XJuKs8qJm1jENJ85fnk4s7LG34s7S+yrTmsbY=
Subject: Re: [PATCH 3/3] vhost-net: use lock_sock_fast() in peek_head_len()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.osdl.org, netdev@vger.kernel.org, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110117081117.18900.48672.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
References: <20110117081058.18900.67456.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
	 <20110117081117.18900.48672.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 10:33:48 +0100
Message-ID: <1295256828.3335.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 17 janvier 2011 à 16:11 +0800, Jason Wang a écrit :
> We can use lock_sock_fast() instead of lock_sock() in order to get
> speedup in peek_head_len().
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/net.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c32a2e4..50b622a 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -211,12 +211,12 @@ static int peek_head_len(struct sock *sk)
>  {
>  	struct sk_buff *head;
>  	int len = 0;
> +	bool slow = lock_sock_fast(sk);
>  
> -	lock_sock(sk);
>  	head = skb_peek(&sk->sk_receive_queue);
>  	if (head)
>  		len = head->len;
> -	release_sock(sk);
> +	unlock_sock_fast(sk, slow);
>  	return len;
>  }
>  
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


