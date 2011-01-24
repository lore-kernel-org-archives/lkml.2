Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1AXCIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:08:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42930 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1AXCB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:01:59 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/28] ARM: tegra: gpio: Add support for waking from suspend
Date: Sun, 23 Jan 2011 18:01:22 -0800
Message-Id: <1295834493-5019-18-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/gpio.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/gpio.c b/arch/arm/mach-tegra/gpio.c
index 132dcd6..5d14ccc 100644
--- a/arch/arm/mach-tegra/gpio.c
+++ b/arch/arm/mach-tegra/gpio.c
@@ -212,6 +212,9 @@ static int tegra_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	else if (type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		__set_irq_handler_unlocked(d->irq, handle_edge_irq);
 
+	if (tegra_get_suspend_mode() == TEGRA_SUSPEND_LP0)
+		tegra_set_lp0_wake_type(d->irq, type);
+
 	return 0;
 }
 
@@ -319,8 +322,17 @@ void tegra_gpio_suspend(void)
 
 static int tegra_gpio_wake_enable(struct irq_data *d, unsigned int enable)
 {
+	int ret;
 	struct tegra_gpio_bank *bank = irq_data_get_irq_chip_data(d);
-	return set_irq_wake(bank->irq, enable);
+
+	ret = tegra_set_lp1_wake(bank->irq, enable);
+	if (ret)
+		return ret;
+
+	if (tegra_get_suspend_mode() == TEGRA_SUSPEND_LP0)
+		return tegra_set_lp0_wake(d->irq, enable);
+
+	return 0;
 }
 #endif
 
-- 
1.7.3.1

