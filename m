Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab2KVWeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:34:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:49007 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab2KVSdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 130/171] libceph: define and use an explicit CONNECTED state
Date: Wed, 21 Nov 2012 16:41:16 -0800
Message-Id: <20121122004046.409705330@linuxfoundation.org>
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

(cherry picked from commit e27947c767f5bed15048f4e4dad3e2eb69133697)

There is no state explicitly defined when a ceph connection is fully
operational.  So define one.

It's set when the connection sequence completes successfully, and is
cleared when the connection gets closed.

Be a little more careful when examining the old state when a socket
disconnect event is reported.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ceph/messenger.h |    1 +
 net/ceph/messenger.c           |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

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
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -463,6 +463,7 @@ void ceph_con_close(struct ceph_connecti
 	     ceph_pr_addr(&con->peer_addr.in_addr));
 	clear_bit(NEGOTIATING, &con->state);
 	clear_bit(CONNECTING, &con->state);
+	clear_bit(CONNECTED, &con->state);
 	clear_bit(STANDBY, &con->state);  /* avoid connect_seq bump */
 	set_bit(CLOSED, &con->state);
 
@@ -1564,6 +1565,7 @@ static int process_connect(struct ceph_c
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
@@ -2190,11 +2193,13 @@ static void con_work(struct work_struct
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


