Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2HJU4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 16:56:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56305 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2HJU4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 16:56:44 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Fri, 10 Aug 2012 15:56:42 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <florian@openwrt.org>
Subject: [RFC PATCH] spi/bcm63xx: Ensure that memory is freed only after it is no longer used
Date: Fri, 10 Aug 2012 13:56:27 -0700
Message-Id: <1344632187-9603-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to spi_unregister_master() in the device remove function frees device
memory, and with it any device local data. However, device local data is still
accessed after the call to spi_unregister_master().

Acquire a reference to the SPI device and release it after cleanup is complete
to solve the problem.

Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Several drivers have this problem, and I am trying to find a common fix.

This solution is modeled after the approach used in spi-txx9spi:txx9spi_remove.
The other possible fix would be to move spi_unregister_master() to the end of
bcm63xx_spi_remove(), but I am not sure if it is a good idea to clean up
before the call to spi_unregister_master().

 drivers/spi/spi-bcm63xx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 6e25ef1..ea0aaa3 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -438,7 +438,7 @@ out:
 
 static int __devexit bcm63xx_spi_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = platform_get_drvdata(pdev);
+	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
 	struct bcm63xx_spi *bs = spi_master_get_devdata(master);
 
 	spi_unregister_master(master);
@@ -452,6 +452,8 @@ static int __devexit bcm63xx_spi_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, 0);
 
+	spi_master_put(master);
+
 	return 0;
 }
 
-- 
1.7.9.7

