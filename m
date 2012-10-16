Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2JPQiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:38:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56957 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab2JPQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:38:11 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/4] staging: csr: Fixed exceeding 80 chars per line on mlme.c
Date: Wed, 17 Oct 2012 01:36:46 +0900
Message-Id: <1350405408-2702-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350405408-2702-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350405408-2702-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed most of the exceeding 80 chars on mlme.c

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/mlme.c |  200 ++++++++++++++++++++++++--------------------
 1 file changed, 107 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/csr/mlme.c b/drivers/staging/csr/mlme.c
index a16841f..dba12b2 100644
--- a/drivers/staging/csr/mlme.c
+++ b/drivers/staging/csr/mlme.c
@@ -37,7 +37,8 @@
  *	  These two number match be equal.
  *	  Should only be used for waiting xxx.cfm signals and only after
  *	  we have sent the matching xxx.req signal to UniFi.
- *	  If no response is received within the expected time (timeout), we assume
+ *	  If no response is received within the expected time (timeout),
+ *	  we assume
  *	  that the UniFi is busy and return an error.
  *	  If the wait is aborted by a kernel signal arriving, we stop waiting.
  *	  If a response from UniFi is not what we expected, we discard it and
@@ -47,7 +48,8 @@
  * ---------------------------------------------------------------------------
  */
 static int
-unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli, int sig_reply_id, int timeout)
+unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli,
+	int sig_reply_id, int timeout)
 {
 	int retries = 0;
 	long r;
@@ -60,8 +62,7 @@ unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli, int sig_reply_i
 	do {
 		/* Wait for the confirm or timeout. */
 		r = wait_event_interruptible_timeout(pcli->udi_wq,
-											 (pcli->wake_up_wq_id) || (priv->io_aborted == 1),
-											 t);
+			(pcli->wake_up_wq_id) || (priv->io_aborted == 1), t);
 		/* Check for general i/o error */
 		if (priv->io_aborted) {
 			unifi_error(priv, "MLME operation aborted\n");
@@ -71,28 +72,33 @@ unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli, int sig_reply_i
 		/*
 		 * If r=0 the request has timed-out.
 		 * If r>0 the request has completed successfully.
-		 * If r=-ERESTARTSYS an event (kill signal) has interrupted the wait_event.
+		 * If r=-ERESTARTSYS an event (kill signal)
+		 * has interrupted the wait_event.
 		 */
 		if ((r == 0) && (pcli->wake_up_wq_id == 0)) {
 			unifi_error(priv, "mlme_wait: timed-out waiting for 0x%.4X, after %lu msec.\n",
-						sig_reply_id,  jiffies_to_msecs(t));
+				sig_reply_id,  jiffies_to_msecs(t));
 			pcli->wake_up_wq_id = 0;
 			return -ETIMEDOUT;
 		} else if (r == -ERESTARTSYS) {
-			unifi_error(priv, "mlme_wait: waiting for 0x%.4X was aborted.\n", sig_reply_id);
+			unifi_error(priv,
+			"mlme_wait: waiting for 0x%.4X was aborted.\n",
+			sig_reply_id);
 			pcli->wake_up_wq_id = 0;
 			return -EINTR;
 		} else {
-			/* Get the sequence number of the signal that we previously set. */
+			/* Get the sequence number of the signal
+			 * that we previously set. */
 			if (pcli->seq_no != 0) {
 				sent_seq_no = pcli->seq_no - 1;
 			} else {
 				sent_seq_no = 0x0F;
 			}
 
-			unifi_trace(priv, UDBG5, "Received 0x%.4X, seq: (r:%d, s:%d)\n",
-						pcli->wake_up_wq_id,
-						pcli->wake_seq_no, sent_seq_no);
+			unifi_trace(priv, UDBG5,
+				"Received 0x%.4X, seq: (r:%d, s:%d)\n",
+				pcli->wake_up_wq_id,
+				pcli->wake_seq_no, sent_seq_no);
 
 			/* The two sequence ids must match. */
 			if (pcli->wake_seq_no == sent_seq_no) {
@@ -103,9 +109,9 @@ unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli, int sig_reply_i
 				} else {
 					/* This should never happen ... */
 					unifi_error(priv, "mlme_wait: mismatching signal id (0x%.4X - exp 0x%.4X) (seq %d)\n",
-								pcli->wake_up_wq_id,
-								sig_reply_id,
-								pcli->wake_seq_no);
+						pcli->wake_up_wq_id,
+						sig_reply_id,
+						pcli->wake_seq_no);
 					pcli->wake_up_wq_id = 0;
 					return -EIO;
 				}
@@ -116,8 +122,7 @@ unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli, int sig_reply_i
 			retries ++;
 			if (retries >= 3) {
 				unifi_error(priv, "mlme_wait: confirm wait retries exhausted (0x%.4X - exp 0x%.4X)\n",
-							pcli->wake_up_wq_id,
-							sig_reply_id);
+					pcli->wake_up_wq_id, sig_reply_id);
 				pcli->wake_up_wq_id = 0;
 				return -EIO;
 			}
