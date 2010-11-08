Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0KHIo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:44:56 -0500
Received: from smtp.nokia.com ([192.100.122.230]:60965 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab0KHIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 03:44:55 -0500
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        ext-eugeny.kuznetsov@nokia.com
Subject: [PATCHv3 1/1] omap: Ptr "isr_reg" tracked as NULL was dereferenced
Date: Mon,  8 Nov 2010 11:38:36 +0300
Message-Id: <cd6fa21776a4564d602cc072358a4bf79a9fe883.1289205105.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 08 Nov 2010 08:44:13.0184 (UTC) FILETIME=[1E754000:01CB7F21]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>

Value of "isr_reg" pointer is depend on configuration and GPIO method.
Potentially it may have NULL value and it is dereferenced later
in code. Warning and exit from function are added in this case.

Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
---
 arch/arm/plat-omap/gpio.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index c05c653..e0e2fa7 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -1318,6 +1318,10 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	if (bank->method == METHOD_GPIO_44XX)
 		isr_reg = bank->base + OMAP4_GPIO_IRQSTATUS0;
 #endif
+
+	if (WARN_ON(!isr_reg))
+		goto exit;
+
 	while(1) {
 		u32 isr_saved, level_mask = 0;
 		u32 enabled;
@@ -1377,6 +1381,7 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	configured, we must unmask the bank interrupt only after
 	handler(s) are executed in order to avoid spurious bank
 	interrupt */
+exit:
 	if (!unmasked)
 		desc->chip->unmask(irq);
 
-- 
1.6.3.3

