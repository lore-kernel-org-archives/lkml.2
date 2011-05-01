Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab1EABpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:45:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab1EABiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fdmMwgKWwD74i3pRnYh/G5EWBgSfeoP7yU5TQZft3bcNe72/bsS6fTe0MkDSnz2w8N
         aPwstVxYCsyIT8n5MKZxVV9T6RODYNo2FO6QgcB5T+Y5j7cqXWeD14fPMMrLm5Jsg8sz
         6ytvRSKtygZtc8XGSt7OT4P3fpH24BXxOpx7Y=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 60/69] sysctl: faster tree-based sysctl implementation
Date: Sun,  1 May 2011 03:36:30 +0200
Message-Id: <1304213799-10257-61-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old implementation used inefficient algorithms both at
lookup/readdir times and at registration. This patch introduces an
improved algorithm: lower memory consumption, better time complexity
for lookup/readdir/registration. Locking is a bit heavier in this
algorithm (in this patch: reader locks for lookup/readdir, writer
locks for register/unregister; in a later patch in this series: RCU +
spin-lock). I'll address this locking issue later in this commit.

I will shortly describe the previous algorithm, the new one and brag
at the end with an endless list of improvements and new limitations.

= Old algorithm =

== Description ==
We created a ctl_table_header for each registered sysctl table. The
header's role is to maintain sysctl internal data, reference counting
and as a token to unregister the table.

All headers were put in a list in the order of registration without
regard to the position of the tables in the sysctl tree. Headers were
also 'attached' one to another to (somewhat) speed up lookup/readdir.

Attachment meant looking at each other already registered header and
comparing the paths to the tables. A newly registered header would be
attached to the first header with which it would share most of it's
path.

e.g. paths registered: /, /a/b/c, /a/b/c/d, /a/x, /a/x/y, /a/z
     tree:
  /
  + /a/b/c
     |   + /a/b/c/d
     + /a/x
     | /a/x/y
     + /a/z

== Time complexity ==

- register N tables would take O(N^2) steps (see above)

- lookup: if the item searched for is not found in the current header,
  iterate the list of headers until you find another header that's
  attached to the current position in the header's table. Lookups for
  elements that are in a header registered under the current position
  or inexistent elements would take O(N) steps each.

- readdir: after searching the current headers table in the current
  position, always do an O(N) search for a header attached to the
  current table position.

== Memory ==

Each header was allocated some data and a variable-length path.
O(1) with kzalloc/kfree.

= New algorithm =

== Description ==

Reuses the 'ctl_table_header' concept but with two distinct meanings:
- as a wrapper of a table registered by the user
- as a directory entry.

Registering the paths from the above example gives this tree:
 paths: /, /a/b/c, /a/b/c/d, /a/x, /a/x/y, /a/z
 tree:
     /: .subdirs = a
       a: .subdirs = b x z
         b: subdirs = c
            c: subdirs = d
	      d:
         x: subdirs = y
	   y:
         z:

Each directory gets a header. Each header has a parent (except root)
and two lists:
 - ctl_subdirs: list of sub-directories - other headers
 - ctl_tables: list of headers that wrap a ctl_table array

Because the directory structure is now maintained as ctl_table_header
objects, we needed to remove the .child from ctl_tables (this explains
the previous patches). A ctl_table array represents a list of files.

== Time complexity ==

- registration of N headers. Registration means adding new directories
  at each level or incrementing an existing directory's refcount.

  - O(N * lnN) - if the paths to the headers are evenly distributed

  - O(N^2) - if most of the headers registered are children of the
    same parent directory (searching the list of subdirs takes O(N)).
    There are cases where this happens (e.g. registering sysctl
    entries for net devices under /proc/sys/net/ipv4|6/conf/device).

    A few later patches will add an optimisation, to fix locations
    that might trigger the O(N^2) issue.

- lookup: O(len(subdirs) + sum(len(tarr) for each tarr in ctl_tables)
  - could be made better:
     - sort ctl_subdirs (for binary search)
     - replace ctl_subdirs with a hash-table (increase memory footprint)
     - sort ctl_table entries at registration time (for binary search).
    Could be done, but I'm too lazy to do it now.

- readdir: O(len(subdirs) + sum(len(tarr) for each tarr in ctl_tables)
   - can't get any better than this :)

== Memory complexity ==

Although we create more ctl_table_header (one for each directory, one
for each table, and because we deleted the .child from ctl_table there
are more tables registered than before this patch) we remove the need
to store a full path (from too to the table) as was done in the old
solution => a O(N) small memory gain with report to the old algo.

Also, because headers have a fixed size, we use kmem_caches => lower
fragmentation.

= Limitations =

== ctl_table does not has .child => some code uglyfication  ==

Registering tables with multiple directories and files cannot be done
in a single operation: there must be at least a table registered for
each directory. This make code that registers sysctls uglier (see the
earlier patches that remove .child form sched_domain and the root
table). Other places e.g. the parport systls look much better now
without .child: I can now read and understand that code.

== Handling of netns specific paths is weirder ==

The algorithm descriptions from above are simplifications. In reality
the code needs to handle directories and files that must be visible in
some netns' only. E.g. the /proc/sys/net/ipv4/conf/DEVICENAME/
directory and it's files must be visible only in the netns of that
device.

The old algorithm used a secondary list that indexed all netns
specific headers. All algorithms remain the same, with the mention
that besides searching the global list, the algorithm would also look
into the current netns' list of headers. This scales perfectly in
rapport to the number of network namespaces.

The new algorithm does something similar, but a bit more complicated.
We also use netns specific lists of directories/tables and store them
in a special directory ctl_table_header (which I dubbed the
"netns-correspondent" of another directory - I'm not very pleased with
the name either).

When registering a net-ns specific table, we will create a
"netns-correspondent" to the last directory that is not net-ns
specific in that path.

E.g.: we're registering a netns specific table for 'lo':
      common path: /proc/sys/net/ipv4/
       netns path: /proc/sys/net/ipv4/conf/lo/

   We'll create an (unnamed) netns correspondent for 'ipv4' which will
   have 'conf' as it's subdir.

E.g.: We're registering a netns specific file in /proc/sys/net/core/somaxconn
      common path: /proc/sys/net/core/
       netns path: /proc/sys/net/core/

We'll create an (unnamed) netns correspondent for 'core' with the
table containing 'somaxconn' in ctl_tables.

All net-ns correspondents of one netns are held in a single list, and
each netns gets it own list. This keeps the algorithm complexity
indifferent of the number of network namespaces (as was the old one).

However, now only a smaller part of directories are members of this
list, improving register/lookup/readdir time complexity.

There is one ugly limitation that stems from this approach.
E.g.: register these files in this order:
 - register common         /dir1/file-common1
 - register netns specific /dir1/dir2/file-netns
 - register common         /dir1/dir2/file-common2

  We'll have this tree:
   'dir1' { .subdirs = ['dir2'], .tables = ['file-common1'] }
     ^                    |
     |                    -> { .subdirs = [], .tables = ['file-common2'] }
     |
     | (unnamed netns-corresp for dir1)
     -> { .subdir = ['dir2'] }
                        |
                        -> { .subdirs = [], .tables = ['file-netns'] }

readdir: when we list the contents of 'dir1' we'll see it has two
         sub-directories named 'dir2' each with a file in it.

lookup: lookup of /dir1/dir2/file-netns will not work because we find
        'dir2' as a subdir of 'dir1' and stick with it and never look
        into the netns correspondent of 'dir1'.

This can be fixed in two ways:

- A) by making sure to never register a netns specific directory and
  after that register that directory as a common one. From what I can
  tell there isn't such a problem in the kernel at the moment, but I
  did not study the source in detail.

- B) by increasing the complexity of the code:

  - readdir: looking at both lists and comparing if we have already
             listed a directory as common, so we don't list twice.
             -> For imbalanced trees this can make readdir O(N^2) :(

  - register: the netns 'dir2' from the example above needs to be
              connected to the common 'dir2' when 'dir2' is
              registered. I'm not even going to thing of how time
              complexity/ugliness is going to explode here.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/proc/inode.c             |    2 +-
 fs/proc/proc_sysctl.c       |  201 ++++++++------
 include/linux/sysctl.h      |  155 ++++++-----
 include/net/net_namespace.h |    2 +-
 init/main.c                 |    2 +
 kernel/sysctl.c             |  628 ++++++++++++++++++++++++++-----------------
 kernel/sysctl_check.c       |  250 +++++++++---------
 net/sysctl_net.c            |   63 ++---
 8 files changed, 730 insertions(+), 573 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index d15aa1b..08166df 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -42,7 +42,7 @@ static void proc_evict_inode(struct inode *inode)
 	head = PROC_I(inode)->sysctl;
 	if (head) {
 		rcu_assign_pointer(PROC_I(inode)->sysctl, NULL);
-		sysctl_head_put(head);
+		sysctl_proc_inode_put(head);
 	}
 }
 
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f50133c..c0cc16b 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -26,20 +26,20 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 
 	inode->i_ino = get_next_ino();
 
