Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab2FHIBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:01:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:62602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab2FHIBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:01:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="149938471"
From: Xudong Hao <xudong.hao@intel.com>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, alex.williamson@redhat.com,
        ddutile@redhat.com, myron.stowe@redhat.com, xiantao.zhang@intel.com,
        xudong.hao@intel.com
Subject: [PATCH 2/4] Enable LTR before device is used by driver
Date: Fri,  8 Jun 2012 16:01:30 +0800
Message-Id: <1339142492-13625-3-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1339142492-13625-1-git-send-email-xudong.hao@intel.com>
References: <1339142492-13625-1-git-send-email-xudong.hao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable LTR(Latency tolerance reporting) in pci_enable_device(),
make sure this feature is enabled before the device is used by driver.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
---
 drivers/pci/pci.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a70093b..5e5e3ad 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1136,6 +1136,21 @@ int pci_load_and_free_saved_state(struct pci_dev *dev,
 }
 EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
 
+static void pci_enable_dev_caps(struct pci_dev *dev)
+{
+	/* 
+	 * LTR(Latency tolerance reporting) allows devices to send
+	 * messages to the root complex indicating their latency
+	 * tolerance for snooped & unsnooped memory transactions.
+	 */
+	pci_enable_ltr(dev);
+}
+
+static void pci_disable_dev_caps(struct pci_dev *dev)
+{
+	pci_disable_ltr(dev);
+}
+
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;
@@ -1148,6 +1163,9 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 		return err;
 	pci_fixup_device(pci_fixup_enable, dev);
 
+	/* Enable some device capibility before it's used by driver. */
+	pci_enable_dev_caps(dev);
+
 	return 0;
 }
 
@@ -1363,6 +1381,7 @@ static void do_pci_disable_device(struct pci_dev *dev)
 	}
 
 	pcibios_disable_device(dev);
+	pci_disable_dev_caps(dev);
 }
 
 /**
-- 
1.5.5

