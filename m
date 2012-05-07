Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2EGNFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:05:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:2520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab2EGNFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:05:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="140949620"
From: Chen Gong <gong.chen@linux.intel.com>
To: mchehab@redhat.com
Cc: bp@amd64.org, tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH V3] edac: avoid mce decoding crash after edac driver unloaded
Date: Mon,  7 May 2012 21:05:50 +0800
Message-Id: <1336395950-12430-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336374233-11482-1-git-send-email-gong.chen@linux.intel.com>
References: <1336374233-11482-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some edac drivers register themselves as mce decoders via
notifier_chain. But in current notifier_chain implementation logic,
it doesn't accept same notifier registered twice. If so, it will be
wrong when adding/removing the element from the list. For example,
on one SandyBridge platform, remove module sb_edac and then trigger
one error, it will hit oops because it has no mce decoder registered
but related notifier_chain still points to an invalid callback
function. Here is an example:

Call Trace:
 [<ffffffff8150ef6a>] atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff8102b936>] mce_log+0x46/0x180
 [<ffffffff8102eaea>] apei_mce_report_mem_error+0x4a/0x60
 [<ffffffff812e19d2>] ghes_do_proc+0x192/0x210
 [<ffffffff812e2066>] ghes_proc+0x46/0x70
 [<ffffffff812e20d8>] ghes_notify_sci+0x48/0x80
 [<ffffffff8150ef05>] notifier_call_chain+0x55/0x80
 [<ffffffff81076f1a>] __blocking_notifier_call_chain+0x5a/0x80
 [<ffffffff812aea11>] ? acpi_os_wait_events_complete+0x23/0x23
 [<ffffffff81076f56>] blocking_notifier_call_chain+0x16/0x20
 [<ffffffff812ddc4d>] acpi_hed_notify+0x19/0x1b
 [<ffffffff812b16bd>] acpi_device_notify+0x19/0x1b
 [<ffffffff812beb38>] acpi_ev_notify_dispatch+0x67/0x7f
 [<ffffffff812aea3a>] acpi_os_execute_deferred+0x29/0x36
 [<ffffffff81069dc2>] process_one_work+0x132/0x450
 [<ffffffff8106bbcb>] worker_thread+0x17b/0x3c0
 [<ffffffff8106ba50>] ? manage_workers+0x120/0x120
 [<ffffffff81070aee>] kthread+0x9e/0xb0
 [<ffffffff81514724>] kernel_thread_helper+0x4/0x10
 [<ffffffff81070a50>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff81514720>] ? gs_change+0x13/0x13
Code: f3 49 89 d4 45 85 ed 4d 89 c6 48 8b 0f 74 48 48 85 c9 75 17 eb 41
0f 1f 80 00 00 00 00 41 83 ed 01 4c 89 f9 74 22 4d 85 ff 74 1d <4c> 8b
79 08 4c 89 e2 48 89 de 48 89 cf ff 11 4d 85 f6 74 04 41
RIP  [<ffffffff8150eef6>] notifier_call_chain+0x46/0x80
 RSP <ffff88042868fb20>
CR2: ffffffffa01af838
---[ end trace 0100930068e73e6f ]---
BUG: unable to handle kernel paging request at fffffffffffffff8
IP: [<ffffffff810705b0>] kthread_data+0x10/0x20
PGD 1a0d067 PUD 1a0e067 PMD 0
Oops: 0000 [#2] SMP

Only i7core_edac and sb_edac have such issues because they have more
than one memory controller which means they have to register mce
decoder many times.

v3->v2:
  remove dead code in i7core_edac, suggested by Mauro

v2->v1:
  move register/unregister to the init/exit part

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/edac/i7core_edac.c |   15 ++++-----------
 drivers/edac/sb_edac.c     |    8 ++++----
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 85226cc..0fe2277 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1932,12 +1932,6 @@ static int i7core_mce_check_error(struct notifier_block *nb, unsigned long val,
 	if (mce->bank != 8)
 		return NOTIFY_DONE;
 
-#ifdef CONFIG_SMP
-	/* Only handle if it is the right mc controller */
-	if (mce->socketid != pvt->i7core_dev->socket)
-		return NOTIFY_DONE;
-#endif
-
 	smp_rmb();
 	if ((pvt->mce_out + 1) % MCE_LOG_LEN == pvt->mce_in) {
 		smp_wmb();
@@ -2234,8 +2228,6 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	if (pvt->enable_scrub)
 		disable_sdram_scrub_setting(mci);
 
-	mce_unregister_decode_chain(&i7_mce_dec);
-
 	/* Disable EDAC polling */
 	i7core_pci_ctl_release(pvt);
 
@@ -2336,8 +2328,6 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* DCLK for scrub rate setting */
 	pvt->dclk_freq = get_dclk_freq();
 
-	mce_register_decode_chain(&i7_mce_dec);
-
 	return 0;
 
 fail0:
@@ -2481,8 +2471,10 @@ static int __init i7core_init(void)
 
 	pci_rc = pci_register_driver(&i7core_driver);
 
-	if (pci_rc >= 0)
+	if (pci_rc >= 0) {
+		mce_register_decode_chain(&i7_mce_dec);
 		return 0;
+	}
 
 	i7core_printk(KERN_ERR, "Failed to register device with error %d.\n",
 		      pci_rc);
@@ -2498,6 +2490,7 @@ static void __exit i7core_exit(void)
 {
 	debugf2("MC: " __FILE__ ": %s()\n", __func__);
 	pci_unregister_driver(&i7core_driver);
+	mce_unregister_decode_chain(&i7_mce_dec);
 }
 
 module_init(i7core_init);
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index a203536..e9858ba 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1669,8 +1669,6 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
 		__func__, mci, &sbridge_dev->pdev[0]->dev);
 
-	mce_unregister_decode_chain(&sbridge_mce_dec);
-
 	/* Remove MC sysfs nodes */
 	edac_mc_del_mc(mci->dev);
 
@@ -1738,7 +1736,6 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 		goto fail0;
 	}
 
-	mce_register_decode_chain(&sbridge_mce_dec);
 	return 0;
 
 fail0:
@@ -1867,8 +1864,10 @@ static int __init sbridge_init(void)
 
 	pci_rc = pci_register_driver(&sbridge_driver);
 
-	if (pci_rc >= 0)
+	if (pci_rc >= 0) {
+		mce_register_decode_chain(&sbridge_mce_dec);
 		return 0;
+	}
 
 	sbridge_printk(KERN_ERR, "Failed to register device with error %d.\n",
 		      pci_rc);
@@ -1884,6 +1883,7 @@ static void __exit sbridge_exit(void)
 {
 	debugf2("MC: " __FILE__ ": %s()\n", __func__);
 	pci_unregister_driver(&sbridge_driver);
+	mce_unregister_decode_chain(&sbridge_mce_dec);
 }
 
 module_init(sbridge_init);
-- 
1.7.10

