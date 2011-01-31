Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1AaXJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:09:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22693 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab1AaXJO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/11] xen/setup: Set identity mapping for non-RAM E820 and E820 gaps.
Date: Mon, 31 Jan 2011 17:44:30 -0500
Message-Id: <1296513876-31415-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We walk the E820 region and start at 0 (for PV guests we start
at ISA_END_ADDRESS) and skip any E820 RAM regions. For all other
regions and as well the gaps we set them to be identity mappings.

The reasons we do not want to set the identity mapping from 0->
ISA_END_ADDRESS when running as PV is b/c that the kernel would
try to read DMI information and fail (no permissions to read that).
There is a lot of gnarly code to deal with that weird region so
we won't try to do a cleanup in this patch.

This code ends up calling 'set_phys_to_identity' with the start
and end PFN of the the E820 that are non-RAM or have gaps.
On 99% of machines that means one big region right underneath the
4GB mark. Usually starts at 0xc0000 (or 0x80000) and goes to
0x100000.

[v2: Fix for E820 crossing 1MB region and clamp the start]
[v3: Squshed in code that does this over ranges]
[v4: Moved the comment to the correct spot]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 7201800..c2a5b5f 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -143,6 +143,44 @@ static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
 	return released;
 }
 
+static unsigned long __init xen_set_identity(const struct e820map *e820)
+{
+	phys_addr_t last = xen_initial_domain() ? 0 : ISA_END_ADDRESS;
+	phys_addr_t start_pci = last;
+	int i;
+	unsigned long identity = 0;
+
+	for (i = 0; i < e820->nr_map; i++) {
+		phys_addr_t start = e820->map[i].addr;
+		phys_addr_t end = start + e820->map[i].size;
+
+		if (start < last)
+			start = last;
+
+		if (end <= start)
+			continue;
+
+		/* Skip over the 1MB region. */
+		if (last > end)
+			continue;
+
+		if (e820->map[i].type == E820_RAM) {
+			if (start > start_pci)
+				identity += set_phys_range_identity(
+					PFN_UP(start_pci), PFN_DOWN(start));
+			start_pci = end;
+			/* Without saving 'last' we would gooble RAM too. */
+			last = end;
+			continue;
+		}
+		start_pci = min(start, start_pci);
+		last = end;
+	}
+	if (last > start_pci)
+		identity += set_phys_range_identity(
+					PFN_UP(start_pci), PFN_DOWN(last));
+	return identity;
+}
 /**
  * machine_specific_memory_setup - Hook for machine specific memory setup.
  **/
@@ -156,6 +194,7 @@ char * __init xen_memory_setup(void)
 	struct xen_memory_map memmap;
 	unsigned long extra_pages = 0;
 	unsigned long extra_limit;
+	unsigned long identity_pages = 0;
 	int i;
 	int op;
 
@@ -251,6 +290,12 @@ char * __init xen_memory_setup(void)
 
 	xen_add_extra_mem(extra_pages);
 
+	/*
+	 * Set P2M for all non-RAM pages and E820 gaps to be identity
+	 * type PFNs.
+	 */
+	identity_pages = xen_set_identity(&e820);
+	printk(KERN_INFO "Set %ld page(s) to 1-1 mapping.\n", identity_pages);
 	return "Xen";
 }
 
-- 
1.7.1

