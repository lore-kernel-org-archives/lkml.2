Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab0LGLGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:06:43 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34119 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755360Ab0LGLGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:06:42 -0500
Message-ID: <4CFE15E8.1020502@dsn.okisemi.com>
Date: Tue, 07 Dec 2010 20:09:28 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: [PATCH net-next-2.6 v8 13/20] CAN : Fix bit timing calculation issue
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify like use calculated value directly passed by CAN core module.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/pch_can.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 3540978..5a6a0df 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -786,17 +786,15 @@ static int pch_set_bittiming(struct net_device *ndev)
 	const struct can_bittiming *bt = &priv->can.bittiming;
 	u32 canbit;
 	u32 bepe;
-	u32 brp;
 
 	/* Setting the CCE bit for accessing the Can Timing register. */
 	pch_can_bit_set(&priv->regs->cont, PCH_CTRL_CCE);
 
-	brp = (bt->tq) / (1000000000/PCH_CAN_CLK) - 1;
-	canbit = brp & PCH_MSK_BITT_BRP;
+	canbit = (bt->brp - 1) & PCH_MSK_BITT_BRP;
 	canbit |= (bt->sjw - 1) << PCH_BIT_SJW_SHIFT;
 	canbit |= (bt->phase_seg1 + bt->prop_seg - 1) << PCH_BIT_TSEG1_SHIFT;
 	canbit |= (bt->phase_seg2 - 1) << PCH_BIT_TSEG2_SHIFT;
-	bepe = (brp & PCH_MSK_BRPE_BRPE) >> PCH_BIT_BRPE_BRPE_SHIFT;
+	bepe = ((bt->brp - 1) & PCH_MSK_BRPE_BRPE) >> PCH_BIT_BRPE_BRPE_SHIFT;
 	iowrite32(canbit, &priv->regs->bitt);
 	iowrite32(bepe, &priv->regs->brpe);
 	pch_can_bit_clear(&priv->regs->cont, PCH_CTRL_CCE);
-- 
1.6.0.6
