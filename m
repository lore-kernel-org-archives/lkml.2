Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2JSHBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:01:11 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51307 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2JSHBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:01:08 -0400
Subject: Re: [Q] Default SLAB allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: JoonSoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
In-Reply-To: <CAAmzW4N1rAQLOE3QmeeTfsNH-7v-9RD8wT990RbZtYon3YfrLA@mail.gmail.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
	 <m27gqwtyu9.fsf@firstfloor.org>
	 <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com>
	 <m2391ktxjj.fsf@firstfloor.org>
	 <alpine.DEB.2.00.1210130249070.7462@chino.kir.corp.google.com>
	 <1350141021.21172.14949.camel@edumazet-glaptop>
	 <CAAmzW4N1rAQLOE3QmeeTfsNH-7v-9RD8wT990RbZtYon3YfrLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Oct 2012 09:01:03 +0200
Message-ID: <1350630063.2293.177.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 09:03 +0900, JoonSoo Kim wrote:
> Hello, Eric.
> Thank you very much for a kind comment about my question.
> I have one more question related to network subsystem.
> Please let me know what I misunderstand.
> 
> 2012/10/14 Eric Dumazet <eric.dumazet@gmail.com>:
> > In latest kernels, skb->head no longer use kmalloc()/kfree(), so SLAB vs
> > SLUB is less a concern for network loads.
> >
> > In 3.7, (commit 69b08f62e17) we use fragments of order-3 pages to
> > populate skb->head.
> 
> You mentioned that in latest kernel skb->head no longer use kmalloc()/kfree().

I hadnt the time to fully explain what was going on, only to give some
general ideas/hints.

Only incoming skbs, delivered by NIC are built this way.

I plan to extend this to some kind of frames, for example TCP ACK.
(They have a short life, so using __netdev_alloc_frag makes sense)

But when an application does a tcp_sendmsg() we use GFP_KERNEL
allocations and thus still use kmalloc().

> But, why result of David's "netperf RR" test on v3.6 is differentiated
> by choosing the allocator?

Because outgoing skb are still using a kmalloc() for their skb->head

RR sends one frame, receives one frame for each transaction.

So with 3.5, each RR transaction using a NIC needs 3 kmalloc() instead
of 4 for previous kernels.

Note that loopback traffic is different, since we do 2 kmalloc() per
transaction, and there is no difference on 3.5 for this kind of network
load.

> As far as I know, __netdev_alloc_frag may be introduced in v3.5, so
> I'm just confused.
> Does this test use __netdev_alloc_skb with "__GFP_WAIT | GFP_DMA"?
> 
> Does normal workload for network use __netdev_alloc_skb with
> "__GFP_WAIT | GFP_DMA"?
> 

Not especially.


