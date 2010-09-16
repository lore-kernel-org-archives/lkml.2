Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0IPFKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 01:10:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:31890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab0IPFKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 01:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,374,1280732400"; 
   d="scan'208";a="657838638"
From: minskey guo <chaohong.guo@linux.intel.com>
To: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Cc: chaohong.guo@intel.com, minskey guo <chaohong_guo@linux.intel.com>
Subject: [PATCH]  NULL pointer might be used in ips_monitor()
Date: Thu, 16 Sep 2010 13:06:28 +0800
Message-Id: <1284613588-5199-1-git-send-email-chaohong.guo@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: minskey guo <chaohong_guo@linux.intel.com>

 The patch is to enable creating ips_adjust thread before ips_monitor
 executes because the latter will kthread_stop() or wake up the former
 via ips->adjust pointer. Otherwise, it is possible that ips->adjust is
 NULL when kthread_stop() or wake_up_process() is called in ips_monitor()

 Besides, some trival changes:
   a) correct an define of register bits;
   b) old_cpu_power sample should not be divided by 65535
   c) handling on error path in ips_get_i915_syms()

Signed-off-by: minskey guo <chaohong.guo@intel.com>
---
 drivers/platform/x86/intel_ips.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 9024480..cb59ebd 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -230,7 +230,7 @@
 #define THM_TC2		0xac
 #define THM_DTV		0xb0
 #define THM_ITV		0xd8
-#define   ITV_ME_SEQNO_MASK 0x000f0000 /* ME should update every ~200ms */
+#define   ITV_ME_SEQNO_MASK 0x00ff0000 /* ME should update every ~200ms */
 #define   ITV_ME_SEQNO_SHIFT (16)
 #define   ITV_MCH_TEMP_MASK 0x0000ff00
 #define   ITV_MCH_TEMP_SHIFT (8)
@@ -940,7 +940,6 @@ static int ips_monitor(void *data)
 		kfree(mch_samples);
 		kfree(cpu_samples);
 		kfree(mchp_samples);
-		kthread_stop(ips->adjust);
 		return -ENOMEM;
 	}
 
@@ -948,7 +947,7 @@ static int ips_monitor(void *data)
 		ITV_ME_SEQNO_SHIFT;
 	seqno_timestamp = get_jiffies_64();
 
-	old_cpu_power = thm_readl(THM_CEC) / 65535;
+	old_cpu_power = thm_readl(THM_CEC);
 	schedule_timeout_interruptible(msecs_to_jiffies(IPS_SAMPLE_PERIOD));
 
 	/* Collect an initial average */
@@ -1390,7 +1389,7 @@ static bool ips_get_i915_syms(struct ips_driver *ips)
 	return true;
 
 out_put_busy:
-	symbol_put(i915_gpu_turbo_disable);
+	symbol_put(i915_gpu_busy);
 out_put_lower:
 	symbol_put(i915_gpu_lower);
 out_put_raise:
@@ -1535,19 +1534,24 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	ips_enable_cpu_turbo(ips);
 	ips->cpu_turbo_enabled = true;
 
-	/* Set up the work queue and monitor/adjust threads */
-	ips->monitor = kthread_run(ips_monitor, ips, "ips-monitor");
-	if (IS_ERR(ips->monitor)) {
+	/* Create thermal adjust thread */
+	ips->adjust = kthread_create(ips_adjust, ips, "ips-adjust");
+	if (IS_ERR(ips->adjust)) {
 		dev_err(&dev->dev,
-			"failed to create thermal monitor thread, aborting\n");
+			"failed to create thermal adjust thread, aborting\n");
 		ret = -ENOMEM;
 		goto error_free_irq;
+
 	}
 
-	ips->adjust = kthread_create(ips_adjust, ips, "ips-adjust");
-	if (IS_ERR(ips->adjust)) {
+	/*
+	 * Set up the work queue and monitor thread. The monitor thread
+	 * will wake up ips_adjust thread.
+	 */
+	ips->monitor = kthread_run(ips_monitor, ips, "ips-monitor");
+	if (IS_ERR(ips->monitor)) {
 		dev_err(&dev->dev,
-			"failed to create thermal adjust thread, aborting\n");
+			"failed to create thermal monitor thread, aborting\n");
 		ret = -ENOMEM;
 		goto error_thread_cleanup;
 	}
@@ -1566,7 +1570,7 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	return ret;
 
 error_thread_cleanup:
-	kthread_stop(ips->monitor);
+	kthread_stop(ips->adjust);
 error_free_irq:
 	free_irq(ips->dev->irq, ips);
 error_unmap:
-- 
1.7.1

