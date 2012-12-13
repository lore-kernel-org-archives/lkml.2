Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2LMOJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:09:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44676 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785Ab2LMOJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 145/241] ARM: Kirkwood: Update PCI-E fixup
Date: Thu, 13 Dec 2012 11:58:30 -0200
Message-Id: <1355407206-17100-146-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/Kconfig              |    1 +
 arch/arm/mach-kirkwood/pcie.c |   11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 72fd2bd..aca782f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -548,6 +548,7 @@ config ARCH_KIRKWOOD
 	bool "Marvell Kirkwood"
 	select CPU_FEROCEON
 	select PCI
+	select PCI_QUIRKS
 	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_CLOCKEVENTS
 	select NEED_MACH_IO_H
diff --git a/arch/arm/mach-kirkwood/pcie.c b/arch/arm/mach-kirkwood/pcie.c
index 6e8b2ef..f3f55b2 100644
--- a/arch/arm/mach-kirkwood/pcie.c
+++ b/arch/arm/mach-kirkwood/pcie.c
@@ -225,14 +225,19 @@ static int __init kirkwood_pcie_setup(int nr, struct pci_sys_data *sys)
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
-- 
1.7.9.5

