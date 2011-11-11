Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab1KKQFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:05:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab1KKQFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:05:34 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, netdev@vger.kernel.org,
        jcliburn@gmail.com, chris.snook@gmail.com
Subject: [PATCH 1/6] net/ethernet/atl1c: Disable ASPM on various chipsets
Date: Fri, 11 Nov 2011 11:05:06 -0500
Message-Id: <1321027511-31229-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1321027511-31229-1-git-send-email-mjg@redhat.com>
References: <1321027511-31229-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Windows driver disables ASPM support for various chipsets supported
by atl1c. This adds the same set of logic to the Linux driver. ASPM is
disabled on l1c, l2c, l2cb and l2cb2 devices except for those in Toshiba
or Lenovo devices. Data taken from
http://www.atheros.cz/atheros-inf-file.php?inf=199&chipset=51&system=6

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: netdev@vger.kernel.org
Cc: jcliburn@gmail.com
Cc: chris.snook@gmail.com
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 02c7ed8..d91dabd 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -19,6 +19,7 @@
  * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 
+#include <linux/pci-aspm.h>
 #include "atl1c.h"
 
 #define ATL1C_DRV_VERSION "1.0.1.0-NAPI"
@@ -2652,6 +2653,20 @@ static int __devinit atl1c_probe(struct pci_dev *pdev,
 
 	int err = 0;
 
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_ATTANSIC_L1C:
+	case PCI_DEVICE_ID_ATTANSIC_L2C:
+	case PCI_DEVICE_ID_ATHEROS_L2C_B:
+	case PCI_DEVICE_ID_ATHEROS_L2C_B2:
+		if (pdev->subsystem_vendor == PCI_VENDOR_ID_TOSHIBA ||
+		    pdev->subsystem_vendor == PCI_VENDOR_ID_LENOVO)
+			break;
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
+				       PCIE_LINK_STATE_L1 |
+				       PCIE_LINK_STATE_CLKPM);
+		break;
+	}
+
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	err = pci_enable_device_mem(pdev);
 	if (err) {
-- 
1.7.7.1

