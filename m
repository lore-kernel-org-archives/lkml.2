Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab2KZRGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932995Ab2KZRGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 112/270] libceph: separate banner and connect writes
Date: Mon, 26 Nov 2012 14:56:42 -0200
Message-Id: <1353949160-26803-113-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit ab166d5aa3bc036fba7efaca6e4e43a7e9510acf upstream.

There are two phases in the process of linking together the two ends
of a ceph connection.  The first involves exchanging a banner and
IP addresses, and if that is successful a second phase exchanges
some detail about each side's connection capabilities.

When initiating a connection, the client side now queues to send
its information for both phases of this process at the same time.
This is probably a bit more efficient, but it is slightly messier
from a layering perspective in the code.

So rearrange things so that the client doesn't send the connection
information until it has received and processed the response in the
initial banner phase (in process_banner()).

Move the code (in the (con->sock == NULL) case in try_write()) that
prepares for writing the connection information, delaying doing that
until the banner exchange has completed.  Move the code that begins
the transition to this second "NEGOTIATING" phase out of
process_banner() and into its caller, so preparing to write the
connection information and preparing to read the response are
adjacent to each other.

Finally, preparing to write the connection information now requires
the output kvec to be reset in all cases, so move that into the
prepare_write_connect() and delete it from all callers.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index dc95437..86294c1 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -841,6 +841,7 @@ static int prepare_write_connect(struct ceph_connection *con)
 	con->out_connect.authorizer_len = auth ?
 		cpu_to_le32(auth->authorizer_buf_len) : 0;
 
+	con_out_kvec_reset(con);
 	con_out_kvec_add(con, sizeof (con->out_connect),
 					&con->out_connect);
 	if (auth && auth->authorizer_buf_len)
@@ -1430,8 +1431,6 @@ static int process_banner(struct ceph_connection *con)
 		     ceph_pr_addr(&con->msgr->inst.addr.in_addr));
 	}
 
-	set_bit(NEGOTIATING, &con->state);
-	prepare_read_connect(con);
 	return 0;
 }
 
@@ -1481,7 +1480,6 @@ static int process_connect(struct ceph_connection *con)
 			return -1;
 		}
 		con->auth_retry = 1;
-		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1502,7 +1500,6 @@ static int process_connect(struct ceph_connection *con)
 		       ENTITY_NAME(con->peer_name),
 		       ceph_pr_addr(&con->peer_addr.in_addr));
 		reset_connection(con);
-		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1528,7 +1525,6 @@ static int process_connect(struct ceph_connection *con)
 		     le32_to_cpu(con->out_connect.connect_seq),
 		     le32_to_cpu(con->in_reply.connect_seq));
 		con->connect_seq = le32_to_cpu(con->in_reply.connect_seq);
-		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1545,7 +1541,6 @@ static int process_connect(struct ceph_connection *con)
 		     le32_to_cpu(con->in_reply.global_seq));
 		get_global_seq(con->msgr,
 			       le32_to_cpu(con->in_reply.global_seq));
-		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1958,9 +1953,6 @@ more:
 
 		con_out_kvec_reset(con);
 		prepare_write_banner(con);
-		ret = prepare_write_connect(con);
-		if (ret < 0)
-			goto out;
 		prepare_read_banner(con);
 
 		BUG_ON(con->in_msg);
@@ -2073,6 +2065,16 @@ more:
 			ret = process_banner(con);
 			if (ret < 0)
 				goto out;
+
+			/* Banner is good, exchange connection info */
+			ret = prepare_write_connect(con);
+			if (ret < 0)
+				goto out;
+			prepare_read_connect(con);
+			set_bit(NEGOTIATING, &con->state);
+
+			/* Send connection info before awaiting response */
+			goto out;
 		}
 		ret = read_partial_connect(con);
 		if (ret <= 0)
-- 
1.7.9.5

