Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2JWGRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:17:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53760 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab2JWGR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:17:26 -0400
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org
Cc: mturquette@linaro.org, Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH 2/4] MIPS: Loongson1B: improve ls1x_serial_setup()
Date: Tue, 23 Oct 2012 14:17:01 +0800
Message-Id: <1350973023-7667-3-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350973023-7667-1-git-send-email-keguang.zhang@gmail.com>
References: <1350973023-7667-1-git-send-email-keguang.zhang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve ls1x_serial_setup().

Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
---
 arch/mips/include/asm/mach-loongson1/platform.h |    2 +-
 arch/mips/loongson1/common/platform.c           |    9 +++++----
 arch/mips/loongson1/ls1b/board.c                |    5 +----
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/mips/include/asm/mach-loongson1/platform.h b/arch/mips/include/asm/mach-loongson1/platform.h
index f584017..718a122 100644
--- a/arch/mips/include/asm/mach-loongson1/platform.h
+++ b/arch/mips/include/asm/mach-loongson1/platform.h
@@ -19,6 +19,6 @@ extern struct platform_device ls1x_ehci_device;
 extern struct platform_device ls1x_rtc_device;
 
 extern void __init ls1x_clk_init(void);
-void ls1x_serial_setup(void);
+extern void __init ls1x_serial_setup(struct platform_device *pdev);
 
 #endif /* __ASM_MACH_LOONGSON1_PLATFORM_H */
diff --git a/arch/mips/loongson1/common/platform.c b/arch/mips/loongson1/common/platform.c
index e92d59c..5ca38dc 100644
--- a/arch/mips/loongson1/common/platform.c
+++ b/arch/mips/loongson1/common/platform.c
@@ -42,16 +42,17 @@ struct platform_device ls1x_uart_device = {
 	},
 };
 
-void __init ls1x_serial_setup(void)
+void __init ls1x_serial_setup(struct platform_device *pdev)
 {
 	struct clk *clk;
 	struct plat_serial8250_port *p;
 
-	clk = clk_get(NULL, "dc");
+	clk = clk_get(NULL, pdev->name);
 	if (IS_ERR(clk))
-		panic("unable to get dc clock, err=%ld", PTR_ERR(clk));
+		panic("unable to get %s clock, err=%ld",
+			pdev->name, PTR_ERR(clk));
 
-	for (p = ls1x_serial8250_port; p->flags != 0; ++p)
+	for (p = pdev->dev.platform_data; p->flags != 0; ++p)
 		p->uartclk = clk_get_rate(clk);
 }
 
diff --git a/arch/mips/loongson1/ls1b/board.c b/arch/mips/loongson1/ls1b/board.c
index 295b1be..1fbd526 100644
--- a/arch/mips/loongson1/ls1b/board.c
+++ b/arch/mips/loongson1/ls1b/board.c
@@ -9,9 +9,6 @@
 
 #include <platform.h>
 
-#include <linux/serial_8250.h>
-#include <loongson1.h>
-
 static struct platform_device *ls1b_platform_devices[] __initdata = {
 	&ls1x_uart_device,
 	&ls1x_eth0_device,
@@ -23,7 +20,7 @@ static int __init ls1b_platform_init(void)
 {
 	int err;
 
-	ls1x_serial_setup();
+	ls1x_serial_setup(&ls1x_uart_device);
 
 	err = platform_add_devices(ls1b_platform_devices,
 				   ARRAY_SIZE(ls1b_platform_devices));
-- 
1.7.1

