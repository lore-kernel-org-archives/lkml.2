Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815Ab2EJRoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:44:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52779 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760594Ab2EJRev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:51 -0400
Message-Id: <20120510173135.447392286@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 29/52] tg3: Avoid panic from reserved statblk field access
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Matt Carlson <mcarlson@broadcom.com>

[ Upstream commit f891ea1634ce41f5f47ae40d8594809f4cd2ca66 ]

When RSS is enabled, interrupt vector 0 does not receive any rx traffic.
The rx producer index fields for vector 0's status block should be
considered reserved in this case.  This patch changes the code to
respect these reserved fields, which avoids a kernel panic when these
fields take on non-zero values.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -879,8 +879,13 @@ static inline unsigned int tg3_has_work(
 		if (sblk->status & SD_STATUS_LINK_CHG)
 			work_exists = 1;
 	}
-	/* check for RX/TX work to do */
-	if (sblk->idx[0].tx_consumer != tnapi->tx_cons ||
+
+	/* check for TX work to do */
+	if (sblk->idx[0].tx_consumer != tnapi->tx_cons)
+		work_exists = 1;
+
+	/* check for RX work to do */
+	if (tnapi->rx_rcb_prod_idx &&
 	    *(tnapi->rx_rcb_prod_idx) != tnapi->rx_rcb_ptr)
 		work_exists = 1;
 
@@ -5877,6 +5882,9 @@ static int tg3_poll_work(struct tg3_napi
 			return work_done;
 	}
 
+	if (!tnapi->rx_rcb_prod_idx)
+		return work_done;
+
 	/* run RX thread, within the bounds set by NAPI.
 	 * All RX "locking" is done by ensuring outside
 	 * code synchronizes with tg3->napi.poll()
@@ -7428,6 +7436,12 @@ static int tg3_alloc_consistent(struct t
 		 */
 		switch (i) {
 		default:
+			if (tg3_flag(tp, ENABLE_RSS)) {
+				tnapi->rx_rcb_prod_idx = NULL;
+				break;
+			}
+			/* Fall through */
+		case 1:
 			tnapi->rx_rcb_prod_idx = &sblk->idx[0].rx_producer;
 			break;
 		case 2:


