Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2KSSbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:31:40 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46848 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2KSSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:31:36 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V3 09/11] ARM: samsung: register syscore_ops for timer resume directly
Date: Mon, 19 Nov 2012 11:31:05 -0700
Message-Id: <1353349867-28494-10-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
References: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
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
 1 file changed, 6 insertions(+), 1 deletion(-)

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
1.7.10.4

