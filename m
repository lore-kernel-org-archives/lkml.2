Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2KVSdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:33:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:48997 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab2KVSd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 071/171] ceph: messenger: rework prepare_connect_authorizer()
Date: Wed, 21 Nov 2012 16:40:17 -0800
Message-Id: <20121122004040.512680515@linuxfoundation.org>
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

(cherry picked from commit b1c6b9803f5491e94041e6da96bc9dec3870e792)

Change prepare_connect_authorizer() so it returns without dropping
the connection mutex if the connection has no get_authorizer method.

Use the symbolic CEPH_AUTH_UNKNOWN instead of 0 when assigning
authorization protocols.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -656,19 +656,29 @@ static void prepare_write_keepalive(stru
 static int prepare_connect_authorizer(struct ceph_connection *con)
 {
 	void *auth_buf;
-	int auth_len = 0;
-	int auth_protocol = 0;
+	int auth_len;
+	int auth_protocol;
+
+	if (!con->ops->get_authorizer) {
+		con->out_connect.authorizer_protocol = CEPH_AUTH_UNKNOWN;
+		con->out_connect.authorizer_len = 0;
+
+		return 0;
+	}
+
+	/* Can't hold the mutex while getting authorizer */
 
 	mutex_unlock(&con->mutex);
-	if (con->ops->get_authorizer)
-		con->ops->get_authorizer(con, &auth_buf, &auth_len,
-					 &auth_protocol, &con->auth_reply_buf,
-					 &con->auth_reply_buf_len,
-					 con->auth_retry);
+
+	auth_buf = NULL;
+	auth_len = 0;
+	auth_protocol = CEPH_AUTH_UNKNOWN;
+	con->ops->get_authorizer(con, &auth_buf, &auth_len, &auth_protocol,
+				&con->auth_reply_buf, &con->auth_reply_buf_len,
+				con->auth_retry);
 	mutex_lock(&con->mutex);
 
-	if (test_bit(CLOSED, &con->state) ||
-	    test_bit(OPENING, &con->state))
+	if (test_bit(CLOSED, &con->state) || test_bit(OPENING, &con->state))
 		return -EAGAIN;
 
 	con->out_connect.authorizer_protocol = cpu_to_le32(auth_protocol);


