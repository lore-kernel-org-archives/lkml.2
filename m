Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab2JDVSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:18:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63596 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844Ab2JDVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:18:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Russ Gorby <russ.gorby@intel.com>,
        "Kappel, LaurentX" <laurentx.kappel@intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 38/56] n_gsm: uplink SKBs accumulate on list
Date: Thu,  4 Oct 2012 14:15:59 -0700
Message-Id: <20121004211156.455425661@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Gorby <russ.gorby@intel.com>

commit 192b6041e75bb4a2aae73834037038cea139a92d upstream.

gsm_dlci_data_kick will not call any output function if tx_bytes > THRESH_LO
furthermore it will call the output function only once if tx_bytes == 0
If the size of the IP writes are on the order of THRESH_LO
we can get into a situation where skbs accumulate on the outbound list
being starved for events to call the output function.

gsm_dlci_data_kick now calls the sweep function when tx_bytes==0

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
Tested-by: Kappel, LaurentX <laurentx.kappel@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_gsm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -971,16 +971,19 @@ static void gsm_dlci_data_sweep(struct g
 static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 {
 	unsigned long flags;
+	int sweep;
 
 	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
 	/* If we have nothing running then we need to fire up */
+	sweep = (dlci->gsm->tx_bytes < TX_THRESH_LO);
 	if (dlci->gsm->tx_bytes == 0) {
 		if (dlci->net)
 			gsm_dlci_data_output_framed(dlci->gsm, dlci);
 		else
 			gsm_dlci_data_output(dlci->gsm, dlci);
-	} else if (dlci->gsm->tx_bytes < TX_THRESH_LO)
-		gsm_dlci_data_sweep(dlci->gsm);
+	}
+	if (sweep)
+ 		gsm_dlci_data_sweep(dlci->gsm);
 	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
 }
 


