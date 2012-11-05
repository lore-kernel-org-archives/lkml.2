Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab2KEPLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:11:10 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47971 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab2KEPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:11:05 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 8/8] mfd: Differentiate between u8500 and u9540 TCDM address mapping
Date: Mon,  5 Nov 2012 16:10:36 +0100
Message-Id: <1352128236-11554-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352128236-11554-1-git-send-email-lee.jones@linaro.org>
References: <1352128236-11554-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TCDM mappings are quite different from u8500 to u9540. If these
aren't correctly specified for a given board, it will fail to boot.
Here we add the correct TCDM base for the u9540.

Please note that although this patch allows us to boot the u9540,
it doesn't provide us with full enablement. For that, another
patch-set will follow which completely re-vamps the way the PRCMU
is passed TCDM mappings.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index e91a6e6..70898c9 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2757,7 +2757,7 @@ static int db8500_irq_init(struct device_node *np)
 
 void __init db8500_prcmu_early_init(void)
 {
-	if (cpu_is_u8500v2()) {
+	if (cpu_is_u8500v2() || cpu_is_u9540()) {
 		void *tcpm_base = ioremap_nocache(U8500_PRCMU_TCPM_BASE, SZ_4K);
 
 		if (tcpm_base != NULL) {
@@ -2775,7 +2775,11 @@ void __init db8500_prcmu_early_init(void)
 			iounmap(tcpm_base);
 		}
 
-		tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
+		if (cpu_is_u9540())
+			tcdm_base = ioremap_nocache(U8500_PRCMU_TCDM_BASE,
+						SZ_4K + SZ_8K) + SZ_8K;
+		else
+			tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
 	} else {
 		pr_err("prcmu: Unsupported chip version\n");
 		BUG();
-- 
1.7.9.5

