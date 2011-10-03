Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab1JCTH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:07:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54851 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab1JCTHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:07:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 00/10] cgroups: Task counter subsystem v6
Date: Mon,  3 Oct 2011 21:07:02 +0200
Message-Id: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This contains minor changes, mostly documentation and changelog
updates, off-case build fix, and a code optimization in
res_counter_common_ancestor().

It's hard to put some statistic numbers while testing this feature
given that the result is rather binary: we launch a forkbomb and
either we stop and kill it or the system become unresponsive.
    
Meanwhile, one can find a testsuite at this address:
https://tglx.de/~fweisbec/task_counter_test.tar.gz
    
It performs several checks to ensure the interface and the behaviour
are reliable after common events like moving tasks around over cgroups
in a hierarchy, forking inside, etc.. It also launches a forkbomb,
tries to stop and kill it. So beware, don't run it on a system that
is doing serious things. Ensure you have CGROUP_TASK_COUNTER set
before, or it may compress the Ten Plagues in your MBR and
inflate the whole after your next reboot.

Changes in v6:

- Update res_counter_common_ancestor() to be O(n+m) instead of O(n*m),
patch from Kirill A. Shutemov (6/10)
- Refine documentation and changelog to better explain the claims and
goals of this subsystem (10/10)
- Fix !CONFIG_CGROUPS build crash (10/10)
- Step over the temporary state that used an ad-hoc fork hook.

Frederic Weisbecker (9):
  cgroups: Add res_counter_write_u64() API
  cgroups: New resource counter inheritance API
  cgroups: Add previous cgroup in can_attach_task/attach_task callbacks
  cgroups: New cancel_attach_task subsystem callback
  cgroups: Ability to stop res charge propagation on bounded ancestor
  res_counter: Allow charge failure pointer to be null
  cgroups: Pull up res counter charge failure interpretation to caller
  cgroups: Allow subsystems to cancel a fork
  cgroups: Add a task counter subsystem

Kirill A. Shutemov (1):
  cgroups: Add res counter common ancestor searching

 Documentation/cgroups/cgroups.txt          |   13 ++-
 Documentation/cgroups/resource_counter.txt |   20 +++-
 Documentation/cgroups/task_counter.txt     |  153 ++++++++++++++++++
 block/blk-cgroup.c                         |   12 +-
 include/linux/cgroup.h                     |   28 +++-
 include/linux/cgroup_subsys.h              |    8 +
 include/linux/res_counter.h                |   27 +++-
 init/Kconfig                               |    9 +
 kernel/Makefile                            |    1 +
 kernel/cgroup.c                            |   58 ++++++--
 kernel/cgroup_freezer.c                    |    9 +-
 kernel/cgroup_task_counter.c               |  239 ++++++++++++++++++++++++++++
 kernel/cpuset.c                            |    6 +-
 kernel/events/core.c                       |    5 +-
 kernel/exit.c                              |    2 +-
 kernel/fork.c                              |    7 +-
 kernel/res_counter.c                       |   97 ++++++++++--
 kernel/sched.c                             |    6 +-
 18 files changed, 644 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/cgroups/task_counter.txt
 create mode 100644 kernel/cgroup_task_counter.c

-- 
1.7.5.4

