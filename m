Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2CFQOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:14:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2CFQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:14:05 -0500
Date: Tue, 6 Mar 2012 08:13:10 -0800
From: tip-bot for Michael Demeter <michael.demeter@intel.com>
Message-ID: <tip-4runmso4t49p4waz5gcvy0ux@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, alan@linux.intel.com,
        michael.demeter@intel.com, hpa@zytor.com, mingo@redhat.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        mika.westerberg@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, michael.demeter@intel.com,
        alan@linux.intel.com, mjg@redhat.com, linux-kernel@vger.kernel.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        mika.westerberg@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/mid/powerbtn: Use MSIC read/
 write instead of ipc_scu
Git-Commit-ID: 8bee7cea6c93b5514b672d1c347dad9960823f12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:13:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bee7cea6c93b5514b672d1c347dad9960823f12
Gitweb:     http://git.kernel.org/tip/8bee7cea6c93b5514b672d1c347dad9960823f12
Author:     Michael Demeter <michael.demeter@intel.com>
AuthorDate: Mon, 5 Mar 2012 15:01:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:01:26 +0100

x86/mid/powerbtn: Use MSIC read/write instead of ipc_scu

In the 2.6.36 kernel we did not have the MSIC driver.  Changed
all ipc_scu_reads/writes to use the MSIC driver and defines.
Added a fix from the 2.6.36 kernel where the SCU FW could send a
power button interrupt to the IA32 FW and the kernel was not
running yet.  This resulted in the interrupt not getting cleared
and the power button was ignored.  this fix just clears the
interrupt on start-up.

Signed-off-by: Michael Demeter <michael.demeter@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[ Revert style-only changes. Remove unused variable. Fix comment style. ]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-4runmso4t49p4waz5gcvy0ux@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/intel_mid_powerbtn.c |   32 +++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel_mid_powerbtn.c b/drivers/platform/x86/intel_mid_powerbtn.c
index f1ae507..0903a88 100644
--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -23,21 +23,27 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
-
-#include <asm/intel_scu_ipc.h>
+#include <linux/mfd/intel_msic.h>
 
 #define DRIVER_NAME "msic_power_btn"
 
-#define MSIC_PB_STATUS	0x3f
 #define MSIC_PB_LEVEL	(1 << 3) /* 1 - release, 0 - press */
 
+/*
+ * MSIC document ti_datasheet defines the 1st bit reg 0x21 is used to mask
+ * power button interrupt
+ */
+#define MSIC_PWRBTNM    (1 << 0)
+
 static irqreturn_t mfld_pb_isr(int irq, void *dev_id)
 {
 	struct input_dev *input = dev_id;
 	int ret;
 	u8 pbstat;
 
-	ret = intel_scu_ipc_ioread8(MSIC_PB_STATUS, &pbstat);
+	ret = intel_msic_reg_read(INTEL_MSIC_PBSTATUS, &pbstat);
+	dev_dbg(input->dev.parent, "PB_INT status= %d\n", pbstat);
+
 	if (ret < 0) {
 		dev_err(input->dev.parent, "Read error %d while reading"
 			       " MSIC_PB_STATUS\n", ret);
@@ -88,6 +94,24 @@ static int __devinit mfld_pb_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, input);
+
+	/*
+	 * SCU firmware might send power button interrupts to IA core before
+	 * kernel boots and doesn't get EOI from IA core. The first bit of
+	 * MSIC reg 0x21 is kept masked, and SCU firmware doesn't send new
+	 * power interrupt to Android kernel. Unmask the bit when probing
+	 * power button in kernel.
+	 * There is a very narrow race between irq handler and power button
+	 * initialization. The race happens rarely. So we needn't worry
+	 * about it.
+	 */
+	error = intel_msic_reg_update(INTEL_MSIC_IRQLVL1MSK, 0, MSIC_PWRBTNM);
+	if (error) {
+		dev_err(&pdev->dev, "Unable to clear power button interrupt, "
+				"error: %d\n", error);
+		goto err_free_irq;
+	}
+
 	return 0;
 
 err_free_irq:
