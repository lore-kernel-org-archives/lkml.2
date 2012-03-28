Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2C1OXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:23:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:62903 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571Ab2C1OXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:23:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124321358"
Message-Id: <20120328121308.568545879@intel.com>
User-Agent: quilt/0.51-1
Date: Wed, 28 Mar 2012 20:13:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linux Memory Management List <linux-mm@kvack.org>
cc: Vivek Goyal <vgoyal@redhat.com>
cc: Suresh Jayaraman <sjayaraman@suse.com>,
        Andrea Righi <andrea@betterlinux.com>
cc: Jeff Moyer <jmoyer@redhat.com>
cc: <linux-fsdevel@vger.kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] buffered write IO controller in balance_dirty_pages()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is one possible solution to "buffered write IO controller", based on Linux
v3.3

git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git  buffered-write-io-controller

Features:
- support blkio.weight
- support blkio.throttle.buffered_write_bps

Possibilities:
- it's trivial to support per-bdi .weight or .buffered_write_bps

Pros:
1) simple
2) virtually no space/time overheads
3) independent of the block layer and IO schedulers, hence
3.1) supports all filesystems/storages, eg. NFS/pNFS, CIFS, sshfs, ...
3.2) supports all IO schedulers. One may use noop for SSDs, inside virtual machines, over iSCSI, etc.

Cons:
1) don't try to smooth bursty IO submission in the flusher thread (*)
2) don't support IOPS based throttling
3) introduces semantic differences to blkio.weight, which will be
   - working by "bandwidth" for buffered writes
   - working by "device time" for direct IO

(*) Maybe not a big concern, since the bursties are limited to 500ms: if one dd
is throttled to 50% disk bandwidth, the flusher thread will be waking up on
every 1 second, keep the disk busy for 500ms and then go idle for 500ms; if
throttled to 10% disk bandwidth, the flusher thread will wake up on every 5s,
keep busy for 500ms and stay idle for 4.5s.

The test results included in the last patch look pretty good in despite of the
simple implementation.

 [PATCH 1/6] blk-cgroup: move blk-cgroup.h in include/linux/blk-cgroup.h
 [PATCH 2/6] blk-cgroup: account dirtied pages
 [PATCH 3/6] blk-cgroup: buffered write IO controller - bandwidth weight
 [PATCH 4/6] blk-cgroup: buffered write IO controller - bandwidth limit
 [PATCH 5/6] blk-cgroup: buffered write IO controller - bandwidth limit interface
 [PATCH 6/6] blk-cgroup: buffered write IO controller - debug trace

The changeset is dominated by the blk-cgroup.h move.
The core changes (to page-writeback.c) are merely 77 lines.

 block/blk-cgroup.c               |   27 +
 block/blk-cgroup.h               |  364 --------------------------
 block/blk-throttle.c             |    2 
 block/cfq.h                      |    2 
 include/linux/blk-cgroup.h       |  396 +++++++++++++++++++++++++++++
 include/trace/events/writeback.h |   34 ++
 mm/page-writeback.c              |   77 +++++
 7 files changed, 530 insertions(+), 372 deletions(-)

Thanks,
Fengguang

