Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2IXOzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:55:43 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:35451 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2IXOzl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 24 Sep 2012 10:55:41 -0400
Message-Id: <50609089020000780009D65E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 24 Sep 2012 15:55:37 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen-pciback: properly clean up after calling
 pcistub_device_find()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the function calls pcistub_device_get() before returning non-NULL,
its callers need to take care of calling pcistub_device_put() on
(mostly, but not exclusively) error paths.

Otoh, the function already guarantees that the 'dev' member is non-NULL
upon successful return, so callers do not need to check for this a
second time.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/xen-pciback/pci_stub.c |   46 ++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- 3.6-rc7/drivers/xen/xen-pciback/pci_stub.c
+++ 3.6-rc7-xen-pciback-find-error-paths/drivers/xen/xen-pciback/pci_stub.c
@@ -681,14 +681,14 @@ static pci_ers_result_t xen_pcibk_slot_r
 		dev_err(&dev->dev, DRV_NAME " device is not connected or owned"
 			" by HVM, kill it\n");
 		kill_domain_by_device(psdev);
-		goto release;
+		goto end;
 	}
 
 	if (!test_bit(_XEN_PCIB_AERHANDLER,
 		(unsigned long *)&psdev->pdev->sh_info->flags)) {
 		dev_err(&dev->dev,
 			"guest with no AER driver should have been killed\n");
-		goto release;
+		goto end;
 	}
 	result = common_process(psdev, 1, XEN_PCI_OP_aer_slotreset, result);
 
@@ -698,9 +698,9 @@ static pci_ers_result_t xen_pcibk_slot_r
 			"No AER slot_reset service or disconnected!\n");
 		kill_domain_by_device(psdev);
 	}
-release:
-	pcistub_device_put(psdev);
 end:
+	if (psdev)
+		pcistub_device_put(psdev);
 	up_write(&pcistub_sem);
 	return result;
 
@@ -739,14 +739,14 @@ static pci_ers_result_t xen_pcibk_mmio_e
 		dev_err(&dev->dev, DRV_NAME " device is not connected or owned"
 			" by HVM, kill it\n");
 		kill_domain_by_device(psdev);
-		goto release;
+		goto end;
 	}
 
 	if (!test_bit(_XEN_PCIB_AERHANDLER,
 		(unsigned long *)&psdev->pdev->sh_info->flags)) {
 		dev_err(&dev->dev,
 			"guest with no AER driver should have been killed\n");
-		goto release;
+		goto end;
 	}
 	result = common_process(psdev, 1, XEN_PCI_OP_aer_mmio, result);
 
@@ -756,9 +756,9 @@ static pci_ers_result_t xen_pcibk_mmio_e
 			"No AER mmio_enabled service or disconnected!\n");
 		kill_domain_by_device(psdev);
 	}
-release:
-	pcistub_device_put(psdev);
 end:
+	if (psdev)
+		pcistub_device_put(psdev);
 	up_write(&pcistub_sem);
 	return result;
 }
@@ -797,7 +797,7 @@ static pci_ers_result_t xen_pcibk_error_
 		dev_err(&dev->dev, DRV_NAME " device is not connected or owned"
 			" by HVM, kill it\n");
 		kill_domain_by_device(psdev);
-		goto release;
+		goto end;
 	}
 
 	/*Guest owns the device yet no aer handler regiested, kill guest*/
@@ -805,7 +805,7 @@ static pci_ers_result_t xen_pcibk_error_
 		(unsigned long *)&psdev->pdev->sh_info->flags)) {
 		dev_dbg(&dev->dev, "guest may have no aer driver, kill it\n");
 		kill_domain_by_device(psdev);
-		goto release;
+		goto end;
 	}
 	result = common_process(psdev, error, XEN_PCI_OP_aer_detected, result);
 
@@ -815,9 +815,9 @@ static pci_ers_result_t xen_pcibk_error_
 			"No AER error_detected service or disconnected!\n");
 		kill_domain_by_device(psdev);
 	}
-release:
-	pcistub_device_put(psdev);
 end:
+	if (psdev)
+		pcistub_device_put(psdev);
 	up_write(&pcistub_sem);
 	return result;
 }
@@ -851,7 +851,7 @@ static void xen_pcibk_error_resume(struc
 		dev_err(&dev->dev, DRV_NAME " device is not connected or owned"
 			" by HVM, kill it\n");
 		kill_domain_by_device(psdev);
-		goto release;
+		goto end;
 	}
 
 	if (!test_bit(_XEN_PCIB_AERHANDLER,
@@ -859,13 +859,13 @@ static void xen_pcibk_error_resume(struc
 		dev_err(&dev->dev,
 			"guest with no AER driver should have been killed\n");
 		kill_domain_by_device(psdev);
-		goto release;
+		goto end;
 	}
 	common_process(psdev, 1, XEN_PCI_OP_aer_resume,
 		       PCI_ERS_RESULT_RECOVERED);
-release:
-	pcistub_device_put(psdev);
 end:
+	if (psdev)
+		pcistub_device_put(psdev);
 	up_write(&pcistub_sem);
 	return;
 }
@@ -987,7 +987,7 @@ static int pcistub_reg_add(int domain, i
 	struct config_field *field;
 
 	psdev = pcistub_device_find(domain, bus, slot, func);
-	if (!psdev || !psdev->dev) {
+	if (!psdev) {
 		err = -ENODEV;
 		goto out;
 	}
@@ -1011,6 +1011,8 @@ static int pcistub_reg_add(int domain, i
 	if (err)
 		kfree(field);
 out:
+	if (psdev)
+		pcistub_device_put(psdev);
 	return err;
 }
 
@@ -1115,10 +1117,9 @@ static ssize_t pcistub_irq_handler_switc
 
 	err = str_to_slot(buf, &domain, &bus, &slot, &func);
 	if (err)
-		goto out;
+		return err;
 
 	psdev = pcistub_device_find(domain, bus, slot, func);
-
 	if (!psdev)
 		goto out;
 
@@ -1134,6 +1135,8 @@ static ssize_t pcistub_irq_handler_switc
 	if (dev_data->isr_on)
 		dev_data->ack_intr = 1;
 out:
+	if (psdev)
+		pcistub_device_put(psdev);
 	if (!err)
 		err = count;
 	return err;
@@ -1221,10 +1224,7 @@ static ssize_t permissive_add(struct dev
 		err = -ENODEV;
 		goto out;
 	}
-	if (!psdev->dev) {
-		err = -ENODEV;
-		goto release;
-	}
+
 	dev_data = pci_get_drvdata(psdev->dev);
 	/* the driver data for a device should never be null at this point */
 	if (!dev_data) {


