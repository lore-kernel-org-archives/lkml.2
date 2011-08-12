Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1HLIvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:51:36 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:54960 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524Ab1HLIvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:51:11 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Pawel Szyszuk <pawel.szyszuk@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 19/23] mfd/db5500-prcmu: implement reset and cause
Date: Fri, 12 Aug 2011 10:30:10 +0200
Message-ID: <1313137810-31213-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pawel Szyszuk <pawel.szyszuk@stericsson.com>

This implements the reset accessor function so that the DB5500
PRCMU can reset the system, and the corresponding accessor
to retrieve the cause of reset after a restart.

Signed-off-by: Pawel Szyszuk <pawel.szyszuk@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db5500-prcmu.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index 35a7a0c..60bfda2 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -27,6 +27,8 @@
 #include <mach/db5500-regs.h>
 #include "dbx500-prcmu-regs.h"
 
+#define PRCM_SW_RST_REASON (tcdm_base + 0xFF8) /* 2 bytes */
+
 #define _PRCM_MB_HEADER (tcdm_base + 0xFE8)
 #define PRCM_REQ_MB0_HEADER (_PRCM_MB_HEADER + 0x0)
 #define PRCM_REQ_MB1_HEADER (_PRCM_MB_HEADER + 0x1)
@@ -957,6 +959,29 @@ int db5500_prcmu_set_display_clocks(void)
 	return 0;
 }
 
+/**
+ * db5500_prcmu_system_reset - System reset
+ *
+ * Saves the reset reason code and then sets the APE_SOFTRST register which
+ * fires an interrupt to fw
+ */
+void db5500_prcmu_system_reset(u16 reset_code)
+{
+	writew(reset_code, PRCM_SW_RST_REASON);
+	writel(1, PRCM_APE_SOFTRST);
+}
+
+/**
+ * db5500_prcmu_get_reset_code - Retrieve SW reset reason code
+ *
+ * Retrieves the reset reason code stored by prcmu_system_reset() before
+ * last restart.
+ */
+u16 db5500_prcmu_get_reset_code(void)
+{
+	return readw(PRCM_SW_RST_REASON);
+}
+
 static void ack_dbb_wakeup(void)
 {
 	unsigned long flags;
-- 
1.7.3.2

