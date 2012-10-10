Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2JJPTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:19:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64154 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab2JJPTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:19:21 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/6] mfd: Differentiate between u8500 and u9540 TCDM address mapping
Date: Wed, 10 Oct 2012 16:18:55 +0100
Message-Id: <1349882335-6786-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
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
index 9d51585..fd0462a 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2670,7 +2670,7 @@ static int db8500_irq_init(struct device_node *np)
 
 void __init db8500_prcmu_early_init(void)
 {
-	if (cpu_is_u8500v2()) {
+	if (cpu_is_u8500v2() || cpu_is_u9540()) {
 		void *tcpm_base = ioremap_nocache(U8500_PRCMU_TCPM_BASE, SZ_4K);
 
 		if (tcpm_base != NULL) {
@@ -2688,7 +2688,11 @@ void __init db8500_prcmu_early_init(void)
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

