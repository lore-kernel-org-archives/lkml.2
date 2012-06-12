Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2FLOXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:23:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab2FLOVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:21:01 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz,
        Jan Kara <jack@suse.cz>, fuse-devel@lists.sourceforge.net,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 21/27] fuse: Convert to new freezing mechanism
Date: Tue, 12 Jun 2012 16:20:42 +0200
Message-Id: <1339510848-16992-22-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert check in fuse_file_aio_write() to using new freeze protection.

CC: fuse-devel@lists.sourceforge.net
CC: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fuse/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b321a68..93d8d6c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -944,9 +944,8 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		return err;
 
 	count = ocount;
-
+	sb_start_write(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
@@ -1004,6 +1003,7 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 out:
 	current->backing_dev_info = NULL;
 	mutex_unlock(&inode->i_mutex);
+	sb_end_write(inode->i_sb);
 
 	return written ? written : err;
 }
-- 
1.7.1

