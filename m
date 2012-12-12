Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2LLNc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 08:32:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35251 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2LLNc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 08:32:26 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, viresh.kumar@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH v2 0/6] sched: packing small tasks
Date: Wed, 12 Dec 2012 14:31:26 +0100
Message-Id: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset takes advantage of the new per-task load tracking that is available in the kernel for packing the small tasks in as few as possible CPU/Cluster/Core. The main goal of packing small tasks is to reduce the power consumption by minimizing the number of power domain that are enabled. The packing is done in 2 steps:

The 1st step looks for the best place to pack tasks in a system according to its topology and it defines a pack buddy CPU for each CPU if there is one available. The policy for defining a buddy CPU is that we pack at all levels where a group of CPU can be power gated independently from others. For describing this capability, a new flag has been introduced SD_SHARE_POWERDOMAIN that is used to indicate whether the groups of CPUs of a scheduling domain are sharing their power state. By default, this flag has been set in all sched_domain in order to keep unchanged the current behavior of the scheduler.

In a 2nd step, the scheduler checks the load average of a task which wakes up as well as the load average of the buddy CPU and can decide to migrate the task on the buddy. This check is done during the wake up because small tasks tend to wake up between load balance and asynchronously to each other which prevents the default mechanism to catch and migrate them efficiently.

Change since V1:

Patch 2/6
 - Change the flag name which was not clear. The new name is SD_SHARE_POWERDOMAIN.
 - Create an architecture dependent function to tune the sched_domain flags
Patch 3/6
 - Fix issues in the algorithm that looks for the best buddy CPU
 - Use pr_debug instead of pr_info
 - Fix for uniprocessor
Patch 4/6
 - Remove the use of usage_avg_sum which has not been merged
Patch 5/6
 - Change the way the coherency of runnable_avg_sum and runnable_avg_period is ensured
Patch 6/6
 - Use the arch dependent function to set/clear SD_SHARE_POWERDOMAIN for ARM platform

New results for V2:

This series has been tested with MP3 play back on ARM platform: TC2 HMP (dual CA-15 and 3xCA-7 cluster).

The measurements have been done on an Ubuntu image during 60 seconds of playback and the result has been normalized to 100.

              | CA15 | CA7  | total |
-------------------------------------
default       |  81  |   97 | 178   |
pack          |  13  |  100 | 113   |
-------------------------------------

Previous result for V1:

The patch-set has been tested on ARM platforms: quad CA-9 SMP and TC2 HMP (dual CA-15 and 3xCA-7 cluster). For ARM platform, the results have demonstrated that it's worth packing small tasks at all topology levels.

The performance tests have been done on both platforms with sysbench. The results don't show any performance regressions. These results are aligned with the policy which uses the normal behavior with heavy use cases.

test: sysbench --test=cpu --num-threads=N --max-requests=R run

Results below is the average duration of 3 tests on the quad CA-9.
default is the current scheduler behavior (pack buddy CPU is -1)
pack is the scheduler with the pack mechanism

              | default |  pack   |
-----------------------------------
N=8;  R=200   |  3.1999 |  3.1921 |
N=8;  R=2000  | 31.4939 | 31.4844 |
N=12; R=200   |  3.2043 |  3.2084 |
N=12; R=2000  | 31.4897 | 31.4831 |
N=16; R=200   |  3.1774 |  3.1824 |
N=16; R=2000  | 31.4899 | 31.4897 |
-----------------------------------

The power consumption tests have been done only on TC2 platform which has got accessible power lines and I have used cyclictest to simulate small tasks. The tests show some power consumption improvements.

test: cyclictest -t 8 -q -e 1000000 -D 20 & cyclictest -t 8 -q -e 1000000 -D 20

The measurements have been done during 16 seconds and the result has been normalized to 100

              | CA15 | CA7  | total |
-------------------------------------
default       | 100  |  40  | 140   |
pack          |  <1  |  45  | <46   |
-------------------------------------

The A15 cluster is less power efficient than the A7 cluster but if we assume that the tasks is well spread on both clusters, we can guest estimate that the power consumption on a dual cluster of CA7 would have been for a default kernel:

Vincent Guittot (6):
  Revert "sched: introduce temporary FAIR_GROUP_SCHED dependency for
    load-tracking"
  sched: add a new SD SHARE_POWERLINE flag for sched_domain
  sched: pack small tasks
  sched: secure access to other CPU statistics
  sched: pack the idle load balance
  ARM: sched: clear SD_SHARE_POWERLINE

 arch/arm/kernel/topology.c       |    9 +++
 arch/ia64/include/asm/topology.h |    1 +
 arch/tile/include/asm/topology.h |    1 +
 include/linux/sched.h            |    9 +--
 include/linux/topology.h         |    4 ++
 kernel/sched/core.c              |   14 ++--
 kernel/sched/fair.c              |  134 +++++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h             |   14 ++--
 8 files changed, 163 insertions(+), 23 deletions(-)

-- 
1.7.9.5

