Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1HEDfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:35:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab1HEDfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:35:06 -0400
Date: Fri, 5 Aug 2011 13:34:56 +1000
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Josef Bacik <josef@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Subject: [PATCH] Restore 'fsync' functionality on block devices.
Message-ID: <20110805133456.5aa0c568@notabene.brown>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 02c24a82187d5a628c68edfe71ae60dc135cd178:

  fs: push i_mutex and filemap_write_and_wait down into ->fsync() handlers

broke fsync on block devices as it did not push the
"filemap_write_and_wait" call down into blkdev_fsync.

(it didn't push it down into ps3flash_flush either, but maybe there is
a reason for that).

So call filemap_write_and_wait from blkdev_fsync following the pattern
that was originally in vfs_fsync_range.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/block_dev.c b/fs/block_dev.c
index f286805..532fefe 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -386,8 +386,10 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t
end, int datasync) {
 	struct inode *bd_inode = filp->f_mapping->host;
 	struct block_device *bdev = I_BDEV(bd_inode);
-	int error;
+	int error, ret;
+
 
+	ret = filemap_write_and_wait_range(filp->f_mapping, start, end);
 	/*
 	 * There is no need to serialise calls to blkdev_issue_flush with
 	 * i_mutex and doing so causes performance issues with concurrent
@@ -396,6 +398,8 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t
end, int datasync) error = blkdev_issue_flush(bdev, GFP_KERNEL, NULL);
 	if (error == -EOPNOTSUPP)
 		error = 0;
+	if (ret)
+		return ret;
 
 	return error;
 }
