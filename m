Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0G3FTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:19:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab0G3FTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:19:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=e8W+XwfEX4813yYd7dRhNRiqeTUVa/MGXIQwk8jMBf2173Va64QQ2wCuHOThYjmUS
	/QjsUlTsGLWyAqsy0Gc6w==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venki@google.com>, Ken Chen <kenchen@google.com>,
        Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 0/6] [RFC] Large weight differential leads to inefficient load balancing
Date: Thu, 29 Jul 2010 22:19:00 -0700
Message-Id: <1280467146-32218-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We have observed that a large weight differential between tasks on a runqueue
leads to sub-optimal machine utilization and poor load balancing. For example,
if you have lots of SCHED_IDLE tasks (sufficient number to keep the machine 100%
busy) and a few SCHED_NORMAL soaker tasks, we see that the machine has
significant idle time.

The data below highlights this problem. The test machine is a 4 socket quad-core
box (16 cpus). These experiemnts were done with v2.6.25-rc6. We spawn 16
SCHED_IDLE soaker threads (one per-cpu) to completely fill up the machine. CPU
utilization numbers gathered from mpstat for 10s are:

03:30:24 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
03:30:25 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16234.65
03:30:26 PM  all   99.88    0.06    0.06    0.00    0.00    0.00    0.00    0.00  16374.00
03:30:27 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16392.00
03:30:28 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16612.12
03:30:29 PM  all   99.88    0.00    0.12    0.00    0.00    0.00    0.00    0.00  16375.00
03:30:30 PM  all   99.94    0.06    0.00    0.00    0.00    0.00    0.00    0.00  16440.00
03:30:31 PM  all   99.81    0.00    0.19    0.00    0.00    0.00    0.00    0.00  16237.62
03:30:32 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16360.00
03:30:33 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16405.00
03:30:34 PM  all   99.38    0.06    0.50    0.00    0.00    0.00    0.00    0.06  18881.82
Average:     all   99.86    0.02    0.12    0.00    0.00    0.00    0.00    0.01  16628.20

We then spawn one SCHED_NORMAL while-1 task (the absolute number does not matter
so long as we introduce some large weight differential).

03:40:57 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
03:40:58 PM  all   83.06    0.00    0.06    0.00    0.00    0.00    0.00   16.88  14555.00
03:40:59 PM  all   78.25    0.00    0.06    0.00    0.00    0.00    0.00   21.69  14527.00
03:41:00 PM  all   82.71    0.06    0.06    0.00    0.00    0.00    0.00   17.17  14879.00
03:41:01 PM  all   87.34    0.00    0.06    0.00    0.00    0.00    0.00   12.59  15466.00
03:41:02 PM  all   80.80    0.06    0.19    0.00    0.00    0.00    0.00   18.95  14584.00
03:41:03 PM  all   82.90    0.00    0.06    0.00    0.00    0.00    0.00   17.04  14570.00
03:41:04 PM  all   79.45    0.00    0.06    0.00    0.00    0.00    0.00   20.49  14536.00
03:41:05 PM  all   86.48    0.00    0.07    0.00    0.00    0.00    0.00   13.46  14577.00
03:41:06 PM  all   76.73    0.06    0.06    0.00    0.00    0.06    0.00   23.10  14594.00
03:41:07 PM  all   86.48    0.00    0.07    0.00    0.00    0.00    0.00   13.45  14703.03
Average:     all   82.31    0.02    0.08    0.00    0.00    0.01    0.00   17.59  14699.10

The machine utilization is sub-optimal and this doesn't look right.  On
investigating this further, we noticed a couple of things. When we consider
load balancing operations at any sched domain where the weight of the group is
greater than one, the group containing the SCHED_NORMAL task is always selected
as the busiest group. While this is expected (SCHED_NORMAL at nice 0 is a factor
of 512 times the weight of SCHED_IDLE), this weight differential leads to
sub-optimal machine utilization.

