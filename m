Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2GZUwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:52:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27046 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab2GZUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:52:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/swiotlb: If user supplied e820_hole=1 in the guest config, enable SWIOTLB.
Date: Thu, 26 Jul 2012 16:43:27 -0400
Message-Id: <1343335407-5465-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343335407-5465-1-git-send-email-konrad.wilk@oracle.com>
References: <1343335407-5465-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can detect that the user is using e820_hole=1 by parsing the E820.
If it shows regions other than E820_RAM or E820_RESV then the
user is bent on providing us with a PCI device and forgot
to do 'iommu=soft'. So lets enable it for him/her.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 56f373e..9b1aebb 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -74,6 +74,11 @@ int __init pci_xen_swiotlb_detect(void)
 	if (xen_pv_domain())
 		swiotlb = 0;
 
+	/* If it hasn't been activated yet, and it has E820 that looks like
+	 * the user supplied e820_hole=1, then turn it on. */
+	if (xen_pv_domain() && !xen_initial_domain() &&
+	    !xen_swiotlb && e820_has_acpi())
+		xen_swiotlb = 1;
 	return xen_swiotlb;
 }
 
-- 
1.7.7.6

