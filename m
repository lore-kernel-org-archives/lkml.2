Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0H0TWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:22:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab0H0TWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:22:19 -0400
Date: Fri, 27 Aug 2010 15:21:38 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Neil Brown <neilb@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 2/5] vfs: make i_op->permission take a dentry instead of an inode
Message-ID: <20100827192138.GE26872@shell>
References: <20100826183340.027591901@szeredi.hu> <20100826183501.528625301@szeredi.hu> <1282854242.16993.6.camel@moss-terrapins.epoch.ncsc.mil> <20100827141100.45feae88@notabene> <1282932831.24418.15.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282932831.24418.15.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 02:13:51PM -0400, David P. Quigley wrote:
> On Fri, 2010-08-27 at 14:11 +1000, Neil Brown wrote:
> > On Thu, 26 Aug 2010 16:24:02 -0400
> > "David P. Quigley" <dpquigl@tycho.nsa.gov> wrote:
> > 
> > > I may be missing something but I looked at your patch series and I see
> > > no good reason for this patch at all. You just churned a lot of code for
> > > something that you don't even have a need for in the patch set. Your
> > > only two new callers of this function could just as easily have used the
> > > inode since it isn't doing anything special with the dentry. It actually
> > > pulls the inode out of it and uses it in generic_permission and
> > > security_inode_permission. If you are going to change this you should
> > > also change generic_permission as well. Honestly I'd rather see the
> > > dentry requirement removed from inode operations instead but
> > > unfortunately this isn't possible as I found out with my attempts to
> > > remove the dentry requirement for get/setxattr
> > 
> > 
> > union_permission needs the dentry to get access to d_fsdata, which caches the
> > upperpath and lowerpath which were found at lookup time.
> > 
> > Is that what you missed?
> > 
> 
> You're correct I missed the line where that was being pulled out of the
> dentry. The better question for me would be why do it this way as
> opposed to what the union file systems are doing. If neither UnionFS or
> AUFS are having to make this change so I'd like a much better
> explination for this change. I'm not seeing enough information in the
> form of why he designed the prototype this way to justify a change that
> the other implementations don't seem to need.

For reference, union mounts needs something like this.  The current
patch set creates a inode_permission() variant for use in the VFS in
cases where we may copy up.  The superblock of the target is read-only
and we have to ignore that - if the topmost parent directory is
unioned.

Here's the patch, which I suspect needs to be rewritten:

commit 72a84672ccf2a923bac120e3ac75ac106d36b4ae
Author: Valerie Aurora <vaurora@redhat.com>
Date:   Sat Mar 20 17:34:53 2010 -0700

    VFS: Split inode_permission() and create path_permission()
    
    Split inode_permission() into inode and file-system-dependent parts.
    Create path_permission() to check permission based on the path to the
    inode.  This is for union mounts, in which an inode can be located on
    a read-only lower layer file system but is still writable, since we
    will copy it up to the writable top layer file system.  So in that
    case, we want to ignore MS_RDONLY on the lower layer.  To make this
    decision, we must know the path (vfsmount, dentry) of both the target
    and its parent.
    
    XXX - so ugly!

diff --git a/fs/namei.c b/fs/namei.c
index 1358a89..2b2bf41 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -241,29 +241,20 @@ int generic_permission(struct inode *inode, int mask,
 }
 
 /**
- * inode_permission  -  check for access rights to a given inode
+ * __inode_permission  -  check for access rights to a given inode
  * @inode:	inode to check permission on
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
  * Used to check for read/write/execute permissions on an inode.
- * We use "fsuid" for this, letting us set arbitrary permissions
- * for filesystem access without changing the "normal" uids which
- * are used for other things.
+ *
+ * This does not check for a read-only file system.  You probably want
+ * inode_permission().
  */
-int inode_permission(struct inode *inode, int mask)
+static int __inode_permission(struct inode *inode, int mask)
 {
 	int retval;
 
 	if (mask & MAY_WRITE) {
-		umode_t mode = inode->i_mode;
-
-		/*
-		 * Nobody gets write access to a read-only fs.
-		 */
-		if (IS_RDONLY(inode) &&
-		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
-			return -EROFS;
-
 		/*
 		 * Nobody gets write access to an immutable file.
 		 */
@@ -288,6 +279,79 @@ int inode_permission(struct inode *inode, int mask)
 }
 
 /**
+ * sb_permission  -  check superblock-level permissions
+ * @sb: superblock of inode to check permission on
+ * @mask: right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Separate out file-system wide checks from inode-specific permission
+ * checks.  In particular, union mounts want to check the read-only
+ * status of the top-level file system, not the lower.
+ */
+int sb_permission(struct super_block *sb, struct inode *inode, int mask)
+{
+	if (mask & MAY_WRITE) {
+		umode_t mode = inode->i_mode;
+
+		/*
+		 * Nobody gets write access to a read-only fs.
+		 */
+		if ((sb->s_flags & MS_RDONLY) &&
+		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
+			return -EROFS;
+	}
+	return 0;
+}
+
+/**
+ * inode_permission  -  check for access rights to a given inode
+ * @inode:	inode to check permission on
+ *
+ * Used to check for read/write/execute permissions on an inode.
+ * We use "fsuid" for this, letting us set arbitrary permissions
+ * for filesystem access without changing the "normal" uids which
+ * are used for other things.
+ */
+int inode_permission(struct inode *inode, int mask)
+{
+	int retval;
+
+	retval = sb_permission(inode->i_sb, inode, mask);
+	if (retval)
+		return retval;
+	return __inode_permission(inode, mask);
+}
+
+/**
+ * path_permission - check for inode access rights depending on path
+ * @path: path of inode to check
+ * @parent_path: path of inode's parent
+ * @mask: right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Like inode_permission, but used to check for permission when the
+ * file may potentially be copied up between union layers.
+ */
+
+int path_permission(struct path *path, struct path *parent_path, int mask)
+{
+	struct vfsmount *mnt;
+	int retval;
+
+	/* Catch some reversal of args */
+	BUG_ON(!S_ISDIR(parent_path->dentry->d_inode->i_mode));
+
+	if (IS_MNT_UNION(parent_path->mnt))
+		mnt = parent_path->mnt;
+	else
+		mnt = path->mnt;
+
+	retval = sb_permission(mnt->mnt_sb, path->dentry->d_inode, mask);
+	if (retval)
+		return retval;
+	return __inode_permission(path->dentry->d_inode, mask);
+}
+
+/**
  * file_permission  -  check for additional access rights to a given file
  * @file:	file to check access rights for
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 78eca89..998adae 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2139,6 +2139,7 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
+extern int path_permission(struct path *, struct path *, int);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 extern int generic_readdir_fallthru(struct dentry *topmost_dentry, const char *name,

-VAL
