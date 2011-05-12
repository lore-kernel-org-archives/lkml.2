Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1ELI5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:57:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36262 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab1ELI5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OcXdtMTGDAUUVCMTbB/fT9n/lzCT45zHncgD1BcaJ4rM21qIPKsRybfAqCbqr3A355
         PUXJTX47Wp2RARyvj/Zg==
MIME-Version: 1.0
In-Reply-To: <20110511065910.GD22551@elte.hu>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
 <20110502061411.GA16682@elte.hu> <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
 <20110504111355.GC5914@elte.hu> <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
 <20110506065959.GB23166@elte.hu> <BANLkTimevJFjvoDSE2q0bu6gQaajmaZATw@mail.gmail.com>
 <20110511065910.GD22551@elte.hu>
From: Nikhil Rao <ncrao@google.com>
Date: Thu, 12 May 2011 01:56:42 -0700
Message-ID: <BANLkTikTAhD9f96JBh5ON9FEGPOjTRreVg@mail.gmail.com>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Nikhil Rao <ncrao@google.com> wrote:
>
>> > Also, the above (and the other scale-adjustment changes) probably explains
>> > why the instruction count went up on 64-bit.
>>
>> Yes, that makes sense. We see an increase in instruction count of about 2%
>> with the new version of the patchset, down from 5.8% (will post the new
>> patchset soon). Assuming 30% of the cost of pipe test is scheduling, that is
>> an effective increase of approx. 6.7%. I'll post the data and some analysis
>> along with the new version.
>
> An instruction count increase does not necessarily mean a linear slowdown: if
> those instructions are cheaper or scheduled better by the CPU then often the
> slowdown will be less.
>
> Sometimes a 1% increase in the instruction count can slow down a workload by
> 5%, if the 1% increase does divisions, has complex data path dependencies or is
> missing the branch-cache a lot.
>
> So you should keep an eye on the cycle count as well. Latest -tip's perf stat
> can also measure 'stalled cycles':
>
> aldebaran:~/sched-tests> taskset 1 perf stat --repeat 3 ./pipe-test-1m
>
>  Performance counter stats for './pipe-test-1m' (3 runs):
>
>       6499.787926 task-clock               #    0.437 CPUs utilized            ( +-  0.41% )
>         2,000,108 context-switches         #    0.308 M/sec                    ( +-  0.00% )
>                 0 CPU-migrations           #    0.000 M/sec                    ( +-100.00% )
>               147 page-faults              #    0.000 M/sec                    ( +-  0.00% )
>    14,226,565,939 cycles                   #    2.189 GHz                      ( +-  0.49% )
>     6,897,331,129 stalled-cycles-frontend  #   48.48% frontend cycles idle     ( +-  0.90% )
>     4,230,895,459 stalled-cycles-backend   #   29.74% backend  cycles idle     ( +-  1.31% )
>    14,002,256,109 instructions             #    0.98  insns per cycle
>                                            #    0.49  stalled cycles per insn  ( +-  0.02% )
>     2,703,891,945 branches                 #  415.997 M/sec                    ( +-  0.02% )
>        44,994,805 branch-misses            #    1.66% of all branches          ( +-  0.27% )
>
>       14.859234036  seconds time elapsed  ( +-  0.19% )
>
> Te stalled-cycles frontend/backend metrics indicate whether a workload utilizes
> the CPU's resources optimally. Looking at a 'perf record -e
> stalled-cycles-frontend' and 'perf report' will show you the problem areas.
>
> Most of the 'problem areas' will be unrelated to your code.
>
> A 'near perfectly utilized' CPU looks like this:
>
> aldebaran:~/opt> taskset 1 perf stat --repeat 10 ./fill_1b
>
>  Performance counter stats for './fill_1b' (10 runs):
>
>       1880.489837 task-clock               #    0.998 CPUs utilized            ( +-  0.15% )
>                36 context-switches         #    0.000 M/sec                    ( +- 19.87% )
>                 1 CPU-migrations           #    0.000 M/sec                    ( +- 59.63% )
>                99 page-faults              #    0.000 M/sec                    ( +-  0.10% )
>     6,027,432,226 cycles                   #    3.205 GHz                      ( +-  0.15% )
>        22,138,455 stalled-cycles-frontend  #    0.37% frontend cycles idle     ( +- 36.56% )
>        16,400,224 stalled-cycles-backend   #    0.27% backend  cycles idle     ( +- 38.12% )
>    18,008,803,113 instructions             #    2.99  insns per cycle
>                                            #    0.00  stalled cycles per insn  ( +-  0.00% )
>     1,001,802,536 branches                 #  532.735 M/sec                    ( +-  0.01% )
>            22,842 branch-misses            #    0.00% of all branches          ( +-  9.07% )
>
>        1.884595529  seconds time elapsed  ( +-  0.15% )
>
> Both stall counts are very low. This is pretty hard to achieve in general, so
> before/after comparisons are used. For that there's 'perf diff' which you can
> use to compare before/after profiles:
>
>  aldebaran:~/sched-tests> taskset 1 perf record -e instructions ./pipe-test-1m
>  [ perf record: Woken up 2 times to write data ]
>  [ perf record: Captured and wrote 0.427 MB perf.data (~18677 samples) ]
>  aldebaran:~/sched-tests> taskset 1 perf record -e instructions ./pipe-test-1m
>  [ perf record: Woken up 2 times to write data ]
>  [ perf record: Captured and wrote 0.428 MB perf.data (~18685 samples) ]
>  aldebaran:~/sched-tests> perf diff | head -10
>  # Baseline  Delta          Shared Object                         Symbol
>  # ........ ..........  .................  .............................
>  #
>     2.68%     +0.84%  [kernel.kallsyms]  [k] select_task_rq_fair
>     3.28%     -0.17%  [kernel.kallsyms]  [k] fsnotify
>     2.67%     +0.13%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>     2.46%     +0.11%  [kernel.kallsyms]  [k] pipe_read
>     2.42%             [kernel.kallsyms]  [k] schedule
>     2.11%     +0.28%  [kernel.kallsyms]  [k] copy_user_generic_string
>     2.13%     +0.18%  [kernel.kallsyms]  [k] mutex_lock
>
>  ( Note: these were two short runs on the same kernel so the diff shows the
>   natural noise of the profile of this workload. Longer runs are needed to
>   measure effects smaller than 1%. )
>
> So there's a wide range of tools you can use to understand the precise
> performance impact of your patch and in turn you can present to us what you
> learned about it.
>
> Such analysis saves quite a bit of time on the side of us scheduler maintainers
> and makes performance impacting patches a lot more easy to apply :-)
>

