Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2A0Gu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:50:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53191 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752720Ab2A0Gu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:50:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/u1M8MhOPuBKGQ0Yi9CRI/Z4xu/uS11tAVQXj7pk
	8cpogjxUsNiLpj
Subject: Re: Shift by one instruction in the perf annotate output
From: Mike Galbraith <efault@gmx.de>
To: =?ISO-8859-1?Q?L=E9na=EFc?= Huard <lenaic@lhuard.fr.eu.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201201270001.27765.lenaic@lhuard.fr.eu.org>
References: <201201270001.27765.lenaic@lhuard.fr.eu.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Jan 2012 07:50:11 +0100
Message-ID: <1327647011.6335.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 00:01 +0100, Lénaïc Huard wrote:
> Hello,
> 
> Using perf and zooming up to the annotated assembler, I noticed a “shift by 
> one” issue between the assembler instructions and the reported consumed cycles 
> in the left margin.
> Each time a given instruction is expensive, the high event count appears on 
> the line right after.
> In order to validate that feeling, I tried to put an expensive instruction 
> (division) inside a block of cheaper instructions (no operation). And here is 
> the output of perf annotate:
> 
>     0,00 :          40041d:       nop
>     0,00 :          40041e:       nop
>     5,31 :          40041f:       nop                                                                                                                                               
>     0,00 :          400420:       divl   (%rsp)
>    84,18 :          400423:       nop                                                                                                                                               
>     0,00 :          400424:       nop
>     0,07 :          400425:       nop
> 
> I would have expected the 84,18 count to be in front of the “divl” instruction 
> and not in front of the “nop” one.
> 
> I am running Linux and perf 3.2 but I remember that previous versions suffered 
> from the same issue.

Yeah, it's been that way since day 1 here, you have to squint a little.
It's not always off, it gets lock btr right, but lock xadd wrong.  Same
CPU as yours.  I see the same with cache-misses too, but since the right
instruction is right next door, it's always been easy to spot the real
culprit, so I just squint and ignore it, figuring it's a hw detail.

Showing cycles for __schedule
  Events  Pcnt (>=5%)
 Percent |      Source code & Disassembly of vmlinux
------------------------------------------------
         :              next = pick_next_task(rq);
         :              clear_tsk_need_resched(prev);
         :
         :              if (likely(prev != next)) {
    7.68 :      ffffffff8139efca:       mov    -0xf0(%rbp),%rcx
         :
         :      static inline void load_cr3(pgd_t *pgdir)
         :      {
         :              write_cr3(__pa(pgdir));
    6.87 :      ffffffff8139f061:       mov    0x48(%r15),%rdi
         :                              : CONST_MASK_ADDR(nr, addr)
         :                              : "iq" ((u8)~CONST_MASK(nr)));
         :              } else {
         :                      asm volatile(LOCK_PREFIX "btr %1,%0"
   38.27 :      ffffffff8139f06d:       lock btr %r14d,0x300(%r12)
         :                      /*
         :                       * load the LDT, if the LDT is different:
         :                       */
         :                      if (unlikely(prev->context.ldt != next->context.ldt))
   12.53 :      ffffffff8139f077:       mov    0x308(%r15),%r13
    0.40 :      ffffffff8139f0df:       jne    ffffffff813a7c60 <ret_from_fork>
    0.00 :      ffffffff8139f0e5:       mov    %rbp,%rsi
    0.00 :      ffffffff8139f0e8:       pop    %rbp
    0.00 :      ffffffff8139f0e9:       popfq  
    5.12 :      ffffffff8139f0ea:       mov    %rax,-0xe8(%rbp)

Showing cycles for _raw_spin_lock_irqsave
  Events  Pcnt (>=5%)
 Percent |      Source code & Disassembly of vmlinux
------------------------------------------------
         :               * documented behavior of the "pop" instruction.
         :               */
         :              asm volatile("# __raw_save_flags\n\t"
    0.00 :      ffffffff813a0b1f:       pushfq 
   15.38 :      ffffffff813a0b20:       pop    %r12
         :              unsigned long flags;
         :
         :              local_irq_save(flags);
         :              preempt_disable();
   16.24 :      ffffffff813a0b23:       mov    $0x1,%edi
         :              register struct __raw_tickets inc = { .tail = 1 };
         :
         :              inc = xadd(&lock->tickets, inc);
    0.00 :      ffffffff813a0b32:       lock xadd %ax,(%rbx)
   46.15 :      ffffffff813a0b37:       movzbl %ah,%edx
         :              return __raw_spin_lock_irqsave(lock);
         :      }
    0.85 :      ffffffff813a0b49:       mov    %r12,%rax
    0.00 :      ffffffff813a0b4c:       pop    %rbx
   17.09 :      ffffffff813a0b4d:       pop    %r12


