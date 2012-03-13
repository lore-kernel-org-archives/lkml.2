Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049Ab2CMAik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:38:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:48618 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964958Ab2CMAYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, David Woodhouse <David.Woodhouse@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 159/196] intel-iommu: Force-disable IOMMU for iGFX on broken Cantiga revisions.
Date: Mon, 12 Mar 2012 20:21:12 -0400
Message-Id: <1331598109-31424-114-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <David.Woodhouse@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2d9e667efdfb4e986074d98e7d9a424003c7c43b upstream.

Certain revisions of this chipset appear to be broken. There is a shadow
GTT which mirrors the real GTT but contains pre-translated physical
addresses, for performance reasons. When a GTT update happens, the
translations are done once and the resulting physical addresses written
back to the shadow GTT.

Except sometimes, the physical address is actually written back to the
_real_ GTT, not the shadow GTT. Thus we start to see faults when that
physical address is fed through translation again.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/intel-iommu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 2b985b9..67e2f60 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -383,7 +383,7 @@ int dmar_disabled = 0;
 int dmar_disabled = 1;
 #endif /*CONFIG_DMAR_DEFAULT_ON*/
 
-static int __initdata dmar_map_gfx = 1;
+static int dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
 
@@ -3762,6 +3762,12 @@ static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
 	 */
 	printk(KERN_INFO "DMAR: Forcing write-buffer flush capability\n");
 	rwbf_quirk = 1;
+
+	/* https://bugzilla.redhat.com/show_bug.cgi?id=538163 */
+	if (dev->revision == 0x07) {
+		printk(KERN_INFO "DMAR: Disabling IOMMU for graphics on this chipset\n");
+		dmar_map_gfx = 0;
+	}
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);
-- 
1.7.9.3

