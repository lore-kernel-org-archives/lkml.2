Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0JHFvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:51:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:3282 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab0JHFvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:51:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,301,1283756400"; 
   d="scan'208";a="845001990"
From: Chen Gong <gong.chen@linux.intel.com>
To: lm-sensors@lm-sensors.org
Cc: JBeulich@novell.com, guenter.roeck@ericsson.com,
        linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH V2 1/2] hwmon: uniform the init style of pkgtemp
Date: Fri,  8 Oct 2010 13:53:35 +0800
Message-Id: <1286517216-15640-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.2.2.173.g515cc
In-Reply-To: <1286517216-15640-1-git-send-email-gong.chen@linux.intel.com>
References: <1286517216-15640-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pkgtemp is derived from coretemp, so some reasonable
logics should be applied onto pkgtemp, too. Such as
the init logic here.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/hwmon/pkgtemp.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
index f119039..29fef42 100644
--- a/drivers/hwmon/pkgtemp.c
+++ b/drivers/hwmon/pkgtemp.c
@@ -35,6 +35,7 @@
 #include <linux/cpu.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
+#include <asm/smp.h>
 
 #define DRVNAME	"pkgtemp"
 
@@ -392,7 +393,6 @@ static struct notifier_block pkgtemp_cpu_notifier __refdata = {
 static int __init pkgtemp_init(void)
 {
 	int i, err = -ENODEV;
-	struct pdev_entry *p, *n;
 
 	/* quick check if we run Intel */
 	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
@@ -402,31 +402,25 @@ static int __init pkgtemp_init(void)
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
 
 #ifdef CONFIG_HOTPLUG_CPU
 	register_hotcpu_notifier(&pkgtemp_cpu_notifier);
 #endif
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

