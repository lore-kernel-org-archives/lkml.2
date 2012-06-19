Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2FSP3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:29:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53353 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2FSP3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:29:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        luis.henriques@canonical.com
Subject: [PATCH 1/1] [media] ene_ir: Fix driver initialisation
Date: Tue, 19 Jun 2012 16:29:49 +0100
Message-Id: <1340119789-22887-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9ef449c6b31bb6a8e6dedc24de475a3b8c79be20 ("[media] rc: Postpone ISR
registration") fixed an early ISR registration on several drivers.  It did
however also introduced a bug by moving the invocation of pnp_port_start()
to the end of the probe function.

This patch fixes this issue by moving the invocation of pnp_port_start() to
an earlier stage in the probe function.

Cc: stable@vger.kernel.org
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/rc/ene_ir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index ed77c6d..5327061 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1018,6 +1018,8 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	spin_lock_init(&dev->hw_lock);
 
+	dev->hw_io = pnp_port_start(pnp_dev, 0);
+
 	pnp_set_drvdata(pnp_dev, dev);
 	dev->pnp_dev = pnp_dev;
 
@@ -1072,7 +1074,6 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	/* claim the resources */
 	error = -EBUSY;
-	dev->hw_io = pnp_port_start(pnp_dev, 0);
 	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
 		dev->hw_io = -1;
 		dev->irq = -1;
-- 
1.7.9.5

