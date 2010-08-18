Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0HRXDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:03:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:37213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab0HRXC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,229,1280732400"; 
   d="scan'208";a="546610547"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Rudolf Marek" <r.marek@assembler.cz>, "Huaxu Wan" <huaxu.wan@intel.com>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "Jean Delvare" <khali@linux-fr.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] drivers/hwmon/pkgtemp: Fix improper locking in CPU hot remove
Date: Wed, 18 Aug 2010 15:53:47 -0700
Message-Id: <1282172027-640-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

When a sibling is added to dev_list after a cpu is hot-removed, pdev_list_mutex
has been locked already. But pkgtemp_device_add() tries to lock pdev_list_mutex
again. This is incorrect. The patch fixes this issue.

The patch also removes __cpuinit for pkgtemp_device_add() to avoid section
mismatch warning.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 drivers/hwmon/pkgtemp.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
index 74157fc..928a016 100644
--- a/drivers/hwmon/pkgtemp.c
+++ b/drivers/hwmon/pkgtemp.c
@@ -276,7 +276,7 @@ struct pdev_entry {
 static LIST_HEAD(pdev_list);
 static DEFINE_MUTEX(pdev_list_mutex);
 
-static int __cpuinit pkgtemp_device_add(unsigned int cpu)
+static int pkgtemp_device_add(unsigned int cpu)
 {
 	int err;
 	struct platform_device *pdev;
@@ -341,26 +341,34 @@ static void pkgtemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p, *n;
 	unsigned int i;
-	int err;
 
-	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
 		if (p->cpu != cpu)
 			continue;
 
+		mutex_lock(&pdev_list_mutex);
 		platform_device_unregister(p->pdev);
 		list_del(&p->list);
 		kfree(p);
+		mutex_unlock(&pdev_list_mutex);
+		/*
+		 * Select one of removed cpu's siblings to represent sensor
+		 * for this package.
+		 * If there is no more running sibling in a package, the
+		 * package sensor for this package is not available to user
+		 * space any more.
+		 */
 		for_each_cpu(i, cpu_core_mask(cpu)) {
+			int err;
+
 			if (i != cpu) {
 				err = pkgtemp_device_add(i);
 				if (!err)
 					break;
 			}
 		}
-		break;
+		return;
 	}
-	mutex_unlock(&pdev_list_mutex);
 }
 
 static int __cpuinit pkgtemp_cpu_callback(struct notifier_block *nfb,
-- 
1.6.0.3

