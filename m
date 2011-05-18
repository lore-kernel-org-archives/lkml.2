Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab1ERRKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:10:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4006 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab1ERRKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:10:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=RM8U8HcprqKCi6VZK2UOG72TwDldqSAfeQietbHQCj8x2VV0yqNF9ZqubOzuTz2Pj
	f90d2Uck6zHAEKdTqtlSw==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v2 0/3] Increase resolution of load weights
Date: Wed, 18 May 2011 10:09:37 -0700
Message-Id: <1305738580-9924-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Please find attached v2 of the patchset series to increase load resolution.
Based on discussions with Ingo and Peter, this version drops all the
unsigned long -> u64 conversions which greatly simplifies the patchset. We also
only scale load when BITS_PER_LONG > 32 bits. Based on experiments with the
previous patchset, the benefits for 32-bit systems were limited and did not
justify the increased performance penalties.

Major changes from v1:
- Dropped unsigned long -> u64 conversions
- Cleaned up set_load_weight()
- Scale load only when BITS_PER_LONG > 32
- Rebased patchset to -tip instead of v2.6.39-rcX

Previous versions:
- v1: http://thread.gmane.org/gmane.linux.kernel/1133978
- v0: http://thread.gmane.org/gmane.linux.kernel/1129232

The patchset applies cleanly to -tip. Please note that this does not apply
cleanly to v2.6.39-rc8. I can post a patchset against v2.6.39-rc8 if needed.

Below is some analysis of the performance costs/improvements of this patchset.

1. Micro-arch performance costs:

Experiment was to run Ingo's pipe_test_100k about 200 times and measure
instructions, cycles, stalled cycles, branches, branch-misses and other
micro-arch costs as needed.

-tip (baseline):

# taskset 4 perf stat -e instructions -e cycles -e stalled-cycles-backend -e stalled-cycles-frontend --repeat=200 ./pipe-test-100k

 Performance counter stats for '/root/load-scale/pipe-test-100k' (200 runs):

       964,991,769 instructions             #    0.82  insns per cycle        
                                            #    0.33  stalled cycles per insn
                                            #    ( +-  0.05% )
     1,171,186,635 cycles                   #    0.000 GHz                      ( +-  0.08% )
       306,373,664 stalled-cycles-backend   #   26.16% backend  cycles idle     ( +-  0.28% )
       314,933,621 stalled-cycles-frontend  #   26.89% frontend cycles idle     ( +-  0.34% )

        1.122405684  seconds time elapsed  ( +-  0.05% )


-tip+patches:

# taskset 4 perf stat -e instructions -e cycles -e stalled-cycles-backend -e stalled-cycles-frontend --repeat=200 ./pipe-test-100k

 Performance counter stats for './load-scale/pipe-test-100k' (200 runs):

       963,624,821 instructions             #    0.82  insns per cycle        
                                            #    0.33  stalled cycles per insn
                                            #    ( +-  0.04% )
     1,175,215,649 cycles                   #    0.000 GHz                      ( +-  0.08% )
       315,321,126 stalled-cycles-backend   #   26.83% backend  cycles idle     ( +-  0.28% )
       316,835,873 stalled-cycles-frontend  #   26.96% frontend cycles idle     ( +-  0.29% )

        1.122238659  seconds time elapsed  ( +-  0.06% )


With this version of the patchset, looks like instructions decreases by ~0.10%
and cycles increases by 0.27%. This doesn't look statistically significant. As
expected, number of stalled cycles in the backend increased from 26.16% to
26.83%. This can be attributed to the shifts we do in c_d_m() and other places.
The fraction of stalled cycles in the frontend remains about the same, at 26.96%
compared to 26.89% in -tip.

For comparison sake, I modified the patch to remove the shifts in c_d_m() and
scale down the inverse weight for tasks.

 Performance counter stats for './data/pipe-test-100k' (200 runs):

       956,993,064 instructions             #    0.81  insns per cycle        
                                            #    0.34  stalled cycles per insn
                                            #    ( +-  0.05% )
     1,181,506,294 cycles                   #    0.000 GHz                      ( +-  0.10% )
       304,271,160 stalled-cycles-backend   #   25.75% backend  cycles idle     ( +-  0.36% )
       325,099,601 stalled-cycles-frontend  #   27.52% frontend cycles idle     ( +-  0.37% )

        1.129208596  seconds time elapsed  ( +-  0.06% )

The number of instructions decreases by about 0.8% and cycles increase about
0.81%. The fraction of cycles stalled in the backend drops to 25.72% and
fraction of cycles in the frontend increases to 27.52% (increase of 2.61%). This
is probably because we take the path marked unlikely in c_d_m() more often
because we overflow the 64-bit mult.

I tried a few variations of this alternative; i.e. do not scale weights in
c_d_m() and replace the unlikely() compiler hint with (i). no compiler hint,
and (ii). a likley() compiler hint. Neither of these variations resulted in
better performance compared to scaling down weights (as currently done).

(i). -tip+patches(alt) + no compiler hint in c_d_m()

# taskset 4 perf stat -e instructions -e cycles -e stalled-cycles-backend -e stalled-cycles-frontend --repeat=200 ./pipe-test-100k

 Performance counter stats for './load-scale/pipe-test-100k' (200 runs):

       958,280,690 instructions             #    0.80  insns per cycle        
                                            #    0.34  stalled cycles per insn
                                            #    ( +-  0.07% )
     1,191,992,203 cycles                   #    0.000 GHz                      ( +-  0.10% )
       314,905,306 stalled-cycles-backend   #   26.42% backend  cycles idle     ( +-  0.36% )
       324,940,653 stalled-cycles-frontend  #   27.26% frontend cycles idle     ( +-  0.38% )

        1.136591328  seconds time elapsed  ( +-  0.08% )


(ii). -tip+patches(alt) + likely() compiler hint

# taskset 4 perf stat -e instructions -e cycles -e stalled-cycles-backend -e stalled-cycles-frontend --repeat=200 ./pipe-test-100k

 Performance counter stats for './load-scale/pipe-test-100k' (200 runs):

       956,711,525 instructions             #    0.81  insns per cycle        
                                            #    0.34  stalled cycles per insn
                                            #    ( +-  0.07% )
     1,184,777,377 cycles                   #    0.000 GHz                      ( +-  0.09% )
       308,259,625 stalled-cycles-backend   #   26.02% backend  cycles idle     ( +-  0.32% )
       325,105,968 stalled-cycles-frontend  #   27.44% frontend cycles idle     ( +-  0.38% )

        1.131130981  seconds time elapsed  ( +-  0.06% )


2. Balancing low-weight task groups

Test setup: run 50 tasks with random sleep/busy times (biased around 100ms) in
a low weight container (with cpu.shares = 2). Measure %idle as reported by
mpstat over a 10s window.

-tip (baseline):

06:47:48 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle    intr/s
06:47:49 PM  all   94.32    0.00    0.06    0.00    0.00    0.00    0.00    0.00    5.62  15888.00
06:47:50 PM  all   94.57    0.00    0.62    0.00    0.00    0.00    0.00    0.00    4.81  16180.00
06:47:51 PM  all   94.69    0.00    0.06    0.00    0.00    0.00    0.00    0.00    5.25  15966.00
06:47:52 PM  all   95.81    0.00    0.00    0.00    0.00    0.00    0.00    0.00    4.19  16053.00
06:47:53 PM  all   94.88    0.06    0.00    0.00    0.00    0.00    0.00    0.00    5.06  15984.00
06:47:54 PM  all   93.31    0.00    0.00    0.00    0.00    0.00    0.00    0.00    6.69  15806.00
06:47:55 PM  all   94.19    0.00    0.06    0.00    0.00    0.00    0.00    0.00    5.75  15896.00
06:47:56 PM  all   92.87    0.00    0.00    0.00    0.00    0.00    0.00    0.00    7.13  15716.00
06:47:57 PM  all   94.88    0.00    0.00    0.00    0.00    0.00    0.00    0.00    5.12  15982.00
06:47:58 PM  all   95.44    0.00    0.00    0.00    0.00    0.00    0.00    0.00    4.56  16075.00
Average:     all   94.49    0.01    0.08    0.00    0.00    0.00    0.00    0.00    5.42  15954.60

-tip+patches:

