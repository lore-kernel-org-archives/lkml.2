Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab1D0LMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:12:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1D0LMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:12:14 -0400
Date: Wed, 27 Apr 2011 13:11:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <asharma@fb.com>
Cc: arun@sharma-home.net, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] perf events: Add stalled cycles generic event -
 PERF_COUNT_HW_STALLED_CYCLES
Message-ID: <20110427111141.GB28993@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110423201409.GA20072@elte.hu>
 <20110424061645.GA12013@radium.snc4.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110424061645.GA12013@radium.snc4.facebook.com>
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


* Arun Sharma <asharma@fb.com> wrote:

>     cycles = c["cycles"] * 1.0
>     cycles_no_uops_issued = cycles - c["UOPS_ISSUED:ANY:c=1:t=1"]
>     cycles_no_uops_retired = cycles - c["UOPS_RETIRED:ANY:c=1:t=1"]
>     backend_stall_cycles = c["RESOURCE_STALLS:ANY"]
>     icache_stall_cycles = c["L1I:CYCLES_STALLED"]
> 
>     # Cycle stall accounting
>     print "Percent idle: %d%%" % ((1 - cycles/(int(options.time) * cycles_per_sec)) * 100)
>     print "\tRetirement Stalls: %d%%" % ((cycles_no_uops_retired / cycles) * 100)
>     print "\tBackend Stalls: %d%%" % ((backend_stall_cycles / cycles) * 100)
>     print "\tFrontend Stalls: %d%%" % ((cycles_no_uops_issued / cycles) * 100)
>     print "\tInstruction Starvation: %d%%" % (((cycles_no_uops_issued - backend_stall_cycles)/cycles) * 100)
>     print "\ticache stalls: %d%%" % ((icache_stall_cycles/cycles) * 100)
> 
>     # Wasted work
>     uops_executed = c["UOPS_EXECUTED:PORT015:t=1"] + c["UOPS_EXECUTED:PORT234_CORE"]
>     uops_retired = c["UOPS_RETIRED:ANY:t=1"]
>     uops_issued = c["UOPS_ISSUED:ANY:t=1"] + c["UOPS_ISSUED:FUSED:t=1"]
> 
>     print "\tPercentage useless uops: %d%%" % ((uops_executed - uops_retired) * 100.0/uops_retired)
>     print "\tPercentage useless uops issued: %d%%" % ((uops_issued - uops_retired) * 100.0/uops_retired)

Just an update: i started working on generalizing these events.

As a first step i'd like to introduce stall statistics in default 'perf stat' 
output, then as a second step offer more detailed modi of analysis (like your 
script).

As for the first, 'overview' step, i'd like to use one or two numbers only, to 
give people a general ballpark figure about how good the CPU is performing for 
a given workload.

Wouldnt UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 be in general a pretty good, 
primary "stall" indicator? This is similar to the "cycles-uops_executed" value 
in your script (UOPS_EXECUTED:PORT015:t=1 and UOPS_EXECUTED:PORT234_CORE 
based): it counts cycles when there's no execution at all - not even 
speculative one.

This would cover a wide variety of 'stall' reasons: external latency, or 
stalling on lack of paralellism in the incoming instruction stream and most 
other stall reasons. So it would measure everything that moves the CPU away 
from 100% utilization.

Secondly, the 'speculative waste' proportion is probably pretty well captured 
via branch-misprediction counts - those are the primary source of filling the 
pipeline with useless work.

So in the most high-level view we could already print useful information via 
the introduction of a single new generic event:

   PERF_COUNT_HW_CPU_CYCLES_BUSY

and 'idle cycles' are "cycles-busy_cycles".

I have implemented preliminary support for this, and this is how the new 
'overview' output looks like currently. Firstly here's the output from a "bad" 
testcase (lots of branch-misses):

 $ perf stat ./branches 20 1

 Performance counter stats for './branches 20 1' (10 runs):

          9.829903 task-clock               #    0.972 CPUs utilized            ( +-  0.07% )
                 0 context-switches         #    0.000 M/sec                    ( +-  0.00% )
                 0 CPU-migrations           #    0.000 M/sec                    ( +-  0.00% )
               111 page-faults              #    0.011 M/sec                    ( +-  0.09% )
        31,470,886 cycles                   #    3.202 GHz                      ( +-  0.06% )
         9,825,068 stalled-cycles           #   31.22% of all cycles are idle   ( +- 13.89% )
        27,868,090 instructions             #    0.89  insns per cycle        
                                            #    0.35  stalled cycles per insn  ( +-  0.02% )
         4,313,661 branches                 #  438.830 M/sec                    ( +-  0.02% )
         1,068,668 branch-misses            #   24.77% of all branches          ( +-  0.01% )

        0.010117520  seconds time elapsed  ( +-  0.14% )

