Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab2E0BSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:18:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2E0BSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:18:33 -0400
Message-Id: <20120527002519.537027764@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:04 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Eric Anholt <eric.anholt@intel.com>, David Bein <d.bein@f5.com>
Subject: [ 58/91] xhci: Avoid dead ports when CONFIG_USB_XHCI_HCD=n
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 51c9e6c7732b67769c0a514d31f505e49fa82dd4 upstream.

If the user chooses to say "no" to CONFIG_USB_XHCI_HCD on a system
with an Intel Panther Point chipset, the PCI quirks code or the EHCI
driver will switch the ports over to the xHCI host, but the xHCI driver
will never load.  The ports will be powered off and seem "dead" to the
user.

Fix this by only switching the ports over if CONFIG_USB_XHCI_HCD is
either compiled in, or compiled as a module.

This patch should be backported to stable kernels as old as 3.0,
that contain commit 69e848c2090aebba5698a1620604c7dccb448684
"Intel xhci: Support EHCI/xHCI port switching."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Eric Anholt <eric.anholt@intel.com>
Reported-by: David Bein <d.bein@f5.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/init.h>
@@ -758,6 +759,19 @@ void usb_enable_xhci_ports(struct pci_de
 {
 	u32		ports_available;
 
+	/* Don't switchover the ports if the user hasn't compiled the xHCI
+	 * driver.  Otherwise they will see "dead" USB ports that don't power
+	 * the devices.
+	 */
+	if (!IS_ENABLED(CONFIG_USB_XHCI_HCD)) {
+		dev_warn(&xhci_pdev->dev,
+				"CONFIG_USB_XHCI_HCD is turned off, "
+				"defaulting to EHCI.\n");
+		dev_warn(&xhci_pdev->dev,
+				"USB 3.0 devices will work at USB 2.0 speeds.\n");
+		return;
+	}
+
 	ports_available = 0xffffffff;
 	/* Write USB3_PSSEN, the USB 3.0 Port SuperSpeed Enable
 	 * Register, to turn on SuperSpeed terminations for all


