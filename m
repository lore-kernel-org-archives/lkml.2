Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab1DWID1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 04:03:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab1DWIDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 04:03:21 -0400
Date: Sat, 23 Apr 2011 10:02:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: arun@sharma-home.net, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110423080258.GA14952@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
 <20110423000347.GC9328@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110423000347.GC9328@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Andi Kleen <ak@linux.intel.com> wrote:

> > > Yes, and note that with instructions events we even have skid-less PEBS 
> > > profiling so seeing the precise .
> >                                   - location of instructions is possible.
> 
> It was better when it was eaten. PEBS does not actually eliminated
> skid unfortunately. The interrupt still occurs later, so the
> instruction location is off.
> 
> PEBS merely gives you more information.

Have you actually tried perf's PEBS support feature? Try:

  perf record -e instructions:pp ./myapp

(the ':pp' postfix stands for 'precise' and activates PEBS+LBR tricks.)

Look at the perf report --tui annotated asssembly output (or check 'perf 
annotate' directly) and see how precise and skid-less the hits are. Works 
pretty well on Nehalem.

Here's a cache-bound loop with skid (profiled with '-e instructions'):

         :	0000000000400390 <main>:
    0.00 :	  400390:       31 c0                   xor    %eax,%eax
    0.00 :	  400392:       eb 22                   jmp    4003b6 <main+0x26>
   12.08 :	  400394:       fe 84 10 50 08 60 00    incb   0x600850(%rax,%rdx,1)
   87.92 :	  40039b:       48 81 c2 10 27 00 00    add    $0x2710,%rdx
    0.00 :	  4003a2:       48 81 fa 00 e1 f5 05    cmp    $0x5f5e100,%rdx
    0.00 :	  4003a9:       75 e9                   jne    400394 <main+0x4>
    0.00 :	  4003ab:       48 ff c0                inc    %rax
    0.00 :	  4003ae:       48 3d 10 27 00 00       cmp    $0x2710,%rax
    0.00 :	  4003b4:       74 04                   je     4003ba <main+0x2a>
    0.00 :	  4003b6:       31 d2                   xor    %edx,%edx
    0.00 :	  4003b8:       eb da                   jmp    400394 <main+0x4>
    0.00 :	  4003ba:       31 c0                   xor    %eax,%eax

Those 'ADD' instruction hits are bogus: 99% of the cost in this function is in 
the INCB, but the PMU NMI often skids to the next (few) instructions.

Profiled with "-e instructions:pp" we get:

         :	0000000000400390 <main>:
    0.00 :	  400390:       31 c0                   xor    %eax,%eax
    0.00 :	  400392:       eb 22                   jmp    4003b6 <main+0x26>
   85.33 :	  400394:       fe 84 10 50 08 60 00    incb   0x600850(%rax,%rdx,1)
    0.00 :	  40039b:       48 81 c2 10 27 00 00    add    $0x2710,%rdx
   14.67 :	  4003a2:       48 81 fa 00 e1 f5 05    cmp    $0x5f5e100,%rdx
    0.00 :	  4003a9:       75 e9                   jne    400394 <main+0x4>
    0.00 :	  4003ab:       48 ff c0                inc    %rax
    0.00 :	  4003ae:       48 3d 10 27 00 00       cmp    $0x2710,%rax
    0.00 :	  4003b4:       74 04                   je     4003ba <main+0x2a>
    0.00 :	  4003b6:       31 d2                   xor    %edx,%edx
    0.00 :	  4003b8:       eb da                   jmp    400394 <main+0x4>
    0.00 :	  4003ba:       31 c0                   xor    %eax,%eax

The INCB has the most hits as expected - but we also learn that there's 
something about the CMP.

Thanks,

	Ingo
