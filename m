Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab1GVP4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:56:16 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:49321 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1GVP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:56:15 -0400
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH vfs-next 2/2] ovl: Adapt ovl_dir_fsync() to updated API in ->fsync()
Date: Fri, 22 Jul 2011 17:56:00 +0200
Message-Id: <1311350160-3651-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on a proposal patch from Miklos Szeredi <miklos@szeredi.hu>.

Adapt ovl_dir_fsync() to recent changes in vfs-2.6.git#for-next.

Documentation/filesystems/porting says:

[mandatory]
       If you have your own ->fsync() you must make sure to call
filemap_write_and_wait_range() so that all dirty pages are synced out properly.
You must also keep in mind that ->fsync() is not called with i_mutex held
anymore, so if you require i_mutex locking you must make sure to take it and
release it yourself.

For more details see:

commit cbc4facd43b3502f644d7f01a9a48f8bec5f3e57
"fs: push i_mutex and filemap_write_and_wait down into ->fsync() handlers"

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 fs/overlayfs/readdir.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 48e35a8..6fcda39 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -386,7 +386,8 @@ out_unlock:
 	return res;
 }
 
-static int ovl_dir_fsync(struct file *file, int datasync)
+static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
+			 int datasync)
 {
 	struct ovl_dir_file *od = file->private_data;
 
@@ -400,7 +401,7 @@ static int ovl_dir_fsync(struct file *file, int datasync)
 			return PTR_ERR(od->realfile);
 	}
 
-	return vfs_fsync(od->realfile, datasync);
+	return vfs_fsync_range(od->realfile, start, end, datasync);
 }
 
 static int ovl_dir_release(struct inode *inode, struct file *file)
-- 
1.7.6

