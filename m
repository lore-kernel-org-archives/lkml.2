Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2KZSCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:02:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47435 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab2KZRFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 089/270] libceph: have messages take a connection reference
Date: Mon, 26 Nov 2012 14:56:19 -0200
Message-Id: <1353949160-26803-90-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 92ce034b5a740046cc643a21ea21eaad589e0043 upstream.

There are essentially two types of ceph messages: incoming and
outgoing.  Outgoing messages are always allocated via ceph_msg_new(),
and at the time of their allocation they are not associated with any
particular connection.  Incoming messages are always allocated via
ceph_con_in_msg_alloc(), and they are initially associated with the
connection from which incoming data will be placed into the message.

When an outgoing message gets sent, it becomes associated with a
connection and remains that way until the message is successfully
sent.  The association of an incoming message goes away at the point
it is sent to an upper layer via a con->ops->dispatch method.

This patch implements reference counting for all ceph messages, such
that every message holds a reference (and a pointer) to a connection
if and only if it is associated with that connection (as described
above).

For background, here is an explanation of the ceph message
lifecycle, emphasizing when an association exists between a message
and a connection.

Outgoing Messages
An outgoing message is "owned" by its allocator, from the time it is
allocated in ceph_msg_new() up to the point it gets queued for
sending in ceph_con_send().  Prior to that point the message's
msg->con pointer is null; at the point it is queued for sending its
message pointer is assigned to refer to the connection.  At that
time the message is inserted into a connection's out_queue list.

When a message on the out_queue list has been sent to the socket
layer to be put on the wire, it is transferred out of that list and
into the connection's out_sent list.  At that point it is still owned
by the connection, and will remain so until an acknowledgement is
received from the recipient that indicates the message was
successfully transferred.  When such an acknowledgement is received
(in process_ack()), the message is removed from its list (in
ceph_msg_remove()), at which point it is no longer associated with
the connection.

So basically, any time a message is on one of a connection's lists,
it is associated with that connection.  Reference counting outgoing
messages can thus be done at the points a message is added to the
out_queue (in ceph_con_send()) and the point it is removed from
either its two lists (in ceph_msg_remove())--at which point its
connection pointer becomes null.

Incoming Messages
When an incoming message on a connection is getting read (in
read_partial_message()) and there is no message in con->in_msg,
a new one is allocated using ceph_con_in_msg_alloc().  At that
point the message is associated with the connection.  Once that
message has been completely and successfully read, it is passed to
upper layer code using the connection's con->ops->dispatch method.
At that point the association between the message and the connection
no longer exists.

Reference counting of connections for incoming messages can be done
by taking a reference to the connection when the message gets
allocated, and releasing that reference when it gets handed off
using the dispatch method.

We should never fail to get a connection reference for a
message--the since the caller should already hold one.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index dc88846..964a8c3 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -415,6 +415,7 @@ static void ceph_msg_remove(struct ceph_msg *msg)
 {
 	list_del_init(&msg->list_head);
 	BUG_ON(msg->con == NULL);
+	ceph_con_put(msg->con);
 	msg->con = NULL;
 
 	ceph_msg_put(msg);
@@ -440,6 +441,7 @@ static void reset_connection(struct ceph_connection *con)
 		con->in_msg->con = NULL;
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
+		ceph_con_put(con->in_msg->con);
 	}
 
 	con->connect_seq = 0;
@@ -1918,6 +1920,7 @@ static void process_message(struct ceph_connection *con)
 	con->in_msg->con = NULL;
 	msg = con->in_msg;
 	con->in_msg = NULL;
+	ceph_con_put(con);
 
 	/* if first message, set peer_name */
 	if (con->peer_name.type == 0)
@@ -2279,6 +2282,7 @@ static void ceph_fault(struct ceph_connection *con)
 		con->in_msg->con = NULL;
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
+		ceph_con_put(con);
 	}
 
 	/* Requeue anything that hasn't been acked */
@@ -2395,8 +2399,11 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 
 	/* queue */
 	mutex_lock(&con->mutex);
+
 	BUG_ON(msg->con != NULL);
-	msg->con = con;
+	msg->con = ceph_con_get(con);
+	BUG_ON(msg->con == NULL);
+
 	BUG_ON(!list_empty(&msg->list_head));
 	list_add_tail(&msg->list_head, &con->out_queue);
 	dout("----- %p to %s%lld %d=%s len %d+%d+%d -----\n", msg,
@@ -2425,10 +2432,11 @@ void ceph_con_revoke(struct ceph_connection *con, struct ceph_msg *msg)
 		dout("%s %p msg %p - was on queue\n", __func__, con, msg);
 		list_del_init(&msg->list_head);
 		BUG_ON(msg->con == NULL);
+		ceph_con_put(msg->con);
 		msg->con = NULL;
+		msg->hdr.seq = 0;
 
 		ceph_msg_put(msg);
-		msg->hdr.seq = 0;
 	}
 	if (con->out_msg == msg) {
 		dout("%s %p msg %p - was sending\n", __func__, con, msg);
@@ -2437,8 +2445,9 @@ void ceph_con_revoke(struct ceph_connection *con, struct ceph_msg *msg)
 			con->out_skip = con->out_kvec_bytes;
 			con->out_kvec_is_msg = false;
 		}
-		ceph_msg_put(msg);
 		msg->hdr.seq = 0;
+
+		ceph_msg_put(msg);
 	}
 	mutex_unlock(&con->mutex);
 }
@@ -2622,8 +2631,10 @@ static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
 		mutex_unlock(&con->mutex);
 		con->in_msg = con->ops->alloc_msg(con, hdr, &skip);
 		mutex_lock(&con->mutex);
-		if (con->in_msg)
-			con->in_msg->con = con;
+		if (con->in_msg) {
+			con->in_msg->con = ceph_con_get(con);
+			BUG_ON(con->in_msg->con == NULL);
+		}
 		if (skip)
 			con->in_msg = NULL;
 
@@ -2637,7 +2648,8 @@ static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
 			       type, front_len);
 			return false;
 		}
-		con->in_msg->con = con;
+		con->in_msg->con = ceph_con_get(con);
+		BUG_ON(con->in_msg->con == NULL);
 		con->in_msg->page_alignment = le16_to_cpu(hdr->data_off);
 	}
 	memcpy(&con->in_msg->hdr, &con->in_hdr, sizeof(con->in_hdr));
-- 
1.7.9.5

