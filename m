Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1EKRXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:23:22 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:59566 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1EKRXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:23:19 -0400
Date: Wed, 11 May 2011 08:59:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
Message-ID: <20110511065910.GD22551@elte.hu>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
 <20110502061411.GA16682@elte.hu>
 <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
 <20110504111355.GC5914@elte.hu>
 <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
 <20110506065959.GB23166@elte.hu>
 <BANLkTimevJFjvoDSE2q0bu6gQaajmaZATw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimevJFjvoDSE2q0bu6gQaajmaZATw@mail.gmail.com>
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


* Nikhil Rao <ncrao@google.com> wrote:

> I think we need the branch for 64-bit kernels. I don't like the branch but I 
> can't think of a better way to avoid it. Do you have any suggestion?

It was just a quick stab into the dark, i was fishing for more 
micro-optimizations on 64-bit (32-bit, as long as we leave its resolution 
alone, should not matter much): clearly there is *some* new overhead on 64-bit 
kernels too, so it would be nice to reduce that to the absolute minimum.

> For 32-bit systems, the compiler should ideally optimize this branch away. 
> Unfortunately gcc-4.4.3 doesn't do that (and I'm not sure if a later version 
> does it either). We could add a macro around this check to avoid the branch 
> for 32-bit and do the check for 64-bit kernels?

I'd rather keep it easy to read. If we keep the 32-bit unit of load a 32-bit 
word then 32-bit will see basically no extra overhead, right? (modulo the 
compiler not noticing such optimizations.)

Also, it's a good idea to do performance measurements with newest gcc (4.6) if 
possible: by the time such a change hits distros it will be the established 
stock distro compiler that kernels get built with. Maybe your figures will get 
better and maybe it can optimize this branch as well.

> > Also, the above (and the other scale-adjustment changes) probably explains 
> > why the instruction count went up on 64-bit.
> 
> Yes, that makes sense. We see an increase in instruction count of about 2% 
> with the new version of the patchset, down from 5.8% (will post the new 
> patchset soon). Assuming 30% of the cost of pipe test is scheduling, that is 
> an effective increase of approx. 6.7%. I'll post the data and some analysis 
> along with the new version.

An instruction count increase does not necessarily mean a linear slowdown: if 
those instructions are cheaper or scheduled better by the CPU then often the 
slowdown will be less.

Sometimes a 1% increase in the instruction count can slow down a workload by 
5%, if the 1% increase does divisions, has complex data path dependencies or is 
missing the branch-cache a lot.

So you should keep an eye on the cycle count as well. Latest -tip's perf stat 
can also measure 'stalled cycles':

aldebaran:~/sched-tests> taskset 1 perf stat --repeat 3 ./pipe-test-1m

 Performance counter stats for './pipe-test-1m' (3 runs):

       6499.787926 task-clock               #    0.437 CPUs utilized            ( +-  0.41% )
         2,000,108 context-switches         #    0.308 M/sec                    ( +-  0.00% )
                 0 CPU-migrations           #    0.000 M/sec                    ( +-100.00% )
               147 page-faults              #    0.000 M/sec                    ( +-  0.00% )
    14,226,565,939 cycles                   #    2.189 GHz                      ( +-  0.49% )
     6,897,331,129 stalled-cycles-frontend  #   48.48% frontend cycles idle     ( +-  0.90% )
     4,230,895,459 stalled-cycles-backend   #   29.74% backend  cycles idle     ( +-  1.31% )
    14,002,256,109 instructions             #    0.98  insns per cycle        
                                            #    0.49  stalled cycles per insn  ( +-  0.02% )
     2,703,891,945 branches                 #  415.997 M/sec                    ( +-  0.02% )
        44,994,805 branch-misses            #    1.66% of all branches          ( +-  0.27% )

       14.859234036  seconds time elapsed  ( +-  0.19% )

Te stalled-cycles frontend/backend metrics indicate whether a workload utilizes 
the CPU's resources optimally. Looking at a 'perf record -e 
stalled-cycles-frontend' and 'perf report' will show you the problem areas.
 
Most of the 'problem areas' will be unrelated to your code.

A 'near perfectly utilized' CPU looks like this:

aldebaran:~/opt> taskset 1 perf stat --repeat 10 ./fill_1b

 Performance counter stats for './fill_1b' (10 runs):

       1880.489837 task-clock               #    0.998 CPUs utilized            ( +-  0.15% )
                36 context-switches         #    0.000 M/sec                    ( +- 19.87% )
                 1 CPU-migrations           #    0.000 M/sec                    ( +- 59.63% )
                99 page-faults              #    0.000 M/sec                    ( +-  0.10% )
     6,027,432,226 cycles                   #    3.205 GHz                      ( +-  0.15% )
        22,138,455 stalled-cycles-frontend  #    0.37% frontend cycles idle     ( +- 36.56% )
        16,400,224 stalled-cycles-backend   #    0.27% backend  cycles idle     ( +- 38.12% )
    18,008,803,113 instructions             #    2.99  insns per cycle        
                                            #    0.00  stalled cycles per insn  ( +-  0.00% )
     1,001,802,536 branches                 #  532.735 M/sec                    ( +-  0.01% )
            22,842 branch-misses            #    0.00% of all branches          ( +-  9.07% )

        1.884595529  seconds time elapsed  ( +-  0.15% )

Both stall counts are very low. This is pretty hard to achieve in general, so 
before/after comparisons are used. For that there's 'perf diff' which you can 
use to compare before/after profiles:

 aldebaran:~/sched-tests> taskset 1 perf record -e instructions ./pipe-test-1m
 [ perf record: Woken up 2 times to write data ]
 [ perf record: Captured and wrote 0.427 MB perf.data (~18677 samples) ]
 aldebaran:~/sched-tests> taskset 1 perf record -e instructions ./pipe-test-1m
 [ perf record: Woken up 2 times to write data ]
 [ perf record: Captured and wrote 0.428 MB perf.data (~18685 samples) ]
 aldebaran:~/sched-tests> perf diff | head -10
 # Baseline  Delta          Shared Object                         Symbol
 # ........ ..........  .................  .............................
 #
     2.68%     +0.84%  [kernel.kallsyms]  [k] select_task_rq_fair
     3.28%     -0.17%  [kernel.kallsyms]  [k] fsnotify
     2.67%     +0.13%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
     2.46%     +0.11%  [kernel.kallsyms]  [k] pipe_read
     2.42%             [kernel.kallsyms]  [k] schedule
     2.11%     +0.28%  [kernel.kallsyms]  [k] copy_user_generic_string
     2.13%     +0.18%  [kernel.kallsyms]  [k] mutex_lock

 ( Note: these were two short runs on the same kernel so the diff shows the 
   natural noise of the profile of this workload. Longer runs are needed to 
   measure effects smaller than 1%. )

So there's a wide range of tools you can use to understand the precise 
performance impact of your patch and in turn you can present to us what you 
learned about it.

Such analysis saves quite a bit of time on the side of us scheduler maintainers 
and makes performance impacting patches a lot more easy to apply :-)

Thanks,

	Ingo
