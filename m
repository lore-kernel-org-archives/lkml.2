Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1GORYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:24:53 -0400
Received: from claw.goop.org ([74.207.240.146]:59999 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab1GORYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:24:51 -0400
Message-ID: <4E2077E1.4060606@goop.org>
Date: Fri, 15 Jul 2011 10:24:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate
 code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <4E0506A8.3010102@zytor.com> <4E0512BC.5010900@goop.org> <1ade2577-044b-4391-a607-91a4a989c3ff@email.android.com>
In-Reply-To: <1ade2577-044b-4391-a607-91a4a989c3ff@email.android.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 08:15 PM, H. Peter Anvin wrote:
>>> Could you give us the delta in *compiled* code size?
>> Sure.  Do you mean for the individual lock sequences, or for the
>> overall
>> kernel?
>>
>>    J
> Overall is fine.

Here's both ;)

For the NR_CPUS < 256 case, it shrinks the kernel text by a little over
1k (and a bit of a data reduction too?):

   text	   data	    bss	    dec	    hex	filename
7287009	1915524	2347008	11549541	 b03b65	vmlinux-spin-base
7285777	1915412	2347008	11548197	 b03625	vmlinux-cleantick

A comparison of spin_lock before:

<do_raw_spin_lock>:
        55                      push   %rbp
        48 89 e5                mov    %rsp,%rbp
        e8 6f fa 3d 00          callq  <mcount>
        b8 00 01 00 00          mov    $0x100,%eax
        f0 66 0f c1 07          lock xadd %ax,(%rdi)
1:      38 e0                   cmp    %ah,%al
        74 06                   je     2f
        f3 90                   pause  
        8a 07                   mov    (%rdi),%al
        eb f6                   jmp    1b
2:      5d                      pop    %rbp
        c3                      retq   

and after:

<do_raw_spin_lock>:
        55                      push   %rbp
        48 89 e5                mov    %rsp,%rbp
        e8 1f f6 3d 00          callq  <mcount>
        b8 00 01 00 00          mov    $0x100,%eax
        f0 66 0f c1 07          lock xadd %ax,(%rdi)
        0f b6 d4                movzbl %ah,%edx
1:      38 d0                   cmp    %dl,%al
        74 06                   je     2f
        f3 90                   pause  
        8a 07                   mov    (%rdi),%al
        eb f6                   jmp    1b
2:      5d                      pop    %rbp
        c3                      retq   

IOW the generated code is identical except that the original has "cmp %ah,%al" and
the compiler generates
	movzbl %ah,%edx
	cmp    %dl,%al

I posted a bug about gcc not generating cmp %ah, %al in this case, but the general consensus was that
it's not a good choice on current Intel chips, because it causes a partial word stall, and that the
current generated code is better.  (And gcc can generate "cmp %Xh, %Xl" if it wants to - see below.)

Likewise trylock before:

<do_raw_spin_trylock>:
        55                      push   %rbp
        48 89 e5                mov    %rsp,%rbp
        e8 50 fa 3d 00          callq  <mcount>
        0f b7 07                movzwl (%rdi),%eax
        38 e0                   cmp    %ah,%al
        8d 90 00 01 00 00       lea    0x100(%rax),%edx
        75 05                   jne    1f
        f0 66 0f b1 17          lock cmpxchg %dx,(%rdi)
1:      0f 94 c2                sete   %dl
        0f b6 c2                movzbl %dl,%eax
        5d                      pop    %rbp
        c3                      retq   

and after:

<do_raw_spin_trylock>:
        55                      push   %rbp
        48 89 e5                mov    %rsp,%rbp
        e8 fd f5 3d 00          callq  <mcount>
        31 c0                   xor    %eax,%eax
        66 8b 17                mov    (%rdi),%dx
        38 d6                   cmp    %dl,%dh
        75 16                   jne    1f
        8d 8a 00 01 00 00       lea    0x100(%rdx),%ecx
        89 d0                   mov    %edx,%eax
        f0 66 0f b1 0f          lock cmpxchg %cx,(%rdi)
        66 39 d0                cmp    %dx,%ax
        0f 94 c0                sete   %al
        0f b6 c0                movzbl %al,%eax
1:      5d                      pop    %rbp
        c3                      retq   


The differences here are a little more extensive, but the code is
broadly comparable.   Some interesting points on the gcc code:

    * it pre-loads the failure return value, so it doesn't need to use
      sete unless its actually doing the cmpxchg - whether this is good
      or not depends on how often trylock fails vs succeeds, but is
      pretty minor either way
    * it generates a 16 bit load, rather than using zero extending
      32-bit load
    * it *can* generate a "cmp %dl,%dh" if it wants to
    * it ends up re-comparing the "old" and "new" values after cmpxchg
      rather than reusing the flags it sets.  This could be fixed by
      having a cmpxchg() variant which returns a flag rather than old,
      which would be generally useful since most cmpxchg() callers end
      up doing that comparison anyway.

spin_unlock is a little trickier to compare because it's inlined, but
I'm guessing that's the source of the code shrinkage.

Likewise, for NR_CPUS=512, there's a ~900 byte kernel shrinkage with the
new code:

   text	   data	    bss	    dec	    hex	filename
7296571	1945380	2424832	11666783	 b2055f	vmlinux-spin-base-big
7295610	1945412	2424832	11665854	 b201be	vmlinux-cleantick-big

The generated code for do_raw_spin_lock is even closer:

Before:

<do_raw_spin_lock>:
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       e8 cf 0a 3e 00          callq  <mcount>
       b8 00 00 01 00          mov    $0x10000,%eax
       f0 0f c1 07             lock xadd %eax,(%rdi)
       0f b7 d0                movzwl %ax,%edx
       c1 e8 10                shr    $0x10,%eax
1:     39 c2                   cmp    %eax,%edx
       74 07                   je     2f
       f3 90                   pause  
       0f b7 17                movzwl (%rdi),%edx
       eb f5                   jmp    1b
2:     5d                      pop    %rbp
       c3                      retq   

After:

<do_raw_spin_lock>:
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       e8 63 07 3e 00          callq  <mcount>
       b8 00 00 01 00          mov    $0x10000,%eax
       f0 0f c1 07             lock xadd %eax,(%rdi)
       89 c2                   mov    %eax,%edx
       c1 ea 10                shr    $0x10,%edx
1:     66 39 d0                cmp    %dx,%ax
       74 07                   je     2f
       f3 90                   pause  
       66 8b 07                mov    (%rdi),%ax
       eb f4                   jmp    1b
2:     5d                      pop    %rbp
       c3                      retq   

In other words, identical aside from using 16 bit regs rather than 32
bit regs and zero extend.

Trylock:

Before:

<do_raw_spin_trylock>:
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       e8 aa 0a 3e 00          callq  <mcount>
       8b 07                   mov    (%rdi),%eax
       89 c2                   mov    %eax,%edx
       c1 c0 10                rol    $0x10,%eax
       39 c2                   cmp    %eax,%edx
       8d 90 00 00 01 00       lea    0x10000(%rax),%edx
       75 04                   jne    1f
       f0 0f b1 17             lock cmpxchg %edx,(%rdi)
1:     0f 94 c2                sete   %dl
       0f b6 c2                movzbl %dl,%eax
       5d                      pop    %rbp
       c3                      retq   

After:

<do_raw_spin_trylock>:
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       e8 3e 07 3e 00          callq  <mcount>
       31 c0                   xor    %eax,%eax
       8b 17                   mov    (%rdi),%edx
       89 d1                   mov    %edx,%ecx
       c1 e9 10                shr    $0x10,%ecx
       66 39 ca                cmp    %cx,%dx
       75 14                   jne    1f
       8d 8a 00 00 01 00       lea    0x10000(%rdx),%ecx
       89 d0                   mov    %edx,%eax
       f0 0f b1 0f             lock cmpxchg %ecx,(%rdi)
       39 d0                   cmp    %edx,%eax
       0f 94 c0                sete   %al
       0f b6 c0                movzbl %al,%eax
1:     5d                      pop    %rbp
       c3                      retq   

The differences here are similar to the < 256 CPU case:

    * gcc generates a straightforward shift and 16-bit compare to
      compare the head and tail, rather than the rol version (which I
      guess keeps everything 32b)
    * same pre-loading the failure return value rather than reusing sete
    * same redundant compare after cmpxchg


So conclusion:

    * overall kernel code size reduction
    * the spinlock code is very similar
    * the trylock code could be improved a little, but its unclear to me
      that it would make much difference (since there's a big fat locked
      cmpxchg in the middle of any interesting code path)
    * unlock is inlined, so I couldn't evaluate that, but since its just
      an unlocked inc, its hard to see how that could go wrong.

    J
