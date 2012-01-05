Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964854Ab2AEQoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:44:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964816Ab2AEQo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:44:26 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] dlm: add recovery callbacks
Date: Thu,  5 Jan 2012 10:44:16 -0600
Message-Id: <1325781857-7938-5-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These new callbacks notify the dlm user about lock recovery.
GFS2, and possibly others, need to be aware of when the dlm
will be doing lock recovery for a failed lockspace member.

In the past, this coordination has been done between dlm and
file system daemons in userspace, which then direct their
kernel counterparts.  These callbacks allow the same
coordination directly, and more simply.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/config.c       |  130 ++++++++++++++++++--------------
 fs/dlm/config.h       |   17 +++-
 fs/dlm/dlm_internal.h |   21 ++----
 fs/dlm/lockspace.c    |   43 +++++++++--
 fs/dlm/member.c       |  197 +++++++++++++++++++++++++++++++------------------
 fs/dlm/member.h       |    3 +-
 fs/dlm/recoverd.c     |   10 +-
 fs/dlm/user.c         |    5 +-
 fs/gfs2/lock_dlm.c    |    4 +-
 fs/ocfs2/stack_user.c |    4 +-
 include/linux/dlm.h   |   71 ++++++++++++++++-
 11 files changed, 333 insertions(+), 172 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 6cf72fc..e7e327d 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/in.h>
 #include <linux/in6.h>
+#include <linux/dlmconstants.h>
 #include <net/ipv6.h>
 #include <net/sock.h>
 
@@ -36,6 +37,7 @@
 static struct config_group *space_list;
 static struct config_group *comm_list;
 static struct dlm_comm *local_comm;
+static uint32_t dlm_comm_count;
 
 struct dlm_clusters;
 struct dlm_cluster;
