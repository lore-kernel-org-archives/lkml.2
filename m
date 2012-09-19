Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2ISP3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:29:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39780 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2ISP3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:29:13 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH v2] lib/dma-debug: check for vmalloc and module addresses used with the DMA-API
Date: Wed, 19 Sep 2012 17:28:36 +0200
Message-Id: <1348068516-17878-1-git-send-email-jlu@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120918131842.GL2505@amd.com>
References: <20120918131842.GL2505@amd.com>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:99ff:fe56:8d7
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---

Changes since v1:
 - As recommended by Joerg Roedel, check for overlap with vmalloc and
   module address ranges.

 lib/dma-debug.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 66ce414..b35992b 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -944,6 +944,14 @@ static void check_for_illegal_area(struct device *dev, void *addr, unsigned long
 	if (overlap(addr, len, _text, _etext) ||
 	    overlap(addr, len, __start_rodata, __end_rodata))
 		err_printk(dev, NULL, "DMA-API: device driver maps memory from kernel text or rodata [addr=%p] [len=%lu]\n", addr, len);
+#ifdef CONFIG_MMU
+	if (overlap(addr, len, (void *)VMALLOC_START, (void *)VMALLOC_END))
+		err_printk(dev, NULL, "DMA-API: device driver maps memory from vmalloc address range [addr=%p] [len=%lu]\n", addr, len);
+#endif
+#if defined(CONFIG_MODULES) && defined(MODULES_VADDR)
+	if (overlap(addr, len, (void *)MODULES_VADDR, (void *)MODULES_END))
+		err_printk(dev, NULL, "DMA-API: device driver maps memory from kernel module address range [addr=%p] [len=%lu]\n", addr, len);
+#endif
 }
 
 static void check_sync(struct device *dev,
-- 
1.7.10.4

