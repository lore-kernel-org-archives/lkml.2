Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1ASM4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:56:25 -0500
Received: from mail-yi0-f42.google.com ([209.85.218.42]:41698 "EHLO
	mail-yi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1ASM4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EHD+NbEeq4ccj+PL+pRmjE2IPudXVwMWBEOfnryyEh1+eUcvEDduC+W9fe5jIeD9pd
         MLKqi87fFKwKxCW5dwB5Enu0GXuggs1AWTICNSXLZ6lZ4SOwAQSHI7kaAXBT7sLVA6T/
         i1tUDGFKdOAsm0KKQyPMinyOPOmpEw0UtZ5GY=
MIME-Version: 1.0
In-Reply-To: <1295441307.28776.15.camel@laptop>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	<20110119120200.GA1057@elte.hu>
	<1295441307.28776.15.camel@laptop>
Date: Wed, 19 Jan 2011 14:56:23 +0200
X-Google-Sender-Auth: Q4bSus55M6lnvSKCkYh8-XZU_LA
Message-ID: <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
Subject: Re: percpu related boot crash on x86 (was: Linux 2.6.38-rc1)
From: Pekka Enberg <penberg@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 13:02 +0100, Ingo Molnar wrote:
>> There's a rather frequent, percpu related boot crash that I can see with .38-rc1:
>>
>> [    0.000000] NR_IRQS:4352
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] WARNING: at kernel/smp.c:433 smp_call_function_many+0x90/0x209()
>> [    0.000000] Hardware name: System Product Name
>> [    0.000000] Modules linked in:
>> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.38-rc1 #86551
>> [    0.000000] Call Trace:
>> [    0.000000]  [<ffffffff8103f544>] ? warn_slowpath_common+0x85/0x9d
>> [    0.000000]  [<ffffffff81027218>] ? do_flush_tlb_all+0x0/0x4d
>> [    0.000000]  [<ffffffff81027218>] ? do_flush_tlb_all+0x0/0x4d
>> [    0.000000]  [<ffffffff8103f576>] ? warn_slowpath_null+0x1a/0x1c
>> [    0.000000]  [<ffffffff810760df>] ? smp_call_function_many+0x90/0x209
>> [    0.000000]  [<ffffffff810cc7ca>] ? pcpu_mem_alloc+0x65/0x67
>> [    0.000000]  [<ffffffff81027218>] ? do_flush_tlb_all+0x0/0x4d
>> [    0.000000]  [<ffffffff8107627a>] ? smp_call_function+0x22/0x26
>> [    0.000000]  [<ffffffff81076299>] ? on_each_cpu+0x1b/0x39
>> [    0.000000]  [<ffffffff810274e6>] ? flush_tlb_all+0x1c/0x1e
>> [    0.000000]  [<ffffffff810dc7d7>] ? remove_vm_area+0x71/0x96
>> [    0.000000]  [<ffffffff810dc868>] ? __vunmap+0x3f/0xcf
>> [    0.000000]  [<ffffffff810dc9db>] ? vfree+0x2c/0x2e
>> [    0.000000]  [<ffffffff810ccca6>] ? pcpu_mem_free+0x1e/0x20
>> [    0.000000]  [<ffffffff810ccd75>] ? pcpu_extend_area_map+0x9a/0xb6
>> [    0.000000]  [<ffffffff810cd452>] ? pcpu_alloc+0x17e/0x916
>> [    0.000000]  [<ffffffff8106bb00>] ? trace_hardirqs_off+0xd/0xf
>> [    0.000000]  [<ffffffff810e5bed>] ? kmem_cache_alloc_trace+0xab/0x120
>> [    0.000000]  [<ffffffff810cdbfa>] ? __alloc_percpu+0x10/0x12
>> [    0.000000]  [<ffffffff8180afd4>] ? early_irq_init+0xb2/0x13d
>> [    0.000000]  [<ffffffff817f4a06>] ? start_kernel+0x1fa/0x3a4
>> [    0.000000]  [<ffffffff817f42a6>] ? x86_64_start_reservations+0xb6/0xba
>> [    0.000000]  [<ffffffff817f43a1>] ? x86_64_start_kernel+0xf7/0xfe
>> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
>> [    0.000000] ------------[ cut here ]------------
>
> You config had CONFIG_FRAME_POINTER=y, still its all '?', did out
> backtrace code go funny in the head?

On Wed, Jan 19, 2011 at 2:48 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  start_kernel()
>   local_irq_disable()
>   ...
>   early_irq_init()
>     alloc_desc()
>       alloc_percpu()
>         __alloc_percpu()
>           pcpu_alloc()
>             pcpu_extend_area_map()
>               pcpu_mem_free()
>                 vfree()
>                   __vunmap()
>                     remove_vm_area()
>                       free_unmap_vmap_area()
>                         vmap_debug_free_range()
> #ifdef CONFIG_DEBUG_PAGEALLOC
>                           flush_tlb_kernel_range()
>                             flush_tlb_all()
>                               on_each_cpu()
>                                 smp_call_function()
>                                   WARN_ON_ONCE(irqs_disabled()....);
>
>
> Not quite sure that to do about that though..

Is vmalloc() and vfree() supposed to work with interrupts disabled? I
always thought they weren't which would mean something in
pcpu_mem_alloc() needs changing...
