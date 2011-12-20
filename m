Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1LTB3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:29:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49789 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1LTB3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:29:01 -0500
Date: Mon, 19 Dec 2011 17:28:50 -0800
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-12ea04ef68d6d4c6f843e4041008bb3ba29846b9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1324338394-4670-6-git-send-email-andi@firstfloor.org>
References: <1324338394-4670-6-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/autoprobe] x86, hwmon:
  Convert via-cputemp to x86 cpuid autoprobing
Git-Commit-ID: 12ea04ef68d6d4c6f843e4041008bb3ba29846b9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Dec 2011 17:28:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12ea04ef68d6d4c6f843e4041008bb3ba29846b9
Gitweb:     http://git.kernel.org/tip/12ea04ef68d6d4c6f843e4041008bb3ba29846b9
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 19 Dec 2011 15:46:31 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Dec 2011 15:49:50 -0800

x86, hwmon: Convert via-cputemp to x86 cpuid autoprobing

Use the new x86 cpuid autoprobe interface.

Cc: khali@linux-fr.org
Cc: guenter.roeck@ericsson.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1324338394-4670-6-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
