Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1JUD4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 23:56:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52008 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab1JUD4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 23:56:45 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com
Subject: [PATCHSET block:for-3.2/core] further updates to blk_cleanup_queue()
Date: Thu, 20 Oct 2011 20:56:34 -0700
Message-Id: <1319169400-15706-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Patchset "fix request_queue life-cycle management"[1] tried to fix
lifecycle management by making blk_cleanup_queue() drain and shut down
the queue; however, there still are some holes.  This patchset
tightens externally visible API a bit and plugs those holes.

 0001-block-sx8-kill-blk_insert_request.patch
 0002-block-allow-blk_execute_rq_nowait-to-be-called-form-.patch
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

This patchset is on top of the block:for-3.2/core 3bcfeaf93f4 "block:
initialize the bounce pool if high memory may be added later" and
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-ref

diffstat follows.

 block/blk-core.c         |  105 ++++++++++++++++++++---------------------------
 block/blk-exec.c         |   15 ++++--
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
 12 files changed, 78 insertions(+), 96 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1205150
