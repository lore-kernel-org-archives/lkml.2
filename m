Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0GESoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:44:22 -0400
Received: from kroah.org ([198.145.64.141]:35207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab0GESoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:44:15 -0400
Date: Mon, 5 Jul 2010 11:38:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.31.14
Message-ID: <20100705183825.GD31678@kroah.com>
References: <20100705183812.GC31678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705183812.GC31678@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index ac8ee8e..7b8f2f0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 31
-EXTRAVERSION = .13
+EXTRAVERSION = .14
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 6d2668f..d42c30c 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -45,8 +45,6 @@ static inline bool is_privroot_deh(struct dentry *dir,
 				   struct reiserfs_de_head *deh)
 {
 	struct dentry *privroot = REISERFS_SB(dir->d_sb)->priv_root;
-	if (reiserfs_expose_privroot(dir->d_sb))
-		return 0;
 	return (dir == dir->d_parent && privroot->d_inode &&
 	        deh->deh_objectid == INODE_PKEY(privroot->d_inode)->k_objectid);
 }
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 6925b83..cc1caa2 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -536,7 +536,7 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 	if (!err && new_size < i_size_read(dentry->d_inode)) {
 		struct iattr newattrs = {
 			.ia_ctime = current_fs_time(inode->i_sb),
-			.ia_size = buffer_size,
+			.ia_size = new_size,
 			.ia_valid = ATTR_SIZE | ATTR_CTIME,
 		};
 		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_XATTR);
@@ -952,21 +952,13 @@ int reiserfs_permission(struct inode *inode, int mask)
 	return generic_permission(inode, mask, NULL);
 }
 
-/* This will catch lookups from the fs root to .reiserfs_priv */
-static int
-xattr_lookup_poison(struct dentry *dentry, struct qstr *q1, struct qstr *name)
+static int xattr_hide_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
-	struct dentry *priv_root = REISERFS_SB(dentry->d_sb)->priv_root;
-	if (container_of(q1, struct dentry, d_name) == priv_root)
-		return -ENOENT;
-	if (q1->len == name->len &&
-		   !memcmp(q1->name, name->name, name->len))
-		return 0;
-	return 1;
+	return -EPERM;
 }
 
 static const struct dentry_operations xattr_lookup_poison_ops = {
-	.d_compare = xattr_lookup_poison,
+	.d_revalidate = xattr_hide_revalidate,
 };
 
 int reiserfs_lookup_privroot(struct super_block *s)
@@ -980,8 +972,7 @@ int reiserfs_lookup_privroot(struct super_block *s)
 				strlen(PRIVROOT_NAME));
 	if (!IS_ERR(dentry)) {
 		REISERFS_SB(s)->priv_root = dentry;
-		if (!reiserfs_expose_privroot(s))
-			s->s_root->d_op = &xattr_lookup_poison_ops;
+		dentry->d_op = &xattr_lookup_poison_ops;
 		if (dentry->d_inode)
 			dentry->d_inode->i_flags |= S_PRIVATE;
 	} else
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index d089d05..187d7a6 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -524,14 +524,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->it_id = (timer_t) new_timer_id;
 	new_timer->it_clock = which_clock;
 	new_timer->it_overrun = -1;
-	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
-	if (error)
-		goto out;
 
-	/*
-	 * return the timer_id now.  The next step is hard to
-	 * back out if there is an error.
-	 */
 	if (copy_to_user(created_timer_id,
 			 &new_timer_id, sizeof (new_timer_id))) {
 		error = -EFAULT;
@@ -562,6 +555,10 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->sigq->info.si_tid   = new_timer->it_id;
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
+	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
+	if (error)
+		goto out;
+
 	spin_lock_irq(&current->sighand->siglock);
 	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index a83d196..32f9853 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1161,13 +1161,15 @@ static long snd_mixart_BA0_read(struct snd_info_entry *entry, void *file_private
 				unsigned long count, unsigned long pos)
 {
 	struct mixart_mgr *mgr = entry->private_data;
+	unsigned long maxsize;
 
-	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
-	if(count <= 0)
+	if (pos >= MIXART_BA0_SIZE)
 		return 0;
-	if(pos + count > MIXART_BA0_SIZE)
-		count = (long)(MIXART_BA0_SIZE - pos);
-	if(copy_to_user_fromio(buf, MIXART_MEM( mgr, pos ), count))
+	maxsize = MIXART_BA0_SIZE - pos;
+	if (count > maxsize)
+		count = maxsize;
+	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
+	if (copy_to_user_fromio(buf, MIXART_MEM(mgr, pos), count))
 		return -EFAULT;
 	return count;
 }
@@ -1180,13 +1182,15 @@ static long snd_mixart_BA1_read(struct snd_info_entry *entry, void *file_private
 				unsigned long count, unsigned long pos)
 {
 	struct mixart_mgr *mgr = entry->private_data;
+	unsigned long maxsize;
 
-	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
-	if(count <= 0)
+	if (pos > MIXART_BA1_SIZE)
 		return 0;
-	if(pos + count > MIXART_BA1_SIZE)
-		count = (long)(MIXART_BA1_SIZE - pos);
-	if(copy_to_user_fromio(buf, MIXART_REG( mgr, pos ), count))
+	maxsize = MIXART_BA1_SIZE - pos;
+	if (count > maxsize)
+		count = maxsize;
+	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
+	if (copy_to_user_fromio(buf, MIXART_REG(mgr, pos), count))
 		return -EFAULT;
 	return count;
 }
