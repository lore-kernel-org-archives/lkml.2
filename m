Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab2DSVZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:25:10 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38471 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2DSVQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:16:56 -0400
Message-Id: <20120419210822.070984365@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:08:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex He <alex.he@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 40/68] xHCI: Correct the #define XHCI_LEGACY_DISABLE_SMI
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex He <alex.he@amd.com>

commit 95018a53f7653e791bba1f54c8d75d9cb700d1bd upstream.

Re-define XHCI_LEGACY_DISABLE_SMI and used it in right way. All SMI enable
bits will be cleared to zero and flag bits 29:31 are also cleared to zero.
Other bits should be presvered as Table 146.

This patch should be backported to kernels as old as 2.6.31.

Signed-off-by: Alex He <alex.he@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c    |   10 +++++++---
 drivers/usb/host/xhci-ext-caps.h |    5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -825,9 +825,13 @@ static void __devinit quirk_usb_handoff_
 		}
 	}
 
-	/* Disable any BIOS SMIs */
-	writel(XHCI_LEGACY_DISABLE_SMI,
-			base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
+	val = readl(base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
+	/* Mask off (turn off) any enabled SMIs */
+	val &= XHCI_LEGACY_DISABLE_SMI;
+	/* Mask all SMI events bits, RW1C */
+	val |= XHCI_LEGACY_SMI_EVENTS;
+	/* Disable any BIOS SMIs and clear all SMI events*/
+	writel(val, base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
 
 	if (usb_is_intel_switchable_xhci(pdev))
 		usb_enable_xhci_ports(pdev);
--- a/drivers/usb/host/xhci-ext-caps.h
+++ b/drivers/usb/host/xhci-ext-caps.h
@@ -62,8 +62,9 @@
 /* USB Legacy Support Control and Status Register  - section 7.1.2 */
 /* Add this offset, plus the value of xECP in HCCPARAMS to the base address */
 #define XHCI_LEGACY_CONTROL_OFFSET	(0x04)
-/* bits 1:2, 5:12, and 17:19 need to be preserved; bits 21:28 should be zero */
-#define	XHCI_LEGACY_DISABLE_SMI		((0x3 << 1) + (0xff << 5) + (0x7 << 17))
+/* bits 1:3, 5:12, and 17:19 need to be preserved; bits 21:28 should be zero */
+#define	XHCI_LEGACY_DISABLE_SMI		((0x7 << 1) + (0xff << 5) + (0x7 << 17))
+#define XHCI_LEGACY_SMI_EVENTS		(0x7 << 29)
 
 /* USB 2.0 xHCI 0.96 L1C capability - section 7.2.2.1.3.2 */
 #define XHCI_L1C               (1 << 16)


