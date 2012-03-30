Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622Ab2C3VxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:53:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46401 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965808Ab2C3VTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:34 -0400
Message-Id: <20120330194834.975064575@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Max Filippov <jcmvbkbc@gmail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 056/175] p54spi: Release GPIO lines and IRQ on error in p54spi_probe
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 62ebeed8d00aef75eac4fd6c161cae75a41965ca upstream.

This makes it possible to reload driver if insmod has failed due to
missing firmware.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/p54/p54spi.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -618,19 +618,19 @@ static int __devinit p54spi_probe(struct
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&priv->spi->dev, "spi_setup failed");
-		goto err_free_common;
+		goto err_free;
 	}
 
 	ret = gpio_request(p54spi_gpio_power, "p54spi power");
 	if (ret < 0) {
 		dev_err(&priv->spi->dev, "power GPIO request failed: %d", ret);
-		goto err_free_common;
+		goto err_free;
 	}
 
 	ret = gpio_request(p54spi_gpio_irq, "p54spi irq");
 	if (ret < 0) {
 		dev_err(&priv->spi->dev, "irq GPIO request failed: %d", ret);
-		goto err_free_common;
+		goto err_free_gpio_power;
 	}
 
 	gpio_direction_output(p54spi_gpio_power, 0);
@@ -641,7 +641,7 @@ static int __devinit p54spi_probe(struct
 			  priv->spi);
 	if (ret < 0) {
 		dev_err(&priv->spi->dev, "request_irq() failed");
-		goto err_free_common;
+		goto err_free_gpio_irq;
 	}
 
 	irq_set_irq_type(gpio_to_irq(p54spi_gpio_irq), IRQ_TYPE_EDGE_RISING);
@@ -673,6 +673,12 @@ static int __devinit p54spi_probe(struct
 	return 0;
 
 err_free_common:
+	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
+err_free_gpio_irq:
+	gpio_free(p54spi_gpio_irq);
+err_free_gpio_power:
+	gpio_free(p54spi_gpio_power);
+err_free:
 	p54_free_common(priv->hw);
 	return ret;
 }


