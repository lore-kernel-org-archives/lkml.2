Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2GBOaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:30:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab2GBO3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:29:32 -0400
Message-Id: <20120702142926.652262547@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 Jul 2012 10:29:28 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, aris@redhat.com, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: [PATCH v3 3/3] cgroup: add xattr support
References: <20120702142925.795007114@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=cgroup3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

This is one of the items in the plumber's wish list.

For use cases:

>> What would the use case be for this?
>
> Attaching meta information to services, in an easily discoverable
> way. For example, in systemd we create one cgroup for each service, and
> could then store data like the main pid of the specific service as an
> xattr on the cgroup itself. That way we'd have almost all service state
> in the cgroupfs, which would make it possible to terminate systemd and
> later restart it without losing any state information. But there's more:
> for example, some very peculiar services cannot be terminated on
> shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
> services in question could just mark that on their cgroup, by setting an
> xattr. On the more desktopy side of things there are other
> possibilities: for example there are plans defining what an application
> is along the lines of a cgroup (i.e. an app being a collection of
> processes). With xattrs one could then attach an icon or human readable
> program name on the cgroup.
>
> The key idea is that this would allow attaching runtime meta information
> to cgroups and everything they model (services, apps, vms), that doesn't
> need any complex userspace infrastructure, has good access control
> (i.e. because the file system enforces that anyway, and there's the
> "trusted." xattr namespace), notifications (inotify), and can easily be
> shared among applications.
>
> Lennart

v3:
- instead of config option, use mount option to enable xattr support

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 include/linux/cgroup.h |   13 ++++-
 kernel/cgroup.c        |  118 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 112 insertions(+), 19 deletions(-)

--- linus-2.6.orig/include/linux/cgroup.h	2012-07-02 10:21:58.055646941 -0400
+++ linus-2.6/include/linux/cgroup.h	2012-07-02 10:22:22.012584730 -0400
@@ -17,6 +17,7 @@  *  Copyright (C) 2004-2006 Silicon Grap
 #include <linux/rwsem.h>
 #include <linux/idr.h>
 #include <linux/workqueue.h>
+#include <linux/xattr.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -216,6 +217,9 @@ 	 * count users of this cgroup. >0 means
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
+
+	/* directory xattrs */
+	struct simple_xattrs xattrs;
 };
 
 /*
@@ -312,6 +316,9 @@ 	 * If not 0, file mode is set to this v
 	/* CFTYPE_* flags */
 	unsigned int flags;
 
+	/* file xattrs */
+	struct simple_xattrs xattrs;
+
 	int (*open)(struct inode *inode, struct file *file);
 	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
 			struct file *file,
