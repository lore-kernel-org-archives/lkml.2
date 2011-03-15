Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1COJZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:25:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50409 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1COJZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:25:31 -0400
From: Keng-Yu Lin <keng-yu.lin@canonical.com>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>
Subject: [PATCH] thinkpad-acpi: disable alsa volume mixer for SL410/SL510
Date: Tue, 15 Mar 2011 17:25:06 +0800
Message-Id: <1300181106-20219-1-git-send-email-keng-yu.lin@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mute key on SL410/SL510 only works when the alsa volume mixer
is not enabled. This patch makes the alsa volume mixer disabled
on the matched SL410/SL510 EC versions.

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

BugLink: https://launchpad.net/bugs/595896

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index eb99223..d4ee8f2 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6870,6 +6870,7 @@ err_exit:
 
 #define TPACPI_VOL_Q_MUTEONLY	0x0001	/* Mute-only control available */
 #define TPACPI_VOL_Q_LEVEL	0x0002  /* Volume control available */
+#define TPACPI_VOL_Q_IGNORE	0x0003  /* No Volume control available */
 
 static const struct tpacpi_quirk volume_quirk_table[] __initconst = {
 	/* Whitelist volume level on all IBM by default */
@@ -6886,6 +6887,8 @@ static const struct tpacpi_quirk volume_quirk_table[] __initconst = {
 	TPACPI_QEC_LNV('7', 'J', TPACPI_VOL_Q_LEVEL), /* X60t */
 	TPACPI_QEC_LNV('7', '7', TPACPI_VOL_Q_LEVEL), /* Z60 */
 	TPACPI_QEC_LNV('7', 'F', TPACPI_VOL_Q_LEVEL), /* Z61 */
+	TPACPI_QEC_LNV('6', 'J', TPACPI_VOL_Q_IGNORE), /* SL410/SL510 */
+	TPACPI_QEC_LNV('7', 'X', TPACPI_VOL_Q_IGNORE), /* SL410/SL510 */
 
 	/* Whitelist mute-only on all Lenovo by default */
 	{ .vendor = PCI_VENDOR_ID_LENOVO,
@@ -6921,20 +6924,21 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 	if (volume_capabilities >= TPACPI_VOL_CAP_MAX)
 		return -EINVAL;
 
+	quirks = tpacpi_check_quirks(volume_quirk_table,
+				     ARRAY_SIZE(volume_quirk_table));
+
 	/*
 	 * The ALSA mixer is our primary interface.
 	 * When disabled, don't install the subdriver at all
 	 */
-	if (!alsa_enable) {
+	if (!alsa_enable || quirks & TPACPI_VOL_Q_IGNORE) {
 		vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
 			    "ALSA mixer disabled by parameter, "
 			    "not loading volume subdriver...\n");
+		alsa_enable = 0; /* reflect the quirk status in sysfs */
 		return 1;
 	}
 
-	quirks = tpacpi_check_quirks(volume_quirk_table,
-				     ARRAY_SIZE(volume_quirk_table));
-
 	switch (volume_capabilities) {
 	case TPACPI_VOL_CAP_AUTO:
 		if (quirks & TPACPI_VOL_Q_MUTEONLY)
-- 
1.7.1

