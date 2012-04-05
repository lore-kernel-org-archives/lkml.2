Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2DEPIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:08:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62866 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2DEO70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:26 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 28/34] cifs: implement i_op->atomic_open() and i_op->atomic_create()
Date: Thu,  5 Apr 2012 16:58:54 +0200
Message-Id: <1333637940-31884-29-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
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
 fs/cifs/cifsfs.c |    1 +
 fs/cifs/cifsfs.h |    3 +
 fs/cifs/dir.c    |  437 ++++++++++++++++++++++++++++++------------------------
 3 files changed, 245 insertions(+), 196 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d342128..74c2bf2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -764,6 +764,7 @@ struct file_system_type cifs_fs_type = {
 };
 const struct inode_operations cifs_dir_inode_ops = {
 	.create = cifs_create,
+	.atomic_open = cifs_atomic_open,
 	.lookup = cifs_lookup,
 	.getattr = cifs_getattr,
 	.unlink = cifs_unlink,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index d1389bb..c960c20 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -46,6 +46,9 @@ extern const struct inode_operations cifs_dir_inode_ops;
 extern struct inode *cifs_root_iget(struct super_block *);
 extern int cifs_create(struct inode *, struct dentry *, umode_t,
 		       struct nameidata *);
+extern struct file *cifs_atomic_open(struct inode *, struct dentry *,
+				     struct opendata *, unsigned, umode_t,
+				     bool *);
 extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
 				  struct nameidata *);
 extern int cifs_unlink(struct inode *dir, struct dentry *dentry);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index d172c8e..9682413 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -133,108 +133,141 @@ cifs_bp_rename_retry:
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
+static int cifs_do_create(struct inode *inode, struct dentry *direntry,
+			  int xid, struct tcon_link *tlink, unsigned oflags,
+			  umode_t mode, __u32 *oplock, __u16 *fileHandle,
+			  bool *created)
 {
 	int rc = -ENOENT;
-	int xid;
 	int create_options = CREATE_NOT_DIR;
-	__u32 oplock = 0;
-	int oflags;
-	/*
-	 * BB below access is probably too much for mknod to request
-	 *    but we have to do query and setpathinfo so requesting
-	 *    less could fail (unless we want to request getatr and setatr
-	 *    permissions (only).  At least for POSIX we do not have to
-	 *    request so much.
-	 */
-	int desiredAccess = GENERIC_READ | GENERIC_WRITE;
-	__u16 fileHandle;
-	struct cifs_sb_info *cifs_sb;
-	struct tcon_link *tlink;
-	struct cifs_tcon *tcon;
+	int desiredAccess;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_tcon *tcon = tlink_tcon(tlink);
 	char *full_path = NULL;
 	FILE_ALL_INFO *buf = NULL;
 	struct inode *newinode = NULL;
-	int disposition = FILE_OVERWRITE_IF;
-
-	xid = GetXid();
-
-	cifs_sb = CIFS_SB(inode->i_sb);
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink)) {
-		FreeXid(xid);
-		return PTR_ERR(tlink);
-	}
-	tcon = tlink_tcon(tlink);
+	int disposition;
 
+	*oplock = 0;
 	if (tcon->ses->server->oplocks)
