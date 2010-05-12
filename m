Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab0ELXQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:16:33 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:47922 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab0ELXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=OC28cmrHsJcqO9L3PpAb6sfUuJEelF1Vn
	xRr9WGfeTJe+0tNvQpzO/LRyj/Pd4rbJdb4DAJI+VgaXqmrWv73oVl6FT8v34+CC
	HTZI15n8Q45GJZoTnT0+KTmHv9l5iYPWdB3KNswYjYMNaVuO/j/6V6jzLw4jQKoJ
	1yi/7830C4=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, sage@newdream.net,
       Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 8/8] ceph-rbd: snapshots support
Date: Wed, 12 May 2010 16:23:41 -0700
Message-Id: <bcb6004a255d4811e8847506d2f18e758de56c8a.1273705398.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
References: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
In-Reply-To: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
References: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds snapshots capabilities to the ceph-rbd. The snapshots
can be created per a single rbd-image, and the relevant snapshot
information is being kept in the rbd header.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/mon_client.c |  153 ++++++++++++++++++-
 fs/ceph/mon_client.h |    5 +
 fs/ceph/osd_client.c |   10 +-
 fs/ceph/osd_client.h |    1 +
 fs/ceph/rbd.c        |  421 ++++++++++++++++++++++++++++++++++++++++----------
 fs/ceph/super.c      |   18 ++-
 fs/ceph/super.h      |    4 +-
 7 files changed, 518 insertions(+), 94 deletions(-)

diff --git a/fs/ceph/mon_client.c b/fs/ceph/mon_client.c
index 9b56613..a1050c2 100644
--- a/fs/ceph/mon_client.c
+++ b/fs/ceph/mon_client.c
@@ -350,7 +350,7 @@ out:
 }
 
 /*
- * statfs
+ * generic requests (e.g., statfs, poolop)
  */
 static struct ceph_mon_generic_request *__lookup_generic_req(
 	struct ceph_mon_client *monc, u64 tid)
@@ -441,6 +441,9 @@ static struct ceph_msg *get_generic_reply(struct ceph_connection *con,
 	return m;
 }
 
