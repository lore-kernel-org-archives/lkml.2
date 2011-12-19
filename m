Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1LSEEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:04:08 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33690 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1LSEEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:04:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
References: <m1aa6pky2r.fsf@fess.ebiederm.org>
Date: Sun, 18 Dec 2011 20:05:43 -0800
In-Reply-To: <m1aa6pky2r.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Sun, 18 Dec 2011 20:03:08 -0800")
Message-ID: <m14nwxkxyg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+vbKWh+yXI9VuJ4PQsAi199jmGEe/eY1M=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: **
Subject: [PATCH 1/4] sysfs: Add s_hash to sysfs_dirent and order directory entries by hash
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Compute a 31 bit hash of directory entries (that can fit in a signed
32bit off_t) and index the sysfs directory entries by that hash,
replacing the per directory indexes by name and by inode.  Because we
now only use a single rbtree this reduces the size of sysfs_dirent by 2
pointers.  Because we have fewer cases to deal with the code is now
simpler.

For now I use the simple hash that the dcache uses as that is easy to
use and seems simple enough.

In addition to makeing the code simpler using a hash for the file
position in readdir brings sysfs in line with other filesystems that
have non-trivial directory structures.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c   |  219 ++++++++++++++++++++++++++++-------------------------
 fs/sysfs/sysfs.h |    9 +-
 2 files changed, 120 insertions(+), 108 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7fdf6a7..0daf255 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -22,76 +22,103 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/security.h>
+#include <linux/hash.h>
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
 DEFINE_SPINLOCK(sysfs_assoc_lock);
 
+#define to_sysfs_dirent(X) rb_entry((X), struct sysfs_dirent, s_rb);
+
 static DEFINE_SPINLOCK(sysfs_ino_lock);
 static DEFINE_IDA(sysfs_ino_ida);
 
 /**
- *	sysfs_link_sibling - link sysfs_dirent into sibling list
+ *	sysfs_name_hash
+ *	@ns:   Namespace tag to hash
+ *	@name: Null terminated string to hash
+ *
+ *	Returns 31 bit hash of ns + name (so it fits in an off_t )
+ */
+static unsigned int sysfs_name_hash(const void *ns, const char *name)
+{
+	unsigned long hash = init_name_hash();
+	unsigned int len = strlen(name);
+	while (len--)
+		hash = partial_name_hash(*name++, hash);
+	hash = ( end_name_hash(hash) ^ hash_ptr( (void *)ns, 31 ) );
+	hash &= 0x7fffffffU;
+	/* Reserve hash numbers 0, 1 and INT_MAX for magic directory entries */
+	if (hash < 1)
+		hash += 2;
+	if (hash >= INT_MAX)
+		hash = INT_MAX - 1;
+	return hash;
+}
+
+static int sysfs_name_compare(unsigned int hash, const void *ns,
+	const char *name, const struct sysfs_dirent *sd)
+{
+	if (hash != sd->s_hash)
+		return hash - sd->s_hash;
+	if (ns != sd->s_ns)
+		return ns - sd->s_ns;
+	return strcmp(name, sd->s_name);
+}
+
+static int sysfs_sd_compare(const struct sysfs_dirent *left,
+			    const struct sysfs_dirent *right)
+{
+	return sysfs_name_compare(left->s_hash, left->s_ns, left->s_name,
+				  right);
+}
+
+/**
+ *	sysfs_link_subling - link sysfs_dirent into sibling rbtree
  *	@sd: sysfs_dirent of interest
  *
- *	Link @sd into its sibling list which starts from
+ *	Link @sd into its sibling rbtree which starts from
  *	sd->s_parent->s_dir.children.
  *
  *	Locking:
  *	mutex_lock(sysfs_mutex)
+ *
+ *	RETURNS:
+ *	0 on susccess -EEXIST on failure.
  */