The two important values are the "20.00% of all cycles are idle" and the 
"24.77% of all branches" missed values - both are high and indicative of 
trouble.

The fixed testcase shows:

 Performance counter stats for './branches 20 0' (100 runs):

          4.417987 task-clock               #    0.948 CPUs utilized            ( +-  0.10% )
                 0 context-switches         #    0.000 M/sec                    ( +-  0.00% )
                 0 CPU-migrations           #    0.000 M/sec                    ( +-  0.00% )
               111 page-faults              #    0.025 M/sec                    ( +-  0.02% )
        14,135,368 cycles                   #    3.200 GHz                      ( +-  0.10% )
         1,939,275 stalled-cycles           #   13.72% of all cycles are idle   ( +-  4.99% )
        27,846,610 instructions             #    1.97  insns per cycle        
                                            #    0.07  stalled cycles per insn  ( +-  0.00% )
         4,309,228 branches                 #  975.383 M/sec                    ( +-  0.00% )
             3,992 branch-misses            #    0.09% of all branches          ( +-  0.26% )

        0.004660164  seconds time elapsed  ( +-  0.15% )

Both stall values are much lower and the instructions per cycle value doubled.

Here's another testcase, one that fills the pipeline near-perfectly:

 $ perf stat ./fill_1b

 Performance counter stats for './fill_1b':

       1874.601174 task-clock               #    0.998 CPUs utilized          
                 1 context-switches         #    0.000 M/sec                  
                 0 CPU-migrations           #    0.000 M/sec                  
               107 page-faults              #    0.000 M/sec                  
     6,009,321,149 cycles                   #    3.206 GHz                    
       212,795,827 stalled-cycles           #    3.54% of all cycles are idle 
    18,007,646,574 instructions             #    3.00  insns per cycle        
                                            #    0.01  stalled cycles per insn
     1,001,527,311 branches                 #  534.262 M/sec                  
            16,988 branch-misses            #    0.00% of all branches        

        1.878558311  seconds time elapsed

Here too both counts are very low.

The next step is to provide the tools to further analyze why the CPU is not 
utilized perfectly. I have implemented some preliminary code for that too, 
using generic cache events:

 $ perf stat --repeat 10 --detailed ./array-bad 

 Performance counter stats for './array-bad' (10 runs):

         50.552646 task-clock               #    0.992 CPUs utilized            ( +-  0.04% )
                 0 context-switches         #    0.000 M/sec                    ( +-  0.00% )
                 0 CPU-migrations           #    0.000 M/sec                    ( +-  0.00% )
             1,877 page-faults              #    0.037 M/sec                    ( +-  0.01% )
       142,802,193 cycles                   #    2.825 GHz                      ( +-  0.18% )  (22.55%)
        88,622,411 stalled-cycles           #   62.06% of all cycles are idle   ( +-  0.22% )  (34.97%)
        45,381,755 instructions             #    0.32  insns per cycle        
                                            #    1.95  stalled cycles per insn  ( +-  0.11% )  (46.94%)
         7,725,207 branches                 #  152.815 M/sec                    ( +-  0.05% )  (58.44%)
            29,788 branch-misses            #    0.39% of all branches          ( +-  1.06% )  (69.46%)
         8,421,969 L1-dcache-loads          #  166.598 M/sec                    ( +-  0.37% )  (70.06%)
         7,868,389 L1-dcache-load-misses    #   93.43% of all L1-dcache hits    ( +-  0.13% )  (58.28%)
         4,553,490 LLC-loads                #   90.074 M/sec                    ( +-  0.31% )  (44.49%)
         1,764,277 LLC-load-misses          #   34.900 M/sec                    ( +-  0.21% )  (9.98%)

        0.050973462  seconds time elapsed  ( +-  0.05% )

The --detailed flag is what activates wider counting. The "93.43% of all 
L1-dcache hits" is a giveaway indicator that this particular workload is 
primarily data-access limited and that much of it escapes into RAM as well.

Is this the direction you'd like to see perf stat to move into? Any comments, 
suggestions?

Thanks,

	Ingo
