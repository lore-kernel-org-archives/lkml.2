Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab1LHAm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:42:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:13722 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909Ab1LHAlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:41:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="84106917"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>,
        fenghua.yu@intel.com, khali@linux-fr.org, guenter.roeck@ericsson.com
Subject: [PATCH 06/10] HWMON: Convert coretemp to x86 cpuid autoprobing
Date: Wed,  7 Dec 2011 16:41:19 -0800
Message-Id: <1323304882-27953-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use the new x86 cpuid autoprobe interface for the Intel coretemp
driver.

Cc: fenghua.yu@intel.com
Cc: khali@linux-fr.org
Cc: guenter.roeck@ericsson.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/hwmon/coretemp.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 104b376..5de1579 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -39,6 +39,7 @@
 #include <linux/moduleparam.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
+#include <asm/cpu_device_id.h>
 
 #define DRVNAME	"coretemp"
 
@@ -756,13 +757,23 @@ static struct notifier_block coretemp_cpu_notifier __refdata = {
 	.notifier_call = coretemp_cpu_callback,
 };
 
+static struct x86_cpu_id coretemp_ids[] = {
+	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTS },
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, coretemp_ids);
+
 static int __init coretemp_init(void)
 {
 	int i, err = -ENODEV;
 
-	/* quick check if we run Intel */
-	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
-		goto exit;
+	/*
+	 * CPUID.06H.EAX[0] indicates whether the CPU has thermal
+	 * sensors. We check this bit only, all the early CPUs
+	 * without thermal sensors will be filtered out.
+	 */
+	if (!x86_match_cpu(coretemp_ids))
+		return -ENODEV;
 
 	err = platform_driver_register(&coretemp_driver);
 	if (err)
-- 
1.7.4.4

