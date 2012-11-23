Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2KWRPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:15:51 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:58435 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2KWRPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:15:50 -0500
Date: Fri, 23 Nov 2012 18:15:47 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC] [PATCH] fix infinite loop; increase robustness of
 debugfs_remove_recursive
Message-ID: <20121123171547.GB23670@soda.linbit>
Mail-Followup-To: Lars Ellenberg <lars.ellenberg@linbit.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When toying around with debugfs, intentionally trying to break things,
I managed to get it into a reproducible endless loop when cleaning up.

debugfs_remove_recursive() completely ignores that entries found
on ->d_subdirs may already be d_delete()d, but not yet d_kill()ed.

In this case, the first two entries found have both been such dentries
(d_iname = ".", btw), while later in the list there was still a real,
not yet deleted entry.

That way, the "goto next_sibling;" did not catch this case,
the "break the infinit loop if we fail to remove something"
did not catch it either.


Disclaimer: I'm not a dentries and inodes guy...

Still, I think the "is this child a non-empty subdir" check
was just wrong. This is my fix:
-	if (list_empty(&child->d_subdirs)) 
+	if (!simple_emty(child))

Also, always trying to __debugfs_remove() the first entry found from
parent->d_subdirs.next is wrong, we need to skip over any already
deleted children. I introduced the debugfs_find_next_positive_child()
helper for this.

If I understand it correctly, if we do it this way, it can never fail.
That is, as long as we can be sure that no new dentries will be created
while we are in debugfs_remove_recursive().
So the 
		if (debugfs_positive(child)) {
 			/*
 			 * Avoid infinite loop if we fail to remove
 			 * one dentry.
is probably dead code now?


As an additional fix, to prevent an access after free and resulting Oops,
I serialize dereferencing of attr->get/set and attr->data with d_delete(),
using the file->f_dentry->d_parent->d_inode->i_mutex.

If this file->f_dentry meanwhile has been deleted, simple_attr_read()
and simple_attr_write() now returns -ESTALE. (Any other error code preferences?)


With this patch, I was able to
cd /sys/debugfs/test-module/some/dir
exec 7< some-file
rmmod test-module
cat <&7

without any infinite loops, hangs, oopses or other problems,
and as expected get an ESTALE for the cat.

Without the patch, I'll get either an infinite loop and rmmod never
terminates, or cat oopses.


If you think this is correct, please comment on the FIXME
below, and help me write a nice commit message.

If you think this is still wrong or even makes things worse,
please help me with a proper fix ;-)


Patch is against upstream as of yesterday,
but looks like it still applies way back into 2009, 2.6.3x,
so if it is correct, it may even qualify for the stable branches?


Cheers,
	Lars



diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b607d92..fc80900 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -520,6 +520,19 @@ void debugfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(debugfs_remove);
 
+static struct dentry *debugfs_find_next_positive_child(struct dentry *parent)
+{
+	struct dentry *tmp;
+	list_for_each_entry(tmp, &parent->d_subdirs, d_u.d_child) {
+		if (debugfs_positive(tmp))
+			return tmp;
+		pr_debug("debugfs_remove_recursive: skipped over %.32s(%p)/%.32s(%p)\n",
+				parent->d_iname, parent,
+				tmp->d_iname, tmp);
+	}
+	return NULL;
+}
+
 /**
  * debugfs_remove_recursive - recursively removes a directory
  * @dentry: a pointer to a the dentry of the directory to be removed.
@@ -549,42 +562,36 @@ void debugfs_remove_recursive(struct dentry *dentry)
 
 	while (1) {
 		/*
-		 * When all dentries under "parent" has been removed,
+		 * Skip over any already d_delete()d,
+		 * but not yet d_kill()ed children.
+		 */
+		child = debugfs_find_next_positive_child(parent);
+
+		/*
+		 * When all dentries under "parent" have been removed,
 		 * walk up the tree until we reach our starting point.
 		 */
-		if (list_empty(&parent->d_subdirs)) {
+		if (!child) {
 			mutex_unlock(&parent->d_inode->i_mutex);
 			if (parent == dentry)
 				break;
 			parent = parent->d_parent;
 			mutex_lock(&parent->d_inode->i_mutex);
+			continue;
 		}
-		child = list_entry(parent->d_subdirs.next, struct dentry,
-				d_u.d_child);
- next_sibling:
 
 		/*
 		 * If "child" isn't empty, walk down the tree and
 		 * remove all its descendants first.
 		 */
-		if (!list_empty(&child->d_subdirs)) {
+		if (!simple_empty(child)) {
 			mutex_unlock(&parent->d_inode->i_mutex);
 			parent = child;
 			mutex_lock(&parent->d_inode->i_mutex);
 			continue;
 		}
 		__debugfs_remove(child, parent);
-		if (parent->d_subdirs.next == &child->d_u.d_child) {
-			/*
-			 * Try the next sibling.
-			 */
-			if (child->d_u.d_child.next != &parent->d_subdirs) {
-				child = list_entry(child->d_u.d_child.next,
-						   struct dentry,
-						   d_u.d_child);
-				goto next_sibling;
-			}
-
+		if (debugfs_positive(child)) {
 			/*
 			 * Avoid infinite loop if we fail to remove
 			 * one dentry.
diff --git a/fs/libfs.c b/fs/libfs.c
index 7cc37ca..bc5f3f3 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -794,8 +794,24 @@ ssize_t simple_attr_read(struct file *file, char __user *buf,
 	if (*ppos) {		/* continued read */
 		size = strlen(attr->get_buf);
 	} else {		/* first read */
+		struct dentry *parent;
 		u64 val;
+
+		ret = -ESTALE;
+		parent = file->f_dentry->d_parent;
+		/* FIXME do I need to check this? */
+		if (!parent || !parent->d_inode)
+			goto out;
+
+		/* serialize with d_delete() */
+		mutex_lock(&parent->d_inode->i_mutex);
+		if (!simple_positive(file->f_dentry)) {
+			mutex_unlock(&parent->d_inode->i_mutex);
+			goto out;
+		}
+
 		ret = attr->get(attr->data, &val);
+		mutex_unlock(&parent->d_inode->i_mutex);
 		if (ret)
 			goto out;
 
@@ -813,6 +829,7 @@ out:
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos)
 {
+	struct dentry *parent;
 	struct simple_attr *attr;
 	u64 val;
 	size_t size;
@@ -833,7 +850,22 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 
 	attr->set_buf[size] = '\0';
 	val = simple_strtoll(attr->set_buf, NULL, 0);
+
+	ret = -ESTALE;
+	parent = file->f_dentry->d_parent;
+	/* FIXME do I need to check this? */
+	if (!parent || !parent->d_inode)
+		goto out;
+
+	/* serialize with d_delete() */
+	mutex_lock(&parent->d_inode->i_mutex);
+	if (!simple_positive(file->f_dentry)) {
+		mutex_unlock(&parent->d_inode->i_mutex);
+		goto out;
+	}
+
 	ret = attr->set(attr->data, val);
+	mutex_unlock(&parent->d_inode->i_mutex);
 	if (ret == 0)
 		ret = len; /* on success, claim we got the whole input */
 out:
