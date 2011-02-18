Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab1BRQ0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:26:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab1BRQ0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:26:51 -0500
Date: Fri, 18 Feb 2011 17:26:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, ananth@in.ibm.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] kprobes - do not allow optimized kprobes in entry code
Message-ID: <20110218162619.GA9425@jolsa.brq.redhat.com>
References: <1297696354-6990-1-git-send-email-jolsa@redhat.com>
 <4D5A4A66.4010503@hitachi.com>
 <20110215123058.GB3135@jolsa.brq.redhat.com>
 <4D5AA209.7070309@hitachi.com>
 <20110215170507.GD3135@jolsa.brq.redhat.com>
 <4D5B4654.30407@hitachi.com>
 <20110217151103.GA11156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217151103.GA11156@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 04:11:03PM +0100, Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > (2011/02/16 2:05), Jiri Olsa wrote:
> > > You can crash the kernel using kprobe tracer by running:
> > > 
> > > echo "p system_call_after_swapgs" > ./kprobe_events
> > > echo 1 > ./events/kprobes/enable
> > > 
> > > The reason is that at the system_call_after_swapgs label, the kernel
> > > stack is not set up. If optimized kprobes are enabled, the user space
> > > stack is being used in this case (see optimized kprobe template) and
> > > this might result in a crash.
> > > 
> > > There are several places like this over the entry code (entry_$BIT).
> > > As it seems there's no any reasonable/maintainable way to disable only
> > > those places where the stack is not ready, I switched off the whole
> > > entry code from kprobe optimizing.
> > 
> > Agreed, and this could be the best way, because kprobes can not
> > know where the kernel stack is ready without this text section.
> 
> The only worry would be that if we move the syscall entry code out of the regular 
> text section fragments the icache layout a tiny bit, possibly hurting performance.
> 
> It's probably not measurable, but we need to measure it:
> 
> Testing could be done of some syscall but also cache-intense workload, like 
> 'hackbench 10', via perf 'stat --repeat 30' and have a very close look at 
> instruction cache eviction differences.
> 
> Perhaps also explicitly enable measure one of these:
> 
>   L1-icache-loads                            [Hardware cache event]
>   L1-icache-load-misses                      [Hardware cache event]
>   L1-icache-prefetches                       [Hardware cache event]
>   L1-icache-prefetch-misses                  [Hardware cache event]
> 
>   iTLB-loads                                 [Hardware cache event]
>   iTLB-load-misses                           [Hardware cache event]
> 
> to see whether there's any statistically significant difference in icache/iTLB 
> evictions, with and without the patch.
> 
> If such stats are included in the changelog - even if just to show that any change 
> is within measurement accuracy, it would make it easier to apply this change.
> 
> Thanks,
> 
> 	Ingo


hi,

I have some results, but need help with interpretation.. ;)

I ran following command (with repeat 100 and 500)

perf stat --repeat 100 -e L1-icache-load -e L1-icache-load-misses -e
L1-icache-prefetches -e L1-icache-prefetch-misses -e iTLB-loads -e
iTLB-load-misses ./hackbench/hackbench 10

I can tell just the obvious:
- the cache load count is higher for the patched kernel,
  but the cache misses count is lower
- patched kernel has also lower count of prefetches,
  other counts are bigger for patched kernel

there's still some variability in counter values each time I run the perf

please let me know what you think, I can run other tests if needed

thanks,
jirka


--------------------------------------------------------------------------
the results for current tip tree are:

 Performance counter stats for './hackbench/hackbench 10' (100 runs):
             
          815008015  L1-icache-loads            ( +-   0.316% )  (scaled from 81.00%)
           26267361  L1-icache-load-misses      ( +-   0.210% )  (scaled from 81.00%)
             204143  L1-icache-prefetches       ( +-   1.291% )  (scaled from 81.01%)
      <not counted>  L1-icache-prefetch-misses
          814902708  iTLB-loads                 ( +-   0.315% )  (scaled from 80.99%)
              82082  iTLB-load-misses           ( +-   0.931% )  (scaled from 80.98%)

        0.205850655  seconds time elapsed   ( +-   0.333% )


 Performance counter stats for './hackbench/hackbench 10' (500 runs):

          817646684  L1-icache-loads            ( +-   0.150% )  (scaled from 80.99%)
           26282174  L1-icache-load-misses      ( +-   0.099% )  (scaled from 81.00%)
             211864  L1-icache-prefetches       ( +-   0.616% )  (scaled from 80.99%)
      <not counted>  L1-icache-prefetch-misses
          817646737  iTLB-loads                 ( +-   0.151% )  (scaled from 80.98%)
              82368  iTLB-load-misses           ( +-   0.451% )  (scaled from 80.98%)

        0.206651959  seconds time elapsed   ( +-   0.152% )



--------------------------------------------------------------------------
the results for tip tree with the patch applied are:


 Performance counter stats for './hackbench/hackbench 10' (100 runs):

          959206624  L1-icache-loads            ( +-   0.320% )  (scaled from 80.98%)
           24322357  L1-icache-load-misses      ( +-   0.334% )  (scaled from 80.93%)
             177970  L1-icache-prefetches       ( +-   1.240% )  (scaled from 80.97%)
      <not counted>  L1-icache-prefetch-misses
          959349089  iTLB-loads                 ( +-   0.320% )  (scaled from 80.93%)
              85535  iTLB-load-misses           ( +-   1.329% )  (scaled from 80.92%)
          
        0.209696972  seconds time elapsed   ( +-   0.352% )
             
      
 Performance counter stats for './hackbench/hackbench 10' (500 runs):

          960162049  L1-icache-loads            ( +-   0.114% )  (scaled from 80.95%)
           24237651  L1-icache-load-misses      ( +-   0.117% )  (scaled from 80.96%)
             179800  L1-icache-prefetches       ( +-   0.530% )  (scaled from 80.95%)
      <not counted>  L1-icache-prefetch-misses
          960352725  iTLB-loads                 ( +-   0.114% )  (scaled from 80.93%)
              84410  iTLB-load-misses           ( +-   0.491% )  (scaled from 80.92%)

        0.210509948  seconds time elapsed   ( +-   0.140% )

