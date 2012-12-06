Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2LFXgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 18:36:00 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36309 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab2LFXf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 18:35:58 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] spi: Fix comparison of different integer types
Date: Thu,  6 Dec 2012 23:35:47 +0000
Message-Id: <1354836947-31078-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix problem discovered with sparse:
+ drivers/spi/spi.c:1554:37: sparse: incompatible types in comparison expression (different signedness)
drivers/spi/spi.c: In function 'spi_write_then_read':
drivers/spi/spi.c:1554:23: warning: comparison of distinct pointer types lacks a cast [enabled by default]

The change to SPI_BUFSIZ was introduced in commit b3a223ee2, "spi:
Remove SPI_BUFSIZ restriction on spi_write_then_read()"

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/spi/spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 22c71e2..b370d292 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1551,7 +1551,7 @@ int spi_write_then_read(struct spi_device *spi,
 	 * using the pre-allocated buffer or the transfer is too large.
 	 */
 	if ((n_tx + n_rx) > SPI_BUFSIZ || !mutex_trylock(&lock)) {
-		local_buf = kmalloc(max(SPI_BUFSIZ, n_tx + n_rx), GFP_KERNEL);
+		local_buf = kmalloc(max((unsigned)SPI_BUFSIZ, n_tx + n_rx), GFP_KERNEL);
 		if (!local_buf)
 			return -ENOMEM;
 	} else {
-- 
1.7.10.4

