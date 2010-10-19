Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab0JSU4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:56:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab0JSU4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:56:00 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=wGm5nfgfXM4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KyWxkVBzxLUieEpdD5oA:9 a=hYSq-3yKI0iXSSX5ZS8A:7 a=24kXggtkK1AUEoOWnODXsP-H_kYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
In-Reply-To: <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
	 <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>
	 <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>
	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
	 <20101019132236.GA19197@Krystal>
	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
	 <1287496495.16971.372.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
	 <20101019142820.GA14520@Krystal>
	 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 16:55:57 -0400
Message-ID: <1287521757.16971.397.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 21:49 +0200, Thomas Gleixner wrote:

> Let's instead look at some more facts:

Sure, this is where it gets fun :-)

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

Since I don't have your patch yet, I used the original:


void test(struct softirq_action *h)
{
        trace_softirq_entry(h, softirq_vec);
        h->action(h);
}


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

Well, the one jmpq is noped out, and the jmp is non conditional. I've
always thought a non conditional jmp was faster than a conditional one,
since there's no need to go into the branch prediction logic. The CPU
can simply skip to the code to jump next. Of counse, this pollutes the 
I$.


> 
> I thought that jumplabel magic was supposed to get rid of the jump
> over the tracing code ? In fact it adds another jump. Whatfor ?

Because you do the h - softvec in the tracepoint parameter? I got a
different result:

Here's the diff. I did a cut -c10- to get rid of the line numbers so I
have a better diff. There's still differences due to jump locations, but
those are easy to figure out:

I diffed nojump vs jump. The '-' is with nojump, the '+' is with jumps.

--- /tmp/s2	2010-10-19 16:40:19.000000000 -0400
+++ /tmp/s1	2010-10-19 16:40:23.000000000 -0400
@@ -1,38 +1,33 @@
-00026f0 <test>:
+00027a0 <test>:
 	55                   	push   %rbp
 	48 89 e5             	mov    %rsp,%rbp
-	48 83 ec 10          	sub    $0x10,%rsp
-	48 89 1c 24          	mov    %rbx,(%rsp)
-	4c 89 64 24 08       	mov    %r12,0x8(%rsp)
-	e8 00 00 00 00       	callq  2706 <test+0x16>
+	41 54                	push   %r12
+	53                   	push   %rbx
+	e8 00 00 00 00       	callq  27ac <test+0xc>
 R_X86_64_PC32	mcount-0x4
-	8b 15 00 00 00 00    	mov    0x0(%rip),%edx        # 270c <test+0x1c>
-R_X86_64_PC32	__tracepoint_softirq_entry+0x4
 	48 89 fb             	mov    %rdi,%rbx

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
-	85 d2                	test   %edx,%edx
-	75 10                	jne    2723 <test+0x33>
+	e9 00 00 00 00       	jmpq   27b4 <test+0x14>
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There's the difference with this code. We replaced a test and jump
conditional with a single jump that will later be nop'd out.


 	48 89 df             	mov    %rbx,%rdi
 	ff 13                	callq  *(%rbx)
-	48 8b 1c 24          	mov    (%rsp),%rbx
-	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
+	5b                   	pop    %rbx
+	41 5c                	pop    %r12
 	c9                   	leaveq 
 	c3                   	retq

^^^^^^^^^^^^^^^^^^^
end of the fast path, below is the code that does the tracepoint.



   
+	66 90                	xchg   %ax,%ax
 	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
 	00 00 
 R_X86_64_32S	kernel_stack
 	83 80 44 e0 ff ff 01 	addl   $0x1,-0x1fbc(%rax)
-	e8 00 00 00 00       	callq  2738 <test+0x48>
+	e8 00 00 00 00       	callq  27d5 <test+0x35>
 R_X86_64_PC32	debug_lockdep_rcu_enabled-0x4
 	85 c0                	test   %eax,%eax
-	74 09                	je     2745 <test+0x55>
-	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 2743 <test+0x53>
-R_X86_64_PC32	.bss-0x1
-	74 53                	je     2798 <test+0xa8>
-	4c 8b 25 00 00 00 00 	mov    0x0(%rip),%r12        # 274c <test+0x5c>
+	75 57                	jne    2830 <test+0x90>
+	4c 8b 25 00 00 00 00 	mov    0x0(%rip),%r12        # 27e0 <test+0x40>
 R_X86_64_PC32	__tracepoint_softirq_entry+0x1c
 	4d 85 e4             	test   %r12,%r12
-	74 22                	je     2773 <test+0x83>
+	74 29                	je     280e <test+0x6e>
 	49 8b 04 24          	mov    (%r12),%rax
+	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
 	49 83 c4 10          	add    $0x10,%r12
 	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
