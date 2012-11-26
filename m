Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab2KZRHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:07:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47582 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab2KZRHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 123/270] libceph: resubmit linger ops when pg mapping changes
Date: Mon, 26 Nov 2012 14:56:53 -0200
Message-Id: <1353949160-26803-124-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 6194ea895e447fdf4adfd23f67873a32bf4f15ae upstream.

The linger op registration (i.e., watch) modifies the object state.  As
such, the OSD will reply with success if it has already applied without
doing the associated side-effects (setting up the watch session state).
If we lose the ACK and resubmit, we will see success but the watch will not
be correctly registered and we won't get notifies.

To fix this, always resubmit the linger op with a new tid.  We accomplish
this by re-registering as a linger (i.e., 'registered') if we are not yet
registered.  Then the second loop will treat this just like a normal
case of re-registering.

This mirrors a similar fix on the userland ceph.git, commit 5dd68b95, and
ceph bug #2796.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/osd_client.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 4475d17..752b498 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -888,7 +888,9 @@ static void __register_linger_request(struct ceph_osd_client *osdc,
 {
 	dout("__register_linger_request %p\n", req);
 	list_add_tail(&req->r_linger_item, &osdc->req_linger);
-	list_add_tail(&req->r_linger_osd, &req->r_osd->o_linger_requests);
+	if (req->r_osd)
+		list_add_tail(&req->r_linger_osd,
+			      &req->r_osd->o_linger_requests);
 }
 
 static void __unregister_linger_request(struct ceph_osd_client *osdc,
@@ -1302,8 +1304,9 @@ static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 
 	dout("kick_requests %s\n", force_resend ? " (force resend)" : "");
 	mutex_lock(&osdc->request_mutex);
-	for (p = rb_first(&osdc->requests); p; p = rb_next(p)) {
+	for (p = rb_first(&osdc->requests); p; ) {
 		req = rb_entry(p, struct ceph_osd_request, r_node);
+		p = rb_next(p);
 		err = __map_request(osdc, req, force_resend);
 		if (err < 0)
 			continue;  /* error */
@@ -1311,10 +1314,23 @@ static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 			dout("%p tid %llu maps to no osd\n", req, req->r_tid);
 			needmap++;  /* request a newer map */
 		} else if (err > 0) {
-			dout("%p tid %llu requeued on osd%d\n", req, req->r_tid,
-			     req->r_osd ? req->r_osd->o_osd : -1);
-			if (!req->r_linger)
+			if (!req->r_linger) {
+				dout("%p tid %llu requeued on osd%d\n", req,
+				     req->r_tid,
+				     req->r_osd ? req->r_osd->o_osd : -1);
 				req->r_flags |= CEPH_OSD_FLAG_RETRY;
+			}
+		}
+		if (req->r_linger && list_empty(&req->r_linger_item)) {
+			/*
+			 * register as a linger so that we will
+			 * re-submit below and get a new tid
+			 */
+			dout("%p tid %llu restart on osd%d\n",
+			     req, req->r_tid,
+			     req->r_osd ? req->r_osd->o_osd : -1);
+			__register_linger_request(osdc, req);
+			__unregister_request(osdc, req);
 		}
 	}
 
-- 
1.7.9.5

