Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2KVWLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:11:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:49520 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802Ab2KVSkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 125/171] libceph: dont change socket state on sock event
Date: Wed, 21 Nov 2012 16:41:11 -0800
Message-Id: <20121122004045.891530464@linuxfoundation.org>
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

(cherry picked from commit 188048bce311ee41e5178bc3255415d0eae28423)

Currently the socket state change event handler records an error
message on a connection to distinguish a close while connecting from
a close while a connection was already established.

Changing connection information during handling of a socket event is
not very clean, so instead move this assignment inside con_work(),
where it can be done during normal connection-level processing (and
under protection of the connection mutex as well).

Move the handling of a socket closed event up to the top of the
processing loop in con_work(); there's no point in handling backoff
etc. if we have a newly-closed socket to take care of.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -261,13 +261,8 @@ static void ceph_sock_state_change(struc
 	case TCP_CLOSE_WAIT:
 		dout("%s TCP_CLOSE_WAIT\n", __func__);
 		con_sock_state_closing(con);
-		if (test_and_set_bit(SOCK_CLOSED, &con->flags) == 0) {
-			if (test_bit(CONNECTING, &con->state))
-				con->error_msg = "connection failed";
-			else
-				con->error_msg = "socket closed";
+		if (!test_and_set_bit(SOCK_CLOSED, &con->flags))
 			queue_con(con);
-		}
 		break;
 	case TCP_ESTABLISHED:
 		dout("%s TCP_ESTABLISHED\n", __func__);
@@ -2187,6 +2182,14 @@ static void con_work(struct work_struct
 
 	mutex_lock(&con->mutex);
 restart:
+	if (test_and_clear_bit(SOCK_CLOSED, &con->flags)) {
+		if (test_bit(CONNECTING, &con->state))
+			con->error_msg = "connection failed";
+		else
+			con->error_msg = "socket closed";
+		goto fault;
+	}
+
 	if (test_and_clear_bit(BACKOFF, &con->flags)) {
 		dout("con_work %p backing off\n", con);
 		if (queue_delayed_work(ceph_msgr_wq, &con->work,
@@ -2216,9 +2219,6 @@ restart:
 		con_close_socket(con);
 	}
 
-	if (test_and_clear_bit(SOCK_CLOSED, &con->flags))
-		goto fault;
-
 	ret = try_read(con);
 	if (ret == -EAGAIN)
 		goto restart;


