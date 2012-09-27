Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2I0SWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:22:32 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47488 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2I0SW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:22:28 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 14:22:16 EDT
From: Daniel Kiper <daniel.kiper@oracle.com>
To: konrad.wilk@oracle.com, andrew.cooper3@citrix.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 04/11] x86/xen: Introduce architecture dependent data for kexec/kdump
Date: Thu, 27 Sep 2012 20:06:31 +0200
Message-Id: <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.000000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce architecture dependent constants, structures and
functions required by Xen kexec/kdump implementation.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/include/asm/xen/hypercall.h |    6 +++
 arch/x86/include/asm/xen/kexec.h     |   83 ++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/kexec.h

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 59c226d..553544c 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -466,6 +466,12 @@ HYPERVISOR_hvm_op(int op, void *arg)
 }
 
 static inline int
+HYPERVISOR_kexec_op(unsigned long op, void *args)
+{
+	return _hypercall2(int, kexec_op, op, args);
+}
+
+static inline int
 HYPERVISOR_tmem_op(
 	struct tmem_op *op)
 {
diff --git a/arch/x86/include/asm/xen/kexec.h b/arch/x86/include/asm/xen/kexec.h
new file mode 100644
index 0000000..3349031
--- /dev/null
+++ b/arch/x86/include/asm/xen/kexec.h
@@ -0,0 +1,83 @@
+/*
+ * Copyright (c) 2011 Daniel Kiper
+ * Copyright (c) 2012 Daniel Kiper, Oracle Corporation
+ *
+ * kexec/kdump implementation for Xen was written by Daniel Kiper.
+ * Initial work on it was sponsored by Google under Google Summer
+ * of Code 2011 program and Citrix. Konrad Rzeszutek Wilk from Oracle
+ * was the mentor for this project.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _ASM_X86_XEN_KEXEC_H
+#define _ASM_X86_XEN_KEXEC_H
+
+#include <linux/init.h>
+
+#define KEXEC_XEN_NO_PAGES	17
+
+#define XK_MA_CONTROL_PAGE	0
+#define XK_VA_CONTROL_PAGE	1
+#define XK_MA_PGD_PAGE		2
+#define XK_VA_PGD_PAGE		3
+#define XK_MA_PUD0_PAGE		4
+#define XK_VA_PUD0_PAGE		5
+#define XK_MA_PUD1_PAGE		6
+#define XK_VA_PUD1_PAGE		7
+#define XK_MA_PMD0_PAGE		8
+#define XK_VA_PMD0_PAGE		9
+#define XK_MA_PMD1_PAGE		10
+#define XK_VA_PMD1_PAGE		11
+#define XK_MA_PTE0_PAGE		12
+#define XK_VA_PTE0_PAGE		13
+#define XK_MA_PTE1_PAGE		14
+#define XK_VA_PTE1_PAGE		15
+#define XK_MA_TABLE_PAGE	16
+
+#ifndef __ASSEMBLY__
+struct xen_kexec_image {
+	unsigned long page_list[KEXEC_XEN_NO_PAGES];
+	unsigned long indirection_page;
+	unsigned long start_address;
+};
+
+struct xen_kexec_load {
+	int type;
+	struct xen_kexec_image image;
+};
+
+extern unsigned int xen_kexec_control_code_size;
+
+extern void __init xen_init_kexec_ops(void);
+
+#ifdef CONFIG_X86_32
+extern void xen_relocate_kernel(unsigned long indirection_page,
+				unsigned long *page_list,
+				unsigned long start_address,
+				unsigned int has_pae,
+				unsigned int preserve_context);
+#else
+extern void xen_relocate_kernel(unsigned long indirection_page,
+				unsigned long *page_list,
+				unsigned long start_address,
+				unsigned int preserve_context);
+#endif
+#endif
+#endif /* _ASM_X86_XEN_KEXEC_H */
-- 
1.5.6.5

