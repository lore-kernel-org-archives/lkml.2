Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2GRVUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:20:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47475 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2GRVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:20:46 -0400
Date: Wed, 18 Jul 2012 22:20:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org
Subject: Re: [Bug 3.4.5] reiserfs: mutex_destroy called with locked mutex
Message-ID: <20120718212044.GU31729@ZenIV.linux.org.uk>
References: <5006491D.8070004@t-online.de>
 <CA+55aFzv5mntf6y9e_r5=v+beG19xBv67EpA=dP0-Zw1CQrGGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzv5mntf6y9e_r5=v+beG19xBv67EpA=dP0-Zw1CQrGGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 09:26:57AM -0700, Linus Torvalds wrote:
> On Tue, Jul 17, 2012 at 10:26 PM, Knut Petersen
> <Knut_Petersen@t-online.de> wrote:
> > I hit the following problem during a heavy compile job on kernel 3.4.5:
> 
> I think it's triggered by the fact that reiserfs does
> 
>         d_instantiate(dentry, inode);
>         unlock_new_inode(inode);
> 
> ie it does the "unlock_new_inode()" *after* it has already made the
> inode visible to others in the filesystem. So you can now have a
> concurrent lookup of that dentry that finds the (locked) inode before
> "unlock_new_inode()" has had the chance to set the lockdep class.
> Also, since it's been instantiated, the only *valid* inode pointer is
> in the dentry, so the code really really shouldn't use the "inode"
> pointer any more because the refcount has been transferred to the
> dentry. So maybe memory pressure could turn the dentry negative (and
> free the inode) while the unlock_new_inode() code runs.
> 
> fs/ext[23]/namei.c has the same pattern, though, and I think it should
> be harmless (the inode is marked I_NEW and we get the i_lock for
> unlock_new_inode, so the freeing code should know to keep away from
> it). So I don't think the freeing code could trigger, but a concurrent
> lookup then trying to look up the new directory (and taking the new
> directory i_semaphore lock) could happen, afaik.
> 
> So I think we should re-order the d_instantiate/unlock_new_inode calls. Al?

Umm...  The thing is, we'd get WARN_ON() in iput_final() triggering in
that scenario before lockdep could complain.

Note that dentry is pinned by reference we are holding, so no matter who
comes and finds it in dcache, no amount of memory pressure is going to
evict it or its inode.  Busy dentries do _not_ become negative under
us.   So no, I don't believe that this is what the original poster had been seeing.

OTOH, you are right and it's better to reorder these pairs on the general principle;
it's just that we are seeing something else here.

Below is the obvious patch reordering such guys; it's a lot more than just
ext[23] and reiserfs, BTW.  I don't believe that this should go in this
cycle, though, and it won't change the situation for the original poster.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index da52cdb..ffa2be5 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -269,8 +269,8 @@ ecryptfs_create(struct inode *directory_inode, struct dentry *ecryptfs_dentry,
 		iput(ecryptfs_inode);
 		goto out;
 	}
-	d_instantiate(ecryptfs_dentry, ecryptfs_inode);
 	unlock_new_inode(ecryptfs_inode);
