Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab1KVVlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:41:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:55377 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab1KVVla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:41:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,555,1315206000"; 
   d="scan'208";a="88279809"
Subject: [PATCH v3 2/2] serial/8250_pci: init-quirk msi support for kt serial
 controller
To: gregkh@suse.de
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Date: Tue, 22 Nov 2011 13:41:29 -0800
Message-ID: <20111122214129.13786.92888.stgit@localhost6.localdomain6>
In-Reply-To: <20111122213859.13786.7738.stgit@localhost6.localdomain6>
References: <20111122213859.13786.7738.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15-7-g9bfb-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantics of UPF_IIR_ONCE (once per serial irq) are only guaranteed
if the kt irq is not shared (once per serial isr in the shared case ==
potentially unwanted reads of the IIR).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/tty/serial/8250_pci.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 8742ef5..2cbf78f 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1118,6 +1118,18 @@ pci_xr17c154_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
+static int try_enable_msi(struct pci_dev *dev)
+{
+	/* use msi if available, but fallback to legacy otherwise */
+	pci_enable_msi(dev);
+	return 0;
+}
+
+static void disable_msi(struct pci_dev *dev)
+{
+	pci_disable_msi(dev);
+}
+
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_DEVICE_ID_OCTPRO		0x0001
@@ -1233,7 +1245,9 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.device		= PCI_DEVICE_ID_INTEL_PATSBURG_KT,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
+		.init		= try_enable_msi,
 		.setup		= kt_serial_setup,
+		.exit		= disable_msi,
 	},
 	/*
 	 * ITE

