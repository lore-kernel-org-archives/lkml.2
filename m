Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935469Ab1JFDxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 23:53:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43652 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934691Ab1JFDxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 23:53:02 -0400
From: Keng-Yu Lin <kengyu@canonical.com>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH 2/2] thinkpad-acpi: add force_volume module parameter
Date: Thu,  6 Oct 2011 11:52:37 +0800
Message-Id: <1317873157-20381-2-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317873157-20381-1-git-send-email-kengyu@canonical.com>
References: <1317873157-20381-1-git-send-email-kengyu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The force_volume module parameter forces to create the ALSA
mixer for the blacklisted models.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 Documentation/laptops/thinkpad-acpi.txt |    4 ++++
 drivers/platform/x86/thinkpad_acpi.c    |   25 +++++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 6181548..8f4adce 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -1186,6 +1186,10 @@ ibm-acpi-devel@lists.sourceforge.net.
 The driver supports the standard ALSA module parameters.  If the ALSA
 mixer is disabled, the driver will disable all volume functionality.
 
+Some models are blacklisted from creating the ALSA interface for
+making the mute key behave properly. To enable the ALSA interface,
+use the module parameter "force_volume=1".
+
 
 Fan control and monitoring: fan speed, fan enable/disable
 ---------------------------------------------------------
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 19f0e3d..4c53e8d 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -476,9 +476,14 @@ struct tpacpi_quirk {
  *
  * The match criteria is: vendor, ec and bios much match.
  */
-static unsigned long __init tpacpi_check_quirks(
+
+#define tpacpi_check_quirks(__qlist, __qlist_size) \
+	_tpacpi_check_quirks(__qlist, __qlist_size, 0)
+
+static unsigned long __init _tpacpi_check_quirks(
 			const struct tpacpi_quirk *qlist,
-			unsigned int qlist_size)
+			unsigned int qlist_size,
+			unsigned int skip_quirk)
 {
 	while (qlist_size) {
 		if ((qlist->vendor == thinkpad_id.vendor ||
@@ -486,9 +491,9 @@ static unsigned long __init tpacpi_check_quirks(
 		    (qlist->bios == thinkpad_id.bios_model ||
 				qlist->bios == TPACPI_MATCH_ANY) &&
 		    (qlist->ec == thinkpad_id.ec_model ||
-				qlist->ec == TPACPI_MATCH_ANY))
+				qlist->ec == TPACPI_MATCH_ANY) &&
+		    (qlist->quirks != skip_quirk))
 			return qlist->quirks;
-
 		qlist_size--;
 		qlist++;
 	}
@@ -6879,6 +6884,8 @@ static const struct tpacpi_quirk volume_quirk_table[] __initconst = {
 	  .quirks = TPACPI_VOL_Q_MUTEONLY }
 };
 
+static uint alsa_force_volume;
+
 static int __init volume_init(struct ibm_init_struct *iibm)
 {
 	unsigned long quirks;
@@ -6908,12 +6915,15 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 	quirks = tpacpi_check_quirks(volume_quirk_table,
 				     ARRAY_SIZE(volume_quirk_table));
 
-	if (quirks & TPACPI_VOL_Q_BLACKLIST) {
+	if (!alsa_force_volume && (quirks & TPACPI_VOL_Q_BLACKLIST)) {
 		dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_MIXER,
 			"ALSA mixer blacklisted for this model, "
 			"not loading volume subdriver...\n");
 		return 1;
-	}
+	} else
+		quirks = _tpacpi_check_quirks(volume_quirk_table,
+					     ARRAY_SIZE(volume_quirk_table),
+					     TPACPI_VOL_Q_BLACKLIST);
 
 	/*
 	 * The ALSA mixer is our primary interface.
@@ -8884,6 +8894,9 @@ module_param_named(id, alsa_id, charp, 0444);
 MODULE_PARM_DESC(id, "ALSA id for the ACPI EC Mixer");
 module_param_named(enable, alsa_enable, bool, 0444);
 MODULE_PARM_DESC(enable, "Enable the ALSA interface for the ACPI EC Mixer");
+module_param_named(force_volume, alsa_force_volume, uint, 0444);
+MODULE_PARM_DESC(force_volume, "Force to enable the ALSA interface "
+				"on the blacklisted machines");
 #endif /* CONFIG_THINKPAD_ACPI_ALSA_SUPPORT */
 
 #define TPACPI_PARAM(feature) \
-- 
1.7.5.4

