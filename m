Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab0DOBDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:03:52 -0400
Received: from [69.28.251.93] ([69.28.251.93]:37944 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab0DOBDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:03:51 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 14 Apr 2010 17:57:33 -0700
Subject: [PATCHv2 1/2] MTD: cfi_cmdset_0002: Add reboot notifier for AMD flashes
Message-Id: <a00f98bfcda7db841108605ebab8d07363f4aa8b@localhost.localdomain>
In-Reply-To: <1271221078.2532.5.camel@localhost.localdomain>
References: <1271221078.2532.5.camel@localhost.localdomain>
To: <dwmw2@infradead.org>, <dedekind1@gmail.com>
Cc: <saeed.bishara@gmail.com>, <linux-mtd@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the flash device is in a quiescent state before rebooting.
The implementation is closely modeled after the cfe_cmdset_0001 reboot
notifier, commit 963a6fb0a0d336d0513083b7e4b5c3ff9d6d2061 .

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/chips/cfi_cmdset_0002.c |   56 +++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index ea2a7f6..f40d308 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/reboot.h>
 #include <linux/mtd/compatmac.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/mtd.h>
@@ -56,6 +57,7 @@ static int cfi_amdstd_erase_varsize(struct mtd_info *, struct erase_info *);
 static void cfi_amdstd_sync (struct mtd_info *);
 static int cfi_amdstd_suspend (struct mtd_info *);
 static void cfi_amdstd_resume (struct mtd_info *);
+static int cfi_amdstd_reboot(struct notifier_block *, unsigned long, void *);
 static int cfi_amdstd_secsi_read (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 
 static void cfi_amdstd_destroy(struct mtd_info *);
@@ -351,6 +353,8 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
 	mtd->name    = map->name;
 	mtd->writesize = 1;
 
+	mtd->reboot_notifier.notifier_call = cfi_amdstd_reboot;
+
 	if (cfi->cfi_mode==CFI_MODE_CFI){
 		unsigned char bootloc;
 		/*
@@ -487,6 +491,7 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
 #endif
 
 	__module_get(THIS_MODULE);
+	register_reboot_notifier(&mtd->reboot_notifier);
 	return mtd;
 
  setup_err:
@@ -628,6 +633,10 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 		chip->state = FL_READY;
 		return 0;
 
+	case FL_SHUTDOWN:
+		/* The machine is rebooting */
+		return -EIO;
+
 	case FL_POINT:
 		/* Only if there's no operation suspended... */
 		if (mode == FL_READY && chip->oldstate == FL_READY)
@@ -1918,11 +1927,58 @@ static void cfi_amdstd_resume(struct mtd_info *mtd)
 	}
 }
 
+
+/*
+ * Ensure that the flash device is put back into read array mode before
+ * unloading the driver or rebooting.  On some systems, rebooting while
+ * the flash is in query/program/erase mode will prevent the CPU from
+ * fetching the bootloader code, requiring a hard reset or power cycle.
+ */
+static int cfi_amdstd_reset(struct mtd_info *mtd)
+{
+	struct map_info *map = mtd->priv;
+	struct cfi_private *cfi = map->fldrv_priv;
+	int i, ret;
+	struct flchip *chip;
+
+	for (i = 0; i < cfi->numchips; i++) {
+
+		chip = &cfi->chips[i];
+
+		spin_lock(chip->mutex);
+
+		ret = get_chip(map, chip, chip->start, FL_SHUTDOWN);
+		if (!ret) {
+			map_write(map, CMD(0xF0), chip->start);
+			chip->state = FL_SHUTDOWN;
+			put_chip(map, chip, chip->start);
+		}
+
+		spin_unlock(chip->mutex);
+	}
+
+	return 0;
+}
+
+
+static int cfi_amdstd_reboot(struct notifier_block *nb, unsigned long val,
+			       void *v)
+{
+	struct mtd_info *mtd;
+
+	mtd = container_of(nb, struct mtd_info, reboot_notifier);
+	cfi_amdstd_reset(mtd);
+	return NOTIFY_DONE;
+}
+
+
 static void cfi_amdstd_destroy(struct mtd_info *mtd)
 {
 	struct map_info *map = mtd->priv;
 	struct cfi_private *cfi = map->fldrv_priv;
 
+	cfi_amdstd_reset(mtd);
+	unregister_reboot_notifier(&mtd->reboot_notifier);
 	kfree(cfi->cmdset_priv);
 	kfree(cfi->cfiq);
 	kfree(cfi);
-- 
1.6.3.1

