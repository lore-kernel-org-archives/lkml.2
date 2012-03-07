Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2CGV0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:26:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37696 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2CGVXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:18 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 13/25] cifs: implement i_op->atomic_open() and i_op->atomic_create()
Date: Wed,  7 Mar 2012 22:22:30 +0100
Message-Id: <1331155362-11132-14-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Replace CIFS's ->create operation with ->atomic_open and ->atomic_create.  Also
move the relevant code from ->lookup into the create function.

CIFS currently only does atomic open for O_CREAT, but it wants to do that as
early as possible, without first calling ->lookup, so it uses ->atomic_open,
just like NFS.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/cifs/cifsfs.c |   24 +++++++-
 fs/cifs/cifsfs.h |    5 +-
 fs/cifs/dir.c    |  172 +++++++++++++++++++++++-------------------------------
 3 files changed, 98 insertions(+), 103 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b1fd382..694bc3d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -763,15 +763,35 @@ static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
 		return -EAGAIN;
 }
 
+static struct file *cifs_create(struct inode *dir, struct dentry *dentry,
+				struct opendata *od, unsigned flags,
+				umode_t mode)
+{
+	bool created = true;
+	return cifs_atomic_open(dir, dentry, od, flags, mode, &created);
+}
+
 struct file_system_type cifs_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "cifs",
 	.mount = cifs_do_mount,
 	.kill_sb = cifs_kill_sb,
-	/*  .fs_flags */
+
+	/* Posix open is only called (at lookup time) for file create now.  For
+	 * opens (rather than creates), because we do not know if it is a file
+	 * or directory yet, and current Samba no longer allows us to do posix
+	 * open on dirs, we could end up wasting an open call on what turns out
+	 * to be a dir. For file opens, we wait to call posix open till
+	 * cifs_open.  It could be added to atomic_open in the future but the
+	 * performance tradeoff of the extra network request when EISDIR or
+	 * EACCES is returned would have to be weighed against the 50% reduction
+	 * in network traffic in the other paths.
+	 */
+	.fs_flags = FS_NO_LOOKUP_OPEN,
 };
 const struct inode_operations cifs_dir_inode_ops = {
-	.create = cifs_create,
+	.atomic_open = cifs_atomic_open,
+	.atomic_create = cifs_create,
 	.lookup = cifs_lookup,
 	.getattr = cifs_getattr,
 	.unlink = cifs_unlink,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index fe5ecf1..16aa162 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -44,8 +44,9 @@ extern const struct address_space_operations cifs_addr_ops_smallbuf;
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
 extern struct inode *cifs_root_iget(struct super_block *);
-extern int cifs_create(struct inode *, struct dentry *, umode_t,
-		       struct nameidata *);
+extern struct file *cifs_atomic_open(struct inode *, struct dentry *,
+				     struct opendata *, unsigned, umode_t,
+				     bool *);
 extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
 				  struct nameidata *);
 extern int cifs_unlink(struct inode *dir, struct dentry *dentry);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 63a196b..507cc67 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -133,17 +133,39 @@ cifs_bp_rename_retry:
 	return full_path;
 }
 
+/*
+ * Don't allow the separator character in a path component.
+ * The VFS will not allow "/", but "\" is allowed by posix.
+ */
+static int
+check_name(struct dentry *direntry)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	int i;
+
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
+		for (i = 0; i < direntry->d_name.len; i++) {
+			if (direntry->d_name.name[i] == '\\') {
+				cFYI(1, "Invalid file name");
+				return -EINVAL;
+			}
+		}
+	}
+	return 0;
+}
+
+
 /* Inode operations in similar order to how they appear in Linux file fs.h */
 
