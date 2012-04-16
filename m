Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab2DPVTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:19:23 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:35576 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754955Ab2DPVTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:19:20 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] snd-ice1712: add chip_exit callback
Date: Mon, 16 Apr 2012 23:18:35 +0200
Message-Id: <1334611118-10301-2-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add chip_exit callback to allow card subdrivers to do cleanup work on module
removal.

Needed by Philips PSC724 subdriver to cancel delayed work.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 sound/pci/ice1712/ice1712.c |    8 +++++++-
 sound/pci/ice1712/ice1712.h |    3 +++
 sound/pci/ice1712/ice1724.c |    8 +++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 132a86e..e153bdb 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2686,6 +2686,7 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 	for (tbl = card_tables; *tbl; tbl++) {
 		for (c = *tbl; c->subvendor; c++) {
 			if (c->subvendor == ice->eeprom.subvendor) {
+				ice->card_info = c;
 				strcpy(card->shortname, c->name);
 				if (c->driver) /* specific driver? */
 					strcpy(card->driver, c->driver);
@@ -2799,7 +2800,12 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 
 static void __devexit snd_ice1712_remove(struct pci_dev *pci)
 {
-	snd_card_free(pci_get_drvdata(pci));
+	struct snd_card *card = pci_get_drvdata(pci);
+	struct snd_ice1712 *ice = card->private_data;
+
+	if (ice->card_info && ice->card_info->chip_exit)
+		ice->card_info->chip_exit(ice);
+	snd_card_free(card);
 	pci_set_drvdata(pci, NULL);
 }
 
diff --git a/sound/pci/ice1712/ice1712.h b/sound/pci/ice1712/ice1712.h
index 0da778a..79f8aeb 100644
--- a/sound/pci/ice1712/ice1712.h
+++ b/sound/pci/ice1712/ice1712.h
@@ -288,6 +288,7 @@ struct snd_ice1712_spdif {
 	} ops;
 };
 
+struct snd_ice1712_card_info;
 
 struct snd_ice1712 {
 	unsigned long conp_dma_size;
@@ -324,6 +325,7 @@ struct snd_ice1712 {
 	struct snd_info_entry *proc_entry;
 
 	struct snd_ice1712_eeprom eeprom;
+	struct snd_ice1712_card_info *card_info;
 
 	unsigned int pro_volumes[20];
 	unsigned int omni:1;		/* Delta Omni I/O */
@@ -517,6 +519,7 @@ struct snd_ice1712_card_info {
 	char *model;
 	char *driver;
 	int (*chip_init)(struct snd_ice1712 *);
+	void (*chip_exit)(struct snd_ice1712 *);
 	int (*build_controls)(struct snd_ice1712 *);
 	unsigned int no_mpu401:1;
 	unsigned int mpu401_1_info_flags;
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 9236297..ea686c4 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2325,6 +2325,7 @@ static int __devinit snd_vt1724_read_eeprom(struct snd_ice1712 *ice,
 				ice->eeprom.subvendor = c->subvendor;
 			} else if (c->subvendor != ice->eeprom.subvendor)
 				continue;
+			ice->card_info = c;
 			if (!c->eeprom_size || !c->eeprom_data)
 				goto found;
 			/* if the EEPROM is given by the driver, use it */
@@ -2765,7 +2766,12 @@ __found:
 
 static void __devexit snd_vt1724_remove(struct pci_dev *pci)
 {
-	snd_card_free(pci_get_drvdata(pci));
+	struct snd_card *card = pci_get_drvdata(pci);
+	struct snd_ice1712 *ice = card->private_data;
+
+	if (ice->card_info && ice->card_info->chip_exit)
+		ice->card_info->chip_exit(ice);
+	snd_card_free(card);
 	pci_set_drvdata(pci, NULL);
 }
 
-- 
Ondrej Zary

