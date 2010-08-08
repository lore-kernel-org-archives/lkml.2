Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0HHViP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 17:38:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59945 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab0HHViN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 17:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LWaOfBNEGCPZu+YROi3ec0YL71W8YCtOMZR+Gcuh4pRqiAaiCRzLtwp+GBW9soFHqZ
         gfFUs2OPVYs5SI1LAyBXc/OYpyJR4mm+Qmba11/6y9K9Zfbc2rI66S+et/3mgcNiH7zV
         YChyxwSg1Fviv+9XPaY9B0XtReoLhiVa5BaMI=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: remove __phys_reloc_hide
Date: Mon,  9 Aug 2010 06:38:10 +0900
Message-Id: <1281303490-390-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unnecessary use of RELOC_HIDE(). It only does simple addition of ptr
and offset, and in this case, offset 0, does nothing. It does NOT do anything
with linker relocation things. I could find no reason to use it.

The only user of __phys_reloc_hide() was __pa_symbol() so it can be removed
safely here.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/include/asm/page.h          |    5 ++---
 arch/x86/include/asm/page_32.h       |    1 -
 arch/x86/include/asm/page_64_types.h |    1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 625c3f0..3da2a8e 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -35,9 +35,8 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 
 #define __pa(x)		__phys_addr((unsigned long)(x))
 #define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
-/* __pa_symbol should be used for C visible symbols.
-   This seems to be the official gcc blessed way to do such arithmetic. */
-#define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
+/* __pa_symbol should be used for C visible symbols. */
+#define __pa_symbol(x)	__pa(x)
 
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
 
diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index da4e762..e78e52a 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -15,7 +15,6 @@ extern unsigned long __phys_addr(unsigned long);
 #else
 #define __phys_addr(x)		__phys_addr_nodebug(x)
 #endif
-#define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
 #ifdef CONFIG_FLATMEM
 #define pfn_valid(pfn)		((pfn) < max_mapnr)
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 7639dbf..5a63066 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -59,7 +59,6 @@ extern unsigned long max_pfn;
 extern unsigned long phys_base;
 
 extern unsigned long __phys_addr(unsigned long);
-#define __phys_reloc_hide(x)	(x)
 
 #define vmemmap ((struct page *)VMEMMAP_START)
 
-- 
1.7.0.4

