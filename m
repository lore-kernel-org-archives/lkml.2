Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0FVR2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:28:08 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:10555 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756774Ab0FVR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:28:06 -0400
X-Greylist: delayed 1827 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 13:28:05 EDT
Date: Tue, 22 Jun 2010 20:57:34 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Barry Song <21cnbao@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/2] mtd: m25p80: Fix false-positive probing
Message-ID: <20100622165734.GA20699@oksana.dev.rtsoft.ru>
References: <20100622165545.GA10255@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100622165545.GA10255@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 18c6182bae0acca220ed6611f741034d563cd19f ("Rework
probing/JEDEC code"), m25p80 driver successfully registers chips
even if JEDEC probing fails.

This was needed to support non-JEDEC flashes. Though, it appears
that some platforms (e.g. blackfin bf533 stamp[1]) used the old
behavior to detect if there's any flash connected, so the driver
have to fail on JEDEC probing errors.

This patch restores the old behavior for JEDEC flashes, and adds
"-nonjedec" SPI device IDs for M25Pxx flashes, so that the kernel
still supports non-JEDEC flashes.

[1] http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=5975

Reported-by: Mingquan Pan
Reported-by: Barry Song <21cnbao@gmail.com>
Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---

This is for 2.6.35.

 drivers/mtd/devices/m25p80.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 81e49a9..a610ca9 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -680,6 +680,16 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "m25p64",  INFO(0x202017,  0,  64 * 1024, 128, 0) },
 	{ "m25p128", INFO(0x202018,  0, 256 * 1024,  64, 0) },
 
+	{ "m25p05-nonjedec",  INFO(0, 0,  32 * 1024,   2, 0) },
+	{ "m25p10-nonjedec",  INFO(0, 0,  32 * 1024,   4, 0) },
+	{ "m25p20-nonjedec",  INFO(0, 0,  64 * 1024,   4, 0) },
+	{ "m25p40-nonjedec",  INFO(0, 0,  64 * 1024,   8, 0) },
+	{ "m25p80-nonjedec",  INFO(0, 0,  64 * 1024,  16, 0) },
+	{ "m25p16-nonjedec",  INFO(0, 0,  64 * 1024,  32, 0) },
+	{ "m25p32-nonjedec",  INFO(0, 0,  64 * 1024,  64, 0) },
+	{ "m25p64-nonjedec",  INFO(0, 0,  64 * 1024, 128, 0) },
+	{ "m25p128-nonjedec", INFO(0, 0, 256 * 1024,  64, 0) },
+
 	{ "m45pe10", INFO(0x204011,  0, 64 * 1024,    2, 0) },
 	{ "m45pe80", INFO(0x204014,  0, 64 * 1024,   16, 0) },
 	{ "m45pe16", INFO(0x204015,  0, 64 * 1024,   32, 0) },
@@ -795,8 +805,7 @@ static int __devinit m25p_probe(struct spi_device *spi)
 
 		jid = jedec_probe(spi);
 		if (!jid) {
-			dev_info(&spi->dev, "non-JEDEC variant of %s\n",
-				 id->name);
+			return -ENODEV;
 		} else if (jid != id) {
 			/*
 			 * JEDEC knows better, so overwrite platform ID. We
-- 
1.7.0.5

