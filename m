Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab2KZRGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47522 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab2KZRGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 110/270] libceph: clear NEGOTIATING when done
Date: Mon, 26 Nov 2012 14:56:40 -0200
Message-Id: <1353949160-26803-111-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 3ec50d1868a9e0493046400bb1fdd054c7f64ebd upstream.

A connection state's NEGOTIATING bit gets set while in CONNECTING
state after we have successfully exchanged a ceph banner and IP
addresses with the connection's peer (the server).  But that bit
is not cleared again--at least not until another connection attempt
is initiated.

Instead, clear it as soon as the connection is fully established.
Also, clear it when a socket connection gets prematurely closed
in the midst of establishing a ceph connection (in case we had
reached the point where it was set).

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5e8033f..9e586ea 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1562,6 +1562,7 @@ static int process_connect(struct ceph_connection *con)
 			fail_protocol(con);
 			return -1;
 		}
+		clear_bit(NEGOTIATING, &con->state);
 		clear_bit(CONNECTING, &con->state);
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
@@ -1951,7 +1952,6 @@ more:
 
 	/* open the socket first? */
 	if (con->sock == NULL) {
-		clear_bit(NEGOTIATING, &con->state);
 		set_bit(CONNECTING, &con->state);
 
 		con_out_kvec_reset(con);
@@ -2190,10 +2190,12 @@ static void con_work(struct work_struct *work)
 	mutex_lock(&con->mutex);
 restart:
 	if (test_and_clear_bit(SOCK_CLOSED, &con->flags)) {
-		if (test_and_clear_bit(CONNECTING, &con->state))
+		if (test_and_clear_bit(CONNECTING, &con->state)) {
+			clear_bit(NEGOTIATING, &con->state);
 			con->error_msg = "connection failed";
-		else
+		} else {
 			con->error_msg = "socket closed";
+		}
 		goto fault;
 	}
 
-- 
1.7.9.5

