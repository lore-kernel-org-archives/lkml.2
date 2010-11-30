Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0K3OWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:22:07 -0500
Received: from lav-w.yar.ru ([193.233.48.101]:43140 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753090Ab0K3OWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:22:06 -0500
X-Greylist: delayed 1522 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 09:22:05 EST
Date: Tue, 30 Nov 2010 16:46:26 +0300
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: netdev@vger.kernel.org, tori@unhappy.mine.nu
Subject: [PATCH] fix hang in dmfe driver on sending of big packet
 (linux-2.6.35)
Message-ID: <20101130134626.GA1856@lw.yar.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

This patch fixes hang in dmfe driver on attempt of sending a big packet.
Without this patch the code stops the queue and never wakes it again.

Signed-off-by: Alexander V. Lukyanov <lav@netis.ru>

-- 
   Alexander.

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmfe.patch"

--- dmfe.c.1	2010-11-30 16:21:52.758465207 +0300
+++ dmfe.c	2010-11-30 16:24:45.301468601 +0300
@@ -687,18 +687,18 @@
 	unsigned long flags;
 
 	DMFE_DBUG(0, "dmfe_start_xmit", 0);
 
-	/* Resource flag check */
-	netif_stop_queue(dev);
-
 	/* Too large packet check */
 	if (skb->len > MAX_PACKET_SIZE) {
 		pr_err("big packet = %d\n", (u16)skb->len);
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
+	/* Resource flag check */
+	netif_stop_queue(dev);
+
 	spin_lock_irqsave(&db->lock, flags);
 
 	/* No Tx resource check, it never happen nromally */
 	if (db->tx_queue_cnt >= TX_FREE_DESC_CNT) {

--AhhlLboLdkugWU4S--
