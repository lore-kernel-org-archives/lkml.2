Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1BAWeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:34:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63523 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab1BAWd7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 1 Feb 2011 17:33:59 -0500
Date: Tue, 1 Feb 2011 17:32:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com
Subject: Re: [PATCH 05/11] xen/setup: Set identity mapping for non-RAM E820
 and E820 gaps.
Message-ID: <20110201223233.GF18656@dumpdata.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
 <1296513876-31415-6-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296513876-31415-6-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 05:44:30PM -0500, Konrad Rzeszutek Wilk wrote:
> We walk the E820 region and start at 0 (for PV guests we start
> at ISA_END_ADDRESS) and skip any E820 RAM regions. For all other
> regions and as well the gaps we set them to be identity mappings.
> 
> The reasons we do not want to set the identity mapping from 0->
> ISA_END_ADDRESS when running as PV is b/c that the kernel would
> try to read DMI information and fail (no permissions to read that).
> There is a lot of gnarly code to deal with that weird region so
> we won't try to do a cleanup in this patch.
> 
> This code ends up calling 'set_phys_to_identity' with the start
> and end PFN of the the E820 that are non-RAM or have gaps.
> On 99% of machines that means one big region right underneath the
> 4GB mark. Usually starts at 0xc0000 (or 0x80000) and goes to
> 0x100000.
> 

Please consider this one instead. The change is that we 
use the unmodified E820 retrieved from the hypervisor. This E820
has no changes to the size of the System RAM (which were throwing off my
ranges earlier):

commit acaf45c9c7d1b0d87c047590b9bffa0d8a30cbee
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Tue Feb 1 17:15:30 2011 -0500

    xen/setup: Set identity mapping for non-RAM E820 and E820 gaps.
    
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
    [v5: Use the "raw" E820 from the hypervisor]
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 7201800..54d9379 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -143,12 +143,55 @@ static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
 	return released;
 }
 
+static unsigned long __init xen_set_identity(const struct e820entry *list,
+					     ssize_t map_size)
+{
+	phys_addr_t last = xen_initial_domain() ? 0 : ISA_END_ADDRESS;
+	phys_addr_t start_pci = last;
+	const struct e820entry *entry;
+	unsigned long identity = 0;
+	int i;
+
+	for (i = 0, entry = list; i < map_size; i++, entry++) {
+		phys_addr_t start = entry->addr;
+		phys_addr_t end = start + entry->size;
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
+		if (entry->type == E820_RAM) {
+			if (start > start_pci)
+				identity += set_phys_range_identity(
+						PFN_UP(start_pci), PFN_DOWN(start));
+
+			/* Without saving 'last' we would gooble RAM too
+			 * at the end of the loop. */
+			last = end;
+			start_pci = end;
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
 char * __init xen_memory_setup(void)
 {
 	static struct e820entry map[E820MAX] __initdata;
+	static struct e820entry map_raw[E820MAX] __initdata;
 
 	unsigned long max_pfn = xen_start_info->nr_pages;
 	unsigned long long mem_end;
@@ -156,6 +199,7 @@ char * __init xen_memory_setup(void)
 	struct xen_memory_map memmap;
 	unsigned long extra_pages = 0;
 	unsigned long extra_limit;
+	unsigned long identity_pages = 0;
 	int i;
 	int op;
 
@@ -181,6 +225,7 @@ char * __init xen_memory_setup(void)
 	}
 	BUG_ON(rc);
 
+	memcpy(map_raw, map, sizeof(map));
 	e820.nr_map = 0;
 	xen_extra_mem_start = mem_end;
 	for (i = 0; i < memmap.nr_entries; i++) {
@@ -251,6 +296,13 @@ char * __init xen_memory_setup(void)
 
 	xen_add_extra_mem(extra_pages);
 
+	/*
+	 * Set P2M for all non-RAM pages and E820 gaps to be identity
+	 * type PFNs. We supply it with the non-sanitized version
+	 * of the E820.
+	 */
+	identity_pages = xen_set_identity(map_raw, memmap.nr_entries);
+	printk(KERN_INFO "Set %ld page(s) to 1-1 mapping.\n", identity_pages);
 	return "Xen";
 }
 
