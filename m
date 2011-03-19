Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1CSQGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 12:06:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48282 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1CSQGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 12:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YVAIHwjlZp0ESvBbbQMbGnTJ5uesB0WbgNP5mLqUYnj31GBJmMZ3GH85/hi7OuYep/
         yHxO7us6A7A0Bta76Ltjq+NZuUtur5tu6nxqMadHEGTQJd0pMhMjodvPQgfM/P+TLU2E
         LFWtmucBjhmtIAsOYDYq/LqkHuAM/fDVAyvY0=
From: Maksym Planeta <mcsim.planeta@gmail.com>
To: tglx@linutronix.de
Cc: kernel-janitors@vger.kernel.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, Maksym Planeta <mcsim.planeta@gmail.com>
Subject: [PATCH] x86: page: get_order() optimization
Date: Sat, 19 Mar 2011 18:08:01 +0200
Message-Id: <1300550881-22091-1-git-send-email-mcsim.planeta@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86 architecture get_order function can be optimized due to
assembler instruction bsr.
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

