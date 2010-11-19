Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab0KSSmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:42:38 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34392 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab0KSSmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:42:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=CSAKR2XeWTtKzTgR75YdnSNvdKSZihWHB6RqHE5GHfeAboLTtco4dTMYEjIohi6nIu
         hXd1mX/ChTK8kmqwiqrZoA6B8CTKi7yX/ytbtEW7EjEtAd+dpuVd1KqFLh9oY/nc6zwg
         0yS7pMQib6j40q7zSylu54FmSQ5VOuvVBcEhA=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Russ Gorby <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: ifx6x60: free IRQ on error
Date: Fri, 19 Nov 2010 21:42:03 +0300
Message-Id: <1290192123-11747-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If second request_irq() failed then the first IRQ must be freed in
error handling code.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/serial/ifx6x60.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index 803264a..3f8d5ee 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
@@ -1133,7 +1133,7 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	if (ret) {
 		dev_err(&spi->dev, "Unable to get irq %x",
 			gpio_to_irq(ifx_dev->gpio.srdy));
-		goto error_ret6;
+		goto error_ret7;
 	}
 
 	/* set pm runtime power state and register with power system */
@@ -1153,6 +1153,8 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 		mrdy_set_low(ifx_dev);
 	return 0;
 
+error_ret7:
+	free_irq(gpio_to_irq(ifx_dev->gpio.reset_out), (void *)ifx_dev);
 error_ret6:
 	gpio_free(ifx_dev->gpio.srdy);
 error_ret5:
-- 
1.7.0.4

