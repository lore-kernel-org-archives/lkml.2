Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3AHXpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:45:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:63988 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab3AHXjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:39:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Graf <tgraf@infradead.org>, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 64/77] sctp: Enforce retransmission limit during shutdown
Date: Tue, 8 Jan 2013 18:35:43 -0500
Message-ID: <1357688156-25387-65-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@infradead.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f8d9605243280f1870dd2c6c37a735b925c15f3c upstream.

When initiating a graceful shutdown while having data chunks
on the retransmission queue with a peer which is in zero
window mode the shutdown is never completed because the
retransmission error count is reset periodically by the
following two rules:

 - Do not timeout association while doing zero window probe.
 - Reset overall error count when a heartbeat request has
   been acknowledged.

The graceful shutdown will wait for all outstanding TSN to
be acknowledged before sending the SHUTDOWN request. This
never happens due to the peer's zero window not acknowledging
the continuously retransmitted data chunks. Although the
error counter is incremented for each failed retransmission,
the receiving of the SACK announcing the zero window clears
the error count again immediately. Also heartbeat requests
continue to be sent periodically. The peer acknowledges these
requests causing the error counter to be reset as well.

This patch changes behaviour to only reset the overall error
counter for the above rules while not in shutdown. After
reaching the maximum number of retransmission attempts, the
T5 shutdown guard timer is scheduled to give the receiver
some additional time to recover. The timer is stopped as soon
as the receiver acknowledges any data.

The issue can be easily reproduced by establishing a sctp
association over the loopback device, constantly queueing
data at the sender while not reading any at the receiver.
Wait for the window to reach zero, then initiate a shutdown
by killing both processes simultaneously. The association
will never be freed and the chunks on the retransmission
queue will be retransmitted indefinitely.

