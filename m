Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab2DYU57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:57:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757671Ab2DYU54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:57:56 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/6] ext2: Remove i_mutex use from ext2_quota_write()
Date: Wed, 25 Apr 2012 22:57:45 +0200
Message-Id: <1335387467-4928-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1335387467-4928-1-git-send-email-jack@suse.cz>
References: <1335387467-4928-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need i_mutex in ext2_quota_write() because writes to quota file
are serialized by dqio_mutex anyway. Changes to quota files outside of quota
code are forbidded and enforced by NOATIME and IMMUTABLE bits.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index e1025c7..1a6fb52 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1441,7 +1441,6 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 	struct buffer_head tmp_bh;
 	struct buffer_head *bh;
 
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
 				sb->s_blocksize - offset : towrite;
@@ -1471,16 +1470,13 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 		blk++;
 	}
 out:
-	if (len == towrite) {
-		mutex_unlock(&inode->i_mutex);
+	if (len == towrite)
 		return err;
-	}
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
 	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(inode);
-	mutex_unlock(&inode->i_mutex);
 	return len - towrite;
 }
 
-- 
1.7.1

