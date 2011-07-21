Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1GUQEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab1GUQEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:13 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] dlm: keep lkbs in idr
Date: Thu, 21 Jul 2011 11:04:03 -0500
Message-Id: <1311264247-28129-7-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is simpler and quicker than the hash table, and
avoids needing to search the hash list for every new
lkid to check if it's used.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/config.c       |    7 ---
 fs/dlm/config.h       |    1 -
 fs/dlm/dlm_internal.h |   14 ++----
 fs/dlm/lock.c         |   69 ++++++++++-------------------
 fs/dlm/lockspace.c    |  114 +++++++++++++++++++++++--------------------------
 5 files changed, 81 insertions(+), 124 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index ad3b5a8..4e20f93 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -94,7 +94,6 @@ struct dlm_cluster {
 	unsigned int cl_tcp_port;
 	unsigned int cl_buffer_size;
 	unsigned int cl_rsbtbl_size;
-	unsigned int cl_lkbtbl_size;
 	unsigned int cl_dirtbl_size;
 	unsigned int cl_recover_timer;
 	unsigned int cl_toss_secs;
@@ -109,7 +108,6 @@ enum {
 	CLUSTER_ATTR_TCP_PORT = 0,
 	CLUSTER_ATTR_BUFFER_SIZE,
 	CLUSTER_ATTR_RSBTBL_SIZE,
-	CLUSTER_ATTR_LKBTBL_SIZE,
 	CLUSTER_ATTR_DIRTBL_SIZE,
 	CLUSTER_ATTR_RECOVER_TIMER,
 	CLUSTER_ATTR_TOSS_SECS,
@@ -162,7 +160,6 @@ __CONFIGFS_ATTR(name, 0644, name##_read, name##_write)
 CLUSTER_ATTR(tcp_port, 1);
 CLUSTER_ATTR(buffer_size, 1);
 CLUSTER_ATTR(rsbtbl_size, 1);
-CLUSTER_ATTR(lkbtbl_size, 1);
 CLUSTER_ATTR(dirtbl_size, 1);
 CLUSTER_ATTR(recover_timer, 1);
 CLUSTER_ATTR(toss_secs, 1);
@@ -176,7 +173,6 @@ static struct configfs_attribute *cluster_attrs[] = {
 	[CLUSTER_ATTR_TCP_PORT] = &cluster_attr_tcp_port.attr,
 	[CLUSTER_ATTR_BUFFER_SIZE] = &cluster_attr_buffer_size.attr,
 	[CLUSTER_ATTR_RSBTBL_SIZE] = &cluster_attr_rsbtbl_size.attr,
-	[CLUSTER_ATTR_LKBTBL_SIZE] = &cluster_attr_lkbtbl_size.attr,
 	[CLUSTER_ATTR_DIRTBL_SIZE] = &cluster_attr_dirtbl_size.attr,
 	[CLUSTER_ATTR_RECOVER_TIMER] = &cluster_attr_recover_timer.attr,
 	[CLUSTER_ATTR_TOSS_SECS] = &cluster_attr_toss_secs.attr,
@@ -446,7 +442,6 @@ static struct config_group *make_cluster(struct config_group *g,
 	cl->cl_tcp_port = dlm_config.ci_tcp_port;
 	cl->cl_buffer_size = dlm_config.ci_buffer_size;
 	cl->cl_rsbtbl_size = dlm_config.ci_rsbtbl_size;
-	cl->cl_lkbtbl_size = dlm_config.ci_lkbtbl_size;
 	cl->cl_dirtbl_size = dlm_config.ci_dirtbl_size;
 	cl->cl_recover_timer = dlm_config.ci_recover_timer;
 	cl->cl_toss_secs = dlm_config.ci_toss_secs;
@@ -1038,7 +1033,6 @@ int dlm_our_addr(struct sockaddr_storage *addr, int num)
 #define DEFAULT_TCP_PORT       21064
 #define DEFAULT_BUFFER_SIZE     4096
 #define DEFAULT_RSBTBL_SIZE     1024
-#define DEFAULT_LKBTBL_SIZE     1024
 #define DEFAULT_DIRTBL_SIZE     1024
 #define DEFAULT_RECOVER_TIMER      5
 #define DEFAULT_TOSS_SECS         10
@@ -1052,7 +1046,6 @@ struct dlm_config_info dlm_config = {
 	.ci_tcp_port = DEFAULT_TCP_PORT,
 	.ci_buffer_size = DEFAULT_BUFFER_SIZE,
 	.ci_rsbtbl_size = DEFAULT_RSBTBL_SIZE,
-	.ci_lkbtbl_size = DEFAULT_LKBTBL_SIZE,
 	.ci_dirtbl_size = DEFAULT_DIRTBL_SIZE,
 	.ci_recover_timer = DEFAULT_RECOVER_TIMER,
 	.ci_toss_secs = DEFAULT_TOSS_SECS,
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index dd0ce24..2605744 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -20,7 +20,6 @@ struct dlm_config_info {
 	int ci_tcp_port;
 	int ci_buffer_size;
 	int ci_rsbtbl_size;
-	int ci_lkbtbl_size;
 	int ci_dirtbl_size;
 	int ci_recover_timer;
 	int ci_toss_secs;
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 0262451..23a234b 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -37,6 +37,7 @@
 #include <linux/jhash.h>
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
+#include <linux/idr.h>
 #include <asm/uaccess.h>
 
 #include <linux/dlm.h>
@@ -52,7 +53,6 @@ struct dlm_ls;
 struct dlm_lkb;
 struct dlm_rsb;
 struct dlm_member;
-struct dlm_lkbtable;
 struct dlm_rsbtable;
 struct dlm_dirtable;
 struct dlm_direntry;
@@ -108,11 +108,6 @@ struct dlm_rsbtable {
 	spinlock_t		lock;
 };
 
-struct dlm_lkbtable {
-	struct list_head	list;
-	rwlock_t		lock;
-	uint16_t		counter;
-};
 
 /*
  * Lockspace member (per node in a ls)
@@ -248,7 +243,6 @@ struct dlm_lkb {
 	int8_t			lkb_wait_count;
 	int			lkb_wait_nodeid; /* for debugging */
 
-	struct list_head	lkb_idtbl_list;	/* lockspace lkbtbl */
 	struct list_head	lkb_statequeue;	/* rsb g/c/w list */
 	struct list_head	lkb_rsb_lookup;	/* waiting for rsb lookup */
 	struct list_head	lkb_wait_reply;	/* waiting for remote reply */
@@ -465,12 +459,12 @@ struct dlm_ls {
 	unsigned long		ls_scan_time;
 	struct kobject		ls_kobj;
 
+	struct idr		ls_lkbidr;
+	spinlock_t		ls_lkbidr_spin;
+
 	struct dlm_rsbtable	*ls_rsbtbl;
 	uint32_t		ls_rsbtbl_size;
 
-	struct dlm_lkbtable	*ls_lkbtbl;
-	uint32_t		ls_lkbtbl_size;
-
 	struct dlm_dirtable	*ls_dirtbl;
 	uint32_t		ls_dirtbl_size;
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 3c72348..784cde4 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -580,9 +580,8 @@ static void detach_lkb(struct dlm_lkb *lkb)
 
 static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 {
-	struct dlm_lkb *lkb, *tmp;
-	uint32_t lkid = 0;
-	uint16_t bucket;
+	struct dlm_lkb *lkb;
+	int rv, id;
 
 	lkb = dlm_allocate_lkb(ls);
 	if (!lkb)
@@ -596,58 +595,38 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 	INIT_LIST_HEAD(&lkb->lkb_time_list);
 	INIT_LIST_HEAD(&lkb->lkb_astqueue);
 
-	get_random_bytes(&bucket, sizeof(bucket));
-	bucket &= (ls->ls_lkbtbl_size - 1);
-
-	write_lock(&ls->ls_lkbtbl[bucket].lock);
+ retry:
+	rv = idr_pre_get(&ls->ls_lkbidr, GFP_NOFS);
+	if (!rv)
+		return -ENOMEM;
 
-	/* counter can roll over so we must verify lkid is not in use */
+	spin_lock(&ls->ls_lkbidr_spin);
+	rv = idr_get_new_above(&ls->ls_lkbidr, lkb, 1, &id);
+	if (!rv)
+		lkb->lkb_id = id;
+	spin_unlock(&ls->ls_lkbidr_spin);
 
-	while (lkid == 0) {
-		lkid = (bucket << 16) | ls->ls_lkbtbl[bucket].counter++;
+	if (rv == -EAGAIN)
+		goto retry;
 
-		list_for_each_entry(tmp, &ls->ls_lkbtbl[bucket].list,
-				    lkb_idtbl_list) {
-			if (tmp->lkb_id != lkid)
-				continue;
-			lkid = 0;
-			break;
-		}
+	if (rv < 0) {
+		log_error(ls, "create_lkb idr error %d", rv);
+		return rv;
 	}
 
-	lkb->lkb_id = lkid;
-	list_add(&lkb->lkb_idtbl_list, &ls->ls_lkbtbl[bucket].list);
-	write_unlock(&ls->ls_lkbtbl[bucket].lock);
-
 	*lkb_ret = lkb;
 	return 0;
 }
 
-static struct dlm_lkb *__find_lkb(struct dlm_ls *ls, uint32_t lkid)
-{
-	struct dlm_lkb *lkb;
-	uint16_t bucket = (lkid >> 16);
-
-	list_for_each_entry(lkb, &ls->ls_lkbtbl[bucket].list, lkb_idtbl_list) {
-		if (lkb->lkb_id == lkid)
-			return lkb;
-	}
-	return NULL;
-}
-
 static int find_lkb(struct dlm_ls *ls, uint32_t lkid, struct dlm_lkb **lkb_ret)
 {
 	struct dlm_lkb *lkb;
-	uint16_t bucket = (lkid >> 16);
-
-	if (bucket >= ls->ls_lkbtbl_size)
-		return -EBADSLT;
 
-	read_lock(&ls->ls_lkbtbl[bucket].lock);
-	lkb = __find_lkb(ls, lkid);
+	spin_lock(&ls->ls_lkbidr_spin);
+	lkb = idr_find(&ls->ls_lkbidr, lkid);
 	if (lkb)
 		kref_get(&lkb->lkb_ref);
-	read_unlock(&ls->ls_lkbtbl[bucket].lock);
+	spin_unlock(&ls->ls_lkbidr_spin);
 
 	*lkb_ret = lkb;
 	return lkb ? 0 : -ENOENT;
@@ -668,12 +647,12 @@ static void kill_lkb(struct kref *kref)
 
 static int __put_lkb(struct dlm_ls *ls, struct dlm_lkb *lkb)
 {
-	uint16_t bucket = (lkb->lkb_id >> 16);
+	uint32_t lkid = lkb->lkb_id;
 
-	write_lock(&ls->ls_lkbtbl[bucket].lock);
+	spin_lock(&ls->ls_lkbidr_spin);
 	if (kref_put(&lkb->lkb_ref, kill_lkb)) {
-		list_del(&lkb->lkb_idtbl_list);
-		write_unlock(&ls->ls_lkbtbl[bucket].lock);
+		idr_remove(&ls->ls_lkbidr, lkid);
+		spin_unlock(&ls->ls_lkbidr_spin);
 
 		detach_lkb(lkb);
 
@@ -683,7 +662,7 @@ static int __put_lkb(struct dlm_ls *ls, struct dlm_lkb *lkb)
 		dlm_free_lkb(lkb);
 		return 1;
 	} else {
-		write_unlock(&ls->ls_lkbtbl[bucket].lock);
+		spin_unlock(&ls->ls_lkbidr_spin);
 		return 0;
 	}
 }
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 493d1e7..871fe6d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -472,17 +472,8 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 		spin_lock_init(&ls->ls_rsbtbl[i].lock);
 	}
 
-	size = dlm_config.ci_lkbtbl_size;
-	ls->ls_lkbtbl_size = size;
-
-	ls->ls_lkbtbl = vmalloc(sizeof(struct dlm_lkbtable) * size);
-	if (!ls->ls_lkbtbl)
-		goto out_rsbfree;
-	for (i = 0; i < size; i++) {
-		INIT_LIST_HEAD(&ls->ls_lkbtbl[i].list);
-		rwlock_init(&ls->ls_lkbtbl[i].lock);
-		ls->ls_lkbtbl[i].counter = 1;
-	}
+	idr_init(&ls->ls_lkbidr);
+	spin_lock_init(&ls->ls_lkbidr_spin);
 
 	size = dlm_config.ci_dirtbl_size;
 	ls->ls_dirtbl_size = size;
@@ -605,8 +596,7 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
  out_dirfree:
 	vfree(ls->ls_dirtbl);
  out_lkbfree:
-	vfree(ls->ls_lkbtbl);
- out_rsbfree:
+	idr_destroy(&ls->ls_lkbidr);
 	vfree(ls->ls_rsbtbl);
  out_lsfree:
 	if (do_unreg)
@@ -641,50 +631,66 @@ int dlm_new_lockspace(const char *name, int namelen, void **lockspace,
 	return error;
 }
 
-/* Return 1 if the lockspace still has active remote locks,
- *        2 if the lockspace still has active local locks.
- */
-static int lockspace_busy(struct dlm_ls *ls)
-{
-	int i, lkb_found = 0;
-	struct dlm_lkb *lkb;
-
-	/* NOTE: We check the lockidtbl here rather than the resource table.
-	   This is because there may be LKBs queued as ASTs that have been
-	   unlinked from their RSBs and are pending deletion once the AST has
-	   been delivered */
-
-	for (i = 0; i < ls->ls_lkbtbl_size; i++) {
-		read_lock(&ls->ls_lkbtbl[i].lock);
-		if (!list_empty(&ls->ls_lkbtbl[i].list)) {
-			lkb_found = 1;
-			list_for_each_entry(lkb, &ls->ls_lkbtbl[i].list,
-					    lkb_idtbl_list) {
-				if (!lkb->lkb_nodeid) {
-					read_unlock(&ls->ls_lkbtbl[i].lock);
-					return 2;
-				}
-			}
-		}
-		read_unlock(&ls->ls_lkbtbl[i].lock);
+static int lkb_idr_is_local(int id, void *p, void *data)
+{
+	struct dlm_lkb *lkb = p;
+
+	if (!lkb->lkb_nodeid)
+		return 1;
+	return 0;
+}
+
+static int lkb_idr_is_any(int id, void *p, void *data)
+{
+	return 1;
+}
+
+static int lkb_idr_free(int id, void *p, void *data)
+{
+	struct dlm_lkb *lkb = p;
+
+	dlm_del_ast(lkb);
+
+	if (lkb->lkb_lvbptr && lkb->lkb_flags & DLM_IFL_MSTCPY)
+		dlm_free_lvb(lkb->lkb_lvbptr);
+
+	dlm_free_lkb(lkb);
+	return 0;
+}
+
+/* NOTE: We check the lkbidr here rather than the resource table.
+   This is because there may be LKBs queued as ASTs that have been unlinked
+   from their RSBs and are pending deletion once the AST has been delivered */
+
+static int lockspace_busy(struct dlm_ls *ls, int force)
+{
+	int rv;
+
+	spin_lock(&ls->ls_lkbidr_spin);
+	if (force == 0) {
+		rv = idr_for_each(&ls->ls_lkbidr, lkb_idr_is_any, ls);
+	} else if (force == 1) {
+		rv = idr_for_each(&ls->ls_lkbidr, lkb_idr_is_local, ls);
+	} else {
+		rv = 0;
 	}
-	return lkb_found;
+	spin_unlock(&ls->ls_lkbidr_spin);
+	return rv;
 }
 
 static int release_lockspace(struct dlm_ls *ls, int force)
 {
-	struct dlm_lkb *lkb;
 	struct dlm_rsb *rsb;
 	struct list_head *head;
 	int i, busy, rv;
 
-	busy = lockspace_busy(ls);
+	busy = lockspace_busy(ls, force);
 
 	spin_lock(&lslist_lock);
 	if (ls->ls_create_count == 1) {
-		if (busy > force)
+		if (busy) {
 			rv = -EBUSY;
-		else {
+		} else {
 			/* remove_lockspace takes ls off lslist */
 			ls->ls_create_count = 0;
 			rv = 0;
@@ -724,29 +730,15 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	vfree(ls->ls_dirtbl);
 
 	/*
-	 * Free all lkb's on lkbtbl[] lists.
+	 * Free all lkb's in idr
 	 */
 
-	for (i = 0; i < ls->ls_lkbtbl_size; i++) {
-		head = &ls->ls_lkbtbl[i].list;
-		while (!list_empty(head)) {
-			lkb = list_entry(head->next, struct dlm_lkb,
-					 lkb_idtbl_list);
-
-			list_del(&lkb->lkb_idtbl_list);
-
-			dlm_del_ast(lkb);
+	idr_for_each(&ls->ls_lkbidr, lkb_idr_free, ls);
+	idr_remove_all(&ls->ls_lkbidr);
+	idr_destroy(&ls->ls_lkbidr);
 
-			if (lkb->lkb_lvbptr && lkb->lkb_flags & DLM_IFL_MSTCPY)
-				dlm_free_lvb(lkb->lkb_lvbptr);
-
-			dlm_free_lkb(lkb);
-		}
-	}
 	dlm_astd_resume();
 
-	vfree(ls->ls_lkbtbl);
-
 	/*
 	 * Free all rsb's on rsbtbl[] lists
 	 */
-- 
1.7.6

