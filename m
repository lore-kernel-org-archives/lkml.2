Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2FLOXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:23:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab2FLOVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:21:01 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz,
        Jan Kara <jack@suse.cz>, linux-ntfs-dev@lists.sourceforge.net,
        Anton Altaparmakov <anton@tuxera.com>
Subject: [PATCH 22/27] ntfs: Convert to new freezing mechanism
Date: Tue, 12 Jun 2012 16:20:43 +0200
Message-Id: <1339510848-16992-23-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move check in ntfs_file_aio_write_nolock() to ntfs_file_aio_write() and
use new freeze protection.

CC: linux-ntfs-dev@lists.sourceforge.net
CC: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ntfs/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 7389d2d..1ecf464 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2084,7 +2084,6 @@ static ssize_t ntfs_file_aio_write_nolock(struct kiocb *iocb,
 	if (err)
 		return err;
 	pos = *ppos;
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 	/* We can write back this queue in page reclaim. */
 	current->backing_dev_info = mapping->backing_dev_info;
 	written = 0;
@@ -2119,6 +2118,7 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	BUG_ON(iocb->ki_pos != pos);
 
+	sb_start_write(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
 	ret = ntfs_file_aio_write_nolock(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
@@ -2127,6 +2127,7 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		if (err < 0)
 			ret = err;
 	}
+	sb_end_write(inode->i_sb);
 	return ret;
 }
 
-- 
1.7.1

