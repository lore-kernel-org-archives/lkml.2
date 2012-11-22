Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab2KVVhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:37:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:49608 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab2KVSk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 129/171] libceph: clear NEGOTIATING when done
Date: Wed, 21 Nov 2012 16:41:15 -0800
Message-Id: <20121122004046.292596312@linuxfoundation.org>
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

(cherry picked from commit 3ec50d1868a9e0493046400bb1fdd054c7f64ebd)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1562,6 +1562,7 @@ static int process_connect(struct ceph_c
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
@@ -2190,10 +2190,12 @@ static void con_work(struct work_struct
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
 


