Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0LGJba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:31:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40322 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab0LGJb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:31:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ka6p+kWDrRLuZEy8bgBZMBZgNIyshI9dk3GHrjYnzZ0QgBmKCE0xW2Dh277gTvQ8yO
         2+3nf0wjcl17hOy2P++ifOuN9hsBkgjImx3by0XguCL/UYPvWEkj3/2UipyLQyhftUYe
         9dxdCl+N6YKcmlRgctRde6ZycWlNxK5gHqXP0=
Date: Tue, 7 Dec 2010 11:31:26 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCH] proc: ->low_ino cleanup
Message-ID: <20101207093126.GA29776@core2.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* ->low_ino is write-once field -- reading it under locks is unnecessary.
* /proc/$PID stuff never reaches pde_put()/free_proc_entry() --
  PROC_DYNAMIC_FIRST check never triggers.
* in proc_get_inode(), inode number always matches proc dir entry,
  so save one parameter.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c  |   12 ++----------
 fs/proc/inode.c    |    7 +++----
 fs/proc/internal.h |    2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -425,13 +425,10 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 		if (de->namelen != dentry->d_name.len)
 			continue;
 		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
-			unsigned int ino;
-
-			ino = de->low_ino;
 			pde_get(de);
 			spin_unlock(&proc_subdir_lock);
 			error = -EINVAL;
-			inode = proc_get_inode(dir->i_sb, ino, de);
+			inode = proc_get_inode(dir->i_sb, de);
 			goto out_unlock;
 		}
 	}
@@ -768,12 +765,7 @@ EXPORT_SYMBOL(proc_create_data);
 
 static void free_proc_entry(struct proc_dir_entry *de)
 {
-	unsigned int ino = de->low_ino;
-
-	if (ino < PROC_DYNAMIC_FIRST)
-		return;
-
-	release_inode_number(ino);
+	release_inode_number(de->low_ino);
 
 	if (S_ISLNK(de->mode))
 		kfree(de->data);
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -409,12 +409,11 @@ static const struct file_operations proc_reg_file_ops_no_compat = {
 };
 #endif
 
-struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
-				struct proc_dir_entry *de)
+struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
 	struct inode * inode;
 
-	inode = iget_locked(sb, ino);
+	inode = iget_locked(sb, de->low_ino);
 	if (!inode)
 		return NULL;
 	if (inode->i_state & I_NEW) {
@@ -464,7 +463,7 @@ int proc_fill_super(struct super_block *s)
 	s->s_time_gran = 1;
 	
 	pde_get(&proc_root);
-	root_inode = proc_get_inode(s, PROC_ROOT_INO, &proc_root);
+	root_inode = proc_get_inode(s, &proc_root);
 	if (!root_inode)
 		goto out_no_root;
 	root_inode->i_uid = 0;
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -109,7 +109,7 @@ void pde_put(struct proc_dir_entry *pde);
 
 extern struct vfsmount *proc_mnt;
 int proc_fill_super(struct super_block *);
-struct inode *proc_get_inode(struct super_block *, unsigned int, struct proc_dir_entry *);
+struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 
 /*
  * These are generic /proc routines that use the internal
