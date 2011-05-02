Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1EBBTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:19:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab1EBBTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:19:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=wrdgJtVbipv6IcS8xY2tCNk3nNDPCVUlZXonk6fvUNZRZuNbtZzRi1hmgAlsvFJWH
	SU/0G7TxS+TgpgofnW5NQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 00/19] Increase resolution of load weights
Date: Sun,  1 May 2011 18:18:58 -0700
Message-Id: <1304299157-25769-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Please find attached v1 of the patchset to increase the resolution of load
weights. The motivation for this patchset and requirements were described in
the first RFC sent to LKML (see http://thread.gmane.org/gmane.linux.kernel/1129232
for more info).

This version of the patchset is more stable than the previous RFC and more
suitable for testing. I have attached some test results below that show the
impact/improvements of the patchset on 32-bit machines and 64-bit kernels.

These patches apply cleanly on top of v2.6.39-rc5. Please note that there is
a merge conflict when applied to -tip; I could send out another patchset that
applies to -tip (not sure what is standard protocol here).

Changes since v0:
- Scale down reference load weight by SCHED_LOAD_RESOLUTION in
  calc_delta_mine() (thanks to Nikunj Dadhania)
- Detect overflow in update_cfs_load() and cap avg_load update to ~0ULL
- Fixed all power calculations to use SCHED_POWER_SHIFT instead of
  SCHED_LOAD_SHIFT (also thanks to Stephan Barwolf for identifying this)
- Convert atomic ops to use atomic64_t instead of atomic_t

Experiments:

1. Performance costs

Ran 50 iterations of Ingo's pipe-test-100k program (100k pipe ping-pongs). See
http://thread.gmane.org/gmane.linux.kernel/1129232/focus=1129389 for more info.

64-bit build.

  2.6.39-rc5 (baseline):

    Performance counter stats for './pipe-test-100k' (50 runs):

       905,034,914 instructions             #      0.345 IPC     ( +-   0.016% )
     2,623,924,516 cycles                     ( +-   0.759% )

        1.518543478  seconds time elapsed   ( +-   0.513% )

  2.6.39-rc5 + patchset:

    Performance counter stats for './pipe-test-100k' (50 runs):

       905,351,545 instructions             #      0.343 IPC     ( +-   0.018% )
     2,638,939,777 cycles                     ( +-   0.761% )

        1.509101452  seconds time elapsed   ( +-   0.537% )

There is a marginal increase in instruction retired, about 0.034%; and marginal
increase in cycles counted, about 0.57%.

32-bit build.

  2.6.39-rc5 (baseline):

    Performance counter stats for './pipe-test-100k' (50 runs):

     1,025,151,722 instructions             #      0.238 IPC     ( +-   0.018% )
     4,303,226,625 cycles                     ( +-   0.524% )

        2.133056844  seconds time elapsed   ( +-   0.619% )

  2.6.39-rc5 + patchset:

    Performance counter stats for './pipe-test-100k' (50 runs):

     1,070,610,068 instructions             #      0.239 IPC     ( +-   1.369% )
     4,478,912,974 cycles                     ( +-   1.011% )

        2.293382242  seconds time elapsed   ( +-   0.144% )

On 32-bit kernels, instructions retired increases by about 4.4% with this
patchset. CPU cycles also increases by about 4%.

2. Fairness tests

Test setup: run 5 soaker threads bound to a single cpu. Measure usage over 10s
for each thread and calculate mean, stdev and coeff of variation (stdev/mean)
for each set of reading. Coeff of variation is averaged over 10 such readings.

As you can see in the data below, there is no significant difference in coeff
of variation between the two kernels on 64-bit or 32-bit builds.

64-bit build.

  2.6.39-rc5 (baseline):
    cv=0.007374042

  2.6.39-rc5 + patchset:
    cv=0.006942042

32-bit-build.

  2.6.39-rc5 (baseline)
    cv=0.002547

  2.6.39-rc5 + patchset:
    cv=0.002426

3. Load balancing low-weight task groups