-	sysctl_head_get(head);
+	sysctl_proc_inode_get(head);
 	ei = PROC_I(inode);
 	ei->sysctl = head;
 	ei->sysctl_entry = table;
 
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-	inode->i_mode = table->mode;
-	if (!table->child) {
-		inode->i_mode |= S_IFREG;
+
+	if (table) {
+		inode->i_mode = S_IFREG | table->mode;
 		inode->i_op = &proc_sys_inode_operations;
 		inode->i_fop = &proc_sys_file_operations;
 	} else {
-		inode->i_mode |= S_IFDIR;
 		inode->i_nlink = 0;
+		inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR;
 		inode->i_op = &proc_sys_dir_operations;
 		inode->i_fop = &proc_sys_dir_file_operations;
 	}
@@ -51,70 +51,76 @@ static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 {
 	int len;
 	for ( ; p->procname; p++) {
-
-		if (!p->procname)
-			continue;
-
 		len = strlen(p->procname);
 		if (len != name->len)
 			continue;
 
-		if (memcmp(p->procname, name->name, len) != 0)
-			continue;
-
-		/* I have a match */
-		return p;
+		if (memcmp(p->procname, name->name, len) == 0)
+			return p;
 	}
 	return NULL;
 }
 
-static struct ctl_table_header *grab_header(struct inode *inode)
-{
-	if (PROC_I(inode)->sysctl)
-		return sysctl_head_grab(PROC_I(inode)->sysctl);
-	else
-		return sysctl_head_next(NULL);
-}
-
 static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 					struct nameidata *nd)
 {
-	struct ctl_table_header *head = grab_header(dir);
-	struct ctl_table *table = PROC_I(dir)->sysctl_entry;
-	struct ctl_table_header *h = NULL;
+	struct ctl_table_header *head = sysctl_fs_get(PROC_I(dir)->sysctl);
 	struct qstr *name = &dentry->d_name;
-	struct ctl_table *p;
+	struct ctl_table_header *h = NULL, *found_head = NULL;
+	struct ctl_table *table = NULL;
 	struct inode *inode;
 	struct dentry *err = ERR_PTR(-ENOENT);
 
+
 	if (IS_ERR(head))
 		return ERR_CAST(head);
 
-	if (table && !table->child) {
-		WARN_ON(1);
-		goto out;
+retry:
+	sysctl_read_lock_head(head);
+
+	/* first check whether a subdirectory has the searched-for name */
+	list_for_each_entry(h, &head->ctl_subdirs, ctl_entry) {
+		if (IS_ERR(sysctl_fs_get(h)))
+			continue;
+
+		if (strcmp(name->name, h->dirname) == 0) {
+			found_head = h;
+			goto search_finished;
+		}
+		sysctl_fs_put(h);
 	}
 
-	table = table ? table->child : head->ctl_table;
+	/* no subdir with that name, look for the file in the ctl_tables */
+	list_for_each_entry(h, &head->ctl_tables, ctl_entry) {
+		if (IS_ERR(sysctl_fs_get(h)))
+			continue;
 
-	p = find_in_table(table, name);
-	if (!p) {
-		for (h = sysctl_head_next(NULL); h; h = sysctl_head_next(h)) {
-			if (h->attached_to != table)
-				continue;
-			p = find_in_table(h->attached_by, name);
-			if (p)
-				break;
+		table = find_in_table(h->ctl_table_arg, name);
+		if (table) {
+			found_head = h;
+			goto search_finished;
 		}
+		sysctl_fs_put(h);
 	}
 
-	if (!p)
+search_finished:
+	sysctl_read_unlock_head(head);
+
+	if (!found_head) {
+		struct ctl_table_header *netns_corresp;
+		netns_corresp = sysctl_fs_get_netns_corresp(head);
+		if (netns_corresp) {
+			sysctl_fs_put(head);
+			head = netns_corresp;
+			goto retry;
+		}
+	}
+	if (!found_head)
 		goto out;
 
 	err = ERR_PTR(-ENOMEM);
-	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	if (h)
-		sysctl_head_finish(h);
+	inode = proc_sys_make_inode(dir->i_sb, found_head, table);
+	sysctl_fs_put(found_head);
 
 	if (!inode)
 		goto out;
@@ -124,7 +130,7 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 	d_add(dentry, inode);
 
 out:
-	sysctl_head_finish(head);
+	sysctl_fs_put(head);
 	return err;
 }
 
@@ -132,7 +138,7 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
 		size_t count, loff_t *ppos, int write)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct ctl_table_header *head = grab_header(inode);
+	struct ctl_table_header *head = sysctl_fs_get(PROC_I(inode)->sysctl);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 	ssize_t error;
 	size_t res;
@@ -145,7 +151,7 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
 	 * and won't be until we finish.
 	 */
 	error = -EPERM;
-	if (sysctl_perm(head->root, table, write ? MAY_WRITE : MAY_READ))
+	if (sysctl_perm(head->ctl_group, table, write ? MAY_WRITE : MAY_READ))
 		goto out;
 
 	/* if that can happen at all, it should be -EINVAL, not -EISDIR */
@@ -159,7 +165,7 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
 	if (!error)
 		error = res;
 out:
-	sysctl_head_finish(head);
+	sysctl_fs_put(head);
 
 	return error;
 }
@@ -188,8 +194,8 @@ static int proc_sys_fill_cache(struct file *filp, void *dirent,
 	ino_t ino = 0;
 	unsigned type = DT_UNKNOWN;
 
-	qname.name = table->procname;
-	qname.len  = strlen(table->procname);
+	qname.name = table ? table->procname : head->dirname;
+	qname.len  = strlen(qname.name);
 	qname.hash = full_name_hash(qname.name, qname.len);
 
 	child = d_lookup(dir, &qname);
@@ -215,50 +221,69 @@ static int proc_sys_fill_cache(struct file *filp, void *dirent,
 	return !!filldir(dirent, qname.name, qname.len, filp->f_pos, ino, type);
 }
 
-static int scan(struct ctl_table_header *head, ctl_table *table,
+static int scan(struct ctl_table_header *head,
 		unsigned long *pos, struct file *file,
 		void *dirent, filldir_t filldir)
 {
+	struct ctl_table_header *h;
+	int res = 0;
 
-	for (; table->procname; table++, (*pos)++) {
-		int res;
+	sysctl_read_lock_head(head);
 
-		/* Can't do anything without a proc name */
-		if (!table->procname)
+	list_for_each_entry(h, &head->ctl_subdirs, ctl_entry) {
+		if (*pos < file->f_pos) {
+			(*pos)++;
 			continue;
+		}
 
-		if (*pos < file->f_pos)
+		if (IS_ERR(sysctl_fs_get(h)))
 			continue;
 
-		res = proc_sys_fill_cache(file, dirent, filldir, head, table);
+		res = proc_sys_fill_cache(file, dirent, filldir, h, NULL);
+		sysctl_fs_put(h);
 		if (res)
-			return res;
+			goto out;
 
 		file->f_pos = *pos + 1;
+		(*pos)++;
 	}
-	return 0;
+
+	list_for_each_entry(h, &head->ctl_tables, ctl_entry) {
+		ctl_table *t;
+
+		if (IS_ERR(sysctl_fs_get(h)))
+			continue;
+
+		for (t = h->ctl_table_arg; t->procname; t++, (*pos)++) {
+			if (*pos < file->f_pos)
+				continue;
+
+			res = proc_sys_fill_cache(file, dirent, filldir, h, t);
+			if (res) {
+				sysctl_fs_put(h);
+				goto out;
+			}
+			file->f_pos = *pos + 1;
+		}
+		sysctl_fs_put(h);
+	}
+
+out:
+	sysctl_read_unlock_head(head);
+	return res;
 }
 
 static int proc_sys_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	struct ctl_table_header *head = grab_header(inode);
-	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
-	struct ctl_table_header *h = NULL;
+	struct ctl_table_header *head = sysctl_fs_get(PROC_I(inode)->sysctl);
 	unsigned long pos;
 	int ret = -EINVAL;
 
 	if (IS_ERR(head))
 		return PTR_ERR(head);
 
-	if (table && !table->child) {
-		WARN_ON(1);
-		goto out;
-	}
-
-	table = table ? table->child : head->ctl_table;
-
 	ret = 0;
 	/* Avoid a switch here: arm builds fail with missing __cmpdi2 */
 	if (filp->f_pos == 0) {
@@ -274,23 +299,25 @@ static int proc_sys_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		filp->f_pos++;
 	}
 	pos = 2;
-
-	ret = scan(head, table, &pos, filp, dirent, filldir);
-	if (ret)
-		goto out;
-
-	for (h = sysctl_head_next(NULL); h; h = sysctl_head_next(h)) {
-		if (h->attached_to != table)
-			continue;
-		ret = scan(h, h->attached_by, &pos, filp, dirent, filldir);
-		if (ret) {
-			sysctl_head_finish(h);
-			break;
+	ret = scan(head, &pos, filp, dirent, filldir);
+	if (!ret) {
+		/* the netns-correspondent contains only those
+		 * subdirectories that are netns-specific, and not
+		 * shared with the @head directory: there is no
+		 * possibility to list the same directory twice (once
+		 * for @head and once for @netns_corresp). Sibling
+		 * tables cannot contain the entries with the same
+		 * name, no need to worry about them either. */
+		struct ctl_table_header *netns_corresp;
+		netns_corresp = sysctl_fs_get_netns_corresp(head);
+		if (netns_corresp) {
+			ret = scan(netns_corresp, &pos, filp, dirent, filldir);
+			sysctl_fs_put(netns_corresp);
 		}
 	}
 	ret = 1;
 out:
-	sysctl_head_finish(head);
+	sysctl_fs_put(head);
 	return ret;
 }
 
@@ -311,17 +338,17 @@ static int proc_sys_permission(struct inode *inode, int mask,unsigned int flags)
 	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))
 		return -EACCES;
 
-	head = grab_header(inode);
+	head = sysctl_fs_get(PROC_I(inode)->sysctl);
 	if (IS_ERR(head))
 		return PTR_ERR(head);
 
 	table = PROC_I(inode)->sysctl_entry;
-	if (!table) /* global root - r-xr-xr-x */
+	if (!table) /* directory - r-xr-xr-x */
 		error = mask & MAY_WRITE ? -EACCES : 0;
 	else /* Use the permissions on the sysctl table entry */
-		error = sysctl_perm(head->root, table, mask);
+		error = sysctl_perm(head->ctl_group, table, mask);
 
-	sysctl_head_finish(head);
+	sysctl_fs_put(head);
 	return error;
 }
 
@@ -352,17 +379,18 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
 static int proc_sys_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
-	struct ctl_table_header *head = grab_header(inode);
+	struct ctl_table_header *head = sysctl_fs_get(PROC_I(inode)->sysctl);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 
 	if (IS_ERR(head))
 		return PTR_ERR(head);
 
 	generic_fillattr(inode, stat);
+
 	if (table)
 		stat->mode = (stat->mode & S_IFMT) | table->mode;
 
-	sysctl_head_finish(head);
+	sysctl_fs_put(head);
 	return 0;
 }
 
@@ -435,5 +463,6 @@ int __init proc_sys_init(void)
 	proc_sys_root->proc_iops = &proc_sys_dir_operations;
 	proc_sys_root->proc_fops = &proc_sys_dir_file_operations;
 	proc_sys_root->nlink = 0;
+
 	return 0;
 }
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 470e06a..cd9e789 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -934,31 +934,39 @@ enum
 
 /* For the /proc/sys support */
 struct ctl_table;