-int
-cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
-		struct nameidata *nd)
+struct file *
+cifs_atomic_open(struct inode *inode, struct dentry *direntry,
+		 struct opendata *od, unsigned oflags, umode_t mode,
+		 bool *created)
 {
 	int rc = -ENOENT;
 	int xid;
 	int create_options = CREATE_NOT_DIR;
 	__u32 oplock = 0;
-	int oflags;
 	/*
 	 * BB below access is probably too much for mknod to request
 	 *    but we have to do query and setpathinfo so requesting
@@ -160,23 +182,30 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	FILE_ALL_INFO *buf = NULL;
 	struct inode *newinode = NULL;
 	int disposition = FILE_OVERWRITE_IF;
+	struct file *filp;
+
+	rc = check_name(direntry);
+	if (rc)
+		return ERR_PTR(rc);
 
 	xid = GetXid();
 
+	cFYI(1, "parent inode = 0x%p name is: %s and dentry = 0x%p",
+	     inode, direntry->d_name.name, direntry);
+
 	cifs_sb = CIFS_SB(inode->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink)) {
 		FreeXid(xid);
-		return PTR_ERR(tlink);
+		return ERR_CAST(tlink);
 	}
 	tcon = tlink_tcon(tlink);
 
 	if (enable_oplocks)
 		oplock = REQ_OPLOCK;
 
-	if (nd)
-		oflags = nd->intent.open.file->f_flags;
-	else
+	/* Why not O_CREAT|O_EXCL? */
+	if (!od)
 		oflags = O_RDONLY | O_CREAT;
 
 	full_path = build_path_from_dentry(direntry);
@@ -186,6 +215,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	}
 
 	if (tcon->unix_ext && (tcon->ses->capabilities & CAP_UNIX) &&
+	    !tcon->broken_posix_open &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		rc = cifs_posix_open(full_path, &newinode,
@@ -207,9 +237,19 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 		   case where server does not support this SMB level, and
 		   falsely claims capability (also get here for DFS case
 		   which should be rare for path not covered on files) */
+
+		/*
+		 * The check below works around a bug in POSIX
+		 * open in samba versions 3.3.1 and earlier where
+		 * open could incorrectly fail with invalid parameter.
+		 * If either that or op not supported returned, follow
+		 * the normal lookup.
+		 */
+		if ((rc == -EINVAL) || (rc != -EOPNOTSUPP))
+			tcon->broken_posix_open = true;
 	}
 
-	if (nd) {
+	if (od) {
 		/* if the file is going to stay open, then we
 		   need to set the desired access properly */
 		desiredAccess = 0;
@@ -278,6 +318,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 				.device	= 0,
 		};
 
+		*created = true;
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 			args.uid = (__u64) current_fsuid();
 			if (inode->i_mode & S_ISGID)
@@ -321,16 +362,17 @@ cifs_create_get_file_info:
 	}
 
 cifs_create_set_dentry:
-	if (rc == 0)
-		d_instantiate(direntry, newinode);
-	else
+	if (rc != 0) {
 		cFYI(1, "Create worked, get_inode_info failed rc = %d", rc);
+		goto cifs_create_out;
+	}
+	d_drop(direntry);
+	d_add(direntry, newinode);
 
-	if (newinode && nd) {
+	if (newinode && od) {
 		struct cifsFileInfo *pfile_info;
-		struct file *filp;
 
-		filp = lookup_instantiate_filp(nd, direntry, generic_file_open);
+		filp = finish_open(od, direntry, generic_file_open);
 		if (IS_ERR(filp)) {
 			rc = PTR_ERR(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -339,20 +381,25 @@ cifs_create_set_dentry:
 
 		pfile_info = cifs_new_fileinfo(fileHandle, filp, tlink, oplock);
 		if (pfile_info == NULL) {
-			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
+			fput(filp);
 			rc = -ENOMEM;
+			goto cifs_create_out;
 		}
 	} else {
 		CIFSSMBClose(xid, tcon, fileHandle);
+		filp = NULL;
 	}
-
-cifs_create_out:
+out:
 	kfree(buf);
 	kfree(full_path);
 	cifs_put_tlink(tlink);
 	FreeXid(xid);
-	return rc;
+	return filp;
+
+cifs_create_out:
+	filp = ERR_PTR(rc);
+	goto out;
 }
 
 int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
@@ -492,16 +539,11 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 {
 	int xid;
 	int rc = 0; /* to get around spurious gcc warning, set to zero here */
-	__u32 oplock = enable_oplocks ? REQ_OPLOCK : 0;
-	__u16 fileHandle = 0;
-	bool posix_open = false;
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
-	struct cifsFileInfo *cfile;
 	struct inode *newInode = NULL;
 	char *full_path = NULL;
-	struct file *filp;
 
 	xid = GetXid();
 
@@ -518,29 +560,9 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	}
 	pTcon = tlink_tcon(tlink);
 
-	/*
-	 * Don't allow the separator character in a path component.
-	 * The VFS will not allow "/", but "\" is allowed by posix.
-	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
-		int i;
-		for (i = 0; i < direntry->d_name.len; i++)
-			if (direntry->d_name.name[i] == '\\') {
-				cFYI(1, "Invalid file name");
-				rc = -EINVAL;
-				goto lookup_out;
-			}
-	}
-
-	/*
-	 * O_EXCL: optimize away the lookup, but don't hash the dentry. Let
-	 * the VFS handle the create.
-	 */
-	if (nd && (nd->flags & LOOKUP_EXCL)) {
-		d_instantiate(direntry, NULL);
-		rc = 0;
+	rc = check_name(direntry);
+	if (rc)
 		goto lookup_out;
-	}
 
 	/* can not grab the rename sem here since it would
 	deadlock in the cases (beginning of sys_rename itself)
@@ -558,64 +580,16 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	}
 	cFYI(1, "Full path: %s inode = 0x%p", full_path, direntry->d_inode);
 
-	/* Posix open is only called (at lookup time) for file create now.
-	 * For opens (rather than creates), because we do not know if it
-	 * is a file or directory yet, and current Samba no longer allows
-	 * us to do posix open on dirs, we could end up wasting an open call
-	 * on what turns out to be a dir. For file opens, we wait to call posix
-	 * open till cifs_open.  It could be added here (lookup) in the future
-	 * but the performance tradeoff of the extra network request when EISDIR
-	 * or EACCES is returned would have to be weighed against the 50%
-	 * reduction in network traffic in the other paths.
-	 */
 	if (pTcon->unix_ext) {
-		if (nd && !(nd->flags & LOOKUP_DIRECTORY) &&
-		     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_open &&
-		     (nd->intent.open.file->f_flags & O_CREAT)) {
-			rc = cifs_posix_open(full_path, &newInode,
-					parent_dir_inode->i_sb,
-					nd->intent.open.create_mode,
-					nd->intent.open.file->f_flags, &oplock,
-					&fileHandle, xid);
-			/*
-			 * The check below works around a bug in POSIX
-			 * open in samba versions 3.3.1 and earlier where
-			 * open could incorrectly fail with invalid parameter.
-			 * If either that or op not supported returned, follow
-			 * the normal lookup.
-			 */
-			if ((rc == 0) || (rc == -ENOENT))
-				posix_open = true;
-			else if ((rc == -EINVAL) || (rc != -EOPNOTSUPP))
-				pTcon->broken_posix_open = true;
-		}
-		if (!posix_open)
-			rc = cifs_get_inode_info_unix(&newInode, full_path,
-						parent_dir_inode->i_sb, xid);
-	} else
+		rc = cifs_get_inode_info_unix(&newInode, full_path,
+					      parent_dir_inode->i_sb, xid);
+	} else {
 		rc = cifs_get_inode_info(&newInode, full_path, NULL,
-				parent_dir_inode->i_sb, xid, NULL);
+					 parent_dir_inode->i_sb, xid, NULL);
+	}
 
 	if ((rc == 0) && (newInode != NULL)) {
 		d_add(direntry, newInode);
-		if (posix_open) {
-			filp = lookup_instantiate_filp(nd, direntry,
-						       generic_file_open);
-			if (IS_ERR(filp)) {
-				rc = PTR_ERR(filp);
-				CIFSSMBClose(xid, pTcon, fileHandle);
-				goto lookup_out;
-			}
-
-			cfile = cifs_new_fileinfo(fileHandle, filp, tlink,
-						  oplock);
-			if (cfile == NULL) {
-				fput(filp);
-				CIFSSMBClose(xid, pTcon, fileHandle);
-				rc = -ENOMEM;
-				goto lookup_out;
-			}
-		}
 		/* since paths are not looked up by component - the parent
 		   directories are presumed to be good here */
 		renew_parental_timestamps(direntry);
-- 
1.7.7

