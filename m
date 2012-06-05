Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409Ab2FEDlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 23:41:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43604 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2FEDlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 23:41:09 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        fengguang.wu@intel.com, hughd@google.com, akpm@linux-foundation.org
Subject: [PATCHSET] block: implement per-blkg request allocation, take#2
Date: Mon,  4 Jun 2012 20:40:50 -0700
Message-Id: <1338867660-4689-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(The posting yesterday went out w/o lkml cc'd and old head message,
 resending w/ Vivek's suggestions applied.  Sorry about the noise.)

This is the second take of "implement per-blkg request allocation"
patchset.  Changes from the last take[L] are

* 0001-fix-blkg_alloc-failure-path patch is separated from this series
  and merged to block/for-linus.

* Updated patches posted incrementally merged into the series.

* Rebased on top of the current block/for-linus.

* Documentation/block/queue-sysfs.txt updated to note that nr_requests
  is per-blkcg.

* Acked/Reviewed-by's added.

The original description follows.

Currently block layer shares a single request_list (@q->rq) for all
IOs regardless of their blkcg associations.  This means that once the
shared pool is exhausted, blkcg limits don't mean much.  Whoever grabs
the requests being freed the first grabs the next IO slot.

This priority inversion can be easily demonstrated by creating a blkio
cgroup w/ very low weight, put a program which can issue a lot of
random direct IOs there and running a sequential IO from a different
cgroup.  As soon as the request pool is used up, the sequential IO
bandwidth crashes.

This patchset implements per-blkg request allocation so that each
blkcg-request_queue pair has its own request pool to allocate from.
This isolates different blkcgs in terms of request allocation.

Most changes are straight-forward; unfortunately, bdi isn't
blkcg-aware yet so it currently just propagates the congestion state
from root blkcg.  As writeback currently is always on the root blkcg,
this kinda works for write congestion but readahead may behave
non-optimally under congestion for now.  This needs to be improved but
the situation is still way better than blkcg completely collapsing.

 0001-blkcg-__blkg_lookup_create-doesn-t-need-radix-preloa.patch
 0002-blkcg-make-root-blkcg-allocation-use-GFP_KERNEL.patch
 0003-mempool-add-gfp_mask-to-mempool_create_node.patch
 0004-block-drop-custom-queue-draining-used-by-scsi_transp.patch
 0005-block-refactor-get_request-_wait.patch
 0006-block-allocate-io_context-upfront.patch
 0007-blkcg-inline-bio_blkcg-and-friends.patch
 0008-block-add-q-nr_rqs-and-move-q-rq.elvpriv-to-q-nr_rqs.patch
 0009-block-prepare-for-multiple-request_lists.patch
 0010-blkcg-implement-per-blkg-request-allocation.patch

0001-0002 are misc preps.

0003 adds @gfp_mask to mempool_create_node().  This is necessary
because blkg allocation is on the IO path and now blkg contains
mempool for request_list.  Note that blkg allocation failure doesn't
lead to catastrophic failure.  It just hinders blkcg enforcement.

0004 drops custom queue draining which I dont't think is necessary and
hinders with further updates.

0005-0009 are prep patches and 0010 implements per-blkg request
allocation.

This patchset is on top of the current block/for-linus - 9b2ea86bc9e
"blkcg: fix blkg_alloc() failure path" and is also available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-rl

 Documentation/block/queue-sysfs.txt |    7 +
 block/blk-cgroup.c                  |  139 ++++++++++++++++---------
 block/blk-cgroup.h                  |  121 +++++++++++++++++++++
 block/blk-core.c                    |  200 ++++++++++++++++++------------------
 block/blk-sysfs.c                   |   34 +++---
 block/blk-throttle.c                |    3 
 block/blk.h                         |    3 
 block/bsg-lib.c                     |   53 ---------
 drivers/scsi/scsi_transport_fc.c    |   38 ------
 drivers/scsi/scsi_transport_iscsi.c |    2 
 include/linux/blkdev.h              |   53 +++++----
 include/linux/bsg-lib.h             |    1 
 include/linux/mempool.h             |    3 
 mm/mempool.c                        |   12 +-
 14 files changed, 382 insertions(+), 287 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel.containers/23159
