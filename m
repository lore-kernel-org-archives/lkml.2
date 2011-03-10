Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1CJPz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:55:57 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:41016 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1CJPz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:55:56 -0500
X-Greylist: delayed 2020 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Mar 2011 10:55:55 EST
Date: Thu, 10 Mar 2011 16:22:12 +0100
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: hda: Only write ICH6_PCIREG_TCSEL on Intel systems.
Message-ID: <20110310152212.GD6376@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

azx_init_pci() always writes PCI config register ICH6_PCIREG_TCSEL
although this looks to be only defined on Intel systems and has a
different meaning on AMD systems. On AMD systems the PCI interrupt pin
control register is modified instead. Since the register has 'ICH' in
its name I pulled the call to update_pci_byte() into the switch block to
only happen on Intel variants. I'm not sure on the other variants.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
---
 sound/pci/hda/hda_intel.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index fcedad9..41debbd 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1049,13 +1049,6 @@ static void azx_init_pci(struct azx *chip)
 {
 	unsigned short snoop;
 
-	/* Clear bits 0-2 of PCI register TCSEL (at offset 0x44)
-	 * TCSEL == Traffic Class Select Register, which sets PCI express QOS
-	 * Ensuring these bits are 0 clears playback static on some HD Audio
-	 * codecs
-	 */
-	update_pci_byte(chip->pci, ICH6_PCIREG_TCSEL, 0x07, 0);
-
 	switch (chip->driver_type) {
 	case AZX_DRIVER_ATI:
 		/* For ATI SB450 azalia HD audio, we need to enable snoop */
@@ -1087,6 +1080,14 @@ static void azx_init_pci(struct azx *chip)
 				(snoop & INTEL_SCH_HDA_DEVC_NOSNOOP)
 				? "Failed" : "OK");
 		}
+		/* fall through */
+	case AZX_DRIVER_ICH:
+		/* Clear bits 0-2 of PCI register TCSEL (at offset 0x44)
+		 * TCSEL == Traffic Class Select Register, which sets PCI
+		 * express QOS Ensuring these bits are 0 clears playback
+		 * static on some HD Audio codecs
+		 */
+		update_pci_byte(chip->pci, ICH6_PCIREG_TCSEL, 0x07, 0);
 		break;
 
         }
-- 
1.7.2.3


Adam
-- 
Adam                 adam@os.inf.tu-dresden.de
  Lackorzynski         http://os.inf.tu-dresden.de/~adam/
