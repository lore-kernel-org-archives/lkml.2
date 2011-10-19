Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1JSE0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:26:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab1JSE0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:26:30 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Cc: ctalbott@google.com, ni@google.com
Subject: [PATCHSET block/for-next] fix request_queue life-cycle management
Date: Tue, 18 Oct 2011 21:26:14 -0700
Message-Id: <1318998384-22525-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_queue life-cycle management is broken in that while it's
lifetime is determined by reference count, it relies on the q owner to
guarantee that no request will traverse it once it's shut down using
blk_cleanup_queue().

As there are other holders of a queue (e.g. bsg), the owner
(e.g. SCSI) doesn't have any way to know whether requests from other
users are in flight or prevent others from issuing further requests.

In most cases, one of the unsynchronized QUEUE_FLAG_DEAD tests
somewhere catches those stray requests; however, with bad enough luck,
or mdelay()'s at the right spot, this broken shutdown/release
implementation leads to all sorts of fun during device removal.

* elv_merge() calling into elevator to investigate merging
   possibilities after blk_cleanup_queue() destroyed elevator.

 Pid: 648, comm: test_rawio Not tainted 3.1.0-rc3-work+ #56 Bochs Bochs
 RIP: 0010:[<ffffffff8137d651>]  [<ffffffff8137d651>] elv_rqhash_find+0x61/0x100
 ...
 Call Trace:
  [<ffffffff8137d774>] elv_merge+0x84/0xe0
  [<ffffffff81385b54>] blk_queue_bio+0xf4/0x400
  [<ffffffff813838ea>] generic_make_request+0xca/0x100
  [<ffffffff81383994>] submit_bio+0x74/0x100
  [<ffffffff811c53ec>] dio_bio_submit+0xbc/0xc0
  [<ffffffff811c610e>] __blockdev_direct_IO+0x92e/0xb40
  [<ffffffff811c39f7>] blkdev_direct_IO+0x57/0x60
  [<ffffffff8113b1c5>] generic_file_aio_read+0x6d5/0x760
  [<ffffffff8118c1ca>] do_sync_read+0xda/0x120
  [<ffffffff8118ce55>] vfs_read+0xc5/0x180
  [<ffffffff8118cfaa>] sys_pread64+0x9a/0xb0
  [<ffffffff81afaf6b>] system_call_fastpath+0x16/0x1b

* get_request() calling into destroyed elevator.

 Pid: 649, comm: test_rawio Not tainted 3.1.0-rc3-work+ #57 Bochs Bochs
 RIP: 0010:[<ffffffff8137d300>]  [<ffffffff8137d300>] elv_may_queue+0x10/0x20
 ...
 Call Trace:
  [<ffffffff81383f18>] get_request+0x58/0x440
  [<ffffffff81384329>] get_request_wait+0x29/0x1e0
  [<ffffffff81385aaa>] blk_queue_bio+0x12a/0x3e0
  [<ffffffff813838ea>] generic_make_request+0xca/0x100
  [<ffffffff81383994>] submit_bio+0x74/0x100
  [<ffffffff811c53ec>] dio_bio_submit+0xbc/0xc0
  [<ffffffff811c610e>] __blockdev_direct_IO+0x92e/0xb40
  [<ffffffff811c39f7>] blkdev_direct_IO+0x57/0x60
  [<ffffffff8113b1c5>] generic_file_aio_read+0x6d5/0x760
  [<ffffffff8118c1ca>] do_sync_read+0xda/0x120
  [<ffffffff8118ce55>] vfs_read+0xc5/0x180
  [<ffffffff8118cfaa>] sys_pread64+0x9a/0xb0
  [<ffffffff81afae6b>] system_call_fastpath+0x16/0x1b

* If blk-throtl had any bio's throttled on blk_cleanup_queue(), those
  bio's get lost leaving their issuers in eternal D state.

This can be solved by implementing proper shutdown/release model,
where shutdown marks the queue dead under proper synchronization,
drains whatever's in-flight and all issuers checking dead state under
proper synchronization before proceeding.

This patchset implements the above with the following ten patches.

 0001-block-make-gendisk-hold-a-reference-to-its-queue.patch
 0002-block-fix-genhd-refcounting-in-blkio_policy_parse_an.patch
 0003-block-move-blk_throtl-prototypes-to-block-blk.h.patch
 0004-block-pass-around-REQ_-flags-instead-of-broken-down-.patch
 0005-block-drop-unnecessary-blk_get-put_queue-in-scsi_cmd.patch
 0006-block-reorganize-queue-draining.patch
 0007-block-reorganize-throtl_get_tg-and-blk_throtl_bio.patch
 0008-block-make-get_request-_wait-fail-if-queue-is-dead.patch
 0009-block-drop-tsk-from-attempt_plug_merge-and-explain-s.patch
 0010-block-fix-request_queue-lifetime-handling-by-making-.patch

* 0001 is re-post of [1] "block: make gendisk hold a reference to its
  queue" with WARN_ON_ONCE() bug fixed.  Included here as
  block/for-next doesn't have this commit yet.

* 0002 fixes genhd refcnt leak from blkcg.

* 0003-0007 are prep patches cleaning up stuff.

* 0008-0010 implement proper shutdown/release.

This patchset is on top of the block/for-next cef1e172c7 "Merge branch
'for-3.2/mtip32xx' into for-next" and available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-ref

diffstat follows.

 block/blk-cgroup.c       |   56 +++++--------
 block/blk-core.c         |  200 +++++++++++++++++++++++++++++++----------------
 block/blk-sysfs.c        |    1 
 block/blk-throttle.c     |  106 ++++++++++++++----------
 block/blk.h              |   20 ++++
 block/elevator.c         |   37 ++------
 block/genhd.c            |    8 +
 block/scsi_ioctl.c       |    3 
 fs/block_dev.c           |   13 +--
 include/linux/blkdev.h   |   14 ---
 include/linux/elevator.h |    6 +
 11 files changed, 274 insertions(+), 190 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1204025
