Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2BPWiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:38:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35363 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2BPWiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:38:05 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET] blkcg: update locking and fix stacking
Date: Thu, 16 Feb 2012 14:37:49 -0800
Message-Id: <1329431878-28300-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

This is the third patchset of blkcg API cleanup series and does the
following two things.

* Drops RCU and use double locking.  As with ioc, we might want to
  re-introduce RCU in more restricted form to walk blkg from blkcg but
  for now there's no need.  cgroup deletion is much colder than task
  exit and there's no other path which requires reverse double
  locking.

* Before this patchset, blk-throttle and cfq-iosched propio couldn't
  be used together because for any bios delayed by blk-throttle would
  be issued by a worker thread and get dumped to the default cgroup.
  So, bios will be nondeterministically thrown into the root cg.  This
  isn't a problem limited to blk-throttle.  Any mechanism which punts
  bios to a different task (e.g. btrfs) would mess up IO scheduling
  for both cgroups and iocontexts.

  This patchset implements a mechanism to associate a bio to a task
  (its cgroup and ioc actually) and block layer will handle the
  request as if it were issued by the associated task no matter which
  task actually ends up issuing it to block layer.  It's applied to
  blk-throttle such that any delayed bio is associated to the original
  task.

This patchset contains the following 9 patches.

 0001-blkcg-use-double-locking-instead-of-RCU-for-blkg-syn.patch
 0002-blkcg-drop-unnecessary-RCU-locking.patch
 0003-block-restructure-get_request.patch
 0004-block-interface-update-for-ioc-icq-creation-function.patch
 0005-block-ioc_task_link-can-t-fail.patch
 0006-block-add-io_context-active_ref.patch
 0007-block-implement-bio_associate_current.patch
 0008-block-make-block-cgroup-policies-follow-bio-task-ass.patch
 0009-block-make-blk-throttle-preserve-the-issuing-task-on.patch

 0001-0002 updates locking and strips out RCU.

 0003-0006 prepare for bio task association.

 0007-0009 implement bio task association and apply it to
 blk-throttle.

This patchset is on top of

  block/for-linus 621032ad6eaabf2fe771c4fa0d8f58e1fcfcdba6
+ [1] blkcg: kill policy node and blkg->dev, take#4
+ [2] blkcg: unify blkgs for different policies (updated)

and is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-locking

The git branch has separate branches for previous patchsets, so using
it probably is the easiest way to review this series.  Jens, if you
want the whole thing reposted, please let me know.

diffstat follows.

 block/blk-cgroup.c        |  167 +++++++++++++++++-----------------------------
 block/blk-cgroup.h        |   12 +--
 block/blk-core.c          |   92 ++++++++++++++-----------
 block/blk-ioc.c           |   58 +++++++++------
 block/blk-throttle.c      |   41 +----------
 block/blk.h               |   24 +++---
 block/cfq-iosched.c       |   54 ++++----------
 block/cfq.h               |   10 --
 block/elevator.c          |    5 -
 fs/bio.c                  |   61 ++++++++++++++++
 include/linux/bio.h       |    8 ++
 include/linux/blk_types.h |   10 ++
 include/linux/blkdev.h    |    1 
 include/linux/elevator.h  |    6 +
 include/linux/iocontext.h |   32 ++++++--
 kernel/fork.c             |    5 -
 16 files changed, 299 insertions(+), 287 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1247152
[2] http://thread.gmane.org/gmane.linux.kernel/1247287
