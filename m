Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2C0OSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:18:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab2C0OSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:18:00 -0400
From: Matthew Garrett <mjg@redhat.com>
To: bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ASPM: Fix pcie devices with non-pcie children
Date: Tue, 27 Mar 2012 10:17:41 -0400
Message-Id: <1332857861-11562-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4949be16822e92a18ea0cc1616319926628092ee changed the behaviour of
pcie_aspm_sanity_check() to always return 0 if aspm is disabled, in order
to avoid cases where we changed ASPM state on pre-PCIe 1.1 devices. This
skipped the secondary function of pcie_aspm_sanity_check which was to avoid
us enabling ASPM on devices that had non-PCIe children, causing us to hit
a BUG_ON later on. Move the aspm_disabled check so we continue to honour
that scenario.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/pci/pcie/aspm.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 86111d9..41e367b 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -521,9 +521,6 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 	int pos;
 	u32 reg32;
 
-	if (aspm_disabled)
-		return 0;
-
 	/*
 	 * Some functions in a slot might not all be PCIe functions,
 	 * very strange. Disable ASPM for the whole slot
@@ -532,6 +529,16 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 		pos = pci_pcie_cap(child);
 		if (!pos)
 			return -EINVAL;
+
+		/*
+		 * If ASPM is disabled then we're not going to change
+		 * the BIOS state. It's safe to continue even if it's a
+		 * pre-1.1 device
+		 */
+
+		if (aspm_disabled)
+			continue;
+
 		/*
 		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
 		 * RBER bit to determine if a function is 1.1 version device
-- 
1.7.7.6

