Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab1CEBCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:02:03 -0500
Received: from kroah.org ([198.145.64.141]:50515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528Ab1CEBBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:01:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:41 2011
Message-Id: <20110305005641.315011111@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [69/73] r8169: disable ASPM
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit ba04c7c93bbcb48ce880cf75b6e9dffcd79d4c7b upstream.

For some time is known that ASPM is causing troubles on r8169, i.e. make
device randomly stop working without any errors in dmesg.

Currently Tomi Leppikangas reports that system with r8169 device hangs
with MCE errors when ASPM is enabled:
https://bugzilla.redhat.com/show_bug.cgi?id=642861#c4

Lets disable ASPM for r8169 devices at all, to avoid problems with
r8169 PCIe devices at least for some users.

Reported-by: Tomi Leppikangas <tomi.leppikangas@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
+#include <linux/pci-aspm.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -3047,6 +3048,11 @@ rtl8169_init_one(struct pci_dev *pdev, c
 	mii->reg_num_mask = 0x1f;
 	mii->supports_gmii = !!(cfg->features & RTL_FEATURE_GMII);
 
+	/* disable ASPM completely as that cause random device stop working
+	 * problems as well as full system hangs for some PCIe devices users */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+				     PCIE_LINK_STATE_CLKPM);
+
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pci_enable_device(pdev);
 	if (rc < 0) {


