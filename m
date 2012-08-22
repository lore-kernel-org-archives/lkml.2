Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2HVVnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:43:09 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53336 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab2HVVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:43:05 -0400
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adobriyan@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1345660110.5158.1969.camel@edumazet-glaptop>
References: <n>  <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
	 <1345660110.5158.1969.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 23:42:58 +0200
Message-ID: <1345671778.5158.2369.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 20:28 +0200, Eric Dumazet wrote:

> 
> Thats interesting, but if you really want this to fly, one RCU
> conversion would be much better ;)
> 
> pde_users would be an atomic_t and you would avoid the spinlock
> contention.

Here is what I had in mind, I would be interested to know how it helps a 512 core machine ;)

 fs/proc/generic.c       |   66 ++++------
 fs/proc/inode.c         |  250 +++++++++++++++++++++++---------------
 fs/proc/internal.h      |    2 
 include/linux/proc_fs.h |    7 -
 4 files changed, 190 insertions(+), 135 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b3647fe..d2f1b70 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -21,7 +21,7 @@
 #include <linux/namei.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
-#include <linux/completion.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -190,14 +190,16 @@ proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 {
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	ssize_t rv = -EIO;
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	rcu_read_unlock();
 
 	rv = __proc_file_read(file, buf, nbytes, ppos);
 
