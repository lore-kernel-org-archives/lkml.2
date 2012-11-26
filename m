Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab2KZRG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47535 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab2KZRGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 113/270] libceph: distinguish two phases of connect sequence
Date: Mon, 26 Nov 2012 14:56:43 -0200
Message-Id: <1353949160-26803-114-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 7593af920baac37752190a0db703d2732bed4a3b upstream.

Currently a ceph connection enters a "CONNECTING" state when it
begins the process of (re-)connecting with its peer.  Once the two
ends have successfully exchanged their banner and addresses, an
additional NEGOTIATING bit is set in the ceph connection's state to
indicate the connection information exhange has begun.  The
CONNECTING bit/state continues to be set during this phase.

Rather than have the CONNECTING state continue while the NEGOTIATING
bit is set, interpret these two phases as distinct states.  In other
words, when NEGOTIATING is set, clear CONNECTING.  That way only
one of them will be active at a time.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   52 +++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 86294c1..fe340b2 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1559,7 +1559,6 @@ static int process_connect(struct ceph_connection *con)
 			return -1;
 		}
 		clear_bit(NEGOTIATING, &con->state);
-		clear_bit(CONNECTING, &con->state);
 		set_bit(CONNECTED, &con->state);
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
@@ -2000,7 +1999,8 @@ more_kvec:
 	}
 
 do_next:
-	if (!test_bit(CONNECTING, &con->state)) {
+	if (!test_bit(CONNECTING, &con->state) &&
+			!test_bit(NEGOTIATING, &con->state)) {
 		/* is anything else pending? */
 		if (!list_empty(&con->out_queue)) {
 			prepare_write_message(con);
@@ -2057,25 +2057,29 @@ more:
 	}
 
 	if (test_bit(CONNECTING, &con->state)) {
-		if (!test_bit(NEGOTIATING, &con->state)) {
-			dout("try_read connecting\n");
-			ret = read_partial_banner(con);
-			if (ret <= 0)
-				goto out;
-			ret = process_banner(con);
-			if (ret < 0)
-				goto out;
-
-			/* Banner is good, exchange connection info */
-			ret = prepare_write_connect(con);
-			if (ret < 0)
-				goto out;
-			prepare_read_connect(con);
-			set_bit(NEGOTIATING, &con->state);
-
-			/* Send connection info before awaiting response */
+		dout("try_read connecting\n");
+		ret = read_partial_banner(con);
+		if (ret <= 0)
 			goto out;
-		}
+		ret = process_banner(con);
+		if (ret < 0)
+			goto out;
+
+		clear_bit(CONNECTING, &con->state);
+		set_bit(NEGOTIATING, &con->state);
+
+		/* Banner is good, exchange connection info */
+		ret = prepare_write_connect(con);
+		if (ret < 0)
+			goto out;
+		prepare_read_connect(con);
+
+		/* Send connection info before awaiting response */
+		goto out;
+	}
+
+	if (test_bit(NEGOTIATING, &con->state)) {
+		dout("try_read negotiating\n");
 		ret = read_partial_connect(con);
 		if (ret <= 0)
 			goto out;
@@ -2197,12 +2201,12 @@ restart:
 	if (test_and_clear_bit(SOCK_CLOSED, &con->flags)) {
 		if (test_and_clear_bit(CONNECTED, &con->state))
 			con->error_msg = "socket closed";
-		else if (test_and_clear_bit(CONNECTING, &con->state)) {
-			clear_bit(NEGOTIATING, &con->state);
+		else if (test_and_clear_bit(NEGOTIATING, &con->state))
+			con->error_msg = "negotiation failed";
+		else if (test_and_clear_bit(CONNECTING, &con->state))
 			con->error_msg = "connection failed";
-		} else {
+		else
 			con->error_msg = "unrecognized con state";
-		}
 		goto fault;
 	}
 
-- 
1.7.9.5