@@ -397,7 +404,7 @@ 	 * Returns 0 or -ve error code.
  */
 struct cftype_set {
 	struct list_head		node;	/* chained at subsys->cftsets */
-	const struct cftype		*cfts;
+	struct cftype			*cfts;
 };
 
 struct cgroup_scanner {
@@ -409,8 +416,8 @@ struct cgroup_scanner {
 	void *data;
 };
 
-int cgroup_add_cftypes(struct cgroup_subsys *ss, const struct cftype *cfts);
-int cgroup_rm_cftypes(struct cgroup_subsys *ss, const struct cftype *cfts);
+int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
+int cgroup_rm_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
--- linus-2.6.orig/kernel/cgroup.c	2012-07-02 10:21:58.059646980 -0400
+++ linus-2.6/kernel/cgroup.c	2012-07-02 10:22:22.017584857 -0400
@@ -276,7 +276,8 @@ inline int cgroup_is_removed(const struc
 
 /* bits in struct cgroupfs_root flags field */
 enum {
-	ROOT_NOPREFIX, /* mounted subsystems have no named prefix */
+	ROOT_NOPREFIX,	/* mounted subsystems have no named prefix */
+	ROOT_XATTR,	/* supports extended attributes */
 };
 
 static int cgroup_is_releasable(const struct cgroup *cgrp)
@@ -916,15 +917,19 @@ static void cgroup_diput(struct dentry *
 		 */
 		BUG_ON(!list_empty(&cgrp->pidlists));
 
+		simple_xattrs_free(&cgrp->xattrs);
+
 		kfree_rcu(cgrp, rcu_head);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
+		struct cftype *cft = cfe->type;
 
 		WARN_ONCE(!list_empty(&cfe->node) &&
 			  cgrp != &cgrp->root->top_cgroup,
 			  "cfe still linked for %s\n", cfe->type->name);
 		kfree(cfe);
+		simple_xattrs_free(&cft->xattrs);
 	}
 	iput(inode);
 }
@@ -1149,6 +1154,8 @@ static int cgroup_show_options(struct se
 		seq_printf(seq, ",%s", ss->name);
 	if (test_bit(ROOT_NOPREFIX, &root->flags))
 		seq_puts(seq, ",noprefix");
+	if (test_bit(ROOT_XATTR, &root->flags))
+		seq_puts(seq, ",xattr");
 	if (strlen(root->release_agent_path))
 		seq_printf(seq, ",release_agent=%s", root->release_agent_path);
 	if (clone_children(&root->top_cgroup))
@@ -1217,6 +1224,10 @@ 	memset(opts, 0, sizeof(*opts));
 			opts->clone_children = true;
 			continue;
 		}
+		if (!strcmp(token, "xattr")) {
+			set_bit(ROOT_XATTR, &opts->flags);
+			continue;
+		}
 		if (!strncmp(token, "release_agent=", 14)) {
 			/* Specifying two release agents is forbidden */
 			if (opts->release_agent)
@@ -1434,6 +1445,7 @@ static void init_cgroup_housekeeping(str
 	mutex_init(&cgrp->pidlist_mutex);
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
+	simple_xattrs_init(&cgrp->xattrs);
 }
 
 static void init_cgroup_root(struct cgroupfs_root *root)
@@ -1779,6 +1791,8 @@ 	ret = rebind_subsystems(root, 0);
 	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 
+	simple_xattrs_free(&cgrp->xattrs);
+
 	kill_litter_super(sb);
 	cgroup_drop_root(root);
 }
@@ -2585,19 +2599,89 @@ static int cgroup_rename(struct inode *o
 	return simple_rename(old_dir, old_dentry, new_dir, new_dentry);
 }
 
+static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
+{
+	if (S_ISDIR(dentry->d_inode->i_mode))
+		return &__d_cgrp(dentry)->xattrs;
+	else
+		return &__d_cft(dentry)->xattrs;
+}
+
+static inline int xattr_enabled(struct dentry *dentry)
+{
+	struct cgroupfs_root *root = dentry->d_sb->s_fs_info;
+	return test_bit(ROOT_XATTR, &root->flags);
+}
+
+static bool is_valid_xattr(const char *name)
+{
+	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) ||
+	    !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
+	    !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN))
+		return true;
+	return false;
+}
+
+static int cgroup_setxattr(struct dentry *dentry, const char *name,
+			   const void *val, size_t size, int flags)
+{
+	if (!xattr_enabled(dentry))
+		return -EOPNOTSUPP;
+	if (!is_valid_xattr(name))
+		return -EINVAL;
+	return simple_xattr_set(__d_xattrs(dentry), name, val, size, flags);
+}
+
+static int cgroup_removexattr(struct dentry *dentry, const char *name)
+{
+	if (!xattr_enabled(dentry))
+		return -EOPNOTSUPP;
+	if (!is_valid_xattr(name))
+		return -EINVAL;
+	return simple_xattr_remove(__d_xattrs(dentry), name);
+}
+
+static ssize_t cgroup_getxattr(struct dentry *dentry, const char *name,
+			       void *buf, size_t size)
+{
+	if (!xattr_enabled(dentry))
+		return -EOPNOTSUPP;
+	if (!is_valid_xattr(name))
+		return -EINVAL;
+	return simple_xattr_get(__d_xattrs(dentry), name, buf, size);
+}
+
+static ssize_t cgroup_listxattr(struct dentry *dentry, char *buf, size_t size)
+{
+	if (!xattr_enabled(dentry))
+		return -EOPNOTSUPP;
+	return simple_xattr_list(__d_xattrs(dentry), buf, size);
+}
+
 static const struct file_operations cgroup_file_operations = {
-	.read = cgroup_file_read,
-	.write = cgroup_file_write,
-	.llseek = generic_file_llseek,
-	.open = cgroup_file_open,
-	.release = cgroup_file_release,
+	.read		= cgroup_file_read,
+	.write		= cgroup_file_write,
+	.llseek		= generic_file_llseek,
+	.open		= cgroup_file_open,
+	.release	= cgroup_file_release,
+};
+
+static const struct inode_operations cgroup_file_inode_operations = {
+	.setxattr	= cgroup_setxattr,
+	.getxattr	= cgroup_getxattr,
+	.listxattr	= cgroup_listxattr,
+	.removexattr	= cgroup_removexattr,
 };
 
 static const struct inode_operations cgroup_dir_inode_operations = {
-	.lookup = cgroup_lookup,
-	.mkdir = cgroup_mkdir,
-	.rmdir = cgroup_rmdir,
-	.rename = cgroup_rename,
+	.lookup		= cgroup_lookup,
+	.mkdir		= cgroup_mkdir,
+	.rmdir		= cgroup_rmdir,
+	.rename		= cgroup_rename,
+	.setxattr	= cgroup_setxattr,
+	.getxattr	= cgroup_getxattr,
+	.listxattr	= cgroup_listxattr,
+	.removexattr	= cgroup_removexattr,
 };
 
 static struct dentry *cgroup_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
