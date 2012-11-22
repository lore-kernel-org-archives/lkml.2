Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab2KVWNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:13:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:49365 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab2KVSif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 081/171] libceph: avoid unregistering osd request when not registered
Date: Wed, 21 Nov 2012 16:40:27 -0800
Message-Id: <20121122004041.500803964@linuxfoundation.org>
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

(cherry picked from commit 35f9f8a09e1e88e31bd34a1e645ca0e5f070dd5c)

There is a race between two __unregister_request() callers: the
reply path and the ceph_osdc_wait_request().  If we get a reply
*and* the timeout expires at roughly the same time, both callers
will try to unregister the request, and the second one will do bad
things.

Simply check if the request is still already unregistered; if so,
return immediately and do nothing.

Fixes http://tracker.newdream.net/issues/2420

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -841,6 +841,12 @@ static void register_request(struct ceph
 static void __unregister_request(struct ceph_osd_client *osdc,
 				 struct ceph_osd_request *req)
 {
+	if (RB_EMPTY_NODE(&req->r_node)) {
+		dout("__unregister_request %p tid %lld not registered\n",
+			req, req->r_tid);
+		return;
+	}
+
 	dout("__unregister_request %p tid %lld\n", req, req->r_tid);
 	rb_erase(&req->r_node, &osdc->requests);
 	osdc->num_requests--;


