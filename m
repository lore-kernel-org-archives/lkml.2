Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab0GGVwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:52:18 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:34451 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab0GGVu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=EiAO/QXVHRMdfNpJ39GPyb9A3tQBLtnv1
	JQvebxtRJ+38GqW1i5coWK9tHy2SWBMWM/C07HvmGl63VX1Fzvgi33c2ddskG/mq
	L3nd2zeBSVT1Dt9NX2Xa05yDIJDrrtpQjFTq2boyExVQSKm5R5HfM8sUL/nqvdJR
	PXX/J1/TPk=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       sage@newdream.net, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH v3 06/10] ceph-rbd: generalize mon requests, add pool op support
Date: Wed,  7 Jul 2010 15:11:28 -0700
Message-Id: <617e8b0a821b32995a9b1eefc51b7ae8dbe5cf60.1278539315.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize the current statfs synchronous requests, and support pool_ops.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/mon_client.c |  170 +++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ceph/mon_client.h |    5 ++
 2 files changed, 158 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/mon_client.c b/fs/ceph/mon_client.c
index 4e022ed..c1082e8 100644
--- a/fs/ceph/mon_client.c
+++ b/fs/ceph/mon_client.c
@@ -349,7 +349,7 @@ out:
 }
 
 /*
- * statfs
+ * generic requests (e.g., statfs, poolop)
  */
 static struct ceph_mon_generic_request *__lookup_generic_req(
 	struct ceph_mon_client *monc, u64 tid)
@@ -442,6 +442,35 @@ static struct ceph_msg *get_generic_reply(struct ceph_connection *con,
 	return m;
 }
 
+static int do_generic_request(struct ceph_mon_client *monc,
+			      struct ceph_mon_generic_request *req)
+{
+	int err;
+
+	/* register request */
+	mutex_lock(&monc->mutex);
+	req->tid = ++monc->last_tid;
+	req->request->hdr.tid = cpu_to_le64(req->tid);
+	__insert_generic_request(monc, req);
+	monc->num_generic_requests++;
+	ceph_con_send(monc->con, ceph_msg_get(req->request));
+	mutex_unlock(&monc->mutex);
+
+	err = wait_for_completion_interruptible(&req->completion);
+
+	mutex_lock(&monc->mutex);
+	rb_erase(&req->node, &monc->generic_request_tree);
+	monc->num_generic_requests--;
+	mutex_unlock(&monc->mutex);
+
+	if (!err)
+		err = req->result;
+	return err;
+}
+
+/*
+ * statfs
+ */
 static void handle_statfs_reply(struct ceph_mon_client *monc,
 				struct ceph_msg *msg)
 {
@@ -468,7 +497,7 @@ static void handle_statfs_reply(struct ceph_mon_client *monc,
 	return;
 
 bad:
-	pr_err("corrupt generic reply, no tid\n");
+	pr_err("corrupt generic reply, tid %llu\n", tid);
 	ceph_msg_dump(msg);
 }
 
@@ -487,6 +516,7 @@ int ceph_monc_do_statfs(struct ceph_mon_client *monc, struct ceph_statfs *buf)
 
 	kref_init(&req->kref);
 	req->buf = buf;
+	req->buf_len = sizeof(*buf);
 	init_completion(&req->completion);
 
 	err = -ENOMEM;
@@ -504,33 +534,134 @@ int ceph_monc_do_statfs(struct ceph_mon_client *monc, struct ceph_statfs *buf)
 	h->monhdr.session_mon_tid = 0;
 	h->fsid = monc->monmap->fsid;
 
-	/* register request */
-	mutex_lock(&monc->mutex);
-	req->tid = ++monc->last_tid;
-	req->request->hdr.tid = cpu_to_le64(req->tid);
-	__insert_generic_request(monc, req);
-	monc->num_generic_requests++;
-	mutex_unlock(&monc->mutex);
+	err = do_generic_request(monc, req);
 
-	/* send request and wait */
-	ceph_con_send(monc->con, ceph_msg_get(req->request));
-	err = wait_for_completion_interruptible(&req->completion);
+out:
+	kref_put(&req->kref, release_generic_request);
+	return err;
+}
+
+/*
+ * pool ops
+ */
+static int get_poolop_reply_buf(const char *src, size_t src_len,
+				char *dst, size_t dst_len)
+{
+	u32 buf_len;
+
+	if (src_len != sizeof(u32) + dst_len)
+		return -EINVAL;
+
+	buf_len = le32_to_cpu(*(u32 *)src);
+	if (buf_len != dst_len)
+		return -EINVAL;
+
+	memcpy(dst, src + sizeof(u32), dst_len);
+	return 0;
+}
+
+static void handle_poolop_reply(struct ceph_mon_client *monc,
+				struct ceph_msg *msg)
+{
+	struct ceph_mon_generic_request *req;
+	struct ceph_mon_poolop_reply *reply = msg->front.iov_base;
+	u64 tid = le64_to_cpu(msg->hdr.tid);
+
+	if (msg->front.iov_len < sizeof(*reply))
+		goto bad;
+	dout("handle_poolop_reply %p tid %llu\n", msg, tid);
 
 	mutex_lock(&monc->mutex);
-	rb_erase(&req->node, &monc->generic_request_tree);
-	monc->num_generic_requests--;
+	req = __lookup_generic_req(monc, tid);
+	if (req) {
+		if (req->buf_len &&
+		    get_poolop_reply_buf(msg->front.iov_base + sizeof(*reply),
+				     msg->front.iov_len - sizeof(*reply),
+				     req->buf, req->buf_len) < 0) {
+			mutex_unlock(&monc->mutex);
+			goto bad;
+		}
+		req->result = le32_to_cpu(reply->reply_code);
+		get_generic_request(req);
+	}
 	mutex_unlock(&monc->mutex);
+	if (req) {
+		complete(&req->completion);
+		put_generic_request(req);
+	}
+	return;
 
-	if (!err)
-		err = req->result;
+bad:
+	pr_err("corrupt generic reply, tid %llu\n", tid);
+	ceph_msg_dump(msg);
+}
+
+/*
+ * Do a synchronous pool op.
+ */
+int ceph_monc_do_poolop(struct ceph_mon_client *monc, u32 op,
+			u32 pool, u64 snapid,
+			char *buf, int len)
+{
+	struct ceph_mon_generic_request *req;
+	struct ceph_mon_poolop *h;
+	int err;
+
+	req = kzalloc(sizeof(*req), GFP_NOFS);
+	if (!req)
+		return -ENOMEM;
+
+	kref_init(&req->kref);
+	req->buf = buf;
+	req->buf_len = len;
+	init_completion(&req->completion);
+
+	err = -ENOMEM;
+	req->request = ceph_msg_new(CEPH_MSG_POOLOP, sizeof(*h), GFP_NOFS);
+	if (!req->request)
+		goto out;
+	req->reply = ceph_msg_new(CEPH_MSG_POOLOP_REPLY, 1024, GFP_NOFS);
+	if (!req->reply)
+		goto out;
+
+	/* fill out request */
+	req->request->hdr.version = cpu_to_le16(2);
+	h = req->request->front.iov_base;
+	h->monhdr.have_version = 0;
+	h->monhdr.session_mon = cpu_to_le16(-1);
+	h->monhdr.session_mon_tid = 0;
+	h->fsid = monc->monmap->fsid;
+	h->pool = cpu_to_le32(pool);
+	h->op = cpu_to_le32(op);
+	h->auid = 0;
+	h->snapid = cpu_to_le64(snapid);
+	h->name_len = 0;
+
+	err = do_generic_request(monc, req);
 
 out:
 	kref_put(&req->kref, release_generic_request);
 	return err;
 }
 
