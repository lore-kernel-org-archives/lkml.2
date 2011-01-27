Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1A0NoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:44:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1A0NoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:44:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] x25: remove the BKL
Date: Thu, 27 Jan 2011 14:43:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Hendry <andrew.hendry@gmail.com>, linux-kernel@vger.kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <201101271338.39295.arnd@arndb.de> <1296134447.2614.5.camel@edumazet-laptop>
In-Reply-To: <1296134447.2614.5.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201101271443.40007.arnd@arndb.de>
X-Provags-ID: V02:K0:b9CqMmCAGvJnXhLh5ts722S0EHrl7pHu9dDbMmT3uPn
 QIoGlIJVpc2YOmJs6R9g8lhH/MxmqRoml/LFr5VdZwUH4UF5rF
 g2UN1JTomyshtYKpKrybGPkTAfJWAtvqS2GHssvB0Evr19NFoz
 oy9I9nrAi6AdAwJyDJwNVcqENYxAmXbKW2WdQ5XGTYivZ/OSO9
 fRcW2SxJyhSZ8Nfmhgdag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 January 2011, Eric Dumazet wrote:
> Le jeudi 27 janvier 2011 à 13:38 +0100, Arnd Bergmann a écrit :
> > diff --git a/net/x25/x25_out.c b/net/x25/x25_out.c
> > index d00649f..f1a6ff1 100644
> > --- a/net/x25/x25_out.c
> > +++ b/net/x25/x25_out.c
> > @@ -68,8 +68,11 @@ int x25_output(struct sock *sk, struct sk_buff *skb)
> >               frontlen = skb_headroom(skb);
> >  
> >               while (skb->len > 0) {
> > -                     if ((skbn = sock_alloc_send_skb(sk, frontlen + max_len,
> > -                                                     noblock, &err)) == NULL){
> > +                     release_sock(sk);
> > +                     skbn = sock_alloc_send_skb(sk, frontlen + max_len,
> > +                                                1, &err);
> > +                     lock_sock(sk);
> > +                     if (!skbn) {
> >                               if (err == -EWOULDBLOCK && noblock){
> >                                       kfree_skb(skb);
> >                                       return sent;
> 
> This part looks strange :
> 
> noblock variable became "const 1 : NOBLOCK"
> 
> Why releasing socket if you dont block in sock_alloc_send_skb() ?

Leftover from an earlier version of the patch, thanks for catching this!

Originally, I wrote this as

	long timeo = sock_sndtimeo(sk, noblock)
	do {
		skbn = sock_alloc_send_skb(sk, frontlen + max_len, 1, &err);
		if (skbn)
			break;

		release_sock(sk);
		timeo = sock_wait_for_wmem(sk, timeo);
		lock_sock(sk);
	} while (timeo);

Then I forgot to flip it back after I noticed that other protocols also just
call release_sock/lock_sock around sock_alloc_send_skb.

I think I'd better go over the whole series and see if there are more things
that got slightly broken...

	Arnd