-		oplock = REQ_OPLOCK;
-
-	if (nd)
-		oflags = nd->intent.open.file->f_flags;
-	else
-		oflags = O_RDONLY | O_CREAT;
+		*oplock = REQ_OPLOCK;
 
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		goto cifs_create_out;
+		goto out;
 	}
 
 	if (tcon->unix_ext && (tcon->ses->capabilities & CAP_UNIX) &&
+	    !tcon->broken_posix_open &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		rc = cifs_posix_open(full_path, &newinode,
-			inode->i_sb, mode, oflags, &oplock, &fileHandle, xid);
-		/* EIO could indicate that (posix open) operation is not
-		   supported, despite what server claimed in capability
-		   negotiation.  EREMOTE indicates DFS junction, which is not
-		   handled in posix open */
+			inode->i_sb, mode, oflags, oplock, fileHandle, xid);
+		switch (rc) {
+		case 0:
+			if (newinode == NULL) {
+				/* query inode info */
+				goto cifs_create_get_file_info;
+			}
 
-		if (rc == 0) {
-			if (newinode == NULL) /* query inode info */
+			if (!S_ISREG(newinode->i_mode)) {
+				/*
+				 * The server may allow us to open things like
+				 * FIFOs, but the client isn't set up to deal
+				 * with that. If it's not a regular file, just
+				 * close it and proceed as if it were a normal
+				 * lookup.
+				 */
+				CIFSSMBClose(xid, tcon, *fileHandle);
 				goto cifs_create_get_file_info;
-			else /* success, no need to query */
-				goto cifs_create_set_dentry;
-		} else if ((rc != -EIO) && (rc != -EREMOTE) &&
-			 (rc != -EOPNOTSUPP) && (rc != -EINVAL))
-			goto cifs_create_out;
-		/* else fallthrough to retry, using older open call, this is
-		   case where server does not support this SMB level, and
-		   falsely claims capability (also get here for DFS case
-		   which should be rare for path not covered on files) */
-	}
+			}
+			/* success, no need to query */
+			goto cifs_create_set_dentry;
+
+		case -ENOENT:
+			goto cifs_create_get_file_info;
+
+		case -EIO:
+		case -EINVAL:
+			/*
+			 * EIO could indicate that (posix open) operation is not
+			 * supported, despite what server claimed in capability
+			 * negotiation.
+			 *
+			 * POSIX open in samba versions 3.3.1 and earlier could
+			 * incorrectly fail with invalid parameter.
+			 */
+			tcon->broken_posix_open = true;
+			break;
 
-	if (nd) {
-		/* if the file is going to stay open, then we
-		   need to set the desired access properly */
-		desiredAccess = 0;
-		if (OPEN_FMODE(oflags) & FMODE_READ)
-			desiredAccess |= GENERIC_READ; /* is this too little? */
-		if (OPEN_FMODE(oflags) & FMODE_WRITE)
-			desiredAccess |= GENERIC_WRITE;
+		case -EREMOTE:
+		case -EOPNOTSUPP:
+			/*
+			 * EREMOTE indicates DFS junction, which is not handled
+			 * in posix open.  If either that or op not supported
+			 * returned, follow the normal lookup.
+			 */
+			break;
 
-		if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
-			disposition = FILE_CREATE;
-		else if ((oflags & (O_CREAT | O_TRUNC)) == (O_CREAT | O_TRUNC))
-			disposition = FILE_OVERWRITE_IF;
-		else if ((oflags & O_CREAT) == O_CREAT)
-			disposition = FILE_OPEN_IF;
-		else
-			cFYI(1, "Create flag not set in create function");
+		default:
+			goto out;
+		}
+		/*
+		 * fallthrough to retry, using older open call, this is case
+		 * where server does not support this SMB level, and falsely
+		 * claims capability (also get here for DFS case which should be
+		 * rare for path not covered on files)
+		 */
 	}
 
+	desiredAccess = 0;
+	if (OPEN_FMODE(oflags) & FMODE_READ)
+		desiredAccess |= GENERIC_READ; /* is this too little? */
+	if (OPEN_FMODE(oflags) & FMODE_WRITE)
+		desiredAccess |= GENERIC_WRITE;
+
+	disposition = FILE_OVERWRITE_IF;
+	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+		disposition = FILE_CREATE;
+	else if ((oflags & (O_CREAT | O_TRUNC)) == (O_CREAT | O_TRUNC))
+		disposition = FILE_OVERWRITE_IF;
+	else if ((oflags & O_CREAT) == O_CREAT)
+		disposition = FILE_OPEN_IF;
+	else
+		cFYI(1, "Create flag not set in create function");
+
 	/* BB add processing to set equivalent of mode - e.g. via CreateX with
 	   ACLs */
 
 	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
-		goto cifs_create_out;
+		goto out;
 	}
 
 	/*
@@ -250,7 +283,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	if (tcon->ses->capabilities & CAP_NT_SMBS)
 		rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
 			 desiredAccess, create_options,
-			 &fileHandle, &oplock, buf, cifs_sb->local_nls,
+			 fileHandle, oplock, buf, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	else
 		rc = -EIO; /* no NT SMB support fall into legacy open below */
