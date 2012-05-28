Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2E1Dq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:46:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52033 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585Ab2E1D31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:27 -0400
Message-Id: <20120528031208.955967060@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Eric Anholt <eric.anholt@intel.com>, David Bein <d.bein@f5.com>
Subject: [ 044/117] xhci: Avoid dead ports when CONFIG_USB_XHCI_HCD=n
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/pci-quirks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 32dada8..39b2612 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/init.h>
@@ -742,6 +743,19 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
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