+int ceph_monc_create_snapid(struct ceph_mon_client *monc,
+			    u32 pool, u64 *snapid)
+{
+	return ceph_monc_do_poolop(monc,  POOL_OP_CREATE_UNMANAGED_SNAP,
+				   pool, 0, (char *)snapid, sizeof(*snapid));
+
+}
+
+int ceph_monc_delete_snapid(struct ceph_mon_client *monc,
+			    u32 pool, u64 snapid)
+{
+	return ceph_monc_do_poolop(monc,  POOL_OP_CREATE_UNMANAGED_SNAP,
+				   pool, snapid, 0, 0);
+
+}
+
 /*
- * Resend pending statfs requests.
+ * Resend pending generic requests.
  */
 static void __resend_generic_request(struct ceph_mon_client *monc)
 {
@@ -782,6 +913,10 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 		handle_statfs_reply(monc, msg);
 		break;
 
+	case CEPH_MSG_POOLOP_REPLY:
+		handle_poolop_reply(monc, msg);
+		break;
+
 	case CEPH_MSG_MON_MAP:
 		ceph_monc_handle_map(monc, msg);
 		break;
@@ -820,6 +955,7 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
 	case CEPH_MSG_MON_SUBSCRIBE_ACK:
 		m = ceph_msg_get(monc->m_subscribe_ack);
 		break;
+	case CEPH_MSG_POOLOP_REPLY:
 	case CEPH_MSG_STATFS_REPLY:
 		return get_generic_reply(con, hdr, skip);
 	case CEPH_MSG_AUTH_REPLY:
diff --git a/fs/ceph/mon_client.h b/fs/ceph/mon_client.h
index 174d794..8e396f2 100644
--- a/fs/ceph/mon_client.h
+++ b/fs/ceph/mon_client.h
@@ -50,6 +50,7 @@ struct ceph_mon_generic_request {
 	struct rb_node node;
 	int result;
 	void *buf;
+	int buf_len;
 	struct completion completion;
 	struct ceph_msg *request;  /* original request */
 	struct ceph_msg *reply;    /* and reply */
@@ -111,6 +112,10 @@ extern int ceph_monc_open_session(struct ceph_mon_client *monc);
 
 extern int ceph_monc_validate_auth(struct ceph_mon_client *monc);
 
+extern int ceph_monc_create_snapid(struct ceph_mon_client *monc,
+				   u32 pool, u64 *snapid);
 
+extern int ceph_monc_delete_snapid(struct ceph_mon_client *monc,
+				   u32 pool, u64 snapid);
 
 #endif
-- 
1.5.6.5

