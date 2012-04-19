Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab2DSVGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:06:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab2DSVGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:06:18 -0400
Message-Id: <20120419210305.343056810@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Sudhakar Mamillapalli <sudhakar@fb.com>,
        Nhan H Mai <nhan.h.mai@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [ 26/75] Revert "serial/8250_pci: init-quirk msi support for kt serial controller"
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 3579812373aba92b2f3b632bdf99329bc3c05d62 upstream.

This reverts commit e86ff4a63c9fdd875ba8492577cd1ad2252f525c.

This tried to enforce the semantics of one interrupt per iir read of the
THRE (transmit-hold empty) status, but events from other sources
(particularly modem status) defeat this guarantee.

This change also broke 8250_pci suspend/resume support as
pciserial_resume_ports() re-runs .init() quirks, but does not run
.exit() quirks in pciserial_suspend_ports() leading to reports like:

  sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:16.3/msi_irqs'

...and a subsequent crash.  The mismatch of init/exit at suspend/resume
seems like a bug in its own right.

Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>
Reported-by: Nhan H Mai <nhan.h.mai@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_pci.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1118,18 +1118,6 @@ pci_xr17c154_setup(struct serial_private
 	return pci_default_setup(priv, board, port, idx);
 }
 
-static int try_enable_msi(struct pci_dev *dev)
-{
-	/* use msi if available, but fallback to legacy otherwise */
-	pci_enable_msi(dev);
-	return 0;
-}
-
-static void disable_msi(struct pci_dev *dev)
-{
-	pci_disable_msi(dev);
-}
-
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_DEVICE_ID_OCTPRO		0x0001
@@ -1249,9 +1237,7 @@ static struct pci_serial_quirk pci_seria
 		.device		= PCI_DEVICE_ID_INTEL_PATSBURG_KT,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
-		.init		= try_enable_msi,
 		.setup		= kt_serial_setup,
-		.exit		= disable_msi,
 	},
 	/*
 	 * ITE


