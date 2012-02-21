Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2BUMPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:15:22 -0500
Received: from mailbackup.inode.at ([213.229.60.24]:38146 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2BUMPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:15:18 -0500
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: Matt Mackall <mpm@selenic.com>, Sascha Hauer <s.hauer@pengutronix.de>
Cc: michael@thalmeier.at, Michael Thalmeier <michael.thalmeier@hale.at>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] i.MX31: mxc-rnga: implement waiting for data in driver
Date: Tue, 21 Feb 2012 13:13:30 +0100
Message-Id: <1329826410-21739-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: q1LCEKe9006099
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1330431261.65004@XVKtQ53MiJTVjfFd6yhUJA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mxc_rnga_data_present dit not use the wait parameter which caused a build
warning about initialization from incompatible pointer type.

Apart from this warning it is cleaner to implement the interface as intendet
and wait in the driver until data is available or a timeout has occured.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 drivers/char/hw_random/mxc-rnga.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 187c6be..39fb446 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -25,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
+#include <linux/delay.h>
 
 /* RNGA Registers */
 #define RNGA_CONTROL			0x00
@@ -60,14 +61,19 @@
 
 static struct platform_device *rng_dev;
 
-static int mxc_rnga_data_present(struct hwrng *rng)
+static int mxc_rnga_data_present(struct hwrng *rng, int wait)
 {
-	int level;
+	int level, i;
 	void __iomem *rng_base = (void __iomem *)rng->priv;
 
-	/* how many random numbers is in FIFO? [0-16] */
-	level = ((__raw_readl(rng_base + RNGA_STATUS) &
-			RNGA_STATUS_LEVEL_MASK) >> 8);
+	for (i = 0; i < 20; i++) {
+		/* how many random numbers is in FIFO? [0-16] */
+		level = ((__raw_readl(rng_base + RNGA_STATUS) &
+				RNGA_STATUS_LEVEL_MASK) >> 8);
+		if (level || !wait)
+			break;
+		udelay(10);
+	}
 
 	return level > 0 ? 1 : 0;
 }
-- 
1.7.7.6



--
Scanned by MailScanner.

