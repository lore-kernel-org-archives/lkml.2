Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab2DZV7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:59:37 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:42415 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab2DZV7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:59:35 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: [PATCHSET] block: implement per-blkg request allocation
Date: Thu, 26 Apr 2012 14:59:10 -0700
Message-Id: <1335477561-11131-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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

 0001-blkcg-fix-blkg_alloc-failure-path.patch
 0002-blkcg-__blkg_lookup_create-doesn-t-have-to-fail-on-r.patch
 0003-blkcg-make-root-blkcg-allocation-use-GFP_KERNEL.patch
 0004-mempool-add-gfp_mask-to-mempool_create_node.patch
 0005-block-drop-custom-queue-draining-used-by-scsi_transp.patch
 0006-block-refactor-get_request-_wait.patch
 0007-block-allocate-io_context-upfront.patch
 0008-blkcg-inline-bio_blkcg-and-friends.patch
 0009-block-add-q-nr_rqs-and-move-q-rq.elvpriv-to-q-nr_rqs.patch
 0010-block-prepare-for-multiple-request_lists.patch
 0011-blkcg-implement-per-blkg-request-allocation.patch

0001-0003 are assorted fixes / improvements which can be separated
from this patchset.  Just sending as part of this series for
convenience.

0004 adds @gfp_mask to mempool_create_node().  This is necessary
because blkg allocation is on the IO path and now blkg contains
mempool for request_list.  Note that blkg allocation failure doesn't
lead to catastrophic failure.  It just hinders blkcg enforcement.

0005 drops custom queue draining which I dont't think is necessary and
hinders with further updates.

0006-0010 are prep patches and 0011 implements per-blkg request
allocation.

This patchset is on top of,

  block/for-3.5/core bd1a68b59c "vmsplice: relax alignement requireme..."
+ [1] blkcg: tg_stats_alloc_lock is an irq lock

and is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-rl

Jens, I still can't reproduce the boot failure you were seeing on
block/for-3.5/core, so am just basing this series on top.  Once we
figure that one out, we can resequence the patches.

Thanks.

 block/blk-cgroup.c                  |  147 ++++++++++++++++----------
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
 13 files changed, 379 insertions(+), 291 deletions(-)

--
tejun

[1] http://article.gmane.org/gmane.linux.kernel/1288400