+/*
+ * statfs
+ */
 static void handle_statfs_reply(struct ceph_mon_client *monc,
 				struct ceph_msg *msg)
 {
@@ -467,7 +470,7 @@ static void handle_statfs_reply(struct ceph_mon_client *monc,
 	return;
 
 bad:
-	pr_err("corrupt generic reply, no tid\n");
+	pr_err("corrupt generic reply, tid %llu\n", tid);
 	ceph_msg_dump(msg);
 }
 
@@ -487,6 +490,7 @@ int ceph_monc_do_statfs(struct ceph_mon_client *monc, struct ceph_statfs *buf)
 	memset(req, 0, sizeof(*req));
 	kref_init(&req->kref);
 	req->buf = buf;
+	req->buf_len = sizeof(*buf);
 	init_completion(&req->completion);
 
 	err = -ENOMEM;
@@ -530,7 +534,145 @@ out:
 }
 
 /*
- * Resend pending statfs requests.
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
+
+	mutex_lock(&monc->mutex);
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
+	mutex_unlock(&monc->mutex);
+	if (req) {
+		complete(&req->completion);
+		put_generic_request(req);
+	}
+	return;
+
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
+	req = kmalloc(sizeof(*req), GFP_NOFS);
+	if (!req)
+		return -ENOMEM;
+
+	memset(req, 0, sizeof(*req));
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
+	/* register request */
+	mutex_lock(&monc->mutex);
+	req->tid = ++monc->last_tid;
+	req->request->hdr.tid = cpu_to_le64(req->tid);
+	__insert_generic_request(monc, req);
+	monc->num_generic_requests++;
+	mutex_unlock(&monc->mutex);
+
+	/* send request and wait */
+	ceph_con_send(monc->con, ceph_msg_get(req->request));
+	err = wait_for_completion_interruptible(&req->completion);
+
+	mutex_lock(&monc->mutex);
+	rb_erase(&req->node, &monc->generic_request_tree);
+	monc->num_generic_requests--;
+	mutex_unlock(&monc->mutex);
+
+	if (!err)
+		err = req->result;
+
+out:
+	kref_put(&req->kref, release_generic_request);
+	return err;
+}
+
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
+/*
+ * Resend pending generic requests.
  */
 static void __resend_generic_request(struct ceph_mon_client *monc)
 {
@@ -771,6 +913,10 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 		handle_statfs_reply(monc, msg);
 		break;
 
+	case CEPH_MSG_POOLOP_REPLY:
+		handle_poolop_reply(monc, msg);
+		break;
+
 	case CEPH_MSG_MON_MAP:
 		ceph_monc_handle_map(monc, msg);
 		break;
@@ -809,6 +955,7 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
 	case CEPH_MSG_MON_SUBSCRIBE_ACK:
 		m = ceph_msg_get(monc->m_subscribe_ack);
 		break;
+	case CEPH_MSG_POOLOP_REPLY:
 	case CEPH_MSG_STATFS_REPLY:
 		return get_generic_reply(con, hdr, skip);
 	case CEPH_MSG_AUTH_REPLY:
diff --git a/fs/ceph/mon_client.h b/fs/ceph/mon_client.h
index 7688778..e204482 100644
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
diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
index e5bb5d5..038a46d 100644
--- a/fs/ceph/osd_client.c
+++ b/fs/ceph/osd_client.c
@@ -25,6 +25,7 @@ static void kick_requests(struct ceph_osd_client *osdc, struct ceph_osd *osd);
 
 void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 			struct ceph_file_layout *layout,
+			u64 snapid,
 			u64 off, u64 len, u64 *bno,
 			struct ceph_osd_request *req)
 {
@@ -33,6 +34,8 @@ void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 	u64 orig_len = len;
 	u64 objoff, objlen;    /* extent in object */
 
+	reqhead->snapid = cpu_to_le64(snapid);
+
 	/* object extent? */
 	ceph_calc_file_object_mapping(layout, off, &len, bno,
 				      &objoff, &objlen);
@@ -75,15 +78,14 @@ void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
  * fill osd op in request message.
  */
 static void calc_layout(struct ceph_osd_client *osdc,
-			struct ceph_vino vino, struct ceph_file_layout *layout,
+			struct ceph_vino vino,
+			struct ceph_file_layout *layout,
 			u64 off, u64 *plen,
 			struct ceph_osd_request *req)
 {
-	struct ceph_osd_request_head *reqhead = req->r_request->front.iov_base;
 	u64 bno;
 
-	reqhead->snapid = cpu_to_le64(vino.snap);
-	ceph_calc_raw_layout(osdc, layout, off, *plen, &bno, req);
+	ceph_calc_raw_layout(osdc, layout, vino.snap, off, *plen, &bno, req);
 
 	sprintf(req->r_oid, "%llx.%08llx", vino.ino, bno);
 	req->r_oid_len = strlen(req->r_oid);
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
index 7fb03e8..b2cf7f7 100644
--- a/fs/ceph/osd_client.h
+++ b/fs/ceph/osd_client.h
@@ -122,6 +122,7 @@ extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
 
 extern void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 			struct ceph_file_layout *layout,
+			u64 snapid,
 			u64 off, u64 len, u64 *bno,
 			struct ceph_osd_request *req);
 
diff --git a/fs/ceph/rbd.c b/fs/ceph/rbd.c
index 462b5ea..c7efcc0 100644
--- a/fs/ceph/rbd.c
+++ b/fs/ceph/rbd.c
@@ -61,6 +61,7 @@
 
 #include "super.h"
 #include "osd_client.h"
+#include "mon_client.h"
 
 #include <linux/kernel.h>
 #include <linux/device.h>
@@ -78,7 +79,7 @@ enum {
 
 static const char rbd_text[] = "<<< Rados Block Device Image >>>\n";
 static const char rbd_signature[] = "RBD";
-static const char rbd_version[] = "001.000";
+static const char rbd_version[] = "001.001";
 
 #define RBD_COMP_NONE		0
 #define RBD_CRYPT_NONE		0
@@ -96,6 +97,17 @@ static const char rbd_version[] = "001.000";
 #define RBD_MAX_OPT_LEN		1024
 #define RBD_MAX_SNAP_NAME_LEN	32
 
+#define RBD_SNAP_OP_CREATE	0x1
+#define RBD_SNAP_OP_SET		0x2
+
+#define RBD_SNAP_HEAD_NAME	"head"
+
+
+struct rbd_obj_snap_ondisk {
+	__le64 id;
+	__le64 image_size;
+} __attribute__((packed));
+
 struct rbd_obj_header_ondisk {
 	char text[64];
 	char signature[4];
@@ -104,10 +116,10 @@ struct rbd_obj_header_ondisk {
 	__u8 obj_order;
 	__u8 crypt_type;
 	__u8 comp_type;
-	__le64 snap_seq;
-	__le16 snap_count;
-	__le32 snap_names_len;
-	__le64 snap_id[0];
+	__le32 snap_seq;
+	__le32 snap_count;
+	__le64 snap_names_len;
+	struct rbd_obj_snap_ondisk snaps[0];
 } __attribute__((packed));
 
 struct rbd_obj_header {
@@ -118,7 +130,11 @@ struct rbd_obj_header {
 	struct rw_semaphore snap_rwsem;
 	struct ceph_snap_context *snapc;
 	size_t snap_names_len;
+	u32 snap_seq;
+	u32 total_snaps;
+
 	char *snap_names;
+	u64 *snap_sizes;
 };
 
 struct rbd_request {
@@ -156,6 +172,10 @@ struct rbd_device {
 	char			pool_name[RBD_MAX_POOL_NAME_SIZE];
 	int			poolid;
 
+	u32 cur_snap;	/* index+1 of current snapshot within snap context
+			   0 - for the head */
+	int read_only;
+
 	struct list_head	node;
 	struct rbd_client_node	*client_node;
 };
@@ -167,8 +187,21 @@ static DEFINE_MUTEX(ctl_mutex);	/* Serialize open/close/setup/teardown */
 static LIST_HEAD(rbddev_list);
 static LIST_HEAD(node_list);
 
+
+static int rbd_open(struct block_device *bdev, fmode_t mode)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct rbd_device *rbd_dev = disk->private_data;
+
+	if (mode & FMODE_WRITE && rbd_dev->read_only)
+		return -EROFS;
+
+	return 0;
+}
+
 static const struct block_device_operations rbd_bd_ops = {
-	.owner		= THIS_MODULE,
+	.owner			= THIS_MODULE,
+	.open			= rbd_open,
 };
 
 /*
@@ -311,6 +344,21 @@ static void rbd_put_client(struct rbd_device *rbd_dev)
 	rbd_dev->client_node = NULL;
 }
 
+static int snap_index(struct rbd_obj_header *header, int snap_num)
+{
+	return header->total_snaps - snap_num;
+}
+
+static u64 cur_snap_id(struct rbd_device *rbd_dev)
+{
+	struct rbd_obj_header *header = &rbd_dev->header;
+
+	if (!rbd_dev->cur_snap)
+		return 0;
+
+	return header->snapc->snaps[snap_index(header, rbd_dev->cur_snap)];
+}
+
 
 /*
  * Create a new header structure, translate header format from the on-disk
@@ -322,17 +370,31 @@ static int rbd_header_from_disk(struct rbd_obj_header *header,
 				 gfp_t gfp_flags)
 {
 	int i;
-	u16 snap_count = le16_to_cpu(ondisk->snap_count);
+	u32 snap_count = le32_to_cpu(ondisk->snap_count);
+	int ret = -ENOMEM;
 
 	init_rwsem(&header->snap_rwsem);
 
 	header->snap_names_len = le64_to_cpu(ondisk->snap_names_len);
-	header->snapc = kmalloc(sizeof(struct rbd_obj_header) +
-				header->snap_names_len +
-				snap_count * sizeof(__u64),
+	header->snapc = kmalloc(sizeof(struct ceph_snap_context) +
+				snap_count *
+					sizeof(struct rbd_obj_snap_ondisk),
 				gfp_flags);
 	if (!header->snapc)
 		return -ENOMEM;
+	if (snap_count) {
+		header->snap_names = kmalloc(header->snap_names_len,
+					     GFP_KERNEL);
+		if (!header->snap_names)
+			goto err_snapc;
+		header->snap_sizes = kmalloc(snap_count * sizeof(u64),
+					     GFP_KERNEL);
+		if (!header->snap_sizes)
+			goto err_names;
+	} else {
+		header->snap_names = NULL;
+		header->snap_sizes = NULL;
+	}
 
 	header->image_size = le64_to_cpu(ondisk->image_size);
 	header->obj_order = ondisk->obj_order;
@@ -340,21 +402,31 @@ static int rbd_header_from_disk(struct rbd_obj_header *header,
 	header->comp_type = ondisk->comp_type;
 
 	atomic_set(&header->snapc->nref, 1);
-	header->snapc->seq = le64_to_cpu(ondisk->snap_seq);
+	header->snap_seq = le32_to_cpu(ondisk->snap_seq);
 	header->snapc->num_snaps = snap_count;
+	header->total_snaps = snap_count;
 
 	if (snap_count &&
 	    allocated_snaps == snap_count) {
-		for (i = 0; i < snap_count; i++)
+		for (i = 0; i < snap_count; i++) {
 			header->snapc->snaps[i] =
-				le64_to_cpu(ondisk->snap_id[i]);
+				le64_to_cpu(ondisk->snaps[i].id);
+			header->snap_sizes[i] =
+				le64_to_cpu(ondisk->snaps[i].image_size);
+		}
 
 		/* copy snapshot names */
-		memcpy(&header->snapc->snaps[i], &ondisk->snap_id[i],
+		memcpy(header->snap_names, &ondisk->snaps[i],
 			header->snap_names_len);
 	}
 
 	return 0;
+
+err_names:
+	kfree(header->snap_names);
+err_snapc:
+	kfree(header->snapc);
+	return ret;
 }
 
 /*
@@ -366,82 +438,174 @@ static int rbd_header_to_disk(struct rbd_obj_header_ondisk **ondisk,
 			      struct rbd_obj_header *header,
 			      gfp_t gfp_flags)
 {
-	struct ceph_snap_context *snapc = header->snapc;
 	int i;
 
 	down_read(&header->snap_rwsem);
 	*ondisk = kmalloc(sizeof(struct rbd_obj_header_ondisk) +
 				header->snap_names_len +
-				snapc->num_snaps * sizeof(__u64),
+				header->total_snaps *
+					sizeof(struct rbd_obj_snap_ondisk),
 				gfp_flags);
 	if (!*ondisk)
 		return -ENOMEM;
 
 	memcpy(*ondisk, old_ondisk, sizeof(*old_ondisk));
 
-	(*ondisk)->snap_seq = cpu_to_le64(snapc->seq);
-	(*ondisk)->snap_count = cpu_to_le64(snapc->num_snaps);
+	(*ondisk)->snap_seq = cpu_to_le32(header->snap_seq);
+	(*ondisk)->snap_count = cpu_to_le32(header->total_snaps);
+	(*ondisk)->snap_names_len = cpu_to_le64(header->snap_names_len);
 
-	if (snapc->num_snaps) {
-		for (i = 0; i < snapc->num_snaps; i++)
-			(*ondisk)->snap_id[i] =
+	if (header->total_snaps) {
+		for (i = 0; i < header->total_snaps; i++) {
+			(*ondisk)->snaps[i].id =
 				cpu_to_le64(header->snapc->snaps[i]);
+			(*ondisk)->snaps[i].image_size =
+				cpu_to_le64(header->snap_sizes[i]);
+		}
 
 		/* copy snapshot names */
-		memcpy(&(*ondisk)->snap_id[i], &header->snapc->snaps[i],
+		memcpy(&(*ondisk)->snaps[i], header->snap_names,
 			header->snap_names_len);
 	}
-	(*ondisk)->snap_names_len = cpu_to_le64(header->snap_names_len);
 	up_read(&header->snap_rwsem);
 
 	return 0;
 }
 
-static int rbd_header_add_snap(struct rbd_obj_header *header,
+static int rbd_header_add_snap(struct rbd_device *dev,
 			       const char *snap_name,
 			       gfp_t gfp_flags)
 {
-	struct ceph_snap_context *snapc = header->snapc;
+	struct rbd_obj_header *header = &dev->header;
 	struct ceph_snap_context *new_snapc;
-	int ret = -ENOMEM;
-	char *src_names, *dst_names, *p;
+	char *p;
 	int name_len = strlen(snap_name);
 	u64 *snaps = header->snapc->snaps;
+	u64 *new_sizes;
+	char *new_names;
+	u64 new_snapid;
 	int i;
+	int ret = -EINVAL;
 
-	src_names = (char *)&snaps[snapc->num_snaps];
+	down_write(&header->snap_rwsem);
 
-	p = src_names;
-	for (i = 0; i < snapc->num_snaps; i++, p += strlen(p) + 1) {
+	/* we can create a snapshot only if we're pointing at the head */
+	if (dev->cur_snap)
+		goto done;
+
+	ret = -EEXIST;
+	p = header->snap_names;
+	for (i = 0; i < header->total_snaps; i++, p += strlen(p) + 1) {
 		if (strcmp(snap_name, p) == 0)
-			return -EEXIST;
+			goto done;
 	}
-	down_write(&header->snap_rwsem);
 
+	ret = -ENOMEM;
 	new_snapc = kmalloc(sizeof(struct rbd_obj_header) +
-			    (snapc->num_snaps + 1) * sizeof(u64) +
-			    header->snap_names_len + name_len + 1,
+			    (header->total_snaps + 1) * sizeof(u64),
 			    gfp_flags);
 	if (!new_snapc)
 		goto done;
+	new_names = kmalloc(header->snap_names_len + name_len + 1, gfp_flags);
+	if (!new_names)
+		goto err_snapc;
+	new_sizes = kmalloc((header->total_snaps + 1) * sizeof(u64),
+			    gfp_flags);
+	if (!new_sizes)
+		goto err_names;
 
 	atomic_set(&new_snapc->nref, 1);
-	new_snapc->seq = snapc->seq + 1;
-	new_snapc->num_snaps = snapc->num_snaps + 1;
-	memcpy(new_snapc->snaps, snaps, snapc->num_snaps * sizeof(u64));
-	new_snapc->snaps[new_snapc->num_snaps - 1] = new_snapc->seq;
+	new_snapc->num_snaps = header->total_snaps + 1;
+	if (header->total_snaps)
+		memcpy(&new_snapc->snaps[1], snaps,
+		       (header->total_snaps) * sizeof(u64));
+
+	ret = ceph_monc_create_snapid(&dev->client->monc, dev->poolid,
+				      &new_snapid);
+	dout("created snapid=%lld\n", new_snapid);
+	if (ret < 0)
+		goto err_sizes;
 
-	/* copy snap names */
-	dst_names = (char *)&new_snapc->snaps[new_snapc->num_snaps];
+	new_snapc->seq = new_snapid; /* we're still pointing at the head */
+	header->snap_seq = new_snapid;
+	new_snapc->snaps[0] = new_snapid;
 
-	memcpy(dst_names, src_names, header->snap_names_len);
-	dst_names += header->snap_names_len;
-	memcpy(dst_names, snap_name, name_len + 1);
+	/* copy snap names */
+	if (header->snap_names)
+		memcpy(new_names + name_len + 1, header->snap_names,
+		       header->snap_names_len);
 
+	memcpy(new_names, snap_name, name_len + 1);
 	header->snap_names_len += name_len + 1;
 
+	/* copy snap image sizes */
+	if (header->snap_sizes)
+		memcpy(new_sizes, header->snap_sizes,
+		       header->total_snaps * sizeof(u64));
+	new_sizes[new_snapc->num_snaps - 1] = header->image_size;
+
+	header->total_snaps = new_snapc->num_snaps;
+
 	kfree(header->snapc);
 	header->snapc = new_snapc;
+	kfree(header->snap_names);
+	header->snap_names = new_names;
+	kfree(header->snap_sizes);
+	header->snap_sizes = new_sizes;
+
+	ret = 0;
+done:
+	up_write(&header->snap_rwsem);
+	return ret;
+err_sizes:
+	kfree(new_sizes);
+err_names:
+	kfree(new_names);
+err_snapc:
+	kfree(new_snapc);
+	up_write(&header->snap_rwsem);
+	return ret;
+}
+
+static int rbd_header_set_snap(struct rbd_device *dev,
+			       const char *snap_name,
+			       u64 *size)
+{
+	struct rbd_obj_header *header = &dev->header;
+	struct ceph_snap_context *snapc = header->snapc;
+	char *p;
+	int i;
+	int ret = -ENOENT;
+
+	down_write(&header->snap_rwsem);
+
+	if (!snap_name ||
+	    !*snap_name ||
+	    strcmp(snap_name, "-") == 0 ||
+	    strcmp(snap_name, RBD_SNAP_HEAD_NAME) == 0) {
+		if (header->total_snaps)
+			snapc->seq = header->snap_seq;
+		else
+			snapc->seq = 0;
+		dev->cur_snap = 0;
+		dev->read_only = 0;
+		if (size)
+			*size = header->image_size;
+	} else {
+		p = header->snap_names;
+		for (i = 0; i < header->total_snaps; i++, p += strlen(p) + 1) {
+			if (strcmp(snap_name, p) == 0)
+				break;
+		}
+		if (i == header->total_snaps)
+			goto done;
+
+		snapc->seq = snapc->snaps[i];
+		dev->cur_snap = header->total_snaps - i;
+		dev->read_only = 1;
+		if (size)
+			*size = header->snap_sizes[i];
+	}
 
 	ret = 0;
 done:
@@ -452,6 +616,8 @@ done:
 static void rbd_header_free(struct rbd_obj_header *header)
 {
 	kfree(header->snapc);
+	kfree(header->snap_names);
+	kfree(header->snap_sizes);
 }
 
 /*
@@ -599,6 +765,7 @@ err_out:
 static int rbd_do_request(struct request *rq,
 			  struct rbd_device *dev,
 			  struct ceph_snap_context *snapc,
+			  u64 snapid,
 			  const char *obj, u64 ofs, u64 len,
 			  struct bio *bio,
 			  struct page **pages,
@@ -658,7 +825,8 @@ static int rbd_do_request(struct request *rq,
 	layout->fl_object_size = RBD_STRIPE_UNIT;
 	layout->fl_pg_preferred = -1;
 	layout->fl_pg_pool = dev->poolid;
-	ceph_calc_raw_layout(&dev->client->osdc, layout, ofs, len, &bno, req);
+	ceph_calc_raw_layout(&dev->client->osdc, layout, snapid,
+			     ofs, len, &bno, req);
 
 	ceph_osdc_build_request(req, ofs, &len, opcode,
 				snapc, 0,
@@ -733,6 +901,7 @@ static void rbd_req_cb(struct ceph_osd_request *req, struct ceph_msg *msg)
  */
 static int rbd_req_sync_op(struct rbd_device *dev,
 			   struct ceph_snap_context *snapc,
+			   u64 snapid,
 			   int opcode, int flags,
 			   int num_reply,
 			   const char *obj,
@@ -754,7 +923,8 @@ static int rbd_req_sync_op(struct rbd_device *dev,
 			goto done;
 	}
 
-	ret = rbd_do_request(NULL, dev, snapc, obj, ofs, len, NULL,
+	ret = rbd_do_request(NULL, dev, snapc, snapid,
+			  obj, ofs, len, NULL,
 			  pages, num_pages,
 			  opcode,
 			  flags,
@@ -764,7 +934,7 @@ static int rbd_req_sync_op(struct rbd_device *dev,
 		goto done;
 
 	if (flags & CEPH_OSD_FLAG_READ)
-		ret = ceph_copy_from_page_vector(pages, buf, ofs, len);
+		ret = ceph_copy_from_page_vector(pages, buf, ofs, ret);
 
 done:
 	ceph_release_page_vector(pages, num_pages);
@@ -777,6 +947,7 @@ done:
 static int rbd_do_op(struct request *rq,
 		     struct rbd_device *rbd_dev ,
 		     struct ceph_snap_context *snapc,
+		     u64 snapid,
 		     int opcode, int flags, int num_reply,
 		     u64 ofs, u64 len,
 		     struct bio *bio)
@@ -802,7 +973,7 @@ static int rbd_do_op(struct request *rq,
 	   truncated at this point */
 	BUG_ON(seg_len < len);
 
-	ret = rbd_do_request(rq, rbd_dev, snapc,
+	ret = rbd_do_request(rq, rbd_dev, snapc, snapid,
 			     seg_name, seg_ofs, seg_len,
 			     bio,
 			     NULL, 0,
@@ -823,7 +994,7 @@ static int rbd_req_write(struct request *rq,
 			 u64 ofs, u64 len,
 			 struct bio *bio)
 {
-	return rbd_do_op(rq, rbd_dev, snapc,
+	return rbd_do_op(rq, rbd_dev, snapc, CEPH_NOSNAP,
 			 CEPH_OSD_OP_WRITE,
 			 CEPH_OSD_FLAG_WRITE | CEPH_OSD_FLAG_ONDISK,
 			 2,
@@ -835,11 +1006,12 @@ static int rbd_req_write(struct request *rq,
  */
 static int rbd_req_sync_write(struct rbd_device *dev,
 			  struct ceph_snap_context *snapc,
+			  u64 snapid,
 			  const char *obj,
 			  u64 ofs, u64 len,
 			  char *buf)
 {
-	return rbd_req_sync_op(dev, snapc,
+	return rbd_req_sync_op(dev, snapc, snapid,
 			       CEPH_OSD_OP_WRITE,
 			       CEPH_OSD_FLAG_WRITE | CEPH_OSD_FLAG_ONDISK,
 			       2, obj, ofs, len, buf);
@@ -850,11 +1022,12 @@ static int rbd_req_sync_write(struct rbd_device *dev,
  */
 static int rbd_req_read(struct request *rq,
 			 struct rbd_device *rbd_dev,
-			 struct ceph_snap_context *snapc,
+			 u64 snapid,
 			 u64 ofs, u64 len,
 			 struct bio *bio)
 {
-	return rbd_do_op(rq, rbd_dev, snapc,
+	return rbd_do_op(rq, rbd_dev, NULL,
+			 (snapid ? snapid : CEPH_NOSNAP),
 			 CEPH_OSD_OP_READ,
 			 CEPH_OSD_FLAG_READ,
 			 2,
@@ -866,11 +1039,13 @@ static int rbd_req_read(struct request *rq,
  */
 static int rbd_req_sync_read(struct rbd_device *dev,
 			  struct ceph_snap_context *snapc,
+			  u64 snapid,
 			  const char *obj,
 			  u64 ofs, u64 len,
 			  char *buf)
 {
-	return rbd_req_sync_op(dev, snapc,
+	return rbd_req_sync_op(dev, NULL,
+			       (snapid ? snapid : CEPH_NOSNAP),
 			       CEPH_OSD_OP_READ,
 			       CEPH_OSD_FLAG_READ,
 			       1, obj, ofs, len, buf);
@@ -946,7 +1121,7 @@ static void rbd_rq_fn(struct request_queue *q)
 					      op_size, bio);
 			else
 				rbd_req_read(rq, rbd_dev,
-					     rbd_dev->header.snapc,
+					     cur_snap_id(rbd_dev),
 					     ofs,
 					     op_size, bio);
 
@@ -1028,7 +1203,8 @@ static int rbd_read_header(struct rbd_device *rbd_dev,
 		return -ENOMEM;
 
 	while (1) {
-		int len = sizeof(*dh) + snap_count * sizeof(u64) +
+		int len = sizeof(*dh) +
+			  snap_count * sizeof(struct rbd_obj_snap_ondisk) +
 			  snap_names_len;
 
 		dh = kmalloc(len, GFP_KERNEL);
@@ -1036,7 +1212,7 @@ static int rbd_read_header(struct rbd_device *rbd_dev,
 			goto out_obj_md;
 
 		rc = rbd_req_sync_read(rbd_dev,
-				       NULL,
+				       NULL, CEPH_NOSNAP,
 				       obj_md_name,
 				       0, len,
 				       (char *)dh);
@@ -1047,8 +1223,8 @@ static int rbd_read_header(struct rbd_device *rbd_dev,
 		if (rc < 0)
 			goto out_dh;
 
-		if (snap_count != header->snapc->num_snaps) {
-			snap_count = header->snapc->num_snaps;
+		if (snap_count != header->total_snaps) {
+			snap_count = header->total_snaps;
 			snap_names_len = header->snap_names_len;
 			rbd_header_free(header);
 			kfree(dh);
@@ -1064,28 +1240,31 @@ out_obj_md:
 	return rc;
 }
 
-static int rbd_read_ondisk_header(struct rbd_device *rbd_dev,
+/*
+ * only read the first part of the ondisk header, without the snaps info
+ */
+static int rbd_read_ondisk_header_nosnap(struct rbd_device *rbd_dev,
 				  struct rbd_obj_header *header,
 				  struct rbd_obj_header_ondisk *dh)
 {
 	ssize_t rc;
 	char *obj_md_name;
-	int snap_count = header->snapc->num_snaps;
-	u64 snap_names_len = header->snap_names_len;
 	int len;
 
 	obj_md_name = rbd_alloc_md_name(rbd_dev, GFP_KERNEL);
 	if (!obj_md_name)
 		return -ENOMEM;
 
-	len = sizeof(*dh) + snap_count * sizeof(u64) +
-		  snap_names_len;
+	len = sizeof(struct rbd_obj_header_ondisk);
 
 	rc = rbd_req_sync_read(rbd_dev,
-			       NULL,
+			       NULL, CEPH_NOSNAP,
 			       obj_md_name,
 			       0, len,
 			       (char *)dh);
+	if (rc > 0 && rc < len)
+		rc = -EIO;
+
 	kfree(obj_md_name);
 	return rc;
 }
@@ -1096,7 +1275,7 @@ static int rbd_write_header(struct rbd_device *rbd_dev,
 {
 	ssize_t rc;
 	char *obj_md_name;
-	int snap_count = header->snapc->num_snaps;
+	int snap_count = header->total_snaps;
 	u64 snap_names_len  = header->snap_names_len;
 	int len;
 
@@ -1104,10 +1283,12 @@ static int rbd_write_header(struct rbd_device *rbd_dev,
 	if (!obj_md_name)
 		return -ENOMEM;
 
-	len = sizeof(*dh) + snap_count * sizeof(u64) +
-		  snap_names_len;
+	len = sizeof(*dh) +
+	      snap_count * sizeof(struct rbd_obj_snap_ondisk) +
+	      snap_names_len;
 
-	rc = rbd_req_sync_write(rbd_dev, NULL,
+	rc = rbd_req_sync_write(rbd_dev,
+			       NULL, CEPH_NOSNAP,
 			       obj_md_name,
 			       0, len,
 			       (char *)dh);
@@ -1125,8 +1306,16 @@ static int rbd_update_snaps(struct rbd_device *rbd_dev)
 		return ret;
 
 	down_write(&rbd_dev->header.snap_rwsem);
+
 	kfree(rbd_dev->header.snapc);
+	kfree(rbd_dev->header.snap_names);
+	kfree(rbd_dev->header.snap_sizes);
+
+	rbd_dev->header.total_snaps = h.total_snaps;
 	rbd_dev->header.snapc = h.snapc;
+	rbd_dev->header.snap_names = h.snap_names;
+	rbd_dev->header.snap_sizes = h.snap_sizes;
+
 	up_write(&rbd_dev->header.snap_rwsem);
 
 	return 0;
@@ -1138,13 +1327,18 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	struct request_queue *q;
 	int rc;
 	u64 total_size;
+	const char *snap = NULL;
 
 	/* contact OSD, request size info about the object being mapped */
 	rc = rbd_read_header(rbd_dev, &rbd_dev->header);
 	if (rc)
 		return rc;
 
-	total_size = rbd_dev->header.image_size;
+	if (rbd_dev->client->mount_args)
+		snap = rbd_dev->client->mount_args->snap;
+	rc = rbd_header_set_snap(rbd_dev, snap, &total_size);
+	if (rc)
+		return rc;
 
 	/* create gendisk info */
 	rc = -ENOMEM;
@@ -1210,9 +1404,10 @@ static ssize_t class_rbd_list(struct class *c,
 		struct rbd_device *rbd_dev;
 
 		rbd_dev = list_entry(tmp, struct rbd_device, node);
-		n += sprintf(data+n, "%d %d %s %s\n",
+		n += sprintf(data+n, "%d %d client%lld %s %s\n",
 			     rbd_dev->id,
 			     rbd_dev->major,
+			     ceph_client_id(rbd_dev->client),
 			     rbd_dev->pool_name,
 			     rbd_dev->obj);
 	}
@@ -1288,7 +1483,6 @@ static ssize_t class_rbd_add(struct class *c,
 		goto err_out_slot;
 
 	mutex_unlock(&ctl_mutex);
-
 	/* register our block device */
 	irc = register_blkdev(0, rbd_dev->name);
 	if (irc < 0) {
@@ -1383,6 +1577,23 @@ static ssize_t class_rbd_remove(struct class *c,
 	return count;
 }
 
+static void get_size_and_suffix(u64 orig_size, u64 *size, char *suffix)
+{
+	if (orig_size >= 1024*1024*1024) {
+		*size = orig_size / (1024*1024*1024);
+		*suffix = 'G';
+	} else if (orig_size >= 1024*1024) {
+		*size = orig_size / (1024*1024);
+		*suffix = 'M';
+	} else if (orig_size >= 1024) {
+		*size = orig_size / 1024;
+		*suffix = 'K';
+	} else {
+		*size = orig_size;
+		*suffix = ' ';
+	}
+}
+
 static ssize_t class_rbd_snaps_list(struct class *c,
 			      struct class_attribute *attr,
 			      char *data)
@@ -1390,6 +1601,8 @@ static ssize_t class_rbd_snaps_list(struct class *c,
 	struct rbd_device *rbd_dev = NULL;
 	struct list_head *tmp;
 	struct rbd_obj_header *header;
+	char size_suffix;
+	u64 size;
 	int i, n = 0, max = PAGE_SIZE;
 	int ret;
 
@@ -1397,26 +1610,47 @@ static ssize_t class_rbd_snaps_list(struct class *c,
 
 	list_for_each(tmp, &rbddev_list) {
 		char *names, *p;
+		struct ceph_snap_context *snapc;
+
 		rbd_dev = list_entry(tmp, struct rbd_device, node);
 		header = &rbd_dev->header;
-		names =
-		   (char *)&header->snapc->snaps[header->snapc->num_snaps];
-		n += snprintf(data, max - n, "snapshots for device id %d:\n",
+		names = header->snap_names;
+		snapc = header->snapc;
+		n += snprintf(data + n, max - n,
+			      "snapshots for device id %d:\n",
 			      rbd_dev->id);
 		if (n == max)
 			break;
 
 		down_read(&header->snap_rwsem);
+
+		get_size_and_suffix(header->image_size, &size,
+				    &size_suffix);
+		n += snprintf(data + n, max - n, "%s\t%lld%c%s\n",
+				      RBD_SNAP_HEAD_NAME,
+				      size, size_suffix,
+				      (!rbd_dev->cur_snap ?
+				       " (*)" : ""));
+		if (n == max)
+			break;
+
 		p = names;
-		for (i = 0; i < header->snapc->num_snaps;
-		     i++, p += strlen(p) + 1) {
-			n += snprintf(data+n, max - n, "%s\n", p);
+		for (i = 0; i < header->total_snaps; i++, p += strlen(p) + 1) {
+			get_size_and_suffix(header->snap_sizes[i], &size,
+					    &size_suffix);
+			n += snprintf(data + n, max - n, "%s\t%lld%c%s\n",
+			      p, size, size_suffix,
+			      (rbd_dev->cur_snap &&
+			       (snap_index(header, i) == rbd_dev->cur_snap) ?
+			       " (*)" : ""));
 			if (n == max)
 				break;
 		}
+
 		up_read(&header->snap_rwsem);
 	}
 
+
 	ret = n;
 	mutex_unlock(&ctl_mutex);
 	return ret;
@@ -1458,10 +1692,11 @@ done:
 	return ret;
 }
 
-static ssize_t class_rbd_snaps_add(struct class *c,
+static ssize_t class_rbd_snaps_op(struct class *c,
 				struct class_attribute *attr,
 				const char *buf,
-				size_t count)
+				size_t count,
+				int snaps_op)
 {
 	struct rbd_device *rbd_dev = NULL;
 	int target_id, ret;
@@ -1489,14 +1724,23 @@ static ssize_t class_rbd_snaps_add(struct class *c,
 		goto done_unlock;
 	}
 
-	ret = rbd_read_ondisk_header(rbd_dev,
-				  &rbd_dev->header,
-				  &old_ondisk);
+	ret = rbd_read_ondisk_header_nosnap(rbd_dev,
+					    &rbd_dev->header,
+					    &old_ondisk);
 	if (ret < 0)
 		goto done_unlock;
 
-	ret = rbd_header_add_snap(&rbd_dev->header,
-				  name, GFP_KERNEL);
+	switch (snaps_op) {
+	case RBD_SNAP_OP_CREATE:
+		ret = rbd_header_add_snap(rbd_dev,
+					  name, GFP_KERNEL);
+		break;
+	case RBD_SNAP_OP_SET:
+		ret = rbd_header_set_snap(rbd_dev, name, NULL);
+		break;
+	default:
+		ret = -EINVAL;
+	}
 	if (ret < 0)
 		goto done_unlock;
 
@@ -1517,12 +1761,21 @@ done:
 	return ret;
 }
 
+static ssize_t class_rbd_snap_create(struct class *c,
+				     struct class_attribute *attr,
+				     const char *buf,
+				     size_t count)
+{
+	return class_rbd_snaps_op(c, attr, buf, count,
+				  RBD_SNAP_OP_CREATE);
+}
+
 static struct class_attribute class_rbd_attrs[] = {
 	__ATTR(add,		0200, NULL, class_rbd_add),
 	__ATTR(remove,		0200, NULL, class_rbd_remove),
 	__ATTR(list,		0444, class_rbd_list, NULL),
 	__ATTR(snaps_refresh,	0200, NULL, class_rbd_snaps_refresh),
-	__ATTR(snaps_add,	0200, NULL, class_rbd_snaps_add),
+	__ATTR(snap_create,	0200, NULL, class_rbd_snap_create),
 	__ATTR(snaps_list,	0444, class_rbd_snaps_list, NULL),
 	__ATTR_NULL
 };
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 43062dc..2adeb94 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -329,6 +329,7 @@ enum {
 	Opt_snapdirname,
 	Opt_name,
 	Opt_secret,
+	Opt_snap,
 	Opt_last_string,
 	/* string args above */
 	Opt_ip,
@@ -360,6 +361,7 @@ static match_table_t arg_tokens = {
 	{Opt_snapdirname, "snapdirname=%s"},
 	{Opt_name, "name=%s"},
 	{Opt_secret, "secret=%s"},
+	{Opt_snap, "snap=%s"},
 	/* string args above */
 	{Opt_ip, "ip=%s"},
 	{Opt_noshare, "noshare"},
@@ -493,6 +495,11 @@ struct ceph_mount_args *parse_mount_args(int flags, char *options,
 						argstr[0].to-argstr[0].from,
 						GFP_KERNEL);
 			break;
+		case Opt_snap:
+			args->snap = kstrndup(argstr[0].from,
+					      argstr[0].to-argstr[0].from,
+					      GFP_KERNEL);
+			break;
 
 			/* misc */
 		case Opt_wsize:
@@ -604,6 +611,10 @@ int ceph_compare_mount_args(struct ceph_mount_args *new_args,
 	if (ret)
 		return ret;
 
+	ret = strcmp_null(args1->snap, args2->snap);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < args1->num_mon; i++) {
 		if (ceph_monmap_contains(client->monc.monmap,
 				 &args1->mon_addr[i]))
@@ -700,6 +711,11 @@ fail:
 	return ERR_PTR(err);
 }
 
+u64 ceph_client_id(struct ceph_client *client)
+{
+	return client->monc.auth->global_id;
+}
+
 void ceph_destroy_client(struct ceph_client *client)
 {
 	dout("destroy_client %p\n", client);
@@ -739,7 +755,7 @@ int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid)
 		}
 	} else {
 		pr_info("client%lld fsid " FSID_FORMAT "\n",
-			client->monc.auth->global_id, PR_FSID(fsid));
+			ceph_client_id(client), PR_FSID(fsid));
 		memcpy(&client->fsid, fsid, sizeof(*fsid));
 		ceph_debugfs_client_init(client);
 		client->have_fsid = true;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 9ccc247..ef9d3c9 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -53,8 +53,6 @@ struct ceph_mount_args {
 	int flags;
 	struct ceph_fsid fsid;
 	struct ceph_entity_addr my_addr;
-	int num_mon;
-	struct ceph_entity_addr *mon_addr;
 	int mount_timeout;
 	int osd_idle_ttl;
 	int osd_timeout;
@@ -75,6 +73,7 @@ struct ceph_mount_args {
 	char *snapdir_name;   /* default ".snap" */
 	char *name;
 	char *secret;
+	char *snap;	/* rbd snapshot */
 };
 
 /*
@@ -751,6 +750,7 @@ extern int ceph_compare_mount_args(struct ceph_mount_args *new_args,
 			    struct ceph_client *client);
 extern struct ceph_client *ceph_create_client(struct ceph_mount_args *args,
 					      int need_mdsc);
+extern u64 ceph_client_id(struct ceph_client *client);
 extern void ceph_destroy_client(struct ceph_client *client);
 extern int ceph_open_session(struct ceph_client *client);
 
-- 
1.5.6.5

