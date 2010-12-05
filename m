Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab0LEXN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:13:56 -0500
Received: from smtp-out.google.com ([74.125.121.35]:58463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab0LEXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:10:04 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@google.com>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/21] ARM: tegra: gpio: Add support for waking from suspend
Date: Sun,  5 Dec 2010 15:09:03 -0800
Message-Id: <1291590548-7341-17-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291590548-7341-1-git-send-email-ccross@android.com>
References: <1291590548-7341-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@google.com>

Signed-off-by: Colin Cross <ccross@google.com>
---
 arch/arm/mach-tegra/gpio.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/gpio.c b/arch/arm/mach-tegra/gpio.c
index 1bf92e5..0187aaa 100644
--- a/arch/arm/mach-tegra/gpio.c
+++ b/arch/arm/mach-tegra/gpio.c
@@ -212,6 +212,9 @@ static int tegra_gpio_irq_set_type(unsigned int irq, unsigned int type)
 	else if (type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		__set_irq_handler_unlocked(irq, handle_edge_irq);
 
+	if (tegra_get_suspend_mode() == TEGRA_SUSPEND_LP0)
+		tegra_set_lp0_wake_type(irq, type);
+
 	return 0;
 }
 
@@ -319,8 +322,17 @@ void tegra_gpio_suspend(void)
 
 static int tegra_gpio_wake_enable(unsigned int irq, unsigned int enable)
 {
+	int ret;
 	struct tegra_gpio_bank *bank = get_irq_chip_data(irq);
-	return set_irq_wake(bank->irq, enable);
+
+	ret = tegra_set_lp1_wake(bank->irq, enable);
+	if (ret)
+		return ret;
+
+	if (tegra_get_suspend_mode() == TEGRA_SUSPEND_LP0)
+		return tegra_set_lp0_wake(irq, enable);
+
+	return 0;
 }
 #endif
 
-- 
1.7.3.1