@@ -149,23 +154,24 @@ unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli, int sig_reply_i
  */
 int
 unifi_mlme_blocking_request(unifi_priv_t *priv, ul_client_t *pcli,
-							CSR_SIGNAL *sig, bulk_data_param_t *data_ptrs,
-							int timeout)
+	CSR_SIGNAL *sig, bulk_data_param_t *data_ptrs, int timeout)
 {
 	int r;
 
 	func_enter();
 
 	if (sig->SignalPrimitiveHeader.SignalId == 0) {
-		unifi_error(priv, "unifi_mlme_blocking_request: Invalid Signal Id (0x%x)\n",
-					sig->SignalPrimitiveHeader.SignalId);
+		unifi_error(priv,
+		"unifi_mlme_blocking_request: Invalid Signal Id (0x%x)\n",
+		sig->SignalPrimitiveHeader.SignalId);
 		return -EINVAL;
 	}
 
 	down(&priv->mlme_blocking_mutex);
 
 	sig->SignalPrimitiveHeader.ReceiverProcessId = 0;
-	sig->SignalPrimitiveHeader.SenderProcessId = pcli->sender_id | pcli->seq_no;
+	sig->SignalPrimitiveHeader.SenderProcessId =
+		pcli->sender_id | pcli->seq_no;
 
 	unifi_trace(priv, UDBG2, "Send client=%d, S:0x%04X, sig 0x%.4X\n",
 				pcli->client_id,
@@ -180,7 +186,7 @@ unifi_mlme_blocking_request(unifi_priv_t *priv, ul_client_t *pcli,
 	}
 
 	unifi_trace(priv, UDBG5, "Send 0x%.4X, seq = %d\n",
-				sig->SignalPrimitiveHeader.SignalId, pcli->seq_no);
+		sig->SignalPrimitiveHeader.SignalId, pcli->seq_no);
 
 	/*
 	 * Advance the sequence number of the last sent signal, only
@@ -191,7 +197,8 @@ unifi_mlme_blocking_request(unifi_priv_t *priv, ul_client_t *pcli,
 		pcli->seq_no = 0;
 	}
 
-	r = unifi_mlme_wait_for_reply(priv, pcli, (sig->SignalPrimitiveHeader.SignalId + 1), timeout);
+	r = unifi_mlme_wait_for_reply(priv, pcli,
+		(sig->SignalPrimitiveHeader.SignalId + 1), timeout);
 	up(&priv->mlme_blocking_mutex);
 
 	if (r) {
@@ -220,8 +227,8 @@ unifi_mlme_blocking_request(unifi_priv_t *priv, ul_client_t *pcli,
  */
 void
 unifi_mlme_copy_reply_and_wakeup_client(ul_client_t *pcli,
-										CSR_SIGNAL *signal, int signal_len,
-										const bulk_data_param_t *bulkdata)
+	CSR_SIGNAL *signal, int signal_len,
+	const bulk_data_param_t *bulkdata)
 {
 	int i;
 
@@ -229,14 +236,19 @@ unifi_mlme_copy_reply_and_wakeup_client(ul_client_t *pcli,
 	memcpy(pcli->reply_signal, signal, signal_len);
 
 	/* Get the sequence number of the signal that woke us up. */
-	pcli->wake_seq_no = pcli->reply_signal->SignalPrimitiveHeader.ReceiverProcessId & 0x0F;
+	pcli->wake_seq_no =
+		pcli->reply_signal->SignalPrimitiveHeader.ReceiverProcessId
+		& 0x0F;
 
 	/* Append any bulk data */
 	for (i = 0; i < UNIFI_MAX_DATA_REFERENCES; i++) {
 		if (bulkdata->d[i].data_length > 0) {
 			if (bulkdata->d[i].os_data_ptr) {
-				memcpy(pcli->reply_bulkdata[i]->ptr, bulkdata->d[i].os_data_ptr, bulkdata->d[i].data_length);
-				pcli->reply_bulkdata[i]->length = bulkdata->d[i].data_length;
+				memcpy(pcli->reply_bulkdata[i]->ptr,
+					bulkdata->d[i].os_data_ptr,
+					bulkdata->d[i].data_length);
+				pcli->reply_bulkdata[i]->length =
+					bulkdata->d[i].data_length;
 			} else {
 				pcli->reply_bulkdata[i]->length = 0;
 			}
@@ -244,7 +256,8 @@ unifi_mlme_copy_reply_and_wakeup_client(ul_client_t *pcli,
 	}
 
 	/* Wake the requesting MLME function. */
-	pcli->wake_up_wq_id = pcli->reply_signal->SignalPrimitiveHeader.SignalId;
+	pcli->wake_up_wq_id =
+		pcli->reply_signal->SignalPrimitiveHeader.SignalId;
 	wake_up_interruptible(&pcli->udi_wq);
 
 } /* unifi_mlme_copy_reply_and_wakeup_client() */
@@ -269,7 +282,8 @@ uf_abort_mlme(unifi_priv_t *priv)
 {
 	ul_client_t *ul_cli;
 
-	/* Ensure no MLME functions are waiting on a the mlme_event semaphore. */
+	/* Ensure no MLME functions are waiting on
+	 * a the mlme_event semaphore. */
 	priv->io_aborted = 1;
 
 	ul_cli = priv->netdev_client;
@@ -301,75 +315,75 @@ struct mlme_code {
 };
 
 static const struct mlme_code Result_codes[] = {
-	{ "Success",							 0x0000 },
-	{ "Unspecified Failure",				 0x0001 },
-	/* (Reserved)					  0x0002 - 0x0009 */
-	{ "Refused Capabilities Mismatch",	   0x000A },
-	/* (Reserved)						  0x000B */
-	{ "Refused External Reason",			 0x000C },
-	/* (Reserved)					  0x000D - 0x0010 */
-	{ "Refused AP Out Of Memory",			0x0011 },
-	{ "Refused Basic Rates Mismatch",		0x0012 },
-	/* (Reserved)					  0x0013 - 0x001F */
-	{ "Failure",							 0x0020 },
-	/* (Reserved)					  0x0021 - 0x0024 */
-	{ "Refused Reason Unspecified",		  0x0025 },
-	{ "Invalid Parameters",				  0x0026 },
-	{ "Rejected With Suggested Changes",	 0x0027 },
-	/* (Reserved)					  0x0028 - 0x002E */
-	{ "Rejected For Delay Period",		   0x002F },
-	{ "Not Allowed",						 0x0030 },
-	{ "Not Present",						 0x0031 },
-	{ "Not QSTA",							0x0032 },
-	/* (Reserved)					  0x0033 - 0x7FFF */
-	{ "Timeout",							 0x8000 },
-	{ "Too Many Simultaneous Requests",	  0x8001 },
-	{ "BSS Already Started Or Joined",	   0x8002 },
-	{ "Not Supported",					   0x8003 },
-	{ "Transmission Failure",				0x8004 },
-	{ "Refused Not Authenticated",		   0x8005 },
-	{ "Reset Required Before Start",		 0x8006 },
-	{ "LM Info Unavailable",				 0x8007 },
+	{ "Success", 0x0000 },
+	{ "Unspecified Failure", 0x0001 },
+	/* (Reserved) 0x0002 - 0x0009 */
+	{ "Refused Capabilities Mismatch", 0x000A },
+	/* (Reserved) 0x000B */
+	{ "Refused External Reason", 0x000C },
+	/* (Reserved) 0x000D - 0x0010 */
+	{ "Refused AP Out Of Memory", 0x0011 },
+	{ "Refused Basic Rates Mismatch", 0x0012 },
+	/* (Reserved) 0x0013 - 0x001F */
+	{ "Failure", 0x0020 },
+	/* (Reserved) 0x0021 - 0x0024 */
+	{ "Refused Reason Unspecified", 0x0025 },
+	{ "Invalid Parameters", 0x0026 },
+	{ "Rejected With Suggested Changes", 0x0027 },
+	/* (Reserved) 0x0028 - 0x002E */
+	{ "Rejected For Delay Period", 0x002F },
+	{ "Not Allowed", 0x0030 },
+	{ "Not Present", 0x0031 },
+	{ "Not QSTA", 0x0032 },
+	/* (Reserved) 0x0033 - 0x7FFF */
+	{ "Timeout", 0x8000 },
+	{ "Too Many Simultaneous Requests", 0x8001 },
+	{ "BSS Already Started Or Joined", 0x8002 },
+	{ "Not Supported", 0x8003 },
+	{ "Transmission Failure", 0x8004 },
+	{ "Refused Not Authenticated", 0x8005 },
+	{ "Reset Required Before Start", 0x8006 },
+	{ "LM Info Unavailable", 0x8007 },
 	{ NULL, -1 }
 };
 
 static const struct mlme_code Reason_codes[] = {
-	/* (Reserved)					  0x0000 */
-	{ "Unspecified Reason",			  0x0001 },
-	{ "Authentication Not Valid",		0x0002 },
-	{ "Deauthenticated Leave BSS",	   0x0003 },
-	{ "Disassociated Inactivity",		0x0004 },
-	{ "AP Overload",					 0x0005 },
-	{ "Class2 Frame Error",			  0x0006 },
-	{ "Class3 Frame Error",			  0x0007 },
-	{ "Disassociated Leave BSS",		 0x0008 },
-	{ "Association Not Authenticated",   0x0009 },
-	{ "Disassociated Power Capability",  0x000A },
+	/* (Reserved) 0x0000 */
+	{ "Unspecified Reason", 0x0001 },
+	{ "Authentication Not Valid", 0x0002 },
+	{ "Deauthenticated Leave BSS", 0x0003 },
+	{ "Disassociated Inactivity", 0x0004 },
+	{ "AP Overload", 0x0005 },
+	{ "Class2 Frame Error", 0x0006 },
+	{ "Class3 Frame Error", 0x0007 },
+	{ "Disassociated Leave BSS", 0x0008 },
+	{ "Association Not Authenticated", 0x0009 },
+	{ "Disassociated Power Capability", 0x000A },
 	{ "Disassociated Supported Channels", 0x000B },
-	/* (Reserved)					  0x000C */
-	{ "Invalid Information Element",	 0x000D },
-	{ "Michael MIC Failure",			 0x000E },
-	{ "Fourway Handshake Timeout",	   0x000F },
-	{ "Group Key Update Timeout",		0x0010 },
-	{ "Handshake Element Different",	 0x0011 },
-	{ "Invalid Group Cipher",			0x0012 },
-	{ "Invalid Pairwise Cipher",		 0x0013 },
-	{ "Invalid AKMP",					0x0014 },
-	{ "Unsupported RSN IE Version",	  0x0015 },
-	{ "Invalid RSN IE Capabilities",	 0x0016 },
-	{ "Dot1X Auth Failed",			   0x0017 },
-	{ "Cipher Rejected By Policy",	   0x0018 },
-	/* (Reserved)				  0x0019 - 0x001F */
-	{ "QoS Unspecified Reason",		  0x0020 },
-	{ "QoS Insufficient Bandwidth",	  0x0021 },
-	{ "QoS Excessive Not Ack",		   0x0022 },
-	{ "QoS TXOP Limit Exceeded",		 0x0023 },
-	{ "QSTA Leaving",					0x0024 },
-	{ "End TS, End DLS, End BA",		 0x0025 },
+	/* (Reserved) 0x000C */
+	{ "Invalid Information Element", 0x000D },
+	{ "Michael MIC Failure", 0x000E },
+	{ "Fourway Handshake Timeout", 0x000F },
+	{ "Group Key Update Timeout", 0x0010 },
+	{ "Handshake Element Different", 0x0011 },
+	{ "Invalid Group Cipher", 0x0012 },
+	{ "Invalid Pairwise Cipher", 0x0013 },
+	{ "Invalid AKMP", 0x0014 },
+	{ "Unsupported RSN IE Version", 0x0015 },
+	{ "Invalid RSN IE Capabilities", 0x0016 },
+	{ "Dot1X Auth Failed", 0x0017 },
+	{ "Cipher Rejected By Policy", 0x0018 },
+	/* (Reserved) 0x0019 - 0x001F */
+	{ "QoS Unspecified Reason", 0x0020 },
+	{ "QoS Insufficient Bandwidth", 0x0021 },
+	{ "QoS Excessive Not Ack", 0x0022 },
+	{ "QoS TXOP Limit Exceeded", 0x0023 },
+	{ "QSTA Leaving", 0x0024 },
+	{ "End TS, End DLS, End BA", 0x0025 },
 	{ "Unknown TS, Unknown DLS, Unknown BA", 0x0026 },
-	{ "Timeout",						 0x0027 },
-	/* (Reserved)				  0x0028 - 0x002C */
-	{ "STAKey Mismatch",				 0x002D },
+	{ "Timeout", 0x0027 },
+	/* (Reserved) 0x0028 - 0x002C */
+	{ "STAKey Mismatch", 0x002D },
 	{ NULL, -1 }
 };
 
-- 
1.7.9.5

