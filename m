Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1GROZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:25:14 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56290 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab1GROZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:25:09 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] i7core_edac: Drop the edac_mce facility
Date: Mon, 18 Jul 2011 16:24:46 +0200
Message-Id: <1310999086-30870-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1310999086-30870-1-git-send-email-bp@amd64.org>
References: <1310999086-30870-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Remove edac_mce pieces and use the normal MCE decoder notifier chain by
retaining the same functionality with considerably less code.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    1 -
 drivers/edac/Kconfig             |    3 --
 drivers/edac/Makefile            |    1 -
 drivers/edac/edac_mce.c          |   61 --------------------------------------
 drivers/edac/i7core_edac.c       |   51 +++++++++++++++----------------
 include/linux/edac_mce.h         |   31 -------------------
 6 files changed, 25 insertions(+), 123 deletions(-)
 delete mode 100644 drivers/edac/edac_mce.c
 delete mode 100644 include/linux/edac_mce.h

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 019786a..63aad27 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -36,7 +36,6 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/debugfs.h>
-#include <linux/edac_mce.h>
 #include <linux/irq_work.h>
 
 #include <asm/processor.h>
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index af1a17d..f888fb5 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -71,9 +71,6 @@ config EDAC_MM_EDAC
 	  occurred so that a particular failing memory module can be
 	  replaced.  If unsure, select 'Y'.
 
-config EDAC_MCE
-	bool
-
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h"
 	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && EDAC_DECODE_MCE
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 3e23913..b06a9b1 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -8,7 +8,6 @@
 
 obj-$(CONFIG_EDAC)			:= edac_stub.o
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
-obj-$(CONFIG_EDAC_MCE)			+= edac_mce.o
 
 edac_core-y	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
 edac_core-y	+= edac_module.o edac_device_sysfs.o
diff --git a/drivers/edac/edac_mce.c b/drivers/edac/edac_mce.c
deleted file mode 100644
index 9ccdc5b..0000000
--- a/drivers/edac/edac_mce.c
+++ /dev/null
@@ -1,61 +0,0 @@
-/* Provides edac interface to mcelog events
- *
- * This file may be distributed under the terms of the
- * GNU General Public License version 2.
- *
- * Copyright (c) 2009 by:
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * Red Hat Inc. http://www.redhat.com
- */
-
-#include <linux/module.h>
-#include <linux/edac_mce.h>
-#include <asm/mce.h>
-
-int edac_mce_enabled;
-EXPORT_SYMBOL_GPL(edac_mce_enabled);
-
-
-/*
- * Extension interface
- */
-
-static LIST_HEAD(edac_mce_list);
-static DEFINE_MUTEX(edac_mce_lock);
-
-int edac_mce_register(struct edac_mce *edac_mce)
-{
-	mutex_lock(&edac_mce_lock);
-	list_add_tail(&edac_mce->list, &edac_mce_list);
-	mutex_unlock(&edac_mce_lock);
-	return 0;
-}
-EXPORT_SYMBOL(edac_mce_register);
-
-void edac_mce_unregister(struct edac_mce *edac_mce)
-{
-	mutex_lock(&edac_mce_lock);
-	list_del(&edac_mce->list);
-	mutex_unlock(&edac_mce_lock);
-}
-EXPORT_SYMBOL(edac_mce_unregister);
-
-int edac_mce_parse(struct mce *mce)
-{
-	struct edac_mce *edac_mce;
-
-	list_for_each_entry(edac_mce, &edac_mce_list, list) {
-		if (edac_mce->check_error(edac_mce->priv, mce))
-			return 1;
-	}
-
-	/* Nobody queued the error */
-	return 0;
-}
-EXPORT_SYMBOL_GPL(edac_mce_parse);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
-MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
-MODULE_DESCRIPTION("EDAC Driver for mcelog captured errors");
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 04f1e7c..26171df 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -33,8 +33,8 @@
 #include <linux/delay.h>
 #include <linux/edac.h>
 #include <linux/mmzone.h>
-#include <linux/edac_mce.h>
 #include <linux/smp.h>
+#include <asm/mce.h>
 #include <asm/processor.h>
 
 #include "edac_core.h"
