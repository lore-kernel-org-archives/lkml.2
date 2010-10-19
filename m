Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab0JSV27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:28:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab0JSV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:28:58 -0400
Date: Tue, 19 Oct 2010 17:28:17 -0400
From: Jason Baron <jbaron@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
Message-ID: <20101019212816.GA2855@redhat.com>
References: <1287395077.29097.1543.camel@twins>
 <1287398936.29097.1548.camel@twins>
 <4CBD79CF.2060706@jp.fujitsu.com>
 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
 <20101019132236.GA19197@Krystal>
 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
 <1287496495.16971.372.camel@gandalf.stny.rr.com>
 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
 <20101019142820.GA14520@Krystal>
 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2010-07-18)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 09:49:45PM +0200, Thomas Gleixner wrote:
> > > On Tue, 19 Oct 2010, Steven Rostedt wrote:
> > as an excuse for adding extra performance impact to kernel code, because when it
> > will be replaced by asm gotos, all that will be left is the performance impact
> > inappropriately justified as insignificant compared to the impact of the old
> > tracepoint scheme.
> 
> Can you at one point just stop your tracing lectures and look at the
> facts ?
> 
> The impact of a sensible tracepoint design on the code in question
> before kstat_incr_softirqs_this_cpu() was added would have been a mere
> _FIVE_ bytes of text. But the original tracepoint code itself is
> _TWENTY_ bytes of text larger.
> 
> So we trade horrible code plus 20 bytes text against 5 bytes of text
> in the hotpath. And you tell me that these _FIVE_ bytes are impacting
> performance so much that it's significant.
> 
> Now with kstat_incr_softirqs_this_cpu() the impact is zero, it even
> removes code.
> 
> And talking about non impact of disabled trace points. The tracepoint
> in question which made me look at the code results in deinlining
> __raise_softirq_irqsoff() in net/dev/core.c. There goes your theory.
> 
> So no, you _cannot_ tell what impact a tracepoint has in reality
> except by looking at the assembly output.
> 
> And what scares me way more is the size of a single tracepoint in a
> code file.
> 
> Just adding "trace_softirq_entry(nr);" adds 88 bytes of text. So
> that's optimized tracing code ?
> 
> All it's supposed to do is:
> 
>     if (enabled)
> 	trace_foo(nr);
> 
> Replace "if (enabled)" with your favourite code patching jump label
> whatever magic. The above stupid version takes about 28, but the
> "optimized" tracing code makes that 88. Brilliant. That's inlining
> utter shite for no good reason. WTF is it necessary to inline all that
> gunk ?
> 
> Please spare me the "jump label will make this less intrusive"
> lecture. I'm not interested at all.
> 
> Let's instead look at some more facts:
> 
> #include <linux/interrupt.h>
> #include <linux/module.h>
> 
> #include <trace/events/irq.h>
> 
> static struct softirq_action softirq_vec[NR_SOFTIRQS];
> 
> void test(struct softirq_action *h)
> {
> 	trace_softirq_entry(h - softirq_vec);
> 
> 	h->action(h);
> }
> 
> Compile this code with GCC 4.5 with and without jump labels (zap the
> select HAVE_ARCH_JUMP_LABEL line in arch/x86/Kconfig)
> 
> So now the !jumplabel case gives us:
> 
> ../build/kernel/soft.o:     file format elf64-x86-64
> 
> Disassembly of section .text:
> 
> 0000000000000000 <test>:
>    0:	55                   	push   %rbp
>    1:	48 89 e5             	mov    %rsp,%rbp
>    4:	41 55                	push   %r13
>    6:	49 89 fd             	mov    %rdi,%r13
>    9:	49 81 ed 00 00 00 00 	sub    $0x0,%r13
>   10:	41 54                	push   %r12
>   12:	49 c1 ed 03          	shr    $0x3,%r13
>   16:	49 89 fc             	mov    %rdi,%r12
>   19:	53                   	push   %rbx
>   1a:	48 83 ec 08          	sub    $0x8,%rsp
>   1e:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0(%rip)        # 25 <test+0x25>
>   25:	74 4d                	je     74 <test+0x74>
>   27:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
>   2e:	00 00 
>   30:	ff 80 44 e0 ff ff    	incl   -0x1fbc(%rax)
>   36:	48 8b 1d 00 00 00 00 	mov    0x0(%rip),%rbx        # 3d <test+0x3d>
>   3d:	48 85 db             	test   %rbx,%rbx
>   40:	74 13                	je     55 <test+0x55>
>   42:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
>   46:	44 89 ee             	mov    %r13d,%esi
>   49:	ff 13                	callq  *(%rbx)
>   4b:	48 83 c3 10          	add    $0x10,%rbx
>   4f:	48 83 3b 00          	cmpq   $0x0,(%rbx)
>   53:	eb eb                	jmp    40 <test+0x40>
>   55:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
>   5c:	00 00 
>   5e:	ff 88 44 e0 ff ff    	decl   -0x1fbc(%rax)
>   64:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
>   6b:	a8 08                	test   $0x8,%al
>   6d:	74 05                	je     74 <test+0x74>
>   6f:	e8 00 00 00 00       	callq  74 <test+0x74>
>   74:	4c 89 e7             	mov    %r12,%rdi
>   77:	41 ff 14 24          	callq  *(%r12)
>   7b:	58                   	pop    %rax
>   7c:	5b                   	pop    %rbx
>   7d:	41 5c                	pop    %r12
>   7f:	41 5d                	pop    %r13
>   81:	c9                   	leaveq 
>   82:	c3                   	retq   
> 
> The jumplabel=y case gives:
> 
> ../build/kernel/soft.o:     file format elf64-x86-64
> 
> Disassembly of section .text:
> 
> 0000000000000000 <test>:
>    0:	55                   	push   %rbp
>    1:	48 89 e5             	mov    %rsp,%rbp
>    4:	41 55                	push   %r13
>    6:	49 89 fd             	mov    %rdi,%r13
>    9:	49 81 ed 00 00 00 00 	sub    $0x0,%r13
>   10:	41 54                	push   %r12
>   12:	49 c1 ed 03          	shr    $0x3,%r13
>   16:	49 89 fc             	mov    %rdi,%r12
>   19:	53                   	push   %rbx
>   1a:	48 83 ec 08          	sub    $0x8,%rsp
>   1e:	e9 00 00 00 00       	jmpq   23 <test+0x23>
>   23:	eb 4d                	jmp    72 <test+0x72>
>   25:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
>   2c:	00 00 
>   2e:	ff 80 44 e0 ff ff    	incl   -0x1fbc(%rax)
>   34:	48 8b 1d 00 00 00 00 	mov    0x0(%rip),%rbx        # 3b <test+0x3b>
>   3b:	48 85 db             	test   %rbx,%rbx
>   3e:	74 13                	je     53 <test+0x53>
>   40:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
>   44:	44 89 ee             	mov    %r13d,%esi
>   47:	ff 13                	callq  *(%rbx)
>   49:	48 83 c3 10          	add    $0x10,%rbx
>   4d:	48 83 3b 00          	cmpq   $0x0,(%rbx)
>   51:	eb eb                	jmp    3e <test+0x3e>
>   53:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
>   5a:	00 00 
>   5c:	ff 88 44 e0 ff ff    	decl   -0x1fbc(%rax)
>   62:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
>   69:	a8 08                	test   $0x8,%al
>   6b:	74 05                	je     72 <test+0x72>
>   6d:	e8 00 00 00 00       	callq  72 <test+0x72>
>   72:	4c 89 e7             	mov    %r12,%rdi
>   75:	41 ff 14 24          	callq  *(%r12)
>   79:	58                   	pop    %rax
>   7a:	5b                   	pop    %rbx
>   7b:	41 5c                	pop    %r12
>   7d:	41 5d                	pop    %r13
>   7f:	c9                   	leaveq 
>   80:	c3                   	retq   
> 
> So that saves _TWO_ bytes of text and replaces:
> 
> -  1e:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0(%rip)        # 25 <test+0x25>
> -  25:	74 4d                	je     74 <test+0x74>
> +  1e:	e9 00 00 00 00       	jmpq   23 <test+0x23>
> +  23:	eb 4d                	jmp    72 <test+0x72>
> 
> So it trades a conditional vs. two jumps ? WTF ??
> 

