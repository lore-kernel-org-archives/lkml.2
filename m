Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1HSLzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:55:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44055 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1HSLzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:55:40 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH 4/4] AM3517: Fix suspend-resume sequence
Date: Fri, 19 Aug 2011 17:25:27 +0530
Message-ID: <1313754927-11992-5-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1313754927-11992-4-git-send-email-abhilash.kv@ti.com>
References: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com>
 <1313754927-11992-2-git-send-email-abhilash.kv@ti.com>
 <1313754927-11992-3-git-send-email-abhilash.kv@ti.com>
 <1313754927-11992-4-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the crash seen while resuming with i2c devices
enabled. This crash was happening because the interface-clocks
were disabled in the suspend sequence, and not re-enabled on
resumption.
The current patch saves the value of the CM_ICLKEN1_CORE register
before zeroing it out, and restores upon resumption. In AM3517 the
interface clocks are enabled by the clock module ONLY during
initialization, so the suspend sequence (in arch/arm/mach-omap2/
sleep3517.S) has to manually turn it off before executing wfi
and then back on again on returning from wfi, to ensure that all
interface clocks are enabled when control returns to omap_sram_idle()
after waking up from idle.

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Reviewed-by: Sanjeev Premi <premi@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/sleep3517.S |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/sleep3517.S b/arch/arm/mach-omap2/sleep3517.S
index 3fceefc..070a943 100644
--- a/arch/arm/mach-omap2/sleep3517.S
+++ b/arch/arm/mach-omap2/sleep3517.S
@@ -55,6 +55,9 @@ loop:
 
 	/* Disable SDRC and Control Module */
 	ldr     r4, cm_iclken1_core
+	ldr     r5, [r4]
+	str     r5, iclk_core_enable
+	ldr     r4, cm_iclken1_core
 	ldr     r5, clk_core_disable
 	str     r5, [r4]
 wait_sdrc_ok:
@@ -108,7 +111,7 @@ wait_sdrc_ok:
 clk_core_disable:
 	.word   0x0
 iclk_core_enable:
-	.word   0x42
+	.word   0x0
 emif_phy_gate:
 	.word   0x2620
 emif_phy_enable:
-- 
1.7.1

