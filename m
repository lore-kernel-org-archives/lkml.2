Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2DRUyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:54:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2DRUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:54:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] [media] ite-cir: postpone ISR registration
Date: Wed, 18 Apr 2012 21:54:07 +0100
Message-Id: <1334782447-8742-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An early registration of an ISR was causing a crash to several users (for
example here: http://bugs.launchpad.net/bugs/972723  The reason was that
IRQs were being triggered before the driver initialisation was completed.

This patch fixes this by moving the invocation to request_irq() to a later
stage on the driver probe function.

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/rc/ite-cir.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 682009d..98d8ccf 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1521,10 +1521,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 				dev_desc->io_region_size, ITE_DRIVER_NAME))
 		goto failure;
 
-	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
-			ITE_DRIVER_NAME, (void *)itdev))
-		goto failure;
-
 	/* set driver data into the pnp device */
 	pnp_set_drvdata(pdev, itdev);
 	itdev->pdev = pdev;
@@ -1600,6 +1596,10 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	rdev->driver_name = ITE_DRIVER_NAME;
 	rdev->map_name = RC_MAP_RC6_MCE;
 
+	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
+			ITE_DRIVER_NAME, (void *)itdev))
+		goto failure;
+
 	ret = rc_register_device(rdev);
 	if (ret)
 		goto failure;
-- 
1.7.9.5

