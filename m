Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab0LBCDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:03:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:47248 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab0LBCDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:03:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="355850356"
Subject: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "hpa@zytor.com" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
        sam@ravnborg.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 10:02:27 +0800
Message-ID: <1291255347.12777.116.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu readmostly section should start and end at address cachline aligned.
Idealy we should change PERCPU_VADDR/PERCPU, but I can't change all arch code, so
I add new macros for x86.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 include/asm-generic/vmlinux.lds.h |   66 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

Index: linux/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux.orig/include/asm-generic/vmlinux.lds.h	2010-12-02 09:22:32.000000000 +0800
+++ linux/include/asm-generic/vmlinux.lds.h	2010-12-02 09:32:42.000000000 +0800
@@ -726,6 +726,72 @@
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
 	}
 
+/**
+ * PERCPU_VADDR_CACHEALIGNED - define output section for percpu area
+ * @vaddr: explicit base address (optional)
+ * @phdr: destination PHDR (optional)
+ * @cacheline: cachline size required by readmostly percpu data
+ *
+ * Macro which expands to output section for percpu area.  If @vaddr
+ * is not blank, it specifies explicit base address and all percpu
+ * symbols will be offset from the given address.  If blank, @vaddr
+ * always equals @laddr + LOAD_OFFSET.
+ *
+ * @phdr defines the output PHDR to use if not blank.  Be warned that
+ * output PHDR is sticky.  If @phdr is specified, the next output
+ * section in the linker script will go there too.  @phdr should have
+ * a leading colon.
+ *
+ * Note that this macros defines __per_cpu_load as an absolute symbol.
+ * If there is no need to put the percpu section at a predetermined
+ * address, use PERCPU_CACHEALIGNED().
+ */
+#define PERCPU_VADDR_CACHEALIGNED(vaddr, phdr, cacheline)		\
+	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
+	.data..percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
+				- LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
+		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
+		*(.data..percpu..page_aligned)				\
+		. = ALIGN(cacheline);					\
+		*(.data..percpu..readmostly)				\
+		. = ALIGN(cacheline);					\
+		*(.data..percpu)					\
+		*(.data..percpu..shared_aligned)			\
+		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+	} phdr								\
+	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data..percpu);
+
+/**
+ * PERCPU_CACHEALIGNED - define output section for percpu area, simple version
+ * @align: required alignment
+ * @cacheline: cachline size required by readmostly percpu data
+ *
+ * Align to @align and outputs output section for percpu area.  This
+ * macro doesn't maniuplate @vaddr or @phdr and __per_cpu_load and
+ * __per_cpu_start will be identical.
+ *
+ * This macro is equivalent to ALIGN(align); PERCPU_VADDR_CACHEALIGNED( , ) except
+ * that __per_cpu_load is defined as a relative symbol against
+ * .data..percpu which is required for relocatable x86_32
+ * configuration.
+ */
+#define PERCPU_CACHEALIGNED(align, cacheline)				\
+	. = ALIGN(align);						\
+	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
+		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
+		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
+		*(.data..percpu..page_aligned)				\
+		. = ALIGN(cacheline);					\
+		*(.data..percpu..readmostly)				\
+		. = ALIGN(cacheline);					\
+		*(.data..percpu)					\
+		*(.data..percpu..shared_aligned)			\
+		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+	}
 
 /*
  * Definition of the high level *_SECTION macros


