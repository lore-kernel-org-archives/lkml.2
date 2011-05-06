Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1EFAj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:39:56 -0400
Received: from kroah.org ([198.145.64.141]:37314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab1EFAZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:17 2011
Message-Id: <20110506002217.581009349@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [125/143] intel-iommu: Force-disable IOMMU for iGFX on broken Cantiga revisions.
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <David.Woodhouse@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/intel-iommu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -382,7 +382,7 @@ int dmar_disabled = 0;
 int dmar_disabled = 1;
 #endif /*CONFIG_DMAR_DEFAULT_ON*/
 
-static int __initdata dmar_map_gfx = 1;
+static int dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
 
@@ -3741,6 +3741,12 @@ static void __devinit quirk_iommu_rwbf(s
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


