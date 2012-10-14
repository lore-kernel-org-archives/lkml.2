Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2JNOld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753422Ab2JNOl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:29 -0400
Message-Id: <20121014143535.671135982@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russ Gorby <russ.gorby@intel.com>,
        "Kappel, LaurentX" <laurentx.kappel@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 014/147] n_gsm: memory leak in uplink error path
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

commit 88ed2a60610974443335c924d7cb8e5dcf9dbdc1 upstream.

Uplink (TX) network data will go through gsm_dlci_data_output_framed
there is a bug where if memory allocation fails, the skb which
has already been pulled off the list will be lost.

In addition TX skbs were being processed in LIFO order

Fixed the memory leak, and changed to FIFO order processing

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
Tested-by: Kappel, LaurentX <laurentx.kappel@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_gsm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index a8c82f5..3e210a4 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -868,7 +868,7 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 
 	/* dlci->skb is locked by tx_lock */
 	if (dlci->skb == NULL) {
-		dlci->skb = skb_dequeue(&dlci->skb_list);
+		dlci->skb = skb_dequeue_tail(&dlci->skb_list);
 		if (dlci->skb == NULL)
 			return 0;
 		first = 1;
@@ -892,8 +892,11 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 
 	/* FIXME: need a timer or something to kick this so it can't
 	   get stuck with no work outstanding and no buffer free */
-	if (msg == NULL)
+	if (msg == NULL) {
+		skb_queue_tail(&dlci->skb_list, dlci->skb);
+		dlci->skb = NULL;
 		return -ENOMEM;
+	}
 	dp = msg->data;
 
 	if (dlci->adaption == 4) { /* Interruptible framed (Packetised Data) */


