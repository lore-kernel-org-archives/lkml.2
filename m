Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab2JWQ4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:56:13 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:13254 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933230Ab2JWQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:56:08 -0400
X-Greylist: delayed 6690 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2012 12:56:07 EDT
From: Andreas Larsson <andreas@gaisler.com>
To: linux-i2c@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: [PATCH 1/2] i2c: i2c-ocores: Add irq support for sparc
Date: Tue, 23 Oct 2012 17:03:56 +0200
Message-Id: <1351004637-11049-2-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1351004637-11049-1-git-send-email-andreas@gaisler.com>
References: <1351004637-11049-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no platform resources of type IORESOURCE_IRQ on sparc, so the irq
number is acquired in a different manner for sparc. The general case uses
platform_get_irq, that internally still uses platform_get_resource.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/i2c/busses/i2c-ocores.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index bffd550..1eb8a65 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -267,16 +267,21 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 {
 	struct ocores_i2c *i2c;
 	struct ocores_i2c_platform_data *pdata;
-	struct resource *res, *res2;
+	struct resource *res;
 	int ret;
 	int i;
+	int irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
 
-	res2 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res2)
+#ifdef CONFIG_SPARC
+	irq = pdev->archdata.irqs[0];
+#else
+	irq = platform_get_irq(pdev, 0);
+#endif
+	if (irq < 0)
 		return -ENODEV;
 
 	i2c = devm_kzalloc(&pdev->dev, sizeof(*i2c), GFP_KERNEL);
@@ -313,7 +318,7 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 	ocores_init(i2c);
 
 	init_waitqueue_head(&i2c->wait);
-	ret = devm_request_irq(&pdev->dev, res2->start, ocores_isr, 0,
+	ret = devm_request_irq(&pdev->dev, irq, ocores_isr, 0,
 			       pdev->name, i2c);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot claim IRQ\n");
-- 
1.7.0.4

