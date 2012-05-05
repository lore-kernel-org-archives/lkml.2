Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab2EEBTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 21:19:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:63745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab2EEBTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 21:19:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="140317344"
From: Chen Gong <gong.chen@linux.intel.com>
To: mchehab@redhat.com
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH] edac: avoid mce decoding crash after edac driver unloaded
Date: Sat,  5 May 2012 09:20:36 +0800
Message-Id: <1336180836-9108-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some edac drivers register themselves as mce decoders via
notifier_chain. But in current notifier_chain implementation logic,
it doesn't accept same notifier registered twice. If so, it will be
wrong when removing the element from the list. For example, on one
SandyBridge platform, remove module sb_edac and then trigger one
error, it will hit oops because it has no mce decoder registered
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

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/edac/i7core_edac.c |   12 ++++++++++--
 drivers/edac/sb_edac.c     |   12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 85226cc..1852a52 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -2216,6 +2216,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 {
 	struct mem_ctl_info *mci = i7core_dev->mci;
 	struct i7core_pvt *pvt;
+	static int once;
 
 	if (unlikely(!mci || !mci->pvt_info)) {
 		debugf0("MC: " __FILE__ ": %s(): dev = %p\n",
@@ -2234,7 +2235,10 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	if (pvt->enable_scrub)
 		disable_sdram_scrub_setting(mci);
 
-	mce_unregister_decode_chain(&i7_mce_dec);
+	if (!once) {
+		mce_unregister_decode_chain(&i7_mce_dec);
+		once = 1;
+	}
 
 	/* Disable EDAC polling */
 	i7core_pci_ctl_release(pvt);
@@ -2253,6 +2257,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	struct mem_ctl_info *mci;
 	struct i7core_pvt *pvt;
 	int rc, channels, csrows;
+	static int once;
 
 	/* Check the number of active and not disabled channels */
 	rc = i7core_get_active_channels(i7core_dev->socket, &channels, &csrows);
@@ -2336,7 +2341,10 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* DCLK for scrub rate setting */
 	pvt->dclk_freq = get_dclk_freq();
 
-	mce_register_decode_chain(&i7_mce_dec);
+	if (!once) {
+		mce_register_decode_chain(&i7_mce_dec);
+		once = 1;
+	}
 
 	return 0;
 
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index a203536..20fabc8 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1655,6 +1655,7 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 {
 	struct mem_ctl_info *mci = sbridge_dev->mci;
 	struct sbridge_pvt *pvt;
+	static int once;
 
 	if (unlikely(!mci || !mci->pvt_info)) {
 		debugf0("MC: " __FILE__ ": %s(): dev = %p\n",
@@ -1669,7 +1670,10 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
 		__func__, mci, &sbridge_dev->pdev[0]->dev);
 
-	mce_unregister_decode_chain(&sbridge_mce_dec);
+	if (!once) {
+		mce_unregister_decode_chain(&sbridge_mce_dec);
+		once = 1;
+	}
 
 	/* Remove MC sysfs nodes */
 	edac_mc_del_mc(mci->dev);
@@ -1685,6 +1689,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	struct mem_ctl_info *mci;
 	struct sbridge_pvt *pvt;
 	int rc, channels, csrows;
+	static int once;
 
 	/* Check the number of active and not disabled channels */
 	rc = sbridge_get_active_channels(sbridge_dev->bus, &channels, &csrows);
@@ -1738,7 +1743,10 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 		goto fail0;
 	}
 
-	mce_register_decode_chain(&sbridge_mce_dec);
+	if (!once) {
+		mce_register_decode_chain(&sbridge_mce_dec);
+		once = 1;
+	}
 	return 0;
 
 fail0:
-- 
1.7.10

