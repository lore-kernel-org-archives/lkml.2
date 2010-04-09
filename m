Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0DIOCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:02:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:45374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0DIOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:31 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 11/12] Do not fallback to default_llseek() when readdir() uses BKL
Date: Fri,  9 Apr 2010 16:00:54 +0200
Message-Id: <1270821655-4368-12-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not use the fallback default_llseek() if the readdir operation of the
filesystem still uses the big kernel lock. Since llseek() modifies
file->f_pos of the directory directly it may need locking to not confuse
readdir which usually uses file->f_pos directly as well. Since the special
characteristics of the BKL (unlocked on schedule) are not necessary in this
case, the inode mutex can be used for locking as provided by
generic_file_llseek(). This is only possible since all filesystems, except
reiserfs, either use a directory as a flat file or with disk address
offsets. Reiserfs on the other hand uses a 32bit hash off the filename as
the offset so generic_file_llseek() can get used as well since the hash is
always smaller than sb->s_maxbytes (= (512 << 32) - blocksize).

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Anders Larsen <al@alarsen.net>
---
 fs/autofs/root.c          |    1 +
 fs/freevxfs/vxfs_lookup.c |    2 ++
 fs/isofs/dir.c            |    1 +
 fs/ncpfs/dir.c            |    1 +
 fs/qnx4/dir.c             |    1 +
 fs/reiserfs/dir.c         |    1 +
 fs/smbfs/dir.c            |    1 +
 fs/udf/dir.c              |    1 +
 8 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 4a1401c..d3aec77 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -30,6 +30,7 @@ const struct file_operations autofs_root_operations = {
 	.read		= generic_read_dir,
 	.readdir	= autofs_root_readdir,
 	.ioctl		= autofs_root_ioctl,
+	.llseek		= generic_file_llseek,
 };
 
 const struct inode_operations autofs_root_inode_operations = {
diff --git a/fs/freevxfs/vxfs_lookup.c b/fs/freevxfs/vxfs_lookup.c
index aee049c..0ec7bb2 100644
--- a/fs/freevxfs/vxfs_lookup.c
+++ b/fs/freevxfs/vxfs_lookup.c
@@ -57,6 +57,8 @@ const struct inode_operations vxfs_dir_inode_ops = {
 };
 
 const struct file_operations vxfs_dir_operations = {
+	.llseek =		generic_file_llseek,
+	.read =			generic_read_dir,
 	.readdir =		vxfs_readdir,
 };
 
diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 8ba5441..4816bd3 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -271,6 +271,7 @@ static int isofs_readdir(struct file *filp,
 
 const struct file_operations isofs_dir_operations =
 {
+	.llseek = generic_file_llseek,
 	.read = generic_read_dir,
 	.readdir = isofs_readdir,
 };
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index b8b5b30..c9cad9a 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -50,6 +50,7 @@ extern int ncp_symlink(struct inode *, struct dentry *, const char *);
 		      
 const struct file_operations ncp_dir_operations =
 {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ncp_readdir,
 	.ioctl		= ncp_ioctl,
diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index 6f30c3d..3d3fd46 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -77,6 +77,7 @@ out:
 
 const struct file_operations qnx4_dir_operations =
 {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= qnx4_readdir,
 	.fsync		= simple_fsync,
diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index c094f58..e1345fa 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -17,6 +17,7 @@ static int reiserfs_dir_fsync(struct file *filp, struct dentry *dentry,
 			      int datasync);
 
 const struct file_operations reiserfs_dir_operations = {
+	.llseek = generic_file_llseek,
 	.read = generic_read_dir,
 	.readdir = reiserfs_readdir,
 	.fsync = reiserfs_dir_fsync,
diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 3e4803b..cd11c54 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -37,6 +37,7 @@ static int smb_link(struct dentry *, struct inode *, struct dentry *);
 
 const struct file_operations smb_dir_operations =
 {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= smb_readdir,
 	.ioctl		= smb_ioctl,
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index f0f2a43..e9f4ae0 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -207,6 +207,7 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
 
 /* readdir and lookup functions */
 const struct file_operations udf_dir_operations = {
+	.llseek			= generic_file_llseek,
 	.read			= generic_read_dir,
 	.readdir		= udf_readdir,
 	.ioctl			= udf_ioctl,
-- 
1.6.4.2

