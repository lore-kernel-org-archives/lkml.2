Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0IMGtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:49:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:58258 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0IMGs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:48:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,358,1280732400"; 
   d="scan'208";a="323825499"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, alan@linux.intel.com, greg@kroah.com,
        Feng Tang <feng.tang@intel.com>, x86@kernel.org
Subject: [PATCH v3 2/4] x86: add two helper macros for fixed address mapping
Date: Mon, 13 Sep 2010 15:08:54 +0800
Message-Id: <1284361736-23011-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
References: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes fixmap will be used to map an physical address which
is not PAGE align, so to use it we need first map it and then
add the address offset to the mapped fixed address. These 2 new
helpers are suggested by Ingo Molnar to make the process simpler.

For a physicall address like "phys", a directly usable virtual
address can be get by
	virt = (void *)set_fixmap_offset(fixed_idx, phys);
or
	virt = (void *)set_fixmap_offset_nocache(fixed_idx, phys);
(depends on whether the physical address is cachable or not).

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/fixmap.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 arch/x86/include/asm/fixmap.h

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
old mode 100644
new mode 100755
index d07b44f..4d293dc
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -214,5 +214,20 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
 	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
 	return __virt_to_fix(vaddr);
 }
+
+/* Return an pointer with offset calculated */
+static inline unsigned long __set_fixmap_offset(enum fixed_addresses idx,
+				phys_addr_t phys, pgprot_t flags)
+{
+	__set_fixmap(idx, phys, flags);
+	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
+}
+
+#define set_fixmap_offset(idx, phys)			\
+	__set_fixmap_offset(idx, phys, PAGE_KERNEL)
+
+#define set_fixmap_offset_nocache(idx, phys)			\
+	__set_fixmap_offset(idx, phys, PAGE_KERNEL_NOCACHE)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_FIXMAP_H */
-- 
1.7.0.4

