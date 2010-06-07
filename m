Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0FGVhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:37:42 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:40917 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409Ab0FGVhk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:37:40 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: Clemens Ladisch <clemens@ladisch.de>,
       DL-MegaRAID Linux <megaraidlinux@lsi.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 7 Jun 2010 15:37:32 -0600
Subject: RE: [PATCH] megaraid_sas: enable message-signaled interrupts
Thread-Topic: [PATCH] megaraid_sas: enable message-signaled interrupts
Thread-Index: AcsGFCA3t60rM1CeRzGrqmB3fR6tKwAdW0gg
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D0803AAB@cosmail02.lsi.com>
References: <4C0CA170.70003@ladisch.de>
In-Reply-To: <4C0CA170.70003@ladisch.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NACK.  The MSI will be turn on until driver fully support it.


-----Original Message-----
From: Clemens Ladisch [mailto:clemens@ladisch.de] 
Sent: Monday, June 07, 2010 3:36 AM
To: DL-MegaRAID Linux
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] megaraid_sas: enable message-signaled interrupts

To avoid sharing interrupts, enable message-signaled interrupts, if
possible.

Tested with LSI 9260-8i/8e, where sharing the interrupt with the nvidia
driver would reduce the RAID performance.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Tested-by: Bert dd <bert.ddecker@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3169,10 +3169,14 @@ megasas_probe_one(struct pci_dev *pdev,
 	if (megasas_init_mfi(instance))
 		goto fail_init_mfi;
 
+	pci_enable_msi(pdev);
+
 	/*
 	 * Register IRQ
 	 */
-	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED, "megasas", instance)) {
+	if (request_irq(pdev->irq, megasas_isr,
+		pci_dev_msi_enabled(pdev) ? 0 : IRQF_SHARED,
+		"megasas", instance)) {
 		printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
 		goto fail_irq;
 	}
@@ -3222,6 +3226,8 @@ megasas_probe_one(struct pci_dev *pdev,
 	megasas_release_mfi(instance);
 
       fail_irq:
+	pci_disable_msi(pdev);
+
       fail_init_mfi:
       fail_alloc_dma_buf:
 	if (instance->evt_detail)
@@ -3354,6 +3360,7 @@ megasas_suspend(struct pci_dev *pdev, pm
 	pci_set_drvdata(instance->pdev, instance);
 	instance->instancet->disable_intr(instance->reg_set);
 	free_irq(instance->pdev->irq, instance);
+	pci_disable_msi(pdev);
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
@@ -3416,10 +3423,13 @@ megasas_resume(struct pci_dev *pdev)
 	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
 			(unsigned long)instance);
 
+	pci_enable_msi(pdev);
+
 	/*
 	 * Register IRQ
 	 */
-	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED,
+	if (request_irq(pdev->irq, megasas_isr,
+		pci_dev_msi_enabled(pdev) ? 0 : IRQF_SHARED,
 		"megasas", instance)) {
 		printk(KERN_ERR "megasas: Failed to register IRQ\n");
 		goto fail_irq;
@@ -3443,6 +3453,8 @@ megasas_resume(struct pci_dev *pdev)
 	return 0;
 
 fail_irq:
+	pci_disable_msi(pdev);
+
 fail_init_mfi:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
@@ -3519,6 +3531,7 @@ static void __devexit megasas_detach_one
 	instance->instancet->disable_intr(instance->reg_set);
 
 	free_irq(instance->pdev->irq, instance);
+	pci_disable_msi(pdev);
 
 	megasas_release_mfi(instance);
 
