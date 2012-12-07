Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424048Ab2LGBFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:05:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46480 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423534Ab2LGA7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:59:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 11/27] ARM: Kirkwood: Update PCI-E fixup
Date: Thu,  6 Dec 2012 16:58:55 -0800
Message-Id: <20121207005828.810628702@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

commit 1dc831bf53fddcc6443f74a39e72db5bcea4f15d upstream.

- The code relies on rc_pci_fixup being called, which only happens
  when CONFIG_PCI_QUIRKS is enabled, so add that to Kconfig. Omitting
  this causes a booting failure with a non-obvious cause.
- Update rc_pci_fixup to set the class properly, copying the
  more modern style from other places
- Correct the rc_pci_fixup comment

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig              |    1 +
 arch/arm/mach-kirkwood/pcie.c |   11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -585,6 +585,7 @@ config ARCH_KIRKWOOD
 	bool "Marvell Kirkwood"
 	select CPU_FEROCEON
 	select PCI
+	select PCI_QUIRKS
 	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_CLOCKEVENTS
 	select NEED_MACH_IO_H
--- a/arch/arm/mach-kirkwood/pcie.c
+++ b/arch/arm/mach-kirkwood/pcie.c
@@ -225,14 +225,19 @@ static int __init kirkwood_pcie_setup(in
 	return 1;
 }
 
+/*
+ * The root complex has a hardwired class of PCI_CLASS_MEMORY_OTHER, when it
+ * is operating as a root complex this needs to be switched to
+ * PCI_CLASS_BRIDGE_HOST or Linux will errantly try to process the BAR's on
+ * the device. Decoding setup is handled by the orion code.
+ */
 static void __devinit rc_pci_fixup(struct pci_dev *dev)
 {
-	/*
-	 * Prevent enumeration of root complex.
-	 */
 	if (dev->bus->parent == NULL && dev->devfn == 0) {
 		int i;
 
+		dev->class &= 0xff;
+		dev->class |= PCI_CLASS_BRIDGE_HOST << 8;
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			dev->resource[i].start = 0;
 			dev->resource[i].end   = 0;


