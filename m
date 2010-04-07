Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0DGXNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:13:13 -0400
Received: from mail.df.lth.se ([194.47.250.12]:65418 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756269Ab0DGXM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:12:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 02/11] ARM: MMCI: pass max frequency from platform
Date: Thu,  8 Apr 2010 01:12:23 +0200
Message-Id: <1270681943-4985-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduce the field f_max into the mmci_platform_data,
making it possible to pass in a desired block clocking frequency
from a board configuration. This is often more desirable than
using a module parameter. We keep the module parameter as a
fallback as well as the default frequency specified for this
parameter if a parameter is not provided.

This also adds some kerneldoc style documentation to the
platform data struct in mmci.h.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mmc/host/mmci.c   |   13 ++++++++++++-
 include/linux/amba/mmci.h |   23 ++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 7e70c1a..ff115d9 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -631,7 +631,18 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 
 	mmc->ops = &mmci_ops;
 	mmc->f_min = (host->mclk + 511) / 512;
-	mmc->f_max = min(host->mclk, fmax);
+	/*
+	 * If the platform data supplies a maximum operating
+	 * frequency, this takes precedence. Else, we fall back
+	 * to using the module parameter, which has a (low)
+	 * default value in case it is not specified. Either
+	 * value must not exceed the clock rate into the block,
+	 * of course.
+	 */
+	if (plat->f_max)
+		mmc->f_max = min(host->mclk, plat->f_max);
+	else
+		mmc->f_max = min(host->mclk, fmax);
 	dev_dbg(mmc_dev(mmc), "clocking block at %u Hz\n", mmc->f_max);
 
 #ifdef CONFIG_REGULATOR
diff --git a/include/linux/amba/mmci.h b/include/linux/amba/mmci.h
index 6b42417..7e466fe 100644
--- a/include/linux/amba/mmci.h
+++ b/include/linux/amba/mmci.h
@@ -6,8 +6,29 @@
 
 #include <linux/mmc/host.h>
 
+/**
+ * struct mmci_platform_data - platform configuration for the MMCI
+ * (also known as PL180) block.
+ * @f_max: the maximum operational frequency for this host in this
+ * platform configuration. When this is specified it takes precedence
+ * over the module parameter for the same frequency.
+ * @ocr_mask: available voltages on the 4 pins from the block, this
+ * is ignored if a regulator is used, see the MMC_VDD_* masks in
+ * mmc/host.h
+ * @translate_vdd: a callback function to translate a MMC_VDD_*
+ * mask into a value to be binary or:ed and written into the
+ * MMCIPWR register of the block
+ * @status: if no GPIO read function was given to the block in
+ * gpio_wp (below) this function will be called to determine
+ * whether a card is present in the MMC slot or not
+ * @gpio_wp: read this GPIO pin to see if the card is write protected
+ * @gpio_cd: read this GPIO pin to detect card insertion
+ * @capabilities: the capabilities of the block as implemented in
+ * this platform, signify anything MMC_CAP_* from mmc/host.h
+ */
 struct mmci_platform_data {
-	unsigned int ocr_mask;			/* available voltages */
+	unsigned int f_max;
+	unsigned int ocr_mask;
 	u32 (*translate_vdd)(struct device *, unsigned int);
 	unsigned int (*status)(struct device *);
 	int	gpio_wp;
-- 
1.6.3.3

