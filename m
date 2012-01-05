Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab2AEQpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab2AEQoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:44:25 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] dlm: convert rsb list to rb_tree
Date: Thu,  5 Jan 2012 10:44:13 -0600
Message-Id: <1325781857-7938-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Change the linked lists to rb_tree's in the rsb
hash table to speed up searches.  Slow rsb searches
were having a large impact on gfs2 performance due
to the large number of dlm locks gfs2 uses.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/debug_fs.c     |   28 ++++++++-------
 fs/dlm/dlm_internal.h |    9 +++--
 fs/dlm/lock.c         |   87 +++++++++++++++++++++++++++++++++++++++---------
 fs/dlm/lockspace.c    |   23 +++++--------
 fs/dlm/recover.c      |   21 +++++++----
 5 files changed, 113 insertions(+), 55 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 5977923..3dca2b3 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -393,6 +393,7 @@ static const struct seq_operations format3_seq_ops;
 
 static void *table_seq_start(struct seq_file *seq, loff_t *pos)
 {
+	struct rb_node *node;
 	struct dlm_ls *ls = seq->private;
 	struct rsbtbl_iter *ri;
 	struct dlm_rsb *r;
@@ -418,9 +419,10 @@ static void *table_seq_start(struct seq_file *seq, loff_t *pos)
 		ri->format = 3;
 
 	spin_lock(&ls->ls_rsbtbl[bucket].lock);
-	if (!list_empty(&ls->ls_rsbtbl[bucket].list)) {
-		list_for_each_entry(r, &ls->ls_rsbtbl[bucket].list,
-				    res_hashchain) {
+	if (!RB_EMPTY_ROOT(&ls->ls_rsbtbl[bucket].keep)) {
+		for (node = rb_first(&ls->ls_rsbtbl[bucket].keep); node;
+		     node = rb_next(node)) {
+			r = rb_entry(node, struct dlm_rsb, res_hashnode);
 			if (!entry--) {
 				dlm_hold_rsb(r);
 				ri->rsb = r;
@@ -449,9 +451,9 @@ static void *table_seq_start(struct seq_file *seq, loff_t *pos)
 		}
 
 		spin_lock(&ls->ls_rsbtbl[bucket].lock);
-		if (!list_empty(&ls->ls_rsbtbl[bucket].list)) {
-			r = list_first_entry(&ls->ls_rsbtbl[bucket].list,
-					     struct dlm_rsb, res_hashchain);
+		if (!RB_EMPTY_ROOT(&ls->ls_rsbtbl[bucket].keep)) {
+			node = rb_first(&ls->ls_rsbtbl[bucket].keep);
+			r = rb_entry(node, struct dlm_rsb, res_hashnode);
 			dlm_hold_rsb(r);
 			ri->rsb = r;
 			ri->bucket = bucket;
@@ -467,7 +469,7 @@ static void *table_seq_next(struct seq_file *seq, void *iter_ptr, loff_t *pos)
 {
 	struct dlm_ls *ls = seq->private;
 	struct rsbtbl_iter *ri = iter_ptr;
-	struct list_head *next;
+	struct rb_node *next;
 	struct dlm_rsb *r, *rp;
 	loff_t n = *pos;
 	unsigned bucket;
@@ -480,10 +482,10 @@ static void *table_seq_next(struct seq_file *seq, void *iter_ptr, loff_t *pos)
 
 	spin_lock(&ls->ls_rsbtbl[bucket].lock);
 	rp = ri->rsb;
-	next = rp->res_hashchain.next;
+	next = rb_next(&rp->res_hashnode);
 
-	if (next != &ls->ls_rsbtbl[bucket].list) {
-		r = list_entry(next, struct dlm_rsb, res_hashchain);
+	if (next) {
+		r = rb_entry(next, struct dlm_rsb, res_hashnode);
 		dlm_hold_rsb(r);
 		ri->rsb = r;
 		spin_unlock(&ls->ls_rsbtbl[bucket].lock);
@@ -511,9 +513,9 @@ static void *table_seq_next(struct seq_file *seq, void *iter_ptr, loff_t *pos)
 		}
 
 		spin_lock(&ls->ls_rsbtbl[bucket].lock);
-		if (!list_empty(&ls->ls_rsbtbl[bucket].list)) {
-			r = list_first_entry(&ls->ls_rsbtbl[bucket].list,
-					     struct dlm_rsb, res_hashchain);
+		if (!RB_EMPTY_ROOT(&ls->ls_rsbtbl[bucket].keep)) {
+			next = rb_first(&ls->ls_rsbtbl[bucket].keep);
+			r = rb_entry(next, struct dlm_rsb, res_hashnode);
 			dlm_hold_rsb(r);
 			ri->rsb = r;
 			ri->bucket = bucket;
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index fe2860c..5685a9a 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -103,8 +103,8 @@ struct dlm_dirtable {
 };
 
 struct dlm_rsbtable {
-	struct list_head	list;
-	struct list_head	toss;
+	struct rb_root		keep;
+	struct rb_root		toss;
 	spinlock_t		lock;
 };
 
@@ -285,7 +285,10 @@ struct dlm_rsb {
 	unsigned long		res_toss_time;
 	uint32_t		res_first_lkid;
 	struct list_head	res_lookup;	/* lkbs waiting on first */
-	struct list_head	res_hashchain;	/* rsbtbl */
+	union {
+		struct list_head	res_hashchain;
+		struct rb_node		res_hashnode;	/* rsbtbl */
+	};
 	struct list_head	res_grantqueue;
 	struct list_head	res_convertqueue;
 	struct list_head	res_waitqueue;
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 83b5e32..d471830 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -56,6 +56,7 @@
    L: receive_xxxx_reply()     <-  R: send_xxxx_reply()
 */
 #include <linux/types.h>
+#include <linux/rbtree.h>
 #include <linux/slab.h>
 #include "dlm_internal.h"
 #include <linux/dlm_device.h>
@@ -380,6 +381,8 @@ static int get_rsb_struct(struct dlm_ls *ls, char *name, int len,
 
 	r = list_first_entry(&ls->ls_new_rsb, struct dlm_rsb, res_hashchain);
 	list_del(&r->res_hashchain);
+	/* Convert the empty list_head to a NULL rb_node for tree usage: */
+	memset(&r->res_hashnode, 0, sizeof(struct rb_node));
 	ls->ls_new_rsb_count--;
 	spin_unlock(&ls->ls_new_rsb_spin);
 
@@ -388,7 +391,6 @@ static int get_rsb_struct(struct dlm_ls *ls, char *name, int len,
 	memcpy(r->res_name, name, len);
 	mutex_init(&r->res_mutex);
 
-	INIT_LIST_HEAD(&r->res_hashchain);
 	INIT_LIST_HEAD(&r->res_lookup);
 	INIT_LIST_HEAD(&r->res_grantqueue);
 	INIT_LIST_HEAD(&r->res_convertqueue);
@@ -400,14 +402,31 @@ static int get_rsb_struct(struct dlm_ls *ls, char *name, int len,
 	return 0;
 }
 
-static int search_rsb_list(struct list_head *head, char *name, int len,
+static int rsb_cmp(struct dlm_rsb *r, const char *name, int nlen)
+{
+	char maxname[DLM_RESNAME_MAXLEN];
+
+	memset(maxname, 0, DLM_RESNAME_MAXLEN);
+	memcpy(maxname, name, nlen);
+	return memcmp(r->res_name, maxname, DLM_RESNAME_MAXLEN);
+}
+
+static int search_rsb_tree(struct rb_root *tree, char *name, int len,
 			   unsigned int flags, struct dlm_rsb **r_ret)
 {
+	struct rb_node *node = tree->rb_node;
 	struct dlm_rsb *r;
 	int error = 0;
-
-	list_for_each_entry(r, head, res_hashchain) {
-		if (len == r->res_length && !memcmp(name, r->res_name, len))
+	int rc;
+
+	while (node) {
+		r = rb_entry(node, struct dlm_rsb, res_hashnode);
+		rc = rsb_cmp(r, name, len);
+		if (rc < 0)
+			node = node->rb_left;
+		else if (rc > 0)
+			node = node->rb_right;
+		else
 			goto found;
 	}
 	*r_ret = NULL;
@@ -420,22 +439,54 @@ static int search_rsb_list(struct list_head *head, char *name, int len,
 	return error;
 }
 
+static int rsb_insert(struct dlm_rsb *rsb, struct rb_root *tree)
+{
+	struct rb_node **newn = &tree->rb_node;
+	struct rb_node *parent = NULL;
+	int rc;
+
+	while (*newn) {
+		struct dlm_rsb *cur = rb_entry(*newn, struct dlm_rsb,
+					       res_hashnode);
+
+		parent = *newn;
+		rc = rsb_cmp(cur, rsb->res_name, rsb->res_length);
+		if (rc < 0)
+			newn = &parent->rb_left;
+		else if (rc > 0)
+			newn = &parent->rb_right;
+		else {
+			log_print("rsb_insert match");
+			dlm_dump_rsb(rsb);
+			dlm_dump_rsb(cur);
+			return -EEXIST;
+		}
+	}
+
+	rb_link_node(&rsb->res_hashnode, parent, newn);
+	rb_insert_color(&rsb->res_hashnode, tree);
+	return 0;
+}
+
 static int _search_rsb(struct dlm_ls *ls, char *name, int len, int b,
 		       unsigned int flags, struct dlm_rsb **r_ret)
 {
 	struct dlm_rsb *r;
 	int error;
 
-	error = search_rsb_list(&ls->ls_rsbtbl[b].list, name, len, flags, &r);
+	error = search_rsb_tree(&ls->ls_rsbtbl[b].keep, name, len, flags, &r);
 	if (!error) {
 		kref_get(&r->res_ref);
 		goto out;
 	}
-	error = search_rsb_list(&ls->ls_rsbtbl[b].toss, name, len, flags, &r);
+	error = search_rsb_tree(&ls->ls_rsbtbl[b].toss, name, len, flags, &r);
 	if (error)
 		goto out;
 
-	list_move(&r->res_hashchain, &ls->ls_rsbtbl[b].list);
+	rb_erase(&r->res_hashnode, &ls->ls_rsbtbl[b].toss);
+	error = rsb_insert(r, &ls->ls_rsbtbl[b].keep);
+	if (error)
+		return error;
 
 	if (dlm_no_directory(ls))
 		goto out;
@@ -527,8 +578,7 @@ static int find_rsb(struct dlm_ls *ls, char *name, int namelen,
 			nodeid = 0;
 		r->res_nodeid = nodeid;
 	}
-	list_add(&r->res_hashchain, &ls->ls_rsbtbl[bucket].list);
-	error = 0;
+	error = rsb_insert(r, &ls->ls_rsbtbl[bucket].keep);
  out_unlock:
 	spin_unlock(&ls->ls_rsbtbl[bucket].lock);
  out:
@@ -556,7 +606,8 @@ static void toss_rsb(struct kref *kref)
 
 	DLM_ASSERT(list_empty(&r->res_root_list), dlm_print_rsb(r););
 	kref_init(&r->res_ref);
-	list_move(&r->res_hashchain, &ls->ls_rsbtbl[r->res_bucket].toss);
+	rb_erase(&r->res_hashnode, &ls->ls_rsbtbl[r->res_bucket].keep);
+	rsb_insert(r, &ls->ls_rsbtbl[r->res_bucket].toss);
 	r->res_toss_time = jiffies;
 	if (r->res_lvbptr) {
 		dlm_free_lvb(r->res_lvbptr);
@@ -1082,19 +1133,19 @@ static void dir_remove(struct dlm_rsb *r)
 				     r->res_name, r->res_length);
 }
 
-/* FIXME: shouldn't this be able to exit as soon as one non-due rsb is
-   found since they are in order of newest to oldest? */
+/* FIXME: make this more efficient */
 
 static int shrink_bucket(struct dlm_ls *ls, int b)
 {
+	struct rb_node *n;
 	struct dlm_rsb *r;
 	int count = 0, found;
 
 	for (;;) {
 		found = 0;
 		spin_lock(&ls->ls_rsbtbl[b].lock);
-		list_for_each_entry_reverse(r, &ls->ls_rsbtbl[b].toss,
-					    res_hashchain) {
+		for (n = rb_first(&ls->ls_rsbtbl[b].toss); n; n = rb_next(n)) {
+			r = rb_entry(n, struct dlm_rsb, res_hashnode);
 			if (!time_after_eq(jiffies, r->res_toss_time +
 					   dlm_config.ci_toss_secs * HZ))
 				continue;
@@ -1108,7 +1159,7 @@ static int shrink_bucket(struct dlm_ls *ls, int b)
 		}
 
 		if (kref_put(&r->res_ref, kill_rsb)) {
-			list_del(&r->res_hashchain);
+			rb_erase(&r->res_hashnode, &ls->ls_rsbtbl[b].toss);
 			spin_unlock(&ls->ls_rsbtbl[b].lock);
 
 			if (is_master(r))
@@ -4441,10 +4492,12 @@ int dlm_purge_locks(struct dlm_ls *ls)
 
 static struct dlm_rsb *find_purged_rsb(struct dlm_ls *ls, int bucket)
 {
+	struct rb_node *n;
 	struct dlm_rsb *r, *r_ret = NULL;
 
 	spin_lock(&ls->ls_rsbtbl[bucket].lock);
-	list_for_each_entry(r, &ls->ls_rsbtbl[bucket].list, res_hashchain) {
+	for (n = rb_first(&ls->ls_rsbtbl[bucket].keep); n; n = rb_next(n)) {
+		r = rb_entry(n, struct dlm_rsb, res_hashnode);
 		if (!rsb_flag(r, RSB_LOCKS_PURGED))
 			continue;
 		hold_rsb(r);
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index a1d8f1a..1d16a23 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -457,8 +457,8 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	if (!ls->ls_rsbtbl)
 		goto out_lsfree;
 	for (i = 0; i < size; i++) {
-		INIT_LIST_HEAD(&ls->ls_rsbtbl[i].list);
-		INIT_LIST_HEAD(&ls->ls_rsbtbl[i].toss);
+		ls->ls_rsbtbl[i].keep.rb_node = NULL;
+		ls->ls_rsbtbl[i].toss.rb_node = NULL;
 		spin_lock_init(&ls->ls_rsbtbl[i].lock);
 	}
 
@@ -685,7 +685,7 @@ static int lockspace_busy(struct dlm_ls *ls, int force)
 static int release_lockspace(struct dlm_ls *ls, int force)
 {
 	struct dlm_rsb *rsb;
-	struct list_head *head;
+	struct rb_node *n;
 	int i, busy, rv;
 
 	busy = lockspace_busy(ls, force);
@@ -746,20 +746,15 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	 */
 
 	for (i = 0; i < ls->ls_rsbtbl_size; i++) {
-		head = &ls->ls_rsbtbl[i].list;
-		while (!list_empty(head)) {
-			rsb = list_entry(head->next, struct dlm_rsb,
-					 res_hashchain);
-
-			list_del(&rsb->res_hashchain);
+		while ((n = rb_first(&ls->ls_rsbtbl[i].keep))) {
+			rsb = rb_entry(n, struct dlm_rsb, res_hashnode);
+			rb_erase(n, &ls->ls_rsbtbl[i].keep);
 			dlm_free_rsb(rsb);
 		}
 
-		head = &ls->ls_rsbtbl[i].toss;
-		while (!list_empty(head)) {
-			rsb = list_entry(head->next, struct dlm_rsb,
-					 res_hashchain);
-			list_del(&rsb->res_hashchain);
+		while ((n = rb_first(&ls->ls_rsbtbl[i].toss))) {
+			rsb = rb_entry(n, struct dlm_rsb, res_hashnode);
+			rb_erase(n, &ls->ls_rsbtbl[i].toss);
 			dlm_free_rsb(rsb);
 		}
 	}
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index 1463823..50467ce 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -715,6 +715,7 @@ void dlm_recover_rsbs(struct dlm_ls *ls)
 
 int dlm_create_root_list(struct dlm_ls *ls)
 {
+	struct rb_node *n;
 	struct dlm_rsb *r;
 	int i, error = 0;
 
@@ -727,7 +728,8 @@ int dlm_create_root_list(struct dlm_ls *ls)
 
 	for (i = 0; i < ls->ls_rsbtbl_size; i++) {
 		spin_lock(&ls->ls_rsbtbl[i].lock);
-		list_for_each_entry(r, &ls->ls_rsbtbl[i].list, res_hashchain) {
+		for (n = rb_first(&ls->ls_rsbtbl[i].keep); n; n = rb_next(n)) {
+			r = rb_entry(n, struct dlm_rsb, res_hashnode);
 			list_add(&r->res_root_list, &ls->ls_root_list);
 			dlm_hold_rsb(r);
 		}
@@ -741,7 +743,8 @@ int dlm_create_root_list(struct dlm_ls *ls)
 			continue;
 		}
 
-		list_for_each_entry(r, &ls->ls_rsbtbl[i].toss, res_hashchain) {
+		for (n = rb_first(&ls->ls_rsbtbl[i].toss); n; n = rb_next(n)) {
+			r = rb_entry(n, struct dlm_rsb, res_hashnode);
 			list_add(&r->res_root_list, &ls->ls_root_list);
 			dlm_hold_rsb(r);
 		}
@@ -771,16 +774,18 @@ void dlm_release_root_list(struct dlm_ls *ls)
 
 void dlm_clear_toss_list(struct dlm_ls *ls)
 {
-	struct dlm_rsb *r, *safe;
+	struct rb_node *n, *next;
+	struct dlm_rsb *rsb;
 	int i;
 
 	for (i = 0; i < ls->ls_rsbtbl_size; i++) {
 		spin_lock(&ls->ls_rsbtbl[i].lock);
-		list_for_each_entry_safe(r, safe, &ls->ls_rsbtbl[i].toss,
-					 res_hashchain) {
-			if (dlm_no_directory(ls) || !is_master(r)) {
-				list_del(&r->res_hashchain);
-				dlm_free_rsb(r);
+		for (n = rb_first(&ls->ls_rsbtbl[i].toss); n; n = next) {
+			next = rb_next(n);;
+			rsb = rb_entry(n, struct dlm_rsb, res_hashnode);
+			if (dlm_no_directory(ls) || !is_master(rsb)) {
+				rb_erase(n, &ls->ls_rsbtbl[i].toss);
+				dlm_free_rsb(rsb);
 			}
 		}
 		spin_unlock(&ls->ls_rsbtbl[i].lock);
-- 
1.7.6

