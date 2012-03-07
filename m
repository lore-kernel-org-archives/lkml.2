Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2CGVaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:30:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43421 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab2CGVW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:22:59 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 03/25] vfs: split __dentry_open()
Date: Wed,  7 Mar 2012 22:22:20 +0100
Message-Id: <1331155362-11132-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Split __dentry_open() into two functions:

  do_dentry_open() - does most of the actual work, doesn't put file on failure
  open_check_o_direct() - after a successful open, checks direct_IO method

This will allow i_op->atomic_open to do just the file initialization and leave
the direct_IO checking to the VFS.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/internal.h |    1 +
 fs/open.c     |   47 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 9962c59..4d69fdd 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -100,6 +100,7 @@ extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
 
 extern long do_handle_open(int mountdirfd,
 			   struct file_handle __user *ufh, int open_flag);
+extern int open_check_o_direct(struct file *f);
 
 /*
  * inode.c
diff --git a/fs/open.c b/fs/open.c
index 77becc0..6acfd2d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -644,10 +644,23 @@ static inline int __get_file_write_access(struct inode *inode,
 	return error;
 }
 
-static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
-					struct file *f,
-					int (*open)(struct inode *, struct file *),
-					const struct cred *cred)
+int open_check_o_direct(struct file *f)
+{
+	/* NB: we're sure to have correct a_ops only after f_op->open */
+	if (f->f_flags & O_DIRECT) {
+		if (!f->f_mapping->a_ops ||
+		    ((!f->f_mapping->a_ops->direct_IO) &&
+		    (!f->f_mapping->a_ops->get_xip_mem))) {
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static struct file *do_dentry_open(struct dentry *dentry, struct vfsmount *mnt,
+				   struct file *f,
+				   int (*open)(struct inode *, struct file *),
+				   const struct cred *cred)
 {
 	static const struct file_operations empty_fops = {};
 	struct inode *inode;
@@ -703,16 +716,6 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 
 	file_ra_state_init(&f->f_ra, f->f_mapping->host->i_mapping);
 
-	/* NB: we're sure to have correct a_ops only after f_op->open */
-	if (f->f_flags & O_DIRECT) {
-		if (!f->f_mapping->a_ops ||
-		    ((!f->f_mapping->a_ops->direct_IO) &&
-		    (!f->f_mapping->a_ops->get_xip_mem))) {
-			fput(f);
-			f = ERR_PTR(-EINVAL);
-		}
-	}
-
 	return f;
 
 cleanup_all:
@@ -740,6 +743,22 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
+static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
+				struct file *f,
+				int (*open)(struct inode *, struct file *),
+				const struct cred *cred)
+{
+	struct file *res = do_dentry_open(dentry, mnt, f, open, cred);
+	if (!IS_ERR(res)) {
+		int error = open_check_o_direct(f);
+		if (error) {
+			fput(res);
+			res = ERR_PTR(error);
+		}
+	}
+	return res;
+}
+
 /**
  * lookup_instantiate_filp - instantiates the open intent filp
  * @nd: pointer to nameidata
-- 
1.7.7

