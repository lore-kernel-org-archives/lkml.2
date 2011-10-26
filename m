Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1JZBCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:02:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51402 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1JZBCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:02:13 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        hch@infradead.org
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET block:for-3.2/core] further updates to blk_cleanup_queue(), take#2
Date: Tue, 25 Oct 2011 18:02:01 -0700
Message-Id: <1319590927-15791-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

This is the second take of "further updates to blk_cleanup_queue()"
patchset.  The only change from the last take[L] is rebase to
for-3.2/core and update to 0002 (and the cascades from it) so that it
runs queue synchrononously if called from sleepable context.  This
should resolve hch's concern about drivers which could use the path
frequently.

Original description follows.

Patchset "fix request_queue life-cycle management"[1] tried to fix
lifecycle management by making blk_cleanup_queue() drain and shut down
the queue; however, there still are some holes.  This patchset
tightens externally visible API a bit and plugs those holes.

 0001-block-sx8-kill-blk_insert_request.patch
 0002-block-allow-blk_execute_rq_nowait-to-be-called-from-.patch
 0003-block-ide-unexport-elv_add_request.patch
 0004-block-add-blk_queue_dead.patch
 0005-block-fix-drain_all-condition-in-blk_drain_queue.patch
 0006-block-add-missing-blk_queue_dead-checks.patch

0001-0003 remove/unexport two request insertion functions which don't
have proper DEAD check.  Users are switched to
blk_execute_rq_nowait().

0004 adds blk_queue_dead() macro for convenience.

0005 updates blk_drain_queue() such that it also waits for requests
which weren't allocated from block layer.

0006 adds missing DEAD checks.

This patchset is on top of the block:for-3.2/core 334c2b0b8b
"blk-throttle: use queue_is_locked() instead of lockdep_is_held()" and
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-ref

diffstat follows.

 block/blk-core.c         |  105 ++++++++++++++++++++---------------------------
 block/blk-exec.c         |   34 +++++++++++----
 block/blk-flush.c        |    2 
 block/blk-sysfs.c        |    4 -
 block/blk-throttle.c     |    4 -
 block/blk.h              |    3 -
 block/elevator.c         |   16 +------
 drivers/block/sx8.c      |   12 +++--
 drivers/ide/ide-atapi.c  |    7 +--
 drivers/ide/ide-park.c   |    2 
 include/linux/blkdev.h   |    2 
 include/linux/elevator.h |    2 
 12 files changed, 94 insertions(+), 99 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1206028
[1] http://thread.gmane.org/gmane.linux.kernel/1205150
