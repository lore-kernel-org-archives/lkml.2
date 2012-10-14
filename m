Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2JNPUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:20:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab2JNOlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:23 -0400
Message-Id: <20121014143535.537156446@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russ Gorby <russ.gorby@intel.com>,
        "Yin, Fengwei" <fengwei.yin@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 013/147] n_gsm: replace kfree_skb w/ appropriate dev_* versions
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

commit 329e56780e514a7ab607bcb51a52ab0dc2669414 upstream.

Drivers are supposed to use the dev_* versions of the kfree_skb
interfaces. In a couple of cases we were called with IRQs
disabled as well which kfree_skb() does not expect.

Replaced kfree_skb calls w/ dev_kfree_skb and dev_kfree_skb_any

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
Tested-by: Yin, Fengwei <fengwei.yin@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_gsm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 6f4f8d3..a8c82f5 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -879,7 +879,7 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 	if (len > gsm->mtu) {
 		if (dlci->adaption == 3) {
 			/* Over long frame, bin it */
-			kfree_skb(dlci->skb);
+			dev_kfree_skb_any(dlci->skb);
 			dlci->skb = NULL;
 			return 0;
 		}
@@ -905,7 +905,7 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 	skb_pull(dlci->skb, len);
 	__gsm_data_queue(dlci, msg);
 	if (last) {
-		kfree_skb(dlci->skb);
+		dev_kfree_skb_any(dlci->skb);
 		dlci->skb = NULL;
 	}
 	return size;
@@ -1674,7 +1674,7 @@ static void gsm_dlci_free(struct kref *ref)
 	dlci->gsm->dlci[dlci->addr] = NULL;
 	kfifo_free(dlci->fifo);
 	while ((dlci->skb = skb_dequeue(&dlci->skb_list)))
-		kfree_skb(dlci->skb);
+		dev_kfree_skb(dlci->skb);
 	kfree(dlci);
 }
 
@@ -2013,7 +2013,7 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
 {
 	int i;
 	struct gsm_dlci *dlci = gsm->dlci[0];
-	struct gsm_msg *txq, *utxq;
+	struct gsm_msg *txq, *ntxq;
 	struct gsm_control *gc;
 
 	gsm->dead = 1;


