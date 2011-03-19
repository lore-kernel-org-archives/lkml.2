Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1CSQcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 12:32:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58111 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab1CSQcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 12:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vHT5vLMhyQkW4gqssLRWVbPkhFECWGPyfIe2o0bSBejD1nBFVZzg3R1Mj5s+yeYdEd
         w9m5BaCZha40YB98pS4HN8V8N1ok+/MgWEOpbOOe+HSKxB+0RjqIvuZBrAE0YgrATyol
         am4yzxT3EeApCM3wMlq3e/WU4p0A1Fh8vriOs=
From: Maksym Planeta <mcsim.planeta@gmail.com>
To: tglx@linutronix.de
Cc: kernel-janitors@vger.kernel.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, Maksym Planeta <mcsim.planeta@gmail.com>
Subject: [PATCH] x86: page: get_order() optimization
Date: Sat, 19 Mar 2011 18:25:47 +0200
Message-Id: <1300551947-22279-1-git-send-email-mcsim.planeta@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86 architecture get_order function can be optimized due to
assembler instruction bsr.

I'm sorry. I've forgot about Signed-off, so the same, but with the sign.

Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
---
 arch/x86/include/asm/page.h |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 8ca8283..339ae26 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -60,10 +60,28 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 extern bool __virt_addr_valid(unsigned long kaddr);
 #define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
 
+/* Pure 2^n version of get_order */
+static inline __attribute_const__ int get_order(unsigned long size)
+{
+	int order;
+
+	size = (size - 1) >> (PAGE_SHIFT - 1);
+#ifdef CONFIG_X86_CMOV
+	asm("bsr %1,%0\n\t"
+	    "cmovzl %2,%0"
+	    : "=&r" (order) : "rm" (size), "rm" (0));
+#else
+	asm("bsr %1,%0\n\t"
+	    "jnz 1f\n\t"
+	    "movl $0,%0\n"
+	    "1:" : "=r" (order) : "rm" (size));
+#endif
+	return order;
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/getorder.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
 
-- 
1.7.2.3

