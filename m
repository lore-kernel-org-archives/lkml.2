Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab0ELXSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:18:23 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:47897 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab0ELXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=Iy7tkyJj8anhYgiaiXW65fNuAXKirYEeg
	ypneLFxFvjsgZ7HL0TNsnwcis9joA7Hs1lx5UNdrJrpy1gSrQRP2muzrnEqKx4lz
	jzb3hFl+vLNG1PwnMOtYCylNi4a1sZyh5NOR0gjauHat2RHEw7oa9BfYvmRyncW/
	pw+ioepGf8=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, sage@newdream.net,
       Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 2/8] ceph: refactor osdc requests creation functions
Date: Wed, 12 May 2010 16:23:34 -0700
Message-Id: <0e317842ec301b9582438b3768f3d5351e40019e.1273705398.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
References: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
In-Reply-To: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
References: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The osd requests creation are being decoupled from the
vino parameter, allowing clients using the osd to use
other arbitrary object names that are not necessarily
vino based.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/osd_client.c |  179 +++++++++++++++++++++++++++++++++++---------------
 fs/ceph/osd_client.h |   24 +++++++
 2 files changed, 149 insertions(+), 54 deletions(-)

diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
index edb8e85..278c6fe 100644
--- a/fs/ceph/osd_client.c
+++ b/fs/ceph/osd_client.c
@@ -22,6 +22,32 @@ static int __kick_requests(struct ceph_osd_client *osdc,
 
 static void kick_requests(struct ceph_osd_client *osdc, struct ceph_osd *osd);
 
+void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
+			struct ceph_file_layout *layout,
+			u64 off, u64 len, u64 *bno,
+			struct ceph_osd_request *req)
+{
+	struct ceph_osd_request_head *reqhead = req->r_request->front.iov_base;
+	struct ceph_osd_op *op = (void *)(reqhead + 1);
+	u64 orig_len = len;
+	u64 objoff, objlen;    /* extent in object */
+
+	/* object extent? */
+	ceph_calc_file_object_mapping(layout, off, &len, bno,
+				      &objoff, &objlen);
+	if (len < orig_len)
+		dout(" skipping last %llu, final file extent %llu~%llu\n",
+		     orig_len - len, off, len);
+
+	op->extent.offset = cpu_to_le64(objoff);
+	op->extent.length = cpu_to_le64(objlen);
+	req->r_num_pages = calc_pages_for(off, len);
+
+	dout("calc_layout bno=%llx %llu~%llu (%d pages)\n",
+	     *bno, objoff, objlen, req->r_num_pages);
+
+}
+
 /*
  * Implement client access to distributed object storage cluster.
  *
@@ -53,29 +79,13 @@ static void calc_layout(struct ceph_osd_client *osdc,
 			struct ceph_osd_request *req)
 {
 	struct ceph_osd_request_head *reqhead = req->r_request->front.iov_base;
-	struct ceph_osd_op *op = (void *)(reqhead + 1);
-	u64 orig_len = *plen;
-	u64 objoff, objlen;    /* extent in object */
 	u64 bno;
 
 	reqhead->snapid = cpu_to_le64(vino.snap);
-
-	/* object extent? */
-	ceph_calc_file_object_mapping(layout, off, plen, &bno,
-				      &objoff, &objlen);
-	if (*plen < orig_len)
-		dout(" skipping last %llu, final file extent %llu~%llu\n",
-		     orig_len - *plen, off, *plen);
+	ceph_calc_raw_layout(osdc, layout, off, *plen, &bno, req);
 
 	sprintf(req->r_oid, "%llx.%08llx", vino.ino, bno);
 	req->r_oid_len = strlen(req->r_oid);
