Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2DNA7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 20:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab2DNA7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 20:59:33 -0400
Date: Fri, 13 Apr 2012 21:59:21 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
Message-ID: <20120414005921.GA22114@infradead.org>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>
 <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 13, 2012 at 11:25:50AM -0700, Linus Torvalds escreveu:
> On Fri, Apr 13, 2012 at 11:07 AM, tip-bot for Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> >
> > The offset view will be the default as soon as operations that deal with
> > offsets in a function are handled accodringly, i.e. in offset view the
> > above will become:
> >
> >     2f:       jne    __list_del_entry+0x84
> > <SNIP>
> >     84:       mov    %rdi,%rcx
> 
> Oh, please please please make this happen.

I will in the next days. Glad you like it.
 
> Also, if at all possible, please mark offsets that are referenced by a
> branch some way. I do think that the "size of instruction" can be a
> very valid piece of information when looking at instruction-level
> profiles, but quite frankly, I'm also 100% sure that the fact that an
> instruction is a branch target is *more* important.
> 
> Now, fancy arrows etc might be too hard to do (especially without
> cluttering things up too much), but marking just the targets would
> already be lovely. IOW, turn this mess:
> 
> 
>          :        ffffffff810d7e80 <kmem_cache_free>:
>     1.91 :        ffffffff810d7e80:       push   %rbp
>     0.05 :        ffffffff810d7e81:       mov    %rsp,%rbp
>     2.02 :        ffffffff810d7e84:       push   %r12
>     0.00 :        ffffffff810d7e86:       mov    %rdi,%r12
>     0.55 :        ffffffff810d7e89:       push   %rbx
>     0.00 :        ffffffff810d7e8a:       mov    %rsi,%rdi
>     1.20 :        ffffffff810d7e8d:       mov    %rsi,%rbx
>     1.64 :        ffffffff810d7e90:       callq  ffffffff8102a730 <__phys_addr>
>     0.05 :        ffffffff810d7e95:       movabs $0xffffea0000000000,%rdi
>     0.22 :        ffffffff810d7e9f:       shr    $0xc,%rax
>     0.11 :        ffffffff810d7ea3:       shl    $0x6,%rax
>     1.64 :        ffffffff810d7ea7:       lea    (%rax,%rdi,1),%rdi
>    42.80 :        ffffffff810d7eab:       mov    (%rdi),%rax
>     2.02 :        ffffffff810d7eae:       test   $0x80,%ah
>     0.00 :        ffffffff810d7eb1:       jne    ffffffff810d7ef6
> <kmem_cache_free+0x76>
>     0.22 :        ffffffff810d7eb3:       mov    0x8(%rbp),%r9
>     7.14 :        ffffffff810d7eb7:       mov    (%r12),%rax
>     0.65 :        ffffffff810d7ebb:       add    %gs:0xcb88,%rax
>     4.58 :        ffffffff810d7ec4:       mov    0x8(%rax),%rdx
> 
> (which has tons of unnecessary white-space too - shades of G+) into

Grin ;-)

Yeah, even the : column isn't needed I think.
 
> <kmem_cache_free>:
>     1.91 :          push   %rbp
>     0.05 :          mov    %rsp,%rbp
>     2.02 :          push   %r12
>     0.00 :          mov    %rdi,%r12
>     0.55 :          push   %rbx
>     0.00 :          mov    %rsi,%rdi
>     1.20 :          mov    %rsi,%rbx
>     1.64 :          callq  ffffffff8102a730 <__phys_addr>
>     0.05 :          movabs $0xffffea0000000000,%rdi
>     0.22 :          shr    $0xc,%rax
>     0.11 :          shl    $0x6,%rax
>     1.64 :          lea    (%rax,%rdi,1),%rdi
>    42.80 :          mov    (%rdi),%rax
>     2.02 :          test   $0x80,%ah
>     0.00 :          jne    kmem_cache_free+0x76
>     0.22 : 0x33:    mov    0x8(%rbp),%r9
>     7.14 : 0x37:    mov    (%r12),%rax
>     0.65 :          add    %gs:0xcb88,%rax
>     4.58 :          mov    0x8(%rax),%rdx
>    ....
> 
> or something. I think the "callq  ffffffff8102a730 <__phys_addr>"
> could also be prettified with *zero* downside.

Yeah, no need to see the address in default mode.
 
> Sure, leave some magic keycombination to get the "full information", but ..

Yeah, we have o to toggle offset view + s to toggle source code view,
etc. 

>                       Linus
