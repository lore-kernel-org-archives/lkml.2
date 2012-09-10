Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab2IJKtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:49:40 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:50092 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757105Ab2IJKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:22 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/14] MFD: twl-core: Add API to query the HFCLK rate
Date: Mon, 10 Sep 2012 13:46:22 +0300
Message-Id: <1347273992-9107-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFG_BOOT register's HFCLK_FREQ field hold information about the used HFCLK
frequency.
Add possibility for users to get the configured rate based on this
register.
This register was configured during boot, without it the chip would not
operate correctly, so we can trust on this information.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c  | 32 ++++++++++++++++++++++++++++++++
 include/linux/i2c/twl.h |  1 +
 2 files changed, 33 insertions(+)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 1c32afe..f162b68 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -552,6 +552,38 @@ int twl_get_version(void)
 }
 EXPORT_SYMBOL_GPL(twl_get_version);
 
+/**
+ * twl_get_hfclk_rate - API to get TWL external HFCLK clock rate.
+ *
+ * Api to get the TWL HFCLK rate based on BOOT_CFG register.
+ */
+int twl_get_hfclk_rate(void)
+{
+	u8 ctrl;
+	int rate;
+
+	twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &ctrl, R_CFG_BOOT);
+
+	switch (ctrl & 0x3) {
+	case HFCLK_FREQ_19p2_MHZ:
+		rate = 19200000;
+		break;
+	case HFCLK_FREQ_26_MHZ:
+		rate = 26000000;
+		break;
+	case HFCLK_FREQ_38p4_MHZ:
+		rate = 38400000;
+		break;
+	default:
+		pr_err("TWL4030: HFCLK is not configured\n");
+		rate = -EINVAL;
+		break;
+	}
+
+	return rate;
+}
+EXPORT_SYMBOL_GPL(twl_get_hfclk_rate);
+
 static struct device *
 add_numbered_child(unsigned chip, const char *name, int num,
 		void *pdata, unsigned pdata_len,
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 7ea898c..ac6488c 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -188,6 +188,7 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 int twl_get_type(void);
 int twl_get_version(void);
+int twl_get_hfclk_rate(void);
 
 int twl6030_interrupt_unmask(u8 bit_mask, u8 offset);
 int twl6030_interrupt_mask(u8 bit_mask, u8 offset);
-- 
1.7.12

