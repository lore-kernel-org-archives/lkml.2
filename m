Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1ANFPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:15:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60966 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1ANFO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:14:59 -0500
Date: Fri, 14 Jan 2011 05:14:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Nick Piggin <npiggin@gmail.com>, Paul Menage <menage@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel BUG at fs/dcache.c:1363 (from cgroup)
Message-ID: <20110114051453.GY19804@ZenIV.linux.org.uk>
References: <4D2FD771.9040301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2FD771.9040301@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 12:56:17PM +0800, Li Zefan wrote:
> Just mount the cgroupfs:
> 
> # mount -t cgroup -o cpuset xxx /mnt
> (oops!!)
> 
> The bug is caused by:
> 
> =========
> commit 0df6a63f8735a7c8a877878bc215d4312e41ef81
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Tue Dec 21 13:29:29 2010 -0500
> 
>     switch cgroup
>     
>     switching it to s_d_op allows to kill the cgroup_lookup() kludge.
>     
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> =========
> 
> This line:
> 
> +       sb->s_d_op = &cgroup_dops;

Oh, crap...  Right, it's using simple_lookup().  Let me check if anything
else might be stepping on that.

Umm...  There's a very strange codepath in btrfs that also might.
Interesting.  Fix for cgroup, AFAICS, should be this:

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
