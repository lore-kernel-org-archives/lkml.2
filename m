Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1B1JfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:35:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:57983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1B1JfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:35:19 -0500
Subject: Re: a question about adaptive mutex lock in the Linux kernel
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?=E5=B4=94=E5=B2=A9ccuiyyan=40gmail=2Ecom?= 
	<ccuiyyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=RkJGYbsEBKJdO_a+TPDOM23hC=uo9tf-OYS7b@mail.gmail.com>
References: <AANLkTin+fnW345BoVxEV_+WAFMqczizT-NfMTCjcz83o@mail.gmail.com>
	 <1295605848.28776.216.camel@laptop>
	 <AANLkTi=RkJGYbsEBKJdO_a+TPDOM23hC=uo9tf-OYS7b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Feb 2011 10:34:49 +0100
Message-ID: <1298885689.2428.10138.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-26 at 11:21 +0800, 崔岩ccuiyyan@gmail.com wrote:
> Thanks for the comments! And i have verified that the lock waiters
> also sleep when the lock owner change by modifying the Linux kernel.  
> 
> However, another problem occurs when i test some benchmarks.
> That is, the spin performance of adaptive mutex lock is worse than
> that of the original ticket spin lock in the kernel. 
> I have attached a picture to show this problem. 
> 
> i create a program where each process creates sockets and deletes
> them. Although the program is written to be totally concurrent, but
> spinlock contention in the Linux kernel can still degrades the
> performance. For this benchmark, dcache_lock and inode_lock in the
> kernel are contended. 
> 
> In the picture, there are two curves. The curve labeled spin lock
> shows the performance of the original Linux kernel, while another
> curve shows the performance using adaptive mutex lock (note that i
> remove the code that the waiter can sleep when the lock owner changes,
> so, the curve indicates the spin performance of adaptive mutex lock). 
> 
> As we can see, the spin lock curve is above another curve, which
> indicates a performance gap between these two mplementations. 
> 
> i wonder to know whether we can optimize the spin performance of the
> adaptive mutex lock?  Hope for your suggestions.

Very much depends on what causes this. If its the case of simple spin
(unfair) vs ticket lock (fair) we could try and come up with a fairer
spin for the adaptive mutex (one of the fifo queue implementations
maybe, as they have the advantage that you can actually remove waiters
-- something not possible with tickets).

If its something trivial as that the mutex spin is basically a cmpxchg
loop and the ticket lock a single xadd, which is much lighter on
cacheline contention, I'm not quite sure how to fix that... /me ponders
a bit.. maybe the fifo queue thing will also solve that, all you need is
to enqueue yourself (single cmpxchg/xchg like) and then spin until
you're the tail or somesuch.

So 1) try and find out why we're slower, you could try to use perf for
that, see if there's more cacheline contention or simething else
entirely (could be our spinloop is simply much much more expensive?)

And 2) try and implement a fifo queue spin variant, where the lock
enqueues itself on a list, and you acquire it when you've reached the
tail of the list.

And I guess its worth seeing what, if anything, the below two patches
do:

  https://lkml.org/lkml/2011/1/4/237
  https://lkml.org/lkml/2011/1/4/224


