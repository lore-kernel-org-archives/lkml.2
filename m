Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab2KVSka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:49627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab2KVSkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 066/171] ceph: messenger: reset connection kvec caller
Date: Wed, 21 Nov 2012 16:40:12 -0800
Message-Id: <20121122004039.992696410@linuxfoundation.org>
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

(cherry picked from commit 84fb3adf6413862cff51d8af3fce5f0b655586a2)

Reset a connection's kvec fields in the caller rather than in
prepare_write_connect().   This ends up repeating a few lines of
code but it's improving the separation between distinct operations
on the connection, which we can take advantage of later.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -725,7 +725,6 @@ static int prepare_write_connect(struct
 	con->out_connect.protocol_version = cpu_to_le32(proto);
 	con->out_connect.flags = 0;
 
-	ceph_con_out_kvec_reset(con);
 	if (include_banner)
 		prepare_write_banner(msgr, con);
 	ceph_con_out_kvec_add(con, sizeof (con->out_connect), &con->out_connect);
@@ -1389,6 +1388,7 @@ static int process_connect(struct ceph_c
 			return -1;
 		}
 		con->auth_retry = 1;
+		ceph_con_out_kvec_reset(con);
 		ret = prepare_write_connect(con->msgr, con, 0);
 		if (ret < 0)
 			return ret;
@@ -1409,6 +1409,7 @@ static int process_connect(struct ceph_c
 		       ENTITY_NAME(con->peer_name),
 		       ceph_pr_addr(&con->peer_addr.in_addr));
 		reset_connection(con);
+		ceph_con_out_kvec_reset(con);
 		prepare_write_connect(con->msgr, con, 0);
 		prepare_read_connect(con);
 
@@ -1432,6 +1433,7 @@ static int process_connect(struct ceph_c
 		     le32_to_cpu(con->out_connect.connect_seq),
 		     le32_to_cpu(con->in_connect.connect_seq));
 		con->connect_seq = le32_to_cpu(con->in_connect.connect_seq);
+		ceph_con_out_kvec_reset(con);
 		prepare_write_connect(con->msgr, con, 0);
 		prepare_read_connect(con);
 		break;
@@ -1446,6 +1448,7 @@ static int process_connect(struct ceph_c
 		     le32_to_cpu(con->in_connect.global_seq));
 		get_global_seq(con->msgr,
 			       le32_to_cpu(con->in_connect.global_seq));
+		ceph_con_out_kvec_reset(con);
 		prepare_write_connect(con->msgr, con, 0);
 		prepare_read_connect(con);
 		break;
@@ -1851,6 +1854,7 @@ more:
 
 	/* open the socket first? */
 	if (con->sock == NULL) {
+		ceph_con_out_kvec_reset(con);
 		prepare_write_connect(msgr, con, 1);
 		prepare_read_banner(con);
 		set_bit(CONNECTING, &con->state);


