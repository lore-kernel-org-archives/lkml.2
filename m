Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2IQAu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33342 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab2IQAt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:27 -0400
Message-Id: <20120917003628.590020709@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 017/135] xen/setup: Fix one-off error when adding for-balloon PFNs to the
 P2M.
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit c96aae1f7f393387d160211f60398d58463a7e65 upstream.

When we are finished with return PFNs to the hypervisor, then
populate it back, and also mark the E820 MMIO and E820 gaps
as IDENTITY_FRAMEs, we then call P2M to set areas that can
be used for ballooning. We were off by one, and ended up
over-writting a P2M entry that most likely was an IDENTITY_FRAME.
For example:

1-1 mapping on 40000->40200
1-1 mapping on bc558->bc5ac
1-1 mapping on bc5b4->bc8c5
1-1 mapping on bc8c6->bcb7c
1-1 mapping on bcd00->100000
Released 614 pages of unused memory
Set 277889 page(s) to 1-1 mapping
Populating 40200-40466 pfn range: 614 pages added

=> here we set from 40466 up to bc559 P2M tree to be
INVALID_P2M_ENTRY. We should have done it up to bc558.

The end result is that if anybody is trying to construct
a PTE for PFN bc558 they end up with ~PAGE_PRESENT.

Reported-by-and-Tested-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/setup.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -78,9 +78,16 @@ static void __init xen_add_extra_mem(u64
 	memblock_x86_reserve_range(start, start + size, "XEN EXTRA");
 
 	xen_max_p2m_pfn = PFN_DOWN(start + size);
+	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
+		unsigned long mfn = pfn_to_mfn(pfn);
+
+		if (WARN(mfn == pfn, "Trying to over-write 1-1 mapping (pfn: %lx)\n", pfn))
+			continue;
+		WARN(mfn != INVALID_P2M_ENTRY, "Trying to remove %lx which has %lx mfn!\n",
+			pfn, mfn);
 
-	for (pfn = PFN_DOWN(start); pfn <= xen_max_p2m_pfn; pfn++)
 		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+	}
 }
 
 static unsigned long __init xen_release_chunk(unsigned long start,


