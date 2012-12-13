Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab2LMOP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:15:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45171 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab2LMOPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 235/241] 8139cp: revert "set ring address before enabling receiver"
Date: Thu, 13 Dec 2012 12:00:00 -0200
Message-Id: <1355407206-17100-236-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?fran=C3=A7ois=20romieu?= <romieu@fr.zoreil.com>

commit b26623dab7eeb1e9f5898c7a49458789dd492f20 upstream.

This patch reverts b01af4579ec41f48e9b9c774e70bd6474ad210db.

The original patch was tested with emulated hardware. Real
hardware chokes.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=47041

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/realtek/8139cp.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 995d0cf..a2679d8 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -979,17 +979,6 @@ static void cp_init_hw (struct cp_private *cp)
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
 
@@ -1003,6 +992,17 @@ static void cp_init_hw (struct cp_private *cp)
 
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
-- 
1.7.9.5

