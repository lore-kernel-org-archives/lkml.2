Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1I3AQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 20:16:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42988 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1I3AQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 20:16:41 -0400
Date: Thu, 29 Sep 2011 19:16:34 -0500
From: Jon Mason <mason@myri.com>
To: Avi Kivity <avi@redhat.com>
Cc: Sven Schnelle <svens@stackframe.org>, Simon Kirby <sim@hostway.ca>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Workaround for Intel MPS errata
Message-ID: <20110930001633.GA11436@myri.com>
References: <4E82017C.3010304@redhat.com>
 <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
 <4E8215B6.1020108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8215B6.1020108@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Avi,
Can you try this patch?  It should resolve the issue you are seeing.

Thanks,
Jon

    PCI: Workaround for Intel MPS errata
    
    Intel 5000 and 5100 series memory controllers have a known issue if read
    completion coalescing is enabled (the default setting) and the PCI-E
    Maximum Payload Size is set to 256B.  To work around this issue, disable
    read completion coalescing if the MPS is 256B.
    
    http://www.intel.com/content/dam/doc/specification-update/5000-chipset-memory-controller-hub-specification-update.pdf
    http://www.intel.com/content/dam/doc/specification-update/5100-memory-controller-hub-chipset-specification-update.pdf
    
    Reported-by: Avi Kivity <avi@redhat.com>
    Signed-off-by: Jon Mason <mason@myri.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a919db2..13c733a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1361,6 +1361,80 @@ static int pcie_find_smpss(struct pci_dev *dev, void *data)
 	return 0;
 }
 
+static void pcie_errata_check(int mps)
+{
+	struct pci_dev *dev = NULL;
+	static bool done = false;
+
+	if (done)
+		return;
+
+	/* Intel 5000 and 5100 Memory controllers have an errata with read
+	 * completion coalescing (which is enabled by default) and MPS of 256B.
+	 */
+	/* 5000X Chipset Memory Controller Hub */
+	dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x25C0, NULL);
+	if (dev)
+		goto fixup;
+
+	/* 5000Z Chipset Memory Controller Hub */
+	dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x25D0, NULL);
+	if (dev)
+		goto fixup;
+
+	/* 5000V Chipset Memory Controller Hub */
+	dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x25D4, NULL);
+	if (dev)
+		goto fixup;
+
+	/* 5000P Chipset Memory Controller Hub */
+	dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x25D8, NULL);
+	if (dev)
+		goto fixup;
+
+	/* 5100 Chipset Memory Controller Hub */
+	dev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x65C0, NULL);
+	if (dev)
+		goto fixup;
+
+	/* No Intel 5000 or 5100 Memory controller in the system, no need to
+	 * check again
+	 */
+	if (!dev) {
+		done = true;
+		return;
+	}
+
+fixup:
+	/* Disable read completion coalescing to allow an MPS of 256 */
+	if (mps == 256) {
+		int err;
+		u16 rcc;
+
+		/* Intel errata specifies bits to change but does not say what
+		 * they are.  Keeping them magical until such time as the
+		 * registers and values can be explained.
+		 */
+		err = pci_read_config_word(dev, 0x48, &rcc);
+		if (err) {
+			dev_err(&dev->dev, "Error attempting to read the read "
+				"completion coalescing register.\n");
+			return;
+		}
+
+		rcc &= ~(1 << 10);
+
+		err = pci_write_config_word(dev, 0x48, rcc);
+		if (err) {
+			dev_err(&dev->dev, "Error attempting to read the read "
+				"completion coalescing register.\n");
+			return;
+		}
+
+		done = true;
+	}
+}
+
 static void pcie_write_mps(struct pci_dev *dev, int mps)
 {
 	int rc;
@@ -1384,6 +1458,8 @@ static void pcie_write_mps(struct pci_dev *dev, int mps)
 			mps = min(mps, pcie_get_mps(dev->bus->self));
 	}
 
+	pcie_errata_check(mps);
+
 	rc = pcie_set_mps(dev, mps);
 	if (rc)
 		dev_err(&dev->dev, "Failed attempting to set the MPS\n");
@@ -1445,7 +1521,7 @@ static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
 	return 0;
 }
 
-/* pcie_bus_configure_mps requires that pci_walk_bus work in a top-down,
+/* pcie_bus_configure_settings requires that pci_walk_bus work in a top-down,
  * parents then children fashion.  If this changes, then this code will not
  * work as designed.
  */
