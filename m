Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2KZSAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:00:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab2KZRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 097/270] libceph: use con get/put methods
Date: Mon, 26 Nov 2012 14:56:27 -0200
Message-Id: <1353949160-26803-98-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 36eb71aa57e6a33d61fd90a2fd87f00c6844bc86 upstream.

The ceph_con_get/put() helpers manipulate the embedded con ref
count, which isn't used now that ceph_connections are embedded in
other structures.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 0a6fdf8..ddb710c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -414,7 +414,7 @@ static void ceph_msg_remove(struct ceph_msg *msg)
 {
 	list_del_init(&msg->list_head);
 	BUG_ON(msg->con == NULL);
-	ceph_con_put(msg->con);
+	msg->con->ops->put(msg->con);
 	msg->con = NULL;
 
 	ceph_msg_put(msg);
@@ -440,7 +440,7 @@ static void reset_connection(struct ceph_connection *con)
 		con->in_msg->con = NULL;
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
-		ceph_con_put(con);
+		con->ops->put(con);
 	}
 
 	con->connect_seq = 0;
@@ -1919,7 +1919,7 @@ static void process_message(struct ceph_connection *con)
 	con->in_msg->con = NULL;
 	msg = con->in_msg;
 	con->in_msg = NULL;
-	ceph_con_put(con);
+	con->ops->put(con);
 
 	/* if first message, set peer_name */
 	if (con->peer_name.type == 0)
@@ -2281,7 +2281,7 @@ static void ceph_fault(struct ceph_connection *con)
 		con->in_msg->con = NULL;
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
-		ceph_con_put(con);
+		con->ops->put(con);
 	}
 
 	/* Requeue anything that hasn't been acked */
@@ -2400,7 +2400,7 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 	mutex_lock(&con->mutex);
 
 	BUG_ON(msg->con != NULL);
-	msg->con = ceph_con_get(con);
+	msg->con = con->ops->get(con);
 	BUG_ON(msg->con == NULL);
 
 	BUG_ON(!list_empty(&msg->list_head));
@@ -2436,7 +2436,7 @@ void ceph_msg_revoke(struct ceph_msg *msg)
 		dout("%s %p msg %p - was on queue\n", __func__, con, msg);
 		list_del_init(&msg->list_head);
 		BUG_ON(msg->con == NULL);
-		ceph_con_put(msg->con);
+		msg->con->ops->put(msg->con);
 		msg->con = NULL;
 		msg->hdr.seq = 0;
 
@@ -2646,7 +2646,7 @@ static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
 		con->in_msg = con->ops->alloc_msg(con, hdr, &skip);
 		mutex_lock(&con->mutex);
 		if (con->in_msg) {
-			con->in_msg->con = ceph_con_get(con);
+			con->in_msg->con = con->ops->get(con);
 			BUG_ON(con->in_msg->con == NULL);
 		}
 		if (skip)
@@ -2662,7 +2662,7 @@ static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
 			       type, front_len);
 			return false;
 		}
-		con->in_msg->con = ceph_con_get(con);
+		con->in_msg->con = con->ops->get(con);
 		BUG_ON(con->in_msg->con == NULL);
 		con->in_msg->page_alignment = le16_to_cpu(hdr->data_off);
 	}
-- 
1.7.9.5

