Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1IFAOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 20:14:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53143 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1IFANz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 20:13:55 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 00/12 v4][RESEND] cgroups: Task counter subsystem
Date: Tue,  6 Sep 2011 02:12:54 +0200
Message-Id: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, I had unbalanced "<" and ">" around email addresses so I need
to resend otherwise LKML wouldn't take it.)


Reminder:

The task counter is a cgroup subsystem that features an upper bound
limitation on the number of tasks running inside cgroup.

It has two desired usecases, but possibly more can be found:

- Protect against forkbomb in the scope of a cgroup, this can be
especially useful in the case of containers where traditional rlmit
is too limited.

- Kill all tasks inside a cgroup without worrying about races against
concurrent forks.

See documentation in patch 10/12 for more details.

May be I should rebase the whole against Tejun's patches that use
an iterator on tasks.

Changes in v4:

- Rebase on top of "cgroups: Don't attach task to subsystem if
  migration failed" (https://lkml.org/lkml/2011/8/26/262), applied
  in -mm.
- Add comment about the use of spinlock in res_counter_write_u64() (patch 1)
- Update documentation after [can_]attach_task() arguments changes (patch 3)
- Update documentation for cancel_attach_task() new callback (patch 4)
- Cancel task attachment on migration failure in cgroup_attach_proc() (patch 4)
- Some function inlining (patch 5)
- Move "Allow charge failure pointer to be null" earlier in the set for
  sanity (patch 7)
- Fix error return value (patch 8 and 9)
- Whitespace fixes, comments added, improve config help section (patch 9)
- Drop subsystem early init (patch 9)
- Add subsystem documentation (patch 10)
- Remove ad-hoc fork hook and reuse existing one for cgroup (patch 11 and 12)

This can not be pulled from:                                                                                                     
                                                                                                                             
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git                                                    
        cgroup/nr_proc-v4

Frederic Weisbecker (12):
  cgroups: Add res_counter_write_u64() API
  cgroups: New resource counter inheritance API
  cgroups: Add previous cgroup in can_attach_task/attach_task callbacks
  cgroups: New cancel_attach_task subsystem callback
  cgroups: Ability to stop res charge propagation on bounded ancestor
  cgroups: Add res counter common ancestor searching
  res_counter: Allow charge failure pointer to be null
  cgroups: Pull up res counter charge failure interpretation to caller
  cgroups: Add a task counter subsystem
  cgroups: Add documentation for task counter subsystem
  cgroups: Allow subsystems to cancel a fork
  cgroups: Convert task counter to use the subsys fork callback

 Documentation/cgroups/cgroups.txt      |   13 ++-
 Documentation/cgroups/task_counter.txt |  126 ++++++++++++++++++++
 block/blk-cgroup.c                     |   10 +-
 include/linux/cgroup.h                 |   20 ++-
 include/linux/cgroup_subsys.h          |    8 ++
 include/linux/res_counter.h            |   25 ++++-
 init/Kconfig                           |    7 +
 kernel/Makefile                        |    1 +
 kernel/cgroup.c                        |   56 +++++++--
 kernel/cgroup_freezer.c                |    9 +-
 kernel/cgroup_task_counter.c           |  200 ++++++++++++++++++++++++++++++++
 kernel/cpuset.c                        |    6 +-
 kernel/events/core.c                   |    5 +-
 kernel/exit.c                          |    2 +-
 kernel/fork.c                          |    7 +-
 kernel/res_counter.c                   |   77 ++++++++++---
 kernel/sched.c                         |    6 +-
 17 files changed, 524 insertions(+), 54 deletions(-)
 create mode 100644 Documentation/cgroups/task_counter.txt
 create mode 100644 kernel/cgroup_task_counter.c

-- 
1.7.5.4

