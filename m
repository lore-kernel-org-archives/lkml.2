Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2JDRJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:09:36 -0400
Received: from ns.iliad.fr ([212.27.33.1]:32984 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab2JDRJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:09:35 -0400
Message-ID: <1349370573.2532.25.camel@sakura.staff.proxad.net>
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109
 __alloc_pages_nodemask+0x1d4/0x68c()
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Madore <david+ml@madore.org>, Francois Romieu <romieu@fr.zoreil.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Date: Thu, 04 Oct 2012 19:09:33 +0200
In-Reply-To: <1349369406.16011.82.camel@edumazet-glaptop>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net>
	 <alpine.LSU.2.00.1208311900330.1936@eggly.anvils>
	 <1349366521.2532.12.camel@sakura.staff.proxad.net>
	 <1349369406.16011.82.camel@edumazet-glaptop>
Organization: Freebox
Content-Type: text/plain; charset="ANSI_X3.4-1968"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2012-10-04 at 18:50 +0200, Eric Dumazet wrote:

> > Since skb_recycle() resets skb->data using (skb->head + NET_SKB_PAD), a
> > recycled skb going multiple times through a path that needs to expand
> > skb head will get bigger and bigger each time, and you eventually end up
> > with an allocation failure.
> > 
> 
> Because there is not enough headroom ?

yes, on ipv6 forward path the default NET_SKB_PAD is too small, so each
packet forwarded has its headroom expanded, it is then recycled and gets
its original default headroom back, then it gets forwarded,
expanded, ...

> > An idea to fix this would be to pass needed skb size to skb_resize() and
> > set skb->data to MIN(NET_SKB_PAD, (skb->end - skb->head - skb_size) / 2)
> 
> I am trying to decode this but I cant ;)
> 
> What is skb_resize() ?
> and what do you mean setting skb->data to MIN(NET_SKB_PAD, (skb->end -
> skb->head - skb_size) / 2)
> 
> Care to explain again your idea ?

damn typo, I meant skb_recycle(), and my formula is probably wrong.

skb_size is passed to skb_recycle_check() to ensure the skb is at least
that big.

The idea is it to pass the same value to skb_recycle(), allowing it to
set skb->data somewhat at the middle of skb head space (after honoring
NET_SKB_PAD), that way the recycled skb won't have its head expanded
again if it takes the same path.

-- 
Maxime


