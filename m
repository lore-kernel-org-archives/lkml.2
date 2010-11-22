Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0KVAcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:32:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48720 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab0KVAb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:31:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=e3x0ZymBylY0+lfvrrB+cL5TMNcPZKN/shEQWB3giJTawQI1eSHW4Et2DdsFRR/RMC
         JG+cyp5iYkKj+NacAbaGXOMCBbL/VyvTnrfROg3s/55bPmV9gr+KLrR3qPXrtQyrJlnG
         I5sVQ3sKq9Uz7oCqw8VUGKGC34jx18xKEe/A4=
Subject: [PATCH 2/4] VFS: Tell fsnotify what part of the file might have
 changed
To: Eric Paris <eparis@redhat.com>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Scott Hassan <hassan@dotfunk.com>, Jan Kara <jack@suse.cz>,
        agruen@linbit.com, linux-kernel@vger.kernel.org, stefan@buettcher.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Date: Mon, 22 Nov 2010 00:33:27 +0000
Message-ID: <20101122003311.13674.50418.stgit@zaytsev.su>
In-Reply-To: <20101122002747.13674.69384.stgit@zaytsev.su>
References: <20101122002747.13674.69384.stgit@zaytsev.su>
User-Agent: StGit/0.15-97-g9680
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 fs/compat.c              |    2 +
 fs/nfsd/vfs.c            |    2 +
 fs/open.c                |    4 +++
 fs/read_write.c          |    4 +--
 include/linux/fs.h       |   14 +++++++++
 include/linux/fsnotify.h |   68 ++++++++++++++++++++++++++++------------------
 6 files changed, 64 insertions(+), 30 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index c580c32..66eb689 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1171,7 +1171,7 @@ out:
 		if (type == READ)
 			fsnotify_access(file);
 		else
-			fsnotify_modify(file);
+			fsnotify_modify(file, pos - ret, ret);
 	}
 	return ret;
 }
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 184938f..d781014 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1035,7 +1035,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 		goto out_nfserr;
 	*cnt = host_err;
 	nfsdstats.io_write += host_err;
-	fsnotify_modify(file);
+	fsnotify_modify(file, offset - host_err, host_err);
 
 	/* clear setuid/setgid flag after write */
 	if (inode->i_mode & (S_ISUID | S_ISGID))
diff --git a/fs/open.c b/fs/open.c
index 4197b9e..17b0d79 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -675,6 +675,10 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	f->f_path.mnt = mnt;
 	f->f_pos = 0;
 	f->f_op = fops_get(inode->i_fop);
+#ifdef CONFIG_FSNOTIFY
+	f->f_whatchanged.start = -1;
+	f->f_whatchanged.end = 0;
+#endif
 	file_sb_list_add(f, inode->i_sb);
 
 	error = security_dentry_open(f, cred);
diff --git a/fs/read_write.c b/fs/read_write.c
index 5d431ba..86c60c2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -383,7 +383,7 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 		else
 			ret = do_sync_write(file, buf, count, pos);
 		if (ret > 0) {
-			fsnotify_modify(file);
+			fsnotify_modify(file, (*pos) - ret, ret);
 			add_wchar(current, ret);
 		}
 		inc_syscw(current);
@@ -699,7 +699,7 @@ out:
 		if (type == READ)
 			fsnotify_access(file);
 		else
-			fsnotify_modify(file);
+			fsnotify_modify(file, (*pos) - ret, ret);
 	}
 	return ret;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index eedc00b..3337975 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -922,6 +922,16 @@ static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
 		index <  ra->start + ra->size);
 }
 
+/* 
+ * fsnotify wants to know, what might have changed during the file's lifetime.
+ * We maintain a single range, so it might include non-modified gaps, but this
+ * should work good enough for the majoroty of use cases, and the rest
+ * shold listen to individual 'modify' events. */
+struct fsnotify_range {
+	loff_t start; /* The beginning of the possibly modified area.*/
+	loff_t end; /* The first byte after the area. */
+};
+
 #define FILE_MNT_WRITE_TAKEN	1
 #define FILE_MNT_WRITE_RELEASED	2
 
@@ -965,6 +975,10 @@ struct file {
 #ifdef CONFIG_DEBUG_WRITECOUNT
 	unsigned long f_mnt_write_state;
 #endif
+
+#ifdef CONFIG_FSNOTIFY
+	struct fsnotify_range f_whatchanged;
+#endif
 };
 
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 5c185fa..49e7788 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -26,12 +26,13 @@ static inline void fsnotify_d_instantiate(struct dentry *dentry,
 }
 
 /* Notify this dentry's parent about a child's events. */