@@ -259,17 +292,17 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 		/* old server, retry the open legacy style */
 		rc = SMBLegacyOpen(xid, tcon, full_path, disposition,
 			desiredAccess, create_options,
-			&fileHandle, &oplock, buf, cifs_sb->local_nls,
+			fileHandle, oplock, buf, cifs_sb->local_nls,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	}
 	if (rc) {
 		cFYI(1, "cifs_create returned 0x%x", rc);
-		goto cifs_create_out;
+		goto out;
 	}
 
 	/* If Open reported that we actually created a file
 	   then we now have to set the mode if possible */
-	if ((tcon->unix_ext) && (oplock & CIFS_CREATE_ACTION)) {
+	if ((tcon->unix_ext) && (*oplock & CIFS_CREATE_ACTION)) {
 		struct cifs_unix_set_info_args args = {
 				.mode	= mode,
 				.ctime	= NO_CHANGE_64,
@@ -278,6 +311,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 				.device	= 0,
 		};
 
+		*created = true;
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 			args.uid = (__u64) current_fsuid();
 			if (inode->i_mode & S_ISGID)
@@ -288,7 +322,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 			args.uid = NO_CHANGE_64;
 			args.gid = NO_CHANGE_64;
 		}
-		CIFSSMBUnixSetFileInfo(xid, tcon, &args, fileHandle,
+		CIFSSMBUnixSetFileInfo(xid, tcon, &args, *fileHandle,
 					current->tgid);
 	} else {
 		/* BB implement mode setting via Windows security
@@ -305,11 +339,11 @@ cifs_create_get_file_info:
 					      inode->i_sb, xid);
 	else {
 		rc = cifs_get_inode_info(&newinode, full_path, buf,
-					 inode->i_sb, xid, &fileHandle);
+					 inode->i_sb, xid, fileHandle);
 		if (newinode) {
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
 				newinode->i_mode = mode;
-			if ((oplock & CIFS_CREATE_ACTION) &&
+			if ((*oplock & CIFS_CREATE_ACTION) &&
 			    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)) {
 				newinode->i_uid = current_fsuid();
 				if (inode->i_mode & S_ISGID)
@@ -321,37 +355,139 @@ cifs_create_get_file_info:
 	}
 
 cifs_create_set_dentry:
-	if (rc == 0)
-		d_instantiate(direntry, newinode);
-	else
+	if (rc != 0) {
 		cFYI(1, "Create worked, get_inode_info failed rc = %d", rc);
+		goto out;
+	}
+	d_drop(direntry);
+	d_add(direntry, newinode);
 
-	if (newinode && nd) {
-		struct cifsFileInfo *pfile_info;
-		struct file *filp;
+	/* ENOENT for create?  How weird... */
+	rc = -ENOENT;
+	if (!newinode) {
+		CIFSSMBClose(xid, tcon, *fileHandle);
+		goto out;
+	}
+	rc = 0;
 
-		filp = lookup_instantiate_filp(nd, direntry, generic_file_open);
-		if (IS_ERR(filp)) {
-			rc = PTR_ERR(filp);
-			CIFSSMBClose(xid, tcon, fileHandle);
-			goto cifs_create_out;
-		}
+out:
+	kfree(buf);
+	kfree(full_path);
+	return rc;
+}
 
-		pfile_info = cifs_new_fileinfo(fileHandle, filp, tlink, oplock);
-		if (pfile_info == NULL) {
-			fput(filp);
-			CIFSSMBClose(xid, tcon, fileHandle);
-			rc = -ENOMEM;
-		}
-	} else {
+struct file *
+cifs_atomic_open(struct inode *inode, struct dentry *direntry,
+		 struct opendata *od, unsigned oflags, umode_t mode,
+		 bool *created)
+{
+	int rc;
+	int xid;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	__u16 fileHandle;
+	__u32 oplock;
+	struct file *filp;
+	struct cifsFileInfo *pfile_info;
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
+	if (!(oflags & O_CREAT)) {
+		struct dentry *res = cifs_lookup(inode, direntry, NULL);
+		if (IS_ERR(res))
+			return ERR_CAST(res);
+
+		finish_no_open(od, res);
+		return NULL;
+	}
+
+	rc = check_name(direntry);
+	if (rc)
+		return ERR_PTR(rc);
+
+	xid = GetXid();
+
+	cFYI(1, "parent inode = 0x%p name is: %s and dentry = 0x%p",
+	     inode, direntry->d_name.name, direntry);
+
+	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
+	filp = ERR_CAST(tlink);
+	if (IS_ERR(tlink))
+		goto free_xid;
+
+	tcon = tlink_tcon(tlink);
+
+	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
+			    &oplock, &fileHandle, created);
+
+	if (rc) {
+		filp = ERR_PTR(rc);
+		goto out;
+	}
+
+	filp = finish_open(od, direntry, generic_file_open);
+	if (IS_ERR(filp)) {
 		CIFSSMBClose(xid, tcon, fileHandle);
+		goto out;
 	}
 
-cifs_create_out:
-	kfree(buf);
-	kfree(full_path);
+	pfile_info = cifs_new_fileinfo(fileHandle, filp, tlink, oplock);
+	if (pfile_info == NULL) {
+		CIFSSMBClose(xid, tcon, fileHandle);
+		fput(filp);
+		filp = ERR_PTR(-ENOMEM);
+	}
+
+out:
+	cifs_put_tlink(tlink);
+free_xid:
+	FreeXid(xid);
+	return filp;
+}
+
+int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
+		struct nameidata *nd)
+{
+	int rc;
+	int xid = GetXid();
+	/*
+	 * BB below access is probably too much for mknod to request
+	 *    but we have to do query and setpathinfo so requesting
+	 *    less could fail (unless we want to request getatr and setatr
+	 *    permissions (only).  At least for POSIX we do not have to
+	 *    request so much.
+	 */
+	unsigned oflags = O_EXCL | O_CREAT | O_RDWR;
+	struct tcon_link *tlink;
+	__u16 fileHandle;
+	__u32 oplock;
+	bool created = true;
+
+	cFYI(1, "cifs_create parent inode = 0x%p name is: %s and dentry = 0x%p",
+	     inode, direntry->d_name.name, direntry);
+
+	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
+	rc = PTR_ERR(tlink);
+	if (IS_ERR(tlink))
+		goto free_xid;
+
+	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
+			    &oplock, &fileHandle, &created);
+	if (!rc)
+		CIFSSMBClose(xid, tlink_tcon(tlink), fileHandle);
+
 	cifs_put_tlink(tlink);
