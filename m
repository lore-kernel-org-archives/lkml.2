Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2KZSD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:03:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab2KZRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 085/270] libceph: init monitor connection when opening
Date: Mon, 26 Nov 2012 14:56:15 -0200
Message-Id: <1353949160-26803-86-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 20581c1faf7b15ae1f8b80c0ec757877b0b53151 upstream.

Hold off initializing a monitor client's connection until just
before it gets opened for use.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/mon_client.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index b59ca7a..fec3147 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -119,6 +119,7 @@ static void __close_session(struct ceph_mon_client *monc)
 	dout("__close_session closing mon%d\n", monc->cur_mon);
 	ceph_con_revoke(&monc->con, monc->m_auth);
 	ceph_con_close(&monc->con);
+	monc->con.private = NULL;
 	monc->cur_mon = -1;
 	monc->pending_auth = 0;
 	ceph_auth_reset(monc->auth);
@@ -141,9 +142,13 @@ static int __open_session(struct ceph_mon_client *monc)
 		monc->sub_renew_after = jiffies;  /* i.e., expired */
 		monc->want_next_osdmap = !!monc->want_next_osdmap;
 
-		dout("open_session mon%d opening\n", monc->cur_mon);
+		ceph_con_init(&monc->client->msgr, &monc->con);
+		monc->con.private = monc;
+		monc->con.ops = &mon_con_ops;
 		monc->con.peer_name.type = CEPH_ENTITY_TYPE_MON;
 		monc->con.peer_name.num = cpu_to_le64(monc->cur_mon);
+
+		dout("open_session mon%d opening\n", monc->cur_mon);
 		ceph_con_open(&monc->con,
 			      &monc->monmap->mon_inst[monc->cur_mon].addr);
 
@@ -760,10 +765,6 @@ int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
 		goto out;
 
 	/* connection */
-	ceph_con_init(&monc->client->msgr, &monc->con);
-	monc->con.private = monc;
-	monc->con.ops = &mon_con_ops;
-
 	/* authentication */
 	monc->auth = ceph_auth_init(cl->options->name,
 				    cl->options->key);
@@ -836,8 +837,6 @@ void ceph_monc_stop(struct ceph_mon_client *monc)
 	mutex_lock(&monc->mutex);
 	__close_session(monc);
 
-	monc->con.private = NULL;
-
 	mutex_unlock(&monc->mutex);
 
 	/*
-- 
1.7.9.5

