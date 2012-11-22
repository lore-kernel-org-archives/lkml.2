Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab2KVVhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:37:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:49635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab2KVSk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 080/171] ceph: add auth buf in prepare_write_connect()
Date: Wed, 21 Nov 2012 16:40:26 -0800
Message-Id: <20121122004041.404694562@linuxfoundation.org>
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

(cherry picked from commit 3da54776e2c0385c32d143fd497a7f40a88e29dd)

Move the addition of the authorizer buffer to a connection's
out_kvec out of get_connect_authorizer() and into its caller.  This
way, the caller--prepare_write_connect()--can avoid adding the
connect header to out_kvec before it has been fully initialized.

Prior to this patch, it was possible for a connect header to be
sent over the wire before the authorizer protocol or buffer length
fields were initialized.  An authorizer buffer associated with that
header could also be queued to send only after the connection header
that describes it was on the wire.

Fixes http://tracker.newdream.net/issues/2424

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -656,8 +656,6 @@ static void prepare_write_keepalive(stru
 static struct ceph_auth_handshake *get_connect_authorizer(struct ceph_connection *con,
 						int *auth_proto)
 {
-	void *auth_buf;
-	int auth_len;
 	struct ceph_auth_handshake *auth;
 
 	if (!con->ops->get_authorizer) {
@@ -680,15 +678,9 @@ static struct ceph_auth_handshake *get_c
 	if (test_bit(CLOSED, &con->state) || test_bit(OPENING, &con->state))
 		return ERR_PTR(-EAGAIN);
 
-	auth_buf = auth->authorizer_buf;
-	auth_len = auth->authorizer_buf_len;
 	con->auth_reply_buf = auth->authorizer_reply_buf;
 	con->auth_reply_buf_len = auth->authorizer_reply_buf_len;
 
-	con->out_connect.authorizer_len = cpu_to_le32(auth_len);
-
-	if (auth_len)
-		ceph_con_out_kvec_add(con, auth_len, auth_buf);
 
 	return auth;
 }
@@ -737,12 +729,20 @@ static int prepare_write_connect(struct
 	con->out_connect.protocol_version = cpu_to_le32(proto);
 	con->out_connect.flags = 0;
 
-	ceph_con_out_kvec_add(con, sizeof (con->out_connect), &con->out_connect);
 	auth_proto = CEPH_AUTH_UNKNOWN;
 	auth = get_connect_authorizer(con, &auth_proto);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
+
 	con->out_connect.authorizer_protocol = cpu_to_le32(auth_proto);
+	con->out_connect.authorizer_len = auth ?
+		cpu_to_le32(auth->authorizer_buf_len) : 0;
+
+	ceph_con_out_kvec_add(con, sizeof (con->out_connect),
+					&con->out_connect);
+	if (auth && auth->authorizer_buf_len)
+		ceph_con_out_kvec_add(con, auth->authorizer_buf_len,
+					auth->authorizer_buf);
 
 	con->out_more = 0;
 	set_bit(WRITE_PENDING, &con->state);