@@ -103,6 +105,8 @@ struct dlm_cluster {
 	unsigned int cl_timewarn_cs;
 	unsigned int cl_waitwarn_us;
 	unsigned int cl_new_rsb_count;
+	unsigned int cl_recover_callbacks;
+	char cl_cluster_name[DLM_LOCKSPACE_LEN];
 };
 
 enum {
@@ -118,6 +122,8 @@ enum {
 	CLUSTER_ATTR_TIMEWARN_CS,
 	CLUSTER_ATTR_WAITWARN_US,
 	CLUSTER_ATTR_NEW_RSB_COUNT,
+	CLUSTER_ATTR_RECOVER_CALLBACKS,
+	CLUSTER_ATTR_CLUSTER_NAME,
 };
 
 struct cluster_attribute {
@@ -126,6 +132,27 @@ struct cluster_attribute {
 	ssize_t (*store)(struct dlm_cluster *, const char *, size_t);
 };
 
+static ssize_t cluster_cluster_name_read(struct dlm_cluster *cl, char *buf)
+{
+	return sprintf(buf, "%s\n", cl->cl_cluster_name);
+}
+
+static ssize_t cluster_cluster_name_write(struct dlm_cluster *cl,
+					  const char *buf, size_t len)
+{
+	strncpy(dlm_config.ci_cluster_name, buf, DLM_LOCKSPACE_LEN);
+	strncpy(cl->cl_cluster_name, buf, DLM_LOCKSPACE_LEN);
+	return len;
+}
+
+static struct cluster_attribute cluster_attr_cluster_name = {
+	.attr   = { .ca_owner = THIS_MODULE,
+                    .ca_name = "cluster_name",
+                    .ca_mode = S_IRUGO | S_IWUSR },
+	.show   = cluster_cluster_name_read,
+	.store  = cluster_cluster_name_write,
+};
+
 static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
 			   int *info_field, int check_zero,
 			   const char *buf, size_t len)
@@ -171,6 +198,7 @@ CLUSTER_ATTR(protocol, 0);
 CLUSTER_ATTR(timewarn_cs, 1);
 CLUSTER_ATTR(waitwarn_us, 0);
 CLUSTER_ATTR(new_rsb_count, 0);
+CLUSTER_ATTR(recover_callbacks, 0);
 
 static struct configfs_attribute *cluster_attrs[] = {
 	[CLUSTER_ATTR_TCP_PORT] = &cluster_attr_tcp_port.attr,
@@ -185,6 +213,8 @@ static struct configfs_attribute *cluster_attrs[] = {
 	[CLUSTER_ATTR_TIMEWARN_CS] = &cluster_attr_timewarn_cs.attr,
 	[CLUSTER_ATTR_WAITWARN_US] = &cluster_attr_waitwarn_us.attr,
 	[CLUSTER_ATTR_NEW_RSB_COUNT] = &cluster_attr_new_rsb_count.attr,
+	[CLUSTER_ATTR_RECOVER_CALLBACKS] = &cluster_attr_recover_callbacks.attr,
+	[CLUSTER_ATTR_CLUSTER_NAME] = &cluster_attr_cluster_name.attr,
 	NULL,
 };
 
@@ -293,6 +323,7 @@ struct dlm_comms {
 
 struct dlm_comm {
 	struct config_item item;
+	int seq;
 	int nodeid;
 	int local;
 	int addr_count;
@@ -309,6 +340,7 @@ struct dlm_node {
 	int nodeid;
 	int weight;
 	int new;
+	int comm_seq; /* copy of cm->seq when nd->nodeid is set */
 };
 
 static struct configfs_group_operations clusters_ops = {
@@ -455,6 +487,9 @@ static struct config_group *make_cluster(struct config_group *g,
 	cl->cl_timewarn_cs = dlm_config.ci_timewarn_cs;
 	cl->cl_waitwarn_us = dlm_config.ci_waitwarn_us;
 	cl->cl_new_rsb_count = dlm_config.ci_new_rsb_count;
+	cl->cl_recover_callbacks = dlm_config.ci_recover_callbacks;
+	memcpy(cl->cl_cluster_name, dlm_config.ci_cluster_name,
+	       DLM_LOCKSPACE_LEN);
 
 	space_list = &sps->ss_group;
 	comm_list = &cms->cs_group;
@@ -558,6 +593,11 @@ static struct config_item *make_comm(struct config_group *g, const char *name)
 		return ERR_PTR(-ENOMEM);
 
 	config_item_init_type_name(&cm->item, name, &comm_type);
+
+	cm->seq = dlm_comm_count++;
+	if (!cm->seq)
+		cm->seq = dlm_comm_count++;
+
 	cm->nodeid = -1;
 	cm->local = 0;
 	cm->addr_count = 0;
@@ -801,7 +841,10 @@ static ssize_t node_nodeid_read(struct dlm_node *nd, char *buf)
 static ssize_t node_nodeid_write(struct dlm_node *nd, const char *buf,
 				 size_t len)
 {
+	uint32_t seq = 0;
 	nd->nodeid = simple_strtol(buf, NULL, 0);
+	dlm_comm_seq(nd->nodeid, &seq);
+	nd->comm_seq = seq;
 	return len;
 }
 
@@ -908,13 +951,13 @@ static void put_comm(struct dlm_comm *cm)
 }
 
 /* caller must free mem */
-int dlm_nodeid_list(char *lsname, int **ids_out, int *ids_count_out,
-		    int **new_out, int *new_count_out)
+int dlm_config_nodes(char *lsname, struct dlm_config_node **nodes_out,
+		     int *count_out)
 {
 	struct dlm_space *sp;
 	struct dlm_node *nd;
-	int i = 0, rv = 0, ids_count = 0, new_count = 0;
-	int *ids, *new;
+	struct dlm_config_node *nodes, *node;
+	int rv, count;
 
 	sp = get_space(lsname);
 	if (!sp)
@@ -927,73 +970,42 @@ int dlm_nodeid_list(char *lsname, int **ids_out, int *ids_count_out,
 		goto out;
 	}
 
-	ids_count = sp->members_count;
+	count = sp->members_count;
 
-	ids = kcalloc(ids_count, sizeof(int), GFP_NOFS);
-	if (!ids) {
+	nodes = kcalloc(count, sizeof(struct dlm_config_node), GFP_NOFS);
+	if (!nodes) {
 		rv = -ENOMEM;
 		goto out;
 	}
 
+	node = nodes;
 	list_for_each_entry(nd, &sp->members, list) {
-		ids[i++] = nd->nodeid;
-		if (nd->new)
-			new_count++;
-	}
-
-	if (ids_count != i)
-		printk(KERN_ERR "dlm: bad nodeid count %d %d\n", ids_count, i);
-
-	if (!new_count)
-		goto out_ids;
+		node->nodeid = nd->nodeid;
+		node->weight = nd->weight;
+		node->new = nd->new;
+		node->comm_seq = nd->comm_seq;
+		node++;
 
-	new = kcalloc(new_count, sizeof(int), GFP_NOFS);
-	if (!new) {
-		kfree(ids);
-		rv = -ENOMEM;
-		goto out;
+		nd->new = 0;
 	}
 
-	i = 0;
-	list_for_each_entry(nd, &sp->members, list) {
-		if (nd->new) {
-			new[i++] = nd->nodeid;
-			nd->new = 0;
-		}
-	}
-	*new_count_out = new_count;
-	*new_out = new;
-
- out_ids:
-	*ids_count_out = ids_count;
-	*ids_out = ids;
+	*count_out = count;
+	*nodes_out = nodes;
+	rv = 0;
  out:
 	mutex_unlock(&sp->members_lock);
 	put_space(sp);
 	return rv;
 }
 
-int dlm_node_weight(char *lsname, int nodeid)
+int dlm_comm_seq(int nodeid, uint32_t *seq)
 {
-	struct dlm_space *sp;
-	struct dlm_node *nd;
-	int w = -EEXIST;
-
-	sp = get_space(lsname);
-	if (!sp)
-		goto out;
-
-	mutex_lock(&sp->members_lock);
-	list_for_each_entry(nd, &sp->members, list) {
-		if (nd->nodeid != nodeid)
-			continue;
-		w = nd->weight;
-		break;
-	}
-	mutex_unlock(&sp->members_lock);
-	put_space(sp);
- out:
-	return w;
+	struct dlm_comm *cm = get_comm(nodeid, NULL);
+	if (!cm)
+		return -EEXIST;
+	*seq = cm->seq;
+	put_comm(cm);
+	return 0;
 }
 
 int dlm_nodeid_to_addr(int nodeid, struct sockaddr_storage *addr)
@@ -1047,6 +1059,8 @@ int dlm_our_addr(struct sockaddr_storage *addr, int num)
 #define DEFAULT_TIMEWARN_CS      500 /* 5 sec = 500 centiseconds */
 #define DEFAULT_WAITWARN_US	   0
 #define DEFAULT_NEW_RSB_COUNT    128
+#define DEFAULT_RECOVER_CALLBACKS  0
+#define DEFAULT_CLUSTER_NAME      ""
 
 struct dlm_config_info dlm_config = {
 	.ci_tcp_port = DEFAULT_TCP_PORT,
@@ -1060,6 +1074,8 @@ struct dlm_config_info dlm_config = {
 	.ci_protocol = DEFAULT_PROTOCOL,
 	.ci_timewarn_cs = DEFAULT_TIMEWARN_CS,
 	.ci_waitwarn_us = DEFAULT_WAITWARN_US,
-	.ci_new_rsb_count = DEFAULT_NEW_RSB_COUNT
+	.ci_new_rsb_count = DEFAULT_NEW_RSB_COUNT,
+	.ci_recover_callbacks = DEFAULT_RECOVER_CALLBACKS,
+	.ci_cluster_name = DEFAULT_CLUSTER_NAME
 };
 
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index 3099d0d..9f5e366 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -14,6 +14,13 @@
 #ifndef __CONFIG_DOT_H__
 #define __CONFIG_DOT_H__
 
+struct dlm_config_node {
+	int nodeid;
+	int weight;
+	int new;
+	uint32_t comm_seq;
+};
+
 #define DLM_MAX_ADDR_COUNT 3
 
 struct dlm_config_info {
@@ -29,15 +36,17 @@ struct dlm_config_info {
 	int ci_timewarn_cs;
 	int ci_waitwarn_us;
 	int ci_new_rsb_count;
+	int ci_recover_callbacks;
+	char ci_cluster_name[DLM_LOCKSPACE_LEN];
 };
 
 extern struct dlm_config_info dlm_config;
 
 int dlm_config_init(void);
 void dlm_config_exit(void);
-int dlm_node_weight(char *lsname, int nodeid);
-int dlm_nodeid_list(char *lsname, int **ids_out, int *ids_count_out,
-		    int **new_out, int *new_count_out);
+int dlm_config_nodes(char *lsname, struct dlm_config_node **nodes_out,
+		     int *count_out);
+int dlm_comm_seq(int nodeid, uint32_t *seq);
 int dlm_nodeid_to_addr(int nodeid, struct sockaddr_storage *addr);
 int dlm_addr_to_nodeid(struct sockaddr_storage *addr, int *nodeid);
 int dlm_our_nodeid(void);
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index f4d132c..3a564d1 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2010 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -119,28 +119,18 @@ struct dlm_member {
 	int			weight;
 	int			slot;
 	int			slot_prev;
+	int			comm_seq;
 	uint32_t		generation;
 };
 
 /*
- * low nodeid saves array of these in ls_slots
- */
-
-struct dlm_slot {
-	int			nodeid;
-	int			slot;
-};
-
-/*
  * Save and manage recovery state for a lockspace.
  */
 
 struct dlm_recover {
 	struct list_head	list;
-	int			*nodeids;   /* nodeids of all members */
-	int			node_count;
-	int			*new;       /* nodeids of new members */
-	int			new_count;
+	struct dlm_config_node	*nodes;
+	int			nodes_count;
 	uint64_t		seq;
 };
 
@@ -584,6 +574,9 @@ struct dlm_ls {
 	struct list_head	ls_root_list;	/* root resources */
 	struct rw_semaphore	ls_root_sem;	/* protect root_list */
 
+	const struct dlm_lockspace_ops *ls_ops;
+	void			*ls_ops_arg;
+
 	int			ls_namelen;
 	char			ls_name[1];
 };
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 1441f04..a1ea25f 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -386,12 +386,15 @@ static void threads_stop(void)
 	dlm_lowcomms_stop();
 }
 
-static int new_lockspace(const char *name, int namelen, void **lockspace,
-			 uint32_t flags, int lvblen)
+static int new_lockspace(const char *name, const char *cluster,
+			 uint32_t flags, int lvblen,
+			 const struct dlm_lockspace_ops *ops, void *ops_arg,
+			 int *ops_result, dlm_lockspace_t **lockspace)
 {
 	struct dlm_ls *ls;
 	int i, size, error;
 	int do_unreg = 0;
+	int namelen = strlen(name);
 
 	if (namelen > DLM_LOCKSPACE_LEN)
 		return -EINVAL;
@@ -403,8 +406,24 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 		return -EINVAL;
 
 	if (!dlm_user_daemon_available()) {
-		module_put(THIS_MODULE);
-		return -EUNATCH;
+		log_print("dlm user daemon not available");
+		error = -EUNATCH;
+		goto out;
+	}
+
+	if (ops && ops_result) {
+	       	if (!dlm_config.ci_recover_callbacks)
+			*ops_result = -EOPNOTSUPP;
+		else
+			*ops_result = 0;
+	}
+
+	if (dlm_config.ci_recover_callbacks && cluster &&
+	    strncmp(cluster, dlm_config.ci_cluster_name, DLM_LOCKSPACE_LEN)) {
+		log_print("dlm cluster name %s mismatch %s",
+			  dlm_config.ci_cluster_name, cluster);
+		error = -EBADR;
+		goto out;
 	}
 
 	error = 0;
@@ -442,6 +461,11 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	ls->ls_flags = 0;
 	ls->ls_scan_time = jiffies;
 
+	if (ops && dlm_config.ci_recover_callbacks) {
+		ls->ls_ops = ops;
+		ls->ls_ops_arg = ops_arg;
+	}
+
 	if (flags & DLM_LSFL_TIMEWARN)
 		set_bit(LSFL_TIMEWARN, &ls->ls_flags);
 
@@ -619,8 +643,10 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	return error;
 }
 
-int dlm_new_lockspace(const char *name, int namelen, void **lockspace,
-		      uint32_t flags, int lvblen)
+int dlm_new_lockspace(const char *name, const char *cluster,
+		      uint32_t flags, int lvblen,
+		      const struct dlm_lockspace_ops *ops, void *ops_arg,
+		      int *ops_result, dlm_lockspace_t **lockspace)
 {
 	int error = 0;
 
@@ -630,7 +656,8 @@ int dlm_new_lockspace(const char *name, int namelen, void **lockspace,
 	if (error)
 		goto out;
 
-	error = new_lockspace(name, namelen, lockspace, flags, lvblen);
+	error = new_lockspace(name, cluster, flags, lvblen, ops, ops_arg,
+			      ops_result, lockspace);
 	if (!error)
 		ls_count++;
 	if (error > 0)
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index eebc52a..862640a 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005-2009 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2011 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -27,7 +27,7 @@ int dlm_slots_version(struct dlm_header *h)
 }
 
 void dlm_slot_save(struct dlm_ls *ls, struct dlm_rcom *rc,
-		  struct dlm_member *memb)
+		   struct dlm_member *memb)
 {
 	struct rcom_config *rf = (struct rcom_config *)rc->rc_buf;
 
@@ -317,59 +317,51 @@ static void add_ordered_member(struct dlm_ls *ls, struct dlm_member *new)
 	}
 }
 
-static int dlm_add_member(struct dlm_ls *ls, int nodeid)
+static int dlm_add_member(struct dlm_ls *ls, struct dlm_config_node *node)
 {
 	struct dlm_member *memb;
-	int w, error;
+	int error;
 
 	memb = kzalloc(sizeof(struct dlm_member), GFP_NOFS);
 	if (!memb)
 		return -ENOMEM;
 
-	w = dlm_node_weight(ls->ls_name, nodeid);
-	if (w < 0) {
-		kfree(memb);
-		return w;
-	}
-
-	error = dlm_lowcomms_connect_node(nodeid);
+	error = dlm_lowcomms_connect_node(node->nodeid);
 	if (error < 0) {
 		kfree(memb);
 		return error;
 	}
 
-	memb->nodeid = nodeid;
-	memb->weight = w;
+	memb->nodeid = node->nodeid;
+	memb->weight = node->weight;
+	memb->comm_seq = node->comm_seq;
 	add_ordered_member(ls, memb);
 	ls->ls_num_nodes++;
 	return 0;
 }
 
-static void dlm_remove_member(struct dlm_ls *ls, struct dlm_member *memb)
-{
-	list_move(&memb->list, &ls->ls_nodes_gone);
-	ls->ls_num_nodes--;
-}
-
-int dlm_is_member(struct dlm_ls *ls, int nodeid)
+static struct dlm_member *find_memb(struct list_head *head, int nodeid)
 {
 	struct dlm_member *memb;
 
-	list_for_each_entry(memb, &ls->ls_nodes, list) {
+	list_for_each_entry(memb, head, list) {
 		if (memb->nodeid == nodeid)
-			return 1;
+			return memb;
 	}
+	return NULL;
+}
+
+int dlm_is_member(struct dlm_ls *ls, int nodeid)
+{
+	if (find_memb(&ls->ls_nodes, nodeid))
+		return 1;
 	return 0;
 }
 
 int dlm_is_removed(struct dlm_ls *ls, int nodeid)
 {
-	struct dlm_member *memb;
-
-	list_for_each_entry(memb, &ls->ls_nodes_gone, list) {
-		if (memb->nodeid == nodeid)
-			return 1;
-	}
+	if (find_memb(&ls->ls_nodes_gone, nodeid))
+		return 1;
 	return 0;
 }
 
@@ -460,10 +452,88 @@ static int ping_members(struct dlm_ls *ls)
 	return error;
 }
 
+static void dlm_lsop_recover_prep(struct dlm_ls *ls)
+{
+	if (!ls->ls_ops || !ls->ls_ops->recover_prep)
+		return;
+	ls->ls_ops->recover_prep(ls->ls_ops_arg);
+}
+
+static void dlm_lsop_recover_slot(struct dlm_ls *ls, struct dlm_member *memb)
+{
+	struct dlm_slot slot;
+	uint32_t seq;
+	int error;
+
+	if (!ls->ls_ops || !ls->ls_ops->recover_slot)
+		return;
+
+	/* if there is no comms connection with this node
+	   or the present comms connection is newer
+	   than the one when this member was added, then
+	   we consider the node to have failed (versus
+	   being removed due to dlm_release_lockspace) */
+
+	error = dlm_comm_seq(memb->nodeid, &seq);
+
+	if (!error && seq == memb->comm_seq)
+		return;
+
+	slot.nodeid = memb->nodeid;
+	slot.slot = memb->slot;
+
+	ls->ls_ops->recover_slot(ls->ls_ops_arg, &slot);
+}
+
+void dlm_lsop_recover_done(struct dlm_ls *ls)
+{
+	struct dlm_member *memb;
+	struct dlm_slot *slots;
+	int i, num;
+
+	if (!ls->ls_ops || !ls->ls_ops->recover_done)
+		return;
+
+	num = ls->ls_num_nodes;
+
+	slots = kzalloc(num * sizeof(struct dlm_slot), GFP_KERNEL);
+	if (!slots)
+		return;
+
+	i = 0;
+	list_for_each_entry(memb, &ls->ls_nodes, list) {
+		if (i == num) {
+			log_error(ls, "dlm_lsop_recover_done bad num %d", num);
+			goto out;
+		}
+		slots[i].nodeid = memb->nodeid;
+		slots[i].slot = memb->slot;
+		i++;
+	}
+
+	ls->ls_ops->recover_done(ls->ls_ops_arg, slots, num,
+				 ls->ls_slot, ls->ls_generation);
+ out:
+	kfree(slots);
+}
+
+static struct dlm_config_node *find_config_node(struct dlm_recover *rv,
+						int nodeid)
+{
+	int i;
+
+	for (i = 0; i < rv->nodes_count; i++) {
+		if (rv->nodes[i].nodeid == nodeid)
+			return &rv->nodes[i];
+	}
+	return NULL;
+}
+
 int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
 {
 	struct dlm_member *memb, *safe;
-	int i, error, found, pos = 0, neg = 0, low = -1;
+	struct dlm_config_node *node;
+	int i, error, neg = 0, low = -1;
 
 	/* previously removed members that we've not finished removing need to
 	   count as a negative change so the "neg" recovery steps will happen */
@@ -476,46 +546,32 @@ int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
 	/* move departed members from ls_nodes to ls_nodes_gone */
 
 	list_for_each_entry_safe(memb, safe, &ls->ls_nodes, list) {
-		found = 0;
-		for (i = 0; i < rv->node_count; i++) {
-			if (memb->nodeid == rv->nodeids[i]) {
-				found = 1;
-				break;
-			}
-		}
+		node = find_config_node(rv, memb->nodeid);
+		if (node && !node->new)
+			continue;
 
-		if (!found) {
-			neg++;
-			dlm_remove_member(ls, memb);
+		if (!node) {
 			log_debug(ls, "remove member %d", memb->nodeid);
+		} else {
+			/* removed and re-added */
+			log_debug(ls, "remove member %d comm_seq %u %u",
+				  memb->nodeid, memb->comm_seq, node->comm_seq);
 		}
-	}
-
-	/* Add an entry to ls_nodes_gone for members that were removed and
-	   then added again, so that previous state for these nodes will be
-	   cleared during recovery. */
 
-	for (i = 0; i < rv->new_count; i++) {
-		if (!dlm_is_member(ls, rv->new[i]))
-			continue;
-		log_debug(ls, "new nodeid %d is a re-added member", rv->new[i]);
-
-		memb = kzalloc(sizeof(struct dlm_member), GFP_NOFS);
-		if (!memb)
-			return -ENOMEM;
-		memb->nodeid = rv->new[i];
-		list_add_tail(&memb->list, &ls->ls_nodes_gone);
 		neg++;
+		list_move(&memb->list, &ls->ls_nodes_gone);
+		ls->ls_num_nodes--;
+		dlm_lsop_recover_slot(ls, memb);
 	}
 
 	/* add new members to ls_nodes */
 
-	for (i = 0; i < rv->node_count; i++) {
-		if (dlm_is_member(ls, rv->nodeids[i]))
+	for (i = 0; i < rv->nodes_count; i++) {
+		node = &rv->nodes[i];
+		if (dlm_is_member(ls, node->nodeid))
 			continue;
-		dlm_add_member(ls, rv->nodeids[i]);
-		pos++;
-		log_debug(ls, "add member %d", rv->nodeids[i]);
+		dlm_add_member(ls, node);
+		log_debug(ls, "add member %d", node->nodeid);
 	}
 
 	list_for_each_entry(memb, &ls->ls_nodes, list) {
@@ -609,21 +665,22 @@ int dlm_ls_stop(struct dlm_ls *ls)
 
 	if (!ls->ls_recover_begin)
 		ls->ls_recover_begin = jiffies;
+
+	dlm_lsop_recover_prep(ls);
 	return 0;
 }
 
 int dlm_ls_start(struct dlm_ls *ls)
 {
 	struct dlm_recover *rv = NULL, *rv_old;
-	int *ids = NULL, *new = NULL;
-	int error, ids_count = 0, new_count = 0;
+	struct dlm_config_node *nodes;
+	int error, count;
 
 	rv = kzalloc(sizeof(struct dlm_recover), GFP_NOFS);
 	if (!rv)
 		return -ENOMEM;
 
-	error = dlm_nodeid_list(ls->ls_name, &ids, &ids_count,
-				&new, &new_count);
+	error = dlm_config_nodes(ls->ls_name, &nodes, &count);
 	if (error < 0)
 		goto fail;
 
@@ -638,10 +695,8 @@ int dlm_ls_start(struct dlm_ls *ls)
 		goto fail;
 	}
 
-	rv->nodeids = ids;
-	rv->node_count = ids_count;
-	rv->new = new;
-	rv->new_count = new_count;
+	rv->nodes = nodes;
+	rv->nodes_count = count;
 	rv->seq = ++ls->ls_recover_seq;
 	rv_old = ls->ls_recover_args;
 	ls->ls_recover_args = rv;
@@ -649,9 +704,8 @@ int dlm_ls_start(struct dlm_ls *ls)
 
 	if (rv_old) {
 		log_error(ls, "unused recovery %llx %d",
-			  (unsigned long long)rv_old->seq, rv_old->node_count);
-		kfree(rv_old->nodeids);
-		kfree(rv_old->new);
+			  (unsigned long long)rv_old->seq, rv_old->nodes_count);
+		kfree(rv_old->nodes);
 		kfree(rv_old);
 	}
 
@@ -660,8 +714,7 @@ int dlm_ls_start(struct dlm_ls *ls)
 
  fail:
 	kfree(rv);
-	kfree(ids);
-	kfree(new);
+	kfree(nodes);
 	return error;
 }
 
diff --git a/fs/dlm/member.h b/fs/dlm/member.h
index 7e87e8a..3deb706 100644
--- a/fs/dlm/member.h
+++ b/fs/dlm/member.h
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2011 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -27,6 +27,7 @@ void dlm_slots_copy_out(struct dlm_ls *ls, struct dlm_rcom *rc);
 int dlm_slots_copy_in(struct dlm_ls *ls);
 int dlm_slots_assign(struct dlm_ls *ls, int *num_slots, int *slots_size,
 		     struct dlm_slot **slots_out, uint32_t *gen_out);
+void dlm_lsop_recover_done(struct dlm_ls *ls);
 
 #endif                          /* __MEMBER_DOT_H__ */
 
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 5a9e1a4..3780caf 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -227,11 +227,12 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	dlm_grant_after_purge(ls);
 
-	log_debug(ls, "dlm_recover %llx done: %u ms",
-		  (unsigned long long)rv->seq,
+	log_debug(ls, "dlm_recover %llx generation %u done: %u ms",
+		  (unsigned long long)rv->seq, ls->ls_generation,
 		  jiffies_to_msecs(jiffies - start));
 	mutex_unlock(&ls->ls_recoverd_active);
 
+	dlm_lsop_recover_done(ls);
 	return 0;
 
  fail:
@@ -259,8 +260,7 @@ static void do_ls_recovery(struct dlm_ls *ls)
 
 	if (rv) {
 		ls_recover(ls, rv);
-		kfree(rv->nodeids);
-		kfree(rv->new);
+		kfree(rv->nodes);
 		kfree(rv);
 	}
 }
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index d8ea607..eb4ed9b 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -392,8 +392,9 @@ static int device_create_lockspace(struct dlm_lspace_params *params)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	error = dlm_new_lockspace(params->name, strlen(params->name),
-				  &lockspace, params->flags, DLM_USER_LVB_LEN);
+	error = dlm_new_lockspace(params->name, NULL, params->flags,
+				  DLM_USER_LVB_LEN, NULL, NULL, NULL,
+				  &lockspace);
 	if (error)
 		return error;
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 98c80d8..ce85b62 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -195,10 +195,10 @@ static int gdlm_mount(struct gfs2_sbd *sdp, const char *fsname)
 		return -EINVAL;
 	}
 
-	error = dlm_new_lockspace(fsname, strlen(fsname), &ls->ls_dlm,
+	error = dlm_new_lockspace(fsname, NULL, 
 				  DLM_LSFL_FS | DLM_LSFL_NEWEXCL |
 				  (ls->ls_nodir ? DLM_LSFL_NODIR : 0),
-				  GDLM_LVB_SIZE);
+				  GDLM_LVB_SIZE, NULL, NULL, NULL, &ls->ls_dlm);
 	if (error)
 		printk(KERN_ERR "dlm_new_lockspace error %d", error);
 
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index a5ebe42..286edf1 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -827,8 +827,8 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 		goto out;
 	}
 
-	rc = dlm_new_lockspace(conn->cc_name, strlen(conn->cc_name),
-			       &fsdlm, DLM_LSFL_FS, DLM_LVB_LEN);
+	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
+			       NULL, NULL, NULL, &fsdlm);
 	if (rc) {
 		ocfs2_live_connection_drop(control);
 		goto out;
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index d4e02f5..6c7f6e9 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2011 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -74,15 +74,76 @@ struct dlm_lksb {
 
 #ifdef __KERNEL__
 
+struct dlm_slot {
+	int nodeid; /* 1 to MAX_INT */
+	int slot;   /* 1 to MAX_INT */
+};
+
+/*
+ * recover_prep: called before the dlm begins lock recovery.
+ *   Notfies lockspace user that locks from failed members will be granted.
+ * recover_slot: called after recover_prep and before recover_done.
+ *   Identifies a failed lockspace member.
+ * recover_done: called after the dlm completes lock recovery.
+ *   Identifies lockspace members and lockspace generation number.
+ */
+
+struct dlm_lockspace_ops {
+	void (*recover_prep) (void *ops_arg);
+	void (*recover_slot) (void *ops_arg, struct dlm_slot *slot);
+	void (*recover_done) (void *ops_arg, struct dlm_slot *slots,
+			      int num_slots, int our_slot, uint32_t generation);
+};
+
 /*
  * dlm_new_lockspace
  *
- * Starts a lockspace with the given name.  If the named lockspace exists in
- * the cluster, the calling node joins it.
+ * Create/join a lockspace.
+ *
+ * name: lockspace name, null terminated, up to DLM_LOCKSPACE_LEN (not
+ *   including terminating null).
+ *
+ * cluster: cluster name, null terminated, up to DLM_LOCKSPACE_LEN (not
+ *   including terminating null).  Optional.  When cluster is null, it
+ *   is not used.  When set, dlm_new_lockspace() returns -EBADR if cluster
+ *   is not equal to the dlm cluster name.
+ *
+ * flags:
+ * DLM_LSFL_NODIR
+ *   The dlm should not use a resource directory, but statically assign
+ *   resource mastery to nodes based on the name hash that is otherwise
+ *   used to select the directory node.  Must be the same on all nodes.
+ * DLM_LSFL_TIMEWARN
+ *   The dlm should emit netlink messages if locks have been waiting
+ *   for a configurable amount of time.  (Unused.)
+ * DLM_LSFL_FS
+ *   The lockspace user is in the kernel (i.e. filesystem).  Enables
+ *   direct bast/cast callbacks.
+ * DLM_LSFL_NEWEXCL
+ *   dlm_new_lockspace() should return -EEXIST if the lockspace exists.
+ *
+ * lvblen: length of lvb in bytes.  Must be multiple of 8.
+ *   dlm_new_lockspace() returns an error if this does not match
+ *   what other nodes are using.
+ *
+ * ops: callbacks that indicate lockspace recovery points so the
+ *   caller can coordinate its recovery and know lockspace members.
+ *   This is only used by the initial dlm_new_lockspace() call.
+ *   Optional.
+ *
+ * ops_arg: arg for ops callbacks.
+ *
+ * ops_result: tells caller if the ops callbacks (if provided) will
+ *   be used or not.  0: will be used, -EXXX will not be used.
+ *   -EOPNOTSUPP: the dlm does not have recovery_callbacks enabled.
+ *
+ * lockspace: handle for dlm functions
  */
 
-int dlm_new_lockspace(const char *name, int namelen,
-		      dlm_lockspace_t **lockspace, uint32_t flags, int lvblen);
+int dlm_new_lockspace(const char *name, const char *cluster,
+		      uint32_t flags, int lvblen,
+		      const struct dlm_lockspace_ops *ops, void *ops_arg,
+		      int *ops_result, dlm_lockspace_t **lockspace);
 
 /*
  * dlm_release_lockspace
-- 
1.7.6

