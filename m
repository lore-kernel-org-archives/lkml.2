Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab2KZRHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:07:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47556 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab2KZRHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 117/270] libceph: initialize mon_client con only once
Date: Mon, 26 Nov 2012 14:56:47 -0200
Message-Id: <1353949160-26803-118-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 735a72ef952d42a256f79ae3e6dc1c17a45c041b upstream.

Do not re-initialize the con on every connection attempt.  When we
ceph_con_close, there may still be work queued on the socket (e.g., to
close it), and re-initializing will clobber the work_struct state.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/mon_client.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index bcc80a0..bfd21a8 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -119,7 +119,6 @@ static void __close_session(struct ceph_mon_client *monc)
 	dout("__close_session closing mon%d\n", monc->cur_mon);
 	ceph_msg_revoke(monc->m_auth);
 	ceph_con_close(&monc->con);
-	monc->con.private = NULL;
 	monc->cur_mon = -1;
 	monc->pending_auth = 0;
 	ceph_auth_reset(monc->auth);
@@ -142,9 +141,6 @@ static int __open_session(struct ceph_mon_client *monc)
 		monc->sub_renew_after = jiffies;  /* i.e., expired */
 		monc->want_next_osdmap = !!monc->want_next_osdmap;
 
-		ceph_con_init(&monc->con, monc, &mon_con_ops,
-			&monc->client->msgr);
-
 		dout("open_session mon%d opening\n", monc->cur_mon);
 		ceph_con_open(&monc->con,
 			      CEPH_ENTITY_TYPE_MON, monc->cur_mon,
@@ -798,6 +794,9 @@ int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
 	if (!monc->m_auth)
 		goto out_auth_reply;
 
+	ceph_con_init(&monc->con, monc, &mon_con_ops,
+		      &monc->client->msgr);
+
 	monc->cur_mon = -1;
 	monc->hunting = true;
 	monc->sub_renew_after = jiffies;
-- 
1.7.9.5

