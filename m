Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab1JFS2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:28:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62341 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759004Ab1JFS1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:27:41 -0400
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: ben-linux@fluff.org, Octavian Purdila <octavian.purdila@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 13/13] i2c-designware: Fix PCI core warning on suspend/resume
Date: Thu,  6 Oct 2011 11:26:37 -0700
Message-Id: <1317925597-32245-14-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1317925597-32245-1-git-send-email-dirk.brandewie@gmail.com>
References: <1317925597-32245-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Octavian Purdila <octavian.purdila@intel.com>

PCI core warns if the legacy PM and new PM functions are
present. Update the driver to only use the new power management
framework.

This patch fixes the following warning seen during suspend/resume:

<7>[   24.193850] i2c-designware-pci 0000:08:13.0: suspend
<4>[   24.193866] ------------[ cut here ]------------
<4>[   24.193892] WARNING: at drivers/pci/pci-driver.c:605 pci_has_legacy_pm_support+0x48/0x4d()
<4>[   24.193925] Hardware name: OakTrail
<4>[   24.193936] Modules linked in:
<4>[   24.193958] Pid: 2834, comm: kworker/u:22 Tainted: G        W   2.6.36greenridge-01402-gc8047e6 #171
<4>[   24.193974] Call Trace:
<4>[   24.193999]  [<c1033a93>] warn_slowpath_common+0x66/0xc2
<4>[   24.194025]  [<c1164143>] ? pci_has_legacy_pm_support+0x48/0x4d
<4>[   24.194052]  [<c1033afe>] warn_slowpath_null+0xf/0x13
<4>[   24.194079]  [<c1164143>] pci_has_legacy_pm_support+0x48/0x4d
<4>[   24.194106]  [<c11643ff>] pci_pm_suspend+0x22/0x154
<4>[   24.194131]  [<c11643dd>] ? pci_pm_suspend+0x0/0x154
<4>[   24.194156]  [<c11e8a7a>] pm_op+0x3e/0x95
<4>[   24.194182]  [<c11e931d>] __device_suspend+0x12e/0x194
<4>[   24.194208]  [<c11e974d>] ? dpm_drv_timeout+0x0/0x47
<4>[   24.194237]  [<c11e9729>] async_suspend+0x16/0x3a
<4>[   24.194265]  [<c104de8e>] async_run_entry_fn+0x97/0x135
<4>[   24.194291]  [<c1043c34>] process_one_work+0x1c9/0x2db

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c |   29 +++++++--------------------
 1 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index d2223b5..9e89e73 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -138,8 +138,9 @@ static struct i2c_algorithm i2c_dw_algo = {
 	.functionality	= i2c_dw_func,
 };
 
-static int i2c_dw_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
+static int i2c_dw_pci_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
 	struct dw_i2c_dev *i2c = pci_get_drvdata(pdev);
 	int err;
 
@@ -161,15 +162,9 @@ static int i2c_dw_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 	return 0;
 }
 
-static int i2c_dw_pci_runtime_suspend(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	dev_dbg(dev, "PCI suspend called\n");
-	return i2c_dw_pci_suspend(pdev, PMSG_SUSPEND);
-}
-
-static int i2c_dw_pci_resume(struct pci_dev *pdev)
+static int i2c_dw_pci_resume(struct device *dev)
 {
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
 	struct dw_i2c_dev *i2c = pci_get_drvdata(pdev);
 	int err;
 	u32 enabled;
@@ -191,13 +186,6 @@ static int i2c_dw_pci_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-static int i2c_dw_pci_runtime_resume(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	dev_dbg(dev, "runtime_resume called\n");
-	return i2c_dw_pci_resume(pdev);
-}
-
 static int i2c_dw_pci_runtime_idle(struct device *dev)
 {
 	int err = pm_schedule_suspend(dev, 500);
@@ -209,9 +197,10 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
 }
 
 static const struct dev_pm_ops i2c_dw_pm_ops = {
-	.runtime_suspend = i2c_dw_pci_runtime_suspend,
-	.runtime_resume = i2c_dw_pci_runtime_resume,
-	.runtime_idle = i2c_dw_pci_runtime_idle,
+	.resume         = i2c_dw_pci_resume,
+	.suspend        = i2c_dw_pci_suspend,
+	SET_RUNTIME_PM_OPS(i2c_dw_pci_suspend, i2c_dw_pci_resume,
+			   i2c_dw_pci_runtime_idle)
 };
 
 static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
@@ -381,8 +370,6 @@ static struct pci_driver dw_i2c_driver = {
 	.id_table	= i2_designware_pci_ids,
 	.probe		= i2c_dw_pci_probe,
 	.remove		= __devexit_p(i2c_dw_pci_remove),
-	.resume         = i2c_dw_pci_resume,
-	.suspend        = i2c_dw_pci_suspend,
 	.driver         = {
 		.pm     = &i2c_dw_pm_ops,
 	},
-- 
1.7.3.4

