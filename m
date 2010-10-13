Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0JMTKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:10:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:11365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0JMTJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:09:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Iw+5BkNO8hwcoRjli2UcStMxvCahStZYYtrBOzIR56/+2prGlFm1qNPEQu8HEiOsY
	ILv7pPim10LNPMWNkiXjg==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 0/4][RFC v2] Improve load balancing when tasks have large weight differential
Date: Wed, 13 Oct 2010 12:09:34 -0700
Message-Id: <1286996978-7007-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached a series of patches that improve load balancing when
there is a large weight differential between tasks (such as when nicing a task
or when using SCHED_IDLE). These patches are based off feedback given by Peter
Zijlstra and Mike Galbraith in earlier posts.

Previous versions:
-v0: http://thread.gmane.org/gmane.linux.kernel/1015966
     Large weight differential leads to inefficient load balancing

-v1: http://thread.gmane.org/gmane.linux.kernel/1041721
     Improve load balancing when tasks have large weight differential

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

10:40:31 AM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
10:40:32 AM  all   99.25    0.00    0.75    0.00    0.00    0.00    0.00    0.00  16998.00
10:40:33 AM  all   99.75    0.00    0.19    0.00    0.00    0.06    0.00    0.00  16337.00
10:40:34 AM  all   98.75    0.00    1.25    0.00    0.00    0.00    0.00    0.00  17127.27
10:40:35 AM  all   99.06    0.00    0.94    0.00    0.00    0.00    0.00    0.00  16741.58
10:40:36 AM  all   99.50    0.06    0.44    0.00    0.00    0.00    0.00    0.00  16477.00
10:40:37 AM  all   99.50    0.00    0.50    0.00    0.00    0.00    0.00    0.00  16868.69
10:40:38 AM  all   99.13    0.00    0.81    0.00    0.00    0.06    0.00    0.00  16761.39
10:40:39 AM  all   99.19    0.00    0.81    0.00    0.00    0.00    0.00    0.00  17501.00
10:40:40 AM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  18209.00
10:40:41 AM  all   99.19    0.00    0.81    0.00    0.00    0.00    0.00    0.00  16862.00
Average:     all   99.32    0.01    0.66    0.00    0.00    0.01    0.00    0.00  16987.80


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

Cpu(s): 49.7% us,  0.2% sy,  0.0% ni, 50.2% id,  0.0% wa,  0.0% hi,  0.0% si
Mem:  16463308k total,  1011248k used, 15452060k free,    10076k buffers
Swap:        0k total,        0k used,        0k free,   766388k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7645 root       5 -15  5876   88    0 R  100  0.0  43:38.76 soaker
 7646 root      20   0  5876   88    0 R   99  0.0  33:15.25 soaker
 7648 root      20   0  5876   88    0 R   75  0.0  36:57.02 soaker
 7647 root      20   0  5876   88    0 R   67  0.0  29:12.97 soaker
 7649 root      20   0  5876   88    0 R   54  0.0  29:28.35 soaker

Comments, feedback welcome.

-Thanks,
Nikhil

Nikhil Rao (4):
  sched: do not consider SCHED_IDLE tasks to be cache hot
  sched: set group_imb only a task can be pulled from the busiest cpu
  sched: drop group_capacity to 1 only if local group has extra
    capacity
  sched: force balancing on newidle balance if local group has capacity

 kernel/sched.c      |    3 +++
 kernel/sched_fair.c |   48 ++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 8 deletions(-)

