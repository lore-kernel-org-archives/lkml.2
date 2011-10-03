Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab1JCVz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:55:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50833 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab1JCVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:55:53 -0400
Date: Mon, 3 Oct 2011 16:55:48 -0500
From: Jon Mason <mason@myri.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance"
 settings
Message-ID: <20111003215547.GA3107@myri.com>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317653420-21404-3-git-send-email-mason@myri.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

When configuring the PCIe settings for "performance", we allow parents
to have a larger Max Payload Size than children and rely on children
Max Read Request Size to not be larger than their own MPS to avoid
having the host bridge generate responses they can't cope with.

However, various drivers in Linux call pci_set_readrq() with arbitrary
values, assuming this to be a simple performance tweak. This breaks
under our "performance" configuration.

Fix that by making sure the value programmed by pcie_set_readrq() is
never larger than the configured MPS for that device.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jon Mason <mason@myri.com>
---
 drivers/pci/pci.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4e84fd4..d369316 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3203,8 +3203,6 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 	if (rq < 128 || rq > 4096 || !is_power_of_2(rq))
 		goto out;
 
-	v = (ffs(rq) - 8) << 12;
-
 	cap = pci_pcie_cap(dev);
 	if (!cap)
 		goto out;
@@ -3212,6 +3210,22 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 	err = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
 	if (err)
 		goto out;
+	/*
+	 * If using the "performance" PCIe config, we clamp the
+	 * read rq size to the max packet size to prevent the
+	 * host bridge generating requests larger than we can
+	 * cope with
+	 */
+	if (pcie_bus_config == PCIE_BUS_PERFORMANCE) {
+		int mps = pcie_get_mps(dev);
+
+		if (mps < 0)
+			return mps;
+		if (mps < rq)
+			rq = mps;
+	}
+
+	v = (ffs(rq) - 8) << 12;
 
 	if ((ctl & PCI_EXP_DEVCTL_READRQ) != v) {
 		ctl &= ~PCI_EXP_DEVCTL_READRQ;
-- 
1.7.6.2

