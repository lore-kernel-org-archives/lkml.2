Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab2KZRGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47506 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab2KZRG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 106/270] libceph: don't change socket state on sock event
Date: Mon, 26 Nov 2012 14:56:36 -0200
Message-Id: <1353949160-26803-107-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 188048bce311ee41e5178bc3255415d0eae28423 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d0aca62..5bd243e 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -261,13 +261,8 @@ static void ceph_sock_state_change(struct sock *sk)
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
@@ -2187,6 +2182,14 @@ static void con_work(struct work_struct *work)
 
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
-- 
1.7.9.5

