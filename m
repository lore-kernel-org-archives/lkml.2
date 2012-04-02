Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab2DBHEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 03:04:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59463 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2DBHEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 03:04:52 -0400
Date: Mon, 2 Apr 2012 09:04:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH -tip 00/16] in-kernel x86 disassember
Message-ID: <20120402070446.GA12689@gmail.com>
References: <20120401160229.4502.2541.stgit@shimauta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu@gmail.com> wrote:

> Hi,
> 
> Here is a series of patches of the in-kernel x86 disassembler
> for the latest tip tree.
> This will show you a pretty disassembled code instead of
> just a digital code sequence when you gets a kernel panic etc.
> (I know, we also have script/decodecode for the panic use)
> 
> This feature is not for users, but mainly for kernel developers
> who can understand disassembly code of x86 ;). This is just like
> a joke feature in kernel. (yeah, I spend my spare time for this.
> It's my fun :))

Nice :-)

Wrt. testing: just wondering, could we eventually attempt to 
create a user-space testcase for this as well? I.e. if we tried 
to have a switch to emulate objdump output, we could check that 
the in-kernel disassembler outputs the same sequence as objdump 
-d, or so.

[ I realize that this does not cover SSE instructions, which do 
  sometimes occur in the vmlinux - but 99% of the instruction 
  stream is regular and would be a nice testcase. ]

>  - Debugfs disassembler interface for kernel function. You can disassemble
>    running kernel function on-line.

Nice :-)

>  - Panic dump shows disassembly code instead of instruction byte stream.
>    It generates more human-readable report. (I strongly recommend you to
>    add a serial logger if it is enabled :))

This is the most useful short-term practical aspect I suspect.

>  - Disassemble command for KDB. 'dis' command is now available.
>  - User-land disassembly tool.

It would be nice to extend the output beyond the boring GNU 
tooling, for example to auto-label branch targets instead of 
relying on debuginfo.

This could be used for better visualization as well, instead of 
the boring and hard to read GNU output:

ffffffff8175d500 <_raw_spin_lock>:
ffffffff8175d500:	55                   	push   %rbp
ffffffff8175d501:	b8 00 00 01 00       	mov    $0x10000,%eax
ffffffff8175d506:	48 89 e5             	mov    %rsp,%rbp
ffffffff8175d509:	f0 0f c1 07          	lock xadd %eax,(%rdi)
ffffffff8175d50d:	89 c2                	mov    %eax,%edx
ffffffff8175d50f:	c1 ea 10             	shr    $0x10,%edx
ffffffff8175d512:	66 39 c2             	cmp    %ax,%dx
ffffffff8175d515:	74 13                	je     ffffffff8175d52a <_raw_spin_lock+0x2a>
ffffffff8175d517:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
ffffffff8175d51e:	00 00 
ffffffff8175d520:	f3 90                	pause  
ffffffff8175d522:	0f b7 07             	movzwl (%rdi),%eax
ffffffff8175d525:	66 39 d0             	cmp    %dx,%ax
ffffffff8175d528:	75 f6                	jne    ffffffff8175d520 <_raw_spin_lock+0x20>
ffffffff8175d52a:	5d                   	pop    %rbp
ffffffff8175d52b:	c3                   	retq   
ffffffff8175d52c:	0f 1f 40 00          	nopl   0x0(%rax)

the default 'human readable' output could be something much more 
intelligent, like:

<_raw_spin_lock>:
             push       %rbp
             mov        $0x10000, %eax
             mov        %rsp, %rbp
             lock xadd  %eax, (%rdi)
             mov        %eax, %edx
             shr        $0x10, %edx
             cmp        %ax, %dx
             je         L2       #-----------------------------.
             nop-7                                             |
                                                               |
L1:          pause                          <-------------.    |
             movzwl     (%rdi), %eax                      |    |
             cmp        %dx, %ax                          |    |
             jne        L1       #------------------------'    |
                                                               |
L2:          pop        %rbp                <------------------'
             retq

This is much more readable, right? Yet it carries all the 
essential information that the original output one carried.

If vector instructions (SEE, MMX, AVX) are in your list to 
support then it would be and interesting use to combine this 
with perf on x86 - which uses objdump right now. Perf could use 
a programmatic, librarized disassembler for its assembly 
annotation code.

That would allow new UI features like:

 - proper highlighting of jump/branch instructions and 
   navigation along branch instructions (and visualization of 
   possible execution flow) as well.

 - register modification and lifetime highlighting. If I click 
   on 'rax' then the output could show how this register gets 
   touched by the code, explicitly and implicitly (a common 
   assembly coding pitfall)

 - summarization of usually irrelevant details, like the nop-7 
   example above.

Another very interesting usecase would be to invert it and 
create a simpler parser and an in-kernel *assembler*: a GAS 
replacement in essence. We could build the kernel using its own 
assembler.

That could also be used for safe sandboxing: the disassembler 
could be combined with the assembler to ensure that binary code 
submitted to the kernel is 'safe' to execute - even in 
kernel-space. A sha1 hash could be used to cache already 
checked, 'safe' modules of code.

Thanks,

	Ingo
