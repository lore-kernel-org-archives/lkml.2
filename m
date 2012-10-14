Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2JNOlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753709Ab2JNOlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:36 -0400
Message-Id: <20121014143535.274492595@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russ Gorby <russ.gorby@intel.com>,
        "Yin, Fengwei" <fengwei.yin@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 011/147] n_gsm: added interlocking for gsm_data_lock for certain code paths
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_gsm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 5f68f2a..0d93e51 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1205,6 +1205,8 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 							u8 *data, int clen)
 {
 	u8 buf[1];
+	unsigned long flags;
+
 	switch (command) {
 	case CMD_CLD: {
 		struct gsm_dlci *dlci = gsm->dlci[0];
@@ -1225,7 +1227,9 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 		gsm->constipated = 0;
 		gsm_control_reply(gsm, CMD_FCON, NULL, 0);
 		/* Kick the link in case it is idling */
+		spin_lock_irqsave(&gsm->tx_lock, flags);
 		gsm_data_kick(gsm);
+		spin_unlock_irqrestore(&gsm->tx_lock, flags);
 		break;
 	case CMD_FCOFF:
 		/* Modem wants us to STFU */
@@ -2392,12 +2396,12 @@ static void gsmld_write_wakeup(struct tty_struct *tty)
 
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


