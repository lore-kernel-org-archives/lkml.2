Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2JTTGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 15:06:22 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:54180 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2JTTGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 15:06:21 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com D6C3783302
From: Andrea Righi <andrea@betterlinux.com>
To: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] distinct load average per-cpuset
Date: Sat, 20 Oct 2012 21:05:59 +0200
Message-Id: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overview
~~~~~~~~
The cpusets subsystem allows to assign a different set of CPUs to a cgroup. A
typical use case is to split large systems in small CPU/memory partitions and
isolate certain users/applications in these subsets of the system.

Sometimes, to have a quick overview of the state of each partition, we may be
interested to get the load average of the CPUs assigned to a particular cpuset,
rather than the global load average of the system.

Proposed solution
~~~~~~~~~~~~~~~~~
The proposal is to add a new file in the cpuset subsystem to report the load
average of the CPUs assinged to a particular cpuset cgroup.

Example:

 # echo 0-1 > /sys/fs/cgroup/cpuset/foo/cpuset.cpus
 # echo 2-3 > /sys/fs/cgroup/cpuset/bar/cpuset.cpus

 # echo $$ > /sys/fs/cgroup/cpuset/foo/tasks
 # for i in `seq 4`; do yes > /dev/null & done

 ... after ~5mins ...

 # cat /proc/loadavg /sys/fs/cgroup/cpuset/{foo,bar}/cpuset.loadavg
 3.99 2.66 1.24 6/377 2855
 3.98 2.64 1.20
 0.01 0.02 0.04

In this case we can easily find that the cpuset "foo" is the most busy in the
system.

ChangeLog v1->v2:
 - convert rq->nr_uninterruptible to a percpu variable
 - fix nr_uninterruptible accounting in the wakeup/sleep paths
 - use DEFINE_PER_CPU() instead of NR_CPUS arrays
 - in patch 2/3 add a comment to explain the validity of evaluating the cpuset
   load average as the sum of the individual per-cpu load averages

[ Thanks to Peter Z. for the review and suggestions of v1 ]

TODO:
 - report nr_running and nr_threads in cpuset.loadavg, producing the same
   output as /proc/loadavg; in this way we could do nice things like, for
   example, "mount --bind cpuset.loadavg /proc/loadavg" in a new mount
   namespace for a specific user that we want to isolate into a specific
   cpuset cgroup, etc...

[PATCH v2 1/3] sched: introduce distinct per-cpu load average
[PATCH v2 2/3] cpusets: add load avgerage interface
[PATCH v2 3/3] cpusets: add documentation of the loadavg file

 Documentation/cgroups/cpusets.txt |    1 +
 include/linux/sched.h             |    6 ++
 kernel/cpuset.c                   |  108 +++++++++++++++++++++++++++++++++++
 kernel/sched/core.c               |  112 +++++++++++++++++++++++++++++++------
 kernel/sched/debug.c              |    3 +-
 kernel/sched/sched.h              |    8 +--
 6 files changed, 214 insertions(+), 24 deletions(-)
