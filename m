Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1D3Poa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:44:30 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34563 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1D3Po3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:44:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEABcuvE1bdWOb/2dsb2JhbACnDsF0hgAEjnmIF4YN
X-IronPort-AV: E=Sophos;i="4.64,293,1301868000"; 
   d="scan'208";a="835750727"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@suse.de
Cc: wuzhangjin@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 1/2] staging: sm7xx: smtcfb.c: Use the new PCI PM
Date: Sat, 30 Apr 2011 17:44:25 +0200
Message-Id: <1304178266-10161-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sm7xx driver uses the legacy PCI power management (suspend and
resume) callbacks.

This patch adds the new PCI PM and let the PCI core code handles the
PCI-specific details of power transitions.

Tested in 2.6.38, including standby and hibernation support.

Tested-by: Wu Zhangjin <wuzhangjin@gmail.com>
Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |   70 ++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 3e2230f..976a080 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -1016,13 +1016,10 @@ static void __devexit smtcfb_pci_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM
-/* Jason (08/14/2009)
- * suspend function, called when the suspend event is triggered
- */
-static int __maybe_unused smtcfb_suspend(struct pci_dev *pdev, pm_message_t msg)
+static int smtcfb_pci_suspend(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct smtcfb_info *sfb;
-	int retv;
 
 	sfb = pci_get_drvdata(pdev);
 
@@ -1032,25 +1029,9 @@ static int __maybe_unused smtcfb_suspend(struct pci_dev *pdev, pm_message_t msg)
 	smtc_seqw(0x20, (smtc_seqr(0x20) | 0xc0));
 	smtc_seqw(0x69, (smtc_seqr(0x69) & 0xf7));
 
-	switch (msg.event) {
-	case PM_EVENT_FREEZE:
-	case PM_EVENT_PRETHAW:
-		pdev->dev.power.power_state = msg;
-		return 0;
-	}
-
-	/* when doing suspend, call fb apis and pci apis */
-	if (msg.event == PM_EVENT_SUSPEND) {
-		console_lock();
-		fb_set_suspend(&sfb->fb, 1);
-		console_unlock();
-		retv = pci_save_state(pdev);
-		pci_disable_device(pdev);
-		retv = pci_choose_state(pdev, msg);
-		retv = pci_set_power_state(pdev, retv);
-	}
-
-	pdev->dev.power.power_state = msg;
+	console_lock();
+	fb_set_suspend(&sfb->fb, 1);
+	console_unlock();
 
 	/* additionally turn off all function blocks including internal PLLs */
 	smtc_seqw(0x21, 0xff);
@@ -1058,22 +1039,13 @@ static int __maybe_unused smtcfb_suspend(struct pci_dev *pdev, pm_message_t msg)
 	return 0;
 }
 
-static int __maybe_unused smtcfb_resume(struct pci_dev *pdev)
+static int smtcfb_pci_resume(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct smtcfb_info *sfb;
-	int retv;
 
 	sfb = pci_get_drvdata(pdev);
 
-	/* when resuming, restore pci data and fb cursor */
-	if (pdev->dev.power.power_state.event != PM_EVENT_FREEZE) {
-		retv = pci_set_power_state(pdev, PCI_D0);
-		pci_restore_state(pdev);
-		if (pci_enable_device(pdev))
-			return -1;
-		pci_set_master(pdev);
-	}
-
 	/* reinit hardware */
 	sm7xx_init_hw();
 	switch (hw.chipID) {
@@ -1108,22 +1080,30 @@ static int __maybe_unused smtcfb_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif
 
-/* Jason (08/13/2009)
- * pci_driver struct used to wrap the original driver
- * so that it can be registered into the kernel and
- * the proper method would be called when suspending and resuming
- */
+static const struct dev_pm_ops sm7xx_pm_ops = {
+	.suspend = smtcfb_pci_suspend,
+	.resume = smtcfb_pci_resume,
+	.freeze = smtcfb_pci_suspend,
+	.thaw = smtcfb_pci_resume,
+	.poweroff = smtcfb_pci_suspend,
+	.restore = smtcfb_pci_resume,
+};
+
+#define SM7XX_PM_OPS (&sm7xx_pm_ops)
+
+#else  /* !CONFIG_PM */
+
+#define SM7XX_PM_OPS NULL
+
+#endif /* !CONFIG_PM */
+
 static struct pci_driver smtcfb_driver = {
 	.name = "smtcfb",
 	.id_table = smtcfb_pci_table,
 	.probe = smtcfb_pci_probe,
 	.remove = __devexit_p(smtcfb_pci_remove),
-#ifdef CONFIG_PM
-	.suspend = smtcfb_suspend,
-	.resume = smtcfb_resume,
-#endif
+	.driver.pm  = SM7XX_PM_OPS,
 };
 
 static int __init smtcfb_init(void)
-- 
1.7.4.1

