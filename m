Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2GWLq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:46:27 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:48722 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2GWLqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:46:25 -0400
Message-ID: <500D398E.1060000@compulab.co.il>
Date: Mon, 23 Jul 2012 14:46:22 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] xhci: provide usb_disable_xhci_ports function for Intel
 chipsets.
References: <5004454E.9030903@compulab.co.il> <20120717045416.GJ7599@xanatos> <50065E5A.2040103@compulab.co.il> <20120718165916.GA30828@xanatos>
In-Reply-To: <20120718165916.GA30828@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices with Intel Panther Point chipset may require switchover
usb ports from XHCI back to EHCI controller before shutdown.
Overwise various BIOS bugs related to power management may be
triggered.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/usb/host/pci-quirks.c |   14 ++++++++++++++
 drivers/usb/host/pci-quirks.h |    1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index df0828c..b19a84a 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -800,6 +800,20 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 }
 EXPORT_SYMBOL_GPL(usb_enable_xhci_ports);

+void usb_disable_xhci_ports(struct pci_dev *xhci_pdev)
+{
+	u32		ports_available;
+
+	ports_available = 0x0;
+
+	pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN,
+			cpu_to_le32(ports_available));
+
+	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR,
+			cpu_to_le32(ports_available));
+}
+EXPORT_SYMBOL_GPL(usb_disable_xhci_ports);
+
 /**
  * PCI Quirks for xHCI.
  *
diff --git a/drivers/usb/host/pci-quirks.h b/drivers/usb/host/pci-quirks.h
index b1002a8..ef004a5 100644
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
-- 
1.7.9.5


