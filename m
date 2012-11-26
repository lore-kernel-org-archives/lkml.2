Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab2KZRrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:47:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373Ab2KZRJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:14 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 150/270] libceph: check for invalid mapping
Date: Mon, 26 Nov 2012 14:57:20 -0200
Message-Id: <1353949160-26803-151-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit d63b77f4c552cc3a20506871046ab0fcbc332609 upstream.

If we encounter an invalid (e.g., zeroed) mapping, return an error
and avoid a divide by zero.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/osd_client.h |    2 +-
 include/linux/ceph/osdmap.h     |    6 +++---
 net/ceph/osd_client.c           |   32 ++++++++++++++++++++------------
 net/ceph/osdmap.c               |   18 ++++++++++++++++--
 4 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index cedfb1a..d9b880e 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -207,7 +207,7 @@ extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
 extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
 				 struct ceph_msg *msg);
 
-extern void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
+extern int ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 			struct ceph_file_layout *layout,
 			u64 snapid,
 			u64 off, u64 *plen, u64 *bno,
diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
index 311ef8d..e88a620 100644
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -109,9 +109,9 @@ extern struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end,
 extern void ceph_osdmap_destroy(struct ceph_osdmap *map);
 
 /* calculate mapping of a file extent to an object */
-extern void ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
-					  u64 off, u64 *plen,
-					  u64 *bno, u64 *oxoff, u64 *oxlen);
+extern int ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
+					 u64 off, u64 *plen,
+					 u64 *bno, u64 *oxoff, u64 *oxlen);
 
 /* calculate mapping of object to a placement group */
 extern int ceph_calc_object_layout(struct ceph_object_layout *ol,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 752b498..065cc38 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -52,7 +52,7 @@ static int op_has_extent(int op)
 		op == CEPH_OSD_OP_WRITE);
 }
 
-void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
+int ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 			struct ceph_file_layout *layout,
 			u64 snapid,
 			u64 off, u64 *plen, u64 *bno,
@@ -62,12 +62,15 @@ void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 	struct ceph_osd_request_head *reqhead = req->r_request->front.iov_base;
 	u64 orig_len = *plen;
 	u64 objoff, objlen;    /* extent in object */
+	int r;
 
 	reqhead->snapid = cpu_to_le64(snapid);
 
 	/* object extent? */
-	ceph_calc_file_object_mapping(layout, off, plen, bno,
-				      &objoff, &objlen);
+	r = ceph_calc_file_object_mapping(layout, off, plen, bno,
+					  &objoff, &objlen);
+	if (r < 0)
+		return r;
 	if (*plen < orig_len)
 		dout(" skipping last %llu, final file extent %llu~%llu\n",
 		     orig_len - *plen, off, *plen);
@@ -83,7 +86,7 @@ void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 
 	dout("calc_layout bno=%llx %llu~%llu (%d pages)\n",
 	     *bno, objoff, objlen, req->r_num_pages);
-
+	return 0;
 }
 EXPORT_SYMBOL(ceph_calc_raw_layout);
 
@@ -112,20 +115,25 @@ EXPORT_SYMBOL(ceph_calc_raw_layout);
  *
  * fill osd op in request message.
  */
-static void calc_layout(struct ceph_osd_client *osdc,
-			struct ceph_vino vino,
-			struct ceph_file_layout *layout,
-			u64 off, u64 *plen,
-			struct ceph_osd_request *req,
-			struct ceph_osd_req_op *op)
+static int calc_layout(struct ceph_osd_client *osdc,
+		       struct ceph_vino vino,
+		       struct ceph_file_layout *layout,
+		       u64 off, u64 *plen,
+		       struct ceph_osd_request *req,
+		       struct ceph_osd_req_op *op)
 {
 	u64 bno;
+	int r;
 
-	ceph_calc_raw_layout(osdc, layout, vino.snap, off,
-			     plen, &bno, req, op);
+	r = ceph_calc_raw_layout(osdc, layout, vino.snap, off,
+				 plen, &bno, req, op);
+	if (r < 0)
+		return r;
 
 	snprintf(req->r_oid, sizeof(req->r_oid), "%llx.%08llx", vino.ino, bno);
 	req->r_oid_len = strlen(req->r_oid);
+
+	return r;
 }
 
 /*
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 9600674..d10a72b 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -945,7 +945,7 @@ bad:
  * for now, we write only a single su, until we can
  * pass a stride back to the caller.
  */
-void ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
+int ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
 				   u64 off, u64 *plen,
 				   u64 *ono,
 				   u64 *oxoff, u64 *oxlen)
@@ -959,11 +959,17 @@ void ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
 
 	dout("mapping %llu~%llu  osize %u fl_su %u\n", off, *plen,
 	     osize, su);
+	if (su == 0 || sc == 0)
+		goto invalid;
 	su_per_object = osize / su;
+	if (su_per_object == 0)
+		goto invalid;
 	dout("osize %u / su %u = su_per_object %u\n", osize, su,
 	     su_per_object);
 
-	BUG_ON((su & ~PAGE_MASK) != 0);
+	if ((su & ~PAGE_MASK) != 0)
+		goto invalid;
+
 	/* bl = *off / su; */
 	t = off;
 	do_div(t, su);
@@ -991,6 +997,14 @@ void ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
 	*plen = *oxlen;
 
 	dout(" obj extent %llu~%llu\n", *oxoff, *oxlen);
+	return 0;
+
+invalid:
+	dout(" invalid layout\n");
+	*ono = 0;
+	*oxoff = 0;
+	*oxlen = 0;
+	return -EINVAL;
 }
 EXPORT_SYMBOL(ceph_calc_file_object_mapping);
 
-- 
1.7.9.5

