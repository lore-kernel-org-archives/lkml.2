Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab2D0IGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:06:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60339 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819Ab2D0IGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:06:19 -0400
Date: Fri, 27 Apr 2012 10:06:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
Message-ID: <20120427080613.GA7359@gmail.com>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
 <20120427072153.GB4766@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120427072153.GB4766@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> [...]
> 
> This would require for us to draw all loops that are 
> interesting: probably all backwards jumping ones, with some 
> nesting limit of 5 or so. I think we really need this loop 
> graph for this UI to have low visual overhead :-/
> 
> Beyond improving visual stability of the output, this would 
> also obviously be (much) more informative as for reasonably 
> sized functions it would show all the current loop contexts - 
> which is very useful when one tries to make sense of a 
> function in assembly.

My (silent) hope would be that if we make assembly output more 
obvious, more structured visually then more people will read 
assembly code.

Note that once we have loop nesting there are countless other 
possibilities as well to augment the output.

( Note that I pile on a couple of visual suggestions below - so 
  the output becomes more and more complex - ideally we want to 
  pick the ones from below that we like and skip the ones that 
  are not so good. )

1) Loop grouping

We could slightly group the assembly instructions themselves 
as well:

    0.00 │       ↓ jmp    cc
    0.00 │         nopl   0x0(%rax)
         │
    0.00 │┌─→ c0:  cmp    %rax,%rbx
    0.00 ││        mov    %rax,%rcx
    0.00 ││      ↓ je     5dd
    0.00 ││   cc:  test   %rcx,%rcx
    0.00 ││      ↓ je     da
    0.00 ││        mov    0x8(%rcx),%esi
    0.00 ││        shr    $0x4,%esi
    0.00 ││        sub    $0x2,%esi
    0.00 ││   da:  mov    %rcx,0x10(%rbx)
    0.00 ││        mov    %rcx,%rax
    0.00 ││        cmpl   $0x0,%fs:0x18
    0.00 ││      ↓ je     ed
    0.00 ││        lock   cmpxchg %rbx,(%rdx)
    0.00 ││        cmp    %rax,%rcx
    0.00 │└──────↑ jne    c0
         │
    0.00 │         test   %rcx,%rcx
    0.00 │       ↓ je     104
    0.00 │         cmp    %r12d,%esi
    0.00 │       ↓ jne    719

See that by using a newline how much clearer the loop stands 
out, visually?

2) Nesting

The classic C method to show nesting is to use curly braces and 
slight indentation:

    0.00 │       ↓ jmp    cc
    0.00 │         nopl   0x0(%rax)
         │
         │         {
    0.00 │┌─→ c0:    cmp    %rax,%rbx
    0.00 ││          mov    %rax,%rcx
    0.00 ││      ↓   je     5dd
    0.00 ││   cc:    test   %rcx,%rcx
    0.00 ││      ↓   je     da
    0.00 ││          mov    0x8(%rcx),%esi
    0.00 ││          shr    $0x4,%esi
    0.00 ││          sub    $0x2,%esi
    0.00 ││   da:    mov    %rcx,0x10(%rbx)
    0.00 ││          mov    %rcx,%rax
    0.00 ││          cmpl   $0x0,%fs:0x18
    0.00 ││      ↓   je     ed
    0.00 ││          lock   cmpxchg %rbx,(%rdx)
    0.00 ││          cmp    %rax,%rcx
         ││
    0.00 │└──────↑ } jne    c0
         │
    0.00 │         test   %rcx,%rcx
    0.00 │       ↓ je     104
    0.00 │         cmp    %r12d,%esi
    0.00 │       ↓ jne    719

3) Separating out forward conditional jumps

    0.00 │       ↓ jmp    cc
    0.00 │         nopl   0x0(%rax)
         │
         │         {
    0.00 │┌─→ c0:    cmp    %rax,%rbx
    0.00 ││          mov    %rax,%rcx
    0.00 ││      ↓   .je    5dd
    0.00 ││   cc:    test   %rcx,%rcx
    0.00 ││      ↓   .je    da
    0.00 ││          mov    0x8(%rcx),%esi
    0.00 ││          shr    $0x4,%esi
    0.00 ││          sub    $0x2,%esi
    0.00 ││   da:    mov    %rcx,0x10(%rbx)
    0.00 ││          mov    %rcx,%rax
    0.00 ││          cmpl   $0x0,%fs:0x18
    0.00 ││      ↓   .je    ed
    0.00 ││          lock   cmpxchg %rbx,(%rdx)
    0.00 ││          cmp    %rax,%rcx
         ││
    0.00 │└──────↑ } jne    c0
         │
    0.00 │         test   %rcx,%rcx
    0.00 │       ↓ .je    104
    0.00 │         cmp    %r12d,%esi
    0.00 │       ↓ .jne   719

