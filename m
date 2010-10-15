Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0JOUMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:12:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43311 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab0JOUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:12:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=A+AHY1g1sAaRuDZS1NYppuT25PfKXz1gSKt7Fns9vso5KvV9KZpPIj6z5mw0D+oFw
	H/RLMZ5RGN8ncivgmFLkQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH 0/4][RFC v3] Improve load balancing when tasks have large weight differential -v3
Date: Fri, 15 Oct 2010 13:12:26 -0700
Message-Id: <1287173550-30365-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached a a series of patches that improve load balancing
when there is a large weight differential between tasks (such as when nicing a
task or when using SCHED_IDLE). These patches are based off feedback given by
Peter Zijlstra and Mike Galbraith in earlier posts.

Previous versions:
-v0: http://thread.gmane.org/gmane.linux.kernel/1015966
     Large weight differential leads to inefficient load balancing

-v1: http://thread.gmane.org/gmane.linux.kernel/1041721
     Improve load balancing when tasks have large weight differential

-v2: http://thread.gmane.org/gmane.linux.kernel/1048073
     Improve load balancing when tasks have large weight differential -v2

Changes from -v2:
- Swap patches 3 and 4, which allows us to reuse sds->this_has_capacity to
  check if the local group has extra capacity.
- Drop this_group_capacity from sd_lb_stats
- Update comments and changelog descriptions to describe the patches better.
- Add an unlikely() hint to the SCHED_IDLE policy check in task_hot() based on
  feedback from Satoru Takeuchi.

These patches can be applied to v2.6.36-rc7 or -tip without conflicts. Below
are some tests that highlight the improvements with this patchset.

1. 16 SCHED_IDLE soakers, 1 SCHED_NORMAL task on 16 cpu machine.
Tested on a quad-cpu, quad-socket. Steps to reproduce:
- spawn 16 SCHED_IDLE tasks
- spawn one nice 0 task
- system utilization immediately drops to 80% on v2.6.36-rc7

v2.6.36-rc7

10:38:46 AM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
10:38:47 AM  all   80.69    0.00    0.50    0.00    0.00    0.00    0.00   18.82  14008.00
10:38:48 AM  all   85.09    0.06    0.50    0.00    0.00    0.00    0.00   14.35  14690.00
10:38:49 AM  all   86.83    0.06    0.44    0.00    0.00    0.00    0.00   12.67  14314.85
10:38:50 AM  all   79.89    0.00    0.37    0.00    0.00    0.00    0.00   19.74  14035.35
10:38:51 AM  all   87.94    0.06    0.44    0.00    0.00    0.00    0.00   11.56  14991.00
10:38:52 AM  all   83.27    0.06    0.37    0.00    0.00    0.00    0.00   16.29  14319.00
10:38:53 AM  all   94.37    0.13    0.50    0.00    0.00    0.00    0.00    5.00  15930.00
10:38:54 AM  all   87.06    0.06    0.62    0.00    0.00    0.06    0.00   12.19  14946.00
10:38:55 AM  all   88.68    0.06    0.38    0.00    0.00    0.00    0.00   10.88  14767.00
10:38:56 AM  all   80.16    0.00    1.06    0.00    0.00    0.00    0.00   18.78  13892.08
Average:     all   85.38    0.05    0.52    0.00    0.00    0.01    0.00   14.05  14588.91


v2.6.36-rc7 + patchset:

12:58:29 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
12:58:30 PM  all   99.81    0.00    0.19    0.00    0.00    0.00    0.00    0.00  16384.00
12:58:31 PM  all   99.75    0.00    0.25    0.00    0.00    0.00    0.00    0.00  16428.00
12:58:32 PM  all   99.81    0.00    0.19    0.00    0.00    0.00    0.00    0.00  16345.00
12:58:33 PM  all   99.75    0.00    0.25    0.00    0.00    0.00    0.00    0.00  16383.00
12:58:34 PM  all   99.75    0.00    0.19    0.00    0.00    0.06    0.00    0.00  16333.00
12:58:35 PM  all   99.81    0.00    0.19    0.00    0.00    0.00    0.00    0.00  16359.00
12:58:36 PM  all   99.75    0.00    0.25    0.00    0.00    0.00    0.00    0.00  16523.23
12:58:37 PM  all   99.75    0.00    0.25    0.00    0.00    0.00    0.00    0.00  16352.00
12:58:38 PM  all   98.75    0.00    1.25    0.00    0.00    0.00    0.00    0.00  17128.00
12:58:39 PM  all   99.31    0.06    0.62    0.00    0.00    0.00    0.00    0.00  16757.00
Average:     all   99.63    0.01    0.36    0.00    0.00    0.01    0.00    0.00  16499.20


2. Sub-optimal utilizataion in presence of niced task.
Tested on a dual-socket/quad-core w/ two cores on each socket disabled.
Steps to reproduce:
- spawn 4 nice 0 soakers and one nice -15 soaker
- force all tasks onto one cpu by setting affinities
- reset affinity masks

v2.6.36-rc7:

Cpu(s): 34.3% us,  0.2% sy,  0.0% ni, 65.1% id,  0.4% wa,  0.0% hi,  0.0% si
Mem:  16463308k total,   996368k used, 15466940k free,    12304k buffers
Swap:        0k total,        0k used,        0k free,   756244k cached

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7651 root       5 -15  5876   84    0 R   98  0.0  37:35.97 soaker
 7652 root      20   0  5876   84    0 R   49  0.0  19:49.02 soaker
 7654 root      20   0  5876   84    0 R   49  0.0  20:48.93 soaker
 7655 root      20   0  5876   84    0 R   49  0.0  19:25.74 soaker
 7653 root      20   0  5876   84    0 R   47  0.0  20:02.16 soaker

v2.6.36-rc7 + patchset:

Cpu(s): 52.5% us,  0.3% sy,  0.0% ni, 47.1% id,  0.0% wa,  0.0% hi,  0.0% si
Mem:  16463912k total,  1012832k used, 15451080k free,     9988k buffers
Swap:        0k total,        0k used,        0k free,   762896k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2749 root       5 -15  5876   88    0 R  100  0.0   9:05.58 soaker
 2750 root      20   0  5876   88    0 R   99  0.0   6:19.94 soaker
 2751 root      20   0  5876   88    0 R   70  0.0   7:51.42 soaker
 2753 root      20   0  5876   88    0 R   67  0.0   6:09.91 soaker
 2752 root      20   0  5876   88    0 R   55  0.0   6:33.41 soaker

Comments, feedback welcome.

-Thanks,
Nikhil

Nikhil Rao (4):
  sched: do not consider SCHED_IDLE tasks to be cache hot
  sched: set group_imb only a task can be pulled from the busiest cpu
  sched: force balancing on newidle balance if local group has capacity
  sched: drop group_capacity to 1 only if local group has extra
    capacity

 kernel/sched.c      |    3 +++
 kernel/sched_fair.c |   47 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 42 insertions(+), 8 deletions(-)

