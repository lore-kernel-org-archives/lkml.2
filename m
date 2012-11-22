Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab2KVWmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:42:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:49011 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab2KVSdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 132/171] libceph: distinguish two phases of connect sequence
Date: Wed, 21 Nov 2012 16:41:18 -0800
Message-Id: <20121122004046.607674011@linuxfoundation.org>
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

(cherry picked from commit 7593af920baac37752190a0db703d2732bed4a3b)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   50 +++++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1559,7 +1559,6 @@ static int process_connect(struct ceph_c
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
+		dout("try_read connecting\n");
+		ret = read_partial_banner(con);
+		if (ret <= 0)
+			goto out;
+		ret = process_banner(con);
+		if (ret < 0)
+			goto out;
+
+		clear_bit(CONNECTING, &con->state);
+		set_bit(NEGOTIATING, &con->state);
 
-			/* Send connection info before awaiting response */
+		/* Banner is good, exchange connection info */
+		ret = prepare_write_connect(con);
+		if (ret < 0)
 			goto out;
-		}
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
 


