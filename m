Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab2KVWeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:34:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:49017 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab2KVSdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 168/171] libceph: check for invalid mapping
Date: Wed, 21 Nov 2012 16:41:54 -0800
Message-Id: <20121122004050.205456546@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit d63b77f4c552cc3a20506871046ab0fcbc332609)

If we encounter an invalid (e.g., zeroed) mapping, return an error
and avoid a divide by zero.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ceph/osd_client.h |    2 +-
 include/linux/ceph/osdmap.h     |    6 +++---
 net/ceph/osd_client.c           |   32 ++++++++++++++++++++------------
 net/ceph/osdmap.c               |   18 ++++++++++++++++--
 4 files changed, 40 insertions(+), 18 deletions(-)

--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -207,7 +207,7 @@ extern void ceph_osdc_handle_reply(struc
 extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
 				 struct ceph_msg *msg);
 
-extern void ceph_calc_raw_layout(struct ceph_osd_client *osdc,
+extern int ceph_calc_raw_layout(struct ceph_osd_client *osdc,
 			struct ceph_file_layout *layout,
 			u64 snapid,
 			u64 off, u64 *plen, u64 *bno,
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -111,9 +111,9 @@ extern struct ceph_osdmap *osdmap_apply_
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
@@ -62,12 +62,15 @@ void ceph_calc_raw_layout(struct ceph_os
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
@@ -83,7 +86,7 @@ void ceph_calc_raw_layout(struct ceph_os
 
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
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -952,7 +952,7 @@ bad:
  * for now, we write only a single su, until we can
  * pass a stride back to the caller.
  */
-void ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
+int ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
 				   u64 off, u64 *plen,
 				   u64 *ono,
 				   u64 *oxoff, u64 *oxlen)
@@ -966,11 +966,17 @@ void ceph_calc_file_object_mapping(struc
 
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
@@ -998,6 +1004,14 @@ void ceph_calc_file_object_mapping(struc
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
 


