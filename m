Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1BJRPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:44 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44627 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab1BJRPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:41 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 12/30] amd64_edac: Cleanup NBCTL code
Date: Thu, 10 Feb 2011 18:15:15 +0100
Message-Id: <1297358133-14320-13-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Remove family names from macro names, drop single bit defines and
comment their meaning instead.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   14 +++++++-------
 drivers/edac/amd64_edac.h |    8 +-------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 495b4d5..9a8a313 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2196,21 +2196,20 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 				       struct pci_dev *F3)
 {
 	bool ret = true;
-	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
+	u32 value, mask = 0x3;		/* UECC/CECC enable */
 
 	if (toggle_ecc_err_reporting(s, nid, ON)) {
 		amd64_warn("Error enabling ECC reporting over MCGCTL!\n");
 		return false;
 	}
 
-	amd64_read_pci_cfg(F3, K8_NBCTL, &value);
+	amd64_read_pci_cfg(F3, NBCTL, &value);
 
-	/* turn on UECCEn and CECCEn bits */
 	s->old_nbctl   = value & mask;
 	s->nbctl_valid = true;
 
 	value |= mask;
-	amd64_write_pci_cfg(F3, K8_NBCTL, value);
+	amd64_write_pci_cfg(F3, NBCTL, value);
 
 	amd64_read_pci_cfg(F3, K8_NBCFG, &value);
 
@@ -2250,16 +2249,17 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 					struct pci_dev *F3)
 {
-	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
+	u32 value, mask = 0x3;		/* UECC/CECC enable */
+
 
 	if (!s->nbctl_valid)
 		return;
 
-	amd64_read_pci_cfg(F3, K8_NBCTL, &value);
+	amd64_read_pci_cfg(F3, NBCTL, &value);
 	value &= ~mask;
 	value |= s->old_nbctl;
 
-	amd64_write_pci_cfg(F3, K8_NBCTL, value);
+	amd64_write_pci_cfg(F3, NBCTL, value);
 
 	/* restore previous BIOS DRAM ECC "off" setting we force-enabled */
 	if (!s->flags.nb_ecc_prev) {
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 0244c61..fc609d1 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -244,13 +244,7 @@
 /*
  * Function 3 - Misc Control
  */
-#define K8_NBCTL			0x40
-
-/* Correctable ECC error reporting enable */
-#define K8_NBCTL_CECCEn			BIT(0)
-
-/* UnCorrectable ECC error reporting enable */
-#define K8_NBCTL_UECCEn			BIT(1)
+#define NBCTL				0x40
 
 #define K8_NBCFG			0x44
 #define K8_NBCFG_CHIPKILL		BIT(23)
-- 
1.7.4.rc2

