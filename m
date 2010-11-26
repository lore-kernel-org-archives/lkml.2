Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0KZTFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:14 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46273 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0KZTFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:11 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 03/16] amd64_edac: Add per-family init function
Date: Fri, 26 Nov 2010 20:04:10 +0100
Message-Id: <1290798263-13074-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Run a per-family init function which does all the settings based on
the family this driver instance is running on. Move the scrubrate
calculation in it and simplify code.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   44 +++++++++++++++++++++++++-------------------
 drivers/edac/amd64_edac.h |    3 +++
 2 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 7f3609d..bb9a342 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -117,8 +117,7 @@ struct scrubrate scrubrates[] = {
  * scan the scrub rate mapping table for a close or matching bandwidth value to
  * issue. If requested is too big, then use last maximum value found.
  */
-static int amd64_search_set_scrub_rate(struct pci_dev *ctl, u32 new_bw,
-				       u32 min_scrubrate)
+static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
 {
 	u32 scrubval;
 	int i;
@@ -134,7 +133,7 @@ static int amd64_search_set_scrub_rate(struct pci_dev *ctl, u32 new_bw,
 		 * skip scrub rates which aren't recommended
 		 * (see F10 BKDG, F3x58)
 		 */
-		if (scrubrates[i].scrubval < min_scrubrate)
+		if (scrubrates[i].scrubval < min_rate)
 			continue;
 
 		if (scrubrates[i].bandwidth <= new_bw)
@@ -160,25 +159,11 @@ static int amd64_search_set_scrub_rate(struct pci_dev *ctl, u32 new_bw,
 	return 0;
 }
 
-static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bandwidth)
+static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	u32 min_scrubrate = 0x0;
 
-	switch (boot_cpu_data.x86) {
-	case 0xf:
-		min_scrubrate = K8_MIN_SCRUB_RATE_BITS;
-		break;
-	case 0x10:
-		min_scrubrate = F10_MIN_SCRUB_RATE_BITS;
-		break;
-
-	default:
-		amd64_printk(KERN_ERR, "Unsupported family!\n");
-		return -EINVAL;
-	}
-	return amd64_search_set_scrub_rate(pvt->misc_f3_ctl, bandwidth,
-					   min_scrubrate);
+	return __amd64_set_scrub_rate(pvt->misc_f3_ctl, bw, pvt->min_scrubrate);
 }
 
 static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
@@ -2607,6 +2592,23 @@ static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
 	mci->get_sdram_scrub_rate = amd64_get_scrub_rate;
 }
 
+static int amd64_per_family_init(struct amd64_pvt *pvt)
+{
+	switch (boot_cpu_data.x86) {
+	case 0xf:
+		pvt->min_scrubrate = K8_MIN_SCRUB_RATE_BITS;
+		break;
+	case 0x10:
+		pvt->min_scrubrate = F10_MIN_SCRUB_RATE_BITS;
+		break;
+
+	default:
+		amd64_printk(KERN_ERR, "Unsupported family!\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * Init stuff for this DRAM Controller device.
  *
@@ -2637,6 +2639,10 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
 	pvt->mc_type_index	= mc_type_index;
 	pvt->ops		= family_ops(mc_type_index);
 
+	ret = -EINVAL;
+	if (amd64_per_family_init(pvt))
+		goto err_free;
+
 	/*
 	 * We have the dram_f2_ctl device as an argument, now go reserve its
 	 * sibling devices from the PCI system.
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index c8f2734..e5204fe 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -461,6 +461,9 @@ struct amd64_pvt {
 	/* MC Type Index value: socket F vs Family 10h */
 	u32 mc_type_index;
 
+	/* DCT per-family scrubrate setting */
+	u32 min_scrubrate;
+
 	/* misc settings */
 	struct flags {
 		unsigned long cf8_extcfg:1;
-- 
1.7.3.1.50.g1e633

