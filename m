Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0GRQDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 12:03:51 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52184 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587Ab0GRQDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 12:03:49 -0400
Message-ID: <4C4325E0.5020407@fusionio.com>
Date: Sun, 18 Jul 2010 10:03:44 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, jgarzik@pobox.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently got one of these laptops, and I've been trying to make it
work a bit better in Linux. One thing that is really annoying is that
it defaults to PIIX instead of AHCI when not booting OSX (it uses
ahci just fine). So I tried to fiddle with this a bit and get it
to use ahci, and after reading the intel specs I managed to switch
it into ahci mode.

The performance is better (512b reads are 3x as fast) and more
importantly it enables the use of ALPM would cuts about 1W of my
power consumption. That's at 30 minutes of battery.

So while the below works, it doesn't work when the laptop is
coming out of suspend. I can't seem to find out why, since it's
a bit hard to debug when you are on the road. What happens is
that it comes back with a bit of a delay, and then the disks are
apparently gone. I've tried adding a resume quirk to re-AHCI the
thing, but it doesn't help.

Looking at the specs, I don't see what I am missing to make this
work for resume. I'm assuming that EFI did initialize some bits
that am missing when coming out of resume, but I don't know which
bits.

Anyone played with this before and has some clues???

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 477345d..3635260 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1020,6 +1020,55 @@ static void quirk_disable_pxb(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb);
 
+/*
+ * This enables AHCI mode on Macbook Pro 6,2 and others based on Intels
+ * 5 series / 3400 series chipset.
+ *
+ * Info found here http://www.intel.com/Assets/PDF/datasheet/322169.pdf
+ */
+static void __devinit quirk_pch_ahci(struct pci_dev *pdev)
+{
+	u16 mode;
+
+	/*
+	 * 0x90 is the MAP register offset
+	 */
+	pci_read_config_word(pdev, 0x90, &mode);
+
+	printk("got mode %x\n", mode);
+
+	/*
+	 * MAP.MV must be 0x00 to allow ahci enable
+	 */
+	if (mode & 0x03)
+		return;
+
+	/*
+	 * Already in AHCI mode?
+	 */
+	if (mode & (1 << 6))
+		return;
+
+	/*
+	 * MAP.SMS bit 6 is AHCI mode, MAP.SC bit 5 is port config
+	 */
+	mode = (1 << 6) | (1 << 5);
+	pci_write_config_word(pdev, 0x90, mode);
+
+	/*
+	 * Re-read device id, it has now changed
+	 */
+	pci_read_config_word(pdev, PCI_DEVICE_ID, &pdev->device);
+
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3b28, quirk_pch_ahci);
+
+static void __devinit quirk_pch_ahci_resume(struct pci_dev *pdev)
+{
+	quirk_pch_ahci(pdev);
+}
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x3b29, quirk_pch_ahci_resume);
+
 static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
 {
 	/* set SBX00/Hudson-2 SATA in IDE mode to AHCI mode */

-- 
Jens Axboe

