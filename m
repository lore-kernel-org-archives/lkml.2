Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab1FWRZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:25:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917Ab1FWRZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:25:42 -0400
Date: Thu, 23 Jun 2011 13:25:41 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172541.27789.40847.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 34/35] sound/pci/hda changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/pci/hda changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 sound/pci/hda/patch_sigmatel.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 7f81cc2..271ea6a 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -28,7 +28,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
 #include <sound/core.h>
 #include <sound/asoundef.h>
 #include <sound/jack.h>
@@ -4798,26 +4798,23 @@ static void set_hp_led_gpio(struct hda_codec *codec)
 static int find_mute_led_gpio(struct hda_codec *codec, int default_polarity)
 {
 	struct sigmatel_spec *spec = codec->spec;
-	const struct dmi_device *dev = NULL;
+	const char *str;
 
 	if ((codec->subsystem_id >> 16) == PCI_VENDOR_ID_HP) {
-		while ((dev = dmi_find_device(DMI_DEV_TYPE_OEM_STRING,
-								NULL, dev))) {
-			if (sscanf(dev->name, "HP_Mute_LED_%d_%d",
-				  &spec->gpio_led_polarity,
-				  &spec->gpio_led) == 2) {
-				spec->gpio_led = 1 << spec->gpio_led;
-				return 1;
-			}
-			if (sscanf(dev->name, "HP_Mute_LED_%d",
-				  &spec->gpio_led_polarity) == 1) {
-				set_hp_led_gpio(codec);
-				return 1;
-			}
+		str = smbios_match_oem_string("HP_Mute_LED_");
+		if (sscanf(str, "HP_Mute_LED_%d_%d", &spec->gpio_led_polarity,
+			   &spec->gpio_led) == 2) {
+			spec->gpio_led = 1 << spec->gpio_led;
+			return 1;
+		}
+		if (sscanf(str, "HP_Mute_LED_%d",
+			   &spec->gpio_led_polarity) == 1) {
+			set_hp_led_gpio(codec);
+			return 1;
 		}
 
 		/*
-		 * Fallback case - if we don't find the DMI strings,
+		 * Fallback case - if we don't find the SMBIOS strings,
 		 * we statically set the GPIO - if not a B-series system.
 		 */
 		if (!hp_blike_system(codec->subsystem_id)) {
-- 
1.7.5.4

