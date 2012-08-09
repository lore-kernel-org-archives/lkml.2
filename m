Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031453Ab2HIPzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:55:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54143 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031351Ab2HIPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:54:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 7/8] mfd: Use the AB8500's IRQ domain to convert hwirq to virq
Date: Thu,  9 Aug 2012 16:53:54 +0100
Message-Id: <1344527635-6163-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the AB8500 had its own IRQ domain, the IRQ handler would take
the fired local IRQ (hwirq) and add it to the irq_base to convert it
to an IRQ number which Linux would understand (virq). However, the
IRQ base is not always used anymore since we can make use of Linear
domains. It's better to use the AB8500 hwirq -> virq mapping helper
function to convert them instead. That's what we do here.

CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 0c5b70f..71a7757 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -501,8 +501,9 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 		do {
 			int bit = __ffs(value);
 			int line = i * 8 + bit;
+			int virq = ab8500_irq_get_virq(ab8500, line);
 
-			handle_nested_irq(ab8500->irq_base + line);
+			handle_nested_irq(virq);
 			value &= ~(1 << bit);
 
 		} while (value);
-- 
1.7.9.5

