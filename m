Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2JNPSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:18:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46024 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753592Ab2JNOl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:29 -0400
Message-Id: <20121014143534.873218526@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russ Gorby <russ.gorby@intel.com>,
        "Kappel, LaurentX" <laurentx.kappel@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 008/147] n_gsm: uplink SKBs accumulate on list
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_gsm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 0988aaa..c028f35 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -971,16 +971,19 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
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
 


