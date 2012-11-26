Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2KZREi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:04:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47384 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2KZREc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 077/270] libceph: rename kvec_reset and kvec_add functions
Date: Mon, 26 Nov 2012 14:56:07 -0200
Message-Id: <1353949160-26803-78-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit e22004235a900213625acd6583ac913d5a30c155 upstream.

The functions ceph_con_out_kvec_reset() and ceph_con_out_kvec_add()
are entirely private functions, so drop the "ceph_" prefix in their
name to make them slightly more wieldy.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5fb9937..d0b27e9 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -486,14 +486,14 @@ static u32 get_global_seq(struct ceph_messenger *msgr, u32 gt)
 	return ret;
 }
 
-static void ceph_con_out_kvec_reset(struct ceph_connection *con)
+static void con_out_kvec_reset(struct ceph_connection *con)
 {
 	con->out_kvec_left = 0;
 	con->out_kvec_bytes = 0;
 	con->out_kvec_cur = &con->out_kvec[0];
 }
 
-static void ceph_con_out_kvec_add(struct ceph_connection *con,
+static void con_out_kvec_add(struct ceph_connection *con,
 				size_t size, void *data)
 {
 	int index;
@@ -534,7 +534,7 @@ static void prepare_write_message(struct ceph_connection *con)
 	struct ceph_msg *m;
 	u32 crc;
 
-	ceph_con_out_kvec_reset(con);
+	con_out_kvec_reset(con);
 	con->out_kvec_is_msg = true;
 	con->out_msg_done = false;
 
@@ -542,9 +542,9 @@ static void prepare_write_message(struct ceph_connection *con)
 	 * TCP packet that's a good thing. */
 	if (con->in_seq > con->in_seq_acked) {
 		con->in_seq_acked = con->in_seq;
-		ceph_con_out_kvec_add(con, sizeof (tag_ack), &tag_ack);
+		con_out_kvec_add(con, sizeof (tag_ack), &tag_ack);
 		con->out_temp_ack = cpu_to_le64(con->in_seq_acked);
-		ceph_con_out_kvec_add(con, sizeof (con->out_temp_ack),
+		con_out_kvec_add(con, sizeof (con->out_temp_ack),
 			&con->out_temp_ack);
 	}
 
@@ -576,12 +576,12 @@ static void prepare_write_message(struct ceph_connection *con)
 	BUG_ON(le32_to_cpu(m->hdr.front_len) != m->front.iov_len);
 
 	/* tag + hdr + front + middle */
-	ceph_con_out_kvec_add(con, sizeof (tag_msg), &tag_msg);
-	ceph_con_out_kvec_add(con, sizeof (m->hdr), &m->hdr);
-	ceph_con_out_kvec_add(con, m->front.iov_len, m->front.iov_base);
+	con_out_kvec_add(con, sizeof (tag_msg), &tag_msg);
+	con_out_kvec_add(con, sizeof (m->hdr), &m->hdr);
+	con_out_kvec_add(con, m->front.iov_len, m->front.iov_base);
 
 	if (m->middle)
-		ceph_con_out_kvec_add(con, m->middle->vec.iov_len,
+		con_out_kvec_add(con, m->middle->vec.iov_len,
 			m->middle->vec.iov_base);
 
 	/* fill in crc (except data pages), footer */
@@ -630,12 +630,12 @@ static void prepare_write_ack(struct ceph_connection *con)
 	     con->in_seq_acked, con->in_seq);
 	con->in_seq_acked = con->in_seq;
 
-	ceph_con_out_kvec_reset(con);
+	con_out_kvec_reset(con);
 
-	ceph_con_out_kvec_add(con, sizeof (tag_ack), &tag_ack);
+	con_out_kvec_add(con, sizeof (tag_ack), &tag_ack);
 
 	con->out_temp_ack = cpu_to_le64(con->in_seq_acked);
-	ceph_con_out_kvec_add(con, sizeof (con->out_temp_ack),
+	con_out_kvec_add(con, sizeof (con->out_temp_ack),
 				&con->out_temp_ack);
 
 	con->out_more = 1;  /* more will follow.. eventually.. */
@@ -648,8 +648,8 @@ static void prepare_write_ack(struct ceph_connection *con)
 static void prepare_write_keepalive(struct ceph_connection *con)
 {
 	dout("prepare_write_keepalive %p\n", con);
-	ceph_con_out_kvec_reset(con);
-	ceph_con_out_kvec_add(con, sizeof (tag_keepalive), &tag_keepalive);
+	con_out_kvec_reset(con);
+	con_out_kvec_add(con, sizeof (tag_keepalive), &tag_keepalive);
 	set_bit(WRITE_PENDING, &con->state);
 }
 
@@ -694,8 +694,8 @@ static struct ceph_auth_handshake *get_connect_authorizer(struct ceph_connection
  */
 static void prepare_write_banner(struct ceph_connection *con)
 {
-	ceph_con_out_kvec_add(con, strlen(CEPH_BANNER), CEPH_BANNER);
-	ceph_con_out_kvec_add(con, sizeof (con->msgr->my_enc_addr),
+	con_out_kvec_add(con, strlen(CEPH_BANNER), CEPH_BANNER);
+	con_out_kvec_add(con, sizeof (con->msgr->my_enc_addr),
 					&con->msgr->my_enc_addr);
 
 	con->out_more = 0;
@@ -742,10 +742,10 @@ static int prepare_write_connect(struct ceph_connection *con)
 	con->out_connect.authorizer_len = auth ?
 		cpu_to_le32(auth->authorizer_buf_len) : 0;
 
-	ceph_con_out_kvec_add(con, sizeof (con->out_connect),
+	con_out_kvec_add(con, sizeof (con->out_connect),
 					&con->out_connect);
 	if (auth && auth->authorizer_buf_len)
-		ceph_con_out_kvec_add(con, auth->authorizer_buf_len,
+		con_out_kvec_add(con, auth->authorizer_buf_len,
 					auth->authorizer_buf);
 
 	con->out_more = 0;
@@ -939,7 +939,7 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 	/* prepare and queue up footer, too */
 	if (!do_datacrc)
 		con->out_msg->footer.flags |= CEPH_MSG_FOOTER_NOCRC;
-	ceph_con_out_kvec_reset(con);
+	con_out_kvec_reset(con);
 	prepare_write_message_footer(con);
 	ret = 1;
 out:
@@ -1402,7 +1402,7 @@ static int process_connect(struct ceph_connection *con)
 			return -1;
 		}
 		con->auth_retry = 1;
-		ceph_con_out_kvec_reset(con);
+		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1423,7 +1423,7 @@ static int process_connect(struct ceph_connection *con)
 		       ENTITY_NAME(con->peer_name),
 		       ceph_pr_addr(&con->peer_addr.in_addr));
 		reset_connection(con);
-		ceph_con_out_kvec_reset(con);
+		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1449,7 +1449,7 @@ static int process_connect(struct ceph_connection *con)
 		     le32_to_cpu(con->out_connect.connect_seq),
 		     le32_to_cpu(con->in_reply.connect_seq));
 		con->connect_seq = le32_to_cpu(con->in_reply.connect_seq);
-		ceph_con_out_kvec_reset(con);
+		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1466,7 +1466,7 @@ static int process_connect(struct ceph_connection *con)
 		     le32_to_cpu(con->in_reply.global_seq));
 		get_global_seq(con->msgr,
 			       le32_to_cpu(con->in_reply.global_seq));
-		ceph_con_out_kvec_reset(con);
+		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1873,7 +1873,7 @@ more:
 
 	/* open the socket first? */
 	if (con->sock == NULL) {
-		ceph_con_out_kvec_reset(con);
+		con_out_kvec_reset(con);
 		prepare_write_banner(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
-- 
1.7.9.5

