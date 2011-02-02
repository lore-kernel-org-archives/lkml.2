Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1BBAyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:54:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:42502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1BBAou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028560"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: suresh.b.siddha@intel.com, ak@linux.intel.com, chrisw@sous-sol.org,
        hpa@linux.intel.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [91/139] x86, vt-d: Handle previous faults after enabling fault handling
Message-Id: <20110202004449.056643E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20101201062244.630417138@intel.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/dmar.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.35.y/drivers/pci/dmar.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/dmar.c
+++ linux-2.6.35.y/drivers/pci/dmar.c
@@ -1414,6 +1414,11 @@ int __init enable_drhd_fault_handling(vo
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
