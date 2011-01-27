Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1A0NUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:20:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47770 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1A0NUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:20:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ShLt+wVlrJChZ/wV9BMAer1i9qO/TwJBpyXQUzq5KL8k9CsZfNHLXSu/fzkCSpOF1j
         R9eM1Lo0nRHVsrZvn7ww2sD1PQoreS1ymcvSw477Mg2fZmit6jWXacgzL8YCGHiVf0QZ
         fa9OC3aGoYjg+jQ0YTrhx9ZJ1rQazzDWX7TWc=
Subject: Re: [PATCH v2] x25: remove the BKL
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Hendry <andrew.hendry@gmail.com>, linux-kernel@vger.kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <201101271338.39295.arnd@arndb.de>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
	 <AANLkTim=d4Tok-ri1BozZUfBFS=rofaodN8ZBA5AjKKd@mail.gmail.com>
	 <201101271317.01502.arnd@arndb.de>  <201101271338.39295.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 14:20:47 +0100
Message-ID: <1296134447.2614.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 27 janvier 2011 à 13:38 +0100, Arnd Bergmann a écrit :
> diff --git a/net/x25/x25_out.c b/net/x25/x25_out.c
> index d00649f..f1a6ff1 100644
> --- a/net/x25/x25_out.c
> +++ b/net/x25/x25_out.c
> @@ -68,8 +68,11 @@ int x25_output(struct sock *sk, struct sk_buff *skb)
>  		frontlen = skb_headroom(skb);
>  
>  		while (skb->len > 0) {
> -			if ((skbn = sock_alloc_send_skb(sk, frontlen + max_len,
> -							noblock, &err)) == NULL){
> +			release_sock(sk);
> +			skbn = sock_alloc_send_skb(sk, frontlen + max_len,
> +						   1, &err);
> +			lock_sock(sk);
> +			if (!skbn) {
>  				if (err == -EWOULDBLOCK && noblock){
>  					kfree_skb(skb);
>  					return sent;

This part looks strange :

noblock variable became "const 1 : NOBLOCK"

Why releasing socket if you dont block in sock_alloc_send_skb() ?