+	d_instantiate(ecryptfs_dentry, ecryptfs_inode);
 out:
 	return rc;
 }
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 9ba7de0..73b0d95 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -41,8 +41,8 @@ static inline int ext2_add_nondir(struct dentry *dentry, struct inode *inode)
 {
 	int err = ext2_add_link(dentry, inode);
 	if (!err) {
-		d_instantiate(dentry, inode);
 		unlock_new_inode(inode);
+		d_instantiate(dentry, inode);
 		return 0;
 	}
 	inode_dec_link_count(inode);
@@ -242,8 +242,8 @@ static int ext2_mkdir(struct inode * dir, struct dentry * dentry, umode_t mode)
 	if (err)
 		goto out_fail;
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 out:
 	return err;
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 85286db..8f4fdda 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1671,8 +1671,8 @@ static int ext3_add_nondir(handle_t *handle,
 	int err = ext3_add_entry(handle, dentry, inode);
 	if (!err) {
 		ext3_mark_inode_dirty(handle, inode);
-		d_instantiate(dentry, inode);
 		unlock_new_inode(inode);
+		d_instantiate(dentry, inode);
 		return 0;
 	}
 	drop_nlink(inode);
@@ -1836,8 +1836,8 @@ out_clear_inode:
 	if (err)
 		goto out_clear_inode;
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 out_stop:
 	brelse(dir_block);
 	ext3_journal_stop(handle);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eca3e48..d0d3f0e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2072,8 +2072,8 @@ static int ext4_add_nondir(handle_t *handle,
 	int err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
 		ext4_mark_inode_dirty(handle, inode);
-		d_instantiate(dentry, inode);
 		unlock_new_inode(inode);
+		d_instantiate(dentry, inode);
 		return 0;
 	}
 	drop_nlink(inode);
@@ -2249,8 +2249,8 @@ out_clear_inode:
 	err = ext4_mark_inode_dirty(handle, dir);
 	if (err)
 		goto out_clear_inode;
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 out_stop:
 	brelse(dir_block);
 	ext4_journal_stop(handle);
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 2324519..ad7774d 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -226,8 +226,8 @@ static int jffs2_create(struct inode *dir_i, struct dentry *dentry,
 		  __func__, inode->i_ino, inode->i_mode, inode->i_nlink,
 		  f->inocache->pino_nlink, inode->i_mapping->nrpages);
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 	return 0;
 
  fail:
@@ -446,8 +446,8 @@ static int jffs2_symlink (struct inode *dir_i, struct dentry *dentry, const char
 	mutex_unlock(&dir_f->sem);
 	jffs2_complete_reservation(c);
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 	return 0;
 
  fail:
@@ -591,8 +591,8 @@ static int jffs2_mkdir (struct inode *dir_i, struct dentry *dentry, umode_t mode
 	mutex_unlock(&dir_f->sem);
 	jffs2_complete_reservation(c);
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 	return 0;
 
  fail:
@@ -766,8 +766,8 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, umode_t mode
 	mutex_unlock(&dir_f->sem);
 	jffs2_complete_reservation(c);
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 	return 0;
 
  fail:
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index c426293..3b91a7a 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -176,8 +176,8 @@ static int jfs_create(struct inode *dip, struct dentry *dentry, umode_t mode,
 		unlock_new_inode(ip);
 		iput(ip);
 	} else {
-		d_instantiate(dentry, ip);
 		unlock_new_inode(ip);
+		d_instantiate(dentry, ip);
 	}
 
       out2:
@@ -309,8 +309,8 @@ static int jfs_mkdir(struct inode *dip, struct dentry *dentry, umode_t mode)
 		unlock_new_inode(ip);
 		iput(ip);
 	} else {
-		d_instantiate(dentry, ip);
 		unlock_new_inode(ip);
+		d_instantiate(dentry, ip);
 	}
 
       out2:
@@ -1043,8 +1043,8 @@ static int jfs_symlink(struct inode *dip, struct dentry *dentry,
 		unlock_new_inode(ip);
 		iput(ip);
 	} else {
-		d_instantiate(dentry, ip);
 		unlock_new_inode(ip);
+		d_instantiate(dentry, ip);
 	}
 
       out2:
@@ -1424,8 +1424,8 @@ static int jfs_mknod(struct inode *dir, struct dentry *dentry,
 		unlock_new_inode(ip);
 		iput(ip);
 	} else {
-		d_instantiate(dentry, ip);
 		unlock_new_inode(ip);
+		d_instantiate(dentry, ip);
 	}
 
       out1:
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 3916be1..8567fb8 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -634,8 +634,8 @@ static int reiserfs_create(struct inode *dir, struct dentry *dentry, umode_t mod
 	reiserfs_update_inode_transaction(inode);
 	reiserfs_update_inode_transaction(dir);
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 
       out_failed:
@@ -712,8 +712,8 @@ static int reiserfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode
 		goto out_failed;
 	}
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 
       out_failed:
@@ -800,8 +800,8 @@ static int reiserfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode
 	// the above add_entry did not update dir's stat data
 	reiserfs_update_sd(&th, dir);
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 out_failed:
 	reiserfs_write_unlock_once(dir->i_sb, lock_depth);
@@ -1096,8 +1096,8 @@ static int reiserfs_symlink(struct inode *parent_dir,
 		goto out_failed;
 	}
 
-	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+	d_instantiate(dentry, inode);
 	retval = journal_end(&th, parent_dir->i_sb, jbegin_count);
       out_failed:
 	reiserfs_write_unlock(parent_dir->i_sb);
