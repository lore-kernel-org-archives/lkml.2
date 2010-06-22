Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab0FVR2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:28:10 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:10556 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756892Ab0FVR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:28:06 -0400
Date: Tue, 22 Jun 2010 20:57:42 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Barry Song <21cnbao@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 2/2] mtd: m25p80: Make jedec_probe() return proper errno
 values
Message-ID: <20100622165742.GB20699@oksana.dev.rtsoft.ru>
References: <20100622165545.GA10255@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100622165545.GA10255@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spi_write_then_read() may return its own return codes (e.g. -EIO),
so let's propagate the value down to the probe().

Also, remove jedec == 0 check, it isn't needed as nowadays we use
dedicated SPI device IDs for non-JEDEC flashes.

Suggested-by: Barry Song <21cnbao@gmail.com>
Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---

This is for 2.6.36.

 drivers/mtd/devices/m25p80.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index a610ca9..7bf5c45 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -16,6 +16,8 @@
  */
 
 #include <linux/init.h>
+#include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
@@ -733,7 +735,7 @@ static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 	if (tmp < 0) {
 		DEBUG(MTD_DEBUG_LEVEL0, "%s: error %d reading JEDEC ID\n",
 			dev_name(&spi->dev), tmp);
-		return NULL;
+		return ERR_PTR(tmp);
 	}
 	jedec = id[0];
 	jedec = jedec << 8;
@@ -741,14 +743,6 @@ static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 	jedec = jedec << 8;
 	jedec |= id[2];
 
-	/*
-	 * Some chips (like Numonyx M25P80) have JEDEC and non-JEDEC variants,
-	 * which depend on technology process. Officially RDID command doesn't
-	 * exist for non-JEDEC chips, but for compatibility they return ID 0.
-	 */
-	if (jedec == 0)
-		return NULL;
-
 	ext_jedec = id[3] << 8 | id[4];
 
 	for (tmp = 0; tmp < ARRAY_SIZE(m25p_ids) - 1; tmp++) {
@@ -759,7 +753,7 @@ static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 			return &m25p_ids[tmp];
 		}
 	}
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 
@@ -804,8 +798,8 @@ static int __devinit m25p_probe(struct spi_device *spi)
 		const struct spi_device_id *jid;
 
 		jid = jedec_probe(spi);
-		if (!jid) {
-			return -ENODEV;
+		if (IS_ERR(jid)) {
+			return PTR_ERR(jid);
 		} else if (jid != id) {
 			/*
 			 * JEDEC knows better, so overwrite platform ID. We
-- 
1.7.0.5
