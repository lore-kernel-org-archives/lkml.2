Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2KVVxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:53:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:49645 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab2KVSkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 078/171] ceph: return pointer from prepare_connect_authorizer()
Date: Wed, 21 Nov 2012 16:40:24 -0800
Message-Id: <20121122004041.203037412@linuxfoundation.org>
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

(cherry picked from commit 729796be9190f57ca40ccca315e8ad34a1eb8fef)

Change prepare_connect_authorizer() so it returns a pointer (or
pointer-coded error).

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -653,7 +653,7 @@ static void prepare_write_keepalive(stru
  * Connection negotiation.
  */
 
-static int prepare_connect_authorizer(struct ceph_connection *con)
+static struct ceph_auth_handshake *prepare_connect_authorizer(struct ceph_connection *con)
 {
 	void *auth_buf;
 	int auth_len;
@@ -664,7 +664,7 @@ static int prepare_connect_authorizer(st
 		con->out_connect.authorizer_protocol = CEPH_AUTH_UNKNOWN;
 		con->out_connect.authorizer_len = 0;
 
-		return 0;
+		return NULL;
 	}
 
 	/* Can't hold the mutex while getting authorizer */
@@ -677,9 +677,9 @@ static int prepare_connect_authorizer(st
 	mutex_lock(&con->mutex);
 
 	if (IS_ERR(auth))
-		return PTR_ERR(auth);
+		return auth;
 	if (test_bit(CLOSED, &con->state) || test_bit(OPENING, &con->state))
-		return -EAGAIN;
+		return ERR_PTR(-EAGAIN);
 
 	auth_buf = auth->authorizer_buf;
 	auth_len = auth->authorizer_buf_len;
@@ -692,7 +692,7 @@ static int prepare_connect_authorizer(st
 	if (auth_len)
 		ceph_con_out_kvec_add(con, auth_len, auth_buf);
 
-	return 0;
+	return auth;
 }
 
 /*
@@ -712,7 +712,7 @@ static int prepare_write_connect(struct
 {
 	unsigned global_seq = get_global_seq(con->msgr, 0);
 	int proto;
-	int ret;
+	struct ceph_auth_handshake *auth;
 
 	switch (con->peer_name.type) {
 	case CEPH_ENTITY_TYPE_MON:
@@ -739,9 +739,9 @@ static int prepare_write_connect(struct
 	con->out_connect.flags = 0;
 
 	ceph_con_out_kvec_add(con, sizeof (con->out_connect), &con->out_connect);
-	ret = prepare_connect_authorizer(con);
-	if (ret)
-		return ret;
+	auth = prepare_connect_authorizer(con);
+	if (IS_ERR(auth))
+		return PTR_ERR(auth);
 
 	con->out_more = 0;
 	set_bit(WRITE_PENDING, &con->state);


