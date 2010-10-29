Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab0J2Xlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 19:41:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34874 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0J2Xlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 19:41:49 -0400
From: Ken Sumrall <ksumrall@android.com>
To: linux-kernel@vger.kernel.org
Cc: Ken Sumrall <ksumrall@android.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>, Anfei <anfei.zhou@gmail.com>,
        "Anand V. Avati" <avati@gluster.com>, fuse-devel@lists.sourceforge.net
Subject: [PATCH] Fix bug in FUSE where the attribute cache for a file was not cleared when a file is opened with O_TRUNC.
Date: Fri, 29 Oct 2010 16:41:40 -0700
Message-Id: <1288395700-9527-1-git-send-email-ksumrall@android.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ken Sumrall <ksumrall@android.com>
---
 fs/fuse/file.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c822458..4fbe62c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -134,6 +134,7 @@ EXPORT_SYMBOL_GPL(fuse_do_open);
 void fuse_finish_open(struct inode *inode, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	if (ff->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
@@ -141,6 +142,8 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		invalidate_inode_pages2(inode->i_mapping);
 	if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
+	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC))
+		fuse_invalidate_attr(inode);
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
-- 
1.7.3.1