-static void sysfs_link_sibling(struct sysfs_dirent *sd)
+static int sysfs_link_sibling(struct sysfs_dirent *sd)
 {
-	struct sysfs_dirent *parent_sd = sd->s_parent;
-
-	struct rb_node **p;
-	struct rb_node *parent;
+	struct rb_node **node = &sd->s_parent->s_dir.children.rb_node;
+	struct rb_node *parent = NULL;
 
 	if (sysfs_type(sd) == SYSFS_DIR)
-		parent_sd->s_dir.subdirs++;
-
-	p = &parent_sd->s_dir.inode_tree.rb_node;
-	parent = NULL;
-	while (*p) {
-		parent = *p;
-#define node	rb_entry(parent, struct sysfs_dirent, inode_node)
-		if (sd->s_ino < node->s_ino) {
-			p = &node->inode_node.rb_left;
-		} else if (sd->s_ino > node->s_ino) {
-			p = &node->inode_node.rb_right;
-		} else {
-			printk(KERN_CRIT "sysfs: inserting duplicate inode '%lx'\n",
-			       (unsigned long) sd->s_ino);
-			BUG();
-		}
-#undef node
-	}
-	rb_link_node(&sd->inode_node, parent, p);
-	rb_insert_color(&sd->inode_node, &parent_sd->s_dir.inode_tree);
-
-	p = &parent_sd->s_dir.name_tree.rb_node;
-	parent = NULL;
-	while (*p) {
-		int c;
-		parent = *p;
-#define node	rb_entry(parent, struct sysfs_dirent, name_node)
-		c = strcmp(sd->s_name, node->s_name);
-		if (c < 0) {
-			p = &node->name_node.rb_left;
-		} else {
-			p = &node->name_node.rb_right;
-		}
-#undef node
+		sd->s_parent->s_dir.subdirs++;
+
+	while (*node) {
+		struct sysfs_dirent *pos;
+		int result;
+
+		pos = to_sysfs_dirent(*node);
+		parent = *node;
+		result = sysfs_sd_compare(sd, pos);
+		if (result < 0)
+			node = &pos->s_rb.rb_left;
+		else if (result > 0)
+			node = &pos->s_rb.rb_right;
+		else
+			return -EEXIST;
 	}
-	rb_link_node(&sd->name_node, parent, p);
-	rb_insert_color(&sd->name_node, &parent_sd->s_dir.name_tree);
+	/* add new node and rebalance the tree */
+	rb_link_node(&sd->s_rb, parent, node);
+	rb_insert_color(&sd->s_rb, &sd->s_parent->s_dir.children);
+	return 0;
 }
 
 /**
- *	sysfs_unlink_sibling - unlink sysfs_dirent from sibling list
+ *	sysfs_unlink_sibling - unlink sysfs_dirent from sibling rbtree
  *	@sd: sysfs_dirent of interest
  *
- *	Unlink @sd from its sibling list which starts from
+ *	Unlink @sd from its sibling rbtree which starts from
  *	sd->s_parent->s_dir.children.
  *
  *	Locking:
@@ -102,8 +129,7 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 	if (sysfs_type(sd) == SYSFS_DIR)
 		sd->s_parent->s_dir.subdirs--;
 
-	rb_erase(&sd->inode_node, &sd->s_parent->s_dir.inode_tree);
-	rb_erase(&sd->name_node, &sd->s_parent->s_dir.name_tree);
+	rb_erase(&sd->s_rb, &sd->s_parent->s_dir.children);
 }
 
 /**
@@ -402,6 +428,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
 	struct sysfs_inode_attrs *ps_iattr;
+	int ret;
 
 	if (!!sysfs_ns_type(acxt->parent_sd) != !!sd->s_ns) {
 		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
@@ -410,12 +437,12 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 		return -EINVAL;
 	}
 
-	if (sysfs_find_dirent(acxt->parent_sd, sd->s_ns, sd->s_name))
-		return -EEXIST;
-
+	sd->s_hash = sysfs_name_hash(sd->s_ns, sd->s_name);
 	sd->s_parent = sysfs_get(acxt->parent_sd);
 
-	sysfs_link_sibling(sd);
+	ret = sysfs_link_sibling(sd);
+	if (ret)
+		return ret;
 
 	/* Update timestamps on the parent */
 	ps_iattr = acxt->parent_sd->s_iattr;
@@ -565,8 +592,8 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 				       const void *ns,
 				       const unsigned char *name)
 {
-	struct rb_node *p = parent_sd->s_dir.name_tree.rb_node;
-	struct sysfs_dirent *found = NULL;
+	struct rb_node *node = parent_sd->s_dir.children.rb_node;
+	unsigned int hash;
 
 	if (!!sysfs_ns_type(parent_sd) != !!ns) {
 		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
@@ -575,33 +602,21 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 		return NULL;
 	}
 
-	while (p) {
-		int c;
-#define node	rb_entry(p, struct sysfs_dirent, name_node)
-		c = strcmp(name, node->s_name);
-		if (c < 0) {
-			p = node->name_node.rb_left;
-		} else if (c > 0) {
-			p = node->name_node.rb_right;
-		} else {
-			found = node;
-			p = node->name_node.rb_left;
-		}
-#undef node
-	}
-
-	if (found) {
-		while (found->s_ns != ns) {
-			p = rb_next(&found->name_node);
-			if (!p)
-				return NULL;
-			found = rb_entry(p, struct sysfs_dirent, name_node);
-			if (strcmp(name, found->s_name))
-				return NULL;
-		}
+	hash = sysfs_name_hash(ns, name);
+	while (node) {
+		struct sysfs_dirent *sd;
+		int result;
+
+		sd = to_sysfs_dirent(node);
+		result = sysfs_name_compare(hash, ns, name, sd);
+		if (result < 0)
+			node = node->rb_left;
+		else if (result > 0)
+			node = node->rb_right;
+		else
+			return sd;
 	}
-
-	return found;
+	return NULL;
 }
 
 /**
@@ -804,9 +819,9 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
 	sysfs_addrm_start(&acxt, dir_sd);
-	pos = rb_first(&dir_sd->s_dir.inode_tree);
+	pos = rb_first(&dir_sd->s_dir.children);
 	while (pos) {
-		struct sysfs_dirent *sd = rb_entry(pos, struct sysfs_dirent, inode_node);
+		struct sysfs_dirent *sd = to_sysfs_dirent(pos);
 		pos = rb_next(pos);
 		if (sysfs_type(sd) != SYSFS_DIR)
 			sysfs_remove_one(&acxt, sd);
@@ -919,38 +934,36 @@ static int sysfs_dir_release(struct inode *inode, struct file *filp)
 }
 
 static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
-	struct sysfs_dirent *parent_sd,	ino_t ino, struct sysfs_dirent *pos)
+	struct sysfs_dirent *parent_sd,	loff_t hash, struct sysfs_dirent *pos)
 {
 	if (pos) {
 		int valid = !(pos->s_flags & SYSFS_FLAG_REMOVED) &&
 			pos->s_parent == parent_sd &&
-			ino == pos->s_ino;
+			hash == pos->s_hash;
 		sysfs_put(pos);
 		if (!valid)
 			pos = NULL;
 	}
-	if (!pos && (ino > 1) && (ino < INT_MAX)) {
-		struct rb_node *p = parent_sd->s_dir.inode_tree.rb_node;
-		while (p) {
-#define node	rb_entry(p, struct sysfs_dirent, inode_node)
-			if (ino < node->s_ino) {
-				pos = node;
-				p = node->inode_node.rb_left;
-			} else if (ino > node->s_ino) {
-				p = node->inode_node.rb_right;
-			} else {
-				pos = node;
+	if (!pos && (hash > 1) && (hash < INT_MAX)) {
+		struct rb_node *node = parent_sd->s_dir.children.rb_node;
+		while (node) {
+			pos = to_sysfs_dirent(node);
+
+			if (hash < pos->s_hash)
+				node = node->rb_left;
+			else if (hash > pos->s_hash)
+				node = node->rb_right;
+			else
 				break;
-			}
-#undef node
 		}
 	}
+	/* Skip over entries in the wrong namespace */
 	while (pos && pos->s_ns != ns) {
-		struct rb_node *p = rb_next(&pos->inode_node);
-		if (!p)
+		struct rb_node *node = rb_next(&pos->s_rb);
+		if (!node)
 			pos = NULL;
 		else
-			pos = rb_entry(p, struct sysfs_dirent, inode_node);
+			pos = to_sysfs_dirent(node);
 	}
 	return pos;
 }
