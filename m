Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2IMAOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:14:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab2ILXiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:38:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 12/85] xen/setup: Fix one-off error when adding for-balloon PFNs to the P2M.
Date: Wed, 12 Sep 2012 16:35:55 -0700
Message-Id: <20120912233543.010766399@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/setup.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -79,9 +79,16 @@ static void __init xen_add_extra_mem(u64
 	memblock_reserve(start, size);
 
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