-struct nsproxy;
-struct ctl_table_root;
+struct ctl_table_header;
+struct ctl_table_group;
+struct ctl_table_group_ops;
 
-struct ctl_table_set {
-	struct list_head list;
-	struct ctl_table_set *parent;
-	int (*is_seen)(struct ctl_table_set *);
-};
+extern __init int sysctl_init(void);
 
-extern void setup_sysctl_set(struct ctl_table_set *p,
-	struct ctl_table_set *parent,
-	int (*is_seen)(struct ctl_table_set *));
+extern void sysctl_init_group(struct ctl_table_group *group,
+			      const struct ctl_table_group_ops *ops,
+			      int has_netns_corresp);
 
-struct ctl_table_header;
 
-extern void sysctl_head_get(struct ctl_table_header *);
-extern void sysctl_head_put(struct ctl_table_header *);
+/* get/put a reference to this header that
+ * will be/was stored in a procfs inode */
+extern void sysctl_proc_inode_get(struct ctl_table_header *);
+extern void sysctl_proc_inode_put(struct ctl_table_header *);
+
 extern int sysctl_is_seen(struct ctl_table_header *);
-extern struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *);
-extern struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev);
-extern struct ctl_table_header *__sysctl_head_next(struct nsproxy *namespaces,
-						struct ctl_table_header *prev);
-extern void sysctl_head_finish(struct ctl_table_header *prev);
-extern int sysctl_perm(struct ctl_table_root *root,
-		struct ctl_table *table, int op);
+extern int sysctl_perm(struct ctl_table_group *group,
+		       struct ctl_table *table, int op);
+
+/* proctect the ctl_subdirs/ctl_tables lists */
+extern void sysctl_write_lock_head(struct ctl_table_header *head);
+extern void sysctl_write_unlock_head(struct ctl_table_header *head);
+extern void sysctl_read_lock_head(struct ctl_table_header *head);
+extern void sysctl_read_unlock_head(struct ctl_table_header *head);
+
+/* get/put references to this header for transient uses inside a VFS
+ * procfs function call. Each such reference must be 'put' back before
+ * leaving the function that 'got' it. */
+extern struct ctl_table_header *sysctl_fs_get(struct ctl_table_header *);
+extern struct ctl_table_header *sysctl_fs_get_netns_corresp(struct ctl_table_header *);
+extern void sysctl_fs_put(struct ctl_table_header *prev);
+
 
 typedef struct ctl_table ctl_table;
 
@@ -986,73 +994,78 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
 
 /*
  * Register a set of sysctl names by calling __register_sysctl_paths
- * with an initialised array of struct ctl_table's.  An entry with 
- * NULL procname terminates the table.  table->de will be
- * set up by the registration and need not be initialised in advance.
- *
- * sysctl names can be mirrored automatically under /proc/sys.  The
- * procname supplied controls /proc naming.
+ * with an initialised array of struct ctl_table's. An entry with a
+ * NULL procname terminates the table.
  *
  * The table's mode will be honoured both for sys_sysctl(2) and
- * proc-fs access.
+ * proc-fs access (sys_sysctl(2) uses procfs internally).
+ *
+ * Only files can be represented by ctl_table elements. Directories
+ * are implemented with ctl_table_header objects.
  *
- * Leaf nodes in the sysctl tree will be represented by a single file
- * under /proc; non-leaf nodes will be represented by directories.  A
- * null procname disables /proc mirroring at this node.
+ * The data and maxlen fields of the ctl_table struct enable minimal
+ * validation of the values being written to be performed, and the
+ * mode field allows minimal authentication.
  *
- * sysctl(2) can automatically manage read and write requests through
- * the sysctl table.  The data and maxlen fields of the ctl_table
- * struct enable minimal validation of the values being written to be
- * performed, and the mode field allows minimal authentication.
- * 
- * There must be a proc_handler routine for any terminal nodes
- * mirrored under /proc/sys (non-terminals are handled by a built-in
- * directory handler).  Several default handlers are available to
- * cover common cases.
+ * There must be a proc_handler routine for each ctl_table node.
+ * Several default handlers are available to cover common cases.
  */
 
 /* A sysctl table is an array of struct ctl_table: */
