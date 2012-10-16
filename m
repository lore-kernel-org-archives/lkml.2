Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab2JPW2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:28:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63115 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab2JPW2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:28:52 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration regardless of freezer state and update locking
Date: Tue, 16 Oct 2012 15:28:39 -0700
Message-Id: <1350426526-14254-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset updates cgroup_freezer so that

* Unfreezable kernel tasks don't prevent a cgroup from transitioning
  into FROZEN from FREEZING.  There's nothing userland can do with or
  about such tasks.

* Tasks can be moved in and out of a frozen cgroup.  Tasks are made to
  conform to the state of the new cgroup during migration.  This
  behavior makes a lot more sense and removes the use of
  ->can_attach() which makes co-mounting difficult.

* Remove use of cgroup_lock_live_group().  Grabbing cgroup_lock from
  outside cgroup proper creates a painful locking dependency and is
  being phased out.  With the above behavior change, removing
  dependency on cgroup_lock is pretty easy.  IMHO, it was simply the
  wrong behavior to implement which forced the wrong implementation.

This patchset contains the following seven patches.

 0001-cgroup-cgroup_subsys-fork-should-be-called-after-the.patch
 0002-freezer-add-missing-mb-s-to-freezer_count-and-freeze.patch
 0003-cgroup_freezer-make-it-official-that-writes-to-freez.patch
 0004-cgroup_freezer-don-t-stall-transition-to-FROZEN-for-.patch
 0005-cgroup_freezer-allow-moving-tasks-in-and-out-of-a-fr.patch
 0006-cgroup_freezer-prepare-update_if_frozen-for-locking-.patch
 0007-cgroup_freezer-don-t-use-cgroup_lock_live_group.patch

0001 is a fix for a rather embarrassing bug in cgroup core.  It does
things in the wrong order leaving a window for racing during fork.

0002 adds a missing mb() around freezing condition updates / checks.

0003-0004 make cgroup_freezer ignore unfreezable kernel tasks and
handle PF_FREEZER_SKIP correctly.

0005 allows migrating tasks in and out of a frozen cgroup.

0006-0007 remove the use of cgroup_lock_live_group().

This patchset is on top of v3.7-rc1 and available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup_freezer-locking

 include/linux/cgroup.h  |    1 
 include/linux/freezer.h |   50 +++++++++--
 kernel/cgroup.c         |   62 ++++++--------
 kernel/cgroup_freezer.c |  210 ++++++++++++++++--------------------------------
 kernel/fork.c           |    9 --
 5 files changed, 147 insertions(+), 185 deletions(-)

Thanks.

--
tejun
