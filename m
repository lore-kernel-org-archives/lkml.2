Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab2KZRI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:08:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47672 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab2KZRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jim Schutt <jaschut@sandia.gov>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 144/270] libceph: avoid truncation due to racing banners
Date: Mon, 26 Nov 2012 14:57:14 -0200
Message-Id: <1353949160-26803-145-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Schutt <jaschut@sandia.gov>

commit 6d4221b53707486dfad3f5bfe568d2ce7f4c9863 upstream.

Because the Ceph client messenger uses a non-blocking connect, it is
possible for the sending of the client banner to race with the
arrival of the banner sent by the peer.

When ceph_sock_state_change() notices the connect has completed, it
schedules work to process the socket via con_work().  During this
time the peer is writing its banner, and arrival of the peer banner
races with con_work().

If con_work() calls try_read() before the peer banner arrives, there
is nothing for it to do, after which con_work() calls try_write() to
send the client's banner.  In this case Ceph's protocol negotiation
can complete succesfully.

The server-side messenger immediately sends its banner and addresses
after accepting a connect request, *before* actually attempting to
read or verify the banner from the client.  As a result, it is
possible for the banner from the server to arrive before con_work()
calls try_read().  If that happens, try_read() will read the banner
and prepare protocol negotiation info via prepare_write_connect().
prepare_write_connect() calls con_out_kvec_reset(), which discards
the as-yet-unsent client banner.  Next, con_work() calls
try_write(), which sends the protocol negotiation info rather than
the banner that the peer is expecting.

The result is that the peer sees an invalid banner, and the client
reports "negotiation failed".

Fix this by moving con_out_kvec_reset() out of
prepare_write_connect() to its callers at all locations except the
one where the banner might still need to be sent.

[elder@inktak.com: added note about server-side behavior]

Signed-off-by: Jim Schutt <jaschut@sandia.gov>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index b6655b1..b141c86 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -911,7 +911,6 @@ static int prepare_write_connect(struct ceph_connection *con)
 	con->out_connect.authorizer_len = auth ?
 		cpu_to_le32(auth->authorizer_buf_len) : 0;
 
-	con_out_kvec_reset(con);
 	con_out_kvec_add(con, sizeof (con->out_connect),
 					&con->out_connect);
 	if (auth && auth->authorizer_buf_len)
@@ -1553,6 +1552,7 @@ static int process_connect(struct ceph_connection *con)
 			return -1;
 		}
 		con->auth_retry = 1;
+		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1573,6 +1573,7 @@ static int process_connect(struct ceph_connection *con)
 		       ENTITY_NAME(con->peer_name),
 		       ceph_pr_addr(&con->peer_addr.in_addr));
 		reset_connection(con);
+		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1597,6 +1598,7 @@ static int process_connect(struct ceph_connection *con)
 		     le32_to_cpu(con->out_connect.connect_seq),
 		     le32_to_cpu(con->in_reply.connect_seq));
 		con->connect_seq = le32_to_cpu(con->in_reply.connect_seq);
+		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -1613,6 +1615,7 @@ static int process_connect(struct ceph_connection *con)
 		     le32_to_cpu(con->in_reply.global_seq));
 		get_global_seq(con->msgr,
 			       le32_to_cpu(con->in_reply.global_seq));
+		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			return ret;
@@ -2131,7 +2134,11 @@ more:
 		BUG_ON(con->state != CON_STATE_CONNECTING);
 		con->state = CON_STATE_NEGOTIATING;
 
-		/* Banner is good, exchange connection info */
+		/*
+		 * Received banner is good, exchange connection info.
+		 * Do not reset out_kvec, as sending our banner raced
+		 * with receiving peer banner after connect completed.
+		 */
 		ret = prepare_write_connect(con);
 		if (ret < 0)
 			goto out;
-- 
1.7.9.5

