Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab2KVVlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:41:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:49627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab2KVSk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 136/171] libceph: initialize mon_client con only once
Date: Wed, 21 Nov 2012 16:41:22 -0800
Message-Id: <20121122004046.997613918@linuxfoundation.org>
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

(cherry picked from commit 735a72ef952d42a256f79ae3e6dc1c17a45c041b)

Do not re-initialize the con on every connection attempt.  When we
ceph_con_close, there may still be work queued on the socket (e.g., to
close it), and re-initializing will clobber the work_struct state.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -119,7 +119,6 @@ static void __close_session(struct ceph_
 	dout("__close_session closing mon%d\n", monc->cur_mon);
 	ceph_msg_revoke(monc->m_auth);
 	ceph_con_close(&monc->con);
-	monc->con.private = NULL;
 	monc->cur_mon = -1;
 	monc->pending_auth = 0;
 	ceph_auth_reset(monc->auth);
@@ -142,9 +141,6 @@ static int __open_session(struct ceph_mo
 		monc->sub_renew_after = jiffies;  /* i.e., expired */
 		monc->want_next_osdmap = !!monc->want_next_osdmap;
 
-		ceph_con_init(&monc->con, monc, &mon_con_ops,
-			&monc->client->msgr);
-
 		dout("open_session mon%d opening\n", monc->cur_mon);
 		ceph_con_open(&monc->con,
 			      CEPH_ENTITY_TYPE_MON, monc->cur_mon,
@@ -798,6 +794,9 @@ int ceph_monc_init(struct ceph_mon_clien
 	if (!monc->m_auth)
 		goto out_auth_reply;
 
+	ceph_con_init(&monc->con, monc, &mon_con_ops,
+		      &monc->client->msgr);
+
 	monc->cur_mon = -1;
 	monc->hunting = true;
 	monc->sub_renew_after = jiffies;


