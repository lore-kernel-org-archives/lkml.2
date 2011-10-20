Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1JTVxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab1JTVxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:53:03 -0400
Date: Thu, 20 Oct 2011 19:52:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] edac: sb_edac: Add it to the building system
Message-ID: <20111020195233.44c6f5c5@redhat.com>
In-Reply-To: <cover.1319146957.git.mchehab@redhat.com>
References: <cover.1319146957.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some changes on it were required due to changeset cd90cc84c6bf0, that
changed the glue with the MCE logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index d057d6c..d9d40d4 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -212,6 +212,20 @@ config EDAC_I7300
 	  Support for error detection and correction the Intel
 	  Clarksboro MCH (Intel 7300 chipset).
 
+config EDAC_SBRIDGE
+	tristate "Intel Sandy-Bridge Integrated MC"
+	depends on EDAC_MM_EDAC && PCI && X86 && X86_MCE_INTEL
+	help
+	  Support for error detection and correction the Intel
+	  Sandy Bridge Integrated Memory Controller.
+
+config EDAC_SBRIDGE
+	tristate "Intel Sandy-Bridge Integrated MC"
+	depends on EDAC_MM_EDAC && X86 && PCI
+	help
+	  Support for error detection and correction the Intel
+	  Sandy Bridge Integrated Memory Controller.
+
 config EDAC_MPC85XX
 	tristate "Freescale MPC83xx / MPC85xx"
 	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || PPC_85xx)
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index b06a9b1..196a63d 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_EDAC_I5100)		+= i5100_edac.o
 obj-$(CONFIG_EDAC_I5400)		+= i5400_edac.o
 obj-$(CONFIG_EDAC_I7300)		+= i7300_edac.o
 obj-$(CONFIG_EDAC_I7CORE)		+= i7core_edac.o
+obj-$(CONFIG_EDAC_SBRIDGE)		+= sb_edac.o
 obj-$(CONFIG_EDAC_E7XXX)		+= e7xxx_edac.o
 obj-$(CONFIG_EDAC_E752X)		+= e752x_edac.o
 obj-$(CONFIG_EDAC_I82443BXGX)		+= i82443bxgx_edac.o
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 785c276..8118f12 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -18,10 +18,10 @@
 #include <linux/delay.h>
 #include <linux/edac.h>
 #include <linux/mmzone.h>
-#include <linux/edac_mce.h>
 #include <linux/smp.h>
 #include <linux/bitmap.h>
 #include <asm/processor.h>
+#include <asm/mce.h>
 
 #include "edac_core.h"
 
@@ -318,9 +318,6 @@ struct sbridge_pvt {
 	/* Memory type detection */
 	bool			is_mirrored, is_lockstep, is_close_pg;
 
-	/* mcelog glue */
-	struct edac_mce		edac_mce;
-
 	/* Fifo double buffers */
 	struct mce		mce_entry[MCE_LOG_LEN];
 	struct mce		mce_outentry[MCE_LOG_LEN];
@@ -1578,10 +1575,17 @@ static void sbridge_check_error(struct mem_ctl_info *mci)
  * WARNING: As this routine should be called at NMI time, extra care should
  * be taken to avoid deadlocks, and to be as fast as possible.
  */
-static int sbridge_mce_check_error(void *priv, struct mce *mce)
+static int sbridge_mce_check_error(struct notifier_block *nb, unsigned long val,
+				   void *data)
 {
-	struct mem_ctl_info *mci = priv;
-	struct sbridge_pvt *pvt = mci->pvt_info;
+	struct mce *mce = (struct mce *)data;
+	struct mem_ctl_info *mci;
+	struct sbridge_pvt *pvt;
+
+	mci = get_mci_for_node_id(mce->socketid);
+	if (!mci)
+		return NOTIFY_BAD;
+	pvt = mci->pvt_info;
 
 	/*
 	 * Just let mcelog handle it if the error is
@@ -1590,7 +1594,7 @@ static int sbridge_mce_check_error(void *priv, struct mce *mce)
 	 * bit 12 has an special meaning.
 	 */
 	if ((mce->status & 0xefff) >> 7 != 1)
-		return 0;
+		return NOTIFY_DONE;
 
 	printk("sbridge: HANDLING MCE MEMORY ERROR\n");
 
@@ -1607,14 +1611,14 @@ static int sbridge_mce_check_error(void *priv, struct mce *mce)
 #ifdef CONFIG_SMP
 	/* Only handle if it is the right mc controller */
 	if (cpu_data(mce->cpu).phys_proc_id != pvt->sbridge_dev->mc)
-		return 0;
+		return NOTIFY_DONE;
 #endif
 
 	smp_rmb();
 	if ((pvt->mce_out + 1) % MCE_LOG_LEN == pvt->mce_in) {
 		smp_wmb();
 		pvt->mce_overrun++;
-		return 0;
+		return NOTIFY_DONE;
 	}
 
 	/* Copy memory error at the ringbuffer */
@@ -1627,9 +1631,13 @@ static int sbridge_mce_check_error(void *priv, struct mce *mce)
 		sbridge_check_error(mci);
 
 	/* Advice mcelog that the error were handled */
-	return 1;
+	return NOTIFY_STOP;
 }
 
+static struct notifier_block sbridge_mce_dec = {
+	.notifier_call      = sbridge_mce_check_error,
+};
+
 /****************************************************************************
 			EDAC register/unregister logic
  ****************************************************************************/
@@ -1652,8 +1660,8 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
 		__func__, mci, &sbridge_dev->pdev[0]->dev);
 
-	/* Disable MCE NMI handler */
-	edac_mce_unregister(&pvt->edac_mce);
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain,
+					 &sbridge_mce_dec);
 
 	/* Remove MC sysfs nodes */
 	edac_mc_del_mc(mci->dev);
@@ -1722,19 +1730,9 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 		goto fail0;
 	}
 
-	/* Registers on edac_mce in order to receive memory errors */
-	pvt->edac_mce.priv = mci;
-	pvt->edac_mce.check_error = sbridge_mce_check_error;
-	rc = edac_mce_register(&pvt->edac_mce);
-	if (unlikely(rc < 0)) {
-		debugf0("MC: " __FILE__
-			": %s(): failed edac_mce_register()\n", __func__);
-		goto fail1;
-	}
-
+	atomic_notifier_chain_register(&x86_mce_decoder_chain,
+				       &sbridge_mce_dec);
 	return 0;
-fail1:
-	edac_mc_del_mc(mci->dev);
 
 fail0:
 	kfree(mci->ctl_name);
-- 
1.7.6.4