Signed-off-by: Thomas Graf <tgraf@infradead.org>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/sctp/command.h |  1 +
 net/sctp/outqueue.c        | 20 +++++++++++++++++++-
 net/sctp/sm_sideeffect.c   | 20 ++++++++++++++++++--
 net/sctp/sm_statefuns.c    | 32 +++++++++++++++++++++++---------
 net/sctp/sm_statetable.c   |  2 +-
 5 files changed, 62 insertions(+), 13 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 2c55a7e..d4699d8 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -63,6 +63,7 @@ typedef enum {
 	SCTP_CMD_ECN_ECNE,	/* Do delayed ECNE processing. */
 	SCTP_CMD_ECN_CWR,	/* Do delayed CWR processing.  */
 	SCTP_CMD_TIMER_START,	/* Start a timer.  */
+	SCTP_CMD_TIMER_START_ONCE, /* Start a timer once */
 	SCTP_CMD_TIMER_RESTART,	/* Restart a timer. */
 	SCTP_CMD_TIMER_STOP,	/* Stop a timer. */
 	SCTP_CMD_INIT_CHOOSE_TRANSPORT, /* Choose transport for an INIT. */
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index abfc0b8..54e20e3 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1587,6 +1587,8 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 #endif /* SCTP_DEBUG */
 	if (transport) {
 		if (bytes_acked) {
+			struct sctp_association *asoc = transport->asoc;
+
 			/* We may have counted DATA that was migrated
 			 * to this transport due to DEL-IP operation.
 			 * Subtract those bytes, since the were never
@@ -1605,6 +1607,17 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 			transport->error_count = 0;
 			transport->asoc->overall_error_count = 0;
 
+			/*
+			 * While in SHUTDOWN PENDING, we may have started
+			 * the T5 shutdown guard timer after reaching the
+			 * retransmission limit. Stop that timer as soon
+			 * as the receiver acknowledged any data.
+			 */
+			if (asoc->state == SCTP_STATE_SHUTDOWN_PENDING &&
+			    del_timer(&asoc->timers
+				[SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD]))
+					sctp_association_put(asoc);
+
 			/* Mark the destination transport address as
 			 * active if it is not so marked.
 			 */
@@ -1634,10 +1647,15 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 			 * A sender is doing zero window probing when the
 			 * receiver's advertised window is zero, and there is
 			 * only one data chunk in flight to the receiver.
+			 *
+			 * Allow the association to timeout while in SHUTDOWN
+			 * PENDING or SHUTDOWN RECEIVED in case the receiver
+			 * stays in zero window mode forever.
 			 */
 			if (!q->asoc->peer.rwnd &&
 			    !list_empty(&tlist) &&
-			    (sack_ctsn+2 == q->asoc->next_tsn)) {
+			    (sack_ctsn+2 == q->asoc->next_tsn) &&
+			    q->asoc->state < SCTP_STATE_SHUTDOWN_PENDING) {
 				SCTP_DEBUG_PRINTK("%s: SACK received for zero "
 						  "window probe: %u\n",
 						  __func__, sack_ctsn);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index eb1f42f..c4cb6b8 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -669,10 +669,19 @@ static void sctp_cmd_transport_on(sctp_cmd_seq_t *cmds,
 	/* 8.3 Upon the receipt of the HEARTBEAT ACK, the sender of the
 	 * HEARTBEAT should clear the error counter of the destination
 	 * transport address to which the HEARTBEAT was sent.
-	 * The association's overall error count is also cleared.
 	 */
 	t->error_count = 0;
-	t->asoc->overall_error_count = 0;
+
+	/*
+	 * Although RFC4960 specifies that the overall error count must
+	 * be cleared when a HEARTBEAT ACK is received, we make an
+	 * exception while in SHUTDOWN PENDING. If the peer keeps its
+	 * window shut forever, we may never be able to transmit our
+	 * outstanding data and rely on the retransmission limit be reached
+	 * to shutdown the association.
+	 */
+	if (t->asoc->state != SCTP_STATE_SHUTDOWN_PENDING)
+		t->asoc->overall_error_count = 0;
 
 	/* Clear the hb_sent flag to signal that we had a good
 	 * acknowledgement.
@@ -1445,6 +1454,13 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 			sctp_cmd_setup_t2(commands, asoc, cmd->obj.ptr);
 			break;
 
+		case SCTP_CMD_TIMER_START_ONCE:
+			timer = &asoc->timers[cmd->obj.to];
+
+			if (timer_pending(timer))
+				break;
+			/* fall through */
+
 		case SCTP_CMD_TIMER_START:
 			timer = &asoc->timers[cmd->obj.to];
 			timeout = asoc->timeouts[cmd->obj.to];
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 24b2cd5..bbfb644 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -5099,7 +5099,7 @@ sctp_disposition_t sctp_sf_do_9_2_start_shutdown(
 	 * The sender of the SHUTDOWN MAY also start an overall guard timer
 	 * 'T5-shutdown-guard' to bound the overall time for shutdown sequence.
 	 */
-	sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_START,
+	sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_RESTART,
 			SCTP_TO(SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD));
 
 	if (asoc->autoclose)
@@ -5244,14 +5244,28 @@ sctp_disposition_t sctp_sf_do_6_3_3_rtx(const struct sctp_endpoint *ep,
 	SCTP_INC_STATS(SCTP_MIB_T3_RTX_EXPIREDS);
 
 	if (asoc->overall_error_count >= asoc->max_retrans) {
-		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
-				SCTP_ERROR(ETIMEDOUT));
-		/* CMD_ASSOC_FAILED calls CMD_DELETE_TCB. */
-		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
-				SCTP_PERR(SCTP_ERROR_NO_ERROR));
-		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
-		return SCTP_DISPOSITION_DELETE_TCB;
+		if (asoc->state == SCTP_STATE_SHUTDOWN_PENDING) {
+			/*
+			 * We are here likely because the receiver had its rwnd
+			 * closed for a while and we have not been able to
+			 * transmit the locally queued data within the maximum
+			 * retransmission attempts limit.  Start the T5
+			 * shutdown guard timer to give the receiver one last
+			 * chance and some additional time to recover before
+			 * aborting.
+			 */
+			sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_START_ONCE,
+				SCTP_TO(SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD));
+		} else {
+			sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
+					SCTP_ERROR(ETIMEDOUT));
+			/* CMD_ASSOC_FAILED calls CMD_DELETE_TCB. */
+			sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
+					SCTP_PERR(SCTP_ERROR_NO_ERROR));
+			SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
+			SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
+			return SCTP_DISPOSITION_DELETE_TCB;
+		}
 	}
 
 	/* E1) For the destination address for which the timer
diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 6d9b3aa..d41d527 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -897,7 +897,7 @@ static const sctp_sm_table_entry_t other_event_table[SCTP_NUM_OTHER_TYPES][SCTP_
 	/* SCTP_STATE_ESTABLISHED */ \
 	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
 	/* SCTP_STATE_SHUTDOWN_PENDING */ \
-	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	TYPE_SCTP_FUNC(sctp_sf_t5_timer_expire), \
 	/* SCTP_STATE_SHUTDOWN_SENT */ \
 	TYPE_SCTP_FUNC(sctp_sf_t5_timer_expire), \
 	/* SCTP_STATE_SHUTDOWN_RECEIVED */ \
-- 
1.7.12.1

