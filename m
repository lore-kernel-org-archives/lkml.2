Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1AaOML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:12:11 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:53692 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab1AaOMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:12:09 -0500
Date: Mon, 31 Jan 2011 15:11:56 +0100
From: Stephen Kitt <steve@sk2.org>
To: David Airlie <airlied@linux.ie>
Cc: Kulikov Vasiliy <segooon@gmail.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] agp: ensure GART has an address before enabling it
Message-ID: <20110131141155.GB7171@sk2.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOSs (eg. the AMI BIOS on the Asus P4P800 motherboard) don't
initialise the GART address, and pcibios_assign_resources() can ignore
it because it can be marked as a host bridge (see
https://bugzilla.kernel.org/show_bug.cgi?id=24392#c5 for
details). This was handled correctly up to 2.6.35, but the
pci_enable_device() cleanup in 2.6.36 means that the kernel tries to
enable the GART before assigning it an address; in such cases the GART
overlaps with other device assignments and ends up being disabled.

This patch fixes #24392.

Note that I imagine efficeon-agp.c probably has the same problem, but
I can't test that and I'd like to make sure this patch is suitable for
-stable (since 2.6.36 and 2.6.37 are affected).

Cc: <stable@kernel.org>
Signed-off-by: Stephen Kitt <steve@sk2.org>
---
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 857df10..b0a0dcc 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -774,20 +774,14 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 	dev_info(&pdev->dev, "Intel %s Chipset\n", intel_agp_chipsets[i].name);
 
 	/*
-	* If the device has not been properly setup, the following will catch
-	* the problem and should stop the system from crashing.
-	* 20030610 - hamish@zot.org
-	*/
-	if (pci_enable_device(pdev)) {
-		dev_err(&pdev->dev, "can't enable PCI device\n");
-		agp_put_bridge(bridge);
-		return -ENODEV;
-	}
-
-	/*
 	* The following fixes the case where the BIOS has "forgotten" to
 	* provide an address range for the GART.
 	* 20030610 - hamish@zot.org
+	* This happens before pci_enable_device() intentionally;
+	* calling pci_enable_device() before assigning the resource
+	* will result in the GART being disabled on machines with such
+	* BIOSs (the GART ends up with a BAR starting at 0, which
+	* conflicts a lot of other devices).
 	*/
 	r = &pdev->resource[0];
 	if (!r->start && r->end) {
@@ -798,6 +792,17 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 		}
 	}
 
+	/*
+	* If the device has not been properly setup, the following will catch
+	* the problem and should stop the system from crashing.
+	* 20030610 - hamish@zot.org
+	*/
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "can't enable PCI device\n");
+		agp_put_bridge(bridge);
+		return -ENODEV;
+	}
+
 	/* Fill in the mode register */
 	if (cap_ptr) {
 		pci_read_config_dword(pdev,
