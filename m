Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab2KZRuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:50:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab2KZRI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:26 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 137/270] libceph: revoke mon_client messages on session restart
Date: Mon, 26 Nov 2012 14:57:07 -0200
Message-Id: <1353949160-26803-138-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 4f471e4a9c7db0256834e1b376ea50c82e345c3c upstream.

Revoke all mon_client messages when we shut down the old connection.
This is mostly moot since we are re-using the same ceph_connection,
but it is cleaner.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/mon_client.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index bfd21a8..105d533 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -118,6 +118,9 @@ static void __close_session(struct ceph_mon_client *monc)
 {
 	dout("__close_session closing mon%d\n", monc->cur_mon);
 	ceph_msg_revoke(monc->m_auth);
+	ceph_msg_revoke_incoming(monc->m_auth_reply);
+	ceph_msg_revoke(monc->m_subscribe);
+	ceph_msg_revoke_incoming(monc->m_subscribe_ack);
 	ceph_con_close(&monc->con);
 	monc->cur_mon = -1;
 	monc->pending_auth = 0;
@@ -685,6 +688,7 @@ static void __resend_generic_request(struct ceph_mon_client *monc)
 	for (p = rb_first(&monc->generic_request_tree); p; p = rb_next(p)) {
 		req = rb_entry(p, struct ceph_mon_generic_request, node);
 		ceph_msg_revoke(req->request);
+		ceph_msg_revoke_incoming(req->reply);
 		ceph_con_send(&monc->con, ceph_msg_get(req->request));
 	}
 }
-- 
1.7.9.5

