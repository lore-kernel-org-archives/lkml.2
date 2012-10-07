Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2JGHod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 03:44:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38144 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2JGHob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 03:44:31 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@redhat.com,
        pjt@google.com, linux@arm.linux.org.uk
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 0/6] sched: packing small tasks
Date: Sun,  7 Oct 2012 09:43:52 +0200
Message-Id: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch-set takes advantage of the new statistics that are going to be available in the kernel thanks to the per-entity load-tracking: http://thread.gmane.org/gmane.linux.kernel/1348522. It packs the small tasks in as few as possible CPU/Cluster/Core. The main goal of packing small tasks is to reduce the power consumption by minimizing the number of power domain that are used. The packing is done in 2 steps:

The 1st step looks for the best place to pack tasks on a system according to its topology and it defines a pack buddy CPU for each CPU if there is one available. The policy for setting a pack buddy CPU is that we pack at all levels where the power line is not shared by groups of CPUs. For describing this capability, a new flag has been introduced SD_SHARE_POWERLINE that is used to describe where CPUs of a scheduling domain are sharing their power rails. This flag has been set in all sched_domain in order to keep unchanged the default behaviour of the scheduler.

In a 2nd step, the scheduler checks the load level of the task which wakes up and the business of the buddy CPU. Then, It can decide to migrate the task on the buddy.

The patch-set has been tested on ARM platforms: quad CA-9 SMP and TC2 HMP (dual CA-15 and 3xCA-7 cluster). For ARM platform, the results have demonstrated that it's worth packing small tasks at all topology levels.

The performance tests have been done on both platforms with sysbench. The results don't show any performance regressions. These results are aligned with the policy which uses the normal behavior with heavy use cases.

test: sysbench --test=cpu --num-threads=N --max-requests=R run

Results below is the average duration of 3 tests on the quad CA-9.
default is the current scheduler behavior (pack buddy CPU is -1)
pack is the scheduler with the pack mecanism

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

              | CA7  | CA7  | total |
-------------------------------------
default       |  40  |  40  |  80   |
-------------------------------------


Vincent Guittot (6):
  Revert "sched: introduce temporary FAIR_GROUP_SCHED dependency for
    load-tracking"
  sched: add a new SD SHARE_POWERLINE flag for sched_domain
  sched: pack small task at wakeup
  sched: secure access to other CPU statistics
  sched: pack the idle load balance
  ARM: sched: clear SD_SHARE_POWERLINE

 arch/arm/kernel/topology.c       |    5 ++
 arch/ia64/include/asm/topology.h |    1 +
 arch/tile/include/asm/topology.h |    1 +
 include/linux/sched.h            |    9 +--
 include/linux/topology.h         |    3 +
 kernel/sched/core.c              |   13 ++--
 kernel/sched/fair.c              |  155 +++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h             |   10 +--
 8 files changed, 165 insertions(+), 32 deletions(-)

-- 
1.7.9.5

