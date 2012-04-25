Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab2DYU6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:58:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759159Ab2DYU6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:58:00 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/6] ext4: Remove i_mutex use from ext4_quota_write()
Date: Wed, 25 Apr 2012 22:57:43 +0200
Message-Id: <1335387467-4928-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1335387467-4928-1-git-send-email-jack@suse.cz>
References: <1335387467-4928-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need i_mutex in ext4_quota_write() because writes to quota file
are serialized by dqio_mutex anyway. Changes to quota files outside of quota
code are forbidded and enforced by NOATIME and IMMUTABLE bits.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6da1935..14965ca 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4742,7 +4742,6 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 		return -EIO;
 	}
 
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	bh = ext4_bread(handle, inode, blk, 1, &err);
 	if (!bh)
 		goto out;
@@ -4758,16 +4757,13 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	err = ext4_handle_dirty_metadata(handle, NULL, bh);
 	brelse(bh);
 out:
-	if (err) {
-		mutex_unlock(&inode->i_mutex);
+	if (err)
 		return err;
-	}
 	if (inode->i_size < off + len) {
 		i_size_write(inode, off + len);
 		EXT4_I(inode)->i_disksize = inode->i_size;
 		ext4_mark_inode_dirty(handle, inode);
 	}
-	mutex_unlock(&inode->i_mutex);
 	return len;
 }
 
-- 
1.7.1

