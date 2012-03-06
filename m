Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2CFQJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:09:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab2CFQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:08:46 -0500
Date: Tue, 6 Mar 2012 08:07:35 -0800
From: tip-bot for Mike Travis <travis@sgi.com>
Message-ID: <tip-018fywmjs3lmzfyzjlktg8dx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joerg.roedel@amd.com, dwmw2@infradead.org, travis@sgi.com,
        habeck@sgi.com, akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
        drahn@suse.com, steiner@sgi.com, chrisw@sous-sol.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        travis@sgi.com, dwmw2@infradead.org, joerg.roedel@amd.com,
        habeck@sgi.com, chrisw@sous-sol.org, steiner@sgi.com, drahn@suse.com,
        jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86/iommu/intel:
  Fix identity mapping for sandy bridge
Git-Commit-ID: eae460b6590bb924d4e528d6cc7ccd4d993ff8dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:08:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eae460b6590bb924d4e528d6cc7ccd4d993ff8dd
Gitweb:     http://git.kernel.org/tip/eae460b6590bb924d4e528d6cc7ccd4d993ff8dd
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Mon, 5 Mar 2012 15:05:16 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:00:01 +0100

x86/iommu/intel: Fix identity mapping for sandy bridge

With SandyBridge, Intel has changed these Socket PCI devices to
have a class type of "System Peripheral" & "Performance
counter", rather than "HostBridge".

So instead of using a "special" case to detect which devices will
not be doing DMA, use the fact that a device that is not associated
with an IOMMU, will not need an identity map.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Mike Habeck <habeck@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Daniel Rahn <drahn@suse.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-018fywmjs3lmzfyzjlktg8dx@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/iommu/intel-iommu.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c9c6053..8aa580d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -48,8 +48,6 @@
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
-#define IS_BRIDGE_HOST_DEVICE(pdev) \
-			    ((pdev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
@@ -2369,18 +2367,18 @@ static int __init iommu_prepare_static_identity_mapping(int hw)
 		return -EFAULT;
 
 	for_each_pci_dev(pdev) {
-		/* Skip Host/PCI Bridge devices */
-		if (IS_BRIDGE_HOST_DEVICE(pdev))
-			continue;
 		if (iommu_should_identity_map(pdev, 1)) {
-			printk(KERN_INFO "IOMMU: %s identity mapping for device %s\n",
-			       hw ? "hardware" : "software", pci_name(pdev));
-
 			ret = domain_add_dev_info(si_domain, pdev,
-						     hw ? CONTEXT_TT_PASS_THROUGH :
-						     CONTEXT_TT_MULTI_LEVEL);
-			if (ret)
+					     hw ? CONTEXT_TT_PASS_THROUGH :
+						  CONTEXT_TT_MULTI_LEVEL);
+			if (ret) {
+				/* device not associated with an iommu */
+				if (ret == -ENODEV)
+					continue;
 				return ret;
+			}
+			pr_info("IOMMU: %s identity mapping for device %s\n",
+				hw ? "hardware" : "software", pci_name(pdev));
 		}
 	}
 
