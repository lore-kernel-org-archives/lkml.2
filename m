Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2HGUDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:03:03 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36540 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab2HGT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        J Freyensee <james_p_freyensee@linux.intel.com>
Subject: [PATCH 09/41] misc: pti, fix fail paths
Date: Tue,  7 Aug 2012 21:47:34 +0200
Message-Id: <1344368886-24033-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fail paths in ->probe and pti_init are incomplete. Fix that by adding
proper clean-up paths.

Note that we used to leak tty_driver on module unload. This is fixed
here too.

tty_unregister_driver needs not retval checking, so remove that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |   53 +++++++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index be6e679..90de855 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -811,7 +811,7 @@ static int __devinit pti_pci_probe(struct pci_dev *pdev,
 			__func__, __LINE__);
 		pr_err("%s(%d): Error value returned: %d\n",
 			__func__, __LINE__, retval);
-		return retval;
+		goto err;
 	}
 
 	retval = pci_enable_device(pdev);
@@ -819,17 +819,16 @@ static int __devinit pti_pci_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev,
 			"%s: pci_enable_device() returned error %d\n",
 			__func__, retval);
-		return retval;
+		goto err_unreg_misc;
 	}
 
 	drv_data = kzalloc(sizeof(*drv_data), GFP_KERNEL);
-
 	if (drv_data == NULL) {
 		retval = -ENOMEM;
 		dev_err(&pdev->dev,
 			"%s(%d): kmalloc() returned NULL memory.\n",
 			__func__, __LINE__);
-		return retval;
+		goto err_disable_pci;
 	}
 	drv_data->pti_addr = pci_resource_start(pdev, pci_bar);
 
@@ -838,18 +837,15 @@ static int __devinit pti_pci_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev,
 			"%s(%d): pci_request_region() returned error %d\n",
 			__func__, __LINE__, retval);
-		kfree(drv_data);
-		return retval;
+		goto err_free_dd;
 	}
 	drv_data->aperture_base = drv_data->pti_addr+APERTURE_14;
 	drv_data->pti_ioaddr =
 		ioremap_nocache((u32)drv_data->aperture_base,
 		APERTURE_LEN);
 	if (!drv_data->pti_ioaddr) {
-		pci_release_region(pdev, pci_bar);
 		retval = -ENOMEM;
-		kfree(drv_data);
-		return retval;
+		goto err_rel_reg;
 	}
 
 	pci_set_drvdata(pdev, drv_data);
@@ -862,6 +858,16 @@ static int __devinit pti_pci_probe(struct pci_dev *pdev,
 
 	register_console(&pti_console);
 
+	return 0;
+err_rel_reg:
+	pci_release_region(pdev, pci_bar);
+err_free_dd:
+	kfree(drv_data);
+err_disable_pci:
+	pci_disable_device(pdev);
+err_unreg_misc:
+	misc_deregister(&pti_char_driver);
+err:
 	return retval;
 }
 
@@ -937,25 +943,24 @@ static int __init pti_init(void)
 		pr_err("%s(%d): Error value returned: %d\n",
 			__func__, __LINE__, retval);
 
-		pti_tty_driver = NULL;
-		return retval;
+		goto put_tty;
 	}
 
 	retval = pci_register_driver(&pti_pci_driver);
-
 	if (retval) {
 		pr_err("%s(%d): PCI registration failed of pti driver\n",
 			__func__, __LINE__);
 		pr_err("%s(%d): Error value returned: %d\n",
 			__func__, __LINE__, retval);
-
-		tty_unregister_driver(pti_tty_driver);
-		pr_err("%s(%d): Unregistering TTY part of pti driver\n",
-			__func__, __LINE__);
-		pti_tty_driver = NULL;
-		return retval;
+		goto unreg_tty;
 	}
 
+	return 0;
+unreg_tty:
+	tty_unregister_driver(pti_tty_driver);
+put_tty:
+	put_tty_driver(pti_tty_driver);
+	pti_tty_driver = NULL;
 	return retval;
 }
 
@@ -964,17 +969,9 @@ static int __init pti_init(void)
  */
 static void __exit pti_exit(void)
 {
-	int retval;
-
-	retval = tty_unregister_driver(pti_tty_driver);
-	if (retval) {
-		pr_err("%s(%d): TTY unregistration failed of pti driver\n",
-			__func__, __LINE__);
-		pr_err("%s(%d): Error value returned: %d\n",
-			__func__, __LINE__, retval);
-	}
-
+	tty_unregister_driver(pti_tty_driver);
 	pci_unregister_driver(&pti_pci_driver);
+	put_tty_driver(pti_tty_driver);
 }
 
 module_init(pti_init);
-- 
1.7.10.4


