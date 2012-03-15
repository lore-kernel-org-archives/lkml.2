Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031862Ab2COQp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:45:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52403 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031805Ab2COQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:44:30 -0400
From: jean.pihet@newoldbits.com
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 07/10] ARM: OMAP2+: SmartReflex: introduce a busy loop condition test macro
Date: Thu, 15 Mar 2012 17:44:02 +0100
Message-Id: <1331829845-9526-8-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Now that omap_test_timeout is only accessible from mach-omap2/,
introduce a similar function for SR.

This change makes the SmartReflex implementation ready for the move
to drivers/.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/mach-omap2/smartreflex.c |   12 ++++++------
 arch/arm/mach-omap2/smartreflex.h |   23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index dd80fde..ceb50b5 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -290,9 +290,9 @@ static void sr_v1_disable(struct omap_sr *sr)
 	 * Wait for SR to be disabled.
 	 * wait until ERRCONFIG.MCUDISACKINTST = 1. Typical latency is 1us.
 	 */
-	omap_test_timeout((sr_read_reg(sr, ERRCONFIG_V1) &
-			ERRCONFIG_MCUDISACKINTST), SR_DISABLE_TIMEOUT,
-			timeout);
+	sr_test_cond_timeout((sr_read_reg(sr, ERRCONFIG_V1) &
+			     ERRCONFIG_MCUDISACKINTST), SR_DISABLE_TIMEOUT,
+			     timeout);
 
 	if (timeout >= SR_DISABLE_TIMEOUT)
 		dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
@@ -335,9 +335,9 @@ static void sr_v2_disable(struct omap_sr *sr)
 	 * Wait for SR to be disabled.
 	 * wait until IRQSTATUS.MCUDISACKINTST = 1. Typical latency is 1us.
 	 */
-	omap_test_timeout((sr_read_reg(sr, IRQSTATUS) &
-			IRQSTATUS_MCUDISABLEACKINT), SR_DISABLE_TIMEOUT,
-			timeout);
+	sr_test_cond_timeout((sr_read_reg(sr, IRQSTATUS) &
+			     IRQSTATUS_MCUDISABLEACKINT), SR_DISABLE_TIMEOUT,
+			     timeout);
 
 	if (timeout >= SR_DISABLE_TIMEOUT)
 		dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
diff --git a/arch/arm/mach-omap2/smartreflex.h b/arch/arm/mach-omap2/smartreflex.h
index 8d3e3c2..3bd4fee 100644
--- a/arch/arm/mach-omap2/smartreflex.h
+++ b/arch/arm/mach-omap2/smartreflex.h
@@ -21,6 +21,7 @@
 #define __ASM_ARM_OMAP_SMARTREFLEX_H
 
 #include <linux/platform_device.h>
+#include <linux/delay.h>
 
 #include <plat/smartreflex.h>
 #include <plat/voltage.h>
@@ -144,6 +145,28 @@
 #define OMAP3430_SR_ERRMAXLIMIT		0x02
 
 /**
+ * test_cond_timeout - busy-loop, testing a condition
+ * @cond: condition to test until it evaluates to true
+ * @timeout: maximum number of microseconds in the timeout
+ * @index: loop index (integer)
+ *
+ * Loop waiting for @cond to become true or until at least @timeout
+ * microseconds have passed.  To use, define some integer @index in the
+ * calling code.  After running, if @index == @timeout, then the loop has
+ * timed out.
+ *
+ * Copied from omap_test_timeout
+ */
+#define sr_test_cond_timeout(cond, timeout, index)		\
+({								\
+	for (index = 0; index < timeout; index++) {		\
+		if (cond)					\
+			break;					\
+		udelay(1);					\
+	}							\
+})
+
+/**
  * struct omap_sr_pmic_data - Strucutre to be populated by pmic code to pass
  *				pmic specific info to smartreflex driver
  *
-- 
1.7.5.4

