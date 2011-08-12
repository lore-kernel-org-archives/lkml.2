Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1HLI3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:29:04 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54040 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab1HLI26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:28:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Jonas Aberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/23] mfd/db8500-prcmu: add watchdog accessor functions
Date: Fri, 12 Aug 2011 10:28:33 +0200
Message-ID: <1313137713-30848-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aberg <jonas.aberg@stericsson.com>

This implements the watchdog accessor functions for the DB8500
PRCMU, making it possible to implement the watchdog driver.

Signed-off-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   72 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 28a6090..95498f8 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1543,6 +1543,78 @@ int prcmu_stop_temp_sense(void)
 	return config_hot_period(0xFFFF);
 }
 
+static int prcmu_a9wdog(u8 cmd, u8 d0, u8 d1, u8 d2, u8 d3)
+{
+
+	mutex_lock(&mb4_transfer.lock);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
+		cpu_relax();
+
+	writeb(d0, (tcdm_base + PRCM_REQ_MB4_A9WDOG_0));
+	writeb(d1, (tcdm_base + PRCM_REQ_MB4_A9WDOG_1));
+	writeb(d2, (tcdm_base + PRCM_REQ_MB4_A9WDOG_2));
+	writeb(d3, (tcdm_base + PRCM_REQ_MB4_A9WDOG_3));
+
+	writeb(cmd, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+
+	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
+	wait_for_completion(&mb4_transfer.work);
+
+	mutex_unlock(&mb4_transfer.lock);
+
+	return 0;
+
+}
+
+int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
+{
+	BUG_ON(num == 0 || num > 0xf);
+	return prcmu_a9wdog(MB4H_A9WDOG_CONF, num, 0, 0,
+			    sleep_auto_off ? A9WDOG_AUTO_OFF_EN :
+			    A9WDOG_AUTO_OFF_DIS);
+}
+
+int prcmu_enable_a9wdog(u8 id)
+{
+	return prcmu_a9wdog(MB4H_A9WDOG_EN, id, 0, 0, 0);
+}
+
+int prcmu_disable_a9wdog(u8 id)
+{
+	return prcmu_a9wdog(MB4H_A9WDOG_DIS, id, 0, 0, 0);
+}
+
+int prcmu_kick_a9wdog(u8 id)
+{
+	return prcmu_a9wdog(MB4H_A9WDOG_KICK, id, 0, 0, 0);
+}
+
+/*
+ * timeout is 28 bit, in ms.
+ */
+#define MAX_WATCHDOG_TIMEOUT 131000
+int prcmu_load_a9wdog(u8 id, u32 timeout)
+{
+	if (timeout > MAX_WATCHDOG_TIMEOUT)
+		/*
+		 * Due to calculation bug in prcmu fw, timeouts
+		 * can't be bigger than 131 seconds.
+		 */
+		return -EINVAL;
+
+	return prcmu_a9wdog(MB4H_A9WDOG_LOAD,
+			    (id & A9WDOG_ID_MASK) |
+			    /*
+			     * Put the lowest 28 bits of timeout at
+			     * offset 4. Four first bits are used for id.
+			     */
+			    (u8)((timeout << 4) & 0xf0),
+			    (u8)((timeout >> 4) & 0xff),
+			    (u8)((timeout >> 12) & 0xff),
+			    (u8)((timeout >> 20) & 0xff));
+}
+
 /**
  * prcmu_set_clock_divider() - Configure the clock divider.
  * @clock:	The clock for which the request is made.
-- 
1.7.3.2

