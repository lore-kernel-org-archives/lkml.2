Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1BFSEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:04:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:55174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1BFSD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:03:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,434,1291622400"; 
   d="scan'208";a="654942321"
From: Pierre Tardy <pierre.tardy@intel.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pierre Tardy <pierre.tardy@intel.com>
Subject: [PATCH v2 1/3] mmc: add per device quirk placeholder
Date: Sun,  6 Feb 2011 19:03:46 +0100
Message-Id: <89ba04ca08bd8f0f858d0921add9522f36f5bd94.1297014807.git.pierre.tardy@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1297014807.git.pierre.tardy@intel.com>
References: <cover.1297014807.git.pierre.tardy@intel.com>
In-Reply-To: <cover.1297014807.git.pierre.tardy@intel.com>
References: <cover.1297014807.git.pierre.tardy@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some cards have quirks valid for every platforms
using current platform quirk hooks leads to a lot
of code and debug duplication.

So we inspire a bit from what exists in PCI subsystem
and do out own per vendorid/deviceid quirk
We still drop the complexity of the pci quirk system
(with special section tables, and so on)
That can be added later if needed.

Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/Makefile |    3 +-
 drivers/mmc/core/core.h   |    2 +
 drivers/mmc/core/quirks.c |   62 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/sdio.c   |    1 +
 include/linux/mmc/card.h  |    2 +
 5 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
index 86b4791..6395019 100644
--- a/drivers/mmc/core/Makefile
+++ b/drivers/mmc/core/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_MMC)		+= mmc_core.o
 mmc_core-y			:= core.o bus.o host.o \
 				   mmc.o mmc_ops.o sd.o sd_ops.o \
 				   sdio.o sdio_ops.o sdio_bus.o \
-				   sdio_cis.o sdio_io.o sdio_irq.o
+				   sdio_cis.o sdio_io.o sdio_irq.o \
+				   quirks.o
 
 mmc_core-$(CONFIG_DEBUG_FS)	+= debugfs.o
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index ca1fdde..20b1c08 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -61,6 +61,8 @@ int mmc_attach_mmc(struct mmc_host *host);
 int mmc_attach_sd(struct mmc_host *host);
 int mmc_attach_sdio(struct mmc_host *host);
 
+void mmc_fixup_device(struct mmc_card *card);
+
 /* Module parameters */
 extern int use_spi_crc;
 
diff --git a/drivers/mmc/core/quirks.c b/drivers/mmc/core/quirks.c
new file mode 100644
index 0000000..aa811fc
--- /dev/null
+++ b/drivers/mmc/core/quirks.c
@@ -0,0 +1,62 @@
+/*
+ *  This file contains work-arounds for many known sdio hardware
+ *  bugs.
+ *
+ *  Copyright (c) 2011 Pierre Tardy <tardyp@gmail.com>
+ *  Inspired from pci fixup code:
+ *  Copyright (c) 1999 Martin Mares <mj@ucw.cz>
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/mmc/card.h>
+#include <linux/mod_devicetable.h>
+
+/*
+ *  The world is not perfect and supplies us with broken mmc/sdio devices.
+ *  For at least a part of these bugs we need a work-around
+ */
+
+struct mmc_fixup {
+	u16 vendor, device;	/* You can use SDIO_ANY_ID here of course */
+	void (*vendor_fixup)(struct mmc_card *card, int data);
+	int data;
+};
+
+/*
+ * This hook just adds a quirk unconditionnally
+ */
+static void __maybe_unused add_quirk(struct mmc_card *card, int data)
+{
+	card->quirks |= data;
+}
+
+/*
+ * This hook just removes a quirk unconditionnally
+ */
+static void __maybe_unused remove_quirk(struct mmc_card *card, int data)
+{
+	card->quirks &= ~data;
+}
+
+static const struct mmc_fixup mmc_fixup_methods[] = {
+	{ 0 }
+};
+
+void mmc_fixup_device(struct mmc_card *card)
+{
+	const struct mmc_fixup *f;
+
+	for (f = mmc_fixup_methods; f->vendor_fixup; f++) {
+		if ((f->vendor == card->cis.vendor
+		     || f->vendor == (u16) SDIO_ANY_ID) &&
+		    (f->device == card->cis.device
+		     || f->device == (u16) SDIO_ANY_ID)) {
+			dev_dbg(&card->dev, "calling %pF\n", f->vendor_fixup);
+			f->vendor_fixup(card, f->data);
+		}
+	}
+}
+EXPORT_SYMBOL(mmc_fixup_device);
+
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 5c4a54d..617e9ad 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -458,6 +458,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 
 		card = oldcard;
 	}
+	mmc_fixup_device(card);
 
 	if (card->type == MMC_TYPE_SD_COMBO) {
 		err = mmc_sd_setup_card(host, card, oldcard != NULL);
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 4652cf9..ad74138 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -151,6 +151,8 @@ struct mmc_card {
 	struct dentry		*debugfs_root;
 };
 
+void mmc_fixup_device(struct mmc_card *dev);
+
 #define mmc_card_mmc(c)		((c)->type == MMC_TYPE_MMC)
 #define mmc_card_sd(c)		((c)->type == MMC_TYPE_SD)
 #define mmc_card_sdio(c)	((c)->type == MMC_TYPE_SDIO)
-- 
1.7.2.3

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

