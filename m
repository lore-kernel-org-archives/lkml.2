Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab1JRLhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 07:37:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38511 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab1JRLhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 07:37:39 -0400
Message-ID: <1318937878.2657.50.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga) causes
 kernel oops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Elmar Vonlanthen <evonlanthen@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Timo =?ISO-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>
Date: Tue, 18 Oct 2011 13:37:58 +0200
In-Reply-To: <20111018104504.GA15913@gondor.apana.org.au>
References: <CA+0Zf5Be5JUSvssH9CrDQq=jtETZr=veAPC7jriM8B-FZKbbpg@mail.gmail.com>
	 <1318604266.2223.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+0Zf5A-8X5MaXC4+BbLKtMb8S8B-Ln_a3JNfz0jR4O-ruefuw@mail.gmail.com>
	 <1318905032.2571.35.camel@edumazet-laptop>
	 <20111018093411.GA15165@gondor.apana.org.au>
	 <1318932093.2657.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111018100527.GA15383@gondor.apana.org.au>
	 <1318933423.2657.44.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111018104504.GA15913@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 octobre 2011 à 12:45 +0200, Herbert Xu a écrit :
> On Tue, Oct 18, 2011 at 12:23:43PM +0200, Eric Dumazet wrote:
> > 
> > You're right, if reallocations are OK in all paths.
> 
> If it wasn't OK then making needed_headroom constant won't work
> anyway.
> 
> > We'll need to change LL_RESERVED_SPACE() / LL_RESERVED_SPACE_EXTRA() /
> > LL_ALLOCATED_SPACE() macros and provide the [read once] values, instead
> > of a [read once] pointer to values.
> 
> I'm not sure what you mean here.  I don't see any need to change
> these macros.  All we need is to save the value in a local variable:
> 
> 	hh_len = LL_RESERVED_SPACE(dev);
> 
> 	skb = alloc_skb(hh_len + len);
> 	skb_reserve(skb, hh_len);
> 

Not really Herbert. Please read again my patch changelog.

In the bug we try to fix, we have :

skb = sock_alloc_send_skb(sk, ... + LL_ALLOCATED_SPACE(rt->dst.dev) 

... < increase of dev->needed_headroom by another cpu/task >

skb_reserve(skb, LL_RESERVED_SPACE(rt->dst.dev));

skb_put() -> crash because we reserved too much space

So we really want LL_ALLOCATED_SPACE() and LL_RESERVED_SPACE() use the
same needed_headroom, or else you can have LL_RESERVED_SPACE() >
LL_ALLOCATED_SPACE().

There are several way to fix this, but this kind of code assumed the
dev->needed... values were consistent for the whole block.



