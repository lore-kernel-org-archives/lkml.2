Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab1BPAxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:53:53 -0500
Received: from kroah.org ([198.145.64.141]:46315 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933512Ab1BPAwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:52:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:16 2011
Message-Id: <20110216002116.211063521@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Kitt <steve@sk2.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kulikov Vasiliy <segooon@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [patch 172/176] agp: ensure GART has an address before enabling it
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Kitt <steve@sk2.org>

commit a70b95c017e8b518e1e069853355e4e497453dbb upstream.

Some BIOSs (eg.  the AMI BIOS on the Asus P4P800 motherboard) don't
initialise the GART address, and pcibios_assign_resources() can ignore it
because it can be marked as a host bridge (see
https://bugzilla.kernel.org/show_bug.cgi?id=24392#c5 for details).  This
was handled correctly up to 2.6.35, but the pci_enable_device() cleanup in
2.6.36 96576a9e1a0cdb8 ("agp: intel-agp: do not use PCI resources before
pci_enable_device()") means that the kernel tries to enable the GART
before assigning it an address; in such cases the GART overlaps with other
device assignments and ends up being disabled.

This patch fixes https://bugzilla.kernel.org/show_bug.cgi?id=24392

Note that I imagine efficeon-agp.c probably has the same problem, but
I can't test that and I'd like to make sure this patch is suitable for
-stable (since 2.6.36 and 2.6.37 are affected).

Signed-off-by: Stephen Kitt <steve@sk2.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kulikov Vasiliy <segooon@gmail.com>
Cc: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -927,20 +927,14 @@ static int __devinit agp_intel_probe(str
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
@@ -951,6 +945,17 @@ static int __devinit agp_intel_probe(str
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


