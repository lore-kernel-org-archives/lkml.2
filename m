Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab0IZF5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 01:57:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:60912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab0IZF5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 01:57:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,237,1283756400"; 
   d="scan'208";a="840982116"
From: Chen Gong <gong.chen@linux.intel.com>
To: lm-sensors@lm-sensors.org
Cc: JBeulich@novell.com, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 1/2] hwmon: uniform the init style of pkgtemp
Date: Sun, 26 Sep 2010 13:59:59 +0800
Message-Id: <1285480800-14558-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.2.2.173.g515cc
In-Reply-To: <1285480800-14558-1-git-send-email-gong.chen@linux.intel.com>
References: <1285480800-14558-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pkgtemp is derived from coretemp, so some reasonable
logics should be applied onto pkgtemp, too. Such as
the init logic here.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/hwmon/pkgtemp.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
index f119039..6186041 100644
--- a/drivers/hwmon/pkgtemp.c
+++ b/drivers/hwmon/pkgtemp.c
@@ -392,7 +392,6 @@ static struct notifier_block pkgtemp_cpu_notifier __refdata = {
 static int __init pkgtemp_init(void)
 {
 	int i, err = -ENODEV;
-	struct pdev_entry *p, *n;
 
 	/* quick check if we run Intel */
 	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
@@ -402,31 +401,23 @@ static int __init pkgtemp_init(void)
 	if (err)
 		goto exit;
 
-	for_each_online_cpu(i) {
-		err = pkgtemp_device_add(i);
-		if (err)
-			goto exit_devices_unreg;
-	}
+	for_each_online_cpu(i)
+		pkgtemp_device_add(i);
+
+#ifndef CONFIG_HOTPLUG_CPU
 	if (list_empty(&pdev_list)) {
 		err = -ENODEV;
 		goto exit_driver_unreg;
 	}
+#endif
 
-#ifdef CONFIG_HOTPLUG_CPU
 	register_hotcpu_notifier(&pkgtemp_cpu_notifier);
-#endif
 	return 0;
 
-exit_devices_unreg:
-	mutex_lock(&pdev_list_mutex);
-	list_for_each_entry_safe(p, n, &pdev_list, list) {
-		platform_device_unregister(p->pdev);
-		list_del(&p->list);
-		kfree(p);
-	}
-	mutex_unlock(&pdev_list_mutex);
+#ifndef CONFIG_HOTPLUG_CPU
 exit_driver_unreg:
 	platform_driver_unregister(&pkgtemp_driver);
+#endif
 exit:
 	return err;
 }
-- 
1.7.2.2.173.g515cc

