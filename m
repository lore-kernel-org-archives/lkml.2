Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0LAG4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:56:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:34092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0LAG4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:56:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="579345803"
Message-Id: <20101201062244.630417138@intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 30 Nov 2010 22:22:29 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>, indou.takao@jp.fujitsu.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org
Subject: [patch 4/4] vt-d: handle previous faults after enabling fault handling
References: <20101201062225.292364637@intel.com>
Content-Disposition: inline; filename=vtd_handle_oldfaults_in_enable_drhd_fault_handling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org [v2.6.32+]
---
 drivers/pci/dmar.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c
+++ tip/drivers/pci/dmar.c
@@ -1417,6 +1417,11 @@ int __init enable_drhd_fault_handling(vo
 			       (unsigned long long)drhd->reg_base_addr, ret);
 			return -1;
 		}
+
+		/*
+ 		 * Clear any previous faults.
+ 		 */
+		dmar_fault(iommu->irq, iommu);
 	}
 
 	return 0;