Thanks for the info! I rebased the patchset against -tip and built
perf from -tip. Here are the results from running pipe-test-100k bound
to a single cpu with 100 repetitions.

-tip (baseline):

 Performance counter stats for '/root/data/pipe-test-100k' (100 runs):

       907,981,999 instructions             #    0.85  insns per cycle
                                            #    0.34  stalled cycles
per insn  ( +-  0.07% )
     1,072,650,809 cycles                   #    0.000 GHz
         ( +-  0.13% )
       305,678,413 stalled-cycles-backend   #   28.50% backend  cycles
idle     ( +-  0.51% )
       245,846,208 stalled-cycles-frontend  #   22.92% frontend cycles
idle     ( +-  0.70% )

        1.060303165  seconds time elapsed  ( +-  0.09% )


-tip+patches:

 Performance counter stats for '/root/data/pipe-test-100k' (100 runs):

       910,501,358 instructions             #    0.82  insns per cycle
                                            #    0.36  stalled cycles
per insn  ( +-  0.06% )
     1,108,981,763 cycles                   #    0.000 GHz
         ( +-  0.17% )
       328,816,295 stalled-cycles-backend   #   29.65% backend  cycles
idle     ( +-  0.63% )
       247,412,614 stalled-cycles-frontend  #   22.31% frontend cycles
idle     ( +-  0.71% )

        1.075497493  seconds time elapsed  ( +-  0.10% )


>From this latest run on -tip, the instruction count is about ~0.28%
more and cycles are approx 3.38% more. From the stalled cycles counts,
it looks like most of this increase is coming from backend stalled
cycles. It's not clear what type of stalls these are, but if I were to
guess, I think it means stalls post-decode (i.e. functional units,
load/store, etc.). Is that right?

I collected profiles from long runs of pipe-test (about 3m iterations)
and tried running "perf diff" on the profiles. I cached the buildid
from the two kernel images and associated test binary & libraries. The
individual reports make sense, but I suspect something is wrong with
the diff output.

# perf buildid-cache -v -a boot.tip-patches/vmlinux-2.6.39-tip-smp-DEV
Adding 17b6f2c42deb3725ad35e3dcba2d9fdb92ad47c1
boot.tip-patches/vmlinux-2.6.39-tip-smp-DEV: Ok
# perf buildid-cache -v -a boot.tip/vmlinux-2.6.39-tip-smp-DEV
Adding 47737eb3efdd6cb789872311c354b106ec8e7477
p/boot.tip/vmlinux-2.6.39-tip-smp-DEV: Ok

# perf buildid-list -i perf.data | grep kernel
17b6f2c42deb3725ad35e3dcba2d9fdb92ad47c1 [kernel.kallsyms]

# perf buildid-list -i perf.data.old | grep kernel
47737eb3efdd6cb789872311c354b106ec8e7477 [kernel.kallsyms]

# perf report -i perf.data.old -d [kernel.kallsyms] | head -n 10
# dso: [kernel.kallsyms]
# Events: 30K instructions
#
# Overhead       Command                       Symbol
# ........  ............  ...........................
#
     5.55%  pipe-test-3m  [k] pipe_read
     4.78%  pipe-test-3m  [k] schedule
     3.68%  pipe-test-3m  [k] update_curr
     3.52%  pipe-test-3m  [k] pipe_write


# perf report -i perf.data -d [kernel.kallsyms] | head -n 10
# dso: [kernel.kallsyms]
# Events: 31K instructions
#
# Overhead       Command                                 Symbol
# ........  ............  .....................................
#
     6.09%  pipe-test-3m  [k] pipe_read
     4.86%  pipe-test-3m  [k] schedule
     4.24%  pipe-test-3m  [k] update_curr
     3.87%  pipe-test-3m  [k] find_next_bit


