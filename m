Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295Ab2HPQO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:14:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32115 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab2HPQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:13:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 11/11] xen/mmu: Release just the MFN list, not MFN list and part of pagetables.
Date: Thu, 16 Aug 2012 12:03:29 -0400
Message-Id: <1345133009-21941-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call memblock_reserve for [start of mfn list] -> [PMD aligned end
of mfn list] instead of <start of mfn list> -> <page aligned end of mfn list].

This has the disastrous effect that if at bootup the end of mfn_list is
not PMD aligned we end up returning to memblock parts of the region
past the mfn_list array. And those parts are the PTE tables with
the disastrous effect of seeing this at bootup:

Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1860k freed
Freeing unused kernel memory: 200k freed
(XEN) mm.c:2429:d0 Bad type (saw 1400000000000002 != exp 7000000000000000) for mfn 116a80 (pfn 14e26)
...
(XEN) mm.c:908:d0 Error getting mfn 116a83 (pfn 14e2a) from L1 entry 8000000116a83067 for l1e_owner=0, pg_owner=0
(XEN) mm.c:908:d0 Error getting mfn 4040 (pfn 5555555555555555) from L1 entry 0000000004040601 for l1e_owner=0, pg_owner=0
.. and so on.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5a880b8..6019c22 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1227,7 +1227,6 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
 			/* We should be in __ka space. */
 			BUG_ON(xen_start_info->mfn_list < __START_KERNEL_map);
 			addr = xen_start_info->mfn_list;
-			size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
 			/* We roundup to the PMD, which means that if anybody at this stage is
 			 * using the __ka address of xen_start_info or xen_start_info->shared_info
 			 * they are in going to crash. Fortunatly we have already revectored
@@ -1235,6 +1234,7 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
 			size = roundup(size, PMD_SIZE);
 			xen_cleanhighmap(addr, addr + size);
 
+			size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
 			memblock_free(__pa(xen_start_info->mfn_list), size);
 			/* And revector! Bye bye old array */
 			xen_start_info->mfn_list = new_mfn_list;
-- 
1.7.7.6

