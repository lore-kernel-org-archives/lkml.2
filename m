Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1LTB3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:29:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49797 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1LTB3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:29:47 -0500
Date: Mon, 19 Dec 2011 17:29:37 -0800
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-10b85d6c159658e912730efa9cd787a607f1ad6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1324338394-4670-7-git-send-email-andi@firstfloor.org>
References: <1324338394-4670-7-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/autoprobe] x86, hwmon:
  Convert coretemp to x86 cpuid autoprobing
Git-Commit-ID: 10b85d6c159658e912730efa9cd787a607f1ad6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Dec 2011 17:29:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10b85d6c159658e912730efa9cd787a607f1ad6c
Gitweb:     http://git.kernel.org/tip/10b85d6c159658e912730efa9cd787a607f1ad6c
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 19 Dec 2011 15:46:32 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Dec 2011 15:49:55 -0800

x86, hwmon: Convert coretemp to x86 cpuid autoprobing

Use the new x86 cpuid autoprobe interface for the Intel coretemp
driver.

Cc: fenghua.yu@intel.com
Cc: khali@linux-fr.org
Cc: guenter.roeck@ericsson.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1324338394-4670-7-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/hwmon/coretemp.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 104b376..b965f80 100644
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
 
+static const struct x86_cpu_id coretemp_ids[] = {
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