@@ -960,11 +973,11 @@ static struct sysfs_dirent *sysfs_dir_next_pos(const void *ns,
 {
 	pos = sysfs_dir_pos(ns, parent_sd, ino, pos);
 	if (pos) do {
-		struct rb_node *p = rb_next(&pos->inode_node);
-		if (!p)
+		struct rb_node *node = rb_next(&pos->s_rb);
+		if (!node)
 			pos = NULL;
 		else
-			pos = rb_entry(p, struct sysfs_dirent, inode_node);
+			pos = to_sysfs_dirent(node);
 	} while (pos && pos->s_ns != ns);
 	return pos;
 }
@@ -1006,7 +1019,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		len = strlen(name);
 		ino = pos->s_ino;
 		type = dt_type(pos);
-		filp->f_pos = ino;
+		filp->f_pos = pos->s_hash;
 		filp->private_data = sysfs_get(pos);
 
 		mutex_unlock(&sysfs_mutex);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index ce29e28..545a8d4 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -20,9 +20,8 @@ struct sysfs_elem_dir {
 	struct kobject		*kobj;
 
 	unsigned long		subdirs;
-
-	struct rb_root		inode_tree;
-	struct rb_root		name_tree;
+	/* children rbtree starts here and goes through sd->s_rb */
+	struct rb_root		children;
 };
 
 struct sysfs_elem_symlink {
@@ -62,8 +61,7 @@ struct sysfs_dirent {
 	struct sysfs_dirent	*s_parent;
 	const char		*s_name;
 
-	struct rb_node		inode_node;
-	struct rb_node		name_node;
+	struct rb_node		s_rb;
 
 	union {
 		struct completion	*completion;
@@ -71,6 +69,7 @@ struct sysfs_dirent {
 	} u;
 
 	const void		*s_ns; /* namespace tag */
+	unsigned int		s_hash; /* ns + name hash */
 	union {
 		struct sysfs_elem_dir		s_dir;
 		struct sysfs_elem_symlink	s_symlink;
-- 
1.7.2.5