@@ -213,13 +215,16 @@ proc_file_write(struct file *file, const char __user *buffer,
 	ssize_t rv = -EIO;
 
 	if (pde->write_proc) {
-		spin_lock(&pde->pde_unload_lock);
-		if (!pde->proc_fops) {
-			spin_unlock(&pde->pde_unload_lock);
+		const struct file_operations *fops;
+
+		rcu_read_lock();
+		fops = rcu_dereference(pde->proc_fops);
+		if (!fops) {
+			rcu_read_unlock();
 			return rv;
 		}
-		pde->pde_users++;
-		spin_unlock(&pde->pde_unload_lock);
+		atomic_inc(&pde->pde_users);
+		rcu_read_unlock();
 
 		/* FIXME: does this routine need ppos?  probably... */
 		rv = pde->write_proc(file, buffer, count, pde->data);
@@ -564,7 +569,7 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 
 	if (S_ISDIR(dp->mode)) {
 		if (dp->proc_iops == NULL) {
-			dp->proc_fops = &proc_dir_operations;
+			RCU_INIT_POINTER(dp->proc_fops, &proc_dir_operations);
 			dp->proc_iops = &proc_dir_inode_operations;
 		}
 		dir->nlink++;
@@ -573,7 +578,7 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 			dp->proc_iops = &proc_link_inode_operations;
 	} else if (S_ISREG(dp->mode)) {
 		if (dp->proc_fops == NULL)
-			dp->proc_fops = &proc_file_operations;
+			RCU_INIT_POINTER(dp->proc_fops, &proc_file_operations);
 		if (dp->proc_iops == NULL)
 			dp->proc_iops = &proc_file_inode_operations;
 	}
@@ -625,11 +630,8 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
-	ent->pde_users = 0;
-	spin_lock_init(&ent->pde_unload_lock);
-	ent->pde_unload_completion = NULL;
-	INIT_LIST_HEAD(&ent->pde_openers);
- out:
+	atomic_set(&ent->pde_users, 0);
+out:
 	return ent;
 }
 
@@ -751,7 +753,7 @@ struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
 	pde = __proc_create(&parent, name, mode, nlink);
 	if (!pde)
 		goto out;
-	pde->proc_fops = proc_fops;
+	rcu_assign_pointer(pde->proc_fops, proc_fops);
 	pde->data = data;
 	if (proc_register(parent, pde) < 0)
 		goto out_free;
@@ -787,6 +789,7 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 	struct proc_dir_entry *de = NULL;
 	const char *fn = name;
 	unsigned int len;
+	LIST_HEAD(purge_queue);
 
 	spin_lock(&proc_subdir_lock);
 	if (__xlate_proc_name(name, &parent, &fn) != 0) {
@@ -809,37 +812,28 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 		return;
 	}
 
-	spin_lock(&de->pde_unload_lock);
 	/*
 	 * Stop accepting new callers into module. If you're
 	 * dynamically allocating ->proc_fops, save a pointer somewhere.
 	 */
 	de->proc_fops = NULL;
+	synchronize_rcu();
 	/* Wait until all existing callers into module are done. */
-	if (de->pde_users > 0) {
-		DECLARE_COMPLETION_ONSTACK(c);
-
-		if (!de->pde_unload_completion)
-			de->pde_unload_completion = &c;
-
-		spin_unlock(&de->pde_unload_lock);
-
-		wait_for_completion(de->pde_unload_completion);
-
-		spin_lock(&de->pde_unload_lock);
+	while (atomic_read(&de->pde_users)) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule();
 	}
+	current->state = TASK_RUNNING;
+	pde_openers_purge(de, &purge_queue);
 
-	while (!list_empty(&de->pde_openers)) {
+	while (!list_empty(&purge_queue)) {
 		struct pde_opener *pdeo;
 
-		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
+		pdeo = list_first_entry(&purge_queue, struct pde_opener, lh);
 		list_del(&pdeo->lh);
-		spin_unlock(&de->pde_unload_lock);
 		pdeo->release(pdeo->inode, pdeo->file);
 		kfree(pdeo);
-		spin_lock(&de->pde_unload_lock);
 	}
-	spin_unlock(&de->pde_unload_lock);
 
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7ac817b..eebf6ab 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -21,6 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/mount.h>
+#include <linux/hash.h>
 
 #include <asm/uaccess.h>
 
@@ -94,8 +95,27 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
+#define PDE_HASH_BITS 5
+#define PDE_HASH_SIZE (1 << PDE_HASH_BITS)
+
+static struct {
+	spinlock_t	 lock;
+	struct list_head head;
+} pde_openers[PDE_HASH_SIZE];
+
+static void __init pde_openers_init(void)
+{
+	int i;
+
+	for (i = 0; i < PDE_HASH_SIZE; i++) {
+		spin_lock_init(&pde_openers[i].lock);
+		INIT_LIST_HEAD(&pde_openers[i].head);
+	}
+}
+
 void __init proc_init_inodecache(void)
 {
+	pde_openers_init();
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
 					     sizeof(struct proc_inode),
 					     0, (SLAB_RECLAIM_ACCOUNT|
@@ -126,18 +146,9 @@ static const struct super_operations proc_sops = {
 	.show_options	= proc_show_options,
 };
 
-static void __pde_users_dec(struct proc_dir_entry *pde)
-{
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-}
-
 void pde_users_dec(struct proc_dir_entry *pde)
 {
-	spin_lock(&pde->pde_unload_lock);
-	__pde_users_dec(pde);
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_dec(&pde->pde_users);
 }
 
 static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
@@ -145,27 +156,29 @@ static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	loff_t rv = -EINVAL;
 	loff_t (*llseek)(struct file *, loff_t, int);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
 	/*
 	 * remove_proc_entry() is going to delete PDE (as part of module
 	 * cleanup sequence). No new callers into module allowed.
 	 */
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
 	/*
 	 * Bump refcount so that remove_proc_entry will wail for ->llseek to
 	 * complete.
 	 */
-	pde->pde_users++;
+	atomic_inc(&pde->pde_users);
 	/*
 	 * Save function pointer under lock, to protect against ->proc_fops
 	 * NULL'ifying right after ->pde_unload_lock is dropped.
 	 */
-	llseek = pde->proc_fops->llseek;
-	spin_unlock(&pde->pde_unload_lock);
+	llseek = fops->llseek;
+	rcu_read_unlock();
 
 	if (!llseek)
 		llseek = default_llseek;
@@ -180,15 +193,17 @@ static ssize_t proc_reg_read(struct file *file, char __user *buf, size_t count,
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	ssize_t rv = -EIO;
 	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	read = pde->proc_fops->read;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	read = fops->read;
+	rcu_read_unlock();
 
 	if (read)
 		rv = read(file, buf, count, ppos);
@@ -202,15 +217,17 @@ static ssize_t proc_reg_write(struct file *file, const char __user *buf, size_t
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	ssize_t rv = -EIO;
 	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	write = pde->proc_fops->write;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	write = fops->write;
+	rcu_read_unlock();
 
 	if (write)
 		rv = write(file, buf, count, ppos);
@@ -224,15 +241,17 @@ static unsigned int proc_reg_poll(struct file *file, struct poll_table_struct *p
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	unsigned int rv = DEFAULT_POLLMASK;
 	unsigned int (*poll)(struct file *, struct poll_table_struct *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	poll = pde->proc_fops->poll;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	poll = fops->poll;
+	rcu_read_unlock();
 
 	if (poll)
 		rv = poll(file, pts);
@@ -246,15 +265,17 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	long rv = -ENOTTY;
 	long (*ioctl)(struct file *, unsigned int, unsigned long);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	ioctl = pde->proc_fops->unlocked_ioctl;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	ioctl = fops->unlocked_ioctl;
+	rcu_read_unlock();
 
 	if (ioctl)
 		rv = ioctl(file, cmd, arg);
@@ -269,15 +290,17 @@ static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	long rv = -ENOTTY;
 	long (*compat_ioctl)(struct file *, unsigned int, unsigned long);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	compat_ioctl = pde->proc_fops->compat_ioctl;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	compat_ioctl = fops->compat_ioctl;
+	rcu_read_unlock();
 
 	if (compat_ioctl)
 		rv = compat_ioctl(file, cmd, arg);
@@ -292,15 +315,17 @@ static int proc_reg_mmap(struct file *file, struct vm_area_struct *vma)
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	int rv = -EIO;
 	int (*mmap)(struct file *, struct vm_area_struct *);
+	const struct file_operations *fops; 
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	mmap = pde->proc_fops->mmap;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	mmap = fops->mmap;
+	rcu_read_unlock();
 
 	if (mmap)
 		rv = mmap(file, vma);
@@ -309,6 +334,59 @@ static int proc_reg_mmap(struct file *file, struct vm_area_struct *vma)
 	return rv;
 }
 
+
+static unsigned int pdeo_hash(const struct inode *inode, const struct file *file)
+{
+	unsigned long hashval = (unsigned long)inode ^ (unsigned long)file;
+
+	return hash_long(hashval, PDE_HASH_BITS);
+}
+
+static void pde_openers_add(struct pde_opener *pdeo)
+{
+	unsigned int slot = pdeo_hash(pdeo->inode, pdeo->file);
+
+	spin_lock(&pde_openers[slot].lock);
+	list_add(&pdeo->lh, &pde_openers[slot].head);
+	spin_unlock(&pde_openers[slot].lock);
+}
+
+void pde_openers_purge(struct proc_dir_entry *pde, struct list_head *queue)
+{
+	int i;
+	struct pde_opener *n, *pdeo;
+
+	for (i = 0; i < PDE_HASH_SIZE; i++) {
+		spin_lock(&pde_openers[i].lock);
+		list_for_each_entry_safe(pdeo, n, &pde_openers[i].head, lh) {
+			if (pdeo->pde == pde)
+				list_move(&pdeo->lh, queue);
+		}
+		spin_unlock(&pde_openers[i].lock);
+	}
+}
+
+typedef int (*release_t)(struct inode *, struct file *);
+
+static release_t pde_opener_del(struct inode *inode, struct file *file)
+{
+	unsigned int slot = pdeo_hash(inode, file);
+	struct pde_opener *pdeo;
+	release_t release = NULL;
+
+	spin_lock(&pde_openers[slot].lock);
+	list_for_each_entry(pdeo, &pde_openers[slot].head, lh) {
+		if (pdeo->inode == inode && pdeo->file == file) {
+			release = pdeo->release;
+			list_del(&pdeo->lh);
+			kfree(pdeo);
+			break;
+		}
+	}
+	spin_unlock(&pde_openers[slot].lock);
+	return release;
+}
+
 static int proc_reg_open(struct inode *inode, struct file *file)
 {
 	struct proc_dir_entry *pde = PDE(inode);
@@ -316,6 +394,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	int (*open)(struct inode *, struct file *);
 	int (*release)(struct inode *, struct file *);
 	struct pde_opener *pdeo;
+	const struct file_operations *fops;
 
 	/*
 	 * What for, you ask? Well, we can have open, rmmod, remove_proc_entry
@@ -331,57 +410,48 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	if (!pdeo)
 		return -ENOMEM;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		kfree(pdeo);
 		return -ENOENT;
 	}
-	pde->pde_users++;
-	open = pde->proc_fops->open;
-	release = pde->proc_fops->release;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	open = fops->open;
+	release = fops->release;
+	rcu_read_unlock();
 
 	if (open)
 		rv = open(inode, file);
 
-	spin_lock(&pde->pde_unload_lock);
 	if (rv == 0 && release) {
 		/* To know what to release. */
 		pdeo->inode = inode;
 		pdeo->file = file;
+		pdeo->pde = pde;
 		/* Strictly for "too late" ->release in proc_reg_release(). */
 		pdeo->release = release;
-		list_add(&pdeo->lh, &pde->pde_openers);
-	} else
-		kfree(pdeo);
-	__pde_users_dec(pde);
-	spin_unlock(&pde->pde_unload_lock);
+		pde_openers_add(pdeo);
+		pdeo = NULL;
+	}
+	pde_users_dec(pde);
+	kfree(pdeo);
 	return rv;
 }
 
-static struct pde_opener *find_pde_opener(struct proc_dir_entry *pde,
-					struct inode *inode, struct file *file)
-{
-	struct pde_opener *pdeo;
-
-	list_for_each_entry(pdeo, &pde->pde_openers, lh) {
-		if (pdeo->inode == inode && pdeo->file == file)
-			return pdeo;
-	}
-	return NULL;
-}
 
 static int proc_reg_release(struct inode *inode, struct file *file)
 {
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	int (*release)(struct inode *, struct file *);
-	struct pde_opener *pdeo;
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	pdeo = find_pde_opener(pde, inode, file);
-	if (!pde->proc_fops) {
+	release = pde_opener_del(inode, file);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
 		/*
 		 * Can't simply exit, __fput() will think that everything is OK,
 		 * and move on to freeing struct file. remove_proc_entry() will
@@ -390,22 +460,14 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 		 *
 		 * But if opener is removed from list, who will ->release it?
 		 */
-		if (pdeo) {
-			list_del(&pdeo->lh);
-			spin_unlock(&pde->pde_unload_lock);
-			rv = pdeo->release(inode, file);
-			kfree(pdeo);
-		} else
-			spin_unlock(&pde->pde_unload_lock);
+		rcu_read_unlock();
+		if (release)
+			release(inode, file);
 		return rv;
 	}
-	pde->pde_users++;
-	release = pde->proc_fops->release;
-	if (pdeo) {
-		list_del(&pdeo->lh);
-		kfree(pdeo);
-	}
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	release = fops->release;
+	rcu_read_unlock();
 
 	if (release)
 		rv = release(inode, file);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index e1167a1..da166be 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -97,12 +97,14 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
 		filldir_t filldir);
 
 struct pde_opener {
+	struct proc_dir_entry *pde;
 	struct inode *inode;
 	struct file *file;
 	int (*release)(struct inode *, struct file *);
 	struct list_head lh;
 };
 void pde_users_dec(struct proc_dir_entry *pde);
+void pde_openers_purge(struct proc_dir_entry *pde, struct list_head *queue);
 
 extern spinlock_t proc_subdir_lock;
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 3fd2e87..35766c1 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -64,16 +64,13 @@ struct proc_dir_entry {
 	 * If you're allocating ->proc_fops dynamically, save a pointer
 	 * somewhere.
 	 */
-	const struct file_operations *proc_fops;
+	const struct file_operations __rcu *proc_fops;
 	struct proc_dir_entry *next, *parent, *subdir;
 	void *data;
 	read_proc_t *read_proc;
 	write_proc_t *write_proc;
 	atomic_t count;		/* use count */
-	int pde_users;	/* number of callers into module in progress */
-	struct completion *pde_unload_completion;
-	struct list_head pde_openers;	/* who did ->open, but not ->release */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	atomic_t pde_users;	/* number of callers into module in progress */
 	u8 namelen;
 	char name[];
 };


