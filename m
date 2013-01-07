Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3AGLYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:24:13 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42559 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3AGLYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:24:10 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 06/16] dmaengine: ste_dma40: don't allow high priority dest event lines
Date: Mon,  7 Jan 2013 12:21:48 +0100
Message-Id: <1357557718-15676-7-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Hardware bug: when a logical channel is triggerred by a high priority
destination event line, an extra packet transaction is generated in case
of important data write response latency on previous logical channel A
and if the source transfer of current logical channel B is already
completed and if no other channel with a higher priority than B is
waiting for execution.

Software workaround: do not set the high priority level for the
destination event lines that trigger logical channels.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 760576b..9f8964a 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2180,11 +2180,24 @@ static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
 {
 	bool realtime = d40c->dma_cfg.realtime;
 	bool highprio = d40c->dma_cfg.high_priority;
-	u32 prioreg = highprio ? D40_DREG_PSEG1 : D40_DREG_PCEG1;
 	u32 rtreg = realtime ? D40_DREG_RSEG1 : D40_DREG_RCEG1;
 	u32 event = D40_TYPE_TO_EVENT(dev_type);
 	u32 group = D40_TYPE_TO_GROUP(dev_type);
 	u32 bit = 1 << event;
+	u32 prioreg;
+
+	/*
+	 * Due to a hardware bug, in some cases a logical channel triggered by
+	 * a high priority destination event line can generate extra packet
+	 * transactions.
+	 *
+	 * The workaround is to not set the high priority level for the
+	 * destination event lines that trigger logical channels.
+	 */
+	if (!src && chan_is_logical(d40c))
+		highprio = false;
+
+	prioreg = highprio ? D40_DREG_PSEG1 : D40_DREG_PCEG1;
 
 	/* Destination event lines are stored in the upper halfword */
 	if (!src)
-- 
1.7.12.1