right, so the 'jmpq' on boot on x86 gets patched with 5 byte no-op
sequence. So in the disabled case we have no-op followed by a jump
around the disabled code.

> I thought that jumplabel magic was supposed to get rid of the jump
> over the tracing code ? In fact it adds another jump. Whatfor ?
> 

yes, that is the plan. gcc does not yet support hot/cold labels...once
it does the second jump will go away and the entire tracepoint code will
be moved to a 'cold' section. It's not quite completely optimal yet, but
we are getting there.

> Now even worse, when you NOP out the jmpq then your tracepoint is
> still not enabled. Brilliant !
> 

The 'jmpq' in the enabled case is patched with a jmpq to the body of the
tracepoint itself.

> Did you guys ever look at the assembly output of that insane shite you
> are advertising with lengthy explanations ? 
> 
> Obviously _NOT_
> 
> Come back when you can show me a clean imlementation of all this crap
> which reproduces with my jumplabel enabled stock compiler. And please
> just send me a patch w/o the blurb.
> 
> And sane looks like:
> 
>     jmpq   2f  <---- This gets noped out 
> 1:
>     mov    %r12,%rdi
>     callq  *(%r12)
>     [whatever cleanup it takes ]
>     leaveq 
>     retq   
> 
> 2f:
>     [tracing gunk]
>     jmp    1b
> 

yes, this is what the code should look like when we get support for
hot/cold labels. I've discussed this support with gcc folk, and its the
next step here. So yes, this is exacatly where we are headed.

thanks,

-Jason
