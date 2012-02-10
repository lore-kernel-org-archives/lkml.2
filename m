Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab2BJWpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:45:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085Ab2BJWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:45:22 -0500
MIME-Version: 1.0
Message-Id: <20120210223444.568828749@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 49/55] usb: Skip PCI USB quirk handling for Netlogic XLP
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayachandran C <jayachandranc@netlogicmicro.com>

commit e4436a7c17ac2b5e138f93f83a541cba9b311685 upstream.

The Netlogic XLP SoC's on-chip USB controller appears as a PCI
USB device, but does not need the EHCI/OHCI handoff done in
usb/host/pci-quirks.c.

The pci-quirks.c is enabled for all vendors and devices, and is
enabled if USB and PCI are configured.

If we do not skip the qurik handling on XLP, the readb() call in
ehci_bios_handoff() will cause a crash since byte access is not
supported for EHCI registers in XLP.

Signed-off-by: Jayachandran C <jayachandranc@netlogicmicro.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -866,6 +866,12 @@ hc_init:
 
 static void __devinit quirk_usb_early_handoff(struct pci_dev *pdev)
 {
+	/* Skip Netlogic mips SoC's internal PCI USB controller.
+	 * This device does not need/support EHCI/OHCI handoff
+	 */
+	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
+		return;
+
 	if (pdev->class == PCI_CLASS_SERIAL_USB_UHCI)
 		quirk_usb_handoff_uhci(pdev);
 	else if (pdev->class == PCI_CLASS_SERIAL_USB_OHCI)


