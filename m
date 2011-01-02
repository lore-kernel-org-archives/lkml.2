Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1ABH0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:26:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:37229 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab1ABH0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:26:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Simon Guinot <sguinot@lacie.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 183/260] dmaengine: fix interrupt clearing for mv_xor
Date: Sun,  2 Jan 2011 02:17:59 -0500
Message-Id: <1293952756-15010-184-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:31.0182 (UTC) FILETIME=[F51EA0E0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Guinot <sguinot@lacie.com>

commit cc60f8878eab892c03d06b10f389232b9b66bd83 upstream.

When using simultaneously the two DMA channels on a same engine, some
transfers are never completed. For example, an endless lock can occur
while writing heavily on a RAID5 array (with async-tx offload support
enabled).

Note that this issue can also be reproduced by using the DMA test
client.

On a same engine, the interrupt cause register is shared between two
DMA channels. This patch make sure that the cause bit is only cleared
for the requested channel.

Signed-off-by: Simon Guinot <sguinot@lacie.com>
Tested-by: Luc Saillard <luc@saillard.org>
Acked-by: saeed bishara <saeed.bishara@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/dma/mv_xor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index e2fd34d..ba28b29 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -162,7 +162,7 @@ static int mv_is_err_intr(u32 intr_cause)
 
 static void mv_xor_device_clear_eoc_cause(struct mv_xor_chan *chan)
 {
-	u32 val = (1 << (1 + (chan->idx * 16)));
+	u32 val = ~(1 << (chan->idx * 16));
 	dev_dbg(chan->device->common.dev, "%s, val 0x%08x\n", __func__, val);
 	__raw_writel(val, XOR_INTR_CAUSE(chan));
 }
-- 
1.7.3.3

