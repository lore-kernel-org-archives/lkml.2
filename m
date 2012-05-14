Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2ENCoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:44:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:53148 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab2ENCow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:44:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165771124"
Date: Mon, 14 May 2012 10:48:16 +0800
From: Xudong Hao <xudong.hao@linux.intel.com>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, alex.williamson@redhat.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: [PATCH 1/1] Enable LTR/OBFF before device is used by driver
Message-ID: <20120514024816.GA15371@hp-xd.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable LTR(Latency tolerance reporting) and OBFF(optimized buffer flush/fill) in
 pci_enable_device(), so that they are enabled before the device is used by driver.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>

---
 drivers/pci/pci.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 111569c..2369883 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1134,6 +1134,31 @@ int pci_load_and_free_saved_state(struct pci_dev *dev,
 }
 EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);

+static void pci_enable_dev_caps(struct pci_dev *dev)
+{
+       /* set default value */
+       unsigned long type = PCI_EXP_OBFF_SIGNAL_ALWAYS;
+
+       /* LTR(Latency tolerance reporting) allows devices to send
+        * messages to the root complex indicating their latency
+        * tolerance for snooped & unsnooped memory transactions.
+        */
+       pci_enable_ltr(dev);
+
+       /* OBFF (optimized buffer flush/fill), where supported,
+        * can help improve energy efficiency by giving devices
+        * information about when interrupts and other activity
+        * will have a reduced power impact.
+        */
+       pci_enable_obff(dev, type);
+}
+
+static void pci_disable_dev_caps(struct pci_dev *dev)
+{
+       pci_disable_obff(dev);
+       pci_disable_ltr(dev);
+}
+
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
        int err;
@@ -1146,6 +1171,9 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
                return err;
        pci_fixup_device(pci_fixup_enable, dev);

+       /* Enable some device capibility before it's used by driver. */
+       pci_enable_dev_caps(dev);
+
        return 0;
 }

@@ -1361,6 +1389,7 @@ static void do_pci_disable_device(struct pci_dev *dev)
        }

        pcibios_disable_device(dev);
+       pci_disable_dev_caps(dev);
 }

 /**
--
1.6.0.rc1

