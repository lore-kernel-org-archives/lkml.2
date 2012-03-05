Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2CEQDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:03:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab2CEQBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:01:39 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Jan Kara <jack@suse.cz>, linux-ntfs-dev@lists.sourceforge.net,
        Anton Altaparmakov <anton@tuxera.com>
Subject: [PATCH 15/19] ntfs: Convert to new freezing mechanism
Date: Mon,  5 Mar 2012 17:01:13 +0100
Message-Id: <1330963277-26336-16-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330963277-26336-1-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
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
index c587e2d..0503e65 100644
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
@@ -2117,6 +2116,7 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	BUG_ON(iocb->ki_pos != pos);
 
+	sb_start_write(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
 	ret = ntfs_file_aio_write_nolock(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
@@ -2125,6 +2125,7 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		if (err < 0)
 			ret = err;
 	}
+	sb_end_write(inode->i_sb);
 	return ret;
 }
 
-- 
1.7.1

