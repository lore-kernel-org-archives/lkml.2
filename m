Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2HYPUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 11:20:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49424 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2HYPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 11:20:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Matthijs Kooijman <matthijs@stdin.nl>,
        Elmar Stellnberger <estellnb@elstel.rivido.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] [media] rc: Fix ISR registration
Date: Sat, 25 Aug 2012 16:20:16 +0100
Message-Id: <1345908016-10462-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9ef449c6b31bb6a8e6dedc24de475a3b8c79be20 ("[media] rc: Postpone ISR
registration") tried to fix an early ISR registration, but it didn't moved
it far enough -- request_irq() has to be called only *after* device
registration.

This patch should fix bug https://bugzilla.kernel.org/show_bug.cgi?id=46391.

Cc: <stable@vger.kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/rc/ene_ir.c      |   34 ++++++++++++++++++----------------
 drivers/media/rc/fintek-cir.c  |   11 ++++++-----
 drivers/media/rc/ite-cir.c     |   11 ++++++-----
 drivers/media/rc/nuvoton-cir.c |   21 +++++++++++----------
 drivers/media/rc/winbond-cir.c |   14 +++++++-------
 5 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 647dd95..3ff3bb6 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1000,7 +1000,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
 	rdev = rc_allocate_device();
 	if (!dev || !rdev)
-		goto error1;
+		goto failure;
 
 	/* validate resources */
 	error = -ENODEV;
@@ -1011,10 +1011,10 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	if (!pnp_port_valid(pnp_dev, 0) ||
 	    pnp_port_len(pnp_dev, 0) < ENE_IO_SIZE)
-		goto error;
+		goto failure;
 
 	if (!pnp_irq_valid(pnp_dev, 0))
-		goto error;
+		goto failure;
 
 	spin_lock_init(&dev->hw_lock);
 
@@ -1030,7 +1030,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	/* detect hardware version and features */
 	error = ene_hw_detect(dev);
 	if (error)
-		goto error;
+		goto failure;
 
 	if (!dev->hw_learning_and_tx_capable && txsim) {
 		dev->hw_learning_and_tx_capable = true;
@@ -1077,30 +1077,32 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
 		dev->hw_io = -1;
 		dev->irq = -1;
-		goto error;
+		goto failure;
 	}
 
+	error = rc_register_device(rdev);
+	if (error)
+		goto failure2;
+
+	error = -EBUSY;
 	dev->irq = pnp_irq(pnp_dev, 0);
 	if (request_irq(dev->irq, ene_isr,
 			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
 		dev->irq = -1;
-		goto error;
+		goto failure3;
 	}
 
-	error = rc_register_device(rdev);
-	if (error < 0)
-		goto error;
-
 	pr_notice("driver has been successfully loaded\n");
 	return 0;
-error:
-	if (dev && dev->irq >= 0)
-		free_irq(dev->irq, dev);
-	if (dev && dev->hw_io >= 0)
-		release_region(dev->hw_io, ENE_IO_SIZE);
-error1:
+
+failure3:
+	rc_unregister_device(rdev);
+failure2:
+	release_region(dev->hw_io, ENE_IO_SIZE);
+failure:
 	rc_free_device(rdev);
 	kfree(dev);
+
 	return error;
 }
 
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index ab30c64..df8631e 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -558,12 +558,13 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 			    fintek->cir_port_len, FINTEK_DRIVER_NAME))
 		goto failure;
 
-	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
-			FINTEK_DRIVER_NAME, (void *)fintek))
-		goto failure2;
-
 	ret = rc_register_device(rdev);
 	if (ret)
+		goto failure2;
+
+	ret = -EBUSY;
+	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
+			FINTEK_DRIVER_NAME, (void *)fintek))
 		goto failure3;
 
 	device_init_wakeup(&pdev->dev, true);
@@ -575,7 +576,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	return 0;
 
 failure3:
-	free_irq(fintek->cir_irq, fintek);
+	rc_unregister_device(rdev);
 failure2:
 	release_region(fintek->cir_addr, fintek->cir_port_len);
 failure:
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 36fe5a3..530cc0b 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1596,12 +1596,13 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 				dev_desc->io_region_size, ITE_DRIVER_NAME))
 		goto failure;
 
-	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
-			ITE_DRIVER_NAME, (void *)itdev))
-		goto failure2;
-
 	ret = rc_register_device(rdev);
 	if (ret)
+		goto failure2;
+
+	ret = -EBUSY;
+	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
+			ITE_DRIVER_NAME, (void *)itdev))
 		goto failure3;
 
 	itdev->rdev = rdev;
@@ -1610,7 +1611,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	return 0;
 
 failure3:
-	free_irq(itdev->cir_irq, itdev);
+	rc_unregister_device(rdev);
 failure2:
 	release_region(itdev->cir_addr, itdev->params.io_region_size);
 failure:
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 699eef3..a0e3cc7 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1072,20 +1072,21 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
 		goto failure;
 
-	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
-			NVT_DRIVER_NAME, (void *)nvt))
-		goto failure2;
-
 	if (!request_region(nvt->cir_wake_addr,
 			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
+		goto failure2;
+
+	ret = rc_register_device(rdev);
+	if (ret)
 		goto failure3;
 
-	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
+	ret = -EBUSY;
+	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
 			NVT_DRIVER_NAME, (void *)nvt))
 		goto failure4;
 
-	ret = rc_register_device(rdev);
-	if (ret)
+	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
+			NVT_DRIVER_NAME, (void *)nvt))
 		goto failure5;
 
 	device_init_wakeup(&pdev->dev, true);
@@ -1099,11 +1100,11 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	return 0;
 
 failure5:
-	free_irq(nvt->cir_wake_irq, nvt);
+	free_irq(nvt->cir_irq, nvt);
 failure4:
-	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
+	rc_unregister_device(rdev);
 failure3:
-	free_irq(nvt->cir_irq, nvt);
+	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
 failure2:
 	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
 failure:
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 54ee348..a42ee93 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1056,26 +1056,26 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 		goto exit_release_ebase;
 	}
 
+	err = rc_register_device(data->dev);
+	if (err)
+		goto exit_release_sbase;
+
 	err = request_irq(data->irq, wbcir_irq_handler,
 			  IRQF_DISABLED, DRVNAME, device);
 	if (err) {
 		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
 		err = -EBUSY;
-		goto exit_release_sbase;
+		goto exit_unregister_dev;
 	}
 
-	err = rc_register_device(data->dev);
-	if (err)
-		goto exit_free_irq;
-
 	device_init_wakeup(&device->dev, 1);
 
 	wbcir_init_hw(data);
 
 	return 0;
 
-exit_free_irq:
-	free_irq(data->irq, device);
+exit_unregister_dev:
+	rc_unregister_device(data->dev);
 exit_release_sbase:
 	release_region(data->sbase, SP_IOMEM_LEN);
 exit_release_ebase:
-- 
1.7.10.4

