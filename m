Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab2KZRI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:08:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab2KZRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:21 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 136/270] libceph: fix handling of immediate socket connect failure
Date: Mon, 26 Nov 2012 14:57:06 -0200
Message-Id: <1353949160-26803-137-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 8007b8d626b49c34fb146ec16dc639d8b10c862f upstream.

If the connect() call immediately fails such that sock == NULL, we
still need con_close_socket() to reset our socket state to CLOSED.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index fa16f2c..a6a0c7a 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -224,6 +224,8 @@ static void con_sock_state_init(struct ceph_connection *con)
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CLOSED);
 	if (WARN_ON(old_state != CON_SOCK_STATE_NEW))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
+	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
+	     CON_SOCK_STATE_CLOSED);
 }
 
 static void con_sock_state_connecting(struct ceph_connection *con)
@@ -233,6 +235,8 @@ static void con_sock_state_connecting(struct ceph_connection *con)
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CONNECTING);
 	if (WARN_ON(old_state != CON_SOCK_STATE_CLOSED))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
+	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
+	     CON_SOCK_STATE_CONNECTING);
 }
 
 static void con_sock_state_connected(struct ceph_connection *con)
@@ -242,6 +246,8 @@ static void con_sock_state_connected(struct ceph_connection *con)
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CONNECTED);
 	if (WARN_ON(old_state != CON_SOCK_STATE_CONNECTING))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
+	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
+	     CON_SOCK_STATE_CONNECTED);
 }
 
 static void con_sock_state_closing(struct ceph_connection *con)
@@ -253,6 +259,8 @@ static void con_sock_state_closing(struct ceph_connection *con)
 			old_state != CON_SOCK_STATE_CONNECTED &&
 			old_state != CON_SOCK_STATE_CLOSING))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
+	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
+	     CON_SOCK_STATE_CLOSING);
 }
 
 static void con_sock_state_closed(struct ceph_connection *con)
@@ -262,8 +270,11 @@ static void con_sock_state_closed(struct ceph_connection *con)
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CLOSED);
 	if (WARN_ON(old_state != CON_SOCK_STATE_CONNECTED &&
 		    old_state != CON_SOCK_STATE_CLOSING &&
-		    old_state != CON_SOCK_STATE_CONNECTING))
+		    old_state != CON_SOCK_STATE_CONNECTING &&
+		    old_state != CON_SOCK_STATE_CLOSED))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
+	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
+	     CON_SOCK_STATE_CLOSED);
 }
 
 /*
@@ -448,14 +459,14 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
  */
 static int con_close_socket(struct ceph_connection *con)
 {
-	int rc;
+	int rc = 0;
 
 	dout("con_close_socket on %p sock %p\n", con, con->sock);
-	if (!con->sock)
-		return 0;
-	rc = con->sock->ops->shutdown(con->sock, SHUT_RDWR);
-	sock_release(con->sock);
-	con->sock = NULL;
+	if (con->sock) {
+		rc = con->sock->ops->shutdown(con->sock, SHUT_RDWR);
+		sock_release(con->sock);
+		con->sock = NULL;
+	}
 
 	/*
 	 * Forcibly clear the SOCK_CLOSED flag.  It gets set
@@ -464,6 +475,7 @@ static int con_close_socket(struct ceph_connection *con)
 	 * shut the socket down.
 	 */
 	clear_bit(CON_FLAG_SOCK_CLOSED, &con->flags);
+
 	con_sock_state_closed(con);
 	return rc;
 }
-- 
1.7.9.5

