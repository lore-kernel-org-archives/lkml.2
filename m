Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2KVVSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:18:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:49621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab2KVSkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 083/171] libceph: osd_client: dont drop reply reference too early
Date: Wed, 21 Nov 2012 16:40:29 -0800
Message-Id: <20121122004041.696321803@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit ab8cb34a4b2f60281a4b18b1f1ad23bc2313d91b)

In ceph_osdc_release_request(), a reference to the r_reply message
is dropped.  But just after that, that same message is revoked if it
was in use to receive an incoming reply.  Reorder these so we are
sure we hold a reference until we're actually done with the message.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 680584fab05efff732b5ae16ad601ba994d7b505)
---
 net/ceph/osd_client.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -139,8 +139,6 @@ void ceph_osdc_release_request(struct kr
 
 	if (req->r_request)
 		ceph_msg_put(req->r_request);
-	if (req->r_reply)
-		ceph_msg_put(req->r_reply);
 	if (req->r_con_filling_msg) {
 		dout("release_request revoking pages %p from con %p\n",
 		     req->r_pages, req->r_con_filling_msg);
@@ -148,6 +146,8 @@ void ceph_osdc_release_request(struct kr
 				      req->r_reply);
 		ceph_con_put(req->r_con_filling_msg);
 	}
+	if (req->r_reply)
+		ceph_msg_put(req->r_reply);
 	if (req->r_own_pages)
 		ceph_release_page_vector(req->r_pages,
 					 req->r_num_pages);


