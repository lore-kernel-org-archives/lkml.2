Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1C0Ip2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 04:45:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44274 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1C0Ip0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 04:45:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CsB2PV48leDr6N3D8IUUs2YV54Hb4eYdbupFUddtdegztgsrNAqGuFk9PNSzXZFaTX
         KuLNq3Hsd7t5nQvB/mZ/RsNyrbcYMr2smY+NuUxHaHYUe4dtW1v05e3JHP6zJzokeEMi
         fruwdyqYXmxI13/xknvogjMzIJaROULsAGXpE=
From: Maksym Planeta <mcsim.planeta@gmail.com>
To: mingo@redhat.com
Cc: kernel-janitors@vger.kernel.org, namhyung@gmail.com,
        linux-kernel@vger.kernel.org, Maksym Planeta <mcsim.planeta@gmail.com>
Subject: [PATCH v2] x86: page: get_order() optimization
Date: Sun, 27 Mar 2011 11:45:56 +0300
Message-Id: <1301215556-8898-1-git-send-email-mcsim.planeta@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86 architecture get_order function can be optimized due to
assembler instruction bsr.

This is second version of patch where for constants gcc precompute the
result.

Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
---
 arch/x86/include/asm/getorder.h |   48 +++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/page.h     |    2 +-
 2 files changed, 49 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/getorder.h

diff --git a/arch/x86/include/asm/getorder.h b/arch/x86/include/asm/getorder.h
new file mode 100644
index 0000000..b0c6f57
--- /dev/null
+++ b/arch/x86/include/asm/getorder.h
@@ -0,0 +1,48 @@
+#ifndef __ASM_GENERIC_GETORDER_H
+#define __ASM_GENERIC_GETORDER_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/compiler.h>
+
+#ifdef CONFIG_X86_CMOV
+#define ASM_CMOVZ(op, dest) \
+		"cmovzl %" #op ",%" #dest ";\n\t"
+#else
+#define ASM_CMOVZ(op, dest) \
+		"jnz 1f;\n\t" \
+		"movl %" #op ", %" #dest ";\n\t" \
+		"1: "
+#endif
+
+static __always_inline int __get_order(unsigned long size)
+{
+	int order;
+
+	size = (size - 1) >> (PAGE_SHIFT - 1);
+	asm("bsr %1, %0\n\t"
+		ASM_CMOVZ(2, 0)
+		: "=&r" (order) : "rm" (size), "rm" (0));
+	return order;
+}
+
+/* Pure 2^n version of get_order */
+static inline __attribute_const__  int get_order(unsigned long size)
+{
+	int order;
+
+	if (__builtin_constant_p(size)) {
+		size = (size - 1) >> (PAGE_SHIFT - 1);
+		order = -1;
+		do {
+			size >>= 1;
+			order++;
+		} while (size);
+		return order;
+	}
+	return __get_order(size);
+}
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* __ASM_GENERIC_GETORDER_H */
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 8ca8283..10e4c45 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -63,7 +63,7 @@ extern bool __virt_addr_valid(unsigned long kaddr);
 #endif	/* __ASSEMBLY__ */
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/getorder.h>
+#include <asm/getorder.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
 
-- 
1.7.2.3

