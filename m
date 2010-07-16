Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab0GPTHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:07:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:57479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab0GPTHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:07:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,215,1278313200"; 
   d="scan'208";a="536202867"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ben Greear <greearb@candelatech.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/pci/mrst: add extra check in fixed bar detection
Date: Fri, 16 Jul 2010 11:58:26 -0700
Message-Id: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed bar capability structure is searched in PCI extended configuration
space. We need to make sure there is a valid capability id to begin with
otherwise, the search code may stuck in a infinite loop which results in
boot hang.
This patch adds additional check for cap ID 0, which is also invalid.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/pci/mrst.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index c9649d0..8636567 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -66,8 +66,9 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
 					  devfn, pos, 4, &pcie_cap))
 			return 0;
 
-		if (pcie_cap == 0xffffffff)
-			return 0;
+		if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
+			PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
+			break;
 
 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
@@ -76,7 +77,7 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
 				return pos;
 		}
 
-		pos = pcie_cap >> 20;
+		pos = PCI_EXT_CAP_NEXT(pcie_cap);
 	}
 
 	return 0;
-- 
1.7.0.4

