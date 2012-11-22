Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab2KVVsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:48:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:49636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab2KVSkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 079/171] ceph: rename prepare_connect_authorizer()
Date: Wed, 21 Nov 2012 16:40:25 -0800
Message-Id: <20121122004041.301741564@linuxfoundation.org>
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

(cherry picked from commit dac1e716c60161867a47745bca592987ca3a9cb2)

Change the name of prepare_connect_authorizer().  The next
patch is going to make this function no longer add anything to the
connection's out_kvec, so it will no longer fit the pattern of
the rest of the prepare_connect_*() functions.

In addition, pass the address of a variable that will hold the
authorization protocol to use.  Move the assignment of that to the
connection's out_connect structure into prepare_write_connect().

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -653,11 +653,11 @@ static void prepare_write_keepalive(stru
  * Connection negotiation.
  */
 
-static struct ceph_auth_handshake *prepare_connect_authorizer(struct ceph_connection *con)
+static struct ceph_auth_handshake *get_connect_authorizer(struct ceph_connection *con,
+						int *auth_proto)
 {
 	void *auth_buf;
 	int auth_len;
-	int auth_protocol;
 	struct ceph_auth_handshake *auth;
 
 	if (!con->ops->get_authorizer) {
@@ -671,8 +671,7 @@ static struct ceph_auth_handshake *prepa
 
 	mutex_unlock(&con->mutex);
 
-	auth_protocol = CEPH_AUTH_UNKNOWN;
-	auth = con->ops->get_authorizer(con, &auth_protocol, con->auth_retry);
+	auth = con->ops->get_authorizer(con, auth_proto, con->auth_retry);
 
 	mutex_lock(&con->mutex);
 
@@ -686,7 +685,6 @@ static struct ceph_auth_handshake *prepa
 	con->auth_reply_buf = auth->authorizer_reply_buf;
 	con->auth_reply_buf_len = auth->authorizer_reply_buf_len;
 
-	con->out_connect.authorizer_protocol = cpu_to_le32(auth_protocol);
 	con->out_connect.authorizer_len = cpu_to_le32(auth_len);
 
 	if (auth_len)
@@ -712,6 +710,7 @@ static int prepare_write_connect(struct
 {
 	unsigned global_seq = get_global_seq(con->msgr, 0);
 	int proto;
+	int auth_proto;
 	struct ceph_auth_handshake *auth;
 
 	switch (con->peer_name.type) {
@@ -739,9 +738,11 @@ static int prepare_write_connect(struct
 	con->out_connect.flags = 0;
 
 	ceph_con_out_kvec_add(con, sizeof (con->out_connect), &con->out_connect);
-	auth = prepare_connect_authorizer(con);
+	auth_proto = CEPH_AUTH_UNKNOWN;
+	auth = get_connect_authorizer(con, &auth_proto);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
+	con->out_connect.authorizer_protocol = cpu_to_le32(auth_proto);
 
 	con->out_more = 0;
 	set_bit(WRITE_PENDING, &con->state);


