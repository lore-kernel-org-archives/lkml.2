Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab1CLUX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:23:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35765 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1CLUXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:23:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f6Y+OgsY4KHXGX4fz8lp0VCRCWoWhfC3lwUbhakMI7tNBz5G8yDob41A+0CTcSya9x
         9DpwbZEsN5f+d013rILpeRCBmOj0ptK2pAXUjAuUqGXCxPUxETMd3Hd6UEq1ThJaCGkn
         ekJL/FGvM7lwNatEI9R00DjDu00kQxepxdz6k=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 09/13] i2c-designware: Support multiple cores using same ISR
Date: Sat, 12 Mar 2011 12:23:23 -0800
Message-Id: <1299961407-26852-10-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
References: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Add check to make sure that the core is enabled and has outstanding
interrupts. The activity bit is masked due to the fact that it will
stay active even after the controller has been disabled until the
contoller internal state machines have settled.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/i2c/busses/i2c-designware-core.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 6e31d35..3597540 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -520,10 +520,16 @@ static u32 i2c_dw_read_clear_intrbits(struct dw_i2c_dev *dev)
 irqreturn_t i2c_dw_isr(int this_irq, void *dev_id)
 {
 	struct dw_i2c_dev *dev = dev_id;
-	u32 stat;
+	u32 stat, enabled;
+
+	enabled = dw_readl(dev, DW_IC_ENABLE);
+	stat = dw_readl(dev, DW_IC_RAW_INTR_STAT);
+	dev_dbg(dev->dev, "%s:  %s enabled= 0x%x stat=0x%x\n", __func__,
+		dev->adapter.name, enabled, stat);
+	if (!enabled || !(stat & ~DW_IC_INTR_ACTIVITY))
+		return IRQ_NONE;
 
 	stat = i2c_dw_read_clear_intrbits(dev);
-	dev_dbg(dev->dev, "%s: stat=0x%x\n", __func__, stat);
 
 	if (stat & DW_IC_INTR_TX_ABRT) {
 		dev->cmd_err |= DW_IC_ERR_TX_ABRT;
-- 
1.7.3.4

