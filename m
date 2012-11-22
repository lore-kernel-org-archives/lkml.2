Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2KVSkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:49636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab2KVSkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 104/171] libceph: init monitor connection when opening
Date: Wed, 21 Nov 2012 16:40:50 -0800
Message-Id: <20121122004043.803433914@linuxfoundation.org>
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

(cherry picked from commit 20581c1faf7b15ae1f8b80c0ec757877b0b53151)

Hold off initializing a monitor client's connection until just
before it gets opened for use.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -119,6 +119,7 @@ static void __close_session(struct ceph_
 	dout("__close_session closing mon%d\n", monc->cur_mon);
 	ceph_con_revoke(&monc->con, monc->m_auth);
 	ceph_con_close(&monc->con);
+	monc->con.private = NULL;
 	monc->cur_mon = -1;
 	monc->pending_auth = 0;
 	ceph_auth_reset(monc->auth);
@@ -141,9 +142,13 @@ static int __open_session(struct ceph_mo
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
 
@@ -760,10 +765,6 @@ int ceph_monc_init(struct ceph_mon_clien
 		goto out;
 
 	/* connection */
-	ceph_con_init(&monc->client->msgr, &monc->con);
-	monc->con.private = monc;
-	monc->con.ops = &mon_con_ops;
-
 	/* authentication */
 	monc->auth = ceph_auth_init(cl->options->name,
 				    cl->options->key);
@@ -836,8 +837,6 @@ void ceph_monc_stop(struct ceph_mon_clie
 	mutex_lock(&monc->mutex);
 	__close_session(monc);
 
-	monc->con.private = NULL;
-
 	mutex_unlock(&monc->mutex);
 
 	/*


