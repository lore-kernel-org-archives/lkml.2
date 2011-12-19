Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1LSXqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:46:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:16645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1LSXqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:46:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="89277675"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, trenn@suse.de, kay.sievers@vrf.org,
        Andi Kleen <ak@linux.intel.com>, khali@linux-fr.org,
        guenter.roeck@ericsson.com
Subject: [PATCH 5/8] HWMON: Convert via-cputemp to x86 cpuid autoprobing
Date: Mon, 19 Dec 2011 15:46:31 -0800
Message-Id: <1324338394-4670-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use the new x86 cpuid autoprobe interface.

Cc: khali@linux-fr.org
Cc: guenter.roeck@ericsson.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/hwmon/via-cputemp.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index 8eac67d..8689664 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -37,6 +37,7 @@
 #include <linux/cpu.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
+#include <asm/cpu_device_id.h>
 
 #define DRVNAME	"via_cputemp"
 
@@ -308,15 +309,20 @@ static struct notifier_block via_cputemp_cpu_notifier __refdata = {
 	.notifier_call = via_cputemp_cpu_callback,
 };
 
+static const struct x86_cpu_id cputemp_ids[] = {
+	{ X86_VENDOR_CENTAUR, 6, 0xa, }, /* C7 A */
+	{ X86_VENDOR_CENTAUR, 6, 0xd, }, /* C7 D */
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
-- 
1.7.7.4

