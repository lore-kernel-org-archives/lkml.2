Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1ANFbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:31:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55199 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab1ANFbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:31:46 -0500
Date: Fri, 14 Jan 2011 05:31:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] cgroup fix
Message-ID: <20110114053145.GA19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup can't use simple_lookup(), since that'd override its desired ->d_op.

Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5c5f4cc..ffb7bba 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -764,6 +764,7 @@ EXPORT_SYMBOL_GPL(cgroup_unlock);
  */
 
 static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, int mode);
+static struct dentry *cgroup_lookup(struct inode *, struct dentry *, struct nameidata *);
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
 static int cgroup_populate_dir(struct cgroup *cgrp);
 static const struct inode_operations cgroup_dir_inode_operations;
@@ -860,6 +861,11 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 	iput(inode);
 }
 
+static int cgroup_delete(const struct dentry *d)
+{
+	return 1;
+}
+
 static void remove_dir(struct dentry *d)
 {
 	struct dentry *parent = dget(d->d_parent);
@@ -1451,6 +1457,7 @@ static int cgroup_get_rootdir(struct super_block *sb)
 {
 	static const struct dentry_operations cgroup_dops = {
 		.d_iput = cgroup_diput,
+		.d_delete = cgroup_delete,
 	};
 
 	struct inode *inode =
@@ -2195,12 +2202,20 @@ static const struct file_operations cgroup_file_operations = {
 };
 
 static const struct inode_operations cgroup_dir_inode_operations = {
-	.lookup = simple_lookup,
+	.lookup = cgroup_lookup,
 	.mkdir = cgroup_mkdir,
 	.rmdir = cgroup_rmdir,
 	.rename = cgroup_rename,
 };
 
+static struct dentry *cgroup_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+{
+	if (dentry->d_name.len > NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+	d_add(dentry, NULL);
+	return NULL;
+}
+
 /*
  * Check if a file is a control file
  */
