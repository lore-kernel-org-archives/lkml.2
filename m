Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab0I0AOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:14:49 -0400
Received: from vana.uk.cvut.cz ([147.32.245.124]:55735 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab0I0AOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:14:48 -0400
X-Greylist: delayed 1632 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Sep 2010 20:14:47 EDT
Date: Mon, 27 Sep 2010 01:47:33 +0200
From: Petr Vandrovec <petr@vandrovec.name>
To: linux-fsdevel@vger.kernel.org
Cc: aia21@cam.ac.uk, linux-kernel@vger.kernel.org, arnd@arndb.de,
        viro@zeniv.linux.org.uk
Subject: [PATCH] Remove BKL usage from ncpfs
Message-ID: <20100926234733.GA31884@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 92498b5267aa58e85e20c7b2cbd84d1ed86df47d
Author: Petr Vandrovec <petr@vandrovec.name>
Date:   Sun Sep 26 16:19:12 2010 -0700

    Remove BKL from ncpfs
    
    Dozen of changes in ncpfs to provide some locking other than BKL.
    
    In readdir cache unlock and mark complete first page as last operation,
    so it can be used for synchronization, as code intended.
    
    When updating dentry name on case insensitive filesystems do at least
    some basic locking...
    
    Hold i_mutex when updating inode fields.
    
    Push some ncp_conn_is_valid down to ncp_request.  Connection can become
    invalid at any moment, and fewer error code paths to test the better.
    
    Use i_size_{read,write} to modify file size.
    
    Set inode's backing_dev_info as ncpfs has its own special bdi.
    
    In ioctl unbreak ioctls invoked on filesystem mounted 'ro' - tests are
    for inode writeable or owner match, but were turned to filesystem
    writeable and inode writeable or owner match.  Also collect all permission
    checks in single place.
    
    Add some locking, and remove comments saying that it would be cool to
    add some locks to the code.
    
    Constify some pointers.
    
    Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 9578cbe..9ebd68e 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -95,6 +95,34 @@ const struct dentry_operations ncp_root_dentry_operations =
 };
 
 
+#define ncp_namespace(i)	(NCP_SERVER(i)->name_space[NCP_FINFO(i)->volNumber])
+
+static inline int ncp_preserve_entry_case(struct inode *i, __u32 nscreator)
+{
+#ifdef CONFIG_NCPFS_SMALLDOS
+	int ns = ncp_namespace(i);
+
+	if ((ns == NW_NS_DOS)
+#ifdef CONFIG_NCPFS_OS2_NS
+		|| ((ns == NW_NS_OS2) && (nscreator == NW_NS_DOS))
+#endif /* CONFIG_NCPFS_OS2_NS */
+	   )
+		return 0;
+#endif /* CONFIG_NCPFS_SMALLDOS */
+	return 1;
+}
+
+#define ncp_preserve_case(i)	(ncp_namespace(i) != NW_NS_DOS)
+
+static inline int ncp_case_sensitive(struct dentry *dentry)
+{
+#ifdef CONFIG_NCPFS_NFS_NS
+	return ncp_namespace(dentry->d_inode) == NW_NS_NFS;
+#else
+	return 0;
+#endif /* CONFIG_NCPFS_NFS_NS */
+}
+
 /*
  * Note: leave the hash unchanged if the directory
  * is case-sensitive.
@@ -102,13 +130,12 @@ const struct dentry_operations ncp_root_dentry_operations =
 static int 
 ncp_hash_dentry(struct dentry *dentry, struct qstr *this)
 {
-	struct nls_table *t;
-	unsigned long hash;
-	int i;
-
-	t = NCP_IO_TABLE(dentry);
+	if (!ncp_case_sensitive(dentry)) {
+		struct nls_table *t;
+		unsigned long hash;
+		int i;
 
-	if (!ncp_case_sensitive(dentry->d_inode)) {
+		t = NCP_IO_TABLE(dentry);
 		hash = init_name_hash();
 		for (i=0; i<this->len ; i++)
 			hash = partial_name_hash(ncp_tolower(t, this->name[i]),
@@ -124,7 +151,7 @@ ncp_compare_dentry(struct dentry *dentry, struct qstr *a, struct qstr *b)
 	if (a->len != b->len)
 		return 1;
 
-	if (ncp_case_sensitive(dentry->d_inode))
+	if (ncp_case_sensitive(dentry))
 		return strncmp(a->name, b->name, a->len);
 
 	return ncp_strnicmp(NCP_IO_TABLE(dentry), a->name, b->name, a->len);
@@ -266,7 +293,7 @@ leave_me:;
 
 
 static int
-__ncp_lookup_validate(struct dentry *dentry)
+ncp_lookup_validate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct ncp_server *server;
 	struct dentry *parent;
@@ -283,9 +310,6 @@ __ncp_lookup_validate(struct dentry *dentry)
 
 	server = NCP_SERVER(dir);
 
-	if (!ncp_conn_valid(server))
-		goto finished;
-
 	/*
 	 * Inspired by smbfs:
 	 * The default validation is based on dentry age:
@@ -304,8 +328,11 @@ __ncp_lookup_validate(struct dentry *dentry)
 	if (ncp_is_server_root(dir)) {
 		res = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 				 dentry->d_name.len, 1);
-		if (!res)
+		if (!res) {
 			res = ncp_lookup_volume(server, __name, &(finfo.i));
+			if (!res)
+				ncp_update_known_namespace(server, finfo.i.volNumber, NULL);
+		}
 	} else {
 		res = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 				 dentry->d_name.len, !ncp_preserve_case(dir));
@@ -320,13 +347,17 @@ __ncp_lookup_validate(struct dentry *dentry)
 	 * what we remember, it's not valid any more.
 	 */
 	if (!res) {
-		if (finfo.i.dirEntNum == NCP_FINFO(dentry->d_inode)->dirEntNum) {
+		struct inode *inode = dentry->d_inode;
+
+		mutex_lock(&inode->i_mutex);
+		if (finfo.i.dirEntNum == NCP_FINFO(inode)->dirEntNum) {
 			ncp_new_dentry(dentry);
 			val=1;
 		} else
 			DDPRINTK("ncp_lookup_validate: found, but dirEntNum changed\n");
 
-		ncp_update_inode2(dentry->d_inode, &finfo);
+		ncp_update_inode2(inode, &finfo);
+		mutex_unlock(&inode->i_mutex);
 	}
 
 finished:
@@ -335,16 +366,6 @@ finished:
 	return val;
 }
 
-static int
-ncp_lookup_validate(struct dentry * dentry, struct nameidata *nd)
-{
-	int res;
-	lock_kernel();
-	res = __ncp_lookup_validate(dentry);
-	unlock_kernel();
-	return res;
-}
-
 static struct dentry *
 ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 {
@@ -411,8 +432,6 @@ static int ncp_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	int result, mtime_valid = 0;
 	time_t mtime = 0;
 
-	lock_kernel();
-
 	ctl.page  = NULL;
 	ctl.cache = NULL;
 
@@ -421,6 +440,7 @@ static int ncp_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		(int) filp->f_pos);
 
 	result = -EIO;
+	/* Do not generate '.' and '..' when server is dead. */
 	if (!ncp_conn_valid(server))
 		goto out;
 
@@ -532,6 +552,12 @@ read_really:
 	ctl.head.end = ctl.fpos - 1;
 	ctl.head.eof = ctl.valid;
 finished:
+	if (ctl.page) {
+		kunmap(ctl.page);
+		SetPageUptodate(ctl.page);
+		unlock_page(ctl.page);
+		page_cache_release(ctl.page);
+	}
 	if (page) {
 		cache->head = ctl.head;
 		kunmap(page);
@@ -539,23 +565,17 @@ finished:
 		unlock_page(page);
 		page_cache_release(page);
 	}
-	if (ctl.page) {
-		kunmap(ctl.page);
-		SetPageUptodate(ctl.page);
-		unlock_page(ctl.page);
-		page_cache_release(ctl.page);
-	}
 out:
-	unlock_kernel();
 	return result;
 }
 
 static int
 ncp_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-		struct ncp_cache_control *ctrl, struct ncp_entry_info *entry)
