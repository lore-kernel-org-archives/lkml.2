Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2GaOwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:52:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48917 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2GaOwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:52:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jbeulich@suse.com, stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/6] xen/mmu: Remove from __ka space PMD entries for pagetables.
Date: Tue, 31 Jul 2012 10:43:24 -0400
Message-Id: <1343745804-28028-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343745804-28028-1-git-send-email-konrad.wilk@oracle.com>
References: <1343745804-28028-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please first read the description in "xen/mmu: Copy and revector the
P2M tree."

At this stage, the __ka address space (which is what the old
P2M tree was using) is partially disassembled. The cleanup_highmap
has removed the PMD entries from 0-16MB and anything past _brk_end
up to the max_pfn_mapped (which is the end of the ramdisk).

The xen_remove_p2m_tree and code around has ripped out the __ka for
the old P2M array.

Here we continue on doing it to where the Xen page-tables were.
It is safe to do it, as the page-tables are addressed using __va.
For good measure we delete anything that is within MODULES_VADDR
and up to the end of the PMD.

At this point the __ka only contains PMD entries for the start
of the kernel up to __brk.

[v1: Per Stefano's suggestion wrapped the MODULES_VADDR in debug]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 9358b75..fa4d208 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1240,6 +1240,25 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
 			xen_start_info->mfn_list = new_mfn_list;
 		}
 	}
+	/* At this stage, cleanup_highmap has already cleaned __ka space
+	 * from _brk_limit way up to the max_pfn_mapped (which is the end of
+	 * the ramdisk). We continue on, erasing PMD entries that point to page
+	 * tables - do note that they are accessible at this stage via __va.
+	 * For good measure we also round up to the PMD - which means that if
+	 * anybody is using __ka address to the initial boot-stack - and try
+	 * to use it - they are going to crash. The xen_start_info has been
+	 * taken care of already in xen_setup_kernel_pagetable. */
+	addr = xen_start_info->pt_base;
+	size = roundup(xen_start_info->nr_pt_frames * PAGE_SIZE, PMD_SIZE);
+
+	xen_cleanhighmap(addr, addr + size);
+	xen_start_info->pt_base = (unsigned long)__va(__pa(xen_start_info->pt_base));
+#ifdef DEBUG
+	/* This is superflous and shouldn't be neccessary, but you know what
+	 * lets do it. The MODULES_VADDR -> MODULES_END should be clear of
+	 * anything at this stage. */
+	xen_cleanhighmap(MODULES_VADDR, roundup(MODULES_VADDR, PUD_SIZE) - 1);
+#endif
 #endif
 	xen_post_allocator_init();
 }
-- 
1.7.7.6

