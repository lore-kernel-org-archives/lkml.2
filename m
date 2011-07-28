Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1G1Xt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:49:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:55935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab1G1Xoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33559504"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: lliubbo@gmail.com, geert@linux-m68k.org, dhowells@redhat.com,
        gerg@uclinux.org, vapier@gentoo.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [29/50] mm/nommu.c: fix remap_pfn_range()
Message-Id: <20110728234433.CB71D2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Bob Liu <lliubbo@gmail.com>

[ upstream commit 8f3b1327aa454bc8283e96bca7669c3c88b83f79 ]

remap_pfn_range() means map physical address pfn<<PAGE_SHIFT to user addr.

For nommu arch it's implemented by vma->vm_start = pfn << PAGE_SHIFT which
is wrong acroding the original meaning of this function.  And some driver
developer using remap_pfn_range() with correct parameter will get
unexpected result because vm_start is changed.  It should be implementd
like addr = pfn << PAGE_SHIFT but which is meanless on nommu arch, this
patch just make it simply return.

Parameter name and setting of vma->vm_flags also be fixed.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/mm/nommu.c
===================================================================
--- linux-2.6.35.y.orig/mm/nommu.c
+++ linux-2.6.35.y/mm/nommu.c
@@ -1747,10 +1747,13 @@ struct page *follow_page(struct vm_area_
 	return NULL;
 }
 
-int remap_pfn_range(struct vm_area_struct *vma, unsigned long from,
-		unsigned long to, unsigned long size, pgprot_t prot)
+int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
-	vma->vm_start = vma->vm_pgoff << PAGE_SHIFT;
+	if (addr != (pfn << PAGE_SHIFT))
+		return -EINVAL;
+
+	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 	return 0;
 }
 EXPORT_SYMBOL(remap_pfn_range);
