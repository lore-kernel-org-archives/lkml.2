Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2JDVyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:54:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57562 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943Ab2JDVWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:22:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Russ Gorby <russ.gorby@intel.com>,
        "Kappel, LaurentX" <laurentx.kappel@intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 43/58] n_gsm: memory leak in uplink error path
Date: Thu,  4 Oct 2012 14:19:50 -0700
Message-Id: <20121004210640.882143703@linuxfoundation.org>
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

---
 drivers/tty/n_gsm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -875,7 +875,7 @@ static int gsm_dlci_data_output_framed(s
 
 	/* dlci->skb is locked by tx_lock */
 	if (dlci->skb == NULL) {
-		dlci->skb = skb_dequeue(&dlci->skb_list);
+		dlci->skb = skb_dequeue_tail(&dlci->skb_list);
 		if (dlci->skb == NULL)
 			return 0;
 		first = 1;
@@ -899,8 +899,11 @@ static int gsm_dlci_data_output_framed(s
 
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


