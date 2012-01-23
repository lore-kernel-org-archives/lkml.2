Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2AWHrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 02:47:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2249 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2AWHrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 02:47:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 22 Jan 2012 23:47:18 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: sameo@linux.intel.com, jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V2] mfd: tps65910: Add wakeup support
Date: Mon, 23 Jan 2012 13:16:15 +0530
Message-Id: <1327304775-12202-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementing irq_set_wake() so that device should able
to wakeup the system through different interrupt provided
by this device like gpios, onkey, rtc etc.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
As discussed on patch V1, the device should call the api 
device_set_wakeup_capable() to expose proper sysfs interface
to userspace to choose the wakeup enable/disable by application.
Then before suspend, driver need to check whether user application
have selected wakeup enabled or not through device_may_wakeup()
and accordingly call the enable_irq_wake().
The above code should be implemented in rtc/onkey or gpio-
client driver to provide proper sysfs interface if require and call
the enable_irq_wake() accordingly.
This patch will just implement the api require to enable the 
wakeup through interrupt from this device.

 drivers/mfd/tps65910-irq.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index a56be93..0c13042 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -145,12 +145,23 @@ static void tps65910_irq_disable(struct irq_data *data)
 	tps65910->irq_mask |= ( 1 << irq_to_tps65910_irq(tps65910, data->irq));
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int tps65910_irq_set_wake(struct irq_data *data, unsigned int enable)
+{
+	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
+	return irq_set_irq_wake(tps65910->chip_irq, enable);
+}
+#else
+#define tps65910_irq_set_wake NULL
+#endif
+
 static struct irq_chip tps65910_irq_chip = {
 	.name = "tps65910",
 	.irq_bus_lock = tps65910_irq_lock,
 	.irq_bus_sync_unlock = tps65910_irq_sync_unlock,
 	.irq_disable = tps65910_irq_disable,
 	.irq_enable = tps65910_irq_enable,
+	.irq_set_wake = tps65910_irq_set_wake,
 };
 
 int tps65910_irq_init(struct tps65910 *tps65910, int irq,
-- 
1.7.1.1

