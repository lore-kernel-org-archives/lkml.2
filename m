Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2K2TZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:25:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54289 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab2K2TZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:25:05 -0500
Date: Thu, 29 Nov 2012 20:25:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ian Kumlien <pomac@vapor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] NULL pointer dereference in 3.7-rc7 (syscall_trace_enter)
Message-ID: <20121129192500.GG30789@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ian Kumlien <pomac@vapor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1354144802.5396.3.camel@pi>
 <20121129092621.GA21100@liondog.tnic>
 <20121129122708.GA6365@pomac.netswarm.net>
 <20121129142220.GC30789@liondog.tnic>
 <20121129162403.GC6365@pomac.netswarm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121129162403.GC6365@pomac.netswarm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 05:24:03PM +0100, Ian Kumlien wrote:
> > Can you do:
> > 
> > make arch/x86/kernel/ptrace.lst
> > 
> > and send me that file, privately is fine too.
> 
> Done, =)

Ok, thanks. Here it is:

ffffffff8100b627:       83 3f 00                cmpl   $0x0,(%rdi)
ffffffff8100b62a:       75 24                   jne    ffffffff8100b650 <syscall_trace_enter+0x163>
ffffffff8100b62c:       eb 37                   jmp    ffffffff8100b665 <syscall_trace_enter+0x178>
ffffffff8100b62e:       65 48 8b 0c 25 00 00    mov    %gs:0x0,%rcx
ffffffff8100b635:       00 00 
                        ffffffff8100b633: R_X86_64_32S  current_task
extern void __audit_seccomp(unsigned long syscall, long signr, int code);
extern void __audit_ptrace(struct task_struct *t);

static inline int audit_dummy_context(void)
{
        void *p = current->audit_context;
ffffffff8100b637:       48 8b 89 c0 04 00 00    mov    0x4c0(%rcx),%rcx
                                    regs->orig_ax,
                                    regs->bx, regs->cx,
                                    regs->dx, regs->si);
#ifdef CONFIG_X86_64
        else
                audit_syscall_entry(AUDIT_ARCH_X86_64,
ffffffff8100b63e:       4c 8b 4b 38             mov    0x38(%rbx),%r9
ffffffff8100b642:       48 8b 53 70             mov    0x70(%rbx),%rdx
        return !p || *(int *)p;
ffffffff8100b646:       48 85 c9                test   %rcx,%rcx
ffffffff8100b649:       74 05                   je     ffffffff8100b650 <syscall_trace_enter+0x163>
ffffffff8100b64b:       83 39 00                cmpl   $0x0,(%rcx)
ffffffff8100b64e:       74 1f                   je     ffffffff8100b66f <syscall_trace_enter+0x182>
                                    regs->di, regs->si,
                                    regs->dx, regs->r10);
#endif

out:
        return ret ?: regs->orig_ax;
ffffffff8100b650:       48 83 ca ff             or     $0xffffffffffffffff,%rdx
ffffffff8100b654:       48 85 ed                test   %rbp,%rbp
ffffffff8100b657:       75 04                   jne    ffffffff8100b65d <syscall_trace_enter+0x170>
ffffffff8100b659:       48 8b 53 78             mov    0x78(%rbx),%rdx
}
ffffffff8100b65d:       5b                      pop    %rbx
ffffffff8100b65e:       5d                      pop    %rbp
ffffffff8100b65f:       48 89 d0                mov    %rdx,%rax
ffffffff8100b662:       41 5c                   pop    %r12
ffffffff8100b664:       c3                      retq

We're calling audit_syscall_entry() for a 64-bit task (chrome) and we
check whether the audit context of the task is not a dummy one.

We fail at the second check in

        return !p || *(int *)p;

when we're trying to deref the ->audit_context pointer of current and
then check it for being 0 in audit_syscall_entry. It turns out it is
some random crap, as we saw already: RCX=0000000000000063.

>From looking at the code, task audit contexts get normally allocated
at fork time and dealloc'd at task exit time so your process should
actually have a valid task context.

The only explanation I have is that it could be some random corruption
which f*cked up the ->audit_context pointer but I might be wrong. Btw,
do you have CONFIG_AUDITSYSCALL enabled in your kernel?

I'd say right now we could watch this and if it is reproducible, then
we can involve some more brain power and skills into it. If it has been
only a single occurrence, then we'll write it on the random corruption's
tab.

Thanks.

-- 
Regards/Gruss,
    Boris.
