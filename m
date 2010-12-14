Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0LNBRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:17:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:46616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758848Ab0LNBRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:17:20 -0500
Date: Tue, 14 Dec 2010 01:17:04 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        chrisw@sous-sol.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        chrisw@sous-sol.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20101201062244.630417138@intel.com>
References: <20101201062244.630417138@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, vt-d: Handle previous faults after enabling fault handling
Message-ID: <tip-7f99d946e71e71d484b7543b49e990508e70d0c0@git.kernel.org>
Git-Commit-ID: 7f99d946e71e71d484b7543b49e990508e70d0c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 01:17:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f99d946e71e71d484b7543b49e990508e70d0c0
Gitweb:     http://git.kernel.org/tip/7f99d946e71e71d484b7543b49e990508e70d0c0
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 30 Nov 2010 22:22:29 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Dec 2010 16:53:57 -0800

x86, vt-d: Handle previous faults after enabling fault handling

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
Cc: stable@kernel.org [v2.6.32+]
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/pci/dmar.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 0157708..09933eb 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1417,6 +1417,11 @@ int __init enable_drhd_fault_handling(void)
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
