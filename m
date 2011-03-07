Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab1CGCmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:42:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37049 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab1CGCmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pa2PVCmFg9qVueQIkFTunNERSkvMKrdJ5CLpfjdET+RTz1/fb7hsV2Luott0QqHRMh
         kxcvewEdN03wVr6Fwmns69r4j23JP5MxZ1X+jmNimpEZuoPwBm18vVhZfYCsJwzF686J
         apSYvg/O14tCTwJi9VEwUxDPgCv6dw3WGJhSc=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Alan Cox <alan@linux.intel.com>, Dave Airlie <airlied@gmail.com>,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next] staging: gma500: fix build according to drm changes
Date: Mon,  7 Mar 2011 05:41:04 +0300
Message-Id: <1299465664-7760-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8410ea3b (drm: rework PCI/platform driver interface.)
changed drm_driver structure. Fix build according to these changes.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/gma500/psb_drv.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 2b410af..9214e47 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -1605,6 +1605,18 @@ static const struct dev_pm_ops psb_pm_ops = {
 	.runtime_idle = psb_runtime_idle,
 };
 
+static struct pci_driver psb_pci_driver = {
+	.name = DRIVER_NAME,
+	.id_table = pciidlist,
+	.resume = ospm_power_resume,
+	.suspend = ospm_power_suspend,
+	.probe = psb_probe,
+	.remove = psb_remove,
+#ifdef CONFIG_PM
+	.driver.pm = &psb_pm_ops,
+#endif
+};
+
 static struct drm_driver driver = {
 	.driver_features = DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | \
 			   DRIVER_IRQ_VBL | DRIVER_MODESET,
@@ -1642,17 +1654,9 @@ static struct drm_driver driver = {
 		 .fasync = drm_fasync,
 		 .read = drm_read,
 		 },
-	.pci_driver = {
-		       .name = DRIVER_NAME,
-		       .id_table = pciidlist,
-		       .resume = ospm_power_resume,
-		       .suspend = ospm_power_suspend,
-		       .probe = psb_probe,
-		       .remove = psb_remove,
-#ifdef CONFIG_PM
-			.driver.pm = &psb_pm_ops,
-#endif
-		       },
+	.kdriver = {
+		.pci = &psb_pci_driver,
+		},
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
 	.date = PSB_DRM_DRIVER_DATE,
@@ -1671,12 +1675,12 @@ static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 static int __init psb_init(void)
 {
-	return drm_init(&driver);
+	return drm_pci_init(&driver, &psb_pci_driver);
 }
 
 static void __exit psb_exit(void)
 {
-	drm_exit(&driver);
+	drm_pci_exit(&driver, &psb_pci_driver);
 }
 
 late_initcall(psb_init);
-- 
1.7.4.1

