Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0KIEUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:20:53 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64778 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab0KIEUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:20:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uOZ/cZUR7RnBnYxOTkgIECjBqNv4tWglBGObA9kXLqVqWofX3PejaF5DrlwTiD6F0G
         hXFp8NjFzZfy10KShgPiKd9htLyUOgPjHIvoWuQXC1HcNrCquHfCqyIWCr0xi5vxInQ7
         0354IKhdzg88HvBB6n+qf3R/tBiHuPS4yIyQ4=
MIME-Version: 1.0
In-Reply-To: <1289250954.2790.11.camel@edumazet-laptop>
References: <AANLkTinVyf4CpxdzEWUn7zTyOrAMKY3H9Dct-HfopiSD@mail.gmail.com>
	<20101108200600.GG4032@linux.vnet.ibm.com>
	<1289248166.2790.1.camel@edumazet-laptop>
	<20101108204240.GA1585@arch.trippelsdorf.de>
	<1289249191.2790.3.camel@edumazet-laptop>
	<20101108205511.GB1585@arch.trippelsdorf.de>
	<1289250954.2790.11.camel@edumazet-laptop>
Date: Mon, 8 Nov 2010 23:20:49 -0500
Message-ID: <AANLkTik6EXFDNw0uJfCSPj8gucQvFi3423kCG+pjS=vJ@mail.gmail.com>
Subject: Re: [PATCH] inet: fix ip_mc_drop_socket()
From: Miles Lane <miles.lane@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Miller <davem@davemloft.net>, paulmck@linux.vnet.ibm.com,
        ilpo.jarvinen@helsinki.fi, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good here.

On Mon, Nov 8, 2010 at 4:15 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Hmm, I believe I found the bug.
>
> Thanks guys !
>
> [PATCH] inet: fix ip_mc_drop_socket()
>
> commit 8723e1b4ad9be4444 (inet: RCU changes in inetdev_by_index())
> forgot one call site in ip_mc_drop_socket()
>
> We should not decrease idev refcount after inetdev_by_index() call,
> since refcount is not increased anymore.
>
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  net/ipv4/igmp.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index c8877c6..3c53c2d 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -2306,10 +2306,8 @@ void ip_mc_drop_socket(struct sock *sk)
>
>                in_dev = inetdev_by_index(net, iml->multi.imr_ifindex);
>                (void) ip_mc_leave_src(sk, iml, in_dev);
> -               if (in_dev != NULL) {
> +               if (in_dev != NULL)
>                        ip_mc_dec_group(in_dev, iml->multi.imr_multiaddr.s_addr);
> -                       in_dev_put(in_dev);
> -               }
>                /* decrease mem now to avoid the memleak warning */
>                atomic_sub(sizeof(*iml), &sk->sk_omem_alloc);
>                call_rcu(&iml->rcu, ip_mc_socklist_reclaim);
>
>
>
