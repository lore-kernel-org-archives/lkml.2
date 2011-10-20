Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1JTUFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 16:05:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38434 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1JTUFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 16:05:31 -0400
Message-ID: <1319141125.2854.14.camel@edumazet-laptop>
Subject: Re: Kernel panic from tg3 net driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ari.m.savolainen@gmail.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 20 Oct 2011 22:05:25 +0200
In-Reply-To: <20111020.155659.486754557434415381.davem@davemloft.net>
References: <CAEbykaXz+J8abVzU3yjqZG2+yhHNrQWsQy2c8wNyoERWPpxWKQ@mail.gmail.com>
	 <CAEbykaX4UPDBxOHmNr=dodaquSPjhPr-pLCcUn5hSu4-xLZy-g@mail.gmail.com>
	 <20111020.155659.486754557434415381.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 octobre 2011 à 15:56 -0400, David Miller a écrit :
> From: Ari Savolainen <ari.m.savolainen@gmail.com>
> Date: Thu, 20 Oct 2011 22:30:44 +0300
> 
> > I finally got time to continue bisecting. The commit that causes the
> > kernel panic is:  2669069aacc9 "tg3: enable transmit time stamping."
> 
> I thought initially that the issue might be that we have to do the
> skb_tx_timestamp() call before we advance the mailbox transmit
> descriptor pointer.
> 
> But that shouldn't matter, we run with a lock held, and TX reclaim takes
> that same lock.
> 
> So I'm sort of stumped at the moment.

But its not a panic, its a RCU splat ?

> [  105.612129]  [<ffffffff810ccdcb>] lockdep_rcu_dereference+0xbb/0xc0
> [  105.612132]  [<ffffffff815dc5a9>] neigh_update+0x4f9/0x5f0
> [  105.612135]  [<ffffffff815da001>] ? neigh_lookup+0xe1/0x220
> [  105.612139]  [<ffffffff81639298>] arp_req_set+0xb8/0x230
> [  105.612142]  [<ffffffff8163a59f>] arp_ioctl+0x1bf/0x310
> [  105.612146]  [<ffffffff810baa40>] ? lock_hrtimer_base.isra.26+0x30/0x60
> [  105.612150]  [<ffffffff8163fb75>] inet_ioctl+0x85/0x90
> [  105.612154]  [<ffffffff815b5520>] sock_do_ioctl+0x30/0x70
> [  105.612157]  [<ffffffff815b55d3>] sock_ioctl+0x73/0x280
> [  105.612162]  [<ffffffff811b7698>] do_vfs_ioctl+0x98/0x570
> [  105.612165]  [<ffffffff811a5c40>] ? fget_light+0x340/0x3a0
> [  105.612168]  [<ffffffff811b7bbf>] sys_ioctl+0x4f/0x80
> [  105.612172]  [<ffffffff816fdcab>] system_call_fastpath+0x16/0x1b

And I think this was fixed yesterday ?

De: 	roy.qing.li@gmail.com
À: 	ari.m.savolainen@gmail.com, netdev@vger.kernel.org
Sujet: 	[PATCH net-next] neigh: fix rcu splat in neigh_update()
Date: 	Tue, 18 Oct 2011 16:32:42 +0800 (18/10/2011 10:32:42)


