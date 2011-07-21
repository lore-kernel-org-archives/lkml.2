Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab1GUQES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1GUQEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:13 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] dlm: improve rsb searches
Date: Thu, 21 Jul 2011 11:04:04 -0500
Message-Id: <1311264247-28129-8-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By pre-allocating rsb structs before searching the hash
table, they can be inserted immediately.  This avoids
always having to repeat the search when adding the struct
to hash list.

This also adds space to the rsb struct for a max resource
name, so an rsb allocation can be used by any request.
The constant size also allows us to finally use a slab
for the rsb structs.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/config.c       |    9 +++-
 fs/dlm/config.h       |    1 +
 fs/dlm/dlm_internal.h |    6 ++-
 fs/dlm/lock.c         |  119 +++++++++++++++++++++++++++++++++---------------
 fs/dlm/lockspace.c    |   10 ++++
 fs/dlm/memory.c       |   22 ++++++---
 fs/dlm/memory.h       |    2 +-
 7 files changed, 121 insertions(+), 48 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 4e20f93..6cf72fc 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -102,6 +102,7 @@ struct dlm_cluster {
 	unsigned int cl_protocol;
 	unsigned int cl_timewarn_cs;
 	unsigned int cl_waitwarn_us;
+	unsigned int cl_new_rsb_count;
 };
 
 enum {
@@ -116,6 +117,7 @@ enum {
 	CLUSTER_ATTR_PROTOCOL,
 	CLUSTER_ATTR_TIMEWARN_CS,
 	CLUSTER_ATTR_WAITWARN_US,
+	CLUSTER_ATTR_NEW_RSB_COUNT,
 };
 
 struct cluster_attribute {
@@ -168,6 +170,7 @@ CLUSTER_ATTR(log_debug, 0);
 CLUSTER_ATTR(protocol, 0);
 CLUSTER_ATTR(timewarn_cs, 1);
 CLUSTER_ATTR(waitwarn_us, 0);
+CLUSTER_ATTR(new_rsb_count, 0);
 
 static struct configfs_attribute *cluster_attrs[] = {
 	[CLUSTER_ATTR_TCP_PORT] = &cluster_attr_tcp_port.attr,
@@ -181,6 +184,7 @@ static struct configfs_attribute *cluster_attrs[] = {
 	[CLUSTER_ATTR_PROTOCOL] = &cluster_attr_protocol.attr,
 	[CLUSTER_ATTR_TIMEWARN_CS] = &cluster_attr_timewarn_cs.attr,
 	[CLUSTER_ATTR_WAITWARN_US] = &cluster_attr_waitwarn_us.attr,
+	[CLUSTER_ATTR_NEW_RSB_COUNT] = &cluster_attr_new_rsb_count.attr,
 	NULL,
 };
 
@@ -450,6 +454,7 @@ static struct config_group *make_cluster(struct config_group *g,
 	cl->cl_protocol = dlm_config.ci_protocol;
 	cl->cl_timewarn_cs = dlm_config.ci_timewarn_cs;
 	cl->cl_waitwarn_us = dlm_config.ci_waitwarn_us;
+	cl->cl_new_rsb_count = dlm_config.ci_new_rsb_count;
 
 	space_list = &sps->ss_group;
 	comm_list = &cms->cs_group;
@@ -1041,6 +1046,7 @@ int dlm_our_addr(struct sockaddr_storage *addr, int num)
 #define DEFAULT_PROTOCOL           0
 #define DEFAULT_TIMEWARN_CS      500 /* 5 sec = 500 centiseconds */
 #define DEFAULT_WAITWARN_US	   0
+#define DEFAULT_NEW_RSB_COUNT    128
 
 struct dlm_config_info dlm_config = {
 	.ci_tcp_port = DEFAULT_TCP_PORT,
@@ -1053,6 +1059,7 @@ struct dlm_config_info dlm_config = {
 	.ci_log_debug = DEFAULT_LOG_DEBUG,
 	.ci_protocol = DEFAULT_PROTOCOL,
 	.ci_timewarn_cs = DEFAULT_TIMEWARN_CS,
-	.ci_waitwarn_us = DEFAULT_WAITWARN_US
+	.ci_waitwarn_us = DEFAULT_WAITWARN_US,
+	.ci_new_rsb_count = DEFAULT_NEW_RSB_COUNT
 };
 
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index 2605744..3099d0d 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -28,6 +28,7 @@ struct dlm_config_info {
 	int ci_protocol;
 	int ci_timewarn_cs;
 	int ci_waitwarn_us;
+	int ci_new_rsb_count;
 };
 
 extern struct dlm_config_info dlm_config;
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 23a234b..6614f33 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -293,7 +293,7 @@ struct dlm_rsb {
 	int			res_recover_locks_count;
 
 	char			*res_lvbptr;
-	char			res_name[1];
+	char			res_name[DLM_RESNAME_MAXLEN+1];
 };
 
 /* find_rsb() flags */
@@ -477,6 +477,10 @@ struct dlm_ls {
 	struct mutex		ls_timeout_mutex;
 	struct list_head	ls_timeout;
 
+	spinlock_t		ls_new_rsb_spin;
+	int			ls_new_rsb_count;
+	struct list_head	ls_new_rsb;	/* new rsb structs */
+
 	struct list_head	ls_nodes;	/* current nodes in ls */
 	struct list_head	ls_nodes_gone;	/* dead node list, recovery */
 	int			ls_num_nodes;	/* number of nodes in ls */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 784cde4..9ebeaa6 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -327,19 +327,68 @@ static void queue_bast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rqmode)
  * Basic operations on rsb's and lkb's
  */
 
-static struct dlm_rsb *create_rsb(struct dlm_ls *ls, char *name, int len)
+static int pre_rsb_struct(struct dlm_ls *ls)
+{
+	struct dlm_rsb *r1, *r2;
+	int count = 0;
+
+	spin_lock(&ls->ls_new_rsb_spin);
+	if (ls->ls_new_rsb_count > dlm_config.ci_new_rsb_count / 2) {
+		spin_unlock(&ls->ls_new_rsb_spin);
+		return 0;
+	}
+	spin_unlock(&ls->ls_new_rsb_spin);
+
+	r1 = dlm_allocate_rsb(ls);
+	r2 = dlm_allocate_rsb(ls);
+
+	spin_lock(&ls->ls_new_rsb_spin);
+	if (r1) {
+		list_add(&r1->res_hashchain, &ls->ls_new_rsb);
+		ls->ls_new_rsb_count++;
+	}
+	if (r2) {
+		list_add(&r2->res_hashchain, &ls->ls_new_rsb);
+		ls->ls_new_rsb_count++;
+	}
+	count = ls->ls_new_rsb_count;
+	spin_unlock(&ls->ls_new_rsb_spin);
+
+	if (!count)
+		return -ENOMEM;
+	return 0;
+}
+
+/* If ls->ls_new_rsb is empty, return -EAGAIN, so the caller can
+   unlock any spinlocks, go back and call pre_rsb_struct again.
+   Otherwise, take an rsb off the list and return it. */
+
+static int get_rsb_struct(struct dlm_ls *ls, char *name, int len,
+			  struct dlm_rsb **r_ret)
 {
 	struct dlm_rsb *r;
+	int count;
 
-	r = dlm_allocate_rsb(ls, len);
-	if (!r)
-		return NULL;
+	spin_lock(&ls->ls_new_rsb_spin);
+	if (list_empty(&ls->ls_new_rsb)) {
+		count = ls->ls_new_rsb_count;
+		spin_unlock(&ls->ls_new_rsb_spin);
+		log_debug(ls, "find_rsb retry %d %d %s",
+			  count, dlm_config.ci_new_rsb_count, name);
+		return -EAGAIN;
+	}
+
+	r = list_first_entry(&ls->ls_new_rsb, struct dlm_rsb, res_hashchain);
+	list_del(&r->res_hashchain);
+	ls->ls_new_rsb_count--;
+	spin_unlock(&ls->ls_new_rsb_spin);
 
 	r->res_ls = ls;
 	r->res_length = len;
 	memcpy(r->res_name, name, len);
 	mutex_init(&r->res_mutex);
 
+	INIT_LIST_HEAD(&r->res_hashchain);
 	INIT_LIST_HEAD(&r->res_lookup);
 	INIT_LIST_HEAD(&r->res_grantqueue);
 	INIT_LIST_HEAD(&r->res_convertqueue);
@@ -347,7 +396,8 @@ static struct dlm_rsb *create_rsb(struct dlm_ls *ls, char *name, int len)
 	INIT_LIST_HEAD(&r->res_root_list);
 	INIT_LIST_HEAD(&r->res_recover_list);
 
-	return r;
+	*r_ret = r;
+	return 0;
 }
 
 static int search_rsb_list(struct list_head *head, char *name, int len,
@@ -405,16 +455,6 @@ static int _search_rsb(struct dlm_ls *ls, char *name, int len, int b,
 	return error;
 }
 
-static int search_rsb(struct dlm_ls *ls, char *name, int len, int b,
-		      unsigned int flags, struct dlm_rsb **r_ret)
-{
-	int error;
-	spin_lock(&ls->ls_rsbtbl[b].lock);
-	error = _search_rsb(ls, name, len, b, flags, r_ret);
-	spin_unlock(&ls->ls_rsbtbl[b].lock);
-	return error;
-}
-
 /*
  * Find rsb in rsbtbl and potentially create/add one
  *
@@ -432,35 +472,48 @@ static int search_rsb(struct dlm_ls *ls, char *name, int len, int b,
 static int find_rsb(struct dlm_ls *ls, char *name, int namelen,
 		    unsigned int flags, struct dlm_rsb **r_ret)
 {
-	struct dlm_rsb *r = NULL, *tmp;
+	struct dlm_rsb *r = NULL;
 	uint32_t hash, bucket;
-	int error = -EINVAL;
+	int error;
 
-	if (namelen > DLM_RESNAME_MAXLEN)
+	if (namelen > DLM_RESNAME_MAXLEN) {
+		error = -EINVAL;
 		goto out;
+	}
 
 	if (dlm_no_directory(ls))
 		flags |= R_CREATE;
 
-	error = 0;
 	hash = jhash(name, namelen, 0);
 	bucket = hash & (ls->ls_rsbtbl_size - 1);
 
-	error = search_rsb(ls, name, namelen, bucket, flags, &r);
+ retry:
+	if (flags & R_CREATE) {
+		error = pre_rsb_struct(ls);
+		if (error < 0)
+			goto out;
+	}
+
+	spin_lock(&ls->ls_rsbtbl[bucket].lock);
+
+	error = _search_rsb(ls, name, namelen, bucket, flags, &r);
 	if (!error)
-		goto out;
+		goto out_unlock;
 
 	if (error == -EBADR && !(flags & R_CREATE))
-		goto out;
+		goto out_unlock;
 
 	/* the rsb was found but wasn't a master copy */
 	if (error == -ENOTBLK)
-		goto out;
+		goto out_unlock;
 
-	error = -ENOMEM;
-	r = create_rsb(ls, name, namelen);
-	if (!r)
-		goto out;
+	error = get_rsb_struct(ls, name, namelen, &r);
+	if (error == -EAGAIN) {
+		spin_unlock(&ls->ls_rsbtbl[bucket].lock);
+		goto retry;
+	}
+	if (error)
+		goto out_unlock;
 
 	r->res_hash = hash;
 	r->res_bucket = bucket;
@@ -474,18 +527,10 @@ static int find_rsb(struct dlm_ls *ls, char *name, int namelen,
 			nodeid = 0;
 		r->res_nodeid = nodeid;
 	}
-
-	spin_lock(&ls->ls_rsbtbl[bucket].lock);
-	error = _search_rsb(ls, name, namelen, bucket, 0, &tmp);
-	if (!error) {
-		spin_unlock(&ls->ls_rsbtbl[bucket].lock);
-		dlm_free_rsb(r);
-		r = tmp;
-		goto out;
-	}
 	list_add(&r->res_hashchain, &ls->ls_rsbtbl[bucket].list);
-	spin_unlock(&ls->ls_rsbtbl[bucket].lock);
 	error = 0;
+ out_unlock:
+	spin_unlock(&ls->ls_rsbtbl[bucket].lock);
  out:
 	*r_ret = r;
 	return error;
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 871fe6d..98a9776 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -493,6 +493,9 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	INIT_LIST_HEAD(&ls->ls_timeout);
 	mutex_init(&ls->ls_timeout_mutex);
 
+	INIT_LIST_HEAD(&ls->ls_new_rsb);
+	spin_lock_init(&ls->ls_new_rsb_spin);
+
 	INIT_LIST_HEAD(&ls->ls_nodes);
 	INIT_LIST_HEAD(&ls->ls_nodes_gone);
 	ls->ls_num_nodes = 0;
@@ -764,6 +767,13 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	vfree(ls->ls_rsbtbl);
 
+	while (!list_empty(&ls->ls_new_rsb)) {
+		rsb = list_first_entry(&ls->ls_new_rsb, struct dlm_rsb,
+				       res_hashchain);
+		list_del(&rsb->res_hashchain);
+		dlm_free_rsb(rsb);
+	}
+
 	/*
 	 * Free structures on any other lists
 	 */
diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index 8e0d00d..da64df7 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -16,6 +16,7 @@
 #include "memory.h"
 
 static struct kmem_cache *lkb_cache;
+static struct kmem_cache *rsb_cache;
 
 
 int __init dlm_memory_init(void)
@@ -26,6 +27,14 @@ int __init dlm_memory_init(void)
 				__alignof__(struct dlm_lkb), 0, NULL);
 	if (!lkb_cache)
 		ret = -ENOMEM;
+
+	rsb_cache = kmem_cache_create("dlm_rsb", sizeof(struct dlm_rsb),
+				__alignof__(struct dlm_rsb), 0, NULL);
+	if (!rsb_cache) {
+		kmem_cache_destroy(lkb_cache);
+		ret = -ENOMEM;
+	}
+
 	return ret;
 }
 
@@ -33,6 +42,8 @@ void dlm_memory_exit(void)
 {
 	if (lkb_cache)
 		kmem_cache_destroy(lkb_cache);
+	if (rsb_cache)
+		kmem_cache_destroy(rsb_cache);
 }
 
 char *dlm_allocate_lvb(struct dlm_ls *ls)
@@ -48,16 +59,11 @@ void dlm_free_lvb(char *p)
 	kfree(p);
 }
 
-/* FIXME: have some minimal space built-in to rsb for the name and
-   kmalloc a separate name if needed, like dentries are done */
-
-struct dlm_rsb *dlm_allocate_rsb(struct dlm_ls *ls, int namelen)
+struct dlm_rsb *dlm_allocate_rsb(struct dlm_ls *ls)
 {
 	struct dlm_rsb *r;
 
-	DLM_ASSERT(namelen <= DLM_RESNAME_MAXLEN,);
-
-	r = kzalloc(sizeof(*r) + namelen, GFP_NOFS);
+	r = kmem_cache_zalloc(rsb_cache, GFP_NOFS);
 	return r;
 }
 
@@ -65,7 +71,7 @@ void dlm_free_rsb(struct dlm_rsb *r)
 {
 	if (r->res_lvbptr)
 		dlm_free_lvb(r->res_lvbptr);
-	kfree(r);
+	kmem_cache_free(rsb_cache, r);
 }
 
 struct dlm_lkb *dlm_allocate_lkb(struct dlm_ls *ls)
diff --git a/fs/dlm/memory.h b/fs/dlm/memory.h
index 485fb29..177c11c 100644
--- a/fs/dlm/memory.h
+++ b/fs/dlm/memory.h
@@ -16,7 +16,7 @@
 
 int dlm_memory_init(void);
 void dlm_memory_exit(void);
-struct dlm_rsb *dlm_allocate_rsb(struct dlm_ls *ls, int namelen);
+struct dlm_rsb *dlm_allocate_rsb(struct dlm_ls *ls);
 void dlm_free_rsb(struct dlm_rsb *r);
 struct dlm_lkb *dlm_allocate_lkb(struct dlm_ls *ls);
 void dlm_free_lkb(struct dlm_lkb *l);
-- 
1.7.6