CPUs outside this group can only pull SCHED_IDLE tasks (because pulling a
SCHED_NORMAL would be far in excess of the imbalance). The load balancer pulls
queued SCHED_IDLE tasks away from this group, and soon it starts failing
balances because it unable to move running tasks. Eventually active migration
kicks in and boots the remaining SCHED_IDLE tasks, leaving idle cpus in the
busiest sched group.

These idle cpus remain idle for long periods of time even though other cpus have
large runqueue depths (albeit filled with SCHED_IDLE tasks). The idle balance on
these cores always select the sched group with the SCHED_NORMAL task to pull tasks
from, and always fails because this group has only one runnable task.

We see the same problem with group scheduling as well, i.e. if we have two
groups with a large weight differential, the machine utilization is sub-optimal.
While this RFC focuses on SCHED_IDLE and SCHED_NORMAL, we can extend these
arguments to SCHED_IDLE-like group entities as well (i.e. groups with cpu.shares
set to 2).

In the remainder of this RFC, we present a solution to address the problem below
and have attached a prototype patchset for feedback and comments. Please let me
know if you have alternate ideas; I would be happy to explore other solutions.

This patchset changes the way the kernel balances SCHED_IDLE tasks. Since
SCHED_IDLE tasks contribute very little weight to the runqueues, we do not
balance them with SCHED_NORMAL/SCHED_BATCH tasks. Instead, we do second pass
to balance SCHED_IDLE tasks using a different metric. We iterate through each
cpu in the sched domain span and calculate the idle load as follows:

     load = (idle_nr_runnig * WEIGHT_IDLEPRIO / idle power)

The metric used is a ratio of the load contributed by SCHED_IDLE tasks to the
available power for running SCHED_IDLE tasks. We determine available power
similar to the RT power scaling calculations, i.e. we scale a CPU's available
idle power based on the average SCHED_NORMAL/SCHED_BATCH activity over a given
period.

Here are some results for a 2.6.35-rc6 kernel + patchset. This is with 16
SCHED_IDLE soaker threads and one SCHED_NORMAL task.

06:55:16 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
06:55:17 PM  all   99.88    0.00    0.12    0.00    0.00    0.00    0.00    0.00  16228.71
06:55:18 PM  all   99.81    0.00    0.19    0.00    0.00    0.00    0.00    0.00  16516.16
06:55:19 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16197.03
06:55:20 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16376.00
06:55:21 PM  all   99.88    0.06    0.06    0.00    0.00    0.00    0.00    0.00  16406.00
06:55:22 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16349.00
06:55:23 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16343.00
06:55:24 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16354.00
06:55:25 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16521.21
06:55:26 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16189.11
Average:     all   99.92    0.01    0.08    0.00    0.00    0.00    0.00    0.00  16347.25

Please find attached patches against v2.6.35-rc6. Note that this patchset is a
prototype and there are known limitations:
- not well integrated with the existing LB paths
- does not support group scheduling
- needs to be extended to support preempt kernels
- needs to be power-savings aware
- needs schedstat support
- written/tested for x86/64, SMP

If folks think this is a good direction and this idea has some merit, then I
will be more than happy to continue working with the community to improve this
patchset. If there is another way to fix this problem, then please do tell; I
would be more than happy to help out.

-Thanks
Nikhil

---

Nikhil Rao (6):
  sched: account SCHED_IDLE tasks on rq->idle_nr_running
  sched: add SD_IDLE_LOAD_BALANCE to sched domain flags
  sched: add moving average of time spent servicing SCHED_NORMAL tasks
  sched: add sched_idle_balance argument to lb functions
  sched: add SCHED_IDLE load balancer
  sched: enable SD_IDLE_LOAD_BALANCE on MC, CPU and NUMA (x86) domains

 arch/x86/include/asm/topology.h |    1 +
 include/linux/sched.h           |    1 +
 include/linux/topology.h        |    4 +
 kernel/sched.c                  |   27 +++++++
 kernel/sched_fair.c             |  161 +++++++++++++++++++++++++++++++++++++--
 5 files changed, 186 insertions(+), 8 deletions(-)

