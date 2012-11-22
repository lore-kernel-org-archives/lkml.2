Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab2KVVlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:41:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:49620 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab2KVSk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 077/171] ceph: use info returned by get_authorizer
Date: Wed, 21 Nov 2012 16:40:23 -0800
Message-Id: <20121122004041.102165170@linuxfoundation.org>
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

(cherry picked from commit 8f43fb53894079bf0caab6e348ceaffe7adc651a)

Rather than passing a bunch of arguments to be filled in with the
content of the ceph_auth_handshake buffer now returned by the
get_authorizer method, just use the returned information in the
caller, and drop the unnecessary arguments.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c           |    9 +--------
 include/linux/ceph/messenger.h |    4 +---
 net/ceph/messenger.c           |   13 +++++++------
 net/ceph/osd_client.c          |    9 +--------
 4 files changed, 10 insertions(+), 25 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3401,9 +3401,7 @@ out:
  * managed separately.  Caller must *not* attempt to free it.
  */
 static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
-					void **buf, int *len, int *proto,
-					void **reply_buf, int *reply_len,
-					int force_new)
+					int *proto, int force_new)
 {
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
@@ -3421,12 +3419,7 @@ static struct ceph_auth_handshake *get_a
 		if (ret)
 			return ERR_PTR(ret);
 	}
-
 	*proto = ac->protocol;
-	*buf = auth->authorizer_buf;
-	*len = auth->authorizer_buf_len;
-	*reply_buf = auth->authorizer_reply_buf;
-	*reply_len = auth->authorizer_reply_buf_len;
 
 	return auth;
 }
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -27,9 +27,7 @@ struct ceph_connection_operations {
 	/* authorize an outgoing connection */
 	struct ceph_auth_handshake *(*get_authorizer) (
 				struct ceph_connection *con,
-				void **buf, int *len, int *proto,
-				void **reply_buf, int *reply_len,
-				int force_new);
+			       int *proto, int force_new);
 	int (*verify_authorizer_reply) (struct ceph_connection *con, int len);
 	int (*invalidate_authorizer)(struct ceph_connection *con);
 
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -671,20 +671,21 @@ static int prepare_connect_authorizer(st
 
 	mutex_unlock(&con->mutex);
 
-	auth_buf = NULL;
-	auth_len = 0;
 	auth_protocol = CEPH_AUTH_UNKNOWN;
-	auth = con->ops->get_authorizer(con, &auth_buf, &auth_len,
-				&auth_protocol, &con->auth_reply_buf,
-				&con->auth_reply_buf_len, con->auth_retry);
+	auth = con->ops->get_authorizer(con, &auth_protocol, con->auth_retry);
+
 	mutex_lock(&con->mutex);
 
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
-
 	if (test_bit(CLOSED, &con->state) || test_bit(OPENING, &con->state))
 		return -EAGAIN;
 
+	auth_buf = auth->authorizer_buf;
+	auth_len = auth->authorizer_buf_len;
+	con->auth_reply_buf = auth->authorizer_reply_buf;
+	con->auth_reply_buf_len = auth->authorizer_reply_buf_len;
+
 	con->out_connect.authorizer_protocol = cpu_to_le32(auth_protocol);
 	con->out_connect.authorizer_len = cpu_to_le32(auth_len);
 
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2113,9 +2113,7 @@ static void put_osd_con(struct ceph_conn
  * managed separately.  Caller must *not* attempt to free it.
  */
 static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
-					void **buf, int *len, int *proto,
-					void **reply_buf, int *reply_len,
-					int force_new)
+					int *proto, int force_new)
 {
 	struct ceph_osd *o = con->private;
 	struct ceph_osd_client *osdc = o->o_osdc;
@@ -2133,12 +2131,7 @@ static struct ceph_auth_handshake *get_a
 		if (ret)
 			return ERR_PTR(ret);
 	}
-
 	*proto = ac->protocol;
-	*buf = auth->authorizer_buf;
-	*len = auth->authorizer_buf_len;
-	*reply_buf = auth->authorizer_reply_buf;
-	*reply_len = auth->authorizer_reply_buf_len;
 
 	return auth;
 }


