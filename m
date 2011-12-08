Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1LHOJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:09:15 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43619 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab1LHOJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:09:09 -0500
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] x86, mce: Add wrappers for registering on the decode chain
Date: Thu,  8 Dec 2011 15:08:51 +0100
Message-Id: <1323353332-5671-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1323353332-5671-1-git-send-email-bp@amd64.org>
References: <1323353332-5671-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

No functionality change, this is done so that in a follow-on patch all
queued-up MCEs can be decoded after registering on the chain.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |    3 ++-
 arch/x86/kernel/cpu/mcheck/mce.c |   25 ++++++++++++++++++-------
 drivers/edac/i7core_edac.c       |    4 ++--
 drivers/edac/mce_amd.c           |    4 ++--
 drivers/edac/sb_edac.c           |    6 ++----
 5 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 0e8ae57..b7c47a4 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -120,7 +120,8 @@ struct mce_log {
 
 #ifdef __KERNEL__
 
-extern struct atomic_notifier_head x86_mce_decoder_chain;
+extern void mce_register_decode_chain(struct notifier_block *nb);
+extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
 #include <linux/percpu.h>
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2af127d..c3c66ac 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -95,13 +95,6 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
-/*
- * CPU/chipset specific EDAC code can register a notifier call here to print
- * MCE errors in a human-readable form.
- */
-ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
-EXPORT_SYMBOL_GPL(x86_mce_decoder_chain);
-
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
@@ -109,6 +102,12 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
+/*
+ * CPU/chipset specific EDAC code can register a notifier call here to print
+ * MCE errors in a human-readable form.
+ */
+ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
+
 /* Do initial initialization of a struct mce */
 void mce_setup(struct mce *m)
 {
@@ -190,6 +189,18 @@ void mce_log(struct mce *mce)
 	set_bit(0, &mce_need_notify);
 }
 
+void mce_register_decode_chain(struct notifier_block *nb)
+{
+	atomic_notifier_chain_register(&x86_mce_decoder_chain, nb);
+}
+EXPORT_SYMBOL_GPL(mce_register_decode_chain);
+
+void mce_unregister_decode_chain(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, nb);
+}
+EXPORT_SYMBOL_GPL(mce_unregister_decode_chain);
+
 static void print_mce(struct mce *m)
 {
 	int ret = 0;
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 70ad892..8568d9b 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -2234,7 +2234,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	if (pvt->enable_scrub)
 		disable_sdram_scrub_setting(mci);
 
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &i7_mce_dec);
+	mce_unregister_decode_chain(&i7_mce_dec);
 
 	/* Disable EDAC polling */
 	i7core_pci_ctl_release(pvt);
@@ -2336,7 +2336,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* DCLK for scrub rate setting */
 	pvt->dclk_freq = get_dclk_freq();
 
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &i7_mce_dec);
+	mce_register_decode_chain(&i7_mce_dec);
 
 	return 0;
 
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index d0864d9..bd926ea 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -884,7 +884,7 @@ static int __init mce_amd_init(void)
 
 	pr_info("MCE: In-kernel MCE decoding enabled.\n");
 
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
+	mce_register_decode_chain(&amd_mce_dec_nb);
 
 	return 0;
 }
@@ -893,7 +893,7 @@ early_initcall(mce_amd_init);
 #ifdef MODULE
 static void __exit mce_amd_exit(void)
 {
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &amd_mce_dec_nb);
+	mce_unregister_decode_chain(&amd_mce_dec_nb);
 	kfree(fam_ops);
 }
 
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 7a402bf..965bc0c 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1661,8 +1661,7 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
 		__func__, mci, &sbridge_dev->pdev[0]->dev);
 
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain,
-					 &sbridge_mce_dec);
+	mce_unregister_decode_chain(&sbridge_mce_dec);
 
 	/* Remove MC sysfs nodes */
 	edac_mc_del_mc(mci->dev);
@@ -1731,8 +1730,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 		goto fail0;
 	}
 
-	atomic_notifier_chain_register(&x86_mce_decoder_chain,
-				       &sbridge_mce_dec);
+	mce_register_decode_chain(&sbridge_mce_dec);
 	return 0;
 
 fail0:
-- 
1.7.8.rc0

