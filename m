Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1CJQmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:42:00 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:51385 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1CJQl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:41:59 -0500
Date: Thu, 10 Mar 2011 17:41:56 +0100
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda: Only write ICH6_PCIREG_TCSEL on Intel
 systems.
Message-ID: <20110310164156.GF6376@os.inf.tu-dresden.de>
References: <20110310152212.GD6376@os.inf.tu-dresden.de>
 <s5h4o7bm13w.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <s5h4o7bm13w.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu Mar 10, 2011 at 16:44:35 +0100, Takashi Iwai wrote:
> At Thu, 10 Mar 2011 16:22:12 +0100,
> Adam Lackorzynski wrote:
> > azx_init_pci() always writes PCI config register ICH6_PCIREG_TCSEL
> > although this looks to be only defined on Intel systems and has a
> > different meaning on AMD systems. On AMD systems the PCI interrupt pin
> > control register is modified instead. Since the register has 'ICH' in
> > its name I pulled the call to update_pci_byte() into the switch block to
> > only happen on Intel variants. I'm not sure on the other variants.
> 
> So, you did check only AMD systems, right?
> 
> Then it's safer to exclude this for AMD but apply to others for the
> time being, since we haven't got any relevant bug reports by this.
> Could you re-submit with that change?
> 
> The fact that it has ICH prefix doesn't mean much -- it's just like
> the driver is called snd-hda-intel.  The first hardware, the first
> set.  (At that time, we weren't sure at that time that HD-audio spec
> would be followed widely by most vendors.)

I tried to find other chipset specifications and had no luck, so I don't
know what other vendors have there. I think it's luck that those PCI
config writes cause no harm.


 Subject: [PATCH] ALSA: hda: Prevent writing ICH6_PCIREG_TCSEL on AMD systems.

azx_init_pci() always writes PCI config register ICH6_PCIREG_TCSEL
although this looks to be only defined on Intel systems and has a
different meaning on AMD systems. On AMD systems the PCI interrupt pin
control register is modified instead.

Since the meaning of offset 0x44 in device specific configuration space is
unknown for devices by other vendors, we only exclude AMD systems to
retain the current behaviour.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
---
 sound/pci/hda/hda_intel.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index fcedad9..70a9d32 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1052,9 +1052,12 @@ static void azx_init_pci(struct azx *chip)
 	/* Clear bits 0-2 of PCI register TCSEL (at offset 0x44)
 	 * TCSEL == Traffic Class Select Register, which sets PCI express QOS
 	 * Ensuring these bits are 0 clears playback static on some HD Audio
-	 * codecs
+	 * codecs.
+	 * The PCI register TCSEL is defined in the Intel manuals.
 	 */
-	update_pci_byte(chip->pci, ICH6_PCIREG_TCSEL, 0x07, 0);
+	if (chip->driver_type != AZX_DRIVER_ATI &&
+	    chip->driver_type != AZX_DRIVER_ATIHDMI)
+		update_pci_byte(chip->pci, ICH6_PCIREG_TCSEL, 0x07, 0);
 
 	switch (chip->driver_type) {
 	case AZX_DRIVER_ATI:
-- 
1.7.2.3


Adam
-- 
Adam                 adam@os.inf.tu-dresden.de
  Lackorzynski         http://os.inf.tu-dresden.de/~adam/
