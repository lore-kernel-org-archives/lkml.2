Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab2ENQsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:48:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:52285 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2ENQs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:48:27 -0400
From: Benedikt Spranger <b.spranger@linutronix.de>
To: hjk@hansjkoch.de
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        magnus.damm@gmail.com, Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH] uio_pdrv_genirq: get irq through platform resource if not set otherwise
Date: Mon, 14 May 2012 18:48:17 +0200
Message-Id: <1337014097-5034-2-git-send-email-b.spranger@linutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1337014097-5034-1-git-send-email-b.spranger@linutronix.de>
References: <1337014097-5034-1-git-send-email-b.spranger@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform devices are configured through platform resources. The interrupt
in the driver uio_pdrv_genirq is instead configured through a side channel
i.e. the platform data structure. Make it possible to use the generic
configuration scheme via platform resource.

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 drivers/uio/uio_pdrv_genirq.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index b98371d..42202cd 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -146,6 +146,14 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	priv->flags = 0; /* interrupt is enabled to begin with */
 	priv->pdev = pdev;
 
+	if (!uioinfo->irq) {
+		ret = platform_get_irq(pdev, 0);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to get IRQ\n");
+			goto bad0;
+		}
+		uioinfo->irq = ret;
+	}
 	uiomem = &uioinfo->mem[0];
 
 	for (i = 0; i < pdev->num_resources; ++i) {
-- 
1.7.9.1