So the forward conditional jumps get moved by one character to 
the right and get prefixed with '.', which has the following 
effects:

 - the flow of all the 'other', register modifying and loop 
   instructions can be seen more clearly

 - the 'exception' forward conditional jumps get moved into the 
   visual background, slightly.

 - blocks of instructions with no branches amongst them are more 
   clearly visible.

If '.' is too aggressive or too confusing then some other 
(possibly graphical) character could be used as well?

4) Marking labels

I'd argue we bring in <ab> as label markers:

    0.00 │       ↓ jmp    <cc>
    0.00 │         nopl   0x0(%rax)
         │
         │         {
    0.00 │┌─→ c0:    cmp    %rax,%rbx
    0.00 ││          mov    %rax,%rcx
    0.00 ││      ↓   .je    <5dd>
    0.00 ││   cc:    test   %rcx,%rcx
    0.00 ││      ↓   .je    <da>
    0.00 ││          mov    0x8(%rcx),%esi
    0.00 ││          shr    $0x4,%esi
    0.00 ││          sub    $0x2,%esi
    0.00 ││   da:    mov    %rcx,0x10(%rbx)
    0.00 ││          mov    %rcx,%rax
    0.00 ││          cmpl   $0x0,%fs:0x18
    0.00 ││      ↓   .je    <ed>
    0.00 ││          lock   cmpxchg %rbx,(%rdx)
    0.00 ││          cmp    %rax,%rcx
         ││
    0.00 │└──────↑ } jne    <c0>
         │
    0.00 │         test   %rcx,%rcx
    0.00 │       ↓ .je    <104>
    0.00 │         cmp    %r12d,%esi
    0.00 │       ↓ .jne   <719>

Note how much easier it becomes to read the body of the loop: 
the <> labels are clearly separated from constants/offsets 
within the other assembly instructions. In the current output 
the two easily 'mix', which is bad.

5)

Another trick we could use to separate labels from constants 
more clearly is capitalization:

    0.00 │       ↓ jmp    <CC>
    0.00 │         nopl   0x0(%rax)
         │
         │         {
    0.00 │┌─→ C0:    cmp    %rax,%rbx
    0.00 ││          mov    %rax,%rcx
    0.00 ││      ↓   .je    <5DD>
    0.00 ││   CC:    test   %rcx,%rcx
    0.00 ││      ↓   .je    <DA>
    0.00 ││          mov    0x8(%rcx),%esi
    0.00 ││          shr    $0x4,%esi
    0.00 ││          sub    $0x2,%esi
    0.00 ││   DA:    mov    %rcx,0x10(%rbx)
    0.00 ││          mov    %rcx,%rax
    0.00 ││          cmpl   $0x0,%fs:0x18
    0.00 ││      ↓   .je    <ED>
    0.00 ││          lock   cmpxchg %rbx,(%rdx)
    0.00 ││          cmp    %rax,%rcx
         ││
    0.00 │└──────↑ } jne    <C0>
         │
    0.00 │         test   %rcx,%rcx
    0.00 │       ↓ .je    <104>
    0.00 │         cmp    %r12d,%esi
    0.00 │       ↓ .jne   <719>

I'm not entirely convinced we want this one.

6) Making callq's to function symbols more C-alike

Before:

    0.00 ││  70:  mov    %rbx,%rdi
    0.00 ││       callq  _IO_switch_to_main_get_area
    0.00 ││       mov    0x8(%rbx),%rdx
    0.00 ││       mov    0x10(%rbx),%rsi
    0.00 ││       cmp    %rsi,%rdx

After:

    0.00 ││  70:  mov    %rbx,%rdi
    0.00 ││       callq  _IO_switch_to_main_get_area()
    0.00 ││       mov    0x8(%rbx),%rdx
    0.00 ││       mov    0x10(%rbx),%rsi
    0.00 ││       cmp    %rsi,%rdx

The () makes it easier to separate the 'function' purpose of the 
symbol.

This would be especially useful once we start looking into 
debuginfo data and start symbolising stack frame offsets and 
data references:

Before:

    0.00 │   1b3:  mov    -0x38(%rbp),%rdx
    0.00 │         mov    -0x34(%rbp),%rcx
    0.00 │         mov    0x335fb4(%rip),%eax        # 392a5b0b60 <perturb_byte>

After:

  #
  # PARAM:idx          : 0x38
  # PARAM:addr         : 0x34
  # DATA:perturb_byte  : 0x392a5b0b60
  #

  ...

    0.00 │   1b3:  mov    P:idx....(%rbp),%rdx
    0.00 │         mov    P:addr...(%rbp),%rcx
    0.00 │         mov    D:pertu..(%rip),%eax

Where 'P:' stands for parameter, 'D:' for data, and the symbol 
names are length-culled to a fixed width 6 chars, to make the 
registers align better and to not interfere with other textual 
output. There's a summary at the top, to still have all the raw 
binary data available - but 'o' can be pressed as well to see 
the raw values.

This way it still looks like assembly - but is *much* more 
informative.

Or so.

Thanks,

	Ingo
