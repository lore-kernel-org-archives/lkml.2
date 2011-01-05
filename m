Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1AEXJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:09:01 -0500
Received: from kroah.org ([198.145.64.141]:50815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab1AEXGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:35 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:26 2011
Message-Id: <20110105230326.178999868@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [27/49] x86, vt-d: Handle previous faults after enabling fault handling
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 7f99d946e71e71d484b7543b49e990508e70d0c0 upstream.

Fault handling is getting enabled after enabling the interrupt-remapping (as
the success of interrupt-remapping can affect the apic mode and hence the
fault handling mode).

Hence there can potentially be some faults between the window of enabling
interrupt-remapping in the vt-d and the fault-handling of the vt-d units.

Handle any previous faults after enabling the vt-d fault handling.

For v2.6.38 cleanup, need to check if we can remove the dmar_fault() in the
enable_intr_remapping() and see if we can enable fault handling along with
enabling intr-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20101201062244.630417138@intel.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/dmar.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1380,6 +1380,11 @@ int __init enable_drhd_fault_handling(vo
 			       (unsigned long long)drhd->reg_base_addr, ret);
 			return -1;
 		}
+
+		/*
+		 * Clear any previous faults.
+		 */
+		dmar_fault(iommu->irq, iommu);
 	}
 
 	return 0;