-
-	op->extent.offset = cpu_to_le64(objoff);
-	op->extent.length = cpu_to_le64(objlen);
-	req->r_num_pages = calc_pages_for(off, *plen);
-
-	dout("calc_layout %s (%d) %llu~%llu (%d pages)\n",
-	     req->r_oid, req->r_oid_len, objoff, objlen, req->r_num_pages);
 }
 
 /*
@@ -108,43 +118,34 @@ void ceph_osdc_release_request(struct kref *kref)
 		kfree(req);
 }
 
-/*
- * build new request AND message, calculate layout, and adjust file
- * extent as needed.
- *
- * if the file was recently truncated, we include information about its
- * old and new size so that the object can be updated appropriately.  (we
- * avoid synchronously deleting truncated objects because it's slow.)
- *
- * if @do_sync, include a 'startsync' command so that the osd will flush
- * data quickly.
- */
-struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
-					       struct ceph_file_layout *layout,
-					       struct ceph_vino vino,
-					       u64 off, u64 *plen,
-					       int opcode, int flags,
+struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
+					       int flags,
 					       struct ceph_snap_context *snapc,
 					       int do_sync,
-					       u32 truncate_seq,
-					       u64 truncate_size,
-					       struct timespec *mtime,
-					       bool use_mempool, int num_reply)
+					       bool use_mempool,
+					       gfp_t gfp_flags,
+					       struct page **pages)
 {
 	struct ceph_osd_request *req;
 	struct ceph_msg *msg;
-	struct ceph_osd_request_head *head;
-	struct ceph_osd_op *op;
-	void *p;
 	int num_op = 1 + do_sync;
-	size_t msg_size = sizeof(*head) + num_op*sizeof(*op);
-	int i;
+	size_t msg_size = sizeof(struct ceph_osd_request_head) +
+			  num_op*sizeof(struct ceph_osd_op);
+
+	if (use_mempool) {
+		req = mempool_alloc(osdc->req_mempool, gfp_flags);
+		memset(req, 0, sizeof(*req));
+	} else {
+		req = kzalloc(sizeof(*req), gfp_flags);
+	}
+	if (!req)
+		return NULL;
 
 	if (use_mempool) {
-		req = mempool_alloc(osdc->req_mempool, GFP_NOFS);
+		req = mempool_alloc(osdc->req_mempool, gfp_flags);
 		memset(req, 0, sizeof(*req));
 	} else {
-		req = kzalloc(sizeof(*req), GFP_NOFS);
+		req = kzalloc(sizeof(*req), gfp_flags);
 	}
 	if (req == NULL)
 		return NULL;
@@ -164,7 +165,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 		msg = ceph_msgpool_get(&osdc->msgpool_op_reply, 0);
 	else
 		msg = ceph_msg_new(CEPH_MSG_OSD_OPREPLY,
-				   OSD_OPREPLY_FRONT_LEN, GFP_NOFS);
+				   OSD_OPREPLY_FRONT_LEN, gfp_flags);
 	if (!msg) {
 		ceph_osdc_put_request(req);
 		return NULL;
@@ -178,18 +179,48 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	if (use_mempool)
 		msg = ceph_msgpool_get(&osdc->msgpool_op, 0);
 	else
-		msg = ceph_msg_new(CEPH_MSG_OSD_OP, msg_size, GFP_NOFS);
+		msg = ceph_msg_new(CEPH_MSG_OSD_OP, msg_size, gfp_flags);
 	if (!msg) {
 		ceph_osdc_put_request(req);
 		return NULL;
 	}
 	msg->hdr.type = cpu_to_le16(CEPH_MSG_OSD_OP);
 	memset(msg->front.iov_base, 0, msg->front.iov_len);
+
+	req->r_request = msg;
+	req->r_pages = pages;
+
+	return req;
+}
+
+/*
+ * build new request AND message
+ *
+ */
+void ceph_osdc_build_request(struct ceph_osd_request *req,
+			    u64 off, u64 *plen,
+			    int opcode,
+			    struct ceph_snap_context *snapc,
+			    int do_sync,
+			    u32 truncate_seq,
+			    u64 truncate_size,
+			    struct timespec *mtime,
+			    const char *oid,
+			    int oid_len)
+{
+	struct ceph_msg *msg = req->r_request;
+	struct ceph_osd_request_head *head;
+	struct ceph_osd_op *op;
+	void *p;
+	int num_op = 1 + do_sync;
+	size_t msg_size = sizeof(*head) + num_op*sizeof(*op);
+	int i;
+	int flags = req->r_flags;
+
 	head = msg->front.iov_base;
 	op = (void *)(head + 1);
 	p = (void *)(op + num_op);
 
-	req->r_request = msg;
 	req->r_snapc = ceph_get_snap_context(snapc);
 
 	head->client_inc = cpu_to_le32(1); /* always, for now. */
@@ -199,10 +230,6 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	head->num_ops = cpu_to_le16(num_op);
 	op->op = cpu_to_le16(opcode);
 
-	/* calculate max write size */
-	calc_layout(osdc, vino, layout, off, plen, req);
-	req->r_file_layout = *layout;  /* keep a copy */
-
 	if (flags & CEPH_OSD_FLAG_WRITE) {
 		req->r_request->hdr.data_off = cpu_to_le16(off);
 		req->r_request->hdr.data_len = cpu_to_le32(*plen);
@@ -212,9 +239,9 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	op->extent.truncate_seq = cpu_to_le32(truncate_seq);
 
 	/* fill in oid */
-	head->object_len = cpu_to_le32(req->r_oid_len);
-	memcpy(p, req->r_oid, req->r_oid_len);
-	p += req->r_oid_len;
+	head->object_len = cpu_to_le32(oid_len);
+	memcpy(p, oid, oid_len);
+	p += oid_len;
 
 	if (do_sync) {
 		op++;
@@ -233,6 +260,50 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	msg_size = p - msg->front.iov_base;
 	msg->front.iov_len = msg_size;
 	msg->hdr.front_len = cpu_to_le32(msg_size);
+	return;
+}
+
+/*
+ * build new request AND message, calculate layout, and adjust file
+ * extent as needed.
+ *
+ * if the file was recently truncated, we include information about its
+ * old and new size so that the object can be updated appropriately.  (we
+ * avoid synchronously deleting truncated objects because it's slow.)
+ *
+ * if @do_sync, include a 'startsync' command so that the osd will flush
+ * data quickly.
+ */
+struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
+					       struct ceph_file_layout *layout,
+					       struct ceph_vino vino,
+					       u64 off, u64 *plen,
+					       int opcode, int flags,
+					       struct ceph_snap_context *snapc,
+					       int do_sync,
+					       u32 truncate_seq,
+					       u64 truncate_size,
+					       struct timespec *mtime,
+					       bool use_mempool, int num_reply)
+{
+	struct ceph_osd_request *req =
+		ceph_osdc_alloc_request(osdc, flags,
+					 snapc, do_sync,
+					 use_mempool,
+					 GFP_NOFS, NULL);
+	if (IS_ERR(req))
+		return req;
+
+	/* calculate max write size */
+	calc_layout(osdc, vino, layout, off, plen, req);
+	req->r_file_layout = *layout;  /* keep a copy */
+
+	ceph_osdc_build_request(req, off, plen, opcode,
+				snapc, do_sync,
+				truncate_seq, truncate_size,
+				mtime,
+				req->r_oid, req->r_oid_len);
+
 	return req;
 }
 
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
index b075991..0b6b697 100644
--- a/fs/ceph/osd_client.h
+++ b/fs/ceph/osd_client.h
@@ -118,6 +118,30 @@ extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
 extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
 				 struct ceph_msg *msg);
 
+extern void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
+			struct ceph_file_layout *layout,
+			u64 off, u64 len, u64 *bno,
+			struct ceph_osd_request *req);
+
+extern struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
+					       int flags,
+					       struct ceph_snap_context *snapc,
+					       int do_sync,
+					       bool use_mempool,
+					       gfp_t gfp_flags,
+					       struct page **pages);
+
+extern void ceph_osdc_build_request(struct ceph_osd_request *req,
+			    u64 off, u64 *plen,
+			    int opcode,
+			    struct ceph_snap_context *snapc,
+			    int do_sync,
+			    u32 truncate_seq,
+			    u64 truncate_size,
+			    struct timespec *mtime,
+			    const char *oid,
+			    int oid_len);
+
 extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
 				      struct ceph_file_layout *layout,
 				      struct ceph_vino vino,
-- 
1.5.6.5

