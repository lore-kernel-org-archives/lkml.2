Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2KVVsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:48:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:49643 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab2KVSkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>,
        Yehuda Sadeh <yehuda@inktank.com>
Subject: [ 142/171] libceph: resubmit linger ops when pg mapping changes
Date: Wed, 21 Nov 2012 16:41:28 -0800
Message-Id: <20121122004047.601668963@linuxfoundation.org>
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

(cherry picked from commit 6194ea895e447fdf4adfd23f67873a32bf4f15ae)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -888,7 +888,9 @@ static void __register_linger_request(st
 {
 	dout("__register_linger_request %p\n", req);
 	list_add_tail(&req->r_linger_item, &osdc->req_linger);
-	list_add_tail(&req->r_linger_osd, &req->r_osd->o_linger_requests);
+	if (req->r_osd)
+		list_add_tail(&req->r_linger_osd,
+			      &req->r_osd->o_linger_requests);
 }
 
 static void __unregister_linger_request(struct ceph_osd_client *osdc,
@@ -1302,8 +1304,9 @@ static void kick_requests(struct ceph_os
 
 	dout("kick_requests %s\n", force_resend ? " (force resend)" : "");
 	mutex_lock(&osdc->request_mutex);
-	for (p = rb_first(&osdc->requests); p; p = rb_next(p)) {
+	for (p = rb_first(&osdc->requests); p; ) {
 		req = rb_entry(p, struct ceph_osd_request, r_node);
+		p = rb_next(p);
 		err = __map_request(osdc, req, force_resend);
 		if (err < 0)
 			continue;  /* error */
@@ -1311,10 +1314,23 @@ static void kick_requests(struct ceph_os
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
 


