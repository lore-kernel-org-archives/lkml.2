Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1CWVOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:14:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37942 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab1CWVOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:14:50 -0400
Date: Wed, 23 Mar 2011 22:14:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Eric Paris <eparis@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        linux-kbuild@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: PATCH][RFC][resend] CC_OPTIMIZE_FOR_SIZE should default to N
Message-ID: <20110323211415.GA8791@elte.hu>
References: <alpine.LNX.2.00.1103212105490.15815@swampdragon.chaosbits.net>
 <AANLkTinmAJsXy=iJ5Fq-+CLTAGXTtLGhULRUf=Q1rkY1@mail.gmail.com>
 <20110322102741.GA4448@elte.hu>
 <AANLkTikz+vJGFuysDXAdVb33q1q3L547dXNJa9NmeqeM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikz+vJGFuysDXAdVb33q1q3L547dXNJa9NmeqeM@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Mar 22, 2011 at 3:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > If that situation has changed - if GCC has regressed in this area then a commit
> > changing the default IMHO gains a lot of credibility if it is backed by careful
> > measurements using perf stat --repeat or similar tools.
> 
> Also, please don't back up any numbers for the "-O2 is faster than
> -Os" case with some benchmark that is hot in the caches.
> 
> The thing is, many optimizations that make the code larger look really
> good if there are no cache misses, and the code is run a million times
> in a tight loop.
> 
> But kernel code in particular tends to not be like that. [...]

To throw some numbers into the discussion, here's the size versus speed 
comparison for 'hackbench 15' - which is more on the microbenchmark side of the 
equation - but has macrobenchmark properties as well, because it runs 3000 
tasks and moves a lot of data, hence thrashes the caches constantly:

     CONFIG_CC_OPTIMIZE_FOR_SIZE=y
     ----------------------------------------
     6,757,858,145 cycles                   #   2525.983 M/sec   ( +-   0.388% )
     2,949,907,036 instructions             #      0.437 IPC     ( +-   0.191% )
       595,955,367 branches                 #    222.759 M/sec   ( +-   0.238% )
        31,504,981 branch-misses            #      5.286 %       ( +-   0.187% )

        0.164320722  seconds time elapsed   ( +-   0.524% )


     # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
     ----------------------------------------
     6,061,867,073 cycles                   #   2510.283 M/sec   ( +-   0.494% )
     2,510,505,732 instructions             #      0.414 IPC     ( +-   0.243% )
       493,721,089 branches                 #    204.455 M/sec   ( +-   0.302% )
        38,731,708 branch-misses            #      7.845 %       ( +-   0.206% )

        0.148203574  seconds time elapsed   ( +-   0.673% )

They were perf stat --repeat 100 runs - repeated a couple of times to make sure 
it's all real. I have used GCC 4.6.0, a relatively recent compiler. (64-bit 
x86, typical .config, etc.)

The text size differences:

      text	   data	    bss	    dec	         filename
  -------------------------------------------------------------------------
   8809558	1790428	2719744	13319730	 vmlinux.optimize_for_size
  10268082	1825292	2727936	14821310	 vmlinux.optimize_for_speed

So by enabling CONFIG_CC_OPTIMIZE_FOR_SIZE=y, we get this total effect:

  -16.5% text size reduction
  +17.5% instruction count increase
  +20.7% branches executed increase
  -22.9% branch-miss reduction
  +11.5% cycle count increase
  +10.8% total runtime increase

A few observations:

 - the branch-miss reduction suggests that almost none of the new branches
   introduced by -Os generates a branch miss.

 - the cycles count increase is in line with the total runtime increase.

 - workloads where 16.5% more instruction cache footprint slows down the 
   workload by more than ~11% would win from enabling 
   CONFIG_CC_OPTIMIZE_FOR_SIZE=y.

Looking at these numbers i became more pessimistic about the usefulness of the 
current implementation of CONFIG_CC_OPTIMIZE_FOR_SIZE=y - it would need some 
*serious* icache thrashing to cause a larger than 11% slowdown, right?

I'm not sure what the best way would be to measure a realistic macro workloads 
where the kernel's instructions generate a lot of instruction-cache misses. 
Most of the 'real' workloads tend to be hard to measure precisely, tend to be 
very noisy and take a long time to run.

I could perhaps try to simulate them: i could patch a debug-only 'icache 
flusher' function into every system call, and compare the perf stat results - 
would that be an acceptable simulation of cache-cold kernel execution?

The 'icache flusher' would be something simple, like 10,000x 5-byte NOP 
instructions in a row, or so. This would slow things down immensely, but this 
particular slowdown is the same for both OPTIMIZE_FOR_SIZE=y and 
OPTIMIZE_FOR_SIZE=n.

Any better ideas?

	Ingo
