Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2HHOuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:50:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58540 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab2HHOrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:47:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 10/11] spi/s3c64xx: improve error handling
Date: Wed,  8 Aug 2012 16:47:27 +0200
Message-Id: <1344437248-20560-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344437248-20560-1-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jPfMJYg6Tt3TUZQHV9OqzBL3ugzKBlD7Mq30WY1xr7s
 Q5PLzb9GCT9GJpUcALNLw8ekWrOecNDohv4wiZM7louDitCJC1
 m5OP85Sx7AfLsJAgwi6FxmqQJZ/SzDhZ3FZkoEdVjHVZWAhQX5
 F8ZUp2X38FVUnxZ0eJJByZGXRvoMTaJjTjMVu1tktWeOvWZrEL
 Vt4p+ksQ8QDiIUeZEKqKKWliRy91dWNYyJ0/jCXoKbSp84ITAq
 v8Q0yE0P9FqTxkzn3izKJWOFysOps398HyezC6yxhxUm5ZwpUn
 JGTBzGmO+EfqvduOsDicxaWAanVlGhcnEzjWhLwELFpL9yNIbD
 FLKDJXzwNAj7cnVIGl23WY57G/F8djoMTLiykceL02xLpZxJbY
 ohIdMrIxMgLwsFCodB/HjyMPup0L4MbSYM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a device tree definition os an s3c64xx SPI master is missing
a "controller-data" subnode, the newly added s3c64xx_get_slave_ctrldata
function might use uninitialized memory in place of that node,
which was correctly reported by gcc.

Without this patch, building s3c6400_defconfig results in:

drivers/spi/spi-s3c64xx.c: In function 's3c64xx_get_slave_ctrldata.isra.25':
drivers/spi/spi-s3c64xx.c:841:5: warning: 'data_np' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 646a765..cfa2c35 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -826,7 +826,7 @@ static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
 				struct spi_device *spi)
 {
 	struct s3c64xx_spi_csinfo *cs;
-	struct device_node *slave_np, *data_np;
+	struct device_node *slave_np, *data_np = NULL;
 	u32 fb_delay = 0;
 
 	slave_np = spi->dev.of_node;
-- 
1.7.10

