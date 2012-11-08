Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab2KHG3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:29:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10139 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KHG3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:29:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 07 Nov 2012 22:29:45 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] gpio: tegra: read output value when gpio is set in direction_out
Date: Thu, 8 Nov 2012 11:57:27 +0530
Message-ID: <1352356047-24817-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read the output value when gpio is set for the output mode for
gpio_get_value(). Reading input value in direction out does not
give correct value.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpio-tegra.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index c7c175a..0fb2ce7 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -135,6 +135,12 @@ static void tegra_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 
 static int tegra_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
+	int bit_val = BIT(GPIO_BIT(offset));
+
+	/* If gpio is in output mode then read from the out value */
+	if (tegra_gpio_readl(GPIO_OE(offset)) & bit_val)
+		return !!(tegra_gpio_readl(GPIO_OUT(offset)) & bit_val);
+
 	return (tegra_gpio_readl(GPIO_IN(offset)) >> GPIO_BIT(offset)) & 0x1;
 }
 
-- 
1.7.1.1

