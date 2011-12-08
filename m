Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab1LHAli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:41:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:18938 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab1LHAlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:41:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83423669"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>,
        khali@linux-fr.org, guenter.roeck@ericsson.com
Subject: [PATCH 05/10] HWMON: Convert via-cputemp to x86 cpuid autoprobing
Date: Wed,  7 Dec 2011 16:41:18 -0800
Message-Id: <1323304882-27953-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use the new x86 cpuid autoprobe interface.

Cc: khali@linux-fr.org
Cc: guenter.roeck@ericsson.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/hwmon/via-cputemp.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index 8eac67d..36ddb83 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -37,6 +37,7 @@
 #include <linux/cpu.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
+#include <asm/cpu_device_id.h>
 
 #define DRVNAME	"via_cputemp"
 
@@ -308,34 +309,26 @@ static struct notifier_block via_cputemp_cpu_notifier __refdata = {
 	.notifier_call = via_cputemp_cpu_callback,
 };
 
+static struct x86_cpu_id cputemp_ids[] = {
+	{ X86_VENDOR_CENTAUR, 6, 0xa, }, /* C7a */
+	{ X86_VENDOR_CENTAUR, 6, 0xd, }, /* C7d */
+	{ X86_VENDOR_CENTAUR, 6, 0xf, }, /* Nano */
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, cputemp_ids);
+
 static int __init via_cputemp_init(void)
 {
 	int i, err;
 
-	if (cpu_data(0).x86_vendor != X86_VENDOR_CENTAUR) {
-		printk(KERN_DEBUG DRVNAME ": Not a VIA CPU\n");
-		err = -ENODEV;
-		goto exit;
-	}
+	if (!x86_match_cpu(cputemp_ids))
+		return -ENODEV;
 
 	err = platform_driver_register(&via_cputemp_driver);
 	if (err)
 		goto exit;
 
 	for_each_online_cpu(i) {
-		struct cpuinfo_x86 *c = &cpu_data(i);
-
-		if (c->x86 != 6)
-			continue;
-
-		if (c->x86_model < 0x0a)
-			continue;
-
-		if (c->x86_model > 0x0f) {
-			pr_warn("Unknown CPU model 0x%x\n", c->x86_model);
-			continue;
-		}
-
 		via_cputemp_device_add(i);
 	}
 
-- 
1.7.4.4

