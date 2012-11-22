Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab2KVV2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:28:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:49611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2KVSkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@newdream.net>, Alex Elder <elder@inktank.com>
Subject: [ 084/171] libceph: use con get/put ops from osd_client
Date: Wed, 21 Nov 2012 16:40:30 -0800
Message-Id: <20121122004041.798943811@linuxfoundation.org>
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

(cherry picked from commit 0d47766f14211a73eaf54cab234db134ece79f49)

There were a few direct calls to ceph_con_{get,put}() instead of the con
ops from osd_client.c.  This is a bug since those ops aren't defined to
be ceph_con_get/put.

This breaks refcounting on the ceph_osd structs that contain the
ceph_connections, and could lead to all manner of strangeness.

The purpose of the ->get and ->put methods in a ceph connection are
to allow the connection to indicate it has a reference to something
external to the messaging system, *not* to indicate something
external has a reference to the connection.

[elder@inktank.com: added that last sentence]

Signed-off-by: Sage Weil <sage@newdream.net>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 88ed6ea0b295f8e2383d599a04027ec596cdf97b)
---
 net/ceph/osd_client.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -144,7 +144,7 @@ void ceph_osdc_release_request(struct kr
 		     req->r_pages, req->r_con_filling_msg);
 		ceph_con_revoke_message(req->r_con_filling_msg,
 				      req->r_reply);
-		ceph_con_put(req->r_con_filling_msg);
+		req->r_con_filling_msg->ops->put(req->r_con_filling_msg);
 	}
 	if (req->r_reply)
 		ceph_msg_put(req->r_reply);
@@ -1216,7 +1216,7 @@ static void handle_reply(struct ceph_osd
 	if (req->r_con_filling_msg == con && req->r_reply == msg) {
 		dout(" dropping con_filling_msg ref %p\n", con);
 		req->r_con_filling_msg = NULL;
-		ceph_con_put(con);
+		con->ops->put(con);
 	}
 
 	if (!req->r_got_reply) {
@@ -2028,7 +2028,7 @@ static struct ceph_msg *get_reply(struct
 		dout("get_reply revoking msg %p from old con %p\n",
 		     req->r_reply, req->r_con_filling_msg);
 		ceph_con_revoke_message(req->r_con_filling_msg, req->r_reply);
-		ceph_con_put(req->r_con_filling_msg);
+		req->r_con_filling_msg->ops->put(req->r_con_filling_msg);
 		req->r_con_filling_msg = NULL;
 	}
 
@@ -2063,7 +2063,7 @@ static struct ceph_msg *get_reply(struct
 #endif
 	}
 	*skip = 0;
-	req->r_con_filling_msg = ceph_con_get(con);
+	req->r_con_filling_msg = con->ops->get(con);
 	dout("get_reply tid %lld %p\n", tid, m);
 
 out:


