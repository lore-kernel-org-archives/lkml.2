Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab2KZRFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:05:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47431 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab2KZRFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 088/270] libceph: have messages point to their connection
Date: Mon, 26 Nov 2012 14:56:18 -0200
Message-Id: <1353949160-26803-89-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 38941f8031bf042dba3ced6394ba3a3b16c244ea upstream.

When a ceph message is queued for sending it is placed on a list of
pending messages (ceph_connection->out_queue).  When they are
actually sent over the wire, they are moved from that list to
another (ceph_connection->out_sent).  When acknowledgement for the
message is received, it is removed from the sent messages list.

During that entire time the message is "in the possession" of a
single ceph connection.  Keep track of that connection in the
message.  This will be used in the next patch (and is a helpful
bit of information for debugging anyway).

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/messenger.h |    3 +++
 net/ceph/messenger.c           |   27 +++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 7ed7a87..7d48ffc 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -77,7 +77,10 @@ struct ceph_msg {
 	unsigned nr_pages;              /* size of page array */
 	unsigned page_alignment;        /* io offset in first page */
 	struct ceph_pagelist *pagelist; /* instead of pages */
+
+	struct ceph_connection *con;
 	struct list_head list_head;
+
 	struct kref kref;
 	struct bio  *bio;		/* instead of pages/pagelist */
 	struct bio  *bio_iter;		/* bio iterator */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 9e12806..dc88846 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -414,6 +414,9 @@ static int con_close_socket(struct ceph_connection *con)
 static void ceph_msg_remove(struct ceph_msg *msg)
 {
 	list_del_init(&msg->list_head);
+	BUG_ON(msg->con == NULL);
+	msg->con = NULL;
+
 	ceph_msg_put(msg);
 }
 static void ceph_msg_remove_list(struct list_head *head)
@@ -433,6 +436,8 @@ static void reset_connection(struct ceph_connection *con)
 	ceph_msg_remove_list(&con->out_sent);
 
 	if (con->in_msg) {
+		BUG_ON(con->in_msg->con != con);
+		con->in_msg->con = NULL;
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
 	}
@@ -625,8 +630,10 @@ static void prepare_write_message(struct ceph_connection *con)
 			&con->out_temp_ack);
 	}
 
+	BUG_ON(list_empty(&con->out_queue));
 	m = list_first_entry(&con->out_queue, struct ceph_msg, list_head);
 	con->out_msg = m;
+	BUG_ON(m->con != con);
 
 	/* put message on sent list */
 	ceph_msg_get(m);
@@ -1810,6 +1817,8 @@ static int read_partial_message(struct ceph_connection *con)
 				"error allocating memory for incoming message";
 			return -ENOMEM;
 		}
+
+		BUG_ON(con->in_msg->con != con);
 		m = con->in_msg;
 		m->front.iov_len = 0;    /* haven't read it yet */
 		if (m->middle)
@@ -1905,6 +1914,8 @@ static void process_message(struct ceph_connection *con)
 {
 	struct ceph_msg *msg;
 
+	BUG_ON(con->in_msg->con != con);
+	con->in_msg->con = NULL;
 	msg = con->in_msg;
 	con->in_msg = NULL;
 
@@ -2264,6 +2275,8 @@ static void ceph_fault(struct ceph_connection *con)
 	con_close_socket(con);
 
 	if (con->in_msg) {
+		BUG_ON(con->in_msg->con != con);
+		con->in_msg->con = NULL;
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
 	}
@@ -2382,6 +2395,8 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 
 	/* queue */
 	mutex_lock(&con->mutex);
+	BUG_ON(msg->con != NULL);
+	msg->con = con;
 	BUG_ON(!list_empty(&msg->list_head));
 	list_add_tail(&msg->list_head, &con->out_queue);
 	dout("----- %p to %s%lld %d=%s len %d+%d+%d -----\n", msg,
@@ -2407,13 +2422,16 @@ void ceph_con_revoke(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	mutex_lock(&con->mutex);
 	if (!list_empty(&msg->list_head)) {
-		dout("con_revoke %p msg %p - was on queue\n", con, msg);
+		dout("%s %p msg %p - was on queue\n", __func__, con, msg);
 		list_del_init(&msg->list_head);
+		BUG_ON(msg->con == NULL);
+		msg->con = NULL;
+
 		ceph_msg_put(msg);
 		msg->hdr.seq = 0;
 	}
 	if (con->out_msg == msg) {
-		dout("con_revoke %p msg %p - was sending\n", con, msg);
+		dout("%s %p msg %p - was sending\n", __func__, con, msg);
 		con->out_msg = NULL;
 		if (con->out_kvec_is_msg) {
 			con->out_skip = con->out_kvec_bytes;
@@ -2482,6 +2500,8 @@ struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags,
 	if (m == NULL)
 		goto out;
 	kref_init(&m->kref);
+
+	m->con = NULL;
 	INIT_LIST_HEAD(&m->list_head);
 
 	m->hdr.tid = 0;
@@ -2602,6 +2622,8 @@ static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
 		mutex_unlock(&con->mutex);
 		con->in_msg = con->ops->alloc_msg(con, hdr, &skip);
 		mutex_lock(&con->mutex);
+		if (con->in_msg)
+			con->in_msg->con = con;
 		if (skip)
 			con->in_msg = NULL;
 
@@ -2615,6 +2637,7 @@ static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
 			       type, front_len);
 			return false;
 		}
+		con->in_msg->con = con;
 		con->in_msg->page_alignment = le16_to_cpu(hdr->data_off);
 	}
 	memcpy(&con->in_msg->hdr, &con->in_hdr, sizeof(con->in_hdr));
-- 
1.7.9.5

