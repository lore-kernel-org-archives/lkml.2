Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab2AMSOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:14:16 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61375 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab2AMSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:14:11 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 0/8] cgroups: Task counter subsystem v7
Date: Fri, 13 Jan 2012 19:13:44 +0100
Message-Id: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the task counter limitation patchset rebased on top
of Tejun's latest cgroup tree (cgroup/for-3.3). In a later
iteration, I also intend to include its selftests once the
selftest subsystem is merged after -rc1.

In fact, the rebase mostly is a concern of the last patch. The
others haven't changed except a few unnoticeable dusts. Some patches
have also been removed because either the last cgroup patches cover
what they were doing or they were tiny changes I merged in the last
patch (like a missing include of err.h fixed by Stephen Rothwell).

Please note that Andrew Morton had doubts whether we want to merge
it upstream or not. So don't merge it too eagerly before we sort out
the debate.


= What is this ? =

The task counter subsystem counts the tasks inside a cgroup and
rejects forks and cgroup migration when they result in a number
of task above the user tunable limit.

= Why is this needed ? =

We want to be able to run untrustee programs into sandboxes and
secure containers while protecting against forkbombs.

This patchset allow us to:

1) Prevent against forkbombs by setting an upper bound number of tasks
in a cgroup. This prevents from a forkbomb to spread. This is typically
NR_PROC rlimit but in the scope of a cgroup. Traditional NR_PROC doesn't
help us here because we don't want to have some container starving all the
others by spawning a high number of tasks when all these containers
are running under the same user.

2) Kill safely a cgroup. We want a non-racy and reliable way to kill
all tasks in a cgroup, without racing against concurrent forks.

Some practical cases from people who request this can be found here:

     https://lkml.org/lkml/2011/12/13/309
     https://lkml.org/lkml/2011/12/13/364

More details on the last patch that provides the documentation.


= Can that be used by Systemd? =

Systemd uses cgroups to keep track of services and the processes it
creates. Some feature have been requested in order to be able to reliably
kill all the processes in a cgroup such that systemd to kill services without
race.

(Note I'm not debating here to know if Systemd is doing the right thing by
using cgroups. I'm just focusing here on this particular feature request).

The task counter subsystem could be used to solve this problem. However
this involves the whole task counting machinery and this is too much
overhead to be used for system services that tend to fork often.

A simple core latch that rejects forks in a cgroup would be much more efficient
for this precise purpose.


= How does it interact with NR_PROC rlimit? =

Both can be used at the same time. They don't conflict, they
are just complementary.


= Why not rather focus on a generic solution to protect against forkbomb ? =

If you know a more generic solution to protect against forkbombs that not
only works in containers but in more cases, I'll be happy to drop this patchset
and focus on that instead.

Note we need a solution that meets our requirements for untrustees running in
containers, something that also prevents a forkbomb from doing any damage like
even a temporary DDOS. We don't want sandboxes and containers to severely impact
the rest of the system.

Thanks.

---
Frederic Weisbecker (7):
  cgroups: add res_counter_write_u64() API
  cgroups: new resource counter inheritance API
  cgroups: ability to stop res charge propagation on bounded ancestor
  res_counter: allow charge failure pointer to be null
  cgroups: pull up res counter charge failure interpretation to caller
  cgroups: allow subsystems to cancel a fork
  cgroups: Add a task counter subsystem

Kirill A. Shutemov (1):
  cgroups: add res counter common ancestor searching

 Documentation/cgroups/resource_counter.txt |   20 ++-
 Documentation/cgroups/task_counter.txt     |  153 ++++++++++++++++
 include/linux/cgroup.h                     |   20 ++-
 include/linux/cgroup_subsys.h              |    8 +
 include/linux/res_counter.h                |   27 +++-
 init/Kconfig                               |    9 +
 kernel/Makefile                            |    1 +
 kernel/cgroup.c                            |   23 ++-
 kernel/cgroup_freezer.c                    |    6 +-
 kernel/cgroup_task_counter.c               |  272 ++++++++++++++++++++++++++++
 kernel/exit.c                              |    2 +-
 kernel/fork.c                              |    7 +-
 kernel/res_counter.c                       |   97 +++++++++--
 13 files changed, 612 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/cgroups/task_counter.txt
 create mode 100644 kernel/cgroup_task_counter.c

-- 
1.7.5.4

