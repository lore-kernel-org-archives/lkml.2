Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0JQOv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:51:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34172 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0JQOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sYYnzfTtV5B0PDG1zI2IYu/V64vrWkPQVbMFj53Hgcrie0XnfN4dqr60JeHD7O02nT
         P7yTriUC4qup2EZkEXM/4/M4/OSZE5fpZfhUwzslTWl1CJISqnmPa8lN4H2nALYVk2ux
         Jhr741dNy/sGVb/ajFj18fiDyd0B7Xtj1RZxs=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kernel: olpc-xo1: fix error handling code
Date: Sun, 17 Oct 2010 18:51:46 +0400
Message-Id: <1287327106-9111-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If anything failed during initialization then setup_bases() should
call pci_disable_device().  Also reference got from pci_get_device()
should be freed with pci_dev_put().

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 arch/x86/kernel/olpc-xo1.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/olpc-xo1.c b/arch/x86/kernel/olpc-xo1.c
index f5442c0..05331cf 100644
--- a/arch/x86/kernel/olpc-xo1.c
+++ b/arch/x86/kernel/olpc-xo1.c
@@ -71,20 +71,25 @@ static int __devinit setup_bases(struct pci_dev *pdev)
 	r = pci_request_region(pdev, ACPI_BAR, DRV_NAME);
 	if (r) {
 		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", ACPI_BAR);
-		return r;
+		goto err_disable;
 	}
 
 	r = pci_request_region(pdev, PMS_BAR, DRV_NAME);
 	if (r) {
 		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", PMS_BAR);
-		pci_release_region(pdev, ACPI_BAR);
-		return r;
+		goto err_region1;
 	}
 
 	acpi_base = pci_resource_start(pdev, ACPI_BAR);
 	pms_base = pci_resource_start(pdev, PMS_BAR);
 
 	return 0;
+
+err_region1:
+	pci_release_region(pdev, ACPI_BAR);
+err_disable:
+	pci_disable_device(pdev);
+	return r;
 }
 
 static int __devinit olpc_xo1_probe(struct platform_device *pdev)
@@ -98,6 +103,7 @@ static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	r = setup_bases(pcidev);
+	pci_dev_put(pcidev);
 	if (r)
 		return r;
 
-- 
1.7.0.4

