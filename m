Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2HTESP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:18:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab2HTD44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:56:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Denis Turischev <denis@compulab.co.il>
Subject: [ 09/16] xhci: Switch PPT ports to EHCI on shutdown.
Date: Sun, 19 Aug 2012 20:56:08 -0700
Message-Id: <20120820035458.982804912@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035457.653002510@linuxfoundation.org>
References: <20120820035457.653002510@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit e95829f474f0db3a4d940cae1423783edd966027 upstream.

The Intel desktop boards DH77EB and DH77DF have a hardware issue that
can be worked around by BIOS.  If the USB ports are switched to xHCI on
shutdown, the xHCI host will send a spurious interrupt, which will wake
the system.  Some BIOS will work around this, but not all.

The bug can be avoided if the USB ports are switched back to EHCI on
shutdown.  The Intel Windows driver switches the ports back to EHCI, so
change the Linux xHCI driver to do the same.

Unfortunately, we can't tell the two effected boards apart from other
working motherboards, because the vendors will change the DMI strings
for the DH77EB and DH77DF boards to their own custom names.  One example
is Compulab's mini-desktop, the Intense-PC.  Instead, key off the
Panther Point xHCI host PCI vendor and device ID, and switch the ports
over for all PPT xHCI hosts.

The only impact this will have on non-effected boards is to add a couple
hundred milliseconds delay on boot when the BIOS has to switch the ports
over from EHCI to xHCI.

This patch should be backported to kernels as old as 3.0, that contain
the commit 69e848c2090aebba5698a1620604c7dccb448684 "Intel xhci: Support
EHCI/xHCI port switching."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Denis Turischev <denis@compulab.co.il>
Tested-by: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |    7 +++++++
 drivers/usb/host/pci-quirks.h |    1 +
 drivers/usb/host/xhci-pci.c   |    9 +++++++++
 drivers/usb/host/xhci.c       |    3 +++
 drivers/usb/host/xhci.h       |    1 +
 5 files changed, 21 insertions(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -798,6 +798,13 @@ void usb_enable_xhci_ports(struct pci_de
 }
 EXPORT_SYMBOL_GPL(usb_enable_xhci_ports);
 
+void usb_disable_xhci_ports(struct pci_dev *xhci_pdev)
+{
+	pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN, 0x0);
+	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR, 0x0);
+}
+EXPORT_SYMBOL_GPL(usb_disable_xhci_ports);
+
 /**
  * PCI Quirks for xHCI.
  *
--- a/drivers/usb/host/pci-quirks.h
+++ b/drivers/usb/host/pci-quirks.h
@@ -10,6 +10,7 @@ void usb_amd_quirk_pll_disable(void);
 void usb_amd_quirk_pll_enable(void);
 bool usb_is_intel_switchable_xhci(struct pci_dev *pdev);
 void usb_enable_xhci_ports(struct pci_dev *xhci_pdev);
+void usb_disable_xhci_ports(struct pci_dev *xhci_pdev);
 #else
 static inline void usb_amd_quirk_pll_disable(void) {}
 static inline void usb_amd_quirk_pll_enable(void) {}
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -140,6 +140,15 @@ static int xhci_pci_setup(struct usb_hcd
 		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
 		xhci->limit_active_eps = 64;
+		/*
+		 * PPT desktop boards DH77EB and DH77DF will power back on after
+		 * a few seconds of being shutdown.  The fix for this is to
+		 * switch the ports from xHCI to EHCI on shutdown.  We can't use
+		 * DMI information to find those particular boards (since each
+		 * vendor will change the board name), so we have to key off all
+		 * PPT chipsets.
+		 */
+		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -594,6 +594,9 @@ void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 
+	if (xhci->quirks && XHCI_SPURIOUS_REBOOT)
+		usb_disable_xhci_ports(to_pci_dev(hcd->self.controller));
+
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
 	spin_unlock_irq(&xhci->lock);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1316,6 +1316,7 @@ struct xhci_hcd {
 #define XHCI_RESET_ON_RESUME	(1 << 7)
 #define XHCI_AMD_0x96_HOST	(1 << 9)
 #define XHCI_TRUST_TX_LENGTH	(1 << 10)
+#define XHCI_SPURIOUS_REBOOT	(1 << 13)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */


