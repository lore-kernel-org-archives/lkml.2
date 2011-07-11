Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab1GKOPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:15:18 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51078 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab1GKOPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:15:16 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/7] cgroups: New max number of tasks subsystem (was: cgroups rlim subsystem)
Date: Mon, 11 Jul 2011 16:14:59 +0200
Message-Id: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Changes in this release are:

* switch from general rlim subsystem to self-contained max number of tasks
subsystem

* Don't use subsys->fork() callback but a static call to avoid cgroups
complications.

* When moving a task accross cgroups, don't charge/uncharge the common
ancestors, to fix race against concurrent forks.
To fix that, Paul proposed a res_counter_move_charge() that do
all in once. But we need to be able to cancel the attachment in case
a following subsystem refuses the attachment itself. Thus the charge
and uncharge still need to be seperate. More specifically, we can
only uncharge the old cgroup once we are sure of the attachment. Because
we can't cancel that uncharge later due to possible forks in the middle.

Thanks.

Frederic Weisbecker (7):
  cgroups: Add res_counter_write_u64() API
  cgroups: New resource counter inheritance API
  cgroups: Add previous cgroup in can_attach_task/attach_task callbacks
  cgroups: New cancel_attach_task subsystem callback
  cgroups: Ability to stop res charge propagation on bounded ancestor
  cgroups: Add res counter common ancestor searching
  cgroups: Add a max number of tasks subsystem

 block/blk-cgroup.c            |   10 ++-
 include/linux/cgroup.h        |   15 +++-
 include/linux/cgroup_subsys.h |    8 ++
 include/linux/res_counter.h   |   12 +++
 init/Kconfig                  |    7 ++
 kernel/Makefile               |    1 +
 kernel/cgroup.c               |   25 ++++--
 kernel/cgroup_freezer.c       |    3 +-
 kernel/cgroup_max_tasks.c     |  176 +++++++++++++++++++++++++++++++++++++++++
 kernel/cpuset.c               |    6 +-
 kernel/events/core.c          |    5 +-
 kernel/fork.c                 |    4 +
 kernel/res_counter.c          |   88 ++++++++++++++++++---
 kernel/sched.c                |    6 +-
 14 files changed, 335 insertions(+), 31 deletions(-)
 create mode 100644 kernel/cgroup_max_tasks.c

-- 
1.7.5.4