+free_xid:
 	FreeXid(xid);
+
 	return rc;
 }
 
@@ -492,16 +628,11 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 {
 	int xid;
 	int rc = 0; /* to get around spurious gcc warning, set to zero here */
-	__u32 oplock;
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
 
@@ -518,31 +649,9 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	}
 	pTcon = tlink_tcon(tlink);
 
-	oplock = pTcon->ses->server->oplocks ? REQ_OPLOCK : 0;
-
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
@@ -560,80 +669,16 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
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
-			switch (rc) {
-			case 0:
-				/*
-				 * The server may allow us to open things like
-				 * FIFOs, but the client isn't set up to deal
-				 * with that. If it's not a regular file, just
-				 * close it and proceed as if it were a normal
-				 * lookup.
-				 */
-				if (newInode && !S_ISREG(newInode->i_mode)) {
-					CIFSSMBClose(xid, pTcon, fileHandle);
-					break;
-				}
-			case -ENOENT:
-				posix_open = true;
-			case -EOPNOTSUPP:
-				break;
-			default:
-				pTcon->broken_posix_open = true;
-			}
-		}
-		if (!posix_open)
-			rc = cifs_get_inode_info_unix(&newInode, full_path,
-						parent_dir_inode->i_sb, xid);
-	} else
+		rc = cifs_get_inode_info_unix(&newInode, full_path,
+					      parent_dir_inode->i_sb, xid);
+	} else {
 		rc = cifs_get_inode_info(&newInode, full_path, NULL,
 				parent_dir_inode->i_sb, xid, NULL);
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

