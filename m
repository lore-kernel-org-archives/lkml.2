Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2KVW3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:29:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:49010 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab2KVSdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 116/171] libceph: use con get/put methods
Date: Wed, 21 Nov 2012 16:41:02 -0800
Message-Id: <20121122004044.992562410@linuxfoundation.org>
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

(cherry picked from commit 36eb71aa57e6a33d61fd90a2fd87f00c6844bc86)

The ceph_con_get/put() helpers manipulate the embedded con ref
count, which isn't used now that ceph_connections are embedded in
other structures.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -414,7 +414,7 @@ static void ceph_msg_remove(struct ceph_
 {
 	list_del_init(&msg->list_head);
 	BUG_ON(msg->con == NULL);
-	ceph_con_put(msg->con);
+	msg->con->ops->put(msg->con);
 	msg->con = NULL;
 
 	ceph_msg_put(msg);
@@ -440,7 +440,7 @@ static void reset_connection(struct ceph
 		con->in_msg->con = NULL;
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
-		ceph_con_put(con);
+		con->ops->put(con);
 	}
 
 	con->connect_seq = 0;
@@ -1919,7 +1919,7 @@ static void process_message(struct ceph_
 	con->in_msg->con = NULL;
 	msg = con->in_msg;
 	con->in_msg = NULL;
-	ceph_con_put(con);
+	con->ops->put(con);
 
 	/* if first message, set peer_name */
 	if (con->peer_name.type == 0)
@@ -2281,7 +2281,7 @@ static void ceph_fault(struct ceph_conne
 		con->in_msg->con = NULL;
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
-		ceph_con_put(con);
+		con->ops->put(con);
 	}
 
 	/* Requeue anything that hasn't been acked */
@@ -2400,7 +2400,7 @@ void ceph_con_send(struct ceph_connectio
 	mutex_lock(&con->mutex);
 
 	BUG_ON(msg->con != NULL);
-	msg->con = ceph_con_get(con);
+	msg->con = con->ops->get(con);
 	BUG_ON(msg->con == NULL);
 
 	BUG_ON(!list_empty(&msg->list_head));
@@ -2436,7 +2436,7 @@ void ceph_msg_revoke(struct ceph_msg *ms
 		dout("%s %p msg %p - was on queue\n", __func__, con, msg);
 		list_del_init(&msg->list_head);
 		BUG_ON(msg->con == NULL);
-		ceph_con_put(msg->con);
+		msg->con->ops->put(msg->con);
 		msg->con = NULL;
 		msg->hdr.seq = 0;
 
@@ -2646,7 +2646,7 @@ static bool ceph_con_in_msg_alloc(struct
 		con->in_msg = con->ops->alloc_msg(con, hdr, &skip);
 		mutex_lock(&con->mutex);
 		if (con->in_msg) {
-			con->in_msg->con = ceph_con_get(con);
+			con->in_msg->con = con->ops->get(con);
 			BUG_ON(con->in_msg->con == NULL);
 		}
 		if (skip)
@@ -2662,7 +2662,7 @@ static bool ceph_con_in_msg_alloc(struct
 			       type, front_len);
 			return false;
 		}
-		con->in_msg->con = ceph_con_get(con);
+		con->in_msg->con = con->ops->get(con);
 		BUG_ON(con->in_msg->con == NULL);
 		con->in_msg->page_alignment = le16_to_cpu(hdr->data_off);
 	}