-struct ctl_table 
-{
+struct ctl_table {
 	const char *procname;		/* Text ID for /proc/sys, or zero */
 	void *data;
 	int maxlen;
 	mode_t mode;
-	struct ctl_table *child;
-	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	void *extra1;
 	void *extra2;
 };
 
-struct ctl_table_root {
-	struct list_head root_list;
-	struct ctl_table_set default_set;
-	struct ctl_table_set *(*lookup)(struct ctl_table_root *root,
-					   struct nsproxy *namespaces);
-	int (*permissions)(struct ctl_table_root *root,
-			struct nsproxy *namespaces, struct ctl_table *table);
+struct ctl_table_group_ops {
+	/* some sysctl entries are visible only in some situations.
+	 * E.g.: /proc/sys/net/ipv4/conf/eth0/ is only visible in the
+	 * netns in which that eth0 interface lives.
+	 *
+	 * If this hook is not set, then all the sysctl entries in
+	 * this group are always visible. */
+	int (*is_seen)(struct ctl_table_group *group);
+
+	/* hook to alter permissions for some sysctl nodes at runtime */
+	int (*permissions)(struct ctl_table *table);
+};
+
+struct ctl_table_group {
+	const struct ctl_table_group_ops *ctl_ops;
+	/* A list of ctl_table_header elements that represent the
+	 * netns-specific correspondents of some sysctl directories */
+	struct list_head corresp_list;
+	/* binary: whether this group uses @corresp_list */
+	char has_netns_corresp;
 };
 
 /* struct ctl_table_header is used to maintain dynamic lists of
    struct ctl_table trees. */
-struct ctl_table_header
-{
+struct ctl_table_header {
 	union {
 		struct {
-			struct ctl_table *ctl_table;
+			/* a header is used either as a wraper for a
+			 * ctl_table array or as directory entry. */
+			union {
+				struct ctl_table *ctl_table_arg;
+				const char *dirname;
+			};
 			struct list_head ctl_entry;
-			int used;
-			int count;
+			int fs_func_refs;
+			int proc_inode_refs;
+			int header_refs;
 		};
 		struct rcu_head rcu;
 	};
 	struct completion *unregistering;
-	struct ctl_table *ctl_table_arg;
-	struct ctl_table_root *root;
-	struct ctl_table_set *set;
-	struct ctl_table *attached_by;
-	struct ctl_table *attached_to;
+	struct ctl_table_group *ctl_group;
+	struct list_head ctl_tables;
+	struct list_head ctl_subdirs;
 	struct ctl_table_header *parent;
 };
 
@@ -1061,15 +1074,19 @@ struct ctl_path {
 	const char *procname;
 };
 
-void register_sysctl_root(struct ctl_table_root *root);
-struct ctl_table_header *__register_sysctl_paths(
-	struct ctl_table_root *root, struct nsproxy *namespaces,
-	const struct ctl_path *path, struct ctl_table *table);
-struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
-						struct ctl_table *table);
-
-void unregister_sysctl_table(struct ctl_table_header * table);
-int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table);
+extern struct ctl_table_header *__register_sysctl_paths(struct ctl_table_group *g,
+							const struct ctl_path *p,
+							struct ctl_table *table);
+extern struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
+						      struct ctl_table *table);
+extern void unregister_sysctl_table(struct ctl_table_header *table);
+
+#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
+extern int sysctl_check_table(const struct ctl_path *path,
+			      int nr_dirs,
+			      struct ctl_table *table);
+extern int sysctl_check_duplicates(struct ctl_table_header *header);
+#endif /* CONFIG_SYSCTL_SYSCALL_CHECK */
 
 #endif /* __KERNEL__ */
 
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 3ae4919..871dd2b 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -52,7 +52,7 @@ struct net {
 	struct proc_dir_entry 	*proc_net_stat;
 
 #ifdef CONFIG_SYSCTL
-	struct ctl_table_set	sysctls;
+	struct ctl_table_group	netns_ctl_group;
 #endif
 
 	struct sock 		*rtnl;			/* rtnetlink socket */
diff --git a/init/main.c b/init/main.c
index 4a9479e..577bff6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -68,6 +68,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/perf_event.h>
+#include <linux/sysctl.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -595,6 +596,7 @@ asmlinkage void __init start_kernel(void)
 		efi_enter_virtual_mode();
 #endif
 	thread_info_cache_init();
+	sysctl_init();
 	cred_init();
 	fork_init(totalram_pages);
 	proc_caches_init();
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d44c280..3ff4384 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -56,6 +56,7 @@
 #include <linux/kprobes.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
+#include <linux/rwsem.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -197,18 +198,22 @@ static int sysrq_sysctl_handler(ctl_table *table, int write,
 
 #endif
 
-static struct ctl_table root_table[];
-static struct ctl_table_root sysctl_table_root;
-static struct ctl_table_header root_table_header = {
-	{{.count = 1,
-	.ctl_table = root_table,
-	.ctl_entry = LIST_HEAD_INIT(sysctl_table_root.default_set.list),}},
-	.root = &sysctl_table_root,
-	.set = &sysctl_table_root.default_set,
+static struct kmem_cache *sysctl_header_cachep;
+
+/* uses default ops and does not need the corresp_list */
+static struct ctl_table_group_ops root_table_group_ops = { };
+
+static struct ctl_table_group root_table_group = {
+	.has_netns_corresp = 0,
+	.ctl_ops = &root_table_group_ops,
 };
-static struct ctl_table_root sysctl_table_root = {
-	.root_list = LIST_HEAD_INIT(sysctl_table_root.root_list),
-	.default_set.list = LIST_HEAD_INIT(root_table_header.ctl_entry),
+
+static struct ctl_table_header root_table_header = {
+	{{.header_refs = 1,
+	  .ctl_entry	= LIST_HEAD_INIT(root_table_header.ctl_entry),}},
+	.ctl_tables	= LIST_HEAD_INIT(root_table_header.ctl_tables),
+	.ctl_subdirs	= LIST_HEAD_INIT(root_table_header.ctl_subdirs),
+	.ctl_group	= &root_table_group,
 };
 
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
@@ -217,10 +222,6 @@ int sysctl_legacy_va_layout;
 
 /* The default sysctl tables: */
 
-static struct ctl_table root_table[] = {
-	{ }
-};
-
 #ifdef CONFIG_SCHED_DEBUG
 static int min_sched_granularity_ns = 100000;		/* 100 usecs */
 static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
@@ -1489,22 +1490,28 @@ static struct ctl_table dev_table[] = {
 
 static DEFINE_SPINLOCK(sysctl_lock);
 
-/* called under sysctl_lock */
-static int use_table(struct ctl_table_header *p)
+
+/* if it's deemed necessary, we can create a per-header rwsem. For now
+ * a global one will do. */
+static DECLARE_RWSEM(sysctl_rwsem);
+void sysctl_write_lock_head(struct ctl_table_header *head)
 {
-	if (unlikely(p->unregistering))
-		return 0;
-	p->used++;
-	return 1;
+	down_write(&sysctl_rwsem);
 }
-
-/* called under sysctl_lock */
-static void unuse_table(struct ctl_table_header *p)
+void sysctl_write_unlock_head(struct ctl_table_header *head)
 {
-	if (!--p->used)
-		if (unlikely(p->unregistering))
-			complete(p->unregistering);
+	up_write(&sysctl_rwsem);
 }
+void sysctl_read_lock_head(struct ctl_table_header *head)
+{
+	down_read(&sysctl_rwsem);
+}
+void sysctl_read_unlock_head(struct ctl_table_header *head)
+{
+	up_read(&sysctl_rwsem);
+}
+
+
 
 /* called under sysctl_lock, will reacquire if has to wait */
 static void start_unregistering(struct ctl_table_header *p)
@@ -1513,7 +1520,7 @@ static void start_unregistering(struct ctl_table_header *p)
 	 * if p->used is 0, nobody will ever touch that entry again;
 	 * we'll eliminate all paths to it before dropping sysctl_lock
 	 */
-	if (unlikely(p->used)) {
+	if (unlikely(p->fs_func_refs)) {
 		struct completion wait;
 		init_completion(&wait);
 		p->unregistering = &wait;
@@ -1524,123 +1531,105 @@ static void start_unregistering(struct ctl_table_header *p)
 		/* anything non-NULL; we'll never dereference it */
 		p->unregistering = ERR_PTR(-EINVAL);
 	}
-	/*
-	 * do not remove from the list until nobody holds it; walking the
-	 * list in do_sysctl() relies on that.
-	 */
-	list_del_init(&p->ctl_entry);
 }
 
-void sysctl_head_get(struct ctl_table_header *head)
+void sysctl_proc_inode_get(struct ctl_table_header *head)
 {
 	spin_lock(&sysctl_lock);
-	head->count++;
+	head->proc_inode_refs++;
 	spin_unlock(&sysctl_lock);
 }
 
 static void free_head(struct rcu_head *rcu)
 {
-	kfree(container_of(rcu, struct ctl_table_header, rcu));
+	struct ctl_table_header *header;
+	header = container_of(rcu, struct ctl_table_header, rcu);
+	kmem_cache_free(sysctl_header_cachep, header);
 }
 
-void sysctl_head_put(struct ctl_table_header *head)
+void sysctl_proc_inode_put(struct ctl_table_header *head)
 {
 	spin_lock(&sysctl_lock);
-	if (!--head->count)
+	head->proc_inode_refs--;
+	if ((head->header_refs == 0) && (head->proc_inode_refs == 0))
 		call_rcu(&head->rcu, free_head);
 	spin_unlock(&sysctl_lock);
 }
 
-struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *head)
+/* called under sysctl_lock */
+static struct ctl_table_header *__sysctl_fs_get(struct ctl_table_header *head)
+{
+	if (unlikely(head->unregistering))
+		return ERR_PTR(-ENOENT);
+
+	head->fs_func_refs++;
+	return head;
+}
+
+struct ctl_table_header *sysctl_fs_get(struct ctl_table_header *head)
 {
 	if (!head)
-		BUG();
+		head = &root_table_header;
+
 	spin_lock(&sysctl_lock);
-	if (!use_table(head))
-		head = ERR_PTR(-ENOENT);
+	head = __sysctl_fs_get(head);
 	spin_unlock(&sysctl_lock);
 	return head;
 }
 
-void sysctl_head_finish(struct ctl_table_header *head)
+void sysctl_fs_put(struct ctl_table_header *head)
 {
 	if (!head)
 		return;
 	spin_lock(&sysctl_lock);
-	unuse_table(head);
-	spin_unlock(&sysctl_lock);
-}
 
-static struct ctl_table_set *
-lookup_header_set(struct ctl_table_root *root, struct nsproxy *namespaces)
-{
-	struct ctl_table_set *set = &root->default_set;
-	if (root->lookup)
-		set = root->lookup(root, namespaces);
-	return set;
-}
+	if (!--head->fs_func_refs)
+		if (unlikely(head->unregistering))
+			complete(head->unregistering);
 
-static struct list_head *
-lookup_header_list(struct ctl_table_root *root, struct nsproxy *namespaces)
-{
-	struct ctl_table_set *set = lookup_header_set(root, namespaces);
-	return &set->list;
+	spin_unlock(&sysctl_lock);
 }
 
-struct ctl_table_header *__sysctl_head_next(struct nsproxy *namespaces,
-					    struct ctl_table_header *prev)
+/* must be called with set protector lock (currently this is sysctl_lock) */
+static struct ctl_table_header *sysctl_fs_get_netns_corresp_dflt(
+	struct ctl_table_group *group,
+	struct ctl_table_header *head,
+	struct ctl_table_header *dflt)
 {
-	struct ctl_table_root *root;
-	struct list_head *header_list;
-	struct ctl_table_header *head;
-	struct list_head *tmp;
+	struct ctl_table_header *h, *ret = NULL;
 
 	spin_lock(&sysctl_lock);
-	if (prev) {
-		head = prev;
-		tmp = &prev->ctl_entry;
-		unuse_table(prev);
-		goto next;
-	}
-	tmp = &root_table_header.ctl_entry;
-	for (;;) {
-		head = list_entry(tmp, struct ctl_table_header, ctl_entry);
 
-		if (!use_table(head))
-			goto next;
-		spin_unlock(&sysctl_lock);
-		return head;
-	next:
-		root = head->root;
-		tmp = tmp->next;
-		header_list = lookup_header_list(root, namespaces);
-		if (tmp != header_list)
+	list_for_each_entry(h, &group->corresp_list, ctl_entry) {
+		if (h->parent != head)
 			continue;
-
-		do {
-			root = list_entry(root->root_list.next,
-					struct ctl_table_root, root_list);
-			if (root == &sysctl_table_root)
-				goto out;
-			header_list = lookup_header_list(root, namespaces);
-		} while (list_empty(header_list));
-		tmp = header_list->next;
+		if (IS_ERR(__sysctl_fs_get(h)))
+			continue;
+		ret = h;
+		goto out;
 	}
+
+	if (!dflt)
+		goto out;
+
+	/* will not fail because dflt is a brand-new header that no
+	 * one has seen yet, so no one has started to unregister it */
+	dflt = __sysctl_fs_get(dflt);
+	dflt->parent = head;
+	list_add_tail(&dflt->ctl_entry, &group->corresp_list);
+	ret = dflt;
+
 out:
 	spin_unlock(&sysctl_lock);
-	return NULL;
-}
-
-struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev)
-{
-	return __sysctl_head_next(current->nsproxy, prev);
+	return ret;
 }
 
-void register_sysctl_root(struct ctl_table_root *root)
+struct ctl_table_header *sysctl_fs_get_netns_corresp(struct ctl_table_header *h)
 {
-	spin_lock(&sysctl_lock);
-	list_add_tail(&root->root_list, &sysctl_table_root.root_list);
-	spin_unlock(&sysctl_lock);
+	struct ctl_table_group *g = &current->nsproxy->net_ns->netns_ctl_group;
+	/* dflt == NULL means: if there's a set-part return it,
+	 *                     if there isn't, just return NULL */
+	return sysctl_fs_get_netns_corresp_dflt(g, h, NULL);
 }
 
 /*
@@ -1659,28 +1648,21 @@ static int test_perm(int mode, int op)
 	return -EACCES;
 }
 
-int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
+int sysctl_perm(struct ctl_table_group *group, struct ctl_table *table, int op)
 {
 	int mode;
 
-	if (root->permissions)
-		mode = root->permissions(root, current->nsproxy, table);
+	if (group->ctl_ops->permissions)
+		mode = group->ctl_ops->permissions(table);
 	else
 		mode = table->mode;
 
 	return test_perm(mode, op);
 }
 
-static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
-{
-	for (; table->procname; table++) {
-		table->parent = parent;
-		if (table->child)
-			sysctl_set_parent(table, table->child);
-	}
-}
+static void sysctl_header_ctor(void *data);
 
-static __init int sysctl_init(void)
+__init int sysctl_init(void)
 {
 	struct ctl_table_header *kern_header, *vm_header, *fs_header,
 		*debug_header, *dev_header;
@@ -1688,7 +1670,11 @@ static __init int sysctl_init(void)
 	struct ctl_table_header *binfmt_misc_header;
 #endif
 
-	sysctl_set_parent(NULL, root_table);
+	sysctl_header_cachep = kmem_cache_create("sysctl_header_cachep",
+					       sizeof(struct ctl_table_header),
+					       0, 0, &sysctl_header_ctor);
+	if (!sysctl_header_cachep)
+		goto fail_alloc_cachep;
 
 	kern_header = register_sysctl_paths(kern_path, kern_table);
 	if (kern_header == NULL)
@@ -1716,10 +1702,6 @@ static __init int sysctl_init(void)
 		goto fail_register_binfmt_misc;
 #endif
 
-
-#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
-	sysctl_check_table(current->nsproxy, root_table);
-#endif
 	return 0;
 
 
@@ -1737,62 +1719,233 @@ fail_register_fs:
 fail_register_vm:
 	unregister_sysctl_table(kern_header);
 fail_register_kern:
+	kmem_cache_destroy(sysctl_header_cachep);
+fail_alloc_cachep:
 	return -ENOMEM;
 }
 
-core_initcall(sysctl_init);
+static void header_refs_inc(struct ctl_table_header*head)
+{
+	spin_lock(&sysctl_lock);
+	head->header_refs ++;
+	spin_unlock(&sysctl_lock);
+}
 
-static struct ctl_table *is_branch_in(struct ctl_table *branch,
-				      struct ctl_table *table)
+static int ctl_path_items(const struct ctl_path *path)
 {
-	struct ctl_table *p;
-	const char *s = branch->procname;
+	int n = 0;
+	while (path->procname) {
+		path++;
+		n++;
+	}
+	return n;
+}
 
-	/* branch should have named subdirectory as its first element */
-	if (!s || !branch->child)
-		return NULL;
+static void sysctl_header_ctor(void *data)
+{
+	struct ctl_table_header *h = data;
 
-	/* ... and nothing else */
-	if (branch[1].procname)
+	h->fs_func_refs = 0;
+	h->proc_inode_refs = 0;
+	h->header_refs = 0;
+
+	INIT_LIST_HEAD(&h->ctl_entry);
+	INIT_LIST_HEAD(&h->ctl_subdirs);
+	INIT_LIST_HEAD(&h->ctl_tables);
+}
+
+static struct ctl_table_header *alloc_sysctl_header(struct ctl_table_group *group)
+{
+	struct ctl_table_header *h;
+
+	h = kmem_cache_alloc(sysctl_header_cachep, GFP_KERNEL);
+	if (!h)
 		return NULL;
 
-	/* table should contain subdirectory with the same name */
-	for (p = table; p->procname; p++) {
-		if (!p->child)
+	/* - all _refs members are zero before freeing
+	 * - all list_head members point to themselves (empty lists) */
+
+	h->ctl_table_arg = NULL;
+	h->unregistering = NULL;
+	h->ctl_group = group;
+
+	return h;
+}
+
+/* Increment the references to an existing subdir of @parent with the name
+ * @name and return that subdir. If no such subdir exists, return NULL.
+ * Called under the write lock protecting parent's ctl_subdirs. */
+static struct ctl_table_header *mkdir_existing_dir(struct ctl_table_header *parent,
+						   const char *name)
+{
+	struct ctl_table_header *h;
+	list_for_each_entry(h, &parent->ctl_subdirs, ctl_entry) {
+		if (IS_ERR(sysctl_fs_get(h)))
 			continue;
-		if (p->procname && strcmp(p->procname, s) == 0)
-			return p;
+		if (strcmp(name, h->dirname) == 0) {
+			header_refs_inc(h);
+			sysctl_fs_put(h);
+			return h;
+		}
+		sysctl_fs_put(h);
 	}
 	return NULL;
 }
 
-/* see if attaching q to p would be an improvement */
-static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
+/* Some sysctl paths are netns-specific. The last directory that in
+ * not net-ns specific will have a corespondent dir in the netns
+ * specific ctl_table_set. That corespondent will hold the lists of
+ * netns specific tables and subdirectories.
+ *
+ * E.g.: registering netns/interface specific directories:
+ *       common path: /proc/sys/net/ipv4/
+ *        netns path: /proc/sys/net/ipv4/conf/lo/
+ * We'll create an (unnamed) netns correspondent for 'ipv4' which will
+ * have 'conf' as it's subdir.
+ *
+ * E.g.: We're registering a netns specific file in /proc/sys/net/core/somaxconn
+ *       common path: /proc/sys/net/core/
+ *        netns path: /proc/sys/net/core/
+ * We'll create an (unnamed) netns correspondent for 'core'.
+ */
+static struct ctl_table_header *mkdir_netns_corresp(
+	struct ctl_table_header *parent,
+	struct ctl_table_group *group,
+	struct ctl_table_header **__netns_corresp)
+{
+	struct ctl_table_header *ret;
+
+	ret = sysctl_fs_get_netns_corresp_dflt(group, parent, *__netns_corresp);
+
+	/* *__netns_corresp is a pre-allocated header. If we used it
+            here, we have to tell the caller so it won't free it. */
+	if (*__netns_corresp == ret)
+		*__netns_corresp = NULL;
+
+	header_refs_inc(ret);
+	sysctl_fs_put(ret);
+	return ret;
+}
+
+/* Add @dir as a subdir of @parent.
+ * Called under the write lock protecting parent's ctl_subdirs. */
+static struct ctl_table_header *mkdir_new_dir(struct ctl_table_header *parent,
+					      struct ctl_table_header *dir)
 {
-	struct ctl_table *to = p->ctl_table, *by = q->ctl_table;
-	struct ctl_table *next;
-	int is_better = 0;
-	int not_in_parent = !p->attached_by;
+	dir->parent = parent;
+	header_refs_inc(dir);
+	list_add_tail(&dir->ctl_entry, &parent->ctl_subdirs);
+	return dir;
+}
+
+/*
+ * Attach the branch denoted by @dirs (a series of directories that
+ * are children of their predecessor in the array) to @parent.
+ *
+ * If at a level there exist in the parent tree a node with the same
+ * name as the one we're trying to add, increment that nodes'
+ * @count. If not, add that dir as a subdir of it's parent.
+ *
+ * Nodes that remain non-NULL in @dirs must be freed by the caller as
+ * they were not added to the tree.
+ *
+ * Return the corresponding ctl_table_header for dirs[nr_dirs-1] from
+ * the tree (either one added by this function, or one already in the
+ * tree).
+ */
+static struct ctl_table_header *sysctl_mkdirs(struct ctl_table_header *parent,
+					      struct ctl_table_group *group,
+					      const struct ctl_path *path,
+					      int nr_dirs)
+{
+	struct ctl_table_header *dirs[CTL_MAXNAME];
+	struct ctl_table_header *__netns_corresp = NULL;
+	int create_first_netns_corresp = group->has_netns_corresp;
+	int i;
+
+	/* We create excess ctl_table_header for directory entries.
+	 * We do so because we may need new headers while under a lock
+	 * where we will not be able to allocate entries (sleeping).
+	 * Also, this simplifies handling of ENOMEM: no need to remove
+	 * already allocated/added directories and unlink them from
+	 * their parent directories. Stuff that is not used will be
+	 * freed at the end. */
+	for (i = 0; i < nr_dirs; i++) {
+		dirs[i] = alloc_sysctl_header(group);
+		if (!dirs[i])
+			goto err_alloc_dir;
+		dirs[i]->dirname = path[i].procname;
+	}
 
-	while ((next = is_branch_in(by, to)) != NULL) {
-		if (by == q->attached_by)
-			is_better = 1;
-		if (to == p->attached_by)
-			not_in_parent = 1;
-		by = by->child;
-		to = next->child;
+	if (create_first_netns_corresp) {
+		/* The netns correspondent for the last common path
+		 * component migh exist.  However we will only know
+		 * this later while being under a lock. We
+		 * pre-allocate it just in case it might be needed and
+		 * free it at the end only if it wasn't used. */
+		__netns_corresp = alloc_sysctl_header(group);
+		if (!__netns_corresp)
+			goto err_alloc_coresp;
 	}
 
-	if (is_better && not_in_parent) {
-		q->attached_by = by;
-		q->attached_to = to;
-		q->parent = p;
+	header_refs_inc(parent);
+
+	for (i = 0; i < nr_dirs; i++) {
+		struct ctl_table_header *h;
+
+	retry:
+		sysctl_write_lock_head(parent);
+
+		h = mkdir_existing_dir(parent, dirs[i]->dirname);
+		if (h != NULL) {
+			sysctl_write_unlock_head(parent);
+			parent = h;
+			continue;
+		}
+
+		if (likely(!create_first_netns_corresp)) {
+			h = mkdir_new_dir(parent, dirs[i]);
+			sysctl_write_unlock_head(parent);
+			parent = h;
+			dirs[i] = NULL; /* I'm used, don't free me */
+			continue;
+		}
+
+		sysctl_write_unlock_head(parent);
+
+		create_first_netns_corresp = 0;
+		parent = mkdir_netns_corresp(parent, group, &__netns_corresp);
+		/* We still have to add the new subdirectory, but
+		 * instead of adding it into the common parent, add it
+		 * to it's netns correspondent. */
+		goto retry;
 	}
+
+	if (create_first_netns_corresp)
+		parent = mkdir_netns_corresp(parent, group, &__netns_corresp);
+
+	if (__netns_corresp)
+		kmem_cache_free(sysctl_header_cachep, __netns_corresp);
+
+	/* free unused pre-allocated entries */
+	for (i = 0; i < nr_dirs; i++)
+		if (dirs[i])
+			kmem_cache_free(sysctl_header_cachep, dirs[i]);
+
+	return parent;
+
+err_alloc_coresp:
+	i = nr_dirs;
+err_alloc_dir:
+	for (i--; i >= 0; i--)
+		kmem_cache_free(sysctl_header_cachep, dirs[i]);
+	return NULL;
+
 }
 
 /**
  * __register_sysctl_paths - register a sysctl hierarchy
- * @root: List of sysctl headers to register on
+ * @group: Group of sysctl headers to register on
  * @namespaces: Data to compute which lists of sysctl entries are visible
  * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
@@ -1811,9 +1964,6 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
  *
  * mode - the file permissions for the /proc/sys file, and for sysctl(2)
  *
- * child - a pointer to the child sysctl table if this entry is a directory, or
- *         %NULL.
- *
  * proc_handler - the text handler routine (described below)
  *
  * de - for internal use by the sysctl routines
@@ -1844,77 +1994,46 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
  * to the table header on success.
  */
 struct ctl_table_header *__register_sysctl_paths(
-	struct ctl_table_root *root,
-	struct nsproxy *namespaces,
-	const struct ctl_path *path, struct ctl_table *table)
+	struct ctl_table_group *group,
+	const struct ctl_path *path,
+	struct ctl_table *table)
 {
 	struct ctl_table_header *header;
-	struct ctl_table *new, **prevp;
-	unsigned int n, npath;
-	struct ctl_table_set *set;
+	int failed_duplicate_check = 0;
+	int nr_dirs = ctl_path_items(path);
 
-	/* Count the path components */
-	for (npath = 0; path[npath].procname; ++npath)
-		;
+#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
+	if (sysctl_check_table(path, nr_dirs, table))
+		return NULL;
+#endif
 
-	/*
-	 * For each path component, allocate a 2-element ctl_table array.
-	 * The first array element will be filled with the sysctl entry
-	 * for this, the second will be the sentinel (procname == 0).
-	 *
-	 * We allocate everything in one go so that we don't have to
-	 * worry about freeing additional memory in unregister_sysctl_table.
-	 */
-	header = kzalloc(sizeof(struct ctl_table_header) +
-			 (2 * npath * sizeof(struct ctl_table)), GFP_KERNEL);
+	header = alloc_sysctl_header(group);
 	if (!header)
 		return NULL;
 
-	new = (struct ctl_table *) (header + 1);
-
-	/* Now connect the dots */
-	prevp = &header->ctl_table;
-	for (n = 0; n < npath; ++n, ++path) {
-		/* Copy the procname */
-		new->procname = path->procname;
-		new->mode     = 0555;
-
-		*prevp = new;
-		prevp = &new->child;
-
-		new += 2;
+	header->parent = sysctl_mkdirs(&root_table_header, group, path, nr_dirs);
+	if (!header->parent) {
+		kmem_cache_free(sysctl_header_cachep, header);
+		return NULL;
 	}
-	*prevp = table;
+
 	header->ctl_table_arg = table;
+	header->header_refs = 1;
+
+	sysctl_write_lock_head(header->parent);
 
-	INIT_LIST_HEAD(&header->ctl_entry);
-	header->used = 0;
-	header->unregistering = NULL;
-	header->root = root;
-	sysctl_set_parent(NULL, header->ctl_table);
-	header->count = 1;
 #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
-	if (sysctl_check_table(namespaces, header->ctl_table)) {
-		kfree(header);
-		return NULL;
-	}
+	failed_duplicate_check = sysctl_check_duplicates(header);
 #endif
-	spin_lock(&sysctl_lock);
-	header->set = lookup_header_set(root, namespaces);
-	header->attached_by = header->ctl_table;
-	header->attached_to = root_table;
-	header->parent = &root_table_header;
-	for (set = header->set; set; set = set->parent) {
-		struct ctl_table_header *p;
-		list_for_each_entry(p, &set->list, ctl_entry) {
-			if (p->unregistering)
-				continue;
-			try_attach(p, header);
-		}
+	if (!failed_duplicate_check)
+		list_add_tail(&header->ctl_entry, &header->parent->ctl_tables);
+
+	sysctl_write_unlock_head(header->parent);
+
+	if (failed_duplicate_check) {
+		unregister_sysctl_table(header);
+		return NULL;
 	}
-	header->parent->count++;
-	list_add_tail(&header->ctl_entry, &header->set->list);
-	spin_unlock(&sysctl_lock);
 
 	return header;
 }
@@ -1932,57 +2051,67 @@ struct ctl_table_header *__register_sysctl_paths(
 struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 						struct ctl_table *table)
 {
-	return __register_sysctl_paths(&sysctl_table_root, current->nsproxy,
-					path, table);
+	return __register_sysctl_paths(&root_table_group, path, table);
 }
 
 /**
  * unregister_sysctl_table - unregister a sysctl table hierarchy
- * @header: the header returned from __register_sysctl_paths
+ * @h: the header returned from __register_sysctl_paths
  *
  * Unregisters the sysctl table and all children. proc entries may not
  * actually be removed until they are no longer used by anyone.
  */
-void unregister_sysctl_table(struct ctl_table_header * header)
+void unregister_sysctl_table(struct ctl_table_header *header)
 {
 	might_sleep();
 
-	if (header == NULL)
-		return;
+	while(header) {
+		struct ctl_table_header *parent = header->parent;
 
-	spin_lock(&sysctl_lock);
-	start_unregistering(header);
-	if (!--header->parent->count) {
-		WARN_ON(1);
-		call_rcu(&header->parent->rcu, free_head);
+		/* ctl_entry is a member of the parent's ctl_tables or
+		 * ctl_subdirs lists which are protected by the
+		 * parent's write lock. */
+		sysctl_write_lock_head(parent);
+
+		/* the three counters (header_refs, proc_inode_refs and
+		 * used) are protected by the spin lock */
+
+		spin_lock(&sysctl_lock);
+		if (!--header->header_refs) {
+			start_unregistering(header);
+			list_del_init(&header->ctl_entry);
+			if (!header->proc_inode_refs)
+				call_rcu(&header->rcu, free_head);
+		}
+		spin_unlock(&sysctl_lock);
+
+		sysctl_write_unlock_head(parent);
+		header = parent;
 	}
-	if (!--header->count)
-		call_rcu(&header->rcu, free_head);
-	spin_unlock(&sysctl_lock);
 }
 
-int sysctl_is_seen(struct ctl_table_header *p)
+int sysctl_is_seen(struct ctl_table_header *head)
 {
-	struct ctl_table_set *set = p->set;
-	int res;
+	struct ctl_table_group *group = head->ctl_group;
+	int ret;
 	spin_lock(&sysctl_lock);
-	if (p->unregistering)
-		res = 0;
-	else if (!set->is_seen)
-		res = 1;
+	if (head->unregistering)
+		ret = 0;
+	else if (!group->ctl_ops->is_seen)
+		ret = 1;
 	else
-		res = set->is_seen(set);
+		ret = group->ctl_ops->is_seen(group);
 	spin_unlock(&sysctl_lock);
-	return res;
+	return ret;
 }
-
-void setup_sysctl_set(struct ctl_table_set *p,
-	struct ctl_table_set *parent,
-	int (*is_seen)(struct ctl_table_set *))
+void sysctl_init_group(struct ctl_table_group *group,
+		       const struct ctl_table_group_ops *ops,
+		       int has_netns_corresp)
 {
-	INIT_LIST_HEAD(&p->list);
-	p->parent = parent ? parent : &sysctl_table_root.default_set;
-	p->is_seen = is_seen;
+	group->ctl_ops = ops;
+	group->has_netns_corresp = has_netns_corresp;
+	if (has_netns_corresp)
+		INIT_LIST_HEAD(&group->corresp_list);
 }
 
 #else /* !CONFIG_SYSCTL */
@@ -1996,15 +2125,14 @@ void unregister_sysctl_table(struct ctl_table_header * table)
 {
 }
 
-void setup_sysctl_set(struct ctl_table_set *p,
-	struct ctl_table_set *parent,
-	int (*is_seen)(struct ctl_table_set *))
+void sysctl_init_group(struct ctl_table_group *group,
+		       const struct ctl_table_group_ops *ops,
+		       int has_netns_corresp)
 {
 }
 
-void sysctl_head_put(struct ctl_table_header *head)
-{
-}
+void sysctl_proc_inode_get(struct ctl_table_header *head) { }
+void sysctl_proc_inode_put(struct ctl_table_header *head) { }
 
 #endif /* CONFIG_SYSCTL */
 
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 4e4932a..ccd39a3 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -1,160 +1,152 @@
-#include <linux/stat.h>
 #include <linux/sysctl.h>
-#include "../fs/xfs/linux-2.6/xfs_sysctl.h"
-#include <linux/sunrpc/debug.h>
 #include <linux/string.h>
-#include <net/ip_vs.h>
 
-
-static int sysctl_depth(struct ctl_table *table)
+/*
+ * @path: the path to the offender
+ * @offender is the name of a file or directory that violated some sysctl rules.
+ * @str: a message accompanying the error
+ */
+static void fail(const struct ctl_path *path,
+		 const char *offender,
+		 const char *str)
 {
-	struct ctl_table *tmp;
-	int depth;
-
-	depth = 0;
-	for (tmp = table; tmp->parent; tmp = tmp->parent)
-		depth++;
+	printk(KERN_ERR "sysctl sanity check failed: ");
 
-	return depth;
-}
-
-static struct ctl_table *sysctl_parent(struct ctl_table *table, int n)
-{
-	int i;
+	for (; path->procname; path++)
+		printk("/%s", path->procname);
 
-	for (i = 0; table && i < n; i++)
-		table = table->parent;
+	if (offender)
+		printk("/%s", offender);
 
-	return table;
+	printk(": %s\n", str);
 }
 
+#define FAIL(str) do { fail(path, t->procname, str); error = -EINVAL;} while (0)
 
-static void sysctl_print_path(struct ctl_table *table)
+int sysctl_check_table(const struct ctl_path *path,
+		       int nr_dirs,
+		       struct ctl_table *table)
 {
-	struct ctl_table *tmp;
-	int depth, i;
-	depth = sysctl_depth(table);
-	if (table->procname) {
-		for (i = depth; i >= 0; i--) {
-			tmp = sysctl_parent(table, i);
-			printk("/%s", tmp->procname?tmp->procname:"");
+	struct ctl_table *t;
+	int error = 0;
+
+	if (nr_dirs > CTL_MAXNAME - 1) {
+		fail(path, NULL, "tree too deep");
+		error = -EINVAL;
+	}
+
+	for(t = table; t->procname; t++) {
+		if ((t->proc_handler == proc_dostring) ||
+		    (t->proc_handler == proc_dointvec) ||
+		    (t->proc_handler == proc_dointvec_minmax) ||
+		    (t->proc_handler == proc_dointvec_jiffies) ||
+		    (t->proc_handler == proc_dointvec_userhz_jiffies) ||
+		    (t->proc_handler == proc_dointvec_ms_jiffies) ||
+		    (t->proc_handler == proc_doulongvec_minmax) ||
+		    (t->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
+			if (!t->data)
+				FAIL("No data");
+			if (!t->maxlen)
+				FAIL("No maxlen");
 		}
+#ifdef CONFIG_PROC_SYSCTL
+		if (!t->proc_handler)
+			FAIL("No proc_handler");
+#endif
+		if (t->mode > 0777)
+			FAIL("bogus .mode");
 	}
-	printk(" ");
+
+	if (error)
+		dump_stack();
+
+	return error;
 }
 
-static struct ctl_table *sysctl_check_lookup(struct nsproxy *namespaces,
-						struct ctl_table *table)
+
+/*
+ * @dir: the directory imediately above the offender
+ * @offender is the name of a file or directory that violated some sysctl rules.
+ */
+static void duplicate_error(struct ctl_table_header *dir,
+			    const char *offender)
 {
-	struct ctl_table_header *head;
-	struct ctl_table *ref, *test;
-	int depth, cur_depth;
-
-	depth = sysctl_depth(table);
-
-	for (head = __sysctl_head_next(namespaces, NULL); head;
-	     head = __sysctl_head_next(namespaces, head)) {
-		cur_depth = depth;
-		ref = head->ctl_table;
-repeat:
-		test = sysctl_parent(table, cur_depth);
-		for (; ref->procname; ref++) {
-			int match = 0;
-			if (cur_depth && !ref->child)
-				continue;
-
-			if (test->procname && ref->procname &&
-			    (strcmp(test->procname, ref->procname) == 0))
-					match++;
-
-			if (match) {
-				if (cur_depth != 0) {
-					cur_depth--;
-					ref = ref->child;
-					goto repeat;
-				}
-				goto out;
-			}
+	const char *names[CTL_MAXNAME];
+	int i = 0;
+
+	printk(KERN_ERR "sysctl duplicate check failed: ");
+
+	for (; dir->parent; dir = dir->parent)
+		/* dirname can be NULL: netns-correspondent
+		 * directories do not have a dirname. Their only
+		 * pourpose is to hold the list of
+		 * subdirs/subtables. They hold netns-specific
+		 * information for the parent directory. */
+		if (dir->dirname) {
+			names[i] = dir->dirname;
+			i++;
 		}
-	}
-	ref = NULL;
-out:
-	sysctl_head_finish(head);
-	return ref;
+
+	/* Print the names in the normal path order, not reversed */
+	for(i--; i >= 0; i--)
+		printk("/%s", names[i]);
+
+	printk("/%s \n", offender);
 }
 
-static void set_fail(const char **fail, struct ctl_table *table, const char *str)
+/* is there an entry in the table with the same procname? */
+static int match(struct ctl_table *table, const char *name)
 {
-	if (*fail) {
-		printk(KERN_ERR "sysctl table check failed: ");
-		sysctl_print_path(table);
-		printk(" %s\n", *fail);
-		dump_stack();
+	for ( ; table->procname; table++) {
+
+		if (strcmp(table->procname, name) == 0)
+			return 1;
 	}
-	*fail = str;
+	return 0;
 }
 
-static void sysctl_check_leaf(struct nsproxy *namespaces,
-				struct ctl_table *table, const char **fail)
+
+/* Called under header->parent write lock.
+ *
+ * checks whether this header's table introduces items that have the
+ * same names as other items at the same level (other files or
+ * subdirectories of the current dir). */
+int sysctl_check_duplicates(struct ctl_table_header *header)
 {
-	struct ctl_table *ref;
+	int has_duplicates = 0;
+	struct ctl_table *table = header->ctl_table_arg;
+	struct ctl_table_header *dir = header->parent;
+	struct ctl_table_header *h;
+
+	list_for_each_entry(h, &dir->ctl_subdirs, ctl_entry) {
+		if (IS_ERR(sysctl_fs_get(h)))
+			continue;
+
+		if (match(table, h->dirname)) {
+			has_duplicates = 1;
+			duplicate_error(dir, h->dirname);
+		}
 
-	ref = sysctl_check_lookup(namespaces, table);
-	if (ref && (ref != table))
-		set_fail(fail, table, "Sysctl already exists");
-}
+		sysctl_fs_put(h);
+	}
 
-int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
-{
-	int error = 0;
-	for (; table->procname; table++) {
-		const char *fail = NULL;
+	list_for_each_entry(h, &dir->ctl_tables, ctl_entry) {
+		ctl_table *t;
 
-		if (table->parent) {
-			if (!table->parent->procname)
-				set_fail(&fail, table, "Parent without procname");
-		}
-		if (table->child) {
-			if (table->data)
-				set_fail(&fail, table, "Directory with data?");
-			if (table->maxlen)
-				set_fail(&fail, table, "Directory with maxlen?");
-			if ((table->mode & (S_IRUGO|S_IXUGO)) != table->mode)
-				set_fail(&fail, table, "Writable sysctl directory");
-			if (table->proc_handler)
-				set_fail(&fail, table, "Directory with proc_handler");
-			if (table->extra1)
-				set_fail(&fail, table, "Directory with extra1");
-			if (table->extra2)
-				set_fail(&fail, table, "Directory with extra2");
-		} else {
-			if ((table->proc_handler == proc_dostring) ||
-			    (table->proc_handler == proc_dointvec) ||
-			    (table->proc_handler == proc_dointvec_minmax) ||
-			    (table->proc_handler == proc_dointvec_jiffies) ||
-			    (table->proc_handler == proc_dointvec_userhz_jiffies) ||
-			    (table->proc_handler == proc_dointvec_ms_jiffies) ||
-			    (table->proc_handler == proc_doulongvec_minmax) ||
-			    (table->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
-				if (!table->data)
-					set_fail(&fail, table, "No data");
-				if (!table->maxlen)
-					set_fail(&fail, table, "No maxlen");
+		if (IS_ERR(sysctl_fs_get(h)))
+			continue;
+
+		for (t = h->ctl_table_arg; t->procname; t++) {
+			if (match(table, t->procname)) {
+				has_duplicates = 1;
+				duplicate_error(dir, t->procname);
 			}
-#ifdef CONFIG_PROC_SYSCTL
-			if (!table->proc_handler)
-				set_fail(&fail, table, "No proc_handler");
-#endif
-			sysctl_check_leaf(namespaces, table, &fail);
-		}
-		if (table->mode > 0777)
-			set_fail(&fail, table, "bogus .mode");
-		if (fail) {
-			set_fail(&fail, table, NULL);
-			error = -EINVAL;
 		}
-		if (table->child)
-			error |= sysctl_check_table(namespaces, table->child);
+		sysctl_fs_put(h);
 	}
-	return error;
+
+	if (has_duplicates)
+		dump_stack();
+
+	return has_duplicates;
 }
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index ca84212..c541541 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -29,21 +29,13 @@
 #include <linux/if_tr.h>
 #endif
 
-static struct ctl_table_set *
-net_ctl_header_lookup(struct ctl_table_root *root, struct nsproxy *namespaces)
+static int is_seen(struct ctl_table_group *group)
 {
-	return &namespaces->net_ns->sysctls;
-}
-
-static int is_seen(struct ctl_table_set *set)
-{
-	return &current->nsproxy->net_ns->sysctls == set;
+	return &current->nsproxy->net_ns->netns_ctl_group == group;
 }
 
 /* Return standard mode bits for table entry. */
-static int net_ctl_permissions(struct ctl_table_root *root,
-			       struct nsproxy *nsproxy,
-			       struct ctl_table *table)
+static int net_ctl_permissions(struct ctl_table *table)
 {
 	/* Allow network administrator to have same access as root. */
 	if (capable(CAP_NET_ADMIN)) {
@@ -53,35 +45,39 @@ static int net_ctl_permissions(struct ctl_table_root *root,
 	return table->mode;
 }
 
-static struct ctl_table_root net_sysctl_root = {
-	.lookup = net_ctl_header_lookup,
+static const struct ctl_table_group_ops net_sysctl_group_ops = {
+	.is_seen = is_seen,
 	.permissions = net_ctl_permissions,
 };
 
-static int net_ctl_ro_header_perms(struct ctl_table_root *root,
-		struct nsproxy *namespaces, struct ctl_table *table)
+static int net_ctl_ro_permissions(struct ctl_table *table)
 {
-	if (net_eq(namespaces->net_ns, &init_net))
+	if (net_eq(current->nsproxy->net_ns, &init_net))
 		return table->mode;
 	else
 		return table->mode & ~0222;
 }
 
-static struct ctl_table_root net_sysctl_ro_root = {
-	.permissions = net_ctl_ro_header_perms,
+static const struct ctl_table_group_ops net_sysctl_ro_group_ops = {
+	.permissions = net_ctl_ro_permissions,
+};
+static struct ctl_table_group net_sysctl_ro_group = {
+	.has_netns_corresp = 0,
+	.ctl_ops = &net_sysctl_ro_group_ops,
 };
 
 static int __net_init sysctl_net_init(struct net *net)
 {
-	setup_sysctl_set(&net->sysctls,
-			 &net_sysctl_ro_root.default_set,
-			 is_seen);
+	int has_netns_corresp = 1;
+
+	sysctl_init_group(&net->netns_ctl_group, &net_sysctl_group_ops,
+			  has_netns_corresp);
 	return 0;
 }
 
 static void __net_exit sysctl_net_exit(struct net *net)
 {
-	WARN_ON(!list_empty(&net->sysctls.list));
+	WARN_ON(!list_empty(&net->netns_ctl_group.corresp_list));
 }
 
 static struct pernet_operations sysctl_pernet_ops = {
@@ -89,36 +85,29 @@ static struct pernet_operations sysctl_pernet_ops = {
 	.exit = sysctl_net_exit,
 };
 
-static __init int sysctl_init(void)
+static __init int net_sysctl_init(void)
 {
 	int ret;
 	ret = register_pernet_subsys(&sysctl_pernet_ops);
 	if (ret)
 		goto out;
-	register_sysctl_root(&net_sysctl_root);
-	setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL, NULL);
-	register_sysctl_root(&net_sysctl_ro_root);
 out:
 	return ret;
 }
-subsys_initcall(sysctl_init);
+subsys_initcall(net_sysctl_init);
 
 struct ctl_table_header *register_net_sysctl_table(struct net *net,
-	const struct ctl_path *path, struct ctl_table *table)
+						   const struct ctl_path *path,
+						   struct ctl_table *table)
 {
-	struct nsproxy namespaces;
-	namespaces = *current->nsproxy;
-	namespaces.net_ns = net;
-	return __register_sysctl_paths(&net_sysctl_root,
-					&namespaces, path, table);
+	return __register_sysctl_paths(&net->netns_ctl_group, path, table);
 }
 EXPORT_SYMBOL_GPL(register_net_sysctl_table);
 
-struct ctl_table_header *register_net_sysctl_rotable(const
-		struct ctl_path *path, struct ctl_table *table)
+struct ctl_table_header *register_net_sysctl_rotable(const struct ctl_path *path,
+						     struct ctl_table *table)
 {
-	return __register_sysctl_paths(&net_sysctl_ro_root,
-			&init_nsproxy, path, table);
+	return __register_sysctl_paths(&net_sysctl_ro_group, path, table);
 }
 EXPORT_SYMBOL_GPL(register_net_sysctl_rotable);
 
-- 
1.7.5.134.g1c08b

