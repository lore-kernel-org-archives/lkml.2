Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0IUJVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:21:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0IUJVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iTTEMBEruvcaYAb4ykBn6YxYJzs5rrEWxrHCbtQEPMKXOQ4/gyWAoDpKJKBuNG1VHD
         24TCPGkEsy49ZUG4fR8RRSq/UNUYDzct7tAkLMiTX24CJRYT0N8aZVvQNR42EzHXvqil
         nTHEu8GXxtDfnnQt1S5ss2ISwYOo+2VB7Dros=
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100921091248.GA8424@ff.dom.local>
References: <20100921091248.GA8424@ff.dom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 11:21:00 +0200
Message-ID: <1285060860.2617.158.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 21 septembre 2010 à 09:12 +0000, Jarek Poplawski a écrit :
> On 2010-09-20 23:31, Eric Dumazet wrote:
> ...
> > [PATCH] ip : fix truesize mismatch in ip fragmentation
> > 
> > We should not set frag->destructor to sock_wkfree() until we are sure we
> > dont hit slow path in ip_fragment(). Or we risk uncharging
> > frag->truesize twice, and in the end, having negative socket
> > sk_wmem_alloc counter, or even freeing socket sooner than expected.
> > 
> > Many thanks to Nick Bowler, who provided a very clean bug report and
> > test programs.
> > 
> > While Nick bisection pointed to commit 2b85a34e911bf483 (net: No more
> > expensive sock_hold()/sock_put() on each tx), underlying bug is older.
> > 
> > Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> >  net/ipv4/ip_output.c  |    8 ++++----
> >  net/ipv6/ip6_output.c |   10 +++++-----
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index 04b6989..126d9b3 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -490,7 +490,6 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
> >  	if (skb_has_frags(skb)) {
> >  		struct sk_buff *frag;
> >  		int first_len = skb_pagelen(skb);
> > -		int truesizes = 0;
> >  
> >  		if (first_len - hlen > mtu ||
> >  		    ((first_len - hlen) & 7) ||
> > @@ -510,11 +509,13 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
> >  				goto slow_path;
> >  
> >  			BUG_ON(frag->sk);
> > -			if (skb->sk) {
> > +		}
> > +		if (skb->sk) {
> > +			skb_walk_frags(skb, frag) {
> >  				frag->sk = skb->sk;
> >  				frag->destructor = sock_wfree;
> 
> Nice catch, but it seems doing it in the first loop as now, and
> reverting changes before goto slow_path might be more optimal here.
> 

I thought of this, but found this function already very complex.

Once everything is in cpu caches, the added loop is very cheap.

I liked the :

<check everything without changing state>
if something wrong
	goto slow_path
else
	<OK, lets do destructive things>


