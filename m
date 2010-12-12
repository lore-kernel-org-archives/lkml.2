Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0LMA1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:27:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44746 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0LLXpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:31 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [34/223] ALSA: hda - Add some workarounds for Creative IBG
Message-Id: <20101212234530.A6679B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 14d34f166c57e77e3d7f9bc8b43d349186d922c1 upstream.

Creative HD-audio controller chips require some workarounds:
 - Additional delay before RIRB response
 - Set the initial RIRB counter to 0xc0

The latter seems to be done in general in Windows driver, so we may
use this value later for all types if it's confirmed to work better.

Reported-by: Wai Yew CHAY <wychay@ctl.creative.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/hda_intel.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux/sound/pci/hda/hda_intel.c
===================================================================
--- linux.orig/sound/pci/hda/hda_intel.c
+++ linux/sound/pci/hda/hda_intel.c
@@ -457,6 +457,7 @@ enum {
 	AZX_DRIVER_ULI,
 	AZX_DRIVER_NVIDIA,
 	AZX_DRIVER_TERA,
+	AZX_DRIVER_CTX,
 	AZX_DRIVER_GENERIC,
 	AZX_NUM_DRIVERS, /* keep this as last entry */
 };
@@ -472,6 +473,7 @@ static char *driver_short_names[] __devi
 	[AZX_DRIVER_ULI] = "HDA ULI M5461",
 	[AZX_DRIVER_NVIDIA] = "HDA NVidia",
 	[AZX_DRIVER_TERA] = "HDA Teradici", 
+	[AZX_DRIVER_CTX] = "HDA Creative",
 	[AZX_DRIVER_GENERIC] = "HD-Audio Generic",
 };
 
@@ -562,7 +564,10 @@ static void azx_init_cmd_io(struct azx *
 	/* reset the rirb hw write pointer */
 	azx_writew(chip, RIRBWP, ICH6_RIRBWP_RST);
 	/* set N=1, get RIRB response interrupt for new entry */
-	azx_writew(chip, RINTCNT, 1);
+	if (chip->driver_type == AZX_DRIVER_CTX)
+		azx_writew(chip, RINTCNT, 0xc0);
+	else
+		azx_writew(chip, RINTCNT, 1);
 	/* enable rirb dma and response irq */
 	azx_writeb(chip, RIRBCTL, ICH6_RBCTL_DMA_EN | ICH6_RBCTL_IRQ_EN);
 	spin_unlock_irq(&chip->reg_lock);
@@ -1135,8 +1140,11 @@ static irqreturn_t azx_interrupt(int irq
 	/* clear rirb int */
 	status = azx_readb(chip, RIRBSTS);
 	if (status & RIRB_INT_MASK) {
-		if (status & RIRB_INT_RESPONSE)
+		if (status & RIRB_INT_RESPONSE) {
+			if (chip->driver_type == AZX_DRIVER_CTX)
+				udelay(80);
 			azx_update_rirb(chip);
+		}
 		azx_writeb(chip, RIRBSTS, RIRB_INT_MASK);
 	}
 
@@ -2790,10 +2798,10 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids)
 	{ PCI_DEVICE(PCI_VENDOR_ID_CREATIVE, PCI_ANY_ID),
 	  .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
 	  .class_mask = 0xffffff,
-	  .driver_data = AZX_DRIVER_GENERIC },
+	  .driver_data = AZX_DRIVER_CTX },
 #else
 	/* this entry seems still valid -- i.e. without emu20kx chip */
-	{ PCI_DEVICE(0x1102, 0x0009), .driver_data = AZX_DRIVER_GENERIC },
+	{ PCI_DEVICE(0x1102, 0x0009), .driver_data = AZX_DRIVER_CTX },
 #endif
 	/* AMD/ATI Generic, PCI class code and Vendor ID for HD Audio */
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_ANY_ID),
