Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab2IKS2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:28:55 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:37626 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2IKS2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:28:53 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: viro@zeniv.linux.org.uk
Cc: jack@suse.cz, hch@lst.de, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Date: Wed, 12 Sep 2012 03:28:42 +0900
Message-ID: <87wr002z39.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If bdi has BDI_CAP_NO_WRITEBACK, bdi_forker_thread() doesn't start
writeback thread. This means there is no consumer of work item made
by bdi_queue_work().

This adds to checking of !bdi_cap_writeback_dirty(sb->s_bdi) before
calling bdi_queue_work(), otherwise queued work never be consumed.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fs-writeback.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~noop_backing_dev_info-check-fix fs/fs-writeback.c
--- linux/fs/fs-writeback.c~noop_backing_dev_info-check-fix	2012-09-11 06:12:30.000000000 +0900
+++ linux-hirofumi/fs/fs-writeback.c	2012-09-11 06:12:30.000000000 +0900
@@ -120,6 +120,9 @@ __bdi_start_writeback(struct backing_dev
 {
 	struct wb_writeback_work *work;
 
+	if (!bdi_cap_writeback_dirty(bdi))
+		return;
+
 	/*
 	 * This is WB_SYNC_NONE writeback, so if allocation fails just
 	 * wakeup the thread for old dirty data writeback
@@ -1310,7 +1313,7 @@ void writeback_inodes_sb_nr(struct super
 		.reason			= reason,
 	};
 
-	if (sb->s_bdi == &noop_backing_dev_info)
+	if (!bdi_cap_writeback_dirty(sb->s_bdi))
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 	bdi_queue_work(sb->s_bdi, &work);
@@ -1396,7 +1399,7 @@ void sync_inodes_sb(struct super_block *
 	};
 
 	/* Nothing to do? */
-	if (sb->s_bdi == &noop_backing_dev_info)
+	if (!bdi_cap_writeback_dirty(sb->s_bdi))
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
