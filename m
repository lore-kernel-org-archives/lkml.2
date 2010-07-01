Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab0GAVDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:03:53 -0400
Received: from kroah.org ([198.145.64.141]:47869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab0GAUvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:15 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:38 2010
Message-Id: <20100701173437.945097797@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shirish Pargaonkar <shirishp@us.ibm.com>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 132/164] CIFS: Allow null nd (as nfs server uses) on create
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <sfrench@us.ibm.com>

commit fa588e0c57048b3d4bfcd772d80dc0615f83fd35 upstream.

While creating a file on a server which supports unix extensions
such as Samba, if a file is being created which does not supply
nameidata (i.e. nd is null), cifs client can oops when calling
cifs_posix_open.

Signed-off-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsproto.h |    6 ++++--
 fs/cifs/dir.c       |   20 ++++++++++++--------
 fs/cifs/file.c      |   11 +++++++----
 3 files changed, 23 insertions(+), 14 deletions(-)

--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -95,8 +95,10 @@ extern struct cifsFileInfo *cifs_new_fil
 				__u16 fileHandle, struct file *file,
 				struct vfsmount *mnt, unsigned int oflags);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
-			   struct vfsmount *mnt, int mode, int oflags,
-			   __u32 *poplock, __u16 *pnetfid, int xid);
+				struct vfsmount *mnt,
+				struct super_block *sb,
+				int mode, int oflags,
+				__u32 *poplock, __u16 *pnetfid, int xid);
 extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
 				     FILE_UNIX_BASIC_INFO *info,
 				     struct cifs_sb_info *cifs_sb);
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -183,13 +183,14 @@ cifs_new_fileinfo(struct inode *newinode
 }
 
 int cifs_posix_open(char *full_path, struct inode **pinode,
-		    struct vfsmount *mnt, int mode, int oflags,
-		    __u32 *poplock, __u16 *pnetfid, int xid)
+			struct vfsmount *mnt, struct super_block *sb,
+			int mode, int oflags,
+			__u32 *poplock, __u16 *pnetfid, int xid)
 {
 	int rc;
 	FILE_UNIX_BASIC_INFO *presp_data;
 	__u32 posix_flags = 0;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(mnt->mnt_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_fattr fattr;
 
 	cFYI(1, ("posix open %s", full_path));
@@ -242,7 +243,7 @@ int cifs_posix_open(char *full_path, str
 
 	/* get new inode and set it up */
 	if (*pinode == NULL) {
-		*pinode = cifs_iget(mnt->mnt_sb, &fattr);
+		*pinode = cifs_iget(sb, &fattr);
 		if (!*pinode) {
 			rc = -ENOMEM;
 			goto posix_open_ret;
@@ -251,7 +252,8 @@ int cifs_posix_open(char *full_path, str
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
-	cifs_new_fileinfo(*pinode, *pnetfid, NULL, mnt, oflags);
+	if (mnt)
+		cifs_new_fileinfo(*pinode, *pnetfid, NULL, mnt, oflags);
 
 posix_open_ret:
 	kfree(presp_data);
@@ -315,13 +317,14 @@ cifs_create(struct inode *inode, struct
 	if (nd && (nd->flags & LOOKUP_OPEN))
 		oflags = nd->intent.open.flags;
 	else
-		oflags = FMODE_READ;
+		oflags = FMODE_READ | SMB_O_CREAT;
 
 	if (tcon->unix_ext && (tcon->ses->capabilities & CAP_UNIX) &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
-		rc = cifs_posix_open(full_path, &newinode, nd->path.mnt,
-				     mode, oflags, &oplock, &fileHandle, xid);
+		rc = cifs_posix_open(full_path, &newinode,
+			nd ? nd->path.mnt : NULL,
+			inode->i_sb, mode, oflags, &oplock, &fileHandle, xid);
 		/* EIO could indicate that (posix open) operation is not
 		   supported, despite what server claimed in capability
 		   negotation.  EREMOTE indicates DFS junction, which is not
@@ -678,6 +681,7 @@ cifs_lookup(struct inode *parent_dir_ino
 		     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_open &&
 		     (nd->intent.open.flags & O_CREAT)) {
 			rc = cifs_posix_open(full_path, &newInode, nd->path.mnt,
+					parent_dir_inode->i_sb,
 					nd->intent.open.create_mode,
 					nd->intent.open.flags, &oplock,
 					&fileHandle, xid);
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -297,10 +297,12 @@ int cifs_open(struct inode *inode, struc
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		int oflags = (int) cifs_posix_convert_flags(file->f_flags);
+		oflags |= SMB_O_CREAT;
 		/* can not refresh inode info since size could be stale */
 		rc = cifs_posix_open(full_path, &inode, file->f_path.mnt,
-				     cifs_sb->mnt_file_mode /* ignored */,
-				     oflags, &oplock, &netfid, xid);
+				inode->i_sb,
+				cifs_sb->mnt_file_mode /* ignored */,
+				oflags, &oplock, &netfid, xid);
 		if (rc == 0) {
 			cFYI(1, ("posix open succeeded"));
 			/* no need for special case handling of setting mode
@@ -512,8 +514,9 @@ reopen_error_exit:
 		int oflags = (int) cifs_posix_convert_flags(file->f_flags);
 		/* can not refresh inode info since size could be stale */
 		rc = cifs_posix_open(full_path, NULL, file->f_path.mnt,
-				     cifs_sb->mnt_file_mode /* ignored */,
-				     oflags, &oplock, &netfid, xid);
+				inode->i_sb,
+				cifs_sb->mnt_file_mode /* ignored */,
+				oflags, &oplock, &netfid, xid);
 		if (rc == 0) {
 			cFYI(1, ("posix reopen succeeded"));
 			goto reopen_success;


