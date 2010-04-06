Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0DFTj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:39:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649Ab0DFTjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:39:51 -0400
Date: Tue, 6 Apr 2010 12:35:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <alpine.LFD.2.00.1004061204320.3487@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004061220270.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic> <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com> <1270568096.1814.145.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop> <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <20100406120315.53ad7390.akpm@linux-foundation.org> <alpine.LFD.2.00.1004061204320.3487@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Apr 2010, Linus Torvalds wrote:
> 
> Anyway, I've not actually found anything wrong in the same_vma locking. 
> And I'm not at all convinced there is any list corruption there. My point 
> was really only that
>  (a) the locking rules seem very unclear and certainly not documented and 
>  (b) corruption of one list could easily be the cause of corruption of 
>      another list of the same structure.
> but I don't actually see anything wrong anywhere.

I _have_ found what looks like a few clues, though.

In particular, the disassembly in Steinar Gunderson's case looks much more 
like the disassembly I get, and if I read that correctly, it's actually 
the _first_ iteration of the for_each_entry() loop that crashes.

Why do I think so?

In Steinar's oops, we have "RAX: ffff880169111fc8", which is clearly a 
kernel pointer. However, the code from Steinar's oops decodes to:

   0:	3b 56 10             	cmp    0x10(%rsi),%edx
   3:	73 1e                	jae    0x23
   5:	48 83 fa f2          	cmp    $0xfffffffffffffff2,%rdx
   9:	74 18                	je     0x23
   b:	4d 89 f8             	mov    %r15,%r8
   e:	48 8d 4d cc          	lea    -0x34(%rbp),%rcx
  12:	4c 89 e7             	mov    %r12,%rdi
  15:	e8 44 f2 ff ff       	callq  0xfffffffffffff25e
  1a:	41 01 c5             	add    %eax,%r13d
  1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  21:	74 19                	je     0x3c
  23:	48 8b 43 20          	mov    0x20(%rbx),%rax
  27:	48 8d 58 e0          	lea    -0x20(%rax),%rbx
  2b:*	48 8b 43 20          	mov    0x20(%rbx),%rax     <-- trapping instruction
  2f:	0f 18 08             	prefetcht0 (%rax)
  32:	48 8d 43 20          	lea    0x20(%rbx),%rax
  36:	48 39 45 88          	cmp    %rax,-0x78(%rbp)
  3a:	75 a7                	jne    0xffffffffffffffe3
  3c:	41 fe 06             	incb   (%r14)
  3f:	e9                   	.byte 0xe9

which matches my code pretty well, and the point is, _if_ it went through 
the loop, then %rbx should be %rax+20. And it's not.

IOW, the code you see above before the trapping instruction is the end of 
the loop: it's the

		referenced += page_referenced_one(page, vma, address,
				&mapcount, vm_flags);
		if (!mapcount)
			break;
	}

part (the "callq" and "add %eax" is that "referenced +=", and %r13d is 
"referenced").

What you cannot see from the code decode is the loop setup and _entry_, 
which looks like this for me:

        movl    12(%rbx), %eax  # <variable>.D.11299._mapcount.counter, D.33294
        xorl    %r12d, %r12d    # referenced
        incl    %eax    # tmp89
        movl    %eax, -52(%rbp) # tmp89, mapcount
        leaq    48(%r14), %rax  #,
        movq    48(%r14), %r13  # <variable>.head.next, <variable>.head.next
        movq    %rax, -128(%rbp)        #, %sfp
        subq    $32, %r13       #, avc
        jmp     .L167   #

where that "L167" is actually the oopsing instruction (ie the "while" loop 
has been turned around, and we jump to the end of the loop that does the 
loop end test).

In other words, what is NULL here is not an anon_vma_chain entry, but  
actually the initial "anon_vma->head.next" pointer.

The whole _head_ of the list has never been initialized, in other words.

So we can entirely ignore the 'anon_vma_chain' issues. We need to look at 
the initializations of the 'anon_vma's themselves.

			Linus
