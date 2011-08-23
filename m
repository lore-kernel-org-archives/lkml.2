Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1HWWUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:20:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53401 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1HWWUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:20:11 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: [PATCHSET] cgroup: introduce cgroup_taskset and consolidate subsys methods
Date: Wed, 24 Aug 2011 00:19:54 +0200
Message-Id: <1314138000-2049-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cgroup has grown quite some number of subsys methods.  Some of them
are overlapping, inconsistent with each other and called under
different conditions depending on whether they're called for a single
task or whole process.  Unfortunately, these callbacks are complicated
and incomplete at the same time.

* ->attach_task() is called after migration for task attach but before
  for process.

* Ditto for ->pre_attach().

* ->can_attach_task() is called for every task in the thread group but
  ->attach_task() skips the ones which don't actually change cgroups.

* Task attach becomes noop if the task isn't actually moving.  Process
  attach is always performed.

* ->attach_task() doesn't (or at least aren't supposed to) have access
  to the old cgroup.

* During cancel, there's no way to access the affected tasks.

This patchset introduces cgroup_taskset along with some accessors and
iterator, updates methods to use it, consolidates usages and drops
superflous methods.

It contains the following six patches.

 0001-cgroup-subsys-attach_task-should-be-called-after-mig.patch
 0002-cgroup-improve-old-cgroup-handling-in-cgroup_attach_.patch
 0003-cgroup-introduce-cgroup_taskset-and-use-it-in-subsys.patch
 0004-cgroup-don-t-use-subsys-can_attach_task-or-attach_ta.patch
 0005-cgroup-cpuset-don-t-use-ss-pre_attach.patch
 0006-cgroup-kill-subsys-can_attach_task-pre_attach-and-at.patch

and is based on the current linux-pm/pm-freezer (7b5b95b3f5 "freezer:
remove should_send_signal() and update frozen()"), and available in
the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer

I based this on top of pm-freezer because cgroup_freezer changes
conflict (easy to resolve but still) and I'm planning on making
further changes to cgroup_freezer which will depend on both freezer
and cgroup changes.  How should we route these changes?

1. As this patchset would affect other cgroup changes, it makes sense
   to route these through the cgroup branch (BTW, where is it?) and
   propagate things there.  In that case, I'll re-spin the patches on
   top of that tree and send a pull request for the merged branch to
   Rafael.

2. Alternatively, if cgroup isn't expected to have too extensive
   changes in this cycle, we can just funnel all these through
   Rafael's tree.

3. Yet another choice would be applying these on Rafael's tree and
   then pull that into cgroup tree as further changes aren't gonna
   affect cgroup all that much.

What do you guys think?

Thank you.

 Documentation/cgroups/cgroups.txt |   46 +++-----
 block/blk-cgroup.c                |   45 +++++---
 include/linux/cgroup.h            |   31 ++++-
 kernel/cgroup.c                   |  200 ++++++++++++++++++++++++--------------
 kernel/cgroup_freezer.c           |   16 ---
 kernel/cpuset.c                   |  105 +++++++++----------
 kernel/events/core.c              |   13 +-
 kernel/sched.c                    |   31 +++--
 mm/memcontrol.c                   |   16 +--
 security/device_cgroup.c          |    7 -
 10 files changed, 289 insertions(+), 221 deletions(-)

--
tejun
