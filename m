Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1FITWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:22:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64443 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab1FITWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NODmlmVFbOzJv51bJ2TJ2KhSZqEs7thdLJ5oyFkpH85xYvQFr8snu5zwNgJNhZjriX
         OLy/SDj+Atlb6awGqs6XHMLs0K67reeymKTMq2kW/9+PJroXnOnqfKBZEeHfC81xWuiH
         SeHbLLUOZh4Rkk/aSTVG9Jm+nz64DNOJd2Nko=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 09/13] i2c-designware: Support multiple cores using same ISR
Date: Thu,  9 Jun 2011 12:21:46 -0700
Message-Id: <1307647310-24332-10-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
References: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Add check to make sure that the core is enabled and has outstanding
interrupts. The activity bit is masked due to the fact that it will
stay active even after the controller has been disabled until the
contoller internal state machines have settled.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-designware-core.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 9de672f..11909eb 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -521,10 +521,16 @@ static u32 i2c_dw_read_clear_intrbits(struct dw_i2c_dev *dev)
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

