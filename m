Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab1JFDw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 23:52:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43647 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1JFDwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 23:52:55 -0400
From: Keng-Yu Lin <kengyu@canonical.com>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH 1/2] thinkpad-acpi: disable alsa volume mixer for SL410/SL510
Date: Thu,  6 Oct 2011 11:52:36 +0800
Message-Id: <1317873157-20381-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mute key on SL410/SL510 only works when the alsa volume mixer
is not enabled. This patch makes the alsa volume mixer disabled
on the matched SL410/SL510 EC versions.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 7bd829f..19f0e3d 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6853,6 +6853,7 @@ err_exit:
 
 #define TPACPI_VOL_Q_MUTEONLY	0x0001	/* Mute-only control available */
 #define TPACPI_VOL_Q_LEVEL	0x0002  /* Volume control available */
+#define TPACPI_VOL_Q_BLACKLIST	0x0004  /* Blacklist volume control */
 
 static const struct tpacpi_quirk volume_quirk_table[] __initconst = {
 	/* Whitelist volume level on all IBM by default */
@@ -6869,6 +6870,7 @@ static const struct tpacpi_quirk volume_quirk_table[] __initconst = {
 	TPACPI_QEC_LNV('7', 'J', TPACPI_VOL_Q_LEVEL), /* X60t */
 	TPACPI_QEC_LNV('7', '7', TPACPI_VOL_Q_LEVEL), /* Z60 */
 	TPACPI_QEC_LNV('7', 'F', TPACPI_VOL_Q_LEVEL), /* Z61 */
+	TPACPI_QEC_LNV('6', 'J', TPACPI_VOL_Q_BLACKLIST), /* SL410/SL510 */
 
 	/* Whitelist mute-only on all Lenovo by default */
 	{ .vendor = PCI_VENDOR_ID_LENOVO,
@@ -6903,6 +6905,16 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 	if (volume_capabilities >= TPACPI_VOL_CAP_MAX)
 		return -EINVAL;
 
+	quirks = tpacpi_check_quirks(volume_quirk_table,
+				     ARRAY_SIZE(volume_quirk_table));
+
+	if (quirks & TPACPI_VOL_Q_BLACKLIST) {
+		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
+			"ALSA mixer blacklisted for this model, "
+			"not loading volume subdriver...\n");
+		return 1;
+	}
+
 	/*
 	 * The ALSA mixer is our primary interface.
 	 * When disabled, don't install the subdriver at all
@@ -6914,9 +6926,6 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 		return 1;
 	}
 
-	quirks = tpacpi_check_quirks(volume_quirk_table,
-				     ARRAY_SIZE(volume_quirk_table));
-
 	switch (volume_capabilities) {
 	case TPACPI_VOL_CAP_AUTO:
 		if (quirks & TPACPI_VOL_Q_MUTEONLY)
-- 
1.7.5.4

