Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2ECMtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:49:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab2ECMsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:36 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/9] writeback: Move clearing of I_SYNC into inode_sync_complete()
Date: Thu,  3 May 2012 14:47:55 +0200
Message-Id: <1336049283-5859-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move clearing of I_SYNC into inode_sync_complete().  It is more logical to have
clearing of I_SYNC bit and waking of waiters in one place. Also later we will
have two places needing to clear I_SYNC and wake up waiters so this allows them
to use the common helper. Moving of I_SYNC clearing to a later stage of
writeback_single_inode() is safe since we hold i_lock all the time.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 539f36c..dd41437 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -231,11 +231,8 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
 
 static void inode_sync_complete(struct inode *inode)
 {
-	/*
-	 * Prevent speculative execution through
-	 * spin_unlock(&wb->list_lock);
-	 */
-
+	inode->i_state &= ~I_SYNC;
+	/* Waiters must see I_SYNC cleared before being woken up */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
 }
@@ -436,7 +433,6 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 
 	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
-	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		/*
 		 * Sync livelock prevention. Each inode is tagged and synced in
-- 
1.7.1

