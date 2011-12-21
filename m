Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1LUAJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:09:20 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51010 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1LUAJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:09:15 -0500
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org
Cc: Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>
Subject: [PATCH 2/3] cpuidle: fix error handling in __cpuidle_register_device
Date: Tue, 20 Dec 2011 16:09:06 -0800
Message-Id: <1324426147-16735-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1324426147-16735-1-git-send-email-ccross@android.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error handling in __cpuidle_register_device to include
the missing list_del.  Move it to a label, which will simplify
the error handling when coupled states are added.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/cpuidle.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 1486b3c..ea00a16 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -318,13 +318,18 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 
 	per_cpu(cpuidle_devices, dev->cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
-	if ((ret = cpuidle_add_sysfs(sys_dev))) {
-		module_put(cpuidle_driver->owner);
-		return ret;
-	}
+	ret = cpuidle_add_sysfs(sys_dev);
+	if (ret)
+		goto err_sysfs;
 
 	dev->registered = 1;
 	return 0;
+
+err_sysfs:
+	module_put(cpuidle_driver->owner);
+	list_del(&dev->device_list);
+	per_cpu(cpuidle_devices, dev->cpu) = NULL;
+	return ret;
 }
 
 /**
-- 
1.7.4.1

