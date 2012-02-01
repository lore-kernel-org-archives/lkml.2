Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab2BAV2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:28:21 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34095 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab2BAVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:23 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET] blkcg: unify blkgs for different policies
Date: Wed,  1 Feb 2012 13:19:05 -0800
Message-Id: <1328131156-13290-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

Currently, blkcg policies have and manage their own blkgs, so blkgs
are per cgroup-queue-policy combination instead of cgroup-queue
combination.  This leads to nasty problems.  It isn't clear which part
are common to both policies.  There are unused duplicates in common
part of blkg and it isn't trivial to tell which part is being used.
The separation also leads to duplicate logic in both policies which
makes the code difficult to follow, prone to subtle bugs and, most
importantly, hinders proper layering between blkcg core and policy
implementations.

Because locking, blkg management, elvswitch and policy
[de]registration are tightly woven, it is challenging to untangle -
doing proper in-place policy data replacement requires locking
improvements which in turn is painful to do when policy
implementations are doing their own things with blkgs.

As a transitional step, all blkgs other than root one are shot down on
policy [de]registration and root blkg is updated in place.  This is
hackish but should get us through locking update after which we can
implement in-place update for all blkgs safely.  While this does
introduce race window while policies are being [de]registered, this
isn't anything new (e.g. none of stat update functions synchronize
against policy update) and shouldn't cause any actual problem given
blk-throttle can't be built as module and cfq-iosched is default
iosched on most installations.

This patchset was pretty painful but I think/hope things will be
eaiser from here on.  Note that this patchset does add ~180 LOC.  Some
of them are comments and it's expected to shrink again with further
cleanups and removal of transitional stuff.

Changes to come are:

* locking simplification

* proper in-place update of policy data for all blkgs on policy
  change

* fix broken blkcg switch after throttling.

* use unified stats updated under queue lock and drop percpu stats
  which should fix locking / context bug across percpu allocation.

* make set of applied policies per-queue

* move stats and conf into their owning policies and let blkcg core
  provide generic framework / helper instead of hard coding all the
  possible ones.  This should be accompanied by cgroup updates to
  allow changing files in cgroupfs.  Not sure how this will turn out
  yet.

This patchset contains the following 11 patches.

 0001-blkcg-let-blkio_group-point-to-blkio_cgroup-directly.patch
 0002-block-relocate-elevator-initialized-test-from-blk_cl.patch
 0003-blkcg-add-blkcg_-init-drain-exit-_queue.patch
 0004-blkcg-clear-all-request_queues-on-blkcg-policy-un-re.patch
 0005-blkcg-let-blkcg-core-handle-policy-private-data-allo.patch
 0006-blkcg-move-refcnt-to-blkcg-core.patch
 0007-blkcg-make-blkg-pd-an-array-and-move-configuration-a.patch
 0008-blkcg-don-t-use-blkg-plid-in-stat-related-functions.patch
 0009-blkcg-move-per-queue-blkg-list-heads-and-counters-to.patch
 0010-blkcg-let-blkcg-core-manage-per-queue-blkg-list-and-.patch
 0011-blkcg-unify-blkg-s-for-blkcg-policies.patch

 0001-0003 are prep patches.

 0004 shoots down all non-root blkgs on policy [de]registration.

 0005 separates per-policy data from common part of blkg and allocate
 them separately from blkcg core.

 0006-0010 collect common data fields and logic from policy
 implementations into blkcg core.

 0011 unifies blkgs so that there's one blkg per cgroup-queue pair.

This patchset is on top of

  v3.3-rc2 62aa2b537c6f5957afd98e29f96897419ed5ebab
+ [1] blkcg: kill policy node and blkg->dev, take#4

and is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-unified-blkg

diffstat follows.

 block/blk-cgroup.c     |  674 +++++++++++++++++++++++++++++++++++--------------
 block/blk-cgroup.h     |  211 +++++++++++----
 block/blk-core.c       |   26 +
 block/blk-sysfs.c      |    6 
 block/blk-throttle.c   |  232 +++-------------
 block/blk.h            |    2 
 block/cfq-iosched.c    |  274 +++++--------------
 block/cfq.h            |   96 ++++--
 block/elevator.c       |    2 
 include/linux/blkdev.h |    7 
 10 files changed, 853 insertions(+), 677 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1247152
