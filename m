Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2KVVoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:44:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:49632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab2KVSkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 067/171] ceph: messenger: send banner in process_connect()
Date: Wed, 21 Nov 2012 16:40:13 -0800
Message-Id: <20121122004040.097747919@linuxfoundation.org>
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

(cherry picked from commit 41b90c00858129f52d08e6a05c9cfdb0f2bd074d)

prepare_write_connect() has an argument indicating whether a banner
should be sent out before sending out a connection message.  It's
only ever set in one of its callers, so move the code that arranges
to send the banner into that caller and drop the "include_banner"
argument from prepare_write_connect().

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -695,8 +695,7 @@ static void prepare_write_banner(struct
 }
 
 static int prepare_write_connect(struct ceph_messenger *msgr,
-				 struct ceph_connection *con,
-				 int include_banner)
+				 struct ceph_connection *con)
 {
 	unsigned global_seq = get_global_seq(con->msgr, 0);
 	int proto;
@@ -725,8 +724,6 @@ static int prepare_write_connect(struct
 	con->out_connect.protocol_version = cpu_to_le32(proto);
 	con->out_connect.flags = 0;
 
-	if (include_banner)
-		prepare_write_banner(msgr, con);
 	ceph_con_out_kvec_add(con, sizeof (con->out_connect), &con->out_connect);
 
 	con->out_more = 0;
@@ -1389,7 +1386,7 @@ static int process_connect(struct ceph_c
 		}
 		con->auth_retry = 1;
 		ceph_con_out_kvec_reset(con);
-		ret = prepare_write_connect(con->msgr, con, 0);
+		ret = prepare_write_connect(con->msgr, con);
 		if (ret < 0)
 			return ret;
 		prepare_read_connect(con);
@@ -1410,7 +1407,7 @@ static int process_connect(struct ceph_c
 		       ceph_pr_addr(&con->peer_addr.in_addr));
 		reset_connection(con);
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(con->msgr, con, 0);
+		prepare_write_connect(con->msgr, con);
 		prepare_read_connect(con);
 
 		/* Tell ceph about it. */
@@ -1434,7 +1431,7 @@ static int process_connect(struct ceph_c
 		     le32_to_cpu(con->in_connect.connect_seq));
 		con->connect_seq = le32_to_cpu(con->in_connect.connect_seq);
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(con->msgr, con, 0);
+		prepare_write_connect(con->msgr, con);
 		prepare_read_connect(con);
 		break;
 
@@ -1449,7 +1446,7 @@ static int process_connect(struct ceph_c
 		get_global_seq(con->msgr,
 			       le32_to_cpu(con->in_connect.global_seq));
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(con->msgr, con, 0);
+		prepare_write_connect(con->msgr, con);
 		prepare_read_connect(con);
 		break;
 
@@ -1855,7 +1852,8 @@ more:
 	/* open the socket first? */
 	if (con->sock == NULL) {
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(msgr, con, 1);
+		prepare_write_banner(msgr, con);
+		prepare_write_connect(msgr, con);
 		prepare_read_banner(con);
 		set_bit(CONNECTING, &con->state);
 		clear_bit(NEGOTIATING, &con->state);


