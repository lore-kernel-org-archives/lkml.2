Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2KNFuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55180 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341Ab2KNFut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:49 -0500
Message-Id: <20121114053940.926046549@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:24 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 51/82] iscsi-target: Fix missed wakeup race in TX thread
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit d5627acba9ae584cf4928af19f7ddf5f6837de32 upstream.

The sleeping code in iscsi_target_tx_thread() is susceptible to the classic
missed wakeup race:

 - TX thread finishes handle_immediate_queue() and handle_response_queue(),
   thinks both queues are empty.
 - Another thread adds a queue entry and does wake_up_process(), which does
   nothing because the TX thread is still awake.
 - TX thread does schedule_timeout() and sleeps forever.

In practice this can kill an iSCSI connection if for example an initiator
does single-threaded writes and the target misses the wakeup window when
queueing an R2T; in this case the connection will be stuck until the
initiator loses patience and does some task management operation (or kills
the connection entirely).

Fix this by converting to wait_event_interruptible(), which does not
suffer from this sort of race.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Cc: Andy Grover <agrover@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target.c       |    4 +++-
 drivers/target/iscsi/iscsi_target_core.h  |    1 +
 drivers/target/iscsi/iscsi_target_login.c |    1 +
 drivers/target/iscsi/iscsi_target_util.c  |   22 ++++++++++++++++++++--
 drivers/target/iscsi/iscsi_target_util.h  |    1 +
 5 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d6ce218..035c2c7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3719,7 +3719,9 @@ restart:
 		 */
 		iscsit_thread_check_cpumask(conn, current, 1);
 
-		schedule_timeout_interruptible(MAX_SCHEDULE_TIMEOUT);
+		wait_event_interruptible(conn->queues_wq,
+					 !iscsit_conn_all_queues_empty(conn) ||
+					 ts->status == ISCSI_THREAD_SET_RESET);
 
 		if ((ts->status == ISCSI_THREAD_SET_RESET) ||
 		     signal_pending(current))
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 2ba9f9b..21048db 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -486,6 +486,7 @@ struct iscsi_tmr_req {
 };
 
 struct iscsi_conn {
+	wait_queue_head_t	queues_wq;
 	/* Authentication Successful for this connection */
 	u8			auth_complete;
 	/* State connection is currently in */
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index cdc8a10..f8dbec0 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -41,6 +41,7 @@
 
 static int iscsi_login_init_conn(struct iscsi_conn *conn)
 {
+	init_waitqueue_head(&conn->queues_wq);
 	INIT_LIST_HEAD(&conn->conn_list);
 	INIT_LIST_HEAD(&conn->conn_cmd_list);
 	INIT_LIST_HEAD(&conn->immed_queue_list);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index afd98cc..1a91195 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -488,7 +488,7 @@ void iscsit_add_cmd_to_immediate_queue(
 	atomic_set(&conn->check_immediate_queue, 1);
 	spin_unlock_bh(&conn->immed_queue_lock);
 
-	wake_up_process(conn->thread_set->tx_thread);
+	wake_up(&conn->queues_wq);
 }
 
 struct iscsi_queue_req *iscsit_get_cmd_from_immediate_queue(struct iscsi_conn *conn)
@@ -562,7 +562,7 @@ void iscsit_add_cmd_to_response_queue(
 	atomic_inc(&cmd->response_queue_count);
 	spin_unlock_bh(&conn->response_queue_lock);
 
-	wake_up_process(conn->thread_set->tx_thread);
+	wake_up(&conn->queues_wq);
 }
 
 struct iscsi_queue_req *iscsit_get_cmd_from_response_queue(struct iscsi_conn *conn)
@@ -616,6 +616,24 @@ static void iscsit_remove_cmd_from_response_queue(
 	}
 }
 
+bool iscsit_conn_all_queues_empty(struct iscsi_conn *conn)
+{
+	bool empty;
+
+	spin_lock_bh(&conn->immed_queue_lock);
+	empty = list_empty(&conn->immed_queue_list);
+	spin_unlock_bh(&conn->immed_queue_lock);
+
+	if (!empty)
+		return empty;
+
+	spin_lock_bh(&conn->response_queue_lock);
+	empty = list_empty(&conn->response_queue_list);
+	spin_unlock_bh(&conn->response_queue_lock);
+
+	return empty;
+}
+
 void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *conn)
 {
 	struct iscsi_queue_req *qr, *qr_tmp;
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 44054bd..894d0f8 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -25,6 +25,7 @@ extern struct iscsi_queue_req *iscsit_get_cmd_from_immediate_queue(struct iscsi_
 extern void iscsit_add_cmd_to_response_queue(struct iscsi_cmd *, struct iscsi_conn *, u8);
 extern struct iscsi_queue_req *iscsit_get_cmd_from_response_queue(struct iscsi_conn *);
 extern void iscsit_remove_cmd_from_tx_queues(struct iscsi_cmd *, struct iscsi_conn *);
+extern bool iscsit_conn_all_queues_empty(struct iscsi_conn *);
 extern void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *);
 extern void iscsit_release_cmd(struct iscsi_cmd *);
 extern void iscsit_free_cmd(struct iscsi_cmd *);