# perf diff -v -d [kernel.kallsyms]
build id event received for [kernel.kallsyms]:
47737eb3efdd6cb789872311c354b106ec8e7477
...
build id event received for [kernel.kallsyms]:
17b6f2c42deb3725ad35e3dcba2d9fdb92ad47c1
...
Looking at the vmlinux_path (6 entries long)
Using /tmp/.debug/.build-id/47/737eb3efdd6cb789872311c354b106ec8e7477
for symbols
Looking at the vmlinux_path (6 entries long)
Using /tmp/.debug/.build-id/17/b6f2c42deb3725ad35e3dcba2d9fdb92ad47c1
for symbols
# Baseline  Delta                                     Symbol
# ........ ..........  .....................................
#
     0.00%     +6.09%  0xffffffff8112a258 ! [k] pipe_read
     0.00%     +4.86%  0xffffffff8141a206 ! [k] schedule
     0.00%     +4.24%  0xffffffff810634d8 ! [k] update_curr
     0.00%     +3.87%  0xffffffff8121f569 ! [k] find_next_bit
     0.00%     +3.33%  0xffffffff81065cbf ! [k] enqueue_task_fair
     0.00%     +3.25%  0xffffffff81065824 ! [k] dequeue_task_fair
     0.00%     +2.77%  0xffffffff81129d10 ! [k] pipe_write
     0.00%     +2.71%  0xffffffff8114ed97 ! [k] fsnotify

The baseline numbers are showing up as zero and the deltas match the
fractions from the -tip+patches report. Am I missing something here?

Another thing I noticed while running this on -tip is that low-weight
task groups are poorly balanced on -tip (much worse than v2.6.39-rc7).
I started bisecting between v2.6.39-rc7 and -tip to identify the
source of this regression.

[ experiment: create low-weight task group and run ~50 threads with
random sleep/busy pattern ]

-tip:

01:30:03 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft
%steal  %guest   %idle    intr/s
01:30:04 PM  all   90.67    0.00    0.00    0.00    0.00    0.00
0.00    0.00    9.33  15368.00
01:30:05 PM  all   93.08    0.00    0.00    0.00    0.00    0.00
0.00    0.00    6.92  15690.00
01:30:06 PM  all   94.56    0.00    0.00    0.00    0.00    0.00
0.00    0.00    5.44  15844.00
01:30:07 PM  all   94.88    0.00    0.06    0.00    0.00    0.00
0.00    0.00    5.06  15989.00
01:30:08 PM  all   94.31    0.00    0.00    0.00    0.00    0.00
0.00    0.00    5.69  15791.00
01:30:09 PM  all   95.00    0.00    0.00    0.00    0.00    0.00
0.00    0.00    5.00  15953.00
01:30:10 PM  all   94.19    0.00    0.06    0.00    0.00    0.00
0.00    0.00    5.75  15810.00
01:30:11 PM  all   93.75    0.00    0.00    0.00    0.00    0.00
0.00    0.00    6.25  15748.00
01:30:12 PM  all   94.94    0.00    0.06    0.00    0.00    0.00
0.00    0.00    5.00  15943.00
01:30:13 PM  all   94.31    0.00    0.00    0.00    0.00    0.00
0.00    0.00    5.69  15865.00
Average:     all   93.97    0.00    0.02    0.00    0.00    0.00
0.00    0.00    6.01  15800.10

-tip+patches:

01:29:59 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft
%steal  %guest   %idle    intr/s
01:30:00 PM  all   99.31    0.00    0.56    0.00    0.00    0.00
0.00    0.00    0.12  16908.00
01:30:01 PM  all   99.44    0.00    0.50    0.00    0.00    0.06
0.00    0.00    0.00  18128.00
01:30:02 PM  all   99.88    0.00    0.00    0.00    0.00    0.00
0.00    0.00    0.12  16582.00
01:30:03 PM  all   99.06    0.00    0.75    0.00    0.00    0.00
0.00    0.00    0.19  17108.00
01:30:04 PM  all   99.94    0.00    0.06    0.00    0.00    0.00
0.00    0.00    0.00  17113.00
01:30:05 PM  all  100.00    0.00    0.00    0.00    0.00    0.00
0.00    0.00    0.00  16568.00
01:30:06 PM  all   99.81    0.00    0.00    0.00    0.00    0.00
0.00    0.00    0.19  16408.91
01:30:07 PM  all   99.87    0.00    0.00    0.00    0.00    0.00
0.00    0.00    0.13  16576.00
01:30:08 PM  all   99.94    0.00    0.00    0.00    0.00    0.00
0.00    0.00    0.06  16617.00
01:30:09 PM  all   99.94    0.00    0.00    0.00    0.00    0.06
0.00    0.00    0.00  16702.00
Average:     all   99.72    0.00    0.19    0.00    0.00    0.01
0.00    0.00    0.08  16870.63

-Thanks,
Nikhil