-static inline int fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
+static inline int fsnotify_parent(struct path *path, struct dentry *dentry,
+		__u32 mask, struct fsnotify_range *range)
 {
 	if (!dentry)
 		dentry = path->dentry;
 
-	return __fsnotify_parent(path, dentry, mask);
+	return __fsnotify_parent(path, dentry, mask, range);
 }
 
 /* simple call site for access decisions */
@@ -53,11 +54,12 @@ static inline int fsnotify_perm(struct file *file, int mask)
 	else
 		BUG();
 
-	ret = fsnotify_parent(path, NULL, fsnotify_mask);
+	ret = fsnotify_parent(path, NULL, fsnotify_mask, NULL);
 	if (ret)
 		return ret;
 
-	return fsnotify(inode, fsnotify_mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	return fsnotify(inode, fsnotify_mask, path, FSNOTIFY_EVENT_PATH,
+			NULL, 0, NULL);
 }
 
 /*
@@ -78,7 +80,7 @@ static inline void fsnotify_d_move(struct dentry *dentry)
  */
 static inline void fsnotify_link_count(struct inode *inode)
 {
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
 }
 
 /*
@@ -102,14 +104,17 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 		new_dir_mask |= FS_ISDIR;
 	}
 
-	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name, fs_cookie);
-	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name, fs_cookie);
+	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE,
+			old_name, fs_cookie, NULL);
+	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE,
+			new_name, fs_cookie, NULL);
 
 	if (target)
 		fsnotify_link_count(target);
 
 	if (source)
-		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE,
+				NULL, 0, NULL);
 	audit_inode_child(moved, new_dir);
 }
 
@@ -139,7 +144,7 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 	if (isdir)
 		mask |= FS_ISDIR;
 
-	fsnotify_parent(NULL, dentry, mask);
+	fsnotify_parent(NULL, dentry, mask, NULL);
 }
 
 /*
@@ -147,7 +152,7 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
  */
 static inline void fsnotify_inoderemove(struct inode *inode)
 {
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
 	__fsnotify_inode_delete(inode);
 }
 
@@ -158,7 +163,8 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 {
 	audit_inode_child(dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE,
+			dentry->d_name.name, 0, NULL);
 }
 
 /*
@@ -171,7 +177,8 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE,
+			new_dentry->d_name.name, 0, NULL);
 }
 
 /*
@@ -184,7 +191,8 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 
 	audit_inode_child(dentry, inode);
 
-	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
+	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE,
+			dentry->d_name.name, 0, NULL);
 }
 
 /*
@@ -200,26 +208,33 @@ static inline void fsnotify_access(struct file *file)
 		mask |= FS_ISDIR;
 
 	if (!(file->f_mode & FMODE_NONOTIFY)) {
-		fsnotify_parent(path, NULL, mask);
-		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+		fsnotify_parent(path, NULL, mask, NULL);
+		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0, NULL);
 	}
 }
 
+
+
 /*
  * fsnotify_modify - file was modified
  */
-static inline void fsnotify_modify(struct file *file)
+static inline void fsnotify_modify(struct file *file, loff_t original, size_t count) 
 {
 	struct path *path = &file->f_path;
 	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_MODIFY;
+	struct fsnotify_range range = {
+		.start = original,
+		.end = original + count,
+	};
 
+	fsnotify_update_range(&file->f_whatchanged, &range);
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_ISDIR;
 
 	if (!(file->f_mode & FMODE_NONOTIFY)) {
-		fsnotify_parent(path, NULL, mask);
-		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+		fsnotify_parent(path, NULL, mask, &range);
+		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0, &range);
 	}
 }
 
@@ -238,8 +253,8 @@ static inline void fsnotify_open(struct file *file)
 	/* FMODE_NONOTIFY must never be set from user */
 	file->f_mode &= ~FMODE_NONOTIFY;
 
-	fsnotify_parent(path, NULL, mask);
-	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	fsnotify_parent(path, NULL, mask, NULL);
+	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0, NULL);
 }
 
 /*
@@ -256,8 +271,9 @@ static inline void fsnotify_close(struct file *file)
 		mask |= FS_ISDIR;
 
 	if (!(file->f_mode & FMODE_NONOTIFY)) {
-		fsnotify_parent(path, NULL, mask);
-		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+		fsnotify_parent(path, NULL, mask, &file->f_whatchanged);
+		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH,
+				NULL, 0, &file->f_whatchanged);
 	}
 }
 
@@ -272,8 +288,8 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_ISDIR;
 
-	fsnotify_parent(NULL, dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	fsnotify_parent(NULL, dentry, mask, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
 }
 
 /*
@@ -307,8 +323,8 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		if (S_ISDIR(inode->i_mode))
 			mask |= FS_ISDIR;
 
-		fsnotify_parent(NULL, dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+		fsnotify_parent(NULL, dentry, mask, NULL);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
 	}
 }
 

