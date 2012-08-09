Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2HIGp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:45:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52312 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2HIGp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:45:27 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: hda - Defer probe when loading patch firmware
Date: Thu,  9 Aug 2012 08:45:23 +0200
Message-Id: <1344494723-6827-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.4
X-Provags-ID: V02:K0:GcWElW0YlTKrXfXRI1LkRDJvbcHZSE0eAOS6vPtnTNB
 Yqks5ATkpWHbLXLwNEO/8jeilTzVebTCC72J4682zT4QtuyvZN
 QKkpBp5ep6qEl7JG82c97Ll06Yuks2WxSoScIbgFZXi24ZPLei
 5ZbLbtTWOg7d5S3S6M5HbkqZYouO3GX2U3lpIYx10EI3zwHVV6
 DSzRlPheCRFME1ziSJfiBj947dmp9au/E9QK6gdol0wZWvNETv
 tYsLTm2QoPOCXHSg3h3bxbct0uaedH17vgTp9LGb1tXTuMWeSS
 Nrj7ldQuYdiQ1qo6mhdcvsvi4pxzmpkQBq0INKZYQQ5uQL1Jek
 iKW3VhkKVeWKrlDyKMwGqkS9mavPbvTdZMHjsffBgqqFe498qs
 f4nXLb6ckcfisFmgsr4iY6dr4u00YdeGIvyXp1hZ7RZ6mAtqhs
 t3kz/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes to the firmware loading helpers cause drivers to stall
when firmware is loaded during the module_init() call. The snd-hda-intel
module requests firmware if the patch= parameter is used to load a patch
file. This patch works around the problem by deferring the probe in such
cases, which will cause the module to load successfully and the driver
binding to the device outside the module_init() call.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 sound/pci/hda/hda_intel.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index c8aced1..296616e 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -69,6 +69,7 @@ static int probe_only[SNDRV_CARDS];
 static bool single_cmd;
 static int enable_msi = -1;
 #ifdef CONFIG_SND_HDA_PATCH_LOADER
+static bool deferred[SNDRV_CARDS];
 static char *patch[SNDRV_CARDS];
 #endif
 #ifdef CONFIG_SND_HDA_INPUT_BEEP
@@ -3156,6 +3157,16 @@ static int __devinit azx_probe(struct pci_dev *pci,
 
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
+
+#ifdef CONFIG_SND_HDA_PATCH_LOADER
+	if (patch[dev] && *patch[dev] && !deferred[dev]) {
+		snd_printk(KERN_ERR SFX "deferring probe for patch %s\n",
+			   patch[dev]);
+		deferred[dev] = true;
+		return -EPROBE_DEFER;
+	}
+#endif
+
 	if (!enable[dev]) {
 		dev++;
 		return -ENOENT;
-- 
1.7.11.4

