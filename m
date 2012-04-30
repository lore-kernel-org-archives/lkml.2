Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2D3UJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:09:26 -0400
Received: from mail-vx0-f202.google.com ([209.85.220.202]:48499 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab2D3UJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:09:20 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-pm@lists.linux-foundation.org,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>
Subject: [PATCHv3 2/5] cpuidle: fix error handling in __cpuidle_register_device
Date: Mon, 30 Apr 2012 13:09:08 -0700
Message-Id: <1335816551-27756-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1335816551-27756-1-git-send-email-ccross@android.com>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error handling in __cpuidle_register_device to include
the missing list_del.  Move it to a label, which will simplify
the error handling when coupled states are added.

Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Tested-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/cpuidle.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 3e3e3e4..4540672 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -403,13 +403,18 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 
 	per_cpu(cpuidle_devices, dev->cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
-	if ((ret = cpuidle_add_sysfs(cpu_dev))) {
-		module_put(cpuidle_driver->owner);
-		return ret;
-	}
+	ret = cpuidle_add_sysfs(cpu_dev);
+	if (ret)
+		goto err_sysfs;
 
 	dev->registered = 1;
 	return 0;
+
+err_sysfs:
+	list_del(&dev->device_list);
+	per_cpu(cpuidle_devices, dev->cpu) = NULL;
+	module_put(cpuidle_driver->owner);
+	return ret;
 }
 
 /**
-- 
1.7.7.3

