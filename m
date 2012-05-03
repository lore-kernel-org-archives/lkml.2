Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2ECMsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:48:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab2ECMse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:34 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/9] writeback: Move I_DIRTY_PAGES handling
Date: Thu,  3 May 2012 14:47:57 +0200
Message-Id: <1336049283-5859-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of clearing I_DIRTY_PAGES and resetting it when we didn't succeed in
writing them all, just clear the bit only when we succeeded writing all the
pages. We also move the clearing of the bit close to other i_state handling to
separate it from writeback list handling. This is desirable because list
handling will differ for flusher thread and other writeback_single_inode()
callers in future. No filesystem plays any tricks with I_DIRTY_PAGES (like
checking it in ->writepages or ->write_inode implementation) so this movement
is safe.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 65cd147..3804a10 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -385,7 +385,6 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
-	inode->i_state &= ~I_DIRTY_PAGES;
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
 
@@ -408,6 +407,9 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	 * write_inode()
 	 */
 	spin_lock(&inode->i_lock);
+	/* Clear I_DIRTY_PAGES if we've written out all dirty pages */
+	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
+		inode->i_state &= ~I_DIRTY_PAGES;
 	dirty = inode->i_state & I_DIRTY;
 	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
 	spin_unlock(&inode->i_lock);
@@ -435,7 +437,6 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything.
 			 */
-			inode->i_state |= I_DIRTY_PAGES;
 			if (wbc->nr_to_write <= 0) {
 				/*
 				 * slice used up: queue for next turn
-- 
1.7.1

