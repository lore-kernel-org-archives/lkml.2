Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423731Ab2LGBAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:00:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46480 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423712Ab2LGBAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:00:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, CAI Qian <caiqian@redhat.com>
Subject: [ 27/27] 8139cp: revert "set ring address before enabling receiver"
Date: Thu,  6 Dec 2012 16:59:11 -0800
Message-Id: <20121207005833.975931292@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit b26623dab7eeb1e9f5898c7a49458789dd492f20 upstream.

This patch reverts b01af4579ec41f48e9b9c774e70bd6474ad210db.

The original patch was tested with emulated hardware. Real
hardware chokes.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=47041

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/realtek/8139cp.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -979,17 +979,6 @@ static void cp_init_hw (struct cp_privat
 	cpw32_f (MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
 	cpw32_f (MAC0 + 4, le32_to_cpu (*(__le32 *) (dev->dev_addr + 4)));
 
-	cpw32_f(HiTxRingAddr, 0);
-	cpw32_f(HiTxRingAddr + 4, 0);
-
-	ring_dma = cp->ring_dma;
-	cpw32_f(RxRingAddr, ring_dma & 0xffffffff);
-	cpw32_f(RxRingAddr + 4, (ring_dma >> 16) >> 16);
-
-	ring_dma += sizeof(struct cp_desc) * CP_RX_RING_SIZE;
-	cpw32_f(TxRingAddr, ring_dma & 0xffffffff);
-	cpw32_f(TxRingAddr + 4, (ring_dma >> 16) >> 16);
-
 	cp_start_hw(cp);
 	cpw8(TxThresh, 0x06); /* XXX convert magic num to a constant */
 
@@ -1003,6 +992,17 @@ static void cp_init_hw (struct cp_privat
 
 	cpw8(Config5, cpr8(Config5) & PMEStatus);
 
+	cpw32_f(HiTxRingAddr, 0);
+	cpw32_f(HiTxRingAddr + 4, 0);
+
+	ring_dma = cp->ring_dma;
+	cpw32_f(RxRingAddr, ring_dma & 0xffffffff);
+	cpw32_f(RxRingAddr + 4, (ring_dma >> 16) >> 16);
+
+	ring_dma += sizeof(struct cp_desc) * CP_RX_RING_SIZE;
+	cpw32_f(TxRingAddr, ring_dma & 0xffffffff);
+	cpw32_f(TxRingAddr + 4, (ring_dma >> 16) >> 16);
+
 	cpw16(MultiIntr, 0);
 
 	cpw8_f(Cfg9346, Cfg9346_Lock);