Test setup: run 50 tasks with random sleep/busy times (biased around 100ms) in
a low weight container (with cpu.shares = 2). Measure %idle as reported by
mpstat over a 10s window.

>From the data below, the patchset applied to v2.6.39-rc5 keeps the busy fully
utilized with tasks in the low weight container. These measurements are for a
64-bit kernel.

2.6.39-rc5 (baseline):

04:08:27 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle    intr/s
04:08:28 PM  all   98.75    0.00    0.00    0.00    0.00    0.00    0.00    0.00    1.25  16475.00
04:08:29 PM  all   99.31    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.69  16447.00
04:08:30 PM  all   99.44    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.56  16445.00
04:08:31 PM  all   99.19    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.81  16447.00
04:08:32 PM  all   99.50    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.50  16523.00
04:08:33 PM  all   99.81    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.19  16516.00
04:08:34 PM  all   99.81    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.19  16517.00
04:08:35 PM  all   99.13    0.00    0.44    0.00    0.00    0.00    0.00    0.00    0.44  17624.00
04:08:36 PM  all   97.00    0.00    0.31    0.00    0.00    0.12    0.00    0.00    2.56  17608.00
04:08:37 PM  all   99.31    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.69  16517.00
Average:     all   99.13    0.00    0.07    0.00    0.00    0.01    0.00    0.00    0.79  16711.90

2.6.39-rc5 + patchset:

04:06:26 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle    intr/s
04:06:27 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16573.00
04:06:28 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.00  16554.00
04:06:29 PM  all   99.69    0.00    0.25    0.00    0.00    0.06    0.00    0.00    0.00  17496.00
04:06:30 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16542.00
04:06:31 PM  all   99.94    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.06  16624.00
04:06:32 PM  all   99.88    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.06  16671.00
04:06:33 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16605.00
04:06:34 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16580.00
04:06:35 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16646.00
04:06:36 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16533.00
Average:     all   99.94    0.00    0.04    0.00    0.00    0.01    0.00    0.00    0.01  16682.40

4. Sizes of vmlinux (32-bit builds)

Sizes of vmlinux compiled with 'make defconfig ARCH=i386' below.

2.6.39-rc5 (baseline):
   text	   data	    bss	    dec	    hex	filename
8144777	1077556	1085440	10307773	 9d48bd	vmlinux-v2.6.39-rc5

2.6.39-rc5 + patchset:
   text	   data	    bss	    dec	    hex	filename
8144846	1077620	1085440	10307906	 9d4942	vmlinux

Negligible increase in text, data size (less than 0.01%).

-Thanks,
Nikhil

Nikhil Rao (19):
  sched: introduce SCHED_POWER_SCALE to scale cpu_power calculations
  sched: increase SCHED_LOAD_SCALE resolution
  sched: use u64 for load_weight fields
  sched: update cpu_load to be u64
  sched: update this_cpu_load() to return u64 value
  sched: update source_load(), target_load() and weighted_cpuload() to
    use u64
  sched: update find_idlest_cpu() to use u64 for load
  sched: update find_idlest_group() to use u64
  sched: update division in cpu_avg_load_per_task to use div_u64
  sched: update wake_affine path to use u64, s64 for weights
  sched: update update_sg_lb_stats() to use u64
  sched: Update update_sd_lb_stats() to use u64
  sched: update f_b_g() to use u64 for weights
  sched: change type of imbalance to be u64
  sched: update h_load to use u64
  sched: update move_task() and helper functions to use u64 for weights
  sched: update f_b_q() to use u64 for weighted cpuload
  sched: update shares distribution to use u64
  sched: convert atomic ops in shares update to use atomic64_t ops

 drivers/cpuidle/governors/menu.c |    5 +-
 include/linux/sched.h            |   22 ++--
 kernel/sched.c                   |   70 ++++++------
 kernel/sched_debug.c             |   14 +-
 kernel/sched_fair.c              |  234 ++++++++++++++++++++------------------
 kernel/sched_stats.h             |    2 +-
 6 files changed, 182 insertions(+), 165 deletions(-)

-- 
1.7.3.1

