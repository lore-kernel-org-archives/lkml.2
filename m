Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2KZR5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:57:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47526 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab2KZRGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 111/270] libceph: define and use an explicit CONNECTED state
Date: Mon, 26 Nov 2012 14:56:41 -0200
Message-Id: <1353949160-26803-112-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit e27947c767f5bed15048f4e4dad3e2eb69133697 upstream.

There is no state explicitly defined when a ceph connection is fully
operational.  So define one.

It's set when the connection sequence completes successfully, and is
cleared when the connection gets closed.

Be a little more careful when examining the old state when a socket
disconnect event is reported.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/messenger.h |    1 +
 net/ceph/messenger.c           |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index f624b75..6a00acc 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -120,6 +120,7 @@ struct ceph_msg_pos {
  */
 #define CONNECTING	1
 #define NEGOTIATING	2
+#define CONNECTED	5
 #define STANDBY		8  /* no outgoing messages, socket closed.  we keep
 			    * the ceph_connection around to maintain shared
 			    * state with the peer. */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 9e586ea..dc95437 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -463,6 +463,7 @@ void ceph_con_close(struct ceph_connection *con)
 	     ceph_pr_addr(&con->peer_addr.in_addr));
 	clear_bit(NEGOTIATING, &con->state);
 	clear_bit(CONNECTING, &con->state);
+	clear_bit(CONNECTED, &con->state);
 	clear_bit(STANDBY, &con->state);  /* avoid connect_seq bump */
 	set_bit(CLOSED, &con->state);
 
@@ -1564,6 +1565,7 @@ static int process_connect(struct ceph_connection *con)
 		}
 		clear_bit(NEGOTIATING, &con->state);
 		clear_bit(CONNECTING, &con->state);
+		set_bit(CONNECTED, &con->state);
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
 		con->peer_features = server_feat;
@@ -2114,6 +2116,7 @@ more:
 			prepare_read_ack(con);
 			break;
 		case CEPH_MSGR_TAG_CLOSE:
+			clear_bit(CONNECTED, &con->state);
 			set_bit(CLOSED, &con->state);   /* fixme */
 			goto out;
 		default:
@@ -2190,11 +2193,13 @@ static void con_work(struct work_struct *work)
 	mutex_lock(&con->mutex);
 restart:
 	if (test_and_clear_bit(SOCK_CLOSED, &con->flags)) {
-		if (test_and_clear_bit(CONNECTING, &con->state)) {
+		if (test_and_clear_bit(CONNECTED, &con->state))
+			con->error_msg = "socket closed";
+		else if (test_and_clear_bit(CONNECTING, &con->state)) {
 			clear_bit(NEGOTIATING, &con->state);
 			con->error_msg = "connection failed";
 		} else {
-			con->error_msg = "socket closed";
+			con->error_msg = "unrecognized con state";
 		}
 		goto fault;
 	}
-- 
1.7.9.5

