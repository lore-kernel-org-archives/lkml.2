Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2EHSXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:23:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:1552 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab2EHSXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150636963"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH 03/23] x86, realmode: Relocator for realmode code
Date: Tue,  8 May 2012 21:22:26 +0300
Message-Id: <1336501366-28617-4-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements relocator for real mode code that is called
as part of setup_arch(). Processes segment relocations
and linear relocations. Real-mode code is relocated to
a free hole below 1 MB.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/include/asm/realmode.h |   26 +++++++++++++
 arch/x86/kernel/Makefile        |    1 +
 arch/x86/kernel/realmode.c      |   79 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c         |    2 +
 4 files changed, 108 insertions(+)
 create mode 100644 arch/x86/include/asm/realmode.h
 create mode 100644 arch/x86/kernel/realmode.c

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
new file mode 100644
index 0000000..dc1bba5
--- /dev/null
+++ b/arch/x86/include/asm/realmode.h
@@ -0,0 +1,26 @@
+#ifndef _ARCH_X86_REALMODE_H
+#define _ARCH_X86_REALMODE_H
+
+#include <linux/types.h>
+#include <asm/io.h>
+
+/* This must match data at realmode.S */
+struct real_mode_header {
+	u32	text_start;
+	u32	ro_end;
+	u32	end;
+} __attribute__((__packed__));
+
+extern struct real_mode_header real_mode_header;
+extern unsigned char *real_mode_base;
+
+extern unsigned long init_rsp;
+extern unsigned long initial_code;
+extern unsigned long initial_gs;
+
+extern unsigned char real_mode_blob[];
+extern unsigned char real_mode_relocs[];
+
+extern void __init setup_real_mode(void);
+
+#endif /* _ARCH_X86_REALMODE_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 532d2e0..f9e19d4 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,6 +36,7 @@ obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
 obj-y				+= trampoline.o trampoline_$(BITS).o
+obj-y				+= realmode.o
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
diff --git a/arch/x86/kernel/realmode.c b/arch/x86/kernel/realmode.c
new file mode 100644
index 0000000..7415c42
--- /dev/null
+++ b/arch/x86/kernel/realmode.c
@@ -0,0 +1,79 @@
+#include <linux/io.h>
+#include <linux/memblock.h>
+
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+#include <asm/realmode.h>
+
+unsigned char *real_mode_base;
+struct real_mode_header real_mode_header;
+
+void __init setup_real_mode(void)
+{
+	phys_addr_t mem;
+	u16 real_mode_seg;
+	u32 *rel;
+	u32 count;
+	u32 *ptr;
+	u16 *seg;
+	int i;
+
+	struct real_mode_header *header =
+		(struct real_mode_header *) real_mode_blob;
+
+	size_t size = PAGE_ALIGN(header->end);
+
+	/* Has to be in very low memory so we can execute real-mode AP code. */
+	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
+	if (!mem)
+		panic("Cannot allocate trampoline\n");
+
+	real_mode_base = __va(mem);
+	memblock_reserve(mem, size);
+
+	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
+	       real_mode_base, (unsigned long long)mem, size);
+
+	memcpy(real_mode_base, real_mode_blob, size);
+
+	real_mode_seg = __pa(real_mode_base) >> 4;
+	rel = (u32 *) real_mode_relocs;
+
+	/* 16-bit segment relocations. */
+	count = rel[0];
+	rel = &rel[1];
+	for (i = 0; i < count; i++) {
+		seg = (u16 *) (real_mode_base + rel[i]);
+		*seg = real_mode_seg;
+	}
+
+	/* 32-bit linear relocations. */
+	count = rel[i];
+	rel =  &rel[i + 1];
+	for (i = 0; i < count; i++) {
+		ptr = (u32 *) (real_mode_base + rel[i]);
+		*ptr += __pa(real_mode_base);
+	}
+
+	/* Copied header will contain relocated physical addresses. */
+	memcpy(&real_mode_header, real_mode_base,
+	       sizeof(struct real_mode_header));
+}
+
+/*
+ * set_real_mode_permissions() gets called very early, to guarantee the
+ * availability of low memory.  This is before the proper kernel page
+ * tables are set up, so we cannot set page permissions in that
+ * function.  Thus, we use an arch_initcall instead.
+ */
+static int __init set_real_mode_permissions(void)
+{
+	size_t all_size =
+		PAGE_ALIGN(real_mode_header.end) -
+		__pa(real_mode_base);
+
+	set_memory_x((unsigned long) real_mode_base, all_size >> PAGE_SHIFT);
+	return 0;
+}
+
+arch_initcall(set_real_mode_permissions);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1a29015..56e4124 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -74,6 +74,7 @@
 #include <asm/mtrr.h>
 #include <asm/apic.h>
 #include <asm/trampoline.h>
+#include <asm/realmode.h>
 #include <asm/e820.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
@@ -918,6 +919,7 @@ void __init setup_arch(char **cmdline_p)
 			max_pfn_mapped<<PAGE_SHIFT);
 
 	setup_trampolines();
+	setup_real_mode();
 
 	init_gbpages();
 
-- 
1.7.9.5