+		struct ncp_cache_control *ctrl, struct ncp_entry_info *entry,
+		int inval_childs)
 {
 	struct dentry *newdent, *dentry = filp->f_path.dentry;
-	struct inode *newino, *inode = dentry->d_inode;
+	struct inode *dir = dentry->d_inode;
 	struct ncp_cache_control ctl = *ctrl;
 	struct qstr qname;
 	int valid = 0;
@@ -564,9 +584,9 @@ ncp_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 	__u8 __name[NCP_MAXPATHLEN + 1];
 
 	qname.len = sizeof(__name);
-	if (ncp_vol2io(NCP_SERVER(inode), __name, &qname.len,
+	if (ncp_vol2io(NCP_SERVER(dir), __name, &qname.len,
 			entry->i.entryName, entry->i.nameLen,
-			!ncp_preserve_entry_case(inode, entry->i.NSCreator)))
+			!ncp_preserve_entry_case(dir, entry->i.NSCreator)))
 		return 1; /* I'm not sure */
 
 	qname.name = __name;
@@ -584,22 +604,64 @@ ncp_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 			goto end_advance;
 	} else {
 		hashed = 1;
-		memcpy((char *) newdent->d_name.name, qname.name,
-							newdent->d_name.len);
+
+		/* If case sensitivity changed for this volume, all entries below this one
+		   should be thrown away.  This entry itself is not affected, as its case
+		   sensitivity is controlled by its own parent. */
+		if (inval_childs)
+			shrink_dcache_parent(newdent);
+
+		/*
+		 * It is not as dangerous as it looks.  NetWare's OS2 namespace is
+		 * case preserving yet case insensitive.  So we update dentry's name
+		 * as received from server.  We found dentry via d_lookup with our
+		 * hash, so we know that hash does not change, and so replacing name
+		 * should be reasonably safe.
+		 */
+		if (qname.len == newdent->d_name.len &&
+		    memcmp(newdent->d_name.name, qname.name, newdent->d_name.len)) {
+			struct inode *inode = newdent->d_inode;
+
+			/*
+			 * Inside ncpfs all uses of d_name are either for debugging,
+			 * or on functions which acquire inode mutex (mknod, creat,
+			 * lookup).  So grab i_mutex here, to be sure.  d_path
+			 * uses dcache_lock when generating path, so we should too.
+			 * And finally d_compare is protected by dentry's d_lock, so
+			 * here we go.
+			 */
+			if (inode)
+				mutex_lock(&inode->i_mutex);
+			spin_lock(&dcache_lock);
+			spin_lock(&newdent->d_lock);
+			memcpy((char *) newdent->d_name.name, qname.name,
+								newdent->d_name.len);
+			spin_unlock(&newdent->d_lock);
+			spin_unlock(&dcache_lock);
+			if (inode)
+				mutex_unlock(&inode->i_mutex);
+		}
 	}
 
 	if (!newdent->d_inode) {
+		struct inode *inode;
+
 		entry->opened = 0;
-		entry->ino = iunique(inode->i_sb, 2);
-		newino = ncp_iget(inode->i_sb, entry);
-		if (newino) {
+		entry->ino = iunique(dir->i_sb, 2);
+		inode = ncp_iget(dir->i_sb, entry);
+		if (inode) {
 			newdent->d_op = &ncp_dentry_operations;
-			d_instantiate(newdent, newino);
+			d_instantiate(newdent, inode);
 			if (!hashed)
 				d_rehash(newdent);
 		}
-	} else
-		ncp_update_inode2(newdent->d_inode, entry);
+	} else {
+		struct inode *inode = newdent->d_inode;
+
+		mutex_lock(&inode->i_mutex);
+		ncp_update_inode2(inode, entry);
+		mutex_unlock(&inode->i_mutex);
+	}
 
 	if (newdent->d_inode) {
 		ino = newdent->d_inode->i_ino;
@@ -617,7 +679,7 @@ ncp_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 		ctl.cache = NULL;
 		ctl.idx  -= NCP_DIRCACHE_SIZE;
 		ctl.ofs  += 1;
-		ctl.page  = grab_cache_page(&inode->i_data, ctl.ofs);
+		ctl.page  = grab_cache_page(&dir->i_data, ctl.ofs);
 		if (ctl.page)
 			ctl.cache = kmap(ctl.page);
 	}
@@ -633,7 +695,7 @@ end_advance:
 		if (!ino)
 			ino = find_inode_number(dentry, &qname);
 		if (!ino)
-			ino = iunique(inode->i_sb, 2);
+			ino = iunique(dir->i_sb, 2);
 		ctl.filled = filldir(dirent, qname.name, qname.len,
 				     filp->f_pos, ino, DT_UNKNOWN);
 		if (!ctl.filled)
@@ -660,6 +722,7 @@ ncp_read_volume_list(struct file *filp, void *dirent, filldir_t filldir,
 			(unsigned long) filp->f_pos);
 
 	for (i = 0; i < NCP_NUMBER_OF_VOLUMES; i++) {
+		int inval_dentry;
 
 		if (ncp_get_volume_info_with_number(server, i, &info) != 0)
 			return;
@@ -675,8 +738,9 @@ ncp_read_volume_list(struct file *filp, void *dirent, filldir_t filldir,
 				info.volume_name);
 			continue;
 		}
+		inval_dentry = ncp_update_known_namespace(server, entry.i.volNumber, NULL);
 		entry.volume = entry.i.volNumber;
-		if (!ncp_fill_cache(filp, dirent, filldir, ctl, &entry))
+		if (!ncp_fill_cache(filp, dirent, filldir, ctl, &entry, inval_dentry))
 			return;
 	}
 }
@@ -739,7 +803,7 @@ ncp_do_readdir(struct file *filp, void *dirent, filldir_t filldir,
 			rpl += onerpl;
 			rpls -= onerpl;
 			entry.volume = entry.i.volNumber;
-			if (!ncp_fill_cache(filp, dirent, filldir, ctl, &entry))
+			if (!ncp_fill_cache(filp, dirent, filldir, ctl, &entry, 0))
 				break;
 		}
 	} while (more);
@@ -775,17 +839,19 @@ int ncp_conn_logged_in(struct super_block *sb)
 		if (dent) {
 			struct inode* ino = dent->d_inode;
 			if (ino) {
+				ncp_update_known_namespace(server, volNumber, NULL);
 				NCP_FINFO(ino)->volNumber = volNumber;
 				NCP_FINFO(ino)->dirEntNum = dirEntNum;
 				NCP_FINFO(ino)->DosDirNum = DosDirNum;
+				result = 0;
 			} else {
 				DPRINTK("ncpfs: sb->s_root->d_inode == NULL!\n");
 			}
 		} else {
 			DPRINTK("ncpfs: sb->s_root == NULL!\n");
 		}
-	}
-	result = 0;
+	} else
+		result = 0;
 
 out:
 	return result;
@@ -799,7 +865,6 @@ static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, struc
 	int error, res, len;
 	__u8 __name[NCP_MAXPATHLEN + 1];
 
-	lock_kernel();
 	error = -EIO;
 	if (!ncp_conn_valid(server))
 		goto finished;
@@ -813,6 +878,8 @@ static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, struc
 				 dentry->d_name.len, 1);
 		if (!res)
 			res = ncp_lookup_volume(server, __name, &(finfo.i));
+			if (!res)
+				ncp_update_known_namespace(server, finfo.i.volNumber, NULL);
 	} else {
 		res = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 				 dentry->d_name.len, !ncp_preserve_case(dir));
@@ -846,7 +913,6 @@ add_entry:
 
 finished:
 	PPRINTK("ncp_lookup: result=%d\n", error);
-	unlock_kernel();
 	return ERR_PTR(error);
 }
 
