Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab1CDXRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:17:03 -0500
Received: from cobra.newdream.net ([66.33.216.30]:56485 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab1CDXRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:17:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=uDGjdKlWJ9IPlKqjfRTdkgjyKcKtxKV+w961N/bsDcj3yB4H
	HWo6zL7C/g7ruyEUkYivL4SJ4c1MqaAGboXI59ceMJQyDWfg2CxE8f2nSBn2VKlC
	syiuqs7vXAKdIL0ruro1ySJlp4efvY4ij39MLcclzJo8Ty4RL1dlzlut5ps=
Date: Fri, 4 Mar 2011 15:18:57 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
cc: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC] d_prune
Message-ID: <Pine.LNX.4.64.1103041443290.29012@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu path walk changes for 2.6.38 shone light in some dark corners 
where Ceph was using the dcache in racy ways.  The main problem is this:

 * The Ceph MDS server gives us lease information such that we know the
   contents for a directory won't change.
 * We want to do lookup on non-existant items without interacting with the
   server.  (We also want to do readdir, but that's a more complicated
   case.)
 * The existing hooks (d_release is what we were using) do not give us
   the opportunity to clear our "this directory is completely cached" flag
   prior to the dentry being unhashed.
 * d_lookup can't look at the "complete" flag and conclude a dentry 
   doesn't exist without worrying about a race with the pruner.

There are two cases where this matters:

 * The VFS does a lookup prior to any create, which means we do two server 
   requests instead of one.  Some VFS refactoring could probably fix that 
   (and Al has some ideas there).
 * A user looks up a non-existent file.  This should not require a server
   request at all.

The race we care about is with the pruner (shrink_dentry_list and 
shrink_dcache_for_umount_subtree).  Dropping dentries due to actual 
changes (rename, unlink, rmdir) all go through the usual d_ops where we 
have ample opportunity to the right thing (with the exception of one 
dentry_unhash in vfs_rename_dir() :/).

Is something like the patch below sane?  It notifies the fs prior to 
unhashing the dentry, giving Ceph the chance to clear its "complete" bit.  
Are there other reasons the VFS would drop dentries that I'm missing?

Some alternatives we've considered:

 * Double-caching.  We could keep a copy of directory contents in the fs
   layer and use that to do the lookup.  Yuck.
 * Put the "complete" bit in the dcache.  The problem is it's a flag on 
   the parent, d_flags is protected by d_lock, and we can't take the parent's
   d_lock while holding the child's d_lock (which we do while pruning).  
   Extra work that most fs's don't need.
 * Serializing lookups against the pruner in some other way.

Any thoughts or suggestions?

Thanks! 
sage


diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 4471a41..180e14b 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -28,6 +28,7 @@ d_revalidate: no              no              yes (ref-walk)  maybe
 d_hash         no              no              no              maybe
 d_compare:     yes             no              no              maybe
 d_delete:      no              yes             no              no
+d_prune:        no              yes             no              no
 d_release:     no              no              yes             no
 d_iput:                no              no              yes             no
 d_dname:       no              no              no              no
diff --git a/fs/dcache.c b/fs/dcache.c
index 2a6bd9a..cdb5d81 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -690,6 +690,8 @@ static void try_prune_one_dentry(struct dentry *dentry)
                        spin_unlock(&dentry->d_lock);
                        return;
                }
+               if (dentry->d_op->d_flags & DCACHE_OP_PRUNE)
+                       dentry->d_op->d_prune(dentry);
                dentry = dentry_kill(dentry, 1);
        }
 }
@@ -896,6 +898,8 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 
        /* detach this root from the system */
        spin_lock(&dentry->d_lock);
+       if (dentry->d_op->d_flags & DCACHE_OP_PRUNE)
+               dentry->d_op->d_prune(dentry);
        dentry_lru_del(dentry);
        __d_drop(dentry);
        spin_unlock(&dentry->d_lock);
@@ -912,6 +916,8 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
                                            d_u.d_child) {
                                spin_lock_nested(&loop->d_lock,
                                                DENTRY_D_LOCK_NESTED);
+                               if (dentry->d_op->d_flags & DCACHE_OP_PRUNE)
+                                       dentry->d_op->d_prune(dentry);
                                dentry_lru_del(loop);
                                __d_drop(loop);
                                spin_unlock(&loop->d_lock);
@@ -1375,6 +1381,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
                dentry->d_flags |= DCACHE_OP_REVALIDATE;
        if (op->d_delete)
                dentry->d_flags |= DCACHE_OP_DELETE;
+       if (op->d_prune)
+               dentry->d_flags |= DCACHE_OP_PRUNE;
 
 }
 EXPORT_SYMBOL(d_set_d_op);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index f958c19..1e83bd8 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -165,6 +165,7 @@ struct dentry_operations {
                        unsigned int, const char *, const struct qstr *);
        int (*d_delete)(const struct dentry *);
        void (*d_release)(struct dentry *);
+       void (*d_prune)(struct dentry *);
        void (*d_iput)(struct dentry *, struct inode *);
        char *(*d_dname)(struct dentry *, char *, int);
        struct vfsmount *(*d_automount)(struct path *);
@@ -219,6 +220,8 @@ struct dentry_operations {
 #define DCACHE_MANAGED_DENTRY \
        (DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
+#define DCACHE_OP_PRUNE         0x80000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(struct dentry *dentry)
