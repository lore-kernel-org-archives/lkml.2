Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048Ab1DNR7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:59:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:42179 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab1DNR6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 179/209] x86, vt-d: Handle previous faults after enabling fault handling
Date: Thu, 14 Apr 2011 13:55:37 -0400
Message-Id: <1302803767-9715-66-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/dmar.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 33ead97..0afcc4e 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1424,6 +1424,11 @@ int __init enable_drhd_fault_handling(void)
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
-- 
1.7.4.4

