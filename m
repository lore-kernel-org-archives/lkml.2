Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0LUViU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:38:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25422 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0LUViR (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:38:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/10] xen/setup: Set identity mapping for non-RAM E820 and E820 gaps.
Date: Tue, 21 Dec 2010 16:37:35 -0500
Message-Id: <1292967460-15709-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all regions that are not considered RAM, we do not
necessarily have to set the P2M, as it assumes that any
P2M top branch (so covering 134217728 pages, on 64-bit) or
middle branch (so covering 262144 pages, on 64-bit) are identity.
Meaning pfn_to_mfn(pfn)==pfn. However, not all E820 gaps are
that large, so for smaller and for boundary conditions we fill
out the P2M mapping with the identity mapping.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index d984d36..752c865 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -146,6 +146,34 @@ static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
 	return released;
 }
 
+static unsigned long __init xen_set_identity(const struct e820map *e820)
+{
+	phys_addr_t last = 0;
+	int i;
+	unsigned long identity = 0;
+	unsigned long pfn;
+
+	for (i = 0; i < e820->nr_map; i++) {
+		phys_addr_t start = e820->map[i].addr;
+		phys_addr_t end = start + e820->map[i].size;
+
+		if (end < start)
+			continue;
+
+		if (e820->map[i].type != E820_RAM) {
+			for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
+				set_phys_to_machine(pfn, pfn);
+			identity += pfn - PFN_UP(start);
+		}
+		if (start > last && ((start - last) > 0)) {
+			for (pfn = PFN_UP(last); pfn < PFN_DOWN(start); pfn++)
+				set_phys_to_machine(pfn, pfn);
+			identity += pfn - PFN_UP(last);
+		}
+		last = end;
+	}
+	return identity;
+}
 /**
  * machine_specific_memory_setup - Hook for machine specific memory setup.
  **/
@@ -254,6 +282,12 @@ char * __init xen_memory_setup(void)
 
 	xen_add_extra_mem(extra_pages);
 
+	/*
+	 * Set P2M for all non-RAM pages and E820 gaps to be identity
+	 * type PFNs.
+	 */
+	printk(KERN_INFO "Set %ld page(s) to 1-1 mapping.\n",
+		xen_set_identity(&e820));
 	return "Xen";
 }
 
-- 
1.7.1

