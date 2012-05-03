Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2ECMuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:50:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab2ECMsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:36 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 7/9] vfs: Move waiting for inode writeback from end_writeback() to evict_inode()
Date: Thu,  3 May 2012 14:48:01 +0200
Message-Id: <1336049283-5859-8-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, I_SYNC can never be set when evict_inode() (and thus
end_writeback()) is called because flusher thread holds inode reference while
inode is under writeback. As a result inode_sync_wait() in those places
currently does nothing. However that is going to change and unveils problems
with calling inode_sync_wait() from end_writeback(). Several filesystems call
end_writeback() after they have deleted the inode (btrfs, gfs2, ...) and other
filesystems (ext3, ext4, reiserfs, ...) can deadlock when waiting for I_SYNC
because they call end_writeback() from within a transaction.

To avoid these issues, we move inode_sync_wait() into evict_inode() before
calling ->evict_inode(). That way we preserve the current property that
->evict_inode() and writeback never run in parallel and all filesystems are
safe.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9f4f5fe..501fc5d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -500,7 +500,6 @@ void end_writeback(struct inode *inode)
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
-	inode_sync_wait(inode);
 	/* don't need i_lock here, no concurrent mods to i_state */
 	inode->i_state = I_FREEING | I_CLEAR;
 }
@@ -531,6 +530,8 @@ static void evict(struct inode *inode)
 
 	inode_sb_list_del(inode);
 
+	inode_sync_wait(inode);
+
 	if (op->evict_inode) {
 		op->evict_inode(inode);
 	} else {
-- 
1.7.1