@@ -41,49 +36,52 @@
 	ff d0                	callq  *%rax
 	49 8b 04 24          	mov    (%r12),%rax
 	48 85 c0             	test   %rax,%rax
-	75 e2                	jne    2755 <test+0x65>
+	75 e2                	jne    27f0 <test+0x50>
 	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
 	00 00 
 R_X86_64_32S	kernel_stack
 	83 a8 44 e0 ff ff 01 	subl   $0x1,-0x1fbc(%rax)
 	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
 	a8 08                	test   $0x8,%al
-	74 85                	je     2713 <test+0x23>
-	e8 00 00 00 00       	callq  2793 <test+0xa3>
+	74 8b                	je     27b4 <test+0x14>
+	e8 00 00 00 00       	callq  282e <test+0x8e>
 R_X86_64_PC32	preempt_schedule-0x4
-	e9 7b ff ff ff       	jmpq   2713 <test+0x23>
-	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
-	00 
-	e8 00 00 00 00       	callq  27a5 <test+0xb5>
+	eb 84                	jmp    27b4 <test+0x14>
+	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 2837 <test+0x97>
+R_X86_64_PC32	.bss-0x1
+	75 a0                	jne    27d9 <test+0x39>
+	e8 00 00 00 00       	callq  283e <test+0x9e>
 R_X86_64_PC32	debug_lockdep_rcu_enabled-0x4
 	85 c0                	test   %eax,%eax
-	74 9c                	je     2745 <test+0x55>
-	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0(%rip)        # 27b0 <test+0xc0>
-R_X86_64_PC32	debug_locks-0x5
-	75 3f                	jne    27f1 <test+0x101>
+	74 97                	je     27d9 <test+0x39>
+	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # 2848 <test+0xa8>
+R_X86_64_PC32	debug_locks-0x4
+	85 f6                	test   %esi,%esi
+	75 44                	jne    2890 <test+0xf0>
 	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
 	00 00 
 R_X86_64_32S	kernel_stack
-	83 b8 44 e0 ff ff 00 	cmpl   $0x0,-0x1fbc(%rax)
-	75 81                	jne    2745 <test+0x55>
+	8b 88 44 e0 ff ff    	mov    -0x1fbc(%rax),%ecx
+	85 c9                	test   %ecx,%ecx
+	0f 85 76 ff ff ff    	jne    27d9 <test+0x39>
 	ff 14 25 00 00 00 00 	callq  *0x0
 R_X86_64_32S	pv_irq_ops
 	f6 c4 02             	test   $0x2,%ah
-	0f 84 71 ff ff ff    	je     2745 <test+0x55>
+	0f 84 66 ff ff ff    	je     27d9 <test+0x39>
 	be 7c 00 00 00       	mov    $0x7c,%esi
 	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 R_X86_64_32S	.rodata.str1.1
-	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # 27e7 <test+0xf7>
+	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # 2886 <test+0xe6>
 R_X86_64_PC32	.bss-0x1
-	e8 00 00 00 00       	callq  27ec <test+0xfc>
+	e8 00 00 00 00       	callq  288b <test+0xeb>
 R_X86_64_PC32	lockdep_rcu_dereference-0x4
-	e9 54 ff ff ff       	jmpq   2745 <test+0x55>
+	e9 49 ff ff ff       	jmpq   27d9 <test+0x39>
 	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
 R_X86_64_32S	rcu_sched_lock_map
-	e8 00 00 00 00       	callq  27fd <test+0x10d>
+	e8 00 00 00 00       	callq  289c <test+0xfc>
 R_X86_64_PC32	lock_is_held-0x4
 	85 c0                	test   %eax,%eax
-	0f 85 40 ff ff ff    	jne    2745 <test+0x55>
-	eb ab                	jmp    27b2 <test+0xc2>
-	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
-	00 00 
+	0f 85 35 ff ff ff    	jne    27d9 <test+0x39>
+	eb a6                	jmp    284c <test+0xac>
+	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
+	00 00 00 


> 
> Now even worse, when you NOP out the jmpq then your tracepoint is
> still not enabled. Brilliant !
> 
> Did you guys ever look at the assembly output of that insane shite you
> are advertising with lengthy explanations ? 
> 
> Obviously _NOT_

Perhaps so, but as Peter Zijlsta has said, compiling with gcc is a
random number generator. Your mileage may vary.

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

The above looks like what I have.

-- Steve


> 
> And further I want to see the tracing gunk in a minimal size so the
> net/core/dev.c deinlining does not happen.
> 
> Thanks,
> 
> 	tglx
> 
> P.S.: It might be helpful and polite if you'd take off your tracing
>       blinkers from time to time.


