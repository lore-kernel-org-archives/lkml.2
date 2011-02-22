Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1BVDxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:53:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab1BVDxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:53:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: neilb@suse.de, sergey.senozhatsky@gmail.com, tj@kernel.org,
        jmoyer@redhat.com, snitzer@redhat.com
Subject: [PATCH 0/3] [RFC] block: Enforce that ->queue_lock is initialized during call to blk_cleanup_queue()
Date: Mon, 21 Feb 2011 22:53:34 -0500
Message-Id: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Currently it is not clear what's the status of ->queue_lock when
blk_cleanup_queue() is called. Now block throttle code (blk_throtl_exit())
requires queue lock to be initialized as it takes the spin lock, so we need
some kind of clear convention that when is it safe to assume that queue lock
is initiliazed and blk_throtle_exit() can be called safely.

We recently ran into issues with loop driver which was trying to free
up queue almost immediately after block_alloc_queue() due to some internal
errors. Also NeilBrown complained that in current form, md provides its
own spinlock and zaps that before blk_cleanup_queue() call and that will
have issues with throttling code. Neil has not fixed the issue with
md driver and queued up a patch in this tree.

So there is a need to make sure blk_throtl_exit() can be called safely
and to also catch any errors if some drivers are not doing so. This
patch series puts a WARN_ON(!q->queue_lock) in blk_cleanup_queue() and
moves the queue lock initialization in queue allocation code. Also it
move blk_throtl_exit() from release_queue() to cleanup_queue().

These pathes are only boot tested on one machine. Before I do more
extensive testing, I wanted to throw it out there and figure out
if it makes sense or not.

Thanks
Vivek

Vivek Goyal (3):
  block: Initialize ->queue_lock to internal lock at queue allocation
    time
  loop: No need to initialize ->queue_lock explicitly before calling
    blk_cleanup_queue()
  block: Move blk_throtl_exit() call to blk_cleanup_queue()

 block/blk-core.c       |   26 ++++++++++++++++++++++++--
 block/blk-settings.c   |    7 -------
 block/blk-sysfs.c      |    2 --
 block/blk-throttle.c   |    2 +-
 drivers/block/loop.c   |    3 ---
 include/linux/blkdev.h |    2 --
 6 files changed, 25 insertions(+), 17 deletions(-)

