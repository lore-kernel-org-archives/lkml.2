Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1LPMCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 07:02:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45770 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1LPMCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 07:02:16 -0500
Date: Fri, 16 Dec 2011 13:00:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alexander van Heukelum <heukelum@fastmail.fm>, fweisbec@gmail.com,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
Message-ID: <20111216120001.GA27801@elte.hu>
References: <20111216081915.GA28288@elte.hu>
 <20111216085259.GA2338@elte.hu>
 <4EEB0E14.9050505@goop.org>
 <4EEB3D8B0200007800068759@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEB3D8B0200007800068759@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 16.12.11 at 10:23, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > On 12/16/2011 12:53 AM, Ingo Molnar wrote:
> >> * Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >>> [...]
> >>>
> >>> The call-chains are still intact for quality backtraces 
> >>> and for call-chain profiling (perf record -g), as the 
> >>> backtrace walker can deduct the full backtrace from the 
> >>> RIP of a leaf function and the parent chain.
> 
> Are you sure about that even if the leaf function uses rBP for 
> a different purpose?

Well, i assumed that GCC does not mess with %bp in leaf 
functions - a frame pointer is barely useful if it's destroyed 
spuriously in leaf functions.

A quick grep of the assembly appears to support that assumption:

 $ objdump -d vmlinux | grep ',%rbp$' | cut -d: -f2- | sort | uniq -c | sort -n | tail -10

      3 	48 89 d5             	mov    %rdx,%rbp
      3 	4c 89 cd             	mov    %r9,%rbp
      4 	48 0f 45 e8          	cmovne %rax,%rbp
      4 	48 83 cd ff          	or     $0xffffffffffffffff,%rbp
      5 	4c 89 dd             	mov    %r11,%rbp
      7 	48 21 fd             	and    %rdi,%rbp
     10 	48 d3 e5             	shl    %cl,%rbp
     14 	48 85 ed             	test   %rbp,%rbp
     14 	48 8b 6c 24 20       	mov    0x20(%rsp),%rbp
  31042 	48 89 e5             	mov    %rsp,%rbp

%rbp is not touched, except in a few special assembly glue/entry 
pieces of code.

> >> Hm, noticed one complication while looking at annotated 
> >> assembly code in perf top. Code doing function calls from 
> >> within asm() is incorrectly marked 'leaf' by GCC:
> >>
> >> ffffffff812b82d8 <arch_local_save_flags>:
> >> ffffffff812b82d8:       ff 14 25 00 d9 c1 81    callq  *0xffffffff81c1d900
> >> ffffffff812b82df:       c3                      retq   
> >>
> >> So all the paravirt details will have to be fixed, so that 
> >> GCC is able to see that there's a real function call done 
> >> inside. Jeremy, Konrad?
> 
> If the above is not a problem, wouldn't this simply result in 
> a skipped function layer?

Yeah - i guess we can live with that, as long as the frame 
pointer chain is otherwise usable and walkable.

Thanks,

	Ingo
