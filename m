Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab1JGFKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:10:15 -0400
Received: from [117.192.88.236] ([117.192.88.236]:37513 "EHLO manju-desktop"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759580Ab1JGFKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:10:13 -0400
To: linux-arm-kernel@lists.infradead.org
Date: Fri, 07 Oct 2011 10:33:09 +0500
Subject: [PATCH 4/5] gpiolib: handle deferral probe error
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
CC: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <1317963790-29426-5-git-send-email-manjugk@ti.com>
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The gpio library should return -EPROBE_DEFER in gpio_request
if gpio driver is not ready. If drivers pass this error code through to
their caller (which they really should) then this will ensure that the
probe is retried later when further devices become available.

Signed-off-by: G, Manjunath Kondaiah <manjugk@ti.com>
---
Cc: linux-omap@vger.kernel.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dilan Lee <dilee@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>

 drivers/gpio/gpiolib.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..9081ef8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1177,13 +1177,15 @@ int gpio_request(unsigned gpio, const char *label)
 {
 	struct gpio_desc	*desc;
 	struct gpio_chip	*chip;
-	int			status = -EINVAL;
+	int			status = -EPROBE_DEFER;
 	unsigned long		flags;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio))
+	if (!gpio_is_valid(gpio)) {
+		status = -EINVAL;
 		goto done;
+	}
 	desc = &gpio_desc[gpio];
 	chip = desc->chip;
 	if (chip == NULL)
-- 
1.7.4.1

