Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0IFAvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:51:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:50968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab0IFAvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:51:42 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:29 +1000
Subject: [PATCH 05/10] ovl: make sure fsync is never called on the lower
	filesystem.
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906005029.20775.56925.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we open a directory O_RDONLY, ->realfile could be on the lower
filesystem.
While fsync is not likely to be called on such a file, we should make
sure never to pass the fsync down as we are treating the lower
filesystem as read-only.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/overlayfs/overlayfs.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index de854e1..f9eea96 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -329,8 +329,15 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
 static int ovl_dir_fsync(struct file *file, int datasync)
 {
 	struct ovl_dir_file *od = file->private_data;
+	struct ovl_entry *ue = file->f_path.dentry->d_fsdata;
 
-	return vfs_fsync(od->realfile, datasync);
+	/* realfile could be on lowerdir, but only if this was a read-only open,
+	 * in which case we can ignore the fsync.
+	 */
+	if (file->f_path.dentry == ue->upperpath.dentry)
+		return vfs_fsync(od->realfile, datasync);
+	else
+		return 0;
 }
 
 static int ovl_dir_release(struct inode *inode, struct file *file)


