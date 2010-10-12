Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0JLPvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:51:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31557 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab0JLPvg (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:51:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/23] xen: define BIOVEC_PHYS_MERGEABLE()
Date: Tue, 12 Oct 2010 11:44:10 -0400
Message-Id: <1286898271-32018-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: allow Xen control of bio merging

When running in Xen domain with device access, we need to make sure
the block subsystem doesn't merge requests across pages which aren't
machine physically contiguous.  To do this, we define our own
BIOVEC_PHYS_MERGEABLE.  When CONFIG_XEN isn't enabled, or we're not
running in a Xen domain, this has identical behaviour to the normal
implementation.  When running under Xen, we also make sure the
underlying machine pages are the same or adjacent.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/io.h |   13 +++++++++++++
 drivers/xen/Makefile      |    2 +-
 drivers/xen/biomerge.c    |   13 +++++++++++++
 3 files changed, 27 insertions(+), 1 deletions(-)
 create mode 100644 drivers/xen/biomerge.c

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 30a3e97..0ad29d4 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -41,6 +41,8 @@
 #include <asm-generic/int-ll64.h>
 #include <asm/page.h>
 
+#include <xen/xen.h>
+
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
 { type ret; asm volatile("mov" size " %1,%0":reg (ret) \
@@ -349,6 +351,17 @@ extern void __iomem *early_memremap(resource_size_t phys_addr,
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 extern void fixup_early_ioremap(void);
 
+#ifdef CONFIG_XEN
+struct bio_vec;
+
+extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
+				      const struct bio_vec *vec2);
+
+#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
+	(__BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&				\
+	 (!xen_domain() || xen_biovec_phys_mergeable(vec1, vec2)))
+#endif	/* CONFIG_XEN */
+
 #define IO_SPACE_LIMIT 0xffff
 
 #endif /* _ASM_X86_IO_H */
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index fcaf838..b47f5da 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,4 +1,4 @@
-obj-y	+= grant-table.o features.o events.o manage.o
+obj-y	+= grant-table.o features.o events.o manage.o biomerge.o
 obj-y	+= xenbus/
 
 nostackp := $(call cc-option, -fno-stack-protector)
diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
new file mode 100644
index 0000000..ba6eda4
--- /dev/null
+++ b/drivers/xen/biomerge.c
@@ -0,0 +1,13 @@
+#include <linux/bio.h>
+#include <linux/io.h>
+#include <xen/page.h>
+
+bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
+			       const struct bio_vec *vec2)
+{
+	unsigned long mfn1 = pfn_to_mfn(page_to_pfn(vec1->bv_page));
+	unsigned long mfn2 = pfn_to_mfn(page_to_pfn(vec2->bv_page));
+
+	return __BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&
+		((mfn1 == mfn2) || ((mfn1+1) == mfn2));
+}
-- 
1.7.0.4

