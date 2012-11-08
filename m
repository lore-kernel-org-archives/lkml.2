Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878Ab2KHVDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:03:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52628 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789Ab2KHVC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:29 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 09/11] ARM: samsung: register syscore_ops for timer resume directly
Date: Thu,  8 Nov 2012 14:01:54 -0700
Message-Id: <1352408516-21988-11-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Instead of using struct sys_timer's resume function, register syscore_ops
directly in s3c2410_timer_init(). This will allow the sys_timer suspend/
resume fields to be removed, and eventually lead to a complete removal of
struct sys_timer.

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/plat-samsung/time.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-samsung/time.c b/arch/arm/plat-samsung/time.c
index 67206df..773745a 100644
--- a/arch/arm/plat-samsung/time.c
+++ b/arch/arm/plat-samsung/time.c
@@ -27,6 +27,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/mach-types.h>
 
@@ -271,6 +272,10 @@ static void __init s3c2410_timer_resources(void)
 	clk_enable(tin);
 }
 
+static struct syscore_ops s3c24xx_syscore_ops = {
+	.resume		= s3c2410_timer_setup,
+};
+
 static void __init s3c2410_timer_init(void)
 {
 	arch_gettimeoffset = s3c2410_gettimeoffset;
@@ -278,9 +283,9 @@ static void __init s3c2410_timer_init(void)
 	s3c2410_timer_resources();
 	s3c2410_timer_setup();
 	setup_irq(IRQ_TIMER4, &s3c2410_timer_irq);
+	register_syscore_ops(&s3c24xx_syscore_ops);
 }
 
 struct sys_timer s3c24xx_timer = {
 	.init		= s3c2410_timer_init,
-	.resume		= s3c2410_timer_setup
 };
-- 
1.7.0.4

