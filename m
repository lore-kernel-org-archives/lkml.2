Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1ASMo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:44:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39605 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab1ASMo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:44:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l8A/C7t2XQ3sr9dgwhBP+XjaV19SCtza3M7NXcBu5XvhyVWgJp3DzsVk5fdDblihEu
         67aRFhFG+b7r90RH+FGJbN6Eyk1DMVqF2VBCUT8Db97Tt+5qdnEPxPnAPEzpVPUQd0S1
         QOfkEW1/1baiQdp5Bd/66mS+a+MuysD9fLNfs=
Date: Wed, 19 Jan 2011 13:44:33 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: percpu related boot crash on x86 (was: Linux 2.6.38-rc1)
Message-ID: <20110119124433.GA14096@mtj.dyndns.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119120200.GA1057@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119120200.GA1057@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On Wed, Jan 19, 2011 at 01:02:00PM +0100, Ingo Molnar wrote:
> 
> There's a rather frequent, percpu related boot crash that I can see with .38-rc1:
> [    0.000000] NR_IRQS:4352
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at kernel/smp.c:433 smp_call_function_many+0x90/0x209()
...
> [    0.000000]  [<ffffffff81076299>] ? on_each_cpu+0x1b/0x39
> [    0.000000]  [<ffffffff810274e6>] ? flush_tlb_all+0x1c/0x1e
> [    0.000000]  [<ffffffff810dc7d7>] ? remove_vm_area+0x71/0x96
> [    0.000000]  [<ffffffff810dc868>] ? __vunmap+0x3f/0xcf
> [    0.000000]  [<ffffffff810dc9db>] ? vfree+0x2c/0x2e
> [    0.000000]  [<ffffffff810ccca6>] ? pcpu_mem_free+0x1e/0x20
> [    0.000000]  [<ffffffff810ccd75>] ? pcpu_extend_area_map+0x9a/0xb6
> [    0.000000]  [<ffffffff810cd452>] ? pcpu_alloc+0x17e/0x916
> [    0.000000]  [<ffffffff8106bb00>] ? trace_hardirqs_off+0xd/0xf
> [    0.000000]  [<ffffffff810e5bed>] ? kmem_cache_alloc_trace+0xab/0x120
> [    0.000000]  [<ffffffff810cdbfa>] ? __alloc_percpu+0x10/0x12
> [    0.000000]  [<ffffffff8180afd4>] ? early_irq_init+0xb2/0x13d
...

This is vfree() path used before local irq is enabled during early
boot.  vfree() triggered TLB flush (maybe debug enabled?) which used
on_each_cpu() which isn't quite happy to be called with local irq
diabled.

> [    0.000000] general protection fault: 01bb [#1] SMP DEBUG_PAGEALLOC
...
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff810068a4>] init_8259A+0xe3/0xe8
> [    0.000000]  [<ffffffff817f7d71>] init_ISA_irqs+0x2f/0x5a
> [    0.000000]  [<ffffffff817f7de1>] native_init_IRQ+0xe/0xa2
> [    0.000000]  [<ffffffff817f7dd1>] init_IRQ+0x35/0x37
> [    0.000000]  [<ffffffff817f4a0b>] start_kernel+0x1ff/0x3a4
> [    0.000000]  [<ffffffff817f42a6>] x86_64_start_reservations+0xb6/0xba
> [    0.000000]  [<ffffffff817f43a1>] x86_64_start_kernel+0xf7/0xfe
> [    0.000000] Code: 18 48 89 f3 be 01 00 00 00 e8 33 fe cd ff 4c 89 e7 e8 77 1f e2 ff f6 c7 02 75 09 53 9d e8 a0 bf cd ff eb 07 e8 74 08 ce ff 53 9d <5b> 41 5c c9 c3 55 48 89 e5 53 48 83 ec 08 e8 91 2c c7 ff 48 8b 
> [    0.000000] RIP  [<ffffffff8138fb5c>] _raw_spin_unlock_irqrestore+0x41/0x4

and this looks like alloc_percpu() failed earlier during early irq
init.  The irq init functions don't check for NULL return so it just
goes off later.  I'll see if I can reproduce the problem here.

It doesn't look like anything hardware dependent.  The first warning
seems more or less spurious and the GPF seems to be caused by earlier
memory allocation failure.  It's a bit curious that the allocation
failed on a x86_64 machine tho.

Thanks.

-- 
tejun
