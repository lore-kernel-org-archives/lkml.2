Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab0KSWEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:04:15 -0500
Received: from kroah.org ([198.145.64.141]:52854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab0KSWEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:08 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:23 2010
Message-Id: <20101119220123.245226305@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steve French <sfrench@us.ibm.com>
Subject: [13/66] cifs: fix broken oplock handling
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Jayaraman <sjayaraman@suse.de>

commit aa91c7e4ab9b0842b7d7a7cbf8cca18b20df89b5 upstream.

cifs_new_fileinfo() does not use the 'oplock' value from the callers. Instead,
it sets it to REQ_OPLOCK which seems wrong. We should be using the oplock value
obtained from the Server to set the inode's clientCanCacheAll or
clientCanCacheRead flags. Fix this by passing oplock from the callers to
cifs_new_fileinfo().

This change dates back to commit a6ce4932 (2.6.30-rc3). So, all the affected
versions will need this fix. Please Cc stable once reviewed and accepted.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsproto.h |    3 ++-
 fs/cifs/dir.c       |   12 +++++-------
 fs/cifs/file.c      |    4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -107,7 +107,8 @@ extern struct timespec cnvrtDosUnixTm(__
 
 extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
 				__u16 fileHandle, struct file *file,
-				struct vfsmount *mnt, unsigned int oflags);
+				struct vfsmount *mnt, unsigned int oflags,
+				__u32 oplock);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
 				int mode, int oflags,
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -132,9 +132,9 @@ cifs_bp_rename_retry:
 
 struct cifsFileInfo *
 cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
-		  struct file *file, struct vfsmount *mnt, unsigned int oflags)
+		  struct file *file, struct vfsmount *mnt, unsigned int oflags,
+		  __u32 oplock)
 {
-	int oplock = 0;
 	struct cifsFileInfo *pCifsFile;
 	struct cifsInodeInfo *pCifsInode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(mnt->mnt_sb);
@@ -143,9 +143,6 @@ cifs_new_fileinfo(struct inode *newinode
 	if (pCifsFile == NULL)
 		return pCifsFile;
 
-	if (oplockEnabled)
-		oplock = REQ_OPLOCK;
-
 	pCifsFile->netfid = fileHandle;
 	pCifsFile->pid = current->tgid;
 	pCifsFile->pInode = igrab(newinode);
@@ -468,7 +465,7 @@ cifs_create_set_dentry:
 		}
 
 		pfile_info = cifs_new_fileinfo(newinode, fileHandle, filp,
-					       nd->path.mnt, oflags);
+					       nd->path.mnt, oflags, oplock);
 		if (pfile_info == NULL) {
 			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -729,7 +726,8 @@ cifs_lookup(struct inode *parent_dir_ino
 
 			cfile = cifs_new_fileinfo(newInode, fileHandle, filp,
 						  nd->path.mnt,
-						  nd->intent.open.flags);
+						  nd->intent.open.flags,
+						  oplock);
 			if (cfile == NULL) {
 				fput(filp);
 				CIFSSMBClose(xid, pTcon, fileHandle);
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -277,7 +277,7 @@ int cifs_open(struct inode *inode, struc
 
 			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
 							file->f_path.mnt,
-							oflags);
+							oflags, oplock);
 			if (pCifsFile == NULL) {
 				CIFSSMBClose(xid, tcon, netfid);
 				rc = -ENOMEM;
@@ -370,7 +370,7 @@ int cifs_open(struct inode *inode, struc
 		goto out;
 
 	pCifsFile = cifs_new_fileinfo(inode, netfid, file, file->f_path.mnt,
-					file->f_flags);
+					file->f_flags, oplock);
 	if (pCifsFile == NULL) {
 		rc = -ENOMEM;
 		goto out;


