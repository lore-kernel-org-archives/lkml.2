Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2ASGPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:15:34 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:47249
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546Ab2ASGP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:15:29 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bhz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <alsa-devel@alsa-project.org>,
        <b29396@freescale.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 06/10] MXS-DMA : add more flags for MXS-DMA
Date: Thu, 19 Jan 2012 14:16:03 +0800
Message-ID: <1326953767-24155-7-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1326953767-24155-1-git-send-email-b32955@freescale.com>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] Background :
    The GPMI does ECC read page operation with a DMA chain consist of three DMA
    Command Structures. The middle one of the chain is used to enable the BCH,
    and read out the NAND page.

    The WAIT4END(wait for command end) is a comunication signal between
    the GPMI and MXS-DMA.

[2] The current DMA code sets the WAIT4END bit at the last one, such as:

    +-----+               +-----+                      +-----+
    | cmd | ------------> | cmd | ------------------>  | cmd |
    +-----+               +-----+                      +-----+
                                                          ^
                                                          |
                                                          |
                                                     set WAIT4END here

    This chain works fine in the mx23/mx28.

[3] But in the new GPMI version (used in MX50/MX60), the WAIT4END bit should
    be set not only at the last DMA Command Structure,
    but also at the middle one, such as:

    +-----+               +-----+                      +-----+
    | cmd | ------------> | cmd | ------------------>  | cmd |
    +-----+               +-----+                      +-----+
                             ^                            ^
                             |                            |
                             |                            |
                        set WAIT4END here too        set WAIT4END here

   If we do not set WAIT4END, the BCH maybe stall in "ECC reading page" state.
   In the next ECC write page operation, a DMA-timeout occurs.
   This has been catched in the MX6Q board.

In order to fix the bug, we should let the driver to
set the proper DMA flags in the DMA command structrues.

So add the new flags for MXS-DMA.
The driver can use these flags to control the DMA in a more flexible way.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/mxs-dma.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/mxs-dma.h b/include/linux/mxs-dma.h
index 203d7c4..3ef73b8 100644
--- a/include/linux/mxs-dma.h
+++ b/include/linux/mxs-dma.h
@@ -11,6 +11,32 @@
 
 #include <linux/dmaengine.h>
 
+/*
+ * The drivers use these flags for ->device_prep_slave_sg() :
+ *    [1] If there is only one DMA command in the DMA chain, the code should be:
+ *            ......
+ *            ->device_prep_slave_sg(MXS_DMA_F_WAIT4END);
+ *            ......
+ *    [2] If there are two DMA commands in the DMA chain, the code should be
+ *            ......
+ *            ->device_prep_slave_sg(0);
+ *            ......
+ *            ->device_prep_slave_sg(MXS_DMA_F_LASTONE);
+ *            ......
+ *    [3] If there are more than two DMA commands in the DMA chain, the code
+ *        should be:
+ *            ......
+ *            ->device_prep_slave_sg(0);                 // First
+ *            ......
+ *            ->device_prep_slave_sg(MXS_DMA_F_APPEND [| MXS_DMA_F_WAIT4END]);
+ *            ......
+ *            ->device_prep_slave_sg(MXS_DMA_F_LASTONE); // Last
+ */
+#define MXS_DMA_F_APPEND	(1 << 0)
+#define MXS_DMA_F_WAIT4END	(1 << 1)
+
+#define MXS_DMA_F_LASTONE	(MXS_DMA_F_APPEND | MXS_DMA_F_WAIT4END)
+
 struct mxs_dma_data {
 	int chan_irq;
 };
-- 
1.7.0.4


