Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2ICIPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:15:05 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:58784 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755492Ab2ICIPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:15:01 -0400
From: Roland Stigge <stigge@antcom.de>
To: linus.walleij@linaro.org, shiraz.linux.kernel@gmail.com,
        aletes.xgr@gmail.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] spi/pl022: Fix chipselects pointer computation
Date: Mon,  3 Sep 2012 10:14:29 +0200
Message-Id: <1346660069-16049-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new chip select handling via GPIO introduced a pointer computation bug:

	(int *) pl022 + sizeof(struct pl022)

doesn't point to the data immediately after the actual struct pl022 (as was
intended) but to a multiple of bytes after it because of the (int *) type.

Replacing the kludgy pointer arithmetic with managed memory allocation for the
chip selects.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/spi/spi-pl022.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/spi/spi-pl022.c
+++ linux-2.6/drivers/spi/spi-pl022.c
@@ -2053,8 +2053,7 @@ pl022_probe(struct amba_device *adev, co
 	}
 
 	/* Allocate master with space for data */
-	master = spi_alloc_master(dev, sizeof(struct pl022) + sizeof(int) *
-				  num_cs);
+	master = spi_alloc_master(dev, sizeof(struct pl022));
 	if (master == NULL) {
 		dev_err(&adev->dev, "probe - cannot alloc SPI master\n");
 		status = -ENOMEM;
@@ -2066,8 +2065,8 @@ pl022_probe(struct amba_device *adev, co
 	pl022->master_info = platform_info;
 	pl022->adev = adev;
 	pl022->vendor = id->data;
-	/* Point chipselects to allocated memory beyond the main struct */
-	pl022->chipselects = (int *) pl022 + sizeof(struct pl022);
+	pl022->chipselects = devm_kzalloc(dev, num_cs * sizeof(int),
+					  GFP_KERNEL);
 
 	/*
 	 * Bus Number Which has been Assigned to this SSP controller
