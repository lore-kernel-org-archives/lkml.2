Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867Ab2AEQoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:44:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab2AEQo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:44:26 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] dlm: add node slots and generation
Date: Thu,  5 Jan 2012 10:44:15 -0600
Message-Id: <1325781857-7938-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slot numbers are assigned to nodes when they join the lockspace.
The slot number chosen is the minimum unused value starting at 1.
Once a node is assigned a slot, that slot number will not change
while the node remains a lockspace member.  If the node leaves
and rejoins it can be assigned a new slot number.

A new generation number is also added to a lockspace.  It is
set and incremented during each recovery along with the slot
collection/assignment.

The slot numbers will be passed to gfs2 which will use them as
journal id's.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h |   48 ++++++++-
 fs/dlm/lockspace.c    |    5 +
 fs/dlm/member.c       |  284 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/dlm/member.h       |    7 ++
 fs/dlm/rcom.c         |   99 ++++++++++++++---
 fs/dlm/rcom.h         |    2 +-
 fs/dlm/recover.c      |   64 ++++++++++--
 7 files changed, 480 insertions(+), 29 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 5685a9a..f4d132c 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -117,6 +117,18 @@ struct dlm_member {
 	struct list_head	list;
 	int			nodeid;
 	int			weight;
+	int			slot;
+	int			slot_prev;
+	uint32_t		generation;
+};
+
+/*
+ * low nodeid saves array of these in ls_slots
+ */
+
+struct dlm_slot {
+	int			nodeid;
+	int			slot;
 };
 
 /*
@@ -337,7 +349,9 @@ static inline int rsb_flag(struct dlm_rsb *r, enum rsb_flags flag)
 /* dlm_header is first element of all structs sent between nodes */
 
 #define DLM_HEADER_MAJOR	0x00030000
-#define DLM_HEADER_MINOR	0x00000000
+#define DLM_HEADER_MINOR	0x00000001
+
+#define DLM_HEADER_SLOTS	0x00000001
 
 #define DLM_MSG			1
 #define DLM_RCOM		2
@@ -425,10 +439,34 @@ union dlm_packet {
 	struct dlm_rcom		rcom;
 };
 