@@ -887,11 +953,6 @@ int ncp_create_new(struct inode *dir, struct dentry *dentry, int mode,
 	PPRINTK("ncp_create_new: creating %s/%s, mode=%x\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name, mode);
 
-	error = -EIO;
-	lock_kernel();
-	if (!ncp_conn_valid(server))
-		goto out;
-
 	ncp_age_dentry(server, dentry);
 	len = sizeof(__name);
 	error = ncp_io2vol(server, __name, &len, dentry->d_name.name,
@@ -917,6 +978,8 @@ int ncp_create_new(struct inode *dir, struct dentry *dentry, int mode,
 		if (result) {
 			if (result == 0x87)
 				error = -ENAMETOOLONG;
+			else if (result < 0)
+				error = result;
 			DPRINTK("ncp_create: %s/%s failed\n",
 				dentry->d_parent->d_name.name, dentry->d_name.name);
 			goto out;
@@ -935,7 +998,6 @@ int ncp_create_new(struct inode *dir, struct dentry *dentry, int mode,
 
 	error = ncp_instantiate(dir, dentry, &finfo);
 out:
-	unlock_kernel();
 	return error;
 }
 
@@ -955,11 +1017,6 @@ static int ncp_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	DPRINTK("ncp_mkdir: making %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	error = -EIO;
-	lock_kernel();
-	if (!ncp_conn_valid(server))
-		goto out;
-
 	ncp_age_dentry(server, dentry);
 	len = sizeof(__name);
 	error = ncp_io2vol(server, __name, &len, dentry->d_name.name,
@@ -967,12 +1024,11 @@ static int ncp_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (error)
 		goto out;
 
-	error = -EACCES;
-	if (ncp_open_create_file_or_subdir(server, dir, __name,
+	error = ncp_open_create_file_or_subdir(server, dir, __name,
 					   OC_MODE_CREATE, aDIR,
 					   cpu_to_le16(0xffff),
-					   &finfo) == 0)
-	{
+					   &finfo);
+	if (error == 0) {
 		if (ncp_is_nfs_extras(server, finfo.volume)) {
 			mode |= S_IFDIR;
 			finfo.i.nfs.mode = mode;
@@ -983,9 +1039,10 @@ static int ncp_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 				goto out;
 		}
 		error = ncp_instantiate(dir, dentry, &finfo);
+	} else if (error > 0) {
+		error = -EACCES;
 	}
 out:
-	unlock_kernel();
 	return error;
 }
 
@@ -998,11 +1055,6 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
 	DPRINTK("ncp_rmdir: removing %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	error = -EIO;
-	lock_kernel();
-	if (!ncp_conn_valid(server))
-		goto out;
-
 	error = -EBUSY;
 	if (!d_unhashed(dentry))
 		goto out;
@@ -1036,11 +1088,10 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
 			error = -ENOENT;
 			break;
 		default:
-			error = -EACCES;
+			error = result < 0 ? result : -EACCES;
 			break;
        	}
 out:
-	unlock_kernel();
 	return error;
 }
 
@@ -1050,15 +1101,10 @@ static int ncp_unlink(struct inode *dir, struct dentry *dentry)
 	struct ncp_server *server;
 	int error;
 
-	lock_kernel();
 	server = NCP_SERVER(dir);
 	DPRINTK("ncp_unlink: unlinking %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 	
-	error = -EIO;
-	if (!ncp_conn_valid(server))
-		goto out;
-
 	/*
 	 * Check whether to close the file ...
 	 */
@@ -1097,12 +1143,9 @@ static int ncp_unlink(struct inode *dir, struct dentry *dentry)
 			error = -ENOENT;
 			break;
 		default:
-			error = -EACCES;
+			error = error < 0 ? error : -EACCES;
 			break;
 	}
-		
-out:
-	unlock_kernel();
 	return error;
 }
 
@@ -1118,11 +1161,6 @@ static int ncp_rename(struct inode *old_dir, struct dentry *old_dentry,
 		old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		new_dentry->d_parent->d_name.name, new_dentry->d_name.name);
 
-	error = -EIO;
-	lock_kernel();
-	if (!ncp_conn_valid(server))
-		goto out;
-
 	ncp_age_dentry(server, old_dentry);
 	ncp_age_dentry(server, new_dentry);
 
@@ -1161,11 +1199,10 @@ static int ncp_rename(struct inode *old_dir, struct dentry *old_dentry,
 			error = -ENOENT;
 			break;
 		default:
-			error = -EACCES;
+			error = error < 0 ? error : -EACCES;
 			break;
 	}
 out:
-	unlock_kernel();
 	return error;
 }
 
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 3639cc5..618feba 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -113,9 +113,6 @@ ncp_file_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	DPRINTK("ncp_file_read: enter %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	if (!ncp_conn_valid(NCP_SERVER(inode)))
-		return -EIO;
-
 	pos = *ppos;
 
 	if ((ssize_t) count < 0) {
@@ -192,13 +189,11 @@ ncp_file_write(struct file *file, const char __user *buf, size_t count, loff_t *
 
 	DPRINTK("ncp_file_write: enter %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
-	if (!ncp_conn_valid(NCP_SERVER(inode)))
-		return -EIO;
 	if ((ssize_t) count < 0)
 		return -EINVAL;
 	pos = *ppos;
 	if (file->f_flags & O_APPEND) {
-		pos = inode->i_size;
+		pos = i_size_read(inode);
 	}
 
 	if (pos + count > MAX_NON_LFS && !(file->f_flags&O_LARGEFILE)) {
@@ -264,8 +259,11 @@ ncp_file_write(struct file *file, const char __user *buf, size_t count, loff_t *
 
 	*ppos = pos;
 
-	if (pos > inode->i_size) {
-		inode->i_size = pos;
+	if (pos > i_size_read(inode)) {
+		mutex_lock(&inode->i_mutex);
+		if (pos > i_size_read(inode))
+			i_size_write(inode, pos);
+		mutex_unlock(&inode->i_mutex);
 	}
 	DPRINTK("ncp_file_write: exit %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
@@ -281,18 +279,9 @@ static int ncp_release(struct inode *inode, struct file *file) {
 	return 0;
 }
 
-static loff_t ncp_remote_llseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t ret;
-	lock_kernel();
-	ret = generic_file_llseek_unlocked(file, offset, origin);
-	unlock_kernel();
-	return ret;
-}
-
 const struct file_operations ncp_file_operations =
 {
-	.llseek 	= ncp_remote_llseek,
+	.llseek		= generic_file_llseek,
 	.read		= ncp_file_read,
 	.write		= ncp_file_write,
 	.unlocked_ioctl	= ncp_ioctl,
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index b4de38c..5f4e58d 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -139,7 +139,7 @@ static void ncp_update_dates(struct inode *inode, struct nw_info_struct *nwi)
 		inode->i_mode = nwi->nfs.mode;
 	}
 
-	inode->i_blocks = (inode->i_size + NCP_BLOCK_SIZE - 1) >> NCP_BLOCK_SHIFT;
+	inode->i_blocks = (i_size_read(inode) + NCP_BLOCK_SIZE - 1) >> NCP_BLOCK_SHIFT;
 
 	inode->i_mtime.tv_sec = ncp_date_dos2unix(nwi->modifyTime, nwi->modifyDate);
 	inode->i_ctime.tv_sec = ncp_date_dos2unix(nwi->creationTime, nwi->creationDate);
@@ -158,18 +158,21 @@ static void ncp_update_attrs(struct inode *inode, struct ncp_entry_info *nwinfo)
 		inode->i_mode = server->m.dir_mode;
 		/* for directories dataStreamSize seems to be some
 		   Object ID ??? */
-		inode->i_size = NCP_BLOCK_SIZE;
+		i_size_write(inode, NCP_BLOCK_SIZE);
 	} else {
+		u32 size;
+
 		inode->i_mode = server->m.file_mode;
-		inode->i_size = le32_to_cpu(nwi->dataStreamSize);
+		size = le32_to_cpu(nwi->dataStreamSize);
+		i_size_write(inode, size);
 #ifdef CONFIG_NCPFS_EXTRAS
 		if ((server->m.flags & (NCP_MOUNT_EXTRAS|NCP_MOUNT_SYMLINKS)) 
 		 && (nwi->attributes & aSHARED)) {
 			switch (nwi->attributes & (aHIDDEN|aSYSTEM)) {
 				case aHIDDEN:
 					if (server->m.flags & NCP_MOUNT_SYMLINKS) {
-						if (/* (inode->i_size >= NCP_MIN_SYMLINK_SIZE)
-						 && */ (inode->i_size <= NCP_MAX_SYMLINK_SIZE)) {
+						if (/* (size >= NCP_MIN_SYMLINK_SIZE)
+						 && */ (size <= NCP_MAX_SYMLINK_SIZE)) {
 							inode->i_mode = (inode->i_mode & ~S_IFMT) | S_IFLNK;
 							NCP_FINFO(inode)->flags |= NCPI_KLUDGE_SYMLINK;
 							break;
@@ -208,7 +211,7 @@ void ncp_update_inode2(struct inode* inode, struct ncp_entry_info *nwinfo)
 }
 
 /*
- * Fill in the inode based on the ncp_entry_info structure.
+ * Fill in the inode based on the ncp_entry_info structure.  Used only for brand new inodes.
  */
 static void ncp_set_attr(struct inode *inode, struct ncp_entry_info *nwinfo)
 {
@@ -254,6 +257,7 @@ ncp_iget(struct super_block *sb, struct ncp_entry_info *info)
 	if (inode) {
 		atomic_set(&NCP_FINFO(inode)->opened, info->opened);
 
+		inode->i_mapping->backing_dev_info = sb->s_bdi;
 		inode->i_ino = info->ino;
 		ncp_set_attr(inode, info);
 		if (S_ISREG(inode->i_mode)) {
@@ -565,10 +569,12 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 /*	server->conn_status = 0;	*/
 /*	server->root_dentry = NULL;	*/
 /*	server->root_setuped = 0;	*/
+	mutex_init(&server->root_setup_lock);
 #ifdef CONFIG_NCPFS_PACKET_SIGNING
 /*	server->sign_wanted = 0;	*/
 /*	server->sign_active = 0;	*/
 #endif
+	init_rwsem(&server->auth_rwsem);
 	server->auth.auth_type = NCP_AUTH_NONE;
 /*	server->auth.object_name_len = 0;	*/
 /*	server->auth.object_name = NULL;	*/
@@ -593,7 +599,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 	server->nls_io = load_nls_default();
 #endif /* CONFIG_NCPFS_NLS */
 
-	server->dentry_ttl = 0;	/* no caching */
+	atomic_set(&server->dentry_ttl, 0);	/* no caching */
 
 	INIT_LIST_HEAD(&server->tx.requests);
 	mutex_init(&server->rcv.creq_mutex);
@@ -658,8 +664,10 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 				goto out_disconnect;
 			}
 		}
+		ncp_lock_server(server);
 		if (options & 2)
 			server->sign_wanted = 1;
+		ncp_unlock_server(server);
 	}
 	else 
 #endif	/* CONFIG_NCPFS_PACKET_SIGNING */
@@ -720,6 +728,9 @@ out_nls:
 	unload_nls(server->nls_io);
 	unload_nls(server->nls_vol);
 #endif
+	mutex_destroy(&server->rcv.creq_mutex);
+	mutex_destroy(&server->root_setup_lock);
+	mutex_destroy(&server->mutex);
 out_fput2:
 	if (server->info_filp)
 		fput(server->info_filp);
@@ -743,8 +754,6 @@ static void ncp_put_super(struct super_block *sb)
 {
 	struct ncp_server *server = NCP_SBP(sb);
 
-	lock_kernel();
-
 	ncp_lock_server(server);
 	ncp_disconnect(server);
 	ncp_unlock_server(server);
@@ -756,6 +765,9 @@ static void ncp_put_super(struct super_block *sb)
 	unload_nls(server->nls_vol);
 	unload_nls(server->nls_io);
 #endif /* CONFIG_NCPFS_NLS */
+	mutex_destroy(&server->rcv.creq_mutex);
+	mutex_destroy(&server->root_setup_lock);
+	mutex_destroy(&server->mutex);
 
 	if (server->info_filp)
 		fput(server->info_filp);
@@ -771,8 +783,6 @@ static void ncp_put_super(struct super_block *sb)
 	vfree(server->packet);
 	sb->s_fs_info = NULL;
 	kfree(server);
-
-	unlock_kernel();
 }
 
 static int ncp_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -851,10 +861,8 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
 
 	result = -EIO;
 
-	lock_kernel();	
-
 	server = NCP_SERVER(inode);
-	if ((!server) || !ncp_conn_valid(server))
+	if (!server)	/* How this could happen? */
 		goto out;
 
 	/* ageing the dentry to force validation */
@@ -981,8 +989,6 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
 		result = ncp_modify_file_or_subdir_dos_info(NCP_SERVER(inode),
 				      inode, info_mask, &info);
 		if (result != 0) {
-			result = -EACCES;
-
 			if (info_mask == (DM_CREATE_TIME | DM_CREATE_DATE)) {
 				/* NetWare seems not to allow this. I
 				   do not know why. So, just tell the
@@ -1005,7 +1011,8 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
 	mark_inode_dirty(inode);
 
 out:
-	unlock_kernel();
+	if (result > 0)
+		result = -EACCES;
 	return result;
 }
 
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 84a8cfc..1db6f2d 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -35,16 +35,11 @@
 #define NCP_PACKET_SIZE_INTERNAL 65536
 
 static int
-ncp_get_fs_info(struct ncp_server * server, struct file *file,
+ncp_get_fs_info(struct ncp_server * server, struct inode *inode,
 		struct ncp_fs_info __user *arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ncp_fs_info info;
 
-	if (file_permission(file, MAY_WRITE) != 0
-	    && current_uid() != server->m.mounted_uid)
-		return -EACCES;
-
 	if (copy_from_user(&info, arg, sizeof(info)))
 		return -EFAULT;
 
@@ -65,16 +60,11 @@ ncp_get_fs_info(struct ncp_server * server, struct file *file,
 }
 
 static int
-ncp_get_fs_info_v2(struct ncp_server * server, struct file *file,
+ncp_get_fs_info_v2(struct ncp_server * server, struct inode *inode,
 		   struct ncp_fs_info_v2 __user * arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ncp_fs_info_v2 info2;
 
-	if (file_permission(file, MAY_WRITE) != 0
-	    && current_uid() != server->m.mounted_uid)
-		return -EACCES;
-
 	if (copy_from_user(&info2, arg, sizeof(info2)))
 		return -EFAULT;
 
@@ -136,16 +126,11 @@ struct compat_ncp_privatedata_ioctl
 #define NCP_IOC_SETPRIVATEDATA_32	_IOR('n', 10, struct compat_ncp_privatedata_ioctl)
 
 static int
-ncp_get_compat_fs_info_v2(struct ncp_server * server, struct file *file,
+ncp_get_compat_fs_info_v2(struct ncp_server * server, struct inode *inode,
 		   struct compat_ncp_fs_info_v2 __user * arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	struct compat_ncp_fs_info_v2 info2;
 
-	if (file_permission(file, MAY_WRITE) != 0
-	    && current_uid() != server->m.mounted_uid)
-		return -EACCES;
-
 	if (copy_from_user(&info2, arg, sizeof(info2)))
 		return -EFAULT;
 
@@ -182,11 +167,8 @@ ncp_set_charsets(struct ncp_server* server, struct ncp_nls_ioctl __user *arg)
 	struct nls_table *iocharset;
 	struct nls_table *oldset_io;
 	struct nls_table *oldset_cp;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-	if (server->root_setuped)
-		return -EBUSY;
+	int utf8;
+	int err;
 
 	if (copy_from_user(&user, arg, sizeof(user)))
 		return -EFAULT;
@@ -206,28 +188,40 @@ ncp_set_charsets(struct ncp_server* server, struct ncp_nls_ioctl __user *arg)
 	user.iocharset[NCP_IOCSNAME_LEN] = 0;
 	if (!user.iocharset[0] || !strcmp(user.iocharset, "default")) {
 		iocharset = load_nls_default();
-		NCP_CLR_FLAG(server, NCP_FLAG_UTF8);
+		utf8 = 0;
 	} else if (!strcmp(user.iocharset, "utf8")) {
 		iocharset = load_nls_default();
-		NCP_SET_FLAG(server, NCP_FLAG_UTF8);
+		utf8 = 1;
 	} else {
 		iocharset = load_nls(user.iocharset);
 		if (!iocharset) {
 			unload_nls(codepage);
 			return -EBADRQC;
 		}
-		NCP_CLR_FLAG(server, NCP_FLAG_UTF8);
+		utf8 = 0;
 	}
 
-	oldset_cp = server->nls_vol;
-	server->nls_vol = codepage;
-	oldset_io = server->nls_io;
-	server->nls_io = iocharset;
-
+	mutex_lock(&server->root_setup_lock);
+	if (server->root_setuped) {
+		oldset_cp = codepage;
+		oldset_io = iocharset;
+		err = -EBUSY;
+	} else {
+		if (utf8)
+			NCP_SET_FLAG(server, NCP_FLAG_UTF8);
+		else
+			NCP_CLR_FLAG(server, NCP_FLAG_UTF8);
+		oldset_cp = server->nls_vol;
+		server->nls_vol = codepage;
+		oldset_io = server->nls_io;
+		server->nls_io = iocharset;
+		err = 0;
+	}
+	mutex_unlock(&server->root_setup_lock);
 	unload_nls(oldset_cp);
 	unload_nls(oldset_io);
 
-	return 0;
+	return err;
 }
 
 static int
@@ -237,6 +231,7 @@ ncp_get_charsets(struct ncp_server* server, struct ncp_nls_ioctl __user *arg)
 	int len;
 
 	memset(&user, 0, sizeof(user));
+	mutex_lock(&server->root_setup_lock);
 	if (server->nls_vol && server->nls_vol->charset) {
 		len = strlen(server->nls_vol->charset);
 		if (len > NCP_IOCSNAME_LEN)
@@ -254,6 +249,7 @@ ncp_get_charsets(struct ncp_server* server, struct ncp_nls_ioctl __user *arg)
 		strncpy(user.iocharset,	server->nls_io->charset, len);
 		user.iocharset[len] = 0;
 	}
+	mutex_unlock(&server->root_setup_lock);
 
 	if (copy_to_user(arg, &user, sizeof(user)))
 		return -EFAULT;
@@ -261,25 +257,19 @@ ncp_get_charsets(struct ncp_server* server, struct ncp_nls_ioctl __user *arg)
 }
 #endif /* CONFIG_NCPFS_NLS */
 
-static long __ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static long __ncp_ioctl(struct inode *inode, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
 	struct ncp_server *server = NCP_SERVER(inode);
 	int result;
 	struct ncp_ioctl_request request;
 	char* bouncebuffer;
 	void __user *argp = (void __user *)arg;
-	uid_t uid = current_uid();
 
 	switch (cmd) {
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_NCPREQUEST_32:
 #endif
 	case NCP_IOC_NCPREQUEST:
-		if (file_permission(filp, MAY_WRITE) != 0
-		    && uid != server->m.mounted_uid)
-			return -EACCES;
-
 #ifdef CONFIG_COMPAT
 		if (cmd == NCP_IOC_NCPREQUEST_32) {
 			struct compat_ncp_ioctl_request request32;
@@ -331,59 +321,58 @@ static long __ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	case NCP_IOC_CONN_LOGGED_IN:
 
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
 		if (!(server->m.int_flags & NCP_IMOUNT_LOGGEDIN_POSSIBLE))
 			return -EINVAL;
+		mutex_lock(&server->root_setup_lock);
 		if (server->root_setuped)
-			return -EBUSY;
-		server->root_setuped = 1;
-		return ncp_conn_logged_in(inode->i_sb);
+			result = -EBUSY;
+		else {
+			result = ncp_conn_logged_in(inode->i_sb);
+			if (result == 0)
+				server->root_setuped = 1;
+		}
+		mutex_unlock(&server->root_setup_lock);
+		return result;
 
 	case NCP_IOC_GET_FS_INFO:
-		return ncp_get_fs_info(server, filp, argp);
+		return ncp_get_fs_info(server, inode, argp);
 
 	case NCP_IOC_GET_FS_INFO_V2:
-		return ncp_get_fs_info_v2(server, filp, argp);
+		return ncp_get_fs_info_v2(server, inode, argp);
 
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_GET_FS_INFO_V2_32:
-		return ncp_get_compat_fs_info_v2(server, filp, argp);
+		return ncp_get_compat_fs_info_v2(server, inode, argp);
 #endif
 	/* we have too many combinations of CONFIG_COMPAT,
 	 * CONFIG_64BIT and CONFIG_UID16, so just handle
 	 * any of the possible ioctls */
 	case NCP_IOC_GETMOUNTUID16:
-	case NCP_IOC_GETMOUNTUID32:
-	case NCP_IOC_GETMOUNTUID64:
-		if (file_permission(filp, MAY_READ) != 0
-			&& uid != server->m.mounted_uid)
-			return -EACCES;
-
-		if (cmd == NCP_IOC_GETMOUNTUID16) {
+		{
 			u16 uid;
+
 			SET_UID(uid, server->m.mounted_uid);
 			if (put_user(uid, (u16 __user *)argp))
 				return -EFAULT;
-		} else if (cmd == NCP_IOC_GETMOUNTUID32) {
-			if (put_user(server->m.mounted_uid,
-						(u32 __user *)argp))
-				return -EFAULT;
-		} else {
-			if (put_user(server->m.mounted_uid,
-						(u64 __user *)argp))
-				return -EFAULT;
+			return 0;
 		}
+	case NCP_IOC_GETMOUNTUID32:
+		if (put_user(server->m.mounted_uid,
+			     (u32 __user *)argp))
+			return -EFAULT;
+		return 0;
+	case NCP_IOC_GETMOUNTUID64:
+		if (put_user(server->m.mounted_uid,
+			     (u64 __user *)argp))
+			return -EFAULT;
 		return 0;
 
 	case NCP_IOC_GETROOT:
 		{
 			struct ncp_setroot_ioctl sr;
 
-			if (file_permission(filp, MAY_READ) != 0
-			    && uid != server->m.mounted_uid)
-				return -EACCES;
-
+			result = -EACCES;
+			mutex_lock(&server->root_setup_lock);
 			if (server->m.mounted_vol[0]) {
 				struct dentry* dentry = inode->i_sb->s_root;
 
@@ -394,6 +383,7 @@ static long __ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 						sr.volNumber = NCP_FINFO(s_inode)->volNumber;
 						sr.dirEntNum = NCP_FINFO(s_inode)->dirEntNum;
 						sr.namespace = server->name_space[sr.volNumber];
+						result = 0;
 					} else
 						DPRINTK("ncpfs: s_root->d_inode==NULL\n");
 				} else
@@ -402,10 +392,12 @@ static long __ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				sr.volNumber = -1;
 				sr.namespace = 0;
 				sr.dirEntNum = 0;
+				result = 0;
 			}
-			if (copy_to_user(argp, &sr, sizeof(sr)))
-				return -EFAULT;
-			return 0;
+			mutex_unlock(&server->root_setup_lock);
+			if (!result && copy_to_user(argp, &sr, sizeof(sr)))
+				result = -EFAULT;
+			return result;
 		}
 
 	case NCP_IOC_SETROOT:
@@ -416,103 +408,114 @@ static long __ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			__le32 dosde;
 			struct dentry* dentry;
 
-			if (!capable(CAP_SYS_ADMIN))
-			{
-				return -EACCES;
-			}
-			if (server->root_setuped) return -EBUSY;
 			if (copy_from_user(&sr, argp, sizeof(sr)))
 				return -EFAULT;
-			if (sr.volNumber < 0) {
-				server->m.mounted_vol[0] = 0;
-				vnum = NCP_NUMBER_OF_VOLUMES;
-				de = 0;
-				dosde = 0;
-			} else if (sr.volNumber >= NCP_NUMBER_OF_VOLUMES) {
-				return -EINVAL;
-			} else if (ncp_mount_subdir(server, sr.volNumber,
-						sr.namespace, sr.dirEntNum,
-						&vnum, &de, &dosde)) {
-				return -ENOENT;
-			}
-			
-			dentry = inode->i_sb->s_root;
-			server->root_setuped = 1;
-			if (dentry) {
-				struct inode* s_inode = dentry->d_inode;
-				
-				if (s_inode) {
-					NCP_FINFO(s_inode)->volNumber = vnum;
-					NCP_FINFO(s_inode)->dirEntNum = de;
-					NCP_FINFO(s_inode)->DosDirNum = dosde;
+			mutex_lock(&server->root_setup_lock);
+			if (server->root_setuped)
+				result = -EBUSY;
+			else {
+				if (sr.volNumber < 0) {
+					server->m.mounted_vol[0] = 0;
+					vnum = NCP_NUMBER_OF_VOLUMES;
+					de = 0;
+					dosde = 0;
+					result = 0;
+				} else if (sr.volNumber >= NCP_NUMBER_OF_VOLUMES) {
+					result = -EINVAL;
+				} else if (ncp_mount_subdir(server, sr.volNumber,
+							sr.namespace, sr.dirEntNum,
+							&vnum, &de, &dosde)) {
+					result = -ENOENT;
 				} else
-					DPRINTK("ncpfs: s_root->d_inode==NULL\n");
-			} else
-				DPRINTK("ncpfs: s_root==NULL\n");
+					result = 0;
 
-			return 0;
+				if (result == 0) {
+					dentry = inode->i_sb->s_root;
+					if (dentry) {
+						struct inode* s_inode = dentry->d_inode;
+				
+						if (s_inode) {
+							NCP_FINFO(s_inode)->volNumber = vnum;
+							NCP_FINFO(s_inode)->dirEntNum = de;
+							NCP_FINFO(s_inode)->DosDirNum = dosde;
+							server->root_setuped = 1;
+						} else {
+							DPRINTK("ncpfs: s_root->d_inode==NULL\n");
+							result = -EIO;
+						}
+					} else {
+						DPRINTK("ncpfs: s_root==NULL\n");
+						result = -EIO;
+					}
+				}
+				result = 0;
+			}
+			mutex_unlock(&server->root_setup_lock);
+
+			return result;
 		}
 
 #ifdef CONFIG_NCPFS_PACKET_SIGNING	
 	case NCP_IOC_SIGN_INIT:
-		if (file_permission(filp, MAY_WRITE) != 0
-		    && uid != server->m.mounted_uid)
-			return -EACCES;
-
-		if (argp) {
-			if (server->sign_wanted)
-			{
-				struct ncp_sign_init sign;
+		{
+			struct ncp_sign_init sign;
 
+			if (argp)
 				if (copy_from_user(&sign, argp, sizeof(sign)))
 					return -EFAULT;
-				memcpy(server->sign_root,sign.sign_root,8);
-				memcpy(server->sign_last,sign.sign_last,16);
-				server->sign_active = 1;
+			ncp_lock_server(server);
+			mutex_lock(&server->rcv.creq_mutex);
+			if (argp) {
+				if (server->sign_wanted) {
+					memcpy(server->sign_root,sign.sign_root,8);
+					memcpy(server->sign_last,sign.sign_last,16);
+					server->sign_active = 1;
+				}
+				/* ignore when signatures not wanted */
+			} else {
+				server->sign_active = 0;
 			}
-			/* ignore when signatures not wanted */
-		} else {
-			server->sign_active = 0;
+			mutex_unlock(&server->rcv.creq_mutex);
+			ncp_unlock_server(server);
+			return 0;		
 		}
-		return 0;		
 		
         case NCP_IOC_SIGN_WANTED:
-		if (file_permission(filp, MAY_READ) != 0
-		    && uid != server->m.mounted_uid)
-			return -EACCES;
-		
-                if (put_user(server->sign_wanted, (int __user *)argp))
-			return -EFAULT;
-                return 0;
+		{
+			int state;
+
+			ncp_lock_server(server);	
+			state = server->sign_wanted;
+			ncp_unlock_server(server);
+			if (put_user(state, (int __user *)argp))
+				return -EFAULT;
+			return 0;
+		}
 
 	case NCP_IOC_SET_SIGN_WANTED:
 		{
 			int newstate;
 
-			if (file_permission(filp, MAY_WRITE) != 0
-			    && uid != server->m.mounted_uid)
-				return -EACCES;
-
 			/* get only low 8 bits... */
 			if (get_user(newstate, (unsigned char __user *)argp))
 				return -EFAULT;
+			result = 0;
+			ncp_lock_server(server);
 			if (server->sign_active) {
 				/* cannot turn signatures OFF when active */
-				if (!newstate) return -EINVAL;
+				if (!newstate)
+					result = -EINVAL;
 			} else {
 				server->sign_wanted = newstate != 0;
 			}
-			return 0;
+			ncp_unlock_server(server);
+			return result;
 		}
 
 #endif /* CONFIG_NCPFS_PACKET_SIGNING */
 
 #ifdef CONFIG_NCPFS_IOCTL_LOCKING
 	case NCP_IOC_LOCKUNLOCK:
-		if (file_permission(filp, MAY_WRITE) != 0
-		    && uid != server->m.mounted_uid)
-			return -EACCES;
-
 		{
 			struct ncp_lock_ioctl	 rqdata;
 
@@ -541,9 +544,6 @@ static long __ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			{
 				return result;
 			}
-			result = -EIO;
-			if (!ncp_conn_valid(server))
-				goto outrel;
 			result = -EISDIR;
 			if (!S_ISREG(inode->i_mode))
 				goto outrel;
@@ -581,60 +581,62 @@ outrel:
 
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_GETOBJECTNAME_32:
-		if (uid != server->m.mounted_uid)
-			return -EACCES;
 		{
 			struct compat_ncp_objectname_ioctl user;
 			size_t outl;
 
 			if (copy_from_user(&user, argp, sizeof(user)))
 				return -EFAULT;
+			down_read(&server->auth_rwsem);
 			user.auth_type = server->auth.auth_type;
 			outl = user.object_name_len;
 			user.object_name_len = server->auth.object_name_len;
 			if (outl > user.object_name_len)
 				outl = user.object_name_len;
+			result = 0;
 			if (outl) {
 				if (copy_to_user(compat_ptr(user.object_name),
 						 server->auth.object_name,
-						 outl)) return -EFAULT;
+						 outl))
+					result = -EFAULT;
 			}
-			if (copy_to_user(argp, &user, sizeof(user)))
-				return -EFAULT;
-			return 0;
+			up_read(&server->auth_rwsem);
+			if (!result && copy_to_user(argp, &user, sizeof(user)))
+				result = -EFAULT;
+			return result;
 		}
 #endif
 
 	case NCP_IOC_GETOBJECTNAME:
-		if (uid != server->m.mounted_uid)
-			return -EACCES;
 		{
 			struct ncp_objectname_ioctl user;
 			size_t outl;
 
 			if (copy_from_user(&user, argp, sizeof(user)))
 				return -EFAULT;
+			down_read(&server->auth_rwsem);
 			user.auth_type = server->auth.auth_type;
 			outl = user.object_name_len;
 			user.object_name_len = server->auth.object_name_len;
 			if (outl > user.object_name_len)
 				outl = user.object_name_len;
+			result = 0;
 			if (outl) {
 				if (copy_to_user(user.object_name,
 						 server->auth.object_name,
-						 outl)) return -EFAULT;
+						 outl))
+					result = -EFAULT;
 			}
-			if (copy_to_user(argp, &user, sizeof(user)))
-				return -EFAULT;
-			return 0;
+			up_read(&server->auth_rwsem);
+			if (!result && copy_to_user(argp, &user, sizeof(user)))
+				result = -EFAULT;
+			return result;
 		}
 
 #ifdef CONFIG_COMPAT
 	case NCP_IOC_SETOBJECTNAME_32:
 #endif
 	case NCP_IOC_SETOBJECTNAME:
-		if (uid != server->m.mounted_uid)
-			return -EACCES;
 		{
 			struct ncp_objectname_ioctl user;
 			void* newname;
@@ -666,9 +668,7 @@ outrel:
 			} else {
 				newname = NULL;
 			}
-			/* enter critical section */
-			/* maybe that kfree can sleep so do that this way */
-			/* it is at least more SMP friendly (in future...) */
+			down_write(&server->auth_rwsem);
 			oldname = server->auth.object_name;
 			oldnamelen = server->auth.object_name_len;
 			oldprivate = server->priv.data;
@@ -678,7 +678,7 @@ outrel:
 			server->auth.object_name = newname;
 			server->priv.len = 0;
 			server->priv.data = NULL;
-			/* leave critical section */
+			up_write(&server->auth_rwsem);
 			kfree(oldprivate);
 			kfree(oldname);
 			return 0;
@@ -688,8 +688,6 @@ outrel:
 	case NCP_IOC_GETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_GETPRIVATEDATA:
-		if (uid != server->m.mounted_uid)
-			return -EACCES;
 		{
 			struct ncp_privatedata_ioctl user;
 			size_t outl;
@@ -706,14 +704,20 @@ outrel:
 			if (copy_from_user(&user, argp, sizeof(user)))
 				return -EFAULT;
 
+			down_read(&server->auth_rwsem);
 			outl = user.len;
 			user.len = server->priv.len;
 			if (outl > user.len) outl = user.len;
+			result = 0;
 			if (outl) {
 				if (copy_to_user(user.data,
 						 server->priv.data,
-						 outl)) return -EFAULT;
+						 outl))
+					result = -EFAULT;
 			}
+			up_read(&server->auth_rwsem);
+			if (result)
+				return result;
 #ifdef CONFIG_COMPAT
 			if (cmd == NCP_IOC_GETPRIVATEDATA_32) {
 				struct compat_ncp_privatedata_ioctl user32;
@@ -733,8 +737,6 @@ outrel:
 	case NCP_IOC_SETPRIVATEDATA_32:
 #endif
 	case NCP_IOC_SETPRIVATEDATA:
-		if (uid != server->m.mounted_uid)
-			return -EACCES;
 		{
 			struct ncp_privatedata_ioctl user;
 			void* new;
@@ -762,12 +764,12 @@ outrel:
 			} else {
 				new = NULL;
 			}
-			/* enter critical section */
+			down_write(&server->auth_rwsem);
 			old = server->priv.data;
 			oldlen = server->priv.len;
 			server->priv.len = user.len;
 			server->priv.data = new;
-			/* leave critical section */
+			up_write(&server->auth_rwsem);
 			kfree(old);
 			return 0;
 		}
@@ -782,10 +784,6 @@ outrel:
 #endif /* CONFIG_NCPFS_NLS */
 
 	case NCP_IOC_SETDENTRYTTL:
-		if (file_permission(filp, MAY_WRITE) != 0 &&
-		    uid != server->m.mounted_uid)
-			return -EACCES;
-
 		{
 			u_int32_t user;
 
@@ -795,13 +793,13 @@ outrel:
 			if (user > 20000)
 				return -EINVAL;
 			user = (user * HZ) / 1000;
-			server->dentry_ttl = user;
+			atomic_set(&server->dentry_ttl, user);
 			return 0;
 		}
 		
 	case NCP_IOC_GETDENTRYTTL:
 		{
-			u_int32_t user = (server->dentry_ttl * 1000) / HZ;
+			u_int32_t user = (atomic_read(&server->dentry_ttl) * 1000) / HZ;
 			if (copy_to_user(argp, &user, sizeof(user)))
 				return -EFAULT;
 			return 0;
@@ -811,59 +809,103 @@ outrel:
 	return -EINVAL;
 }
 
-static int ncp_ioctl_need_write(unsigned int cmd)
+long ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct ncp_server *server = NCP_SERVER(inode);
+	uid_t uid = current_uid();
+	int need_drop_write = 0;
+	long ret;
+
 	switch (cmd) {
-	case NCP_IOC_GET_FS_INFO:
-	case NCP_IOC_GET_FS_INFO_V2:
-	case NCP_IOC_NCPREQUEST:
-	case NCP_IOC_SETDENTRYTTL:
-	case NCP_IOC_SIGN_INIT:
-	case NCP_IOC_LOCKUNLOCK:
-	case NCP_IOC_SET_SIGN_WANTED:
-		return 1;
-	case NCP_IOC_GETOBJECTNAME:
-	case NCP_IOC_SETOBJECTNAME:
-	case NCP_IOC_GETPRIVATEDATA:
-	case NCP_IOC_SETPRIVATEDATA:
 	case NCP_IOC_SETCHARSETS:
-	case NCP_IOC_GETCHARSETS:
 	case NCP_IOC_CONN_LOGGED_IN:
-	case NCP_IOC_GETDENTRYTTL:
-	case NCP_IOC_GETMOUNTUID2:
-	case NCP_IOC_SIGN_WANTED:
-	case NCP_IOC_GETROOT:
 	case NCP_IOC_SETROOT:
-		return 0;
-	default:
-		/* unknown IOCTL command, assume write */
-		return 1;
+		if (!capable(CAP_SYS_ADMIN)) {
+			ret = -EACCES;
+			goto out;
+		}
+		break;
 	}
-}
-
-long ncp_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
-{
-	long ret;
-
-	lock_kernel();
-	if (ncp_ioctl_need_write(cmd)) {
+	if (server->m.mounted_uid != uid) {
+		switch (cmd) {
 		/*
-		 * inside the ioctl(), any failures which
-		 * are because of file_permission() are
-		 * -EACCESS, so it seems consistent to keep
-		 *  that here.
-		 */
-		if (mnt_want_write(filp->f_path.mnt)) {
+		 * Only mount owner can issue these ioctls.  Information
+		 * necessary to authenticate to other NDS servers are
+		 * stored here.
+		 */
+		case NCP_IOC_GETOBJECTNAME:
+		case NCP_IOC_SETOBJECTNAME:
+		case NCP_IOC_GETPRIVATEDATA:
+		case NCP_IOC_SETPRIVATEDATA:
+#ifdef CONFIG_COMPAT
+		case NCP_IOC_GETOBJECTNAME_32:
+		case NCP_IOC_SETOBJECTNAME_32:
+		case NCP_IOC_GETPRIVATEDATA_32:
+		case NCP_IOC_SETPRIVATEDATA_32:
+#endif
 			ret = -EACCES;
 			goto out;
+		/*
+		 * These require write access on the inode if user id
+		 * does not match.  Note that they do not write to the
+		 * file...  But old code did mnt_want_write, so I keep
+		 * it as is.  Of course not for mountpoint owner, as
+		 * that breaks read-only mounts altogether as ncpmount
+		 * needs working NCP_IOC_NCPREQUEST and
+		 * NCP_IOC_GET_FS_INFO.  Some of these codes (setdentryttl,
+		 * signinit, setsignwanted) should be probably restricted
+		 * to owner only, or even more to CAP_SYS_ADMIN).
+		 */
+		case NCP_IOC_GET_FS_INFO:
+		case NCP_IOC_GET_FS_INFO_V2:
+		case NCP_IOC_NCPREQUEST:
+		case NCP_IOC_SETDENTRYTTL:
+		case NCP_IOC_SIGN_INIT:
+		case NCP_IOC_LOCKUNLOCK:
+		case NCP_IOC_SET_SIGN_WANTED:
+#ifdef CONFIG_COMPAT
+		case NCP_IOC_GET_FS_INFO_V2_32:
+		case NCP_IOC_NCPREQUEST_32:
+#endif
+			ret = mnt_want_write_file(filp);
+			if (ret)
+				goto out;
+			need_drop_write = 1;
+			ret = inode_permission(inode, MAY_WRITE);
+			if (ret)
+				goto outDropWrite;
+			break;
+		/*
+		 * Read access required.
+		 */
+		case NCP_IOC_GETMOUNTUID16:
+		case NCP_IOC_GETMOUNTUID32:
+		case NCP_IOC_GETMOUNTUID64:
+		case NCP_IOC_GETROOT:
+		case NCP_IOC_SIGN_WANTED:
+			ret = inode_permission(inode, MAY_READ);
+			if (ret)
+				goto out;
+			break;
+		/*
+		 * Anybody can read these.
+		 */
+		case NCP_IOC_GETCHARSETS:
+		case NCP_IOC_GETDENTRYTTL:
+		default:
+		/* Three codes below are protected by CAP_SYS_ADMIN above. */
+		case NCP_IOC_SETCHARSETS:
+		case NCP_IOC_CONN_LOGGED_IN:
+		case NCP_IOC_SETROOT:
+			break;
 		}
 	}
-	ret = __ncp_ioctl(filp, cmd, arg);
-	if (ncp_ioctl_need_write(cmd))
+	ret = __ncp_ioctl(inode, cmd, arg);
+outDropWrite:
+	if (need_drop_write)
 		mnt_drop_write(filp->f_path.mnt);
-
 out:
-	unlock_kernel();
 	return ret;
 }
 
@@ -872,10 +914,8 @@ long ncp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 
-	lock_kernel();
 	arg = (unsigned long) compat_ptr(arg);
 	ret = ncp_ioctl(file, cmd, arg);
-	unlock_kernel();
 	return ret;
 }
 #endif
diff --git a/fs/ncpfs/ncplib_kernel.c b/fs/ncpfs/ncplib_kernel.c
index 0ec6237..60981bc 100644
--- a/fs/ncpfs/ncplib_kernel.c
+++ b/fs/ncpfs/ncplib_kernel.c
@@ -107,17 +107,17 @@ ncp_reply_data(struct ncp_server *server, int offset)
 	return &(server->packet[sizeof(struct ncp_reply_header) + offset]);
 }
 
-static inline u8 BVAL(void *data)
+static inline u8 BVAL(const void *data)
 {
-	return *(u8 *)data;
+	return *(const u8 *)data;
 }
 
 static u8 ncp_reply_byte(struct ncp_server *server, int offset)
 {
-	return *(u8 *)ncp_reply_data(server, offset);
+	return *(const u8 *)ncp_reply_data(server, offset);
 }
 
-static inline u16 WVAL_LH(void *data)
+static inline u16 WVAL_LH(const void *data)
 {
 	return get_unaligned_le16(data);
 }
@@ -134,7 +134,7 @@ ncp_reply_be16(struct ncp_server *server, int offset)
 	return get_unaligned_be16(ncp_reply_data(server, offset));
 }
 
-static inline u32 DVAL_LH(void *data)
+static inline u32 DVAL_LH(const void *data)
 {
 	return get_unaligned_le32(data);
 }
@@ -349,9 +349,9 @@ int ncp_dirhandle_free(struct ncp_server* server, __u8 dirhandle) {
 	return result;
 }
 
-void ncp_extract_file_info(void *structure, struct nw_info_struct *target)
+void ncp_extract_file_info(const void *structure, struct nw_info_struct *target)
 {
-	__u8 *name_len;
+	const __u8 *name_len;
 	const int info_struct_size = offsetof(struct nw_info_struct, nameLen);
 
 	memcpy(target, structure, info_struct_size);
@@ -364,7 +364,7 @@ void ncp_extract_file_info(void *structure, struct nw_info_struct *target)
 }
 
 #ifdef CONFIG_NCPFS_NFS_NS
-static inline void ncp_extract_nfs_info(unsigned char *structure,
+static inline void ncp_extract_nfs_info(const unsigned char *structure,
 				 struct nw_nfs_info *target)
 {
 	target->mode = DVAL_LH(structure);
@@ -417,7 +417,7 @@ int ncp_obtain_nfs_info(struct ncp_server *server,
  * Returns information for a (one-component) name relative to
  * the specified directory.
  */
-int ncp_obtain_info(struct ncp_server *server, struct inode *dir, char *path,
+int ncp_obtain_info(struct ncp_server *server, struct inode *dir, const char *path,
 			struct nw_info_struct *target)
 {
 	__u8  volnum = NCP_FINFO(dir)->volNumber;
@@ -452,16 +452,16 @@ out:
 #ifdef CONFIG_NCPFS_NFS_NS
 static int
 ncp_obtain_DOS_dir_base(struct ncp_server *server,
-		__u8 volnum, __le32 dirent,
-		char *path, /* At most 1 component */
+		__u8 ns, __u8 volnum, __le32 dirent,
+		const char *path, /* At most 1 component */
 		__le32 *DOS_dir_base)
 {
 	int result;
 
 	ncp_init_request(server);
 	ncp_add_byte(server, 6); /* subfunction */
-	ncp_add_byte(server, server->name_space[volnum]);
-	ncp_add_byte(server, server->name_space[volnum]);
+	ncp_add_byte(server, ns);
+	ncp_add_byte(server, ns);
 	ncp_add_word(server, cpu_to_le16(0x8006)); /* get all */
 	ncp_add_dword(server, RIM_DIRECTORY);
 	ncp_add_handle_path(server, volnum, dirent, 1, path);
@@ -523,10 +523,27 @@ ncp_get_known_namespace(struct ncp_server *server, __u8 volume)
 #endif	/* defined(CONFIG_NCPFS_OS2_NS) || defined(CONFIG_NCPFS_NFS_NS) */
 }
 
+int
+ncp_update_known_namespace(struct ncp_server *server, __u8 volume, int *ret_ns)
+{
+	int ns = ncp_get_known_namespace(server, volume);
+
+	if (ret_ns)
+		*ret_ns = ns;
+
+	DPRINTK("lookup_vol: namespace[%d] = %d\n",
+		volume, server->name_space[volume]);
+
+	if (server->name_space[volume] == ns)
+		return 0;
+	server->name_space[volume] = ns;
+	return 1;
+}
+
 static int
 ncp_ObtainSpecificDirBase(struct ncp_server *server,
 		__u8 nsSrc, __u8 nsDst, __u8 vol_num, __le32 dir_base,
-		char *path, /* At most 1 component */
+		const char *path, /* At most 1 component */
 		__le32 *dirEntNum, __le32 *DosDirNum)
 {
 	int result;
@@ -560,14 +577,13 @@ ncp_mount_subdir(struct ncp_server *server,
 {
 	int dstNS;
 	int result;
-	
-	dstNS = ncp_get_known_namespace(server, volNumber);
+
+	ncp_update_known_namespace(server, volNumber, &dstNS);	
 	if ((result = ncp_ObtainSpecificDirBase(server, srcNS, dstNS, volNumber, 
 				      dirEntNum, NULL, newDirEnt, newDosEnt)) != 0)
 	{
 		return result;
 	}
-	server->name_space[volNumber] = dstNS;
 	*volume = volNumber;
 	server->m.mounted_vol[1] = 0;
 	server->m.mounted_vol[0] = 'X';
@@ -575,11 +591,10 @@ ncp_mount_subdir(struct ncp_server *server,
 }
 
 int 
-ncp_get_volume_root(struct ncp_server *server, const char *volname,
-		    __u32* volume, __le32* dirent, __le32* dosdirent)
+ncp_get_volume_root(struct ncp_server *server,
+		    const char *volname, __u32* volume, __le32* dirent, __le32* dosdirent)
 {
 	int result;
-	__u8 volnum;
 
 	DPRINTK("ncp_get_volume_root: looking up vol %s\n", volname);
 
@@ -601,21 +616,14 @@ ncp_get_volume_root(struct ncp_server *server, const char *volname,
 		return result;
 	}
 	*dirent = *dosdirent = ncp_reply_dword(server, 4);
-	volnum = ncp_reply_byte(server, 8);
+	*volume = ncp_reply_byte(server, 8);
 	ncp_unlock_server(server);
-	*volume = volnum;
-
-	server->name_space[volnum] = ncp_get_known_namespace(server, volnum);
-
-	DPRINTK("lookup_vol: namespace[%d] = %d\n",
-		volnum, server->name_space[volnum]);
-
 	return 0;
 }
 
 int
-ncp_lookup_volume(struct ncp_server *server, const char *volname,
-		  struct nw_info_struct *target)
+ncp_lookup_volume(struct ncp_server *server,
+		  const char *volname, struct nw_info_struct *target)
 {
 	int result;
 
@@ -625,6 +633,7 @@ ncp_lookup_volume(struct ncp_server *server, const char *volname,
 	if (result) {
 		return result;
 	}
+	ncp_update_known_namespace(server, target->volNumber, NULL);
 	target->nameLen = strlen(volname);
 	memcpy(target->entryName, volname, target->nameLen+1);
 	target->attributes = aDIR;
@@ -676,8 +685,8 @@ int ncp_modify_nfs_info(struct ncp_server *server, __u8 volnum, __le32 dirent,
 {
 	int result = 0;
 
+	ncp_init_request(server);
 	if (server->name_space[volnum] == NW_NS_NFS) {
-		ncp_init_request(server);
 		ncp_add_byte(server, 25);	/* subfunction */
 		ncp_add_byte(server, server->name_space[volnum]);
 		ncp_add_byte(server, NW_NS_NFS);
@@ -690,8 +699,8 @@ int ncp_modify_nfs_info(struct ncp_server *server, __u8 volnum, __le32 dirent,
 		ncp_add_dword_lh(server, 1);	/* nlinks */
 		ncp_add_dword_lh(server, rdev);
 		result = ncp_request(server, 87);
-		ncp_unlock_server(server);
 	}
+	ncp_unlock_server(server);
 	return result;
 }
 #endif
@@ -734,23 +743,25 @@ ncp_del_file_or_subdir2(struct ncp_server *server,
 
 int
 ncp_del_file_or_subdir(struct ncp_server *server,
-		       struct inode *dir, char *name)
+		       struct inode *dir, const char *name)
 {
 	__u8  volnum = NCP_FINFO(dir)->volNumber;
 	__le32 dirent = NCP_FINFO(dir)->dirEntNum;
+	int name_space;
 
+	name_space = server->name_space[volnum];
 #ifdef CONFIG_NCPFS_NFS_NS
-	if (server->name_space[volnum]==NW_NS_NFS)
+	if (name_space == NW_NS_NFS)
  	{
  		int result;
  
- 		result=ncp_obtain_DOS_dir_base(server, volnum, dirent, name, &dirent);
+		result=ncp_obtain_DOS_dir_base(server, name_space, volnum, dirent, name, &dirent);
  		if (result) return result;
- 		return ncp_DeleteNSEntry(server, 1, volnum, dirent, NULL, NW_NS_DOS, cpu_to_le16(0x8006));
+		name = NULL;
+		name_space = NW_NS_DOS;
  	}
- 	else
 #endif	/* CONFIG_NCPFS_NFS_NS */
- 		return ncp_DeleteNSEntry(server, 1, volnum, dirent, name, server->name_space[volnum], cpu_to_le16(0x8006));
+	return ncp_DeleteNSEntry(server, 1, volnum, dirent, name, name_space, cpu_to_le16(0x8006));
 }
 
 static inline void ConvertToNWfromDWORD(__u16 v0, __u16 v1, __u8 ret[6])
@@ -765,7 +776,7 @@ static inline void ConvertToNWfromDWORD(__u16 v0, __u16 v1, __u8 ret[6])
 /* If both dir and name are NULL, then in target there's already a
    looked-up entry that wants to be opened. */
 int ncp_open_create_file_or_subdir(struct ncp_server *server,
-				   struct inode *dir, char *name,
+				   struct inode *dir, const char *name,
 				   int open_create_mode,
 				   __le32 create_attributes,
 				   __le16 desired_acc_rights,
@@ -890,8 +901,8 @@ int ncp_search_for_fileset(struct ncp_server *server,
 
 static int
 ncp_RenameNSEntry(struct ncp_server *server,
-		  struct inode *old_dir, char *old_name, __le16 old_type,
-		  struct inode *new_dir, char *new_name)
+		  struct inode *old_dir, const char *old_name, __le16 old_type,
+		  struct inode *new_dir, const char *new_name)
 {
 	int result = -EINVAL;
 
@@ -929,8 +940,8 @@ out:
 }
 
 int ncp_ren_or_mov_file_or_subdir(struct ncp_server *server,
-				struct inode *old_dir, char *old_name,
-				struct inode *new_dir, char *new_name)
+				struct inode *old_dir, const char *old_name,
+				struct inode *new_dir, const char *new_name)
 {
         int result;
         __le16 old_type = cpu_to_le16(0x06);
@@ -958,7 +969,7 @@ int
 ncp_read_kernel(struct ncp_server *server, const char *file_id,
 	     __u32 offset, __u16 to_read, char *target, int *bytes_read)
 {
-	char *source;
+	const char *source;
 	int result;
 
 	ncp_init_request(server);
diff --git a/fs/ncpfs/ncplib_kernel.h b/fs/ncpfs/ncplib_kernel.h
index 2441d1a..3c57eca 100644
--- a/fs/ncpfs/ncplib_kernel.h
+++ b/fs/ncpfs/ncplib_kernel.h
@@ -65,10 +65,11 @@ static inline void ncp_inode_close(struct inode *inode) {
 	atomic_dec(&NCP_FINFO(inode)->opened);
 }
 
-void ncp_extract_file_info(void* src, struct nw_info_struct* target);
-int ncp_obtain_info(struct ncp_server *server, struct inode *, char *,
+void ncp_extract_file_info(const void* src, struct nw_info_struct* target);
+int ncp_obtain_info(struct ncp_server *server, struct inode *, const char *,
 		struct nw_info_struct *target);
 int ncp_obtain_nfs_info(struct ncp_server *server, struct nw_info_struct *target);
+int ncp_update_known_namespace(struct ncp_server *server, __u8 volume, int *ret_ns);
 int ncp_get_volume_root(struct ncp_server *server, const char *volname,
 			__u32 *volume, __le32 *dirent, __le32 *dosdirent);
 int ncp_lookup_volume(struct ncp_server *, const char *, struct nw_info_struct *);
@@ -80,8 +81,8 @@ int ncp_modify_nfs_info(struct ncp_server *, __u8 volnum, __le32 dirent,
 			__u32 mode, __u32 rdev);
 
 int ncp_del_file_or_subdir2(struct ncp_server *, struct dentry*);
-int ncp_del_file_or_subdir(struct ncp_server *, struct inode *, char *);
-int ncp_open_create_file_or_subdir(struct ncp_server *, struct inode *, char *,
+int ncp_del_file_or_subdir(struct ncp_server *, struct inode *, const char *);
+int ncp_open_create_file_or_subdir(struct ncp_server *, struct inode *, const char *,
 				int, __le32, __le16, struct ncp_entry_info *);
 
 int ncp_initialize_search(struct ncp_server *, struct inode *,
@@ -93,7 +94,7 @@ int ncp_search_for_fileset(struct ncp_server *server,
 			   char** rbuf, size_t* rsize);
 
 int ncp_ren_or_mov_file_or_subdir(struct ncp_server *server,
-			      struct inode *, char *, struct inode *, char *);
+			      struct inode *, const char *, struct inode *, const char *);
 
 
 int
@@ -170,13 +171,13 @@ static inline int ncp_strnicmp(struct nls_table *t, const unsigned char *s1,
 #endif /* CONFIG_NCPFS_NLS */
 
 #define NCP_GET_AGE(dentry)	(jiffies - (dentry)->d_time)
-#define NCP_MAX_AGE(server)	((server)->dentry_ttl)
+#define NCP_MAX_AGE(server)	atomic_read(&(server)->dentry_ttl)
 #define NCP_TEST_AGE(server,dentry)	(NCP_GET_AGE(dentry) < NCP_MAX_AGE(server))
 
 static inline void
 ncp_age_dentry(struct ncp_server* server, struct dentry* dentry)
 {
-	dentry->d_time = jiffies - server->dentry_ttl;
+	dentry->d_time = jiffies - NCP_MAX_AGE(server);
 }
 
 static inline void
diff --git a/fs/ncpfs/ncpsign_kernel.c b/fs/ncpfs/ncpsign_kernel.c
index 7c0b5c2..d8b2d7e 100644
--- a/fs/ncpfs/ncpsign_kernel.c
+++ b/fs/ncpfs/ncpsign_kernel.c
@@ -15,21 +15,21 @@
 
 /* i386: 32-bit, little endian, handles mis-alignment */
 #ifdef __i386__
-#define GET_LE32(p) (*(int *)(p))
+#define GET_LE32(p) (*(const int *)(p))
 #define PUT_LE32(p,v) { *(int *)(p)=v; }
 #else
 /* from include/ncplib.h */
-#define BVAL(buf,pos) (((__u8 *)(buf))[pos])
+#define BVAL(buf,pos) (((const __u8 *)(buf))[pos])
 #define PVAL(buf,pos) ((unsigned)BVAL(buf,pos))
-#define BSET(buf,pos,val) (BVAL(buf,pos) = (val))
+#define BSET(buf,pos,val) (((__u8 *)(buf))[pos] = (val))
 
 static inline __u16
-WVAL_LH(__u8 * buf, int pos)
+WVAL_LH(const __u8 * buf, int pos)
 {
 	return PVAL(buf, pos) | PVAL(buf, pos + 1) << 8;
 }
 static inline __u32
-DVAL_LH(__u8 * buf, int pos)
+DVAL_LH(const __u8 * buf, int pos)
 {
 	return WVAL_LH(buf, pos) | WVAL_LH(buf, pos + 2) << 16;
 }
diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index c7ff6c7..668bd26 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -746,7 +746,6 @@ static int ncp_do_request(struct ncp_server *server, int size,
 		return -EIO;
 	}
 	if (!ncp_conn_valid(server)) {
-		printk(KERN_ERR "ncpfs: Connection invalid!\n");
 		return -EIO;
 	}
 	{
diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
index 4522aed..ef66306 100644
--- a/include/linux/ncp_fs.h
+++ b/include/linux/ncp_fs.h
@@ -241,34 +241,6 @@ int ncp_mmap(struct file *, struct vm_area_struct *);
 /* linux/fs/ncpfs/ncplib_kernel.c */
 int ncp_make_closed(struct inode *);
 
-#define ncp_namespace(i)	(NCP_SERVER(i)->name_space[NCP_FINFO(i)->volNumber])
-
-static inline int ncp_preserve_entry_case(struct inode *i, __u32 nscreator)
-{
-#ifdef CONFIG_NCPFS_SMALLDOS
-	int ns = ncp_namespace(i);
-
-	if ((ns == NW_NS_DOS)
-#ifdef CONFIG_NCPFS_OS2_NS
-		|| ((ns == NW_NS_OS2) && (nscreator == NW_NS_DOS))
-#endif /* CONFIG_NCPFS_OS2_NS */
-				)
-		return 0;
-#endif /* CONFIG_NCPFS_SMALLDOS */
-	return 1;
-}
-
-#define ncp_preserve_case(i)	(ncp_namespace(i) != NW_NS_DOS)
-
-static inline int ncp_case_sensitive(struct inode *i)
-{
-#ifdef CONFIG_NCPFS_NFS_NS
-	return ncp_namespace(i) == NW_NS_NFS;
-#else
-	return 0;
-#endif	/* CONFIG_NCPFS_NFS_NS */
-} 
-
 #endif				/* __KERNEL__ */
 
 #endif				/* _LINUX_NCP_FS_H */
diff --git a/include/linux/ncp_fs_sb.h b/include/linux/ncp_fs_sb.h
index 8da05bc..d64b0e8 100644
--- a/include/linux/ncp_fs_sb.h
+++ b/include/linux/ncp_fs_sb.h
@@ -62,6 +62,7 @@ struct ncp_server {
 	int ncp_reply_size;
 
 	int root_setuped;
+	struct mutex root_setup_lock;
 
 	/* info for packet signing */
 	int sign_wanted;	/* 1=Server needs signed packets */
@@ -81,13 +82,14 @@ struct ncp_server {
 		size_t	len;
 		void*	data;
 	} priv;
+	struct rw_semaphore auth_rwsem;
 
 	/* nls info: codepage for volume and charset for I/O */
 	struct nls_table *nls_vol;
 	struct nls_table *nls_io;
 
 	/* maximum age in jiffies */
-	int dentry_ttl;
+	atomic_t dentry_ttl;
 
 	/* miscellaneous */
 	unsigned int flags;
