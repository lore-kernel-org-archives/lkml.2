Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1JZBss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:48:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55101 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab1JZBsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:48:47 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET block:for-3.2/core] rescue cfq from RCU death sprial :)
Date: Tue, 25 Oct 2011 18:48:26 -0700
Message-Id: <1319593719-19132-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Over the years, cfq has developed an interesting synchronization
scheme around cic's (cfq_io_context).  Each cic is association between
an ioc (io_context) and a q (request_queue).  As it lives across two
different locking domains, synchronization has some level of inherent
complexity - nesting one way and makes the other way difficult.

cfq used RCU in rather creative ways to resolve the locking order
problem and also to cut on some of locking overhead - cic traversals
from both sides depend on RCU and removal synchronization is done by
setting cic->key to a different value.

Even when used according to usual conventions, RCU can be a bit
challenging to get right; unfortunately, this unconventional use of
RCU in CFQ seems to have devolved into ambiguous pile of partial fixes
- lazy dropping to avoid unlinking race, elevator_ops->trim() and
percpu cic counting to deal with lingering ioc's on module unload, and
so on.  There doesn't seem to be any guiding design regarding
synchronization at this point.

This is a lost cause and the code is extremely fragile and holes
aren't too difficult to spot.  The following one is from cfqd going
away too soon after ioc and q exits raced.

 sd 0:0:1:0: [sdb] Synchronizing SCSI cache
 sd 0:0:1:0: [sdb] Stopping disk
 ata1.01: disabled
 scsi: killing requests for dead queue
 general protection fault: 0000 [#1] PREEMPT SMP
 CPU 2
 Modules linked in:
 [   88.503444]
 Pid: 599, comm: hexdump Not tainted 3.1.0-rc10-work+ #158 Bochs Bochs
 RIP: 0010:[<ffffffff81397628>]  [<ffffffff81397628>] cfq_exit_single_io_context+0x58/0xf0
 RSP: 0018:ffff88001bd79de8  EFLAGS: 00010296
 RAX: 000000000000002a RBX: ffff88001daa6188 RCX: 0000000000000001
 RDX: 0000000000000000 RSI: ffffffff81afdaf1 RDI: ffffffff810950b7
 RBP: ffff88001bd79e18 R08: 0000000000000001 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000001 R12: 6b6b6b6b6b6b6b6b
 R13: ffff88001b7490a0 R14: 0000000000000064 R15: ffff88001bd79f00
 FS:  00007f4452475720(0000) GS:ffff88001fd00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00007f6c11760000 CR3: 000000001b713000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process hexdump (pid: 599, threadinfo ffff88001bd78000, task ffff88001a60e600)
 Stack:
  ffff88001bd79e68 ffff88001b4f3bd8 ffff88001b4f3bd8 ffffffff813975d0
  ffff88001b7490f0 ffff88001e9ca040 ffff88001bd79e58 ffffffff81395a4a
  ffffffff813959f0 ffffffff820883c0 ffff88001e9ca040 ffff88001b4f3bd8
 Call Trace:
  [<ffffffff81395a4a>] call_for_each_cic+0x5a/0x90
  [<ffffffff81395ab5>] cfq_exit_io_context+0x15/0x20
  [<ffffffff81389130>] exit_io_context+0x100/0x140
  [<ffffffff81098a29>] do_exit+0x579/0x850
  [<ffffffff81098d5b>] do_group_exit+0x5b/0xd0
  [<ffffffff81098de7>] sys_exit_group+0x17/0x20
  [<ffffffff81b02f2b>] system_call_fastpath+0x16/0x1b

Also, the complex and unconventional synchronization made the code
very inaccessible and elevator/io_context APIs non-modular.

The thing is that locking scheme here, although non-trivial, can be
much simpler and conventional.  The only actual performance benefit
which can be gained from use of RCU is not acquiring ioc->lock during
cic lookup on request issue path.  Nothing else actually needs or
benefits from RCU.  cic adding and removal from queue side can be done
with straight forward nested locking.

The only complex part is cic removal from ioc side; however,
reverse-order double lock dancing is a well-known trick.  It isn't the
prettiest thing in the world but definitely is way better and more
understandable than the current scheme.  And with fast path
optimization, it doesn't have to be noticeably more expensive either.

So, that's what this patchset does.  It replaces the current RCU based
magic sync scheme with plain double locking w/ only lookup part using
RCU.  The changes don't add any locking overhead to fast path and even
slow path overhead shouldn't be noticeable at all.

This patchset contains the following 13 patches.

 0001-ida-make-ida_simple_get-put-IRQ-safe.patch
 0002-block-cfq-move-cfqd-cic_index-to-q-id.patch
 0003-block-misc-ioc-cleanups.patch
 0004-block-make-ioc-get-put-interface-more-conventional-a.patch
 0005-block-misc-updates-to-blk_get_queue.patch
 0006-block-cfq-misc-updates-to-cfq_io_context.patch
 0007-block-cfq-move-ioc-ioprio-cgroup-changed-handling-to.patch
 0008-block-cfq-fix-race-condition-in-cic-creation-path-an.patch
 0009-block-cfq-fix-cic-lookup-locking.patch
 0010-block-cfq-unlink-cfq_io_context-s-immediately.patch
 0011-block-cfq-remove-delayed-unlink.patch
 0012-block-cfq-kill-ioc_gone.patch
 0013-block-cfq-kill-cic-key.patch

0001-0003 are misc preps.

0004-0005 fix and udpate io_context get/put.

0006-0007 are cfq preps.

0008-0010 updates cic locking such that cic's are added and removed
under both locks and looked up under queue_lock.

0011-0013 drop no longer necessary stuff.

I tried to test most paths w/ injected conditions and instrumentations
but this stuff definitely needs a lot more baking, so definitely not
material for this merge window.

And here are future plans.

* With locking updated, it becomes much easier to reorganize ioc/cic
  interface such that blk-ioc can handle most of cic management so
  that cfq can simply request and use cic's, so that's the next step.

* blkcg support basically suffers from the same problem both in
  locking and API separation, so that'll be the next one once ioc side
  is done.

This patchset is on top of

  block:for-3.2/core 334c2b0b8b "blk-throttle: use queue_is_locked() instead..."
+ [1] patchset "further updates to blk_cleanup_queue(), take#2"

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cfq-sync

diffstat follows.

 block/blk-cgroup.c        |   11 -
 block/blk-core.c          |   32 +--
 block/blk-ioc.c           |  356 +++++++++++++++++++++++++--------
 block/blk-sysfs.c         |    2 
 block/blk.h               |   12 +
 block/bsg.c               |    4 
 block/cfq-iosched.c       |  485 ++++++++++++++--------------------------------
 block/elevator.c          |   16 -
 block/genhd.c             |    2 
 drivers/scsi/scsi_scan.c  |    2 
 fs/ioprio.c               |   24 --
 include/linux/blkdev.h    |   11 -
 include/linux/elevator.h  |   18 -
 include/linux/iocontext.h |   40 +--
 kernel/fork.c             |    8 
 lib/idr.c                 |   11 -
 16 files changed, 515 insertions(+), 519 deletions(-)

Thank you.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1207608