@@ -2645,6 +2729,7 @@ static int cgroup_create_file(struct den
 	} else if (S_ISREG(mode)) {
 		inode->i_size = 0;
 		inode->i_fop = &cgroup_file_operations;
+		inode->i_op = &cgroup_file_inode_operations;
 	}
 	d_instantiate(dentry, inode);
 	dget(dentry);	/* Extra count - pin the dentry in core */
@@ -2705,7 +2790,7 @@ 	umode_t mode = 0;
 }
 
 static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
-			   const struct cftype *cft)
+			   struct cftype *cft)
 {
 	struct dentry *dir = cgrp->dentry;
 	struct cgroup *parent = __d_cgrp(dir);
@@ -2716,6 +2801,7 @@ static int cgroup_add_file(struct cgroup
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
 	cft->subsys = subsys;
+	simple_xattrs_init(&cft->xattrs);
 
 	/* does @cft->flags tell us to skip creation on @cgrp? */
 	if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
@@ -2757,9 +2843,9 @@ out:
 }
 
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
-			      const struct cftype cfts[], bool is_add)
+			      struct cftype cfts[], bool is_add)
 {
-	const struct cftype *cft;
+	struct cftype *cft;
 	int err, ret = 0;
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
@@ -2793,7 +2879,7 @@ static void cgroup_cfts_prepare(void)
 }
 
 static void cgroup_cfts_commit(struct cgroup_subsys *ss,
-			       const struct cftype *cfts, bool is_add)
+			       struct cftype *cfts, bool is_add)
 	__releases(&cgroup_mutex) __releases(&cgroup_cft_mutex)
 {
 	LIST_HEAD(pending);
@@ -2844,7 +2930,7 @@  * Returns 0 on successful registration,
  * function currently returns 0 as long as @cfts registration is successful
  * even if some file creation attempts on existing cgroups fail.
  */
-int cgroup_add_cftypes(struct cgroup_subsys *ss, const struct cftype *cfts)
+int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	struct cftype_set *set;
 
@@ -2874,7 +2960,7 @@ EXPORT_SYMBOL_GPL(cgroup_add_cftypes);
  * Returns 0 on successful unregistration, -ENOENT if @cfts is not
  * registered with @ss.
  */
-int cgroup_rm_cftypes(struct cgroup_subsys *ss, const struct cftype *cfts)
+int cgroup_rm_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	struct cftype_set *set;
 

