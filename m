Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2FMKXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:23:05 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6067 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab2FMKW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:22:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 13 Jun 2012 03:21:51 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <ben-linux@fluff.org>,
        <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 1/4] i2c: tegra: make sure register writes completes
Date: Wed, 13 Jun 2012 15:42:36 +0530
Message-ID: <1339582359-7911-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com>
References: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra PPSB (an peripheral bus) queues writes transactions.
In order to guarantee that writes have completed before a
certain time, a read transaction to a register on the same
bus must be executed.
This is necessary in situations such as when clearing an
interrupt status or enable, so that when returning from an
interrupt handler, the HW has already de-asserted its
interrupt status output, which will avoid spurious interrupts.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Using the readback for mask/unmask of irq also.

Changes from V2:
- Read back is done whenever write happen in i2c register other than TX FIFO.

 drivers/i2c/busses/i2c-tegra.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 8b2e555..785f7f7 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -165,6 +165,10 @@ static void i2c_writel(struct tegra_i2c_dev *i2c_dev, u32 val,
 	unsigned long reg)
 {
 	writel(val, i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
+
+	/* Read back register to make sure that register writes completed */
+	if (reg != I2C_TX_FIFO)
+		readl(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
 }
 
 static u32 i2c_readl(struct tegra_i2c_dev *i2c_dev, unsigned long reg)
-- 
1.7.1.1