+#define DLM_RSF_NEED_SLOTS	0x00000001
+
+/* RCOM_STATUS data */
+struct rcom_status {
+	__le32			rs_flags;
+	__le32			rs_unused1;
+	__le64			rs_unused2;
+};
+
+/* RCOM_STATUS_REPLY data */
 struct rcom_config {
 	__le32			rf_lvblen;
 	__le32			rf_lsflags;
-	__le64			rf_unused;
+
+	/* DLM_HEADER_SLOTS adds: */
+	__le32			rf_flags;
+	__le16			rf_our_slot;
+	__le16			rf_num_slots;
+	__le32			rf_generation;
+	__le32			rf_unused1;
+	__le64			rf_unused2;
+};
+
+struct rcom_slot {
+	__le32			ro_nodeid;
+	__le16			ro_slot;
+	__le16			ro_unused1;
+	__le64			ro_unused2;
 };
 
 struct rcom_lock {
@@ -455,6 +493,7 @@ struct dlm_ls {
 	struct list_head	ls_list;	/* list of lockspaces */
 	dlm_lockspace_t		*ls_local_handle;
 	uint32_t		ls_global_id;	/* global unique lockspace ID */
+	uint32_t		ls_generation;
 	uint32_t		ls_exflags;
 	int			ls_lvblen;
 	int			ls_count;	/* refcount of processes in
@@ -493,6 +532,11 @@ struct dlm_ls {
 	int			ls_total_weight;
 	int			*ls_node_array;
 
+	int			ls_slot;
+	int			ls_num_slots;
+	int			ls_slots_size;
+	struct dlm_slot		*ls_slots;
+
 	struct dlm_rsb		ls_stub_rsb;	/* for returning errors */
 	struct dlm_lkb		ls_stub_lkb;	/* for returning errors */
 	struct dlm_message	ls_stub_ms;	/* for faking a reply */
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 1d16a23..1441f04 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -525,6 +525,11 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	if (!ls->ls_recover_buf)
 		goto out_dirfree;
 
+	ls->ls_slot = 0;
+	ls->ls_num_slots = 0;
+	ls->ls_slots_size = 0;
+	ls->ls_slots = NULL;
+
 	INIT_LIST_HEAD(&ls->ls_recover_list);
 	spin_lock_init(&ls->ls_recover_list_lock);
 	ls->ls_recover_list_count = 0;
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index 5ebd1df..eebc52a 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -19,6 +19,280 @@
 #include "config.h"
 #include "lowcomms.h"
 
+int dlm_slots_version(struct dlm_header *h)
+{
+	if ((h->h_version & 0x0000FFFF) < DLM_HEADER_SLOTS)
+		return 0;
+	return 1;
+}
+
+void dlm_slot_save(struct dlm_ls *ls, struct dlm_rcom *rc,
+		  struct dlm_member *memb)
+{
+	struct rcom_config *rf = (struct rcom_config *)rc->rc_buf;
+
+	if (!dlm_slots_version(&rc->rc_header))
+		return;
+
+	memb->slot = le16_to_cpu(rf->rf_our_slot);
+	memb->generation = le32_to_cpu(rf->rf_generation);
+}
+
+void dlm_slots_copy_out(struct dlm_ls *ls, struct dlm_rcom *rc)
+{
+	struct dlm_slot *slot;
+	struct rcom_slot *ro;
+	int i;
+
+	ro = (struct rcom_slot *)(rc->rc_buf + sizeof(struct rcom_config));
+
+	/* ls_slots array is sparse, but not rcom_slots */
+
+	for (i = 0; i < ls->ls_slots_size; i++) {
+		slot = &ls->ls_slots[i];
+		if (!slot->nodeid)
+			continue;
+		ro->ro_nodeid = cpu_to_le32(slot->nodeid);
+		ro->ro_slot = cpu_to_le16(slot->slot);
+		ro++;
+	}
+}
+
+#define SLOT_DEBUG_LINE 128
+
+static void log_debug_slots(struct dlm_ls *ls, uint32_t gen, int num_slots,
+			    struct rcom_slot *ro0, struct dlm_slot *array,
+			    int array_size)
+{
+	char line[SLOT_DEBUG_LINE];
+	int len = SLOT_DEBUG_LINE - 1;
+	int pos = 0;
+	int ret, i;
+
+	if (!dlm_config.ci_log_debug)
+		return;
+
+	memset(line, 0, sizeof(line));
+
+	if (array) {
+		for (i = 0; i < array_size; i++) {
+			if (!array[i].nodeid)
+				continue;
+
+			ret = snprintf(line + pos, len - pos, " %d:%d",
+				       array[i].slot, array[i].nodeid);
+			if (ret >= len - pos)
+				break;
+			pos += ret;
+		}
+	} else if (ro0) {
+		for (i = 0; i < num_slots; i++) {
+			ret = snprintf(line + pos, len - pos, " %d:%d",
+				       ro0[i].ro_slot, ro0[i].ro_nodeid);
+			if (ret >= len - pos)
+				break;
+			pos += ret;
+		}
+	}
+
+	log_debug(ls, "generation %u slots %d%s", gen, num_slots, line);
+}
+
+int dlm_slots_copy_in(struct dlm_ls *ls)
+{
+	struct dlm_member *memb;
+	struct dlm_rcom *rc = ls->ls_recover_buf;
+	struct rcom_config *rf = (struct rcom_config *)rc->rc_buf;
+	struct rcom_slot *ro0, *ro;
+	int our_nodeid = dlm_our_nodeid();
+	int i, num_slots;
+	uint32_t gen;
+
+	if (!dlm_slots_version(&rc->rc_header))
+		return -1;
+
+	gen = le32_to_cpu(rf->rf_generation);
+	if (gen <= ls->ls_generation) {
+		log_error(ls, "dlm_slots_copy_in gen %u old %u",
+			  gen, ls->ls_generation);
+	}
+	ls->ls_generation = gen;
+
+	num_slots = le16_to_cpu(rf->rf_num_slots);
+	if (!num_slots)
+		return -1;
+
+	ro0 = (struct rcom_slot *)(rc->rc_buf + sizeof(struct rcom_config));
+
+	for (i = 0, ro = ro0; i < num_slots; i++, ro++) {
+		ro->ro_nodeid = le32_to_cpu(ro->ro_nodeid);
+		ro->ro_slot = le16_to_cpu(ro->ro_slot);
+	}
+
+	log_debug_slots(ls, gen, num_slots, ro0, NULL, 0);
+
+	list_for_each_entry(memb, &ls->ls_nodes, list) {
+		for (i = 0, ro = ro0; i < num_slots; i++, ro++) {
+			if (ro->ro_nodeid != memb->nodeid)
+				continue;
+			memb->slot = ro->ro_slot;
+			memb->slot_prev = memb->slot;
+			break;
+		}
+
+		if (memb->nodeid == our_nodeid) {
+			if (ls->ls_slot && ls->ls_slot != memb->slot) {
+				log_error(ls, "dlm_slots_copy_in our slot "
+					  "changed %d %d", ls->ls_slot,
+					  memb->slot);
+				return -1;
+			}
+
+			if (!ls->ls_slot)
+				ls->ls_slot = memb->slot;
+		}
+
+		if (!memb->slot) {
+			log_error(ls, "dlm_slots_copy_in nodeid %d no slot",
+				   memb->nodeid);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/* for any nodes that do not support slots, we will not have set memb->slot
+   in wait_status_all(), so memb->slot will remain -1, and we will not
+   assign slots or set ls_num_slots here */
+
+int dlm_slots_assign(struct dlm_ls *ls, int *num_slots, int *slots_size,
+		     struct dlm_slot **slots_out, uint32_t *gen_out)
+{
+	struct dlm_member *memb;
+	struct dlm_slot *array;
+	int our_nodeid = dlm_our_nodeid();
+	int array_size, max_slots, i;
+	int need = 0;
+	int max = 0;
+	int num = 0;
+	uint32_t gen = 0;
+
+	/* our own memb struct will have slot -1 gen 0 */
+
+	list_for_each_entry(memb, &ls->ls_nodes, list) {
+		if (memb->nodeid == our_nodeid) {
+			memb->slot = ls->ls_slot;
+			memb->generation = ls->ls_generation;
+			break;
+		}
+	}
+
+	list_for_each_entry(memb, &ls->ls_nodes, list) {
+		if (memb->generation > gen)
+			gen = memb->generation;
+
+		/* node doesn't support slots */
+
+		if (memb->slot == -1)
+			return -1;
+
+		/* node needs a slot assigned */
+
+		if (!memb->slot)
+			need++;
+
+		/* node has a slot assigned */
+
+		num++;
+
+		if (!max || max < memb->slot)
+			max = memb->slot;
+
+		/* sanity check, once slot is assigned it shouldn't change */
+
+		if (memb->slot_prev && memb->slot && memb->slot_prev != memb->slot) {
+			log_error(ls, "nodeid %d slot changed %d %d",
+				  memb->nodeid, memb->slot_prev, memb->slot);
+			return -1;
+		}
+		memb->slot_prev = memb->slot;
+	}
+
+	array_size = max + need;
+
+	array = kzalloc(array_size * sizeof(struct dlm_slot), GFP_NOFS);
+	if (!array)
+		return -ENOMEM;
+
+	num = 0;
+
+	/* fill in slots (offsets) that are used */
+
+	list_for_each_entry(memb, &ls->ls_nodes, list) {
+		if (!memb->slot)
+			continue;
+
+		if (memb->slot > array_size) {
+			log_error(ls, "invalid slot number %d", memb->slot);
+			kfree(array);
+			return -1;
+		}
+
+		array[memb->slot - 1].nodeid = memb->nodeid;
+		array[memb->slot - 1].slot = memb->slot;
+		num++;
+	}
+
+	/* assign new slots from unused offsets */
+
+	list_for_each_entry(memb, &ls->ls_nodes, list) {
+		if (memb->slot)
+			continue;
+
+		for (i = 0; i < array_size; i++) {
+			if (array[i].nodeid)
+				continue;
+
+			memb->slot = i + 1;
+			memb->slot_prev = memb->slot;
+			array[i].nodeid = memb->nodeid;
+			array[i].slot = memb->slot;
+			num++;
+
+			if (!ls->ls_slot && memb->nodeid == our_nodeid)
+				ls->ls_slot = memb->slot;
+			break;
+		}
+
+		if (!memb->slot) {
+			log_error(ls, "no free slot found");
+			kfree(array);
+			return -1;
+		}
+	}
+
+	gen++;
+
+	log_debug_slots(ls, gen, num, NULL, array, array_size);
+
+	max_slots = (dlm_config.ci_buffer_size - sizeof(struct dlm_rcom) -
+		     sizeof(struct rcom_config)) / sizeof(struct rcom_slot);
+
+	if (num > max_slots) {
+		log_error(ls, "num_slots %d exceeds max_slots %d",
+			  num, max_slots);
+		kfree(array);
+		return -1;
+	}
+
+	*gen_out = gen;
+	*slots_out = array;
+	*slots_size = array_size;
+	*num_slots = num;
+	return 0;
+}
+
 static void add_ordered_member(struct dlm_ls *ls, struct dlm_member *new)
 {
 	struct dlm_member *memb = NULL;
@@ -176,7 +450,7 @@ static int ping_members(struct dlm_ls *ls)
 		error = dlm_recovery_stopped(ls);
 		if (error)
 			break;
-		error = dlm_rcom_status(ls, memb->nodeid);
+		error = dlm_rcom_status(ls, memb->nodeid, 0);
 		if (error)
 			break;
 	}
@@ -322,7 +596,15 @@ int dlm_ls_stop(struct dlm_ls *ls)
 	 */
 
 	dlm_recoverd_suspend(ls);
+
+	spin_lock(&ls->ls_recover_lock);
+	kfree(ls->ls_slots);
+	ls->ls_slots = NULL;
+	ls->ls_num_slots = 0;
+	ls->ls_slots_size = 0;
 	ls->ls_recover_status = 0;
+	spin_unlock(&ls->ls_recover_lock);
+
 	dlm_recoverd_resume(ls);
 
 	if (!ls->ls_recover_begin)
diff --git a/fs/dlm/member.h b/fs/dlm/member.h
index 7a26fca..7e87e8a 100644
--- a/fs/dlm/member.h
+++ b/fs/dlm/member.h
@@ -20,6 +20,13 @@ void dlm_clear_members_gone(struct dlm_ls *ls);
 int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv,int *neg_out);
 int dlm_is_removed(struct dlm_ls *ls, int nodeid);
 int dlm_is_member(struct dlm_ls *ls, int nodeid);
+int dlm_slots_version(struct dlm_header *h);
+void dlm_slot_save(struct dlm_ls *ls, struct dlm_rcom *rc,
+		   struct dlm_member *memb);
+void dlm_slots_copy_out(struct dlm_ls *ls, struct dlm_rcom *rc);
+int dlm_slots_copy_in(struct dlm_ls *ls);
+int dlm_slots_assign(struct dlm_ls *ls, int *num_slots, int *slots_size,
+		     struct dlm_slot **slots_out, uint32_t *gen_out);
 
 #endif                          /* __MEMBER_DOT_H__ */
 
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index f10a50f..ac5c616 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -23,6 +23,7 @@
 #include "memory.h"
 #include "lock.h"
 #include "util.h"
+#include "member.h"
 
 
 static int rcom_response(struct dlm_ls *ls)
@@ -72,20 +73,30 @@ static void send_rcom(struct dlm_ls *ls, struct dlm_mhandle *mh,
 	dlm_lowcomms_commit_buffer(mh);
 }
 
+static void set_rcom_status(struct dlm_ls *ls, struct rcom_status *rs,
+			    uint32_t flags)
+{
+	rs->rs_flags = cpu_to_le32(flags);
+}
+
 /* When replying to a status request, a node also sends back its
    configuration values.  The requesting node then checks that the remote
    node is configured the same way as itself. */
 
-static void make_config(struct dlm_ls *ls, struct rcom_config *rf)
+static void set_rcom_config(struct dlm_ls *ls, struct rcom_config *rf,
+			    uint32_t num_slots)
 {
 	rf->rf_lvblen = cpu_to_le32(ls->ls_lvblen);
 	rf->rf_lsflags = cpu_to_le32(ls->ls_exflags);
+
+	rf->rf_our_slot = cpu_to_le16(ls->ls_slot);
+	rf->rf_num_slots = cpu_to_le16(num_slots);
+	rf->rf_generation =  cpu_to_le32(ls->ls_generation);
 }
 
-static int check_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
+static int check_rcom_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 {
 	struct rcom_config *rf = (struct rcom_config *) rc->rc_buf;
-	size_t conf_size = sizeof(struct dlm_rcom) + sizeof(struct rcom_config);
 
 	if ((rc->rc_header.h_version & 0xFFFF0000) != DLM_HEADER_MAJOR) {
 		log_error(ls, "version mismatch: %x nodeid %d: %x",
@@ -94,12 +105,6 @@ static int check_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		return -EPROTO;
 	}
 
-	if (rc->rc_header.h_length < conf_size) {
-		log_error(ls, "config too short: %d nodeid %d",
-			  rc->rc_header.h_length, nodeid);
-		return -EPROTO;
-	}
-
 	if (le32_to_cpu(rf->rf_lvblen) != ls->ls_lvblen ||
 	    le32_to_cpu(rf->rf_lsflags) != ls->ls_exflags) {
 		log_error(ls, "config mismatch: %d,%x nodeid %d: %d,%x",
@@ -127,7 +132,18 @@ static void disallow_sync_reply(struct dlm_ls *ls)
 	spin_unlock(&ls->ls_rcom_spin);
 }
 
-int dlm_rcom_status(struct dlm_ls *ls, int nodeid)
+/*
+ * low nodeid gathers one slot value at a time from each node.
+ * it sets need_slots=0, and saves rf_our_slot returned from each
+ * rcom_config.
+ *
+ * other nodes gather all slot values at once from the low nodeid.
+ * they set need_slots=1, and ignore the rf_our_slot returned from each
+ * rcom_config.  they use the rf_num_slots returned from the low
+ * node's rcom_config.
+ */
+
+int dlm_rcom_status(struct dlm_ls *ls, int nodeid, uint32_t status_flags)
 {
 	struct dlm_rcom *rc;
 	struct dlm_mhandle *mh;
@@ -141,10 +157,13 @@ int dlm_rcom_status(struct dlm_ls *ls, int nodeid)
 		goto out;
 	}
 
-	error = create_rcom(ls, nodeid, DLM_RCOM_STATUS, 0, &rc, &mh);
+	error = create_rcom(ls, nodeid, DLM_RCOM_STATUS,
+			    sizeof(struct rcom_status), &rc, &mh);
 	if (error)
 		goto out;
 
+	set_rcom_status(ls, (struct rcom_status *)rc->rc_buf, status_flags);
+
 	allow_sync_reply(ls, &rc->rc_id);
 	memset(ls->ls_recover_buf, 0, dlm_config.ci_buffer_size);
 
@@ -161,8 +180,11 @@ int dlm_rcom_status(struct dlm_ls *ls, int nodeid)
 		/* we pretend the remote lockspace exists with 0 status */
 		log_debug(ls, "remote node %d not ready", nodeid);
 		rc->rc_result = 0;
-	} else
-		error = check_config(ls, rc, nodeid);
+		error = 0;
+	} else {
+		error = check_rcom_config(ls, rc, nodeid);
+	}
+
 	/* the caller looks at rc_result for the remote recovery status */
  out:
 	return error;
@@ -172,17 +194,60 @@ static void receive_rcom_status(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 {
 	struct dlm_rcom *rc;
 	struct dlm_mhandle *mh;
-	int error, nodeid = rc_in->rc_header.h_nodeid;
+	struct rcom_status *rs;
+	uint32_t status;
+	int nodeid = rc_in->rc_header.h_nodeid;
+	int len = sizeof(struct rcom_config);
+	int num_slots = 0;
+	int error;
+
+	if (!dlm_slots_version(&rc_in->rc_header)) {
+		status = dlm_recover_status(ls);
+		goto do_create;
+	}
+
+	rs = (struct rcom_status *)rc_in->rc_buf;
 
+	if (!(rs->rs_flags & DLM_RSF_NEED_SLOTS)) {
+		status = dlm_recover_status(ls);
+		goto do_create;
+	}
+
+	spin_lock(&ls->ls_recover_lock);
+	status = ls->ls_recover_status;
+	num_slots = ls->ls_num_slots;
+	spin_unlock(&ls->ls_recover_lock);
+	len += num_slots * sizeof(struct rcom_slot);
+
+ do_create:
 	error = create_rcom(ls, nodeid, DLM_RCOM_STATUS_REPLY,
-			    sizeof(struct rcom_config), &rc, &mh);
+			    len, &rc, &mh);
 	if (error)
 		return;
+
 	rc->rc_id = rc_in->rc_id;
 	rc->rc_seq_reply = rc_in->rc_seq;
-	rc->rc_result = dlm_recover_status(ls);
-	make_config(ls, (struct rcom_config *) rc->rc_buf);
+	rc->rc_result = status;
+
+	set_rcom_config(ls, (struct rcom_config *)rc->rc_buf, num_slots);
+
+	if (!num_slots)
+		goto do_send;
+
+	spin_lock(&ls->ls_recover_lock);
+	if (ls->ls_num_slots != num_slots) {
+		spin_unlock(&ls->ls_recover_lock);
+		log_debug(ls, "receive_rcom_status num_slots %d to %d",
+			  num_slots, ls->ls_num_slots);
+		rc->rc_result = 0;
+		set_rcom_config(ls, (struct rcom_config *)rc->rc_buf, 0);
+		goto do_send;
+	}
+
+	dlm_slots_copy_out(ls, rc);
+	spin_unlock(&ls->ls_recover_lock);
 
+ do_send:
 	send_rcom(ls, mh, rc);
 }
 
diff --git a/fs/dlm/rcom.h b/fs/dlm/rcom.h
index b09abd2..206723a 100644
--- a/fs/dlm/rcom.h
+++ b/fs/dlm/rcom.h
@@ -14,7 +14,7 @@
 #ifndef __RCOM_DOT_H__
 #define __RCOM_DOT_H__
 
-int dlm_rcom_status(struct dlm_ls *ls, int nodeid);
+int dlm_rcom_status(struct dlm_ls *ls, int nodeid, uint32_t status_flags);
 int dlm_rcom_names(struct dlm_ls *ls, int nodeid, char *last_name,int last_len);
 int dlm_send_rcom_lookup(struct dlm_rsb *r, int dir_nodeid);
 int dlm_send_rcom_lock(struct dlm_rsb *r, struct dlm_lkb *lkb);
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index 81b2393..34d5adf1f 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -85,14 +85,20 @@ uint32_t dlm_recover_status(struct dlm_ls *ls)
 	return status;
 }
 
+static void _set_recover_status(struct dlm_ls *ls, uint32_t status)
+{
+	ls->ls_recover_status |= status;
+}
+
 void dlm_set_recover_status(struct dlm_ls *ls, uint32_t status)
 {
 	spin_lock(&ls->ls_recover_lock);
-	ls->ls_recover_status |= status;
+	_set_recover_status(ls, status);
 	spin_unlock(&ls->ls_recover_lock);
 }
 
-static int wait_status_all(struct dlm_ls *ls, uint32_t wait_status)
+static int wait_status_all(struct dlm_ls *ls, uint32_t wait_status,
+			   int save_slots)
 {
 	struct dlm_rcom *rc = ls->ls_recover_buf;
 	struct dlm_member *memb;
@@ -106,10 +112,13 @@ static int wait_status_all(struct dlm_ls *ls, uint32_t wait_status)
 				goto out;
 			}
 
-			error = dlm_rcom_status(ls, memb->nodeid);
+			error = dlm_rcom_status(ls, memb->nodeid, 0);
 			if (error)
 				goto out;
 
+			if (save_slots)
+				dlm_slot_save(ls, rc, memb);
+
 			if (rc->rc_result & wait_status)
 				break;
 			if (delay < 1000)
@@ -121,7 +130,8 @@ static int wait_status_all(struct dlm_ls *ls, uint32_t wait_status)
 	return error;
 }
 
-static int wait_status_low(struct dlm_ls *ls, uint32_t wait_status)
+static int wait_status_low(struct dlm_ls *ls, uint32_t wait_status,
+			   uint32_t status_flags)
 {
 	struct dlm_rcom *rc = ls->ls_recover_buf;
 	int error = 0, delay = 0, nodeid = ls->ls_low_nodeid;
@@ -132,7 +142,7 @@ static int wait_status_low(struct dlm_ls *ls, uint32_t wait_status)
 			goto out;
 		}
 
-		error = dlm_rcom_status(ls, nodeid);
+		error = dlm_rcom_status(ls, nodeid, status_flags);
 		if (error)
 			break;
 
@@ -152,18 +162,56 @@ static int wait_status(struct dlm_ls *ls, uint32_t status)
 	int error;
 
 	if (ls->ls_low_nodeid == dlm_our_nodeid()) {
-		error = wait_status_all(ls, status);
+		error = wait_status_all(ls, status, 0);
 		if (!error)
 			dlm_set_recover_status(ls, status_all);
 	} else
-		error = wait_status_low(ls, status_all);
+		error = wait_status_low(ls, status_all, 0);
 
 	return error;
 }
 
 int dlm_recover_members_wait(struct dlm_ls *ls)
 {
-	return wait_status(ls, DLM_RS_NODES);
+	struct dlm_member *memb;
+	struct dlm_slot *slots;
+	int num_slots, slots_size;
+	int error, rv;
+	uint32_t gen;
+
+	list_for_each_entry(memb, &ls->ls_nodes, list) {
+		memb->slot = -1;
+		memb->generation = 0;
+	}
+
+	if (ls->ls_low_nodeid == dlm_our_nodeid()) {
+		error = wait_status_all(ls, DLM_RS_NODES, 1);
+		if (error)
+			goto out;
+
+		/* slots array is sparse, slots_size may be > num_slots */
+
+		rv = dlm_slots_assign(ls, &num_slots, &slots_size, &slots, &gen);
+		if (!rv) {
+			spin_lock(&ls->ls_recover_lock);
+			_set_recover_status(ls, DLM_RS_NODES_ALL);
+			ls->ls_num_slots = num_slots;
+			ls->ls_slots_size = slots_size;
+			ls->ls_slots = slots;
+			ls->ls_generation = gen;
+			spin_unlock(&ls->ls_recover_lock);
+		} else {
+			dlm_set_recover_status(ls, DLM_RS_NODES_ALL);
+		}
+	} else {
+		error = wait_status_low(ls, DLM_RS_NODES_ALL, DLM_RSF_NEED_SLOTS);
+		if (error)
+			goto out;
+
+		dlm_slots_copy_in(ls);
+	}
+ out:
+	return error;
 }
 
 int dlm_recover_directory_wait(struct dlm_ls *ls)
-- 
1.7.6

