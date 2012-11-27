Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab2K0BCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:02:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58067 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495Ab2K0BCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:02:36 -0500
From: <oleg.matcovschi@ti.com>
To: <tony@atomide.com>, <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Oleg Matcovschi <oleg.matcovschi@ti.com>
Subject: [PATCH v2] OMAP2+: mux: Fixed gpio mux mode analysis.
Date: Mon, 26 Nov 2012 17:02:03 -0800
Message-ID: <1353978123-12936-1-git-send-email-oleg.matcovschi@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.188.36.244]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Matcovschi <oleg.matcovschi@ti.com>

OMAP_MODE_GPIO() macro verified only OMAP_MUX_MODE4.
It is not correct for following platforms:
    2430 - gpio mux mode 3
    44xx - gpio mux mode 3
    54xx - gpio mux mode 6

Patch reserves first 3 bits in partition flags for storing gpio mux
mode in same format as stored in control pad register.
Modified OMAP_MODE_GPIO() macro to handle all possible cases of gpio mux mode.
Modified omap_mux_init() flags of omap34xx to include OMAP_MUX_GPIO_IN_MODE4.

Signed-off-by: Oleg Matcovschi <oleg.matcovschi@ti.com>
---
 arch/arm/mach-omap2/mux.c     |   10 ++++------
 arch/arm/mach-omap2/mux.h     |   20 +++++++++++++++-----
 arch/arm/mach-omap2/mux34xx.c |    2 +-
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 701e17c..1fa39dc 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -134,10 +134,7 @@ static int __init _omap_mux_init_gpio(struct omap_mux_partition *partition,
 
 	old_mode = omap_mux_read(partition, gpio_mux->reg_offset);
 	mux_mode = val & ~(OMAP_MUX_NR_MODES - 1);
-	if (partition->flags & OMAP_MUX_GPIO_IN_MODE3)
-		mux_mode |= OMAP_MUX_MODE3;
-	else
-		mux_mode |= OMAP_MUX_MODE4;
+	mux_mode |= partition->gpio;
 	pr_debug("%s: Setting signal %s.gpio%i 0x%04x -> 0x%04x\n", __func__,
 		 gpio_mux->muxnames[0], gpio, old_mode, mux_mode);
 	omap_mux_write(partition, mux_mode, gpio_mux->reg_offset);
@@ -799,7 +796,7 @@ int __init omap_mux_late_init(void)
 			struct omap_mux *m = &e->mux;
 			u16 mode = omap_mux_read(partition, m->reg_offset);
 
-			if (OMAP_MODE_GPIO(mode))
+			if (OMAP_MODE_GPIO(partition, mode))
 				continue;
 
 #ifndef CONFIG_DEBUG_FS
@@ -1064,7 +1061,7 @@ static void __init omap_mux_init_list(struct omap_mux_partition *partition,
 		}
 #else
 		/* Skip pins that are not muxed as GPIO by bootloader */
-		if (!OMAP_MODE_GPIO(omap_mux_read(partition,
+		if (!OMAP_MODE_GPIO(partition, omap_mux_read(partition,
 				    superset->reg_offset))) {
 			superset++;
 			continue;
@@ -1131,6 +1128,7 @@ int __init omap_mux_init(const char *name, u32 flags,
 
 	partition->name = name;
 	partition->flags = flags;
+	partition->gpio = flags & OMAP_MUX_MODE7;
 	partition->size = mux_size;
 	partition->phys = mux_pbase;
 	partition->base = ioremap(mux_pbase, mux_size);
diff --git a/arch/arm/mach-omap2/mux.h b/arch/arm/mach-omap2/mux.h
index 76f9b3c..5504e12 100644
--- a/arch/arm/mach-omap2/mux.h
+++ b/arch/arm/mach-omap2/mux.h
@@ -58,7 +58,8 @@
 #define OMAP_PIN_OFF_INPUT_PULLDOWN	(OMAP_OFF_EN | OMAP_OFF_PULL_EN)
 #define OMAP_PIN_OFF_WAKEUPENABLE	OMAP_WAKEUP_EN
 
-#define OMAP_MODE_GPIO(x)	(((x) & OMAP_MUX_MODE7) == OMAP_MUX_MODE4)
+#define OMAP_MODE_GPIO(partition, x)	(((x) & OMAP_MUX_MODE7) == \
+					  partition->gpio)
 #define OMAP_MODE_UART(x)	(((x) & OMAP_MUX_MODE7) == OMAP_MUX_MODE0)
 
 /* Flags for omapX_mux_init */
@@ -79,13 +80,20 @@
 /*
  * omap_mux_init flags definition:
  *
+ * OMAP_GPIO_MUX_MODE, bits 0-2: gpio muxing mode, same like pad control
+ *      register which includes values from 0-7.
  * OMAP_MUX_REG_8BIT: Ensure that access to padconf is done in 8 bits.
  * The default value is 16 bits.
- * OMAP_MUX_GPIO_IN_MODE3: The GPIO is selected in mode3.
- * The default is mode4.
  */
-#define OMAP_MUX_REG_8BIT		(1 << 0)
-#define OMAP_MUX_GPIO_IN_MODE3		(1 << 1)
+#define OMAP_MUX_GPIO_IN_MODE0		OMAP_MUX_MODE0
+#define OMAP_MUX_GPIO_IN_MODE1		OMAP_MUX_MODE1
+#define OMAP_MUX_GPIO_IN_MODE2		OMAP_MUX_MODE2
+#define OMAP_MUX_GPIO_IN_MODE3		OMAP_MUX_MODE3
+#define OMAP_MUX_GPIO_IN_MODE4		OMAP_MUX_MODE4
+#define OMAP_MUX_GPIO_IN_MODE5		OMAP_MUX_MODE5
+#define OMAP_MUX_GPIO_IN_MODE6		OMAP_MUX_MODE6
+#define OMAP_MUX_GPIO_IN_MODE7		OMAP_MUX_MODE7
+#define OMAP_MUX_REG_8BIT		(1 << 3)
 
 /**
  * struct omap_board_data - board specific device data
@@ -105,6 +113,7 @@ struct omap_board_data {
  * struct mux_partition - contain partition related information
  * @name: name of the current partition
  * @flags: flags specific to this partition
+ * @gpio: gpio mux mode 
  * @phys: physical address
  * @size: partition size
  * @base: virtual address after ioremap
@@ -114,6 +123,7 @@ struct omap_board_data {
 struct omap_mux_partition {
 	const char		*name;
 	u32			flags;
+	u32			gpio;
 	u32			phys;
 	u32			size;
 	void __iomem		*base;
diff --git a/arch/arm/mach-omap2/mux34xx.c b/arch/arm/mach-omap2/mux34xx.c
index c47140b..c53609f4 100644
--- a/arch/arm/mach-omap2/mux34xx.c
+++ b/arch/arm/mach-omap2/mux34xx.c
@@ -2053,7 +2053,7 @@ int __init omap3_mux_init(struct omap_board_mux *board_subset, int flags)
 		return -EINVAL;
 	}
 
-	return omap_mux_init("core", 0,
+	return omap_mux_init("core", OMAP_MUX_GPIO_IN_MODE4,
 			     OMAP3_CONTROL_PADCONF_MUX_PBASE,
 			     OMAP3_CONTROL_PADCONF_MUX_SIZE,
 			     omap3_muxmodes, package_subset, board_subset,
-- 
1.7.4.1

