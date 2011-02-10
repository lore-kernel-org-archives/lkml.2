Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab1BJRQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:16:15 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44678 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1BJRQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:16:09 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 28/30] amd64_edac: Simplify scrubrate setting
Date: Thu, 10 Feb 2011 18:15:31 +0100
Message-Id: <1297358133-14320-29-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Drop per-instance variable and compute min scrubrate dynamically.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    8 +++++---
 drivers/edac/amd64_edac.h |   10 ----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index eb6b6ba..0caf05e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -193,8 +193,12 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
 static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
+	u32 min_scrubrate = 0x5;
 
-	return __amd64_set_scrub_rate(pvt->F3, bw, pvt->min_scrubrate);
+	if (boot_cpu_data.x86 == 0xf)
+		min_scrubrate = 0x0;
+
+	return __amd64_set_scrub_rate(pvt->F3, bw, min_scrubrate);
 }
 
 static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
@@ -2399,13 +2403,11 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 		fam_type		= &amd64_family_types[K8_CPUS];
 		pvt->ops		= &amd64_family_types[K8_CPUS].ops;
 		pvt->ctl_name		= fam_type->ctl_name;
-		pvt->min_scrubrate	= K8_MIN_SCRUB_RATE_BITS;
 		break;
 	case 0x10:
 		fam_type		= &amd64_family_types[F10_CPUS];
 		pvt->ops		= &amd64_family_types[F10_CPUS].ops;
 		pvt->ctl_name		= fam_type->ctl_name;
-		pvt->min_scrubrate	= F10_MIN_SCRUB_RATE_BITS;
 		break;
 
 	default:
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8e431ab..3f853ed 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -368,9 +368,6 @@ struct amd64_pvt {
 	/* place to store error injection parameters prior to issue */
 	struct error_injection injection;
 
-	/* DCT per-family scrubrate setting */
-	u32 min_scrubrate;
-
 	/* family name this instance is running on */
 	const char *ctl_name;
 
@@ -468,12 +465,5 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
 #define amd64_read_dct_pci_cfg(pvt, offset, val) \
 	pvt->ops->read_dct_pci_cfg(pvt, offset, val, __func__)
 
-/*
- * For future CPU versions, verify the following as new 'slow' rates appear and
- * modify the necessary skip values for the supported CPU.
- */
-#define K8_MIN_SCRUB_RATE_BITS	0x0
-#define F10_MIN_SCRUB_RATE_BITS	0x5
-
 int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 			     u64 *hole_offset, u64 *hole_size);
-- 
1.7.4.rc2

