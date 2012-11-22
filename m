Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2KVW2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:28:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:49024 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab2KVSd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 101/171] libceph: set CLOSED state bit in con_init
Date: Wed, 21 Nov 2012 16:40:47 -0800
Message-Id: <20121122004043.494563125@linuxfoundation.org>
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

(cherry picked from commit a5988c490ef66cb04ea2f610681949b25c773b3c)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -454,11 +454,14 @@ void ceph_con_close(struct ceph_connecti
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
@@ -475,7 +478,8 @@ void ceph_con_open(struct ceph_connectio
 {
 	dout("con_open %p %s\n", con, ceph_pr_addr(&addr->in_addr));
 	set_bit(OPENING, &con->state);
-	clear_bit(CLOSED, &con->state);
+	WARN_ON(!test_and_clear_bit(CLOSED, &con->state));
+
 	memcpy(&con->peer_addr, addr, sizeof(*addr));
 	con->delay = 0;      /* reset backoff memory */
 	queue_con(con);
@@ -530,6 +534,8 @@ void ceph_con_init(struct ceph_messenger
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


