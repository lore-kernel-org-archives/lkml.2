Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab2ASKNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:13:09 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5965 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2ASKND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:13:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 19 Jan 2012 02:12:40 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: swarren@nvidia.com, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 1/3] rtc: twl: Enable RTC irrespective of its prior state
Date: Thu, 19 Jan 2012 15:42:27 +0530
Message-Id: <1326967949-8248-2-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1326967949-8248-1-git-send-email-vbyravarasu@nvidia.com>
References: <1326967949-8248-1-git-send-email-vbyravarasu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venu Byravarasu <vbyravarasu@nvidia.com>

As part of probe, before enabling RTC, RTC_CTRL register is read
to check if it is already running. If RTC is used by kernel alone,
then this read is not required. Even if RTC was enabled already by
boot loader, setting STOP_RTC bit again should not harm.
Hence removed unwanted read operation.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/rtc/rtc-twl.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 20687d5..61ae1b7 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -449,19 +449,11 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 			REG_INT_MSK_STS_A);
 	}
 
-	/* Check RTC module status, Enable if it is off */
-	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_CTRL_REG);
+	dev_info(&pdev->dev, "Enabling TWL-RTC\n");
+	ret = twl_rtc_write_u8(BIT_RTC_CTRL_REG_STOP_RTC_M, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out1;
 
-	if (!(rd_reg & BIT_RTC_CTRL_REG_STOP_RTC_M)) {
-		dev_info(&pdev->dev, "Enabling TWL-RTC.\n");
-		rd_reg = BIT_RTC_CTRL_REG_STOP_RTC_M;
-		ret = twl_rtc_write_u8(rd_reg, REG_RTC_CTRL_REG);
-		if (ret < 0)
-			goto out1;
-	}
-
 	/* init cached IRQ enable bits */
 	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)
-- 
1.7.1.1

