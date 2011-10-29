Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab1J2Xt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:49:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab1J2Xtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:52 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET block:for-3.2/core] cleanup io_context interface
Date: Sat, 29 Oct 2011 16:49:37 -0700
Message-Id: <1319932187-7631-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Over time, cfq and io_context has grown into each other and currently
it isn'tq clear which part belongs where.  Some of cfq internals live
in io_context code and vice-versa.  This makes the code error-prone,
difficult to understand.

With locking simplified, io_context interface can be cleaned up now.
This patchset moves bulk of io_cq management from cfq to block core.
This provides clean separation between iosched algorithm
implementation and ioc / ioc-q association (icq, formerly cic's)
management which is a bit complex due to the locking requirements.

Elevators now can simply set .icq_size and align in elevator_type and
block layer will automatically manage icq's and guarantee correct
behavior across ioc, q exits and elevator switches.

Comments are added to iocontext.h to explain the rules for using icq.

 0001-block-cfq-replace-current_io_context-with-create_io_.patch
 0002-block-reorder-elevator-switch-sequence.patch
 0003-block-remove-elevator_queue-ops.patch
 0004-block-cfq-reorganize-cfq_io_context-into-generic-and.patch
 0005-block-cfq-move-cfqd-icq_list-to-request_queue-and-ad.patch
 0006-block-cfq-move-io_cq-lookup-to-blk-ioc.c.patch
 0007-block-cfq-move-icq-cache-management-to-block-core.patch
 0008-block-cfq-move-io_cq-exit-release-to-blk-ioc.c.patch
 0009-block-cfq-restructure-io_cq-creation-path-for-io_con.patch
 0010-block-cfq-move-icq-creation-and-rq-elv.icq-associati.patch

This patchset is on top of

  block:for-3.2/core 334c2b0b8b "blk-throttle: use queue_is_locked() instead..."
+ [1] patchset "further updates to blk_cleanup_queue(), take#2"
+ [2] patchset "rescue cfq from RCU death spiral"

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-ioc

Jens, this patchset is the last of io_context related updates;
however, as I wrote earlier, I'm thinking about doing similar updates
to blkcg code which has basically the same issues.  I'll wait for
reviews on the pending patchsets and then proceed.

diffstat follows.  Added lines are from comments.  Without them total
LOC is negative.

 block/blk-core.c          |   72 ++++++--
 block/blk-ioc.c           |  282 ++++++++++++++++++++++---------
 block/blk-sysfs.c         |    6 
 block/blk.h               |   49 ++++-
 block/cfq-iosched.c       |  408 +++++++++++-----------------------------------
 block/deadline-iosched.c  |    4 
 block/elevator.c          |  203 ++++++++++++----------
 block/noop-iosched.c      |    4 
 include/linux/blkdev.h    |   10 -
 include/linux/elevator.h  |   23 ++
 include/linux/iocontext.h |  114 +++++++++---
 11 files changed, 630 insertions(+), 545 deletions(-)

Thank you.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1207608
[2] http://thread.gmane.org/gmane.linux.kernel/1207624
