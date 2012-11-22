Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2KVVoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:44:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:49609 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab2KVSkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 068/171] ceph: drop msgr argument from prepare_write_connect()
Date: Wed, 21 Nov 2012 16:40:14 -0800
Message-Id: <20121122004040.200963265@linuxfoundation.org>
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

(cherry picked from commit e825a66df97776d30a48a187e3a986736af43945)

In all cases, the value passed as the msgr argument to
prepare_write_connect() is just con->msgr.  Just get the msgr
value from the ceph connection and drop the unneeded argument.

The only msgr passed to prepare_write_banner() is also therefore
just the one from con->msgr, so change that function to drop the
msgr argument as well.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -683,19 +683,17 @@ static int prepare_connect_authorizer(st
 /*
  * We connected to a peer and are saying hello.
  */
-static void prepare_write_banner(struct ceph_messenger *msgr,
-				 struct ceph_connection *con)
+static void prepare_write_banner(struct ceph_connection *con)
 {
 	ceph_con_out_kvec_add(con, strlen(CEPH_BANNER), CEPH_BANNER);
-	ceph_con_out_kvec_add(con, sizeof (msgr->my_enc_addr),
-					&msgr->my_enc_addr);
+	ceph_con_out_kvec_add(con, sizeof (con->msgr->my_enc_addr),
+					&con->msgr->my_enc_addr);
 
 	con->out_more = 0;
 	set_bit(WRITE_PENDING, &con->state);
 }
 
-static int prepare_write_connect(struct ceph_messenger *msgr,
-				 struct ceph_connection *con)
+static int prepare_write_connect(struct ceph_connection *con)
 {
 	unsigned global_seq = get_global_seq(con->msgr, 0);
 	int proto;
@@ -717,7 +715,7 @@ static int prepare_write_connect(struct
 	dout("prepare_write_connect %p cseq=%d gseq=%d proto=%d\n", con,
 	     con->connect_seq, global_seq, proto);
 
-	con->out_connect.features = cpu_to_le64(msgr->supported_features);
+	con->out_connect.features = cpu_to_le64(con->msgr->supported_features);
 	con->out_connect.host_type = cpu_to_le32(CEPH_ENTITY_TYPE_CLIENT);
 	con->out_connect.connect_seq = cpu_to_le32(con->connect_seq);
 	con->out_connect.global_seq = cpu_to_le32(global_seq);
@@ -1386,7 +1384,7 @@ static int process_connect(struct ceph_c
 		}
 		con->auth_retry = 1;
 		ceph_con_out_kvec_reset(con);
-		ret = prepare_write_connect(con->msgr, con);
+		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
 		prepare_read_connect(con);
@@ -1407,7 +1405,7 @@ static int process_connect(struct ceph_c
 		       ceph_pr_addr(&con->peer_addr.in_addr));
 		reset_connection(con);
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(con->msgr, con);
+		prepare_write_connect(con);
 		prepare_read_connect(con);
 
 		/* Tell ceph about it. */
@@ -1431,7 +1429,7 @@ static int process_connect(struct ceph_c
 		     le32_to_cpu(con->in_connect.connect_seq));
 		con->connect_seq = le32_to_cpu(con->in_connect.connect_seq);
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(con->msgr, con);
+		prepare_write_connect(con);
 		prepare_read_connect(con);
 		break;
 
@@ -1446,7 +1444,7 @@ static int process_connect(struct ceph_c
 		get_global_seq(con->msgr,
 			       le32_to_cpu(con->in_connect.global_seq));
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(con->msgr, con);
+		prepare_write_connect(con);
 		prepare_read_connect(con);
 		break;
 
@@ -1840,7 +1838,6 @@ static void process_message(struct ceph_
  */
 static int try_write(struct ceph_connection *con)
 {
-	struct ceph_messenger *msgr = con->msgr;
 	int ret = 1;
 
 	dout("try_write start %p state %lu nref %d\n", con, con->state,
@@ -1852,8 +1849,8 @@ more:
 	/* open the socket first? */
 	if (con->sock == NULL) {
 		ceph_con_out_kvec_reset(con);
-		prepare_write_banner(msgr, con);
-		prepare_write_connect(msgr, con);
+		prepare_write_banner(con);
+		prepare_write_connect(con);
 		prepare_read_banner(con);
 		set_bit(CONNECTING, &con->state);
 		clear_bit(NEGOTIATING, &con->state);


