Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab2FIFWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 01:22:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55538 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2FIFWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 01:22:43 -0400
Date: Sat, 9 Jun 2012 06:22:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: seq_file dangerous assumption?
Message-ID: <20120609052242.GW30000@ZenIV.linux.org.uk>
References: <CAFkjPTkmgMY_TkUHvCmN0iQ9Hx4ADBVCLXGrQB8uMyoF0xMj0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFkjPTkmgMY_TkUHvCmN0iQ9Hx4ADBVCLXGrQB8uMyoF0xMj0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 02:32:02PM -0500, Eric Van Hensbergen wrote:

> In other words, if something is in file->private_data, then we must
> have already allocated and put our structure there.  In the case of
> this driver, file->private_data was already populated (with a pointer
> to the device structure) -- so the call to seq_open zero'd a portion
> of the device structure and then corrupted it with a seq_file
> structure.
> 
> So, an obvious solution is, don't use seq_file with a character device
> -- but shouldn't there also be a fingerprint or something in the
> seq_file structure as a sanity check so foolish developers don't trip
> over it and corrupt their kernel memory?

So embed seq_file into whatever struct you have there, set ->private_data
to that field and use container_of() to get to it in ->show() and iterator.
seq_open() sets ->private_data only if you have left it NULL; it's perfectly
OK to set it to struct seq_file - seq_open() will initialize and use it.

IOW, seq_file use is compatible with having driver-specific data object
reachable via ->private_data.  Not a problem...

Mind you, I wanted to point you to fs/proc_namespace.c for the example of
use, but it's horribly convoluted.  Let me clean it up a bit; hopefully
that'll make it more understandable:
    
don't rely on proc_mounts->m being the first field; container_of()
is there for purpose.  No need to bother with ->private, while
we are at it - the same container_of will do nicely.
    
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/mount.h b/fs/mount.h
index 05a2a11..4f291f9 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -74,10 +74,12 @@ static inline void get_mnt_ns(struct mnt_namespace *ns)
 }
 
 struct proc_mounts {
-	struct seq_file m; /* must be the first element */
+	struct seq_file m;
 	struct mnt_namespace *ns;
 	struct path root;
 	int (*show)(struct seq_file *, struct vfsmount *);
 };
 
+#define proc_mounts(p) (container_of((p), struct proc_mounts, m))
+
 extern const struct seq_operations mounts_op;
diff --git a/fs/namespace.c b/fs/namespace.c
index a524ea4..8f412ab 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -923,7 +923,7 @@ EXPORT_SYMBOL(replace_mount_options);
 /* iterator; we want it to have access to namespace_sem, thus here... */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	struct proc_mounts *p = container_of(m, struct proc_mounts, m);
+	struct proc_mounts *p = proc_mounts(m);
 
 	down_read(&namespace_sem);
 	return seq_list_start(&p->ns->list, *pos);
@@ -931,7 +931,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct proc_mounts *p = container_of(m, struct proc_mounts, m);
+	struct proc_mounts *p = proc_mounts(m);
 
 	return seq_list_next(v, &p->ns->list, pos);
 }
@@ -943,7 +943,7 @@ static void m_stop(struct seq_file *m, void *v)
 
 static int m_show(struct seq_file *m, void *v)
 {
-	struct proc_mounts *p = container_of(m, struct proc_mounts, m);
+	struct proc_mounts *p = proc_mounts(m);
 	struct mount *r = list_entry(v, struct mount, mnt_list);
 	return p->show(m, &r->mnt);
 }
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 5e289a7..5fe34c3 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -17,7 +17,7 @@
 
 static unsigned mounts_poll(struct file *file, poll_table *wait)
 {
-	struct proc_mounts *p = file->private_data;
+	struct proc_mounts *p = proc_mounts(file->private_data);
 	struct mnt_namespace *ns = p->ns;
 	unsigned res = POLLIN | POLLRDNORM;
 
@@ -121,7 +121,7 @@ out:
 
 static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
 {
-	struct proc_mounts *p = m->private;
+	struct proc_mounts *p = proc_mounts(m);
 	struct mount *r = real_mount(mnt);
 	struct super_block *sb = mnt->mnt_sb;
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
@@ -268,7 +268,6 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 	if (ret)
 		goto err_free;
 
-	p->m.private = p;
 	p->ns = ns;
 	p->root = root;
 	p->m.poll_event = ns->event;
@@ -288,7 +287,7 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 
 static int mounts_release(struct inode *inode, struct file *file)
 {
-	struct proc_mounts *p = file->private_data;
+	struct proc_mounts *p = proc_mounts(file->private_data);
 	path_put(&p->root);
 	put_mnt_ns(p->ns);
 	return seq_release(inode, file);
