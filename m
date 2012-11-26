Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab2KZSE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:04:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab2KZREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 082/270] libceph: set CLOSED state bit in con_init
Date: Mon, 26 Nov 2012 14:56:12 -0200
Message-Id: <1353949160-26803-83-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit a5988c490ef66cb04ea2f610681949b25c773b3c upstream.

Once a connection is fully initialized, it is really in a CLOSED
state, so make that explicit by setting the bit in its state field.

It is possible for a connection in NEGOTIATING state to get a
failure, leading to ceph_fault() and ultimately ceph_con_close().
Clear that bits if it is set in that case, to reflect that the
connection truly is closed and is no longer participating in a
connect sequence.

Issue a warning if ceph_con_open() is called on a connection that
is not in CLOSED state.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3239d3d..603d8b5 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -454,11 +454,14 @@ void ceph_con_close(struct ceph_connection *con)
 {
 	dout("con_close %p peer %s\n", con,
 	     ceph_pr_addr(&con->peer_addr.in_addr));
-	set_bit(CLOSED, &con->state);  /* in case there's queued work */
+	clear_bit(NEGOTIATING, &con->state);
 	clear_bit(STANDBY, &con->state);  /* avoid connect_seq bump */
+	set_bit(CLOSED, &con->state);
+
 	clear_bit(LOSSYTX, &con->flags);  /* so we retry next connect */
 	clear_bit(KEEPALIVE_PENDING, &con->flags);
 	clear_bit(WRITE_PENDING, &con->flags);
+
 	mutex_lock(&con->mutex);
 	reset_connection(con);
 	con->peer_global_seq = 0;
@@ -475,7 +478,8 @@ void ceph_con_open(struct ceph_connection *con, struct ceph_entity_addr *addr)
 {
 	dout("con_open %p %s\n", con, ceph_pr_addr(&addr->in_addr));
 	set_bit(OPENING, &con->state);
-	clear_bit(CLOSED, &con->state);
+	WARN_ON(!test_and_clear_bit(CLOSED, &con->state));
+
 	memcpy(&con->peer_addr, addr, sizeof(*addr));
 	con->delay = 0;      /* reset backoff memory */
 	queue_con(con);
@@ -530,6 +534,8 @@ void ceph_con_init(struct ceph_messenger *msgr, struct ceph_connection *con)
 	INIT_LIST_HEAD(&con->out_queue);
 	INIT_LIST_HEAD(&con->out_sent);
 	INIT_DELAYED_WORK(&con->work, con_work);
+
+	set_bit(CLOSED, &con->state);
 }
 EXPORT_SYMBOL(ceph_con_init);
 
@@ -1937,14 +1943,15 @@ more:
 
 	/* open the socket first? */
 	if (con->sock == NULL) {
+		clear_bit(NEGOTIATING, &con->state);
+		set_bit(CONNECTING, &con->state);
+
 		con_out_kvec_reset(con);
 		prepare_write_banner(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			goto out;
 		prepare_read_banner(con);
-		set_bit(CONNECTING, &con->state);
-		clear_bit(NEGOTIATING, &con->state);
 
 		BUG_ON(con->in_msg);
 		con->in_tag = CEPH_MSGR_TAG_READY;
-- 
1.7.9.5

