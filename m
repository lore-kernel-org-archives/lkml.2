Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab2KZRzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:55:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063Ab2KZRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 119/270] libceph: initialize msgpool message types
Date: Mon, 26 Nov 2012 14:56:49 -0200
Message-Id: <1353949160-26803-120-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit d50b409fb8698571d8209e5adfe122e287e31290 upstream.

Initialize the type field for messages in a msgpool.  The caller was doing
this for osd ops, but not for the reply messages.

Reported-by: Alex Elder <elder@inktank.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/msgpool.h |    3 ++-
 net/ceph/msgpool.c           |    7 ++++---
 net/ceph/osd_client.c        |    7 ++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/ceph/msgpool.h b/include/linux/ceph/msgpool.h
index a362605..09fa96b 100644
--- a/include/linux/ceph/msgpool.h
+++ b/include/linux/ceph/msgpool.h
@@ -11,10 +11,11 @@
 struct ceph_msgpool {
 	const char *name;
 	mempool_t *pool;
+	int type;               /* preallocated message type */
 	int front_len;          /* preallocated payload size */
 };
 
-extern int ceph_msgpool_init(struct ceph_msgpool *pool,
+extern int ceph_msgpool_init(struct ceph_msgpool *pool, int type,
 			     int front_len, int size, bool blocking,
 			     const char *name);
 extern void ceph_msgpool_destroy(struct ceph_msgpool *pool);
diff --git a/net/ceph/msgpool.c b/net/ceph/msgpool.c
index 11d5f41..ddec1c1 100644
--- a/net/ceph/msgpool.c
+++ b/net/ceph/msgpool.c
@@ -12,7 +12,7 @@ static void *msgpool_alloc(gfp_t gfp_mask, void *arg)
 	struct ceph_msgpool *pool = arg;
 	struct ceph_msg *msg;
 
-	msg = ceph_msg_new(0, pool->front_len, gfp_mask, true);
+	msg = ceph_msg_new(pool->type, pool->front_len, gfp_mask, true);
 	if (!msg) {
 		dout("msgpool_alloc %s failed\n", pool->name);
 	} else {
@@ -32,10 +32,11 @@ static void msgpool_free(void *element, void *arg)
 	ceph_msg_put(msg);
 }
 
-int ceph_msgpool_init(struct ceph_msgpool *pool,
+int ceph_msgpool_init(struct ceph_msgpool *pool, int type,
 		      int front_len, int size, bool blocking, const char *name)
 {
 	dout("msgpool %s init\n", name);
+	pool->type = type;
 	pool->front_len = front_len;
 	pool->pool = mempool_create(size, msgpool_alloc, msgpool_free, pool);
 	if (!pool->pool)
@@ -61,7 +62,7 @@ struct ceph_msg *ceph_msgpool_get(struct ceph_msgpool *pool,
 		WARN_ON(1);
 
 		/* try to alloc a fresh message */
-		return ceph_msg_new(0, front_len, GFP_NOFS, false);
+		return ceph_msg_new(pool->type, front_len, GFP_NOFS, false);
 	}
 
 	msg = mempool_alloc(pool->pool, GFP_NOFS);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index c252711..4475d17 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -242,6 +242,7 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 		}
 		ceph_pagelist_init(req->r_trail);
 	}
+
 	/* create request message; allow space for oid */
 	msg_size += MAX_OBJ_NAME_SIZE;
 	if (snapc)
@@ -255,7 +256,6 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 		return NULL;
 	}
 
-	msg->hdr.type = cpu_to_le16(CEPH_MSG_OSD_OP);
 	memset(msg->front.iov_base, 0, msg->front.iov_len);
 
 	req->r_request = msg;
@@ -1837,11 +1837,12 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
 	if (!osdc->req_mempool)
 		goto out;
 
-	err = ceph_msgpool_init(&osdc->msgpool_op, OSD_OP_FRONT_LEN, 10, true,
+	err = ceph_msgpool_init(&osdc->msgpool_op, CEPH_MSG_OSD_OP,
+				OSD_OP_FRONT_LEN, 10, true,
 				"osd_op");
 	if (err < 0)
 		goto out_mempool;
-	err = ceph_msgpool_init(&osdc->msgpool_op_reply,
+	err = ceph_msgpool_init(&osdc->msgpool_op_reply, CEPH_MSG_OSD_OPREPLY,
 				OSD_OPREPLY_FRONT_LEN, 10, true,
 				"osd_op_reply");
 	if (err < 0)
-- 
1.7.9.5

