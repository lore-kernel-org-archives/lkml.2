Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2AaBSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:18:38 -0500
Received: from nm1-vm0.bullet.mail.ird.yahoo.com ([77.238.189.95]:37114 "HELO
	nm1-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752631Ab2AaBSh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:18:37 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 493231.6921.bm@omp1040.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=W4JNcLGd/ZJ9mcvcWny26gN2AkB/4hpx63vUEJVuG+9Hav8c5jGI0ZZ4gXzww8PUEUw+J8mdQ1tFxSVQ4ZsEZoIVh6CdKlYUOad6Xq0pp8OpG5grFRbcJQnEj7qIkgBIX+ycJ2ITTQ2ssoI9eC7OoZ63xSa4OFQwQuz0txef2rc=;
X-YMail-OSG: W2HYPiIVM1kk6t.HJulS4X.7BielhF39qIV6Y7JiZP1qXDj
 YHePQh2X.ltuA94WiLKjyqFFxDwZjq4n.hJIyKTUDKPGZGq03uY2WCUrf1vl
 wGpxxRFd6AvKJ0Dps8n2pd6KRkY1ThoWVzgdamnqjwj7fPdoMjoScHsXc2Ar
 LmYnu3f8ur_yvaLpOkZyuGfCwI_NjFK83cMe0tvXICt5FdppoK.4beQJvURn
 JAbn5e9_WRCQqHF2zhxbOg.6rt_CmZW67mB2n6fshDnkN8hOX8WcPeQkxM6u
 8CRgJqRHTAIKC2nli7nK4rnzMdHDQlbBA9B7Nf_VByad.zeH8AZ9H5DY.PcL
 tIXjDAkZpzU.8mXi2Gtn4Yu2_QdRl24kGrYrieGIwzPIAAfeKeE3AMbIW59k
 4FSntKxmN4x8IBNxJ3_ZIo.KnUwq9LGKZQL7JMA--
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.116.331537
Message-ID: <1327972715.82506.YahooMailClassic@web29004.mail.ird.yahoo.com>
Date: Tue, 31 Jan 2012 01:18:35 +0000 (GMT)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: [PATCH] mfd: asic3: Add to_irq() member to gpio_chip structure
To: linux-kernel@vger.kernel.org
Cc: philipp.zabel@gmail.com, sameo@linux.intel.com, mad_soft@inbox.ru,
        koen@dominion.thruhere.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio_to_irq() macro is now defined as __gpio_to_irq() instead of IRQ_GPIO().
The __gpio_to_irq() function returns -ENXIO if the referenced gpio_chip
structure does not define a to_irq() member.
This is true of the asic3 gpio_chip structure, and thus calls to gpio_to_irq()
now fail (for example from the gpio-vbus module).
This patch defines the to_irq() member in the asic3 gpio_chip structure.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---
diff -ru clean-3.3-rc1/drivers/mfd/asic3.c linux-3.3-rc1/drivers/mfd/asic3.c
--- clean-3.3-rc1/drivers/mfd/asic3.c	2012-01-19 23:04:48.000000000 +0000
+++ linux-3.3-rc1/drivers/mfd/asic3.c	2012-01-31 00:58:34.777451050 +0000
@@ -525,6 +525,11 @@
 	return;
 }
 
+static int asic3_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	return (offset < ASIC3_NUM_GPIOS) ? IRQ_BOARD_START + offset : -ENXIO;
+}
+
 static __init int asic3_gpio_probe(struct platform_device *pdev,
 				   u16 *gpio_config, int num)
 {
@@ -976,6 +981,7 @@
 	asic->gpio.set = asic3_gpio_set;
 	asic->gpio.direction_input = asic3_gpio_direction_input;
 	asic->gpio.direction_output = asic3_gpio_direction_output;
+	asic->gpio.to_irq = asic3_gpio_to_irq;
 
 	ret = asic3_gpio_probe(pdev,
 			       pdata->gpio_config,

