Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2JPO7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:59:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:2900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab2JPO7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:59:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235797826"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: =?UTF-8?q?=5BPATCH=202/5=5D=20bcma=3A=20suspend/resume=20callbacks=20should=20be=20conditionally=20compiled=20on=20CONFIG=5FPM=5FSLEEP?=
Date: Tue, 16 Oct 2012 22:59:02 +0800
Message-Id: <1350399545-11179-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will fix warnings like following when CONFIG_PM_SLEEP is not set:

        warning: 'xxx_suspend' defined but not used [-Wunused-function]
        warning: 'xxx_resume' defined but not used [-Wunused-function]

Because
	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)

Only references the callbacks on CONFIG_PM_SLEEP (instead of CONFIG_PM).

Cc: John W. Linville <linville@tuxdriver.com>
Cc: "Rafał Miłecki" <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/bcma/host_pci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index b6b4b5e..98fdc3e 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -238,7 +238,7 @@ static void __devexit bcma_host_pci_remove(struct pci_dev *dev)
 	pci_set_drvdata(dev, NULL);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int bcma_host_pci_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -261,11 +261,11 @@ static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
 			 bcma_host_pci_resume);
 #define BCMA_PM_OPS	(&bcma_pm_ops)
 
-#else /* CONFIG_PM */
+#else /* CONFIG_PM_SLEEP */
 
 #define BCMA_PM_OPS     NULL
 
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
-- 
1.7.7.6

