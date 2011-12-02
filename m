Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1LBStR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:49:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:23917 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab1LBSna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:43:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,285,1320652800"; 
   d="scan'208";a="97981763"
From: Andi Kleen <andi@firstfloor.org>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fengguang.wu@intel.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] DEBUGFS: Automatically create parents for debugfs files
Date: Fri,  2 Dec 2011 10:43:25 -0800
Message-Id: <1322851407-17182-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
References: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Allow passing path names to debugfs_create* and automatically create
the parents. This makes it much simpler for the caller to create hierarchies.

The way the reference counts are handled is admittedly a bit ugly.

There is no way to clean them up currently other than to delete the tree,
but that doesn't seem like a big problem for debugfs to leave
behind a few empty directories.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/debugfs/inode.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index f3a257d..7ea9a6c 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -146,6 +146,52 @@ static struct file_system_type debug_fs_type = {
 	.kill_sb =	kill_litter_super,
 };
 
+/*
+ * Created parents stay around later. Sorry, but it shouldn't be a big issue.
+ */
+static const char *create_parents(const char *name, struct dentry *parent,
+				  struct dentry **pp, int *ref)
+{
+	char fn[strlen(name) + 1];
+	char *tail;
+	char *s, *p;
+	struct dentry *new_parent, *dentry, *old_parent = NULL;
+
+	strcpy(fn, name);
+	tail = strrchr(fn, '/');
+	if (!tail)
+		return name;
+	tail++;
+
+	s = fn;
+	while ((p = strsep(&s, "/")) != NULL && p != tail) {
+		/* ignore error here */
+		dentry = debugfs_create_dir(p, parent);
+
+		/* Is it there now? */
+		mutex_lock(&parent->d_inode->i_mutex);
+		new_parent = lookup_one_len(p, parent, strlen(p));
+		mutex_unlock(&parent->d_inode->i_mutex);
+
+		if (!PTR_ERR(dentry))
+			dput(dentry);
+		if (IS_ERR(new_parent))
+			return NULL;
+		if (old_parent)
+			dput(old_parent);
+		if (parent != *pp)
+			old_parent = parent;
+		parent = new_parent;
+	}
+	if (parent) {
+		*ref = 1;
+		*pp = parent;
+	}
+	if (old_parent)
+		dput(old_parent);
+	return strrchr(name, '/') + 1;
+}
+
 static int debugfs_create_by_name(const char *name, mode_t mode,
 				  struct dentry *parent,
 				  struct dentry **dentry,
@@ -153,6 +199,7 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
 				  const struct file_operations *fops)
 {
 	int error = 0;
+	int ref = 0;
 
 	/* If the parent is not specified, we create it in the root.
 	 * We need the root dentry to do this, which is in the super 
@@ -161,6 +208,7 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
 	 */
 	if (!parent)
 		parent = debugfs_mount->mnt_sb->s_root;
+	name = create_parents(name, parent, &parent, &ref);
 
 	*dentry = NULL;
 	mutex_lock(&parent->d_inode->i_mutex);
@@ -185,6 +233,9 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
 		error = PTR_ERR(*dentry);
 	mutex_unlock(&parent->d_inode->i_mutex);
 
+	if (ref)
+		dput(parent);
+
 	return error;
 }
 
-- 
1.7.4.4

