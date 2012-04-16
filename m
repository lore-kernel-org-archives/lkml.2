Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2DPQRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:17:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab2DPQOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:25 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 21/27] fuse: Convert to new freezing mechanism
Date: Mon, 16 Apr 2012 18:13:59 +0200
Message-Id: <1334592845-22862-22-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert check in fuse_file_aio_write() to using new freeze protection.

CC: fuse-devel@lists.sourceforge.net
CC: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fuse/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a841868..48b5147 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -943,8 +943,8 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (err)
 		return err;
 
+	sb_start_write(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
@@ -970,6 +970,7 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 out:
 	current->backing_dev_info = NULL;
 	mutex_unlock(&inode->i_mutex);
+	sb_end_write(inode->i_sb);
 
 	return written ? written : err;
 }
-- 
1.7.1

