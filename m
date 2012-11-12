Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2KLRAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:00:07 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:61205 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751530Ab2KLRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:00:04 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 1/2] i2c: i2c-ocores: Add irq support for sparc
Date: Mon, 12 Nov 2012 17:59:50 +0100
Message-Id: <1352739591-1317-2-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352739591-1317-1-git-send-email-andreas@gaisler.com>
References: <1352739591-1317-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sparc support by using platform_get_irq instead of platform_get_resource.
There are no platform resources of type IORESOURCE_IRQ for sparc, but
platform_get_irq works for sparc. In the non-sparc case platform_get_irq
internally uses platform_get_resource.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
---
Changes since v1:
 - platform_get_irq now works for sparc, so that is used for all platforms
 - Acked by Peter Korsgaard <jacmet@sunsite.dk>

 drivers/i2c/busses/i2c-ocores.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index bffd550..0b71dc6 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -267,7 +267,8 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 {
 	struct ocores_i2c *i2c;
 	struct ocores_i2c_platform_data *pdata;
-	struct resource *res, *res2;
+	struct resource *res;
+	int irq;
 	int ret;
 	int i;
 
@@ -275,8 +276,8 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	res2 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res2)
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
 		return -ENODEV;
 
 	i2c = devm_kzalloc(&pdev->dev, sizeof(*i2c), GFP_KERNEL);
@@ -313,7 +314,7 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 	ocores_init(i2c);
 
 	init_waitqueue_head(&i2c->wait);
-	ret = devm_request_irq(&pdev->dev, res2->start, ocores_isr, 0,
+	ret = devm_request_irq(&pdev->dev, irq, ocores_isr, 0,
 			       pdev->name, i2c);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot claim IRQ\n");
-- 
1.7.0.4

