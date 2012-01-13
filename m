Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2AMJHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:07:24 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:12587
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab2AMJHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:07:09 -0500
X-SpamScore: 0
X-BigFish: VS0(zz13e6Kc8kzz1202hzz8275bhz2dhc1ahc1bh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Qiang Liu <qiang.liu@freescale.com>
To: <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
CC: Qiang Liu <b32616@freescale.com>, Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH][SDK v1.2] sata: I/O load balancing
Date: Fri, 13 Jan 2012 16:25:47 +0800
Message-ID: <1326443147-26645-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiang Liu <b32616@freescale.com>

Reduce interrupt singnals through reset Interrupt Coalescing Control Reg.
Increase the threshold value of interrupt and timer will reduce the number
of complete interrupt sharply. Improve the system performance effectively.

Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
Description:
  1. sata-fsl interrupt will be raised 130 thousand times when write 8G file
(dd if=/dev/zero of=/dev/sda2 bs=128K count=65536);
  2. most of interrupts raised because of only 1-4 commands completed;
  3. only 30 thousand times will be raised after set max interrupt threshold,
more interrupts are coalesced as the description of ICC;

Performance Improvement:
  use top command,
  [root@p2020ds root]# dd if=/dev/zero of=/dev/sda2 bs=128K count=65536 &
  [root@p2020ds root]# top

   CPU %  |  dd   |  flush-8:0 | softirq
  ---------------------------------------
   before | 20-22 |    17-19   |    7
  ---------------------------------------
   after  | 18-21 |    15-16   |    5
  ---------------------------------------

 drivers/ata/sata_fsl.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 3547000..93f8b00 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -6,7 +6,7 @@
  * Author: Ashish Kalra <ashish.kalra@freescale.com>
  * Li Yang <leoli@freescale.com>
  *
- * Copyright (c) 2006-2007, 2011 Freescale Semiconductor, Inc.
+ * Copyright (c) 2006-2007, 2011-2012 Freescale Semiconductor, Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -162,6 +162,16 @@ enum {
 };

 /*
+ * Interrupt Coalescing Control Register bitdefs
+ */
+enum {
+	ICC_MIN_INT_THRESHOLD_COUNT = (1 << 24),
+	ICC_MAX_INT_THRESHOLD_COUNT = (((1 << 4) - 1) << 24),
+	ICC_MIN_INT_THRESHOLD_TIMER = 1,
+	ICC_MAX_INT_THRESHOLD_TIMER = ((1 << 18) - 1),
+};
+
+/*
  * SATA Superset Registers
  */
 enum {
@@ -460,6 +470,13 @@ static unsigned int sata_fsl_qc_issue(struct ata_queued_cmd *qc)
 	/* Simply queue command to the controller/device */
 	iowrite32(1 << tag, CQ + hcr_base);

+	/*
+	 * reset the number of command complete bits which will cause the
+	 * interrupt to be signaled
+	 */
+	iowrite32(ICC_MAX_INT_THRESHOLD_COUNT | ICC_MAX_INT_THRESHOLD_TIMER,
+			ICC + hcr_base);
+
 	VPRINTK("xx_qc_issue called, tag=%d, CQ=0x%x, CA=0x%x\n",
 		tag, ioread32(CQ + hcr_base), ioread32(CA + hcr_base));

--
1.6.4


