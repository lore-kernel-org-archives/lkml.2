Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2DFSeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:34:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:38762 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2DFSeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:34:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="138592926"
Subject: [PATCH 1/6] Revert "serial/8250_pci: init-quirk msi support for kt
 serial controller"
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-serial@vger.kernel.org,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@linux.intel.com>
Date: Fri, 06 Apr 2012 11:49:37 -0700
Message-ID: <20120406184934.22088.63056.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

[stable: 3.3.x]
Cc: <stable@vger.kernel.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>
Reported-by: Nhan H Mai <nhan.h.mai@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/tty/serial/8250/8250_pci.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index da2b0b0..1d4ccf8 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1118,18 +1118,6 @@ pci_xr17c154_setup(struct serial_private *priv,
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
@@ -1249,9 +1237,7 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.device		= PCI_DEVICE_ID_INTEL_PATSBURG_KT,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
-		.init		= try_enable_msi,
 		.setup		= kt_serial_setup,
-		.exit		= disable_msi,
 	},
 	/*
 	 * ITE

