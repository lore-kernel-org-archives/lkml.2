Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1LFKcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:32:31 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:51822 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab1LFKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:32:29 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH][NET] several cleanups and bugfixes for fec.c: preserve MII/RMII setting in fec_stop()
Date: Tue,  6 Dec 2011 11:27:14 +0100
Message-Id: <d6f4de9e4cfb393754b42815a2ef1a59c96eab83.1323163127.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <55b78c1766da5b0d0d679f5eae3fb9fc74a6ceef.1323163127.git.LW@KARO-electronics.de>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <bd4415514fa0b40ece04d56b3ac4f549e79d87d7.1323163127.git.LW@KARO-electronics.de>
 <6c28f25c5c6d2f88d0985ce361c5e16f19db27d0.1323163127.git.LW@KARO-electronics.de>
 <0b92136d69e509a6ce49b526e1834f0ec90b04a4.1323163127.git.LW@KARO-electronics.de>
 <6d1e5cdcbfc48df864ec9e0939645c0e95389d2a.1323163127.git.LW@KARO-electronics.de>
 <55b78c1766da5b0d0d679f5eae3fb9fc74a6ceef.1323163127.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323163127.git.LW@KARO-electronics.de>
References: <cover.1323163127.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additionally to setting the ETHER_EN bit in FEC_ECNTRL the MII/RMII
setting in FEC_R_CNTRL needs to be preserved to keep the MII interface
functional.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/ethernet/freescale/fec.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
index 11534b9..ab0afb5 100644
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -515,6 +515,7 @@ fec_stop(struct net_device *ndev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	const struct platform_device_id *id_entry =
 				platform_get_device_id(fep->pdev);
+	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
 
 	/* We cannot expect a graceful transmit stop without link !!! */
 	if (fep->link) {
@@ -531,8 +532,10 @@ fec_stop(struct net_device *ndev)
 	writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 
 	/* We have to keep ENET enabled to have MII interrupt stay working */
-	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC)
+	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC) {
 		writel(2, fep->hwp + FEC_ECNTRL);
+		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
+	}
 }
 
 
-- 
1.5.6.5

