Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2KVVsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:48:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:49639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab2KVSkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 063/171] ceph: messenger: update "to" in read_partial() caller
Date: Wed, 21 Nov 2012 16:40:09 -0800
Message-Id: <20121122004039.701295615@linuxfoundation.org>
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

(cherry picked from commit e6cee71fac27c946a0bbad754dd076e66c4e9dbd)

read_partial() always increases whatever "to" value is supplied by
adding the requested size to it, and that's the only thing it does
with that pointed-to value.

Do that pointer advance in the caller (and then only when the
updated value will be subsequently used), and change the "to"
parameter to be an in-only and non-pointer value.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -992,11 +992,12 @@ static int prepare_read_message(struct c
 
 
 static int read_partial(struct ceph_connection *con,
-			int *to, int size, void *object)
+			int to, int size, void *object)
 {
-	*to += size;
-	while (con->in_base_pos < *to) {
-		int left = *to - con->in_base_pos;
+	int end = to + size;
+
+	while (con->in_base_pos < end) {
+		int left = end - con->in_base_pos;
 		int have = size - left;
 		int ret = ceph_tcp_recvmsg(con->sock, object + have, left);
 		if (ret <= 0)
@@ -1017,14 +1018,16 @@ static int read_partial_banner(struct ce
 	dout("read_partial_banner %p at %d\n", con, con->in_base_pos);
 
 	/* peer's banner */
-	ret = read_partial(con, &to, strlen(CEPH_BANNER), con->in_banner);
+	ret = read_partial(con, to, strlen(CEPH_BANNER), con->in_banner);
 	if (ret <= 0)
 		goto out;
-	ret = read_partial(con, &to, sizeof(con->actual_peer_addr),
+	to += strlen(CEPH_BANNER);
+	ret = read_partial(con, to, sizeof(con->actual_peer_addr),
 			   &con->actual_peer_addr);
 	if (ret <= 0)
 		goto out;
-	ret = read_partial(con, &to, sizeof(con->peer_addr_for_me),
+	to += sizeof(con->actual_peer_addr);
+	ret = read_partial(con, to, sizeof(con->peer_addr_for_me),
 			   &con->peer_addr_for_me);
 	if (ret <= 0)
 		goto out;
@@ -1038,10 +1041,11 @@ static int read_partial_connect(struct c
 
 	dout("read_partial_connect %p at %d\n", con, con->in_base_pos);
 
-	ret = read_partial(con, &to, sizeof(con->in_reply), &con->in_reply);
+	ret = read_partial(con, to, sizeof(con->in_reply), &con->in_reply);
 	if (ret <= 0)
 		goto out;
-	ret = read_partial(con, &to, le32_to_cpu(con->in_reply.authorizer_len),
+	to += sizeof(con->in_reply);
+	ret = read_partial(con, to, le32_to_cpu(con->in_reply.authorizer_len),
 			   con->auth_reply_buf);
 	if (ret <= 0)
 		goto out;
@@ -1491,9 +1495,7 @@ static int process_connect(struct ceph_c
  */
 static int read_partial_ack(struct ceph_connection *con)
 {
-	int to = 0;
-
-	return read_partial(con, &to, sizeof(con->in_temp_ack),
+	return read_partial(con, 0, sizeof(con->in_temp_ack),
 			    &con->in_temp_ack);
 }
 
@@ -1638,8 +1640,7 @@ static int read_partial_message(struct c
 	dout("read_partial_message con %p msg %p\n", con, m);
 
 	/* header */
-	to = 0;
-	ret = read_partial(con, &to, sizeof (con->in_hdr), &con->in_hdr);
+	ret = read_partial(con, 0, sizeof (con->in_hdr), &con->in_hdr);
 	if (ret <= 0)
 		return ret;
 
@@ -1755,7 +1756,7 @@ static int read_partial_message(struct c
 
 	/* footer */
 	to = sizeof (m->hdr);
-	ret = read_partial(con, &to, sizeof (m->footer), &m->footer);
+	ret = read_partial(con, to, sizeof (m->footer), &m->footer);
 	if (ret <= 0)
 		return ret;
 


