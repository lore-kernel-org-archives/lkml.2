Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab2JDVzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:55:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56720 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937Ab2JDVWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:22:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Russ Gorby <russ.gorby@intel.com>,
        "Yin, Fengwei" <fengwei.yin@intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 42/58] n_gsm: added interlocking for gsm_data_lock for certain code paths
Date: Thu,  4 Oct 2012 14:19:49 -0700
Message-Id: <20121004210640.743182779@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Gorby <russ.gorby@intel.com>

commit 5e44708f75b0f8712da715d6babb0c21089b2317 upstream.

There were some locking holes in the management of the MUX's
message queue for 2 code paths:
1) gsmld_write_wakeup
2) receipt of CMD_FCON flow-control message
In both cases gsm_data_kick is called w/o locking so it can collide
with other other instances of gsm_data_kick (pulling messages tx_tail)
or potentially other instances of __gsm_data_queu (adding messages to tx_head)

Changed to take the tx_lock in these 2 cases

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
Tested-by: Yin, Fengwei <fengwei.yin@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_gsm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1193,6 +1193,8 @@ static void gsm_control_message(struct g
 							u8 *data, int clen)
 {
 	u8 buf[1];
+	unsigned long flags;
+
 	switch (command) {
 	case CMD_CLD: {
 		struct gsm_dlci *dlci = gsm->dlci[0];
@@ -1218,7 +1220,9 @@ static void gsm_control_message(struct g
 		gsm->constipated = 0;
 		gsm_control_reply(gsm, CMD_FCOFF, NULL, 0);
 		/* Kick the link in case it is idling */
+		spin_lock_irqsave(&gsm->tx_lock, flags);
 		gsm_data_kick(gsm);
+		spin_unlock_irqrestore(&gsm->tx_lock, flags);
 		break;
 	case CMD_MSC:
 		/* Out of band modem line change indicator for a DLCI */
@@ -2380,12 +2384,12 @@ static void gsmld_write_wakeup(struct tt
 
 	/* Queue poll */
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	gsm_data_kick(gsm);
 	if (gsm->tx_bytes < TX_THRESH_LO) {
-		spin_lock_irqsave(&gsm->tx_lock, flags);
 		gsm_dlci_data_sweep(gsm);
-		spin_unlock_irqrestore(&gsm->tx_lock, flags);
 	}
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 }
 
 /**


