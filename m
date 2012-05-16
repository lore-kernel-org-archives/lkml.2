Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967538Ab2EPNoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:44:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:38819 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967473Ab2EPNoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:44:44 -0400
Date: Wed, 16 May 2012 15:44:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Sverdlin <asv@sysgo.com>
cc: linux-kernel@vger.kernel.org, alexander.sverdlin.ext@nsn.com
Subject: Re: Possible race in request_irq() (__setup_irq())
In-Reply-To: <4FB39EDA.3030807@sysgo.com>
Message-ID: <alpine.LFD.2.02.1205161512270.3231@ionos>
References: <4FB39EDA.3030807@sysgo.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Alexander Sverdlin wrote:

> [<ffffffff801cb9f8>] handle_IRQ_event+0x30/0x190
> [<ffffffff801cdef4>] handle_percpu_irq+0x54/0xc0
> [<ffffffff8015f094>] do_IRQ+0x2c/0x40
> [<ffffffff8011a594>] plat_irq_dispatch+0x10c/0x1e8
> [<ffffffff80100880>] ret_from_irq+0x0/0x4
> [<ffffffff80100aa0>] r4k_wait+0x20/0x40
> [<ffffffff8015fcc4>] cpu_idle+0x9c/0x108
> 

> This code is inside raw_spin_lock_irqsave() protected region, but
> actually IRQ could be triggered on another core where IRQs are not
> disabled!

And that interrupt will spin on desc->lock until this code has set up
the action. So nothing happens at all.

Except for per_cpu interrupts. Now, that's a different issue and you
are doing something completely wrong here.

> So if IRQ affinity is set up in the way that IRQ itself and
> request_irq() happen on different cores, IRQ that is already pending
> in hardware will occur before it's handler is actually set up.

per_cpu interrupts are special.
 
> And this actually happens on our boards. The only reason the topic
> of the message contains "Possible" is that this race present in
> kernel for quite a long time and I have not found any occurrences on
> other SMP systems than our Octeon. Other possible cause could be
> wrong usage of request_irq(), but the whole configuration seems to
> be legal:

Well, there is no law which forbids doing that.

> IRQ affinity is set to 1 (core 0 processes IRQ).
> request_irq() happens during kernel init on core 5. 
> IRQ is already pending (but not enabled) before request_irq() happens.
> IRQ is not shared and should be enabled by request_irq() automatically.

But it's wrong nevertheless.

Your irq is using handle_percpu_irq() as the flow handler.

handle_percpu_irq() is a special flow handler which does not take the
irq descriptor lock for performance reasons. It's a single interrupt
number which has a percpu dev_id and can be handled on all cores in
parallel.

The interrupts need to be marked as such and requested with
request_percpu_irq(). Those interrupts are either marked as
NOAUTOENABLE or set up by the low level setup code, which runs on the
boot cpu with interrupt enabled.

Those interrupts are marked as percpu and can only be requested with
request_percpu_irq().

>From your description it looks like you are using a regular interrupt,
because interrupt affinities of per cpu interrupts cannot be set. They
are hardwired.

I don't know what your archaeologic kernel version is doing there, but
the current cavium code only uses handle_percpu_irq flow handler for a
handful special interrupts which are handled and setup by the cavium
core code correctly.

So nothing to fix here.

Thanks,

	tglx
