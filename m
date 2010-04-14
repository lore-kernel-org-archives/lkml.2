Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0DNLzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 07:55:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38578
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755189Ab0DNLzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 07:55:04 -0400
Date: Wed, 14 Apr 2010 04:55:06 -0700 (PDT)
Message-Id: <20100414.045506.52212061.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: eric.dumazet@gmail.com, mst@redhat.com, jan.kiszka@siemens.com,
       paul.moore@hp.com, David.Woodhouse@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH] tun: orphan an skb on tx
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100414005822.GD18044@gondor.apana.org.au>
References: <20100413173919.GC26011@redhat.com>
	<1271183463.16881.545.camel@edumazet-laptop>
	<20100414005822.GD18044@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 14 Apr 2010 08:58:22 +0800

> On Tue, Apr 13, 2010 at 08:31:03PM +0200, Eric Dumazet wrote:
>>
>> Herbert Acked your patch, so I guess its OK, but I think it can be
>> dangerous.
> 
> The tun socket accounting was never designed to stop it from
> flooding another tun interface.  It's there to stop it from
> transmitting above a destination interface TX bandwidth and
> cause unnecessary packet drops.  It also limits the total amount
> of kernel memory that can be pinned down by a single tun interface.
> 
> In this case, all we're doing is shifting the accounting from the
> "hardware" queue to the qdisc queue.
> 
> So your ability to flood a tun interface is essentially unchanged.
> 
> BTW we do the same thing in a number of hardware drivers, as well
> as virtio-net.

Right.  Although this reminds me about the whole SKB
orphaning on xmit issue that keeps coming back to haunt
us.

If there weren't odd references to the SKB's socket in
the packet scheduler et al. we could just orphan these
things right upon entry to the qdisc and not have to
add hacks like this to every driver.

In fact... maybe we can just do it in dev_hard_queue_xmit()
since we are out of the qdisc at that point.... but I guess
there might be weird drivers that want the SKB socket in
their ->xmit routine...  Ho hum.

In any event that's net-next-2.6 exploratory material, and I've
applied this patch to net-2.6, thanks!
