Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2KVSih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:38:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:49338 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab2KVSi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 156/171] libceph: revoke mon_client messages on session restart
Date: Wed, 21 Nov 2012 16:41:42 -0800
Message-Id: <20121122004049.003599192@linuxfoundation.org>
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

(cherry picked from commit 4f471e4a9c7db0256834e1b376ea50c82e345c3c)

Revoke all mon_client messages when we shut down the old connection.
This is mostly moot since we are re-using the same ceph_connection,
but it is cleaner.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -118,6 +118,9 @@ static void __close_session(struct ceph_
 {
 	dout("__close_session closing mon%d\n", monc->cur_mon);
 	ceph_msg_revoke(monc->m_auth);
+	ceph_msg_revoke_incoming(monc->m_auth_reply);
+	ceph_msg_revoke(monc->m_subscribe);
+	ceph_msg_revoke_incoming(monc->m_subscribe_ack);
 	ceph_con_close(&monc->con);
 	monc->cur_mon = -1;
 	monc->pending_auth = 0;
@@ -685,6 +688,7 @@ static void __resend_generic_request(str
 	for (p = rb_first(&monc->generic_request_tree); p; p = rb_next(p)) {
 		req = rb_entry(p, struct ceph_mon_generic_request, node);
 		ceph_msg_revoke(req->request);
+		ceph_msg_revoke_incoming(req->reply);
 		ceph_con_send(&monc->con, ceph_msg_get(req->request));
 	}
 }


