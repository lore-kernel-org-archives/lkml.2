Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2HFH72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 03:59:28 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:18244 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab2HFH7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 03:59:21 -0400
X-SBRS: None
From: Peter Huewe <peter.huewe@infineon.com>
To: Kent Yoder <key@linux.vnet.ibm.com>, <jmorris@namei.org>
CC: <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>, Bryan Freed <bfreed@chromium.org>,
        David Safford <safford@linux.vnet.ibm.com>, <hpa@linux.intel.com>,
        Peter Huewe <peter.huewe@infineon.com>
Subject: [PATCH] char/tpm: Use struct dev_pm_ops for power management.
Date: Mon, 6 Aug 2012 09:58:59 +0200
Message-ID: <1344239939-5752-1-git-send-email-peter.huewe@infineon.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <20120803203836.GA11918@linux.vnet.ibm.com>
References: <20120803203836.GA11918@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.170.142]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the tpm_i2c_infineon driver define its PM callbacks trough a
struct dev_pm_ops by using SIMPLE_DEV_PM_OPS instead of coding it
explicitly.

This simplifies the code and allows the driver to use tpm_pm_suspend()
and tpm_pm_resume() as its PM callbacks directly, without defining its
own PM callback routines.

Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
---
Thanks Kent and Rafael - much better this way ;)

 drivers/char/tpm/tpm_i2c_infineon.c |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 1794a09..65761b6 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -655,35 +655,7 @@ static const struct i2c_device_id tpm_tis_i2c_table[] = {
 };
 
 MODULE_DEVICE_TABLE(i2c, tpm_tis_i2c_table);
-
-#ifdef CONFIG_PM
-/* NOTE:
- * Suspend does currently not work Nvidias Tegra2 Platform
- * but works fine on Beagleboard (arm omap).
- *
- * This function will block System Suspend if TPM is not initialized,
- * however the TPM is usually initialized by BIOS/u-boot or by sending
- * a TPM_Startup command.
- */
-static int tpm_tis_i2c_suspend(struct device *dev)
-{
-	return tpm_pm_suspend(dev, dev->power.power_state);
-}
-
-static int tpm_tis_i2c_resume(struct device *dev)
-{
-	return tpm_pm_resume(dev);
-}
-
-static const struct dev_pm_ops tpm_tis_i2c_ops = {
-	.suspend = tpm_tis_i2c_suspend,
-	.resume = tpm_tis_i2c_resume,
-};
-#else
-#define tpm_tis_i2c_suspend NULL
-#define tpm_tis_i2c_resume NULL
-#define tpm_tis_i2c_ops NULL
-#endif
+static SIMPLE_DEV_PM_OPS(tpm_tis_i2c_ops, tpm_pm_suspend, tpm_pm_resume);
 
 static int __devinit tpm_tis_i2c_probe(struct i2c_client *client,
 			     const struct i2c_device_id *id)
-- 
1.7.6.msysgit.0

