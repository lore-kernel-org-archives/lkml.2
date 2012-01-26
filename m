Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2AZR04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:26:56 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55303 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2AZR0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:26:55 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] intel_mid_powerbtn: use MSIC read/write instead of ipc_scu
To: mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Jan 2012 17:40:27 +0000
Message-ID: <20120126174021.16810.63743.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Demeter <michael.demeter@intel.com>

In the 2.6.36 kernel we did not have the MSIC driver. Changed
all ipc_scu_reads/writes to use the MSIC driver and defines.
Added a fix from the 2.6.36 kernel where the SCU FW could send
a power button interrupt to the IA32 FW and the kernel was not
running yet. This resulted in the interrupt not getting cleared
and the power button was ignored. this fix just clears the
interrupt on start-up.

Signed-off-by: Michael Demeter <michael.demeter@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Revert style-only changes. Remove unused variable. Fix comment style.]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/platform/x86/intel_mid_powerbtn.c |   32 +++++++++++++++++++++++++----
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

