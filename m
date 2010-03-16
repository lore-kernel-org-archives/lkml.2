Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966545Ab0CPSRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:17:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966497Ab0CPSRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:17:41 -0400
Date: Tue, 16 Mar 2010 14:17:12 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Show data flow for file copyup in unions
Message-ID: <20100316181711.GB24819@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch shows the basic data flow necessary to implement efficient
union mount file copyup (without the actual file copyup code).  I need
input from other VFS people on design, especially since namei.c is
getting some much needed reorganization.  Some background:

In union mounts, a file on the lower, read-only file system layer is
copied up to the top layer when an application attempts to write to
it.  This is in-kernel file copyup.  Some constraints make this
difficult:

1. Don't copyup if the operation would fail (e.g., open(O_WRONLY) on a
file with mode 444).  It's inefficient and a possible security hole to
copy up a file if no write (or maybe even read) can occur anyway.

2. Near-zero added cost for operations on non-union paths in a
CONFIG_UNION_MOUNT kernel.  One or two flag tests is okay, but
grabbing a lock or doing a lookup operation to find out if a file
should be copied up is too expensive.

3. A file should be copied up if the path (mnt + dentry) of its parent
is from a union top layer (MNT_UNION set in mnt->mnt_flags).  We can't
tell if a file can be copied up by looking at its inode, dentry, or
even path, we have to know what its parent path is.

This patch shows the convoluted windy path we must take to obey these
constraints using access(W_OK) as the example.  No file copyup is
actually done, but this shows how the information has to propagate.

Ideas?

-VAL

commit e2ac0614773efe43214e87377d62880b3fbbe3a2
Author: Valerie Aurora <vaurora@redhat.com>
Date:   Mon Mar 15 15:09:12 2010 -0700

    union-mount: Show data flow for in-kernel file copyup
    
    This patch shows what information has to flow where in order to do an
    efficient file copyup by implementing the access() system call with
    the bare minimum of code changes.  In short, we have to propagate the
    information that a file is located on a lower layer of a union from
    the first lookup of the file (user_path_at()) across all permission
    checking to the first point that we actually write to the file.  Note
    that access() doesn't actually write to the file, it simply checks if
    we are permitted to - but this shows the concept.
    
    This patch is for DEMONSTRATION PURPOSES ONLY and NOT FOR INCLUSION.
    It's obviously an ugly hack and not intended as a solution.

diff --git a/fs/namei.c b/fs/namei.c
index e72d990..9a3ea06 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -241,16 +241,12 @@ int generic_permission(struct inode *inode, int mask,
 }
 
 /**
- * inode_permission  -  check for access rights to a given inode
+ * __inode_permission  -  check for access rights to a given inode
  * @inode:	inode to check permission on
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
- *
- * Used to check for read/write/execute permissions on an inode.
- * We use "fsuid" for this, letting us set arbitrary permissions
- * for filesystem access without changing the "normal" uids which
- * are used for other things.
+ * @ignore_rofs: whether to check for a read-only fs (useful for union mounts)
  */
-int inode_permission(struct inode *inode, int mask)
+int __inode_permission(struct inode *inode, int mask, int ignore_rofs)
 {
 	int retval;
 
@@ -258,9 +254,11 @@ int inode_permission(struct inode *inode, int mask)
 		umode_t mode = inode->i_mode;
 
 		/*
-		 * Nobody gets write access to a read-only fs.
+		 * Nobody gets write access to a read-only fs.  Unless
+		 * this is a file on the lower layer of a union, and
+		 * we'll be copying it up if we write to it.
 		 */
-		if (IS_RDONLY(inode) &&
+		if (!ignore_rofs && IS_RDONLY(inode) &&
 		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
 			return -EROFS;
 
@@ -288,6 +286,26 @@ int inode_permission(struct inode *inode, int mask)
 }
 
 /**
+ * inode_permission  -  check for access rights to a given inode
+ * @inode:	inode to check permission on
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Used to check for read/write/execute permissions on an inode.
+ * We use "fsuid" for this, letting us set arbitrary permissions
+ * for filesystem access without changing the "normal" uids which
+ * are used for other things.
+ */
+int inode_permission(struct inode *inode, int mask)
+{
+	return __inode_permission(inode, mask, 0);
+}
+
+int inode_permission_union(struct inode *inode, int mask, int is_lower)
+{
+	return __inode_permission(inode, mask, is_lower);
+}
+
+/**
  * file_permission  -  check for additional access rights to a given file
  * @file:	file to check access rights for
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
@@ -823,6 +841,7 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 			topmost->dentry = lower.dentry;
 			/* mntput() of previous topmost done in link_path_walk() */
 			topmost->mnt = mntget(lower.mnt);
+			nd->um_flags |= UM_LOWER;
 			break;
 		}
 
@@ -1233,6 +1252,7 @@ static int path_init(int dfd, const char *name, unsigned int flags, struct namei
 	struct file *file;
 
 	nd->last_type = LAST_ROOT; /* if there are only slashes... */
+	nd->um_flags = 0;
 	nd->flags = flags;
 	nd->depth = 0;
 	nd->root.mnt = NULL;
@@ -1477,8 +1497,8 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 	return __lookup_hash(&this, base, NULL);
 }
 
-int user_path_at(int dfd, const char __user *name, unsigned flags,
-		 struct path *path)
+int __user_path_at(int dfd, const char __user *name, unsigned flags,
+		   struct path *path, int *is_lower)
 {
 	struct nameidata nd;
 	char *tmp = getname(name);
@@ -1491,10 +1511,24 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
 		putname(tmp);
 		if (!err)
 			*path = nd.path;
+		*is_lower = nd.um_flags & UM_LOWER;
 	}
 	return err;
 }
 
+int user_path_at(int dfd, const char __user *name, unsigned flags,
+		 struct path *path)
+{
+	int dontcare;
+	return __user_path_at(dfd, name, flags, path, &dontcare);
+}
+
+int user_path_at_union(int dfd, const char __user *name, unsigned flags,
+		       struct path *path, int *is_lower)
+{
+	return __user_path_at(dfd, name, flags, path, is_lower);
+}
+
 static int user_path_parent(int dfd, const char __user *path,
 			struct nameidata *nd, char **name)
 {
diff --git a/fs/open.c b/fs/open.c
index e17f544..4b84b75 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -455,6 +455,7 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 	struct cred *override_cred;
 	struct path path;
 	struct inode *inode;
+	int is_lower = 0;
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
@@ -478,7 +479,8 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 
 	old_cred = override_creds(override_cred);
 
-	res = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+	res = user_path_at_union(dfd, filename, LOOKUP_FOLLOW, &path,
+				 &is_lower);
 	if (res)
 		goto out;
 
@@ -494,11 +496,18 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 			goto out_path_release;
 	}
 
-	res = inode_permission(inode, mode | MAY_ACCESS);
+	res = inode_permission_union(inode, mode | MAY_ACCESS, is_lower);
 	/* SuS v2 requires we report a read only fs too */
 	if (res || !(mode & S_IWOTH) || special_file(inode->i_mode))
 		goto out_path_release;
 	/*
+	 * If this file is from a lower layer of a union, ignore a
+	 * read-only file system.  The top layer of a union is always
+	 * read-write.
+	 */
+	if (is_lower)
+		goto out_path_release;
+	/*
 	 * This is a rare case where using __mnt_is_readonly()
 	 * is OK without a mnt_want/drop_write() pair.  Since
 	 * no actual write to the fs is performed here, we do
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4dae882..5cf81b2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2114,6 +2114,7 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
+extern int inode_permission_union(struct inode *, int, int);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 05b441d..d6a7cc7 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -20,6 +20,16 @@ struct nameidata {
 	struct qstr	last;
 	struct path	root;
 	unsigned int	flags;
+/*
+ * Need a way to return whether the last component is in the lower
+ * layer of a union.  Why not use the existing flags variable?
+ * Because that's all input, it's directions for how to do lookup and
+ * we shouldn't mix in output parameters as well.  Why not use
+ * last_type?  Because we'd have to change all tests for (last ==
+ * LAST_NORM) to ((last == LAST_NORM) || (last == LAST_UNION)).
+ * Better ideas?
+ */
+	unsigned int	um_flags;
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
@@ -31,6 +41,13 @@ struct nameidata {
 };
 
 /*
+ * Union mount related flags
+ *
+ * UM_LOWER - looked up path resides on a lower layer of the union
+ */
+#define UM_LOWER		 1
+
+/*
  * Type of the last component on LOOKUP_PARENT
  */
 enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
@@ -58,6 +75,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_RENAME_TARGET	0x0800
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
+extern int user_path_at_union(int, const char __user *, unsigned, struct path *, int *);
 
 #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
 #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)
