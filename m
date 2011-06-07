Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1FGSKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:10:22 -0400
Received: from smtp.citrix.com ([66.165.176.89]:4308 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab1FGSKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:10:19 -0400
X-IronPort-AV: E=Sophos;i="4.65,333,1304308800"; 
   d="scan'208";a="14472927"
From: <stefano.stabellini@eu.citrix.com>
To: hpa@zytor.com
CC: hpa@linux.intel.com, konrad.wilk@oracle.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Stefano.Stabellini@eu.citrix.com, yinghai@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3/3] x86: move memblock_x86_reserve_range PGTABLE to find_early_table_space
Date: Tue, 7 Jun 2011 19:13:29 +0100
Message-ID: <1307470409-7654-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop>
References: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Now that find_early_table_space knows how to calculate the exact amout
of memory needed by the kernel pagetable, we can reserve the range
directly in find_early_table_space.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/init.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 15590fd..36bacfe 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -104,6 +104,10 @@ static void __init find_early_table_space(unsigned long start,
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
 		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
+
+	if (pgt_buf_top > pgt_buf_start)
+		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
+				 pgt_buf_top << PAGE_SHIFT, "PGTABLE");
 }
 
 struct map_range {
@@ -301,10 +305,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		printk(KERN_DEBUG "initial kernel pagetable allocation wasted %lx"
 				" pages\n", pgt_buf_top - pgt_buf_end);
 
-	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
-		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
-				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
-
 	if (!after_bootmem)
 		early_memtest(start, end);
 
-- 
1.7.2.3

