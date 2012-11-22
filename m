Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab2KVVjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:39:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:49649 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab2KVSk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 155/171] libceph: fix handling of immediate socket connect failure
Date: Wed, 21 Nov 2012 16:41:41 -0800
Message-Id: <20121122004048.901513693@linuxfoundation.org>
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

(cherry picked from commit 8007b8d626b49c34fb146ec16dc639d8b10c862f)

If the connect() call immediately fails such that sock == NULL, we
still need con_close_socket() to reset our socket state to CLOSED.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -224,6 +224,8 @@ static void con_sock_state_init(struct c
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CLOSED);
 	if (WARN_ON(old_state != CON_SOCK_STATE_NEW))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
+	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
+	     CON_SOCK_STATE_CLOSED);
 }
 
 static void con_sock_state_connecting(struct ceph_connection *con)
@@ -233,6 +235,8 @@ static void con_sock_state_connecting(st
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CONNECTING);
 	if (WARN_ON(old_state != CON_SOCK_STATE_CLOSED))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
+	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
+	     CON_SOCK_STATE_CONNECTING);
 }
 
 static void con_sock_state_connected(struct ceph_connection *con)
@@ -242,6 +246,8 @@ static void con_sock_state_connected(str
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CONNECTED);
 	if (WARN_ON(old_state != CON_SOCK_STATE_CONNECTING))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
+	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
+	     CON_SOCK_STATE_CONNECTED);
 }
 
 static void con_sock_state_closing(struct ceph_connection *con)
@@ -253,6 +259,8 @@ static void con_sock_state_closing(struc
 			old_state != CON_SOCK_STATE_CONNECTED &&
 			old_state != CON_SOCK_STATE_CLOSING))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
+	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
+	     CON_SOCK_STATE_CLOSING);
 }
 
 static void con_sock_state_closed(struct ceph_connection *con)
@@ -262,8 +270,11 @@ static void con_sock_state_closed(struct
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
@@ -448,14 +459,14 @@ static int ceph_tcp_sendpage(struct sock
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
@@ -464,6 +475,7 @@ static int con_close_socket(struct ceph_
 	 * shut the socket down.
 	 */
 	clear_bit(CON_FLAG_SOCK_CLOSED, &con->flags);
+
 	con_sock_state_closed(con);
 	return rc;
 }


