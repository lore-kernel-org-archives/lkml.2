Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab2KVWEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:04:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:49645 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab2KVSkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 072/171] ceph: messenger: check return from get_authorizer
Date: Wed, 21 Nov 2012 16:40:18 -0800
Message-Id: <20121122004040.611761912@linuxfoundation.org>
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

(cherry picked from commit ed96af646011412c2bf1ffe860db170db355fae5)

In prepare_connect_authorizer(), a connection's get_authorizer
method is called but ignores its return value.  This function can
return an error, so check for it and return it if that ever occurs.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -658,6 +658,7 @@ static int prepare_connect_authorizer(st
 	void *auth_buf;
 	int auth_len;
 	int auth_protocol;
+	int ret;
 
 	if (!con->ops->get_authorizer) {
 		con->out_connect.authorizer_protocol = CEPH_AUTH_UNKNOWN;
@@ -673,11 +674,14 @@ static int prepare_connect_authorizer(st
 	auth_buf = NULL;
 	auth_len = 0;
 	auth_protocol = CEPH_AUTH_UNKNOWN;
-	con->ops->get_authorizer(con, &auth_buf, &auth_len, &auth_protocol,
-				&con->auth_reply_buf, &con->auth_reply_buf_len,
-				con->auth_retry);
+	ret = con->ops->get_authorizer(con, &auth_buf, &auth_len,
+				&auth_protocol, &con->auth_reply_buf,
+				&con->auth_reply_buf_len, con->auth_retry);
 	mutex_lock(&con->mutex);
 
+	if (ret)
+		return ret;
+
 	if (test_bit(CLOSED, &con->state) || test_bit(OPENING, &con->state))
 		return -EAGAIN;
 