06:47:03 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle    intr/s
06:47:04 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16630.00
06:47:05 PM  all   99.69    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.31  16580.20
06:47:06 PM  all   99.69    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.25  16596.00
06:47:07 PM  all   99.20    0.00    0.74    0.00    0.00    0.06    0.00    0.00    0.00  17838.61
06:47:08 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16540.00
06:47:09 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16575.00
06:47:10 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16614.00
06:47:11 PM  all   99.94    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.06  16588.00
06:47:12 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.00  16593.00
06:47:13 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.00  16551.00
Average:     all   99.84    0.00    0.09    0.00    0.00    0.01    0.00    0.00    0.06  16711.58

On a related note, compared to v2.6.39-rc7, -tip seems to have regressed in
this test. A bisection points to this merge commit:

$ git show 493bd3180190511770876ed251d75dab8595d322
commit 493bd3180190511770876ed251d75dab8595d322
Merge: 0cc5bc3 d906f0e
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jan 7 14:09:55 2011 +0100

    Merge branch 'x86/numa'

Is there a way to bisect into this merge commit? I don't have much experience
with git bisect and I've been manually inspecting commits :-( Full bisection
log below.

git bisect start
# good: [693d92a1bbc9e42681c42ed190bd42b636ca876f] Linux 2.6.39-rc7
git bisect good 693d92a1bbc9e42681c42ed190bd42b636ca876f
# bad: [6639653af57eb8f48971cc8662318dfacd192929] Merge branch 'perf/urgent'
git bisect bad 6639653af57eb8f48971cc8662318dfacd192929
# bad: [1ebfeec0895bf5afc59d135deab2664ad4d71e82] Merge branch 'x86/urgent'
git bisect bad 1ebfeec0895bf5afc59d135deab2664ad4d71e82
# good: [0d51ef74badd470c0f84ee4eff502e06bdb7e06b] Merge branch 'perf/core'
git bisect good 0d51ef74badd470c0f84ee4eff502e06bdb7e06b
# good: [4c637fc4944b153dc98735cc79dcd776c1a47303] Merge branch 'perf/core'
git bisect good 4c637fc4944b153dc98735cc79dcd776c1a47303
# good: [959620395dcef68a93288ac6055f6010fbefa243] Merge branch 'perf/core'
git bisect good 959620395dcef68a93288ac6055f6010fbefa243
# good: [6a8aeb83d3d7e5682df4542e6080cd4037a1f6d7] Merge branch 'out-of-tree'
git bisect good 6a8aeb83d3d7e5682df4542e6080cd4037a1f6d7
# good: [106f3c7499db2d4094e2d3a669c2f2c6f08ab093] Merge branch 'perf/core'
git bisect good 106f3c7499db2d4094e2d3a669c2f2c6f08ab093
# good: [0de7032fa49c88b06a492a88da7ea0c5118cedad] Merge branch 'linus'
git bisect good 0de7032fa49c88b06a492a88da7ea0c5118cedad
# good: [5e02063f418c58fb756b1ac972a7d1805127f299] Merge branch 'perf/core'
git bisect good 5e02063f418c58fb756b1ac972a7d1805127f299
# bad: [f9a3e42e48b14d6cb698cf8a5380ea32c316c949] Merge branch 'sched/urgent'
git bisect bad f9a3e42e48b14d6cb698cf8a5380ea32c316c949
# good: [0cc5bc39098229cf4192c3639f0f6108afe4932b] Merge branch 'x86/urgent'
git bisect good 0cc5bc39098229cf4192c3639f0f6108afe4932b
# bad: [1f01b669d560f33ba388360aa6070fbdef9f8f44] Merge branch 'perf/core'
git bisect bad 1f01b669d560f33ba388360aa6070fbdef9f8f44
# bad: [493bd3180190511770876ed251d75dab8595d322] Merge branch 'x86/numa'
git bisect bad 493bd3180190511770876ed251d75dab8595d322
# bad: [493bd3180190511770876ed251d75dab8595d322] Merge branch 'x86/numa'
git bisect bad 493bd3180190511770876ed251d75dab8595d322

-Thanks,
Nikhil

Nikhil Rao (3):
  sched: cleanup set_load_weight()
  sched: introduce SCHED_POWER_SCALE to scale cpu_power calculations
  sched: increase SCHED_LOAD_SCALE resolution

 include/linux/sched.h |   25 +++++++++++++++++-----
 kernel/sched.c        |   38 ++++++++++++++++++++++++-----------
 kernel/sched_fair.c   |   52 +++++++++++++++++++++++++-----------------------
 3 files changed, 72 insertions(+), 43 deletions(-)

-- 
1.7.3.1

