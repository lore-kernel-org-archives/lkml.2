Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2JNOll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46050 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805Ab2JNOlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:36 -0400
Message-Id: <20121014143535.143856643@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "samix.lebsir" <samix.lebsir@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 010/147] char: n_gsm: remove message filtering for contipated DLCI
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "samix.lebsir" <samix.lebsir@intel.com>

commit 10c6c383e43565c9c6ec07ff8eb2825f8091bdf0 upstream.

The design of uplink flow control in the mux driver is
that for constipated channels data will backup into the
per-channel fifos, and any messages that make it to the
outbound message queue will still go out.
Code was added to also stop messages that were in the outbound
queue but this requires filtering through all the messages on the
queue for stopped dlcis and changes some of the mux logic unneccessarily.

The message fiiltering was removed to be in line w/ the original design
as the message filtering does not provide any solution.
Extra debug messages used during investigation were also removed.

Signed-off-by: samix.lebsir <samix.lebsir@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_gsm.c |   25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index db15b56..5f68f2a 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -691,10 +691,6 @@ static void gsm_data_kick(struct gsm_mux *gsm)
 			msg = msg->next;
 			continue;
 		}
-		if (gsm->dlci[msg->addr]->constipated) {
-			msg = msg->next;
-			continue;
-		}
 		if (gsm->encoding != 0) {
 			gsm->txframe[0] = GSM1_SOF;
 			len = gsm_stuff_frame(msg->data,
@@ -748,8 +744,6 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 	u8 *dp = msg->data;
 	u8 *fcs = dp + msg->len;
 
-	WARN_ONCE(dlci->constipated, "%s: queueing from a constipated DLCI",
-		__func__);
 	/* Fill in the header */
 	if (gsm->encoding == 0) {
 		if (msg->len < 128)
@@ -956,9 +950,6 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 			break;
 		dlci = gsm->dlci[i];
 		if (dlci == NULL || dlci->constipated) {
-			if (dlci && (debug & 0x20))
-				pr_info("%s: DLCI %d is constipated",
-					__func__, i);
 			i++;
 			continue;
 		}
@@ -988,12 +979,8 @@ static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 	unsigned long flags;
 	int sweep;
 
-	if (dlci->constipated) {
-		if (debug & 0x20)
-			pr_info("%s: DLCI %d is constipated",
-				__func__, dlci->addr);
+	if (dlci->constipated) 
 		return;
-	}
 
 	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
 	/* If we have nothing running then we need to fire up */
@@ -1069,15 +1056,9 @@ static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
 	/* Flow control/ready to communicate */
 	fc = (modem & MDM_FC) || !(modem & MDM_RTR);
 	if (fc && !dlci->constipated) {
-		if (debug & 0x20)
-			pr_info("%s: DLCI %d START constipated (tx_bytes=%d)",
-				__func__, dlci->addr, dlci->gsm->tx_bytes);
 		/* Need to throttle our output on this device */
 		dlci->constipated = 1;
 	} else if (!fc && dlci->constipated) {
-		if (debug & 0x20)
-			pr_info("%s: DLCI %d END constipated (tx_bytes=%d)",
-				__func__, dlci->addr, dlci->gsm->tx_bytes);
 		dlci->constipated = 0;
 		gsm_dlci_data_kick(dlci);
 	}
@@ -1241,8 +1222,6 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 		break;
 	case CMD_FCON:
 		/* Modem can accept data again */
-		if (debug & 0x20)
-			pr_info("%s: GSM END constipation", __func__);
 		gsm->constipated = 0;
 		gsm_control_reply(gsm, CMD_FCON, NULL, 0);
 		/* Kick the link in case it is idling */
@@ -1250,8 +1229,6 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 		break;
 	case CMD_FCOFF:
 		/* Modem wants us to STFU */
-		if (debug & 0x20)
-			pr_info("%s: GSM START constipation", __func__);
 		gsm->constipated = 1;
 		gsm_control_reply(gsm, CMD_FCOFF, NULL, 0);
 		break;


