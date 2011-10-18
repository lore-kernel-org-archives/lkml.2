Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab1JRCaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 22:30:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48950 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab1JRCah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 22:30:37 -0400
Message-ID: <1318905032.2571.35.camel@edumazet-laptop>
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga) causes
 kernel oops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Elmar Vonlanthen <evonlanthen@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Timo =?ISO-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Tue, 18 Oct 2011 04:30:32 +0200
In-Reply-To: <CA+0Zf5A-8X5MaXC4+BbLKtMb8S8B-Ln_a3JNfz0jR4O-ruefuw@mail.gmail.com>
References: <CA+0Zf5Be5JUSvssH9CrDQq=jtETZr=veAPC7jriM8B-FZKbbpg@mail.gmail.com>
	 <1318604266.2223.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+0Zf5A-8X5MaXC4+BbLKtMb8S8B-Ln_a3JNfz0jR4O-ruefuw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 17 octobre 2011 à 09:16 +0200, Elmar Vonlanthen a écrit :
> 2011/10/14 Eric Dumazet <eric.dumazet@gmail.com>:
> > Please try following patch :
> >
> > [PATCH] ip_gre: dont increase dev->needed_headroom on a live device
> >
> > It seems ip_gre is able to change dev->needed_headroom on the fly.
> >
> > Its is not legal unfortunately and triggers a BUG in raw_sendmsg()
> >
> > skb = sock_alloc_send_skb(sk, ... + LL_ALLOCATED_SPACE(rt->dst.dev)
> >
> > < another cpu change dev->needed_headromm (making it bigger)
> >
> > ...
> > skb_reserve(skb, LL_RESERVED_SPACE(rt->dst.dev));
> >
> > We end with LL_RESERVED_SPACE() being bigger than LL_ALLOCATED_SPACE()
> > -> we crash later because skb head is exhausted.
> >
> > Bug introduced in commit 243aad83 in 2.6.34 (ip_gre: include route
> > header_len in max_headroom calculation)
> >
> > Reported-by: Elmar Vonlanthen <evonlanthen@gmail.com>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > CC: Timo Teräs <timo.teras@iki.fi>
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
> > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > index 8871067..1505dcf 100644
> > --- a/net/ipv4/ip_gre.c
> > +++ b/net/ipv4/ip_gre.c
> > @@ -835,8 +835,6 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
> >        if (skb_headroom(skb) < max_headroom || skb_shared(skb)||
> >            (skb_cloned(skb) && !skb_clone_writable(skb, 0))) {
> >                struct sk_buff *new_skb = skb_realloc_headroom(skb, max_headroom);
> > -               if (max_headroom > dev->needed_headroom)
> > -                       dev->needed_headroom = max_headroom;
> >                if (!new_skb) {
> >                        ip_rt_put(rt);
> >                        dev->stats.tx_dropped++;
> 
> Hello
> 
> I tried this patch and I was not able anymore to reproduce the kernel
> oops. So the patch solved the bug.
> Thank you very much!
> 
> Would it be possible to add the patch to the long term kernel 2.6.35
> as well? Because this is the one I use at the moment in production.
> 

Thanks for testing.

If David/Herbert/Timo agree, then patch should find its way into current
kernel, then to stable trees as well.

Thanks


