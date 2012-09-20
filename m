Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2ITVsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:48:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39701 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2ITVs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:48:29 -0400
Date: Thu, 20 Sep 2012 17:48:27 -0400 (EDT)
Message-Id: <20120920.174827.1245530945282009606.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: use a per task frag allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348073761.26523.1095.camel@edumazet-glaptop>
References: <1348073761.26523.1095.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 19 Sep 2012 18:56:01 +0200

> From: Eric Dumazet <edumazet@google.com>
> 
> We currently use a per socket page reserve for tcp_sendmsg() operations.
> 
> This page is used to build fragments for skbs.
> 
> Its done to increase probability of coalescing small write() into
> single segments in skbs still in write queue (not yet sent)
> 
> But it wastes a lot of memory for applications handling many mostly
> idle sockets, since each socket holds one page in sk->sk_sndmsg_page
> 
> Its also quite inefficient to build TSO packets of 64KB, because we need
> about 16 pages per skb on arches where PAGE_SIZE = 4096, so we hit
> page allocator more than wanted.
> 
> This patch switches this frag allocator from socket to task structure,
> and uses bigger pages.
> 
> (up to 32768 bytes per frag, thats order-3 pages on x86)
> 
> This increases TCP stream performance by 20% on loopback device,
> but also benefits on other network devices, since 8x less frags are
> mapped on transmit and unmapped on tx completion.
> 
> Its possible some TSO enabled hardware cant cope with bigger fragments,
> but their ndo_start_xmit() should already handle this, splitting a
> fragment in sub fragments, since some arches have PAGE_SIZE=65536
> 
> Successfully tested on various ethernet devices.
> (ixgbe, igb, bnx2x, tg3, mellanox mlx4)
> 
> Followup patches can use this infrastructure in two other spots
> and get rid of the socket sk_sndmsg_page.
> 
> Open for discussion : Should we fallback to smaller pages
> if order-3 page allocations fail ?
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

I like this a lot and I look forward to your upcoming changes to
convert the other two sk_sndmsg_page users as well, but I can't
apply this to net-next just yet.

The question on fallback is a good one and something we have
to resolve before applying this.

Note in particular that sk_allocation can be set to just about
anything, and this also has potential interaction issues with
SOCK_MEMALLOC.
