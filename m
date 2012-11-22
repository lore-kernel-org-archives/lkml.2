Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2KVVTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:19:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:49643 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab2KVSkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 087/171] libceph: fix messenger retry
Date: Wed, 21 Nov 2012 16:40:33 -0800
Message-Id: <20121122004042.103195068@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit 5bdca4e0768d3e0f4efa43d9a2cc8210aeb91ab9)

In ancient times, the messenger could both initiate and accept connections.
An artifact if that was data structures to store/process an incoming
ceph_msg_connect request and send an outgoing ceph_msg_connect_reply.
Sadly, the negotiation code was referencing those structures and ignoring
important information (like the peer's connect_seq) from the correct ones.

Among other things, this fixes tight reconnect loops where the server sends
RETRY_SESSION and we (the client) retries with the same connect_seq as last
time.  This bug pretty easily triggered by injecting socket failures on the
MDS and running some fs workload like workunits/direct_io/test_sync_io.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ceph/messenger.h |   12 ++----------
 net/ceph/messenger.c           |   12 ++++++------
 2 files changed, 8 insertions(+), 16 deletions(-)

--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -163,16 +163,8 @@ struct ceph_connection {
 
 	/* connection negotiation temps */
 	char in_banner[CEPH_BANNER_MAX_LEN];
-	union {
-		struct {  /* outgoing connection */
-			struct ceph_msg_connect out_connect;
-			struct ceph_msg_connect_reply in_reply;
-		};
-		struct {  /* incoming */
-			struct ceph_msg_connect in_connect;
-			struct ceph_msg_connect_reply out_reply;
-		};
-	};
+	struct ceph_msg_connect out_connect;
+	struct ceph_msg_connect_reply in_reply;
 	struct ceph_entity_addr actual_peer_addr;
 
 	/* message out temps */
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1423,7 +1423,7 @@ static int process_connect(struct ceph_c
 		 * dropped messages.
 		 */
 		dout("process_connect got RESET peer seq %u\n",
-		     le32_to_cpu(con->in_connect.connect_seq));
+		     le32_to_cpu(con->in_reply.connect_seq));
 		pr_err("%s%lld %s connection reset\n",
 		       ENTITY_NAME(con->peer_name),
 		       ceph_pr_addr(&con->peer_addr.in_addr));
@@ -1450,10 +1450,10 @@ static int process_connect(struct ceph_c
 		 * If we sent a smaller connect_seq than the peer has, try
 		 * again with a larger value.
 		 */
-		dout("process_connect got RETRY my seq = %u, peer_seq = %u\n",
+		dout("process_connect got RETRY_SESSION my seq %u, peer %u\n",
 		     le32_to_cpu(con->out_connect.connect_seq),
-		     le32_to_cpu(con->in_connect.connect_seq));
-		con->connect_seq = le32_to_cpu(con->in_connect.connect_seq);
+		     le32_to_cpu(con->in_reply.connect_seq));
+		con->connect_seq = le32_to_cpu(con->in_reply.connect_seq);
 		ceph_con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
@@ -1468,9 +1468,9 @@ static int process_connect(struct ceph_c
 		 */
 		dout("process_connect got RETRY_GLOBAL my %u peer_gseq %u\n",
 		     con->peer_global_seq,
-		     le32_to_cpu(con->in_connect.global_seq));
+		     le32_to_cpu(con->in_reply.global_seq));
 		get_global_seq(con->msgr,
-			       le32_to_cpu(con->in_connect.global_seq));
+			       le32_to_cpu(con->in_reply.global_seq));
 		ceph_con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)