@@ -255,9 +255,6 @@ struct i7core_pvt {
 
 	unsigned int	is_registered;
 
-	/* mcelog glue */
-	struct edac_mce		edac_mce;
-
 	/* Fifo double buffers */
 	struct mce		mce_entry[MCE_LOG_LEN];
 	struct mce		mce_outentry[MCE_LOG_LEN];
@@ -1826,33 +1823,43 @@ check_ce_error:
  * WARNING: As this routine should be called at NMI time, extra care should
  * be taken to avoid deadlocks, and to be as fast as possible.
  */
-static int i7core_mce_check_error(void *priv, struct mce *mce)
+static int i7core_mce_check_error(struct notifier_block *nb, unsigned long val,
+				  void *data)
 {
-	struct mem_ctl_info *mci = priv;
-	struct i7core_pvt *pvt = mci->pvt_info;
+	struct mce *mce = (struct mce *)data;
+	struct i7core_dev *i7_dev;
+	struct mem_ctl_info *mci;
+	struct i7core_pvt *pvt;
+
+	i7_dev = get_i7core_dev(mce->socketid);
+	if (!i7_dev)
+		return NOTIFY_BAD;
+
+	mci = i7_dev->mci;
+	pvt = mci->pvt_info;
 
 	/*
 	 * Just let mcelog handle it if the error is
 	 * outside the memory controller
 	 */
 	if (((mce->status & 0xffff) >> 7) != 1)
-		return 0;
+		return NOTIFY_DONE;
 
 	/* Bank 8 registers are the only ones that we know how to handle */
 	if (mce->bank != 8)
-		return 0;
+		return NOTIFY_DONE;
 
 #ifdef CONFIG_SMP
 	/* Only handle if it is the right mc controller */
 	if (cpu_data(mce->cpu).phys_proc_id != pvt->i7core_dev->socket)
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
@@ -1865,9 +1872,13 @@ static int i7core_mce_check_error(void *priv, struct mce *mce)
 		i7core_check_error(mci);
 
 	/* Advise mcelog that the errors were handled */
-	return 1;
+	return NOTIFY_STOP;
 }
 
+static struct notifier_block i7_mce_dec = {
+	.notifier_call	= i7core_mce_check_error,
+};
+
 static void i7core_pci_ctl_create(struct i7core_pvt *pvt)
 {
 	pvt->i7core_pci = edac_pci_create_generic_ctl(
@@ -1906,8 +1917,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
 		__func__, mci, &i7core_dev->pdev[0]->dev);
 
-	/* Disable MCE NMI handler */
-	edac_mce_unregister(&pvt->edac_mce);
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &i7_mce_dec);
 
 	/* Disable EDAC polling */
 	i7core_pci_ctl_release(pvt);
@@ -2002,21 +2012,10 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* allocating generic PCI control info */
 	i7core_pci_ctl_create(pvt);
 
-	/* Registers on edac_mce in order to receive memory errors */
-	pvt->edac_mce.priv = mci;
-	pvt->edac_mce.check_error = i7core_mce_check_error;
-	rc = edac_mce_register(&pvt->edac_mce);
-	if (unlikely(rc < 0)) {
-		debugf0("MC: " __FILE__
-			": %s(): failed edac_mce_register()\n", __func__);
-		goto fail1;
-	}
+	atomic_notifier_chain_register(&x86_mce_decoder_chain, &i7_mce_dec);
 
 	return 0;
 
-fail1:
-	i7core_pci_ctl_release(pvt);
-	edac_mc_del_mc(mci->dev);
 fail0:
 	kfree(mci->ctl_name);
 	edac_mc_free(mci);
diff --git a/include/linux/edac_mce.h b/include/linux/edac_mce.h
deleted file mode 100644
index f974fc0..0000000
--- a/include/linux/edac_mce.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/* Provides edac interface to mcelog events
- *
- * This file may be distributed under the terms of the
- * GNU General Public License version 2.
- *
- * Copyright (c) 2009 by:
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * Red Hat Inc. http://www.redhat.com
- */
-
-#if defined(CONFIG_EDAC_MCE) || \
-			(defined(CONFIG_EDAC_MCE_MODULE) && defined(MODULE))
-
-#include <asm/mce.h>
-#include <linux/list.h>
-
-struct edac_mce {
-	struct list_head list;
-
-	void *priv;
-	int (*check_error)(void *priv, struct mce *mce);
-};
-
-int edac_mce_register(struct edac_mce *edac_mce);
-void edac_mce_unregister(struct edac_mce *edac_mce);
-int edac_mce_parse(struct mce *mce);
-
-#else
-#define edac_mce_parse(mce) (0)
-#endif
-- 
1.7.4.rc2

