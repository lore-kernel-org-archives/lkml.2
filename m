Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab2DYU56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:57:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275Ab2DYU54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:57:56 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/6] ext3: Remove i_mutex use from ext3_quota_write()
Date: Wed, 25 Apr 2012 22:57:42 +0200
Message-Id: <1335387467-4928-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1335387467-4928-1-git-send-email-jack@suse.cz>
References: <1335387467-4928-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need i_mutex in ext3_quota_write() because writes to quota file
are serialized by dqio_mutex anyway. Changes to quota files outside of quota
code are forbidded and enforced by NOATIME and IMMUTABLE bits.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index cf0b592..7c08c93 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -3000,7 +3000,6 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	bh = ext3_bread(handle, inode, blk, 1, &err);
 	if (!bh)
 		goto out;
@@ -3024,10 +3023,8 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 	}
 	brelse(bh);
 out:
-	if (err) {
-		mutex_unlock(&inode->i_mutex);
+	if (err)
 		return err;
-	}
 	if (inode->i_size < off + len) {
 		i_size_write(inode, off + len);
 		EXT3_I(inode)->i_disksize = inode->i_size;
@@ -3035,7 +3032,6 @@ out:
 	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	ext3_mark_inode_dirty(handle, inode);
-	mutex_unlock(&inode->i_mutex);
 	return len;
 }
 
-- 
1.7.1

