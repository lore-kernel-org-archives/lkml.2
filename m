Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab2ASLwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:52:38 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3337 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2ASLwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:52:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 19 Jan 2012 03:52:36 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] rtc: twl: optimize IRQ bit access
Date: Thu, 19 Jan 2012 17:22:22 +0530
Message-Id: <1326973942-11576-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venu Byravarasu <vbyravarasu@nvidia.com>

As TWL RTC driver is having a cached copy of enabled RTC interrupt bits
in variable rtc_irq_bits, that can be checked before really setting
or masking any of the interrupt bits.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/rtc/rtc-twl.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index a0236a0..b1f6c8b 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -176,6 +176,10 @@ static int set_rtc_irq_bit(unsigned char bit)
 	unsigned char val;
 	int ret;
 
+	/* if the bit is set, return from here */
+	if (rtc_irq_bits & bit)
+		return 0;
+
 	val = rtc_irq_bits | bit;
 	val &= ~BIT_RTC_INTERRUPTS_REG_EVERY_M;
 	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
@@ -193,6 +197,10 @@ static int mask_rtc_irq_bit(unsigned char bit)
 	unsigned char val;
 	int ret;
 
+	/* if the bit is clear, return from here */
+	if (!(rtc_irq_bits & bit))
+		return 0;
+
 	val = rtc_irq_bits & ~bit;
 	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
 	if (ret == 0)
-- 
1.7.1.1

