Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2LLJjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:39:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51693 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2LLJia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:38:30 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 6/7] dmaengine: ste_dma40: don't allow high priority dest event lines
Date: Wed, 12 Dec 2012 10:37:20 +0100
Message-Id: <1355305041-2338-7-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
References: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
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
index d8d58d9..f871df6 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2181,11 +2181,24 @@ static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
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

