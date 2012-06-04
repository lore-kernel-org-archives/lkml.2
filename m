Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab2FDMPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:15:54 -0400
Received: from relay.parallels.com ([195.214.232.42]:34859 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2FDMPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:15:53 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vladimir Davydov <vdavydov@parallels.com>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2] fs: make reading /proc/mounts consistent
Date: Mon, 4 Jun 2012 16:15:48 +0400
Message-ID: <1338812148-12620-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading /proc/mounts from userspace is atomic, but only within a single system
call. That means that if there are ongoing unmounts while a userspace process
is reading /proc/mounts, the process can omit some mount points.

The patch makes /proc/mounts more-or-less consistent: a userspace process is
guaranteed to read all mount points that will exist when the process closes the
file. This is achieved by keeping the position where a process stopped as a
pointer to mount entry and resuming reading from the position. If a mount entry
is removed, all processes that stopped on the entry are advanced i.e.  their
position is moved to the next entry. To achieve this, all processes reading
/proc/mounts are organized in a linked list.

An example of /proc/mounts inconsistency is here:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593516

Changes from v1:
 * make mounts readers list and corresponding lock per-namespace
 * do not lock mounts readers lock in advance_mounts_readers(), instead take
   namespace_sem for reading in register/unregister_mounts_reader() in order to
   avoid possible DOS-attack against umount caused by many processes opening/
   closing /proc/mounts
---
 fs/mount.h          |    9 +++++++
 fs/namespace.c      |   66 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/proc_namespace.c |    5 ++++
 3 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index 4ef36d9..2dde86c 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -8,6 +8,8 @@ struct mnt_namespace {
 	struct list_head	list;
 	wait_queue_head_t poll;
 	int event;
+	struct list_head mounts_readers;
+	spinlock_t mounts_readers_lock;
 };
 
 struct mnt_pcp {
@@ -70,7 +72,14 @@ struct proc_mounts {
 	struct seq_file m; /* must be the first element */
 	struct mnt_namespace *ns;
 	struct path root;
+	struct list_head *iter;
+	loff_t iter_pos;
+	int iter_advanced;
+	struct list_head reader;
 	int (*show)(struct seq_file *, struct vfsmount *);
 };
 
+extern void register_mounts_reader(struct proc_mounts *p);
+extern void unregister_mounts_reader(struct proc_mounts *p);
+
 extern const struct seq_operations mounts_op;
diff --git a/fs/namespace.c b/fs/namespace.c
index e608199..aaa7abc 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -51,6 +51,40 @@ EXPORT_SYMBOL_GPL(fs_kobj);
  */
 DEFINE_BRLOCK(vfsmount_lock);
 
+void register_mounts_reader(struct proc_mounts *p)
+{
+	struct mnt_namespace *ns = p->ns;
+
+	down_read(&namespace_sem);
+	spin_lock(&ns->mounts_readers_lock);
+	list_add(&p->reader, &ns->mounts_readers);
+	spin_unlock(&ns->mounts_readers_lock);
+	up_read(&namespace_sem);
+}
+
+void unregister_mounts_reader(struct proc_mounts *p)
+{
+	struct mnt_namespace *ns = p->ns;
+
+	down_read(&namespace_sem);
+	spin_lock(&ns->mounts_readers_lock);
+	list_del(&p->reader);
+	spin_unlock(&ns->mounts_readers_lock);
+	up_read(&namespace_sem);
+}
+
+static void advance_mounts_readers(struct mount *mnt)
+{
+	struct proc_mounts *p;
+
+	list_for_each_entry(p, &mnt->mnt_ns->mounts_readers, reader) {
+		if (p->iter == &mnt->mnt_list) {
+			p->iter = p->iter->next;
+			p->iter_advanced = 1;
+		}
+	}
+}
+
 static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 {
 	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
@@ -941,14 +975,39 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	struct proc_mounts *p = container_of(m, struct proc_mounts, m);
 
 	down_read(&namespace_sem);
-	return seq_list_start(&p->ns->list, *pos);
+	if (p->iter_advanced) {
+		p->iter_advanced = 0;
+		if (p->iter_pos < *pos)
+			p->iter_pos++;
+	}
+
+	if (!p->iter || (p->iter_pos > *pos && p->iter == &p->ns->list)) {
+		p->iter = p->ns->list.next;
+		p->iter_pos = 0;
+	}
+
+	while (p->iter_pos < *pos && p->iter != &p->ns->list) {
+		p->iter = p->iter->next;
+		p->iter_pos++;
+	}
+
+	while (p->iter_pos > *pos && p->iter != p->ns->list.next) {
+		p->iter = p->iter->prev;
+		p->iter_pos--;
+	}
+
+	p->iter_pos = *pos;
+	return p->iter != &p->ns->list ? p->iter : NULL;
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct proc_mounts *p = container_of(m, struct proc_mounts, m);
 
-	return seq_list_next(v, &p->ns->list, pos);
+	p->iter = p->iter->next;
+	p->iter_pos++;
+	*pos = p->iter_pos;
+	return p->iter != &p->ns->list ? p->iter : NULL;
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -1071,6 +1130,7 @@ void umount_tree(struct mount *mnt, int propagate, struct list_head *kill)
 
 	list_for_each_entry(p, &tmp_list, mnt_hash) {
 		list_del_init(&p->mnt_expire);
+		advance_mounts_readers(p);
 		list_del_init(&p->mnt_list);
 		__touch_mnt_namespace(p->mnt_ns);
 		p->mnt_ns = NULL;
@@ -2204,6 +2264,8 @@ static struct mnt_namespace *alloc_mnt_ns(void)
 	INIT_LIST_HEAD(&new_ns->list);
 	init_waitqueue_head(&new_ns->poll);
 	new_ns->event = 0;
+	INIT_LIST_HEAD(&new_ns->mounts_readers);
+	spin_lock_init(&new_ns->mounts_readers_lock);
 	return new_ns;
 }
 
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 1241285..4f4524d 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -273,6 +273,10 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 	p->root = root;
 	p->m.poll_event = ns->event;
 	p->show = show;
+	p->iter = NULL;
+	p->iter_pos = 0;
+	p->iter_advanced = 0;
+	register_mounts_reader(p);
 
 	return 0;
 
@@ -289,6 +293,7 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 static int mounts_release(struct inode *inode, struct file *file)
 {
 	struct proc_mounts *p = file->private_data;
+	unregister_mounts_reader(p);
 	path_put(&p->root);
 	put_mnt_ns(p->ns);
 	return seq_release(inode, file);
-- 
1.7.1

