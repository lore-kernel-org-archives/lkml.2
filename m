Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162957Ab2GLXGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:06:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63438 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162891Ab2GLXGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:06:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Eric Anholt <eric.anholt@intel.com>, David Bein <d.bein@f5.com>
Subject: [ 52/68] xhci: Avoid dead ports when CONFIG_USB_XHCI_HCD=n
Date: Thu, 12 Jul 2012 16:02:26 -0700
Message-Id: <20120712175040.030750290@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

Commit 51c9e6c7732b67769c0a514d31f505e49fa82dd4 upstream, but modified
to get this to apply on 3.0.

If the user chooses to say "no" to CONFIG_USB_XHCI_HCD on a system
with an Intel Panther Point chipset, the PCI quirks code or the EHCI
driver will switch the ports over to the xHCI host, but the xHCI driver
will never load.  The ports will be powered off and seem "dead" to the
user.

Fix this by only switching the ports over if CONFIG_USB_XHCI_HCD is
either compiled in, or compiled as a module.

This patch should be backported to the 3.0 stable kernel, since it
contains the commit 69e848c2090aebba5698a1620604c7dccb448684 "Intel
xhci: Support EHCI/xHCI port switching."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Eric Anholt <eric.anholt@intel.com>
Reported-by: David Bein <d.bein@f5.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -755,6 +755,7 @@ EXPORT_SYMBOL_GPL(usb_is_intel_switchabl
  */
 void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 {
+#if defined(CONFIG_USB_XHCI_HCD) || defined(CONFIG_USB_XHCI_HCD_MODULE)
 	u32		ports_available;
 
 	ports_available = 0xffffffff;
@@ -782,6 +783,18 @@ void usb_enable_xhci_ports(struct pci_de
 			&ports_available);
 	dev_dbg(&xhci_pdev->dev, "USB 2.0 ports that are now switched over "
 			"to xHCI: 0x%x\n", ports_available);
+#else
+	/* Don't switchover the ports if the user hasn't compiled the xHCI
+	 * driver.  Otherwise they will see "dead" USB ports that don't power
+	 * the devices.
+	 */
+	dev_warn(&xhci_pdev->dev,
+			"CONFIG_USB_XHCI_HCD is turned off, "
+			"defaulting to EHCI.\n");
+	dev_warn(&xhci_pdev->dev,
+			"USB 3.0 devices will work at USB 2.0 speeds.\n");
+#endif	/* CONFIG_USB_XHCI_HCD || CONFIG_USB_XHCI_HCD_MODULE */
+
 }
 EXPORT_SYMBOL_GPL(usb_enable_xhci_ports);
 


