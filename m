Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2AWXKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:10:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54228 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2AWXJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:09:58 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET] blkcg: kill policy node and blkg->dev, take#3
Date: Mon, 23 Jan 2012 15:09:37 -0800
Message-Id: <1327360193-24679-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

This is the third take of blkcg-kill-policy-node-and-blkg_dev
patchset.  Changes from the last take[L] are,

* 0001-blkcg-make-CONFIG_BLK_CGROUP-bool.patch fixed as suggested by
  Vivek.

* 0007-blkcg-make-blkio_list_lock-irq-safe.patch dropped and
  lock order inversion involving blkio_list_lock fixed.

* 0007-blkcg-shoot-down-blkio_groups-on-elevator-switch.patch updated
  to avoid shooting down blk-throtl's root_group and retry when lost
  race against blkcg removal.

blk-cgroup, blk-throttle and cfq-iosched are pretty tightly tangled
and untangling requires seemingly unrelated changes and addition of
some transitional stuff.  Some are in this patchset but they'll be
more prominent in the second patchset.  This patchset concentrates on
removing blkio_policy_node and blkio_group->dev, and preparing for the
next patchset which will unify blkg so that there's single blkg per
cgroup - request_queue pair.

blkio_policy_node carries configuration per cgroup-request_queue
association separately from the matching blkio_group.  The goal seems
to be allowing configuration of missing devices and retaining
configuration across hot unplug/plug cycles.  Such behavior is very
different from existing conventions, misleading and unnecessary.  This
patchset moves configuration to blkio_group and removes
blkio_policy_node.

blkg->dev removal is much simpler.  blkg->dev is used to print out
device number when printing out per-device configurations or
statistics.  The device name can be easily determined by following the
associated request_queue from blkg instead.

This patchset makes the following two userland visible behavior
changes.

* Per-device blkcg configuration can't be done for non-existing
  devices.  This behavior change is intentional and permanent.

* Switching elevator clears per-device blk-throtl configuration.  This
  behavior change is transitional and will be restored with later
  patches.

This patchset contains the following 16 patches.

 0001-blkcg-make-CONFIG_BLK_CGROUP-bool.patch
 0002-cfq-don-t-register-propio-policy-if-CONFIG_CFQ_GROUP.patch
 0003-elevator-clear-auxiliary-data-earlier-during-elevato.patch
 0004-elevator-make-elevator_init_fn-return-0-errno.patch
 0005-block-implement-blk_queue_bypass_start-end.patch
 0006-block-extend-queue-bypassing-to-cover-blkcg-policies.patch
 0007-blkcg-shoot-down-blkio_groups-on-elevator-switch.patch
 0008-blkcg-move-rcu_read_lock-outside-of-blkio_group-get-.patch
 0009-blkcg-update-blkg-get-functions-take-blkio_cgroup-as.patch
 0010-blkcg-use-q-and-plid-instead-of-opaque-void-for-blki.patch
 0011-blkcg-add-blkio_policy-array-and-allow-one-policy-pe.patch
 0012-blkcg-use-the-usual-get-blkg-path-for-root-blkio_gro.patch
 0013-blkcg-factor-out-blkio_group-creation.patch
 0014-blkcg-don-t-allow-or-retain-configuration-of-missing.patch
 0015-blkcg-kill-blkio_policy_node.patch
 0016-blkcg-kill-the-mind-bending-blkg-dev.patch

0001-0004: misc preps including elevator switch update

0005-0007: ensure blkcg policies are quiescent across elvswitch

0008-0013: move common part of blkg management into blkcg core

0014-0015: kill blkio_policy_node

0016     : kill blkg->dev

This patchset is on top of v3.3-rc1 and also available in the
following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-kill-pn

 block/Kconfig.iosched    |    4 
 block/blk-cgroup.c       |  686 ++++++++++++++++-------------------------------
 block/blk-cgroup.h       |  106 ++-----
 block/blk-core.c         |   53 +++
 block/blk-throttle.c     |  286 ++++++-------------
 block/blk.h              |    6 
 block/cfq-iosched.c      |  296 ++++++++------------
 block/cfq.h              |    7 
 block/deadline-iosched.c |    8 
 block/elevator.c         |  116 +++----
 block/noop-iosched.c     |    8 
 include/linux/blkdev.h   |    5 
 include/linux/elevator.h |    2 
 init/Kconfig             |    2 
 14 files changed, 606 insertions(+), 979 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1242220
