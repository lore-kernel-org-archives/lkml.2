Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2KQAZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:25:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2KQAZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:25:21 -0500
Date: Fri, 16 Nov 2012 16:24:49 -0800
From: tip-bot for Alexander Duyck <alexander.h.duyck@intel.com>
Message-ID: <tip-bf4010fcf8f241a81693556b5abb48d9dbc33f97@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alexander.h.duyck@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alexander.h.duyck@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20121116215356.8521.92472.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116215356.8521.92472.stgit@ahduyck-cp1.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86:
  Make it so that __pa_symbol can only process kernel symbols on x86_64
Git-Commit-ID: bf4010fcf8f241a81693556b5abb48d9dbc33f97
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Nov 2012 16:25:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf4010fcf8f241a81693556b5abb48d9dbc33f97
Gitweb:     http://git.kernel.org/tip/bf4010fcf8f241a81693556b5abb48d9dbc33f97
Author:     Alexander Duyck <alexander.h.duyck@intel.com>
AuthorDate: Fri, 16 Nov 2012 13:55:46 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Nov 2012 15:20:25 -0800

x86: Make it so that __pa_symbol can only process kernel symbols on x86_64

I submitted an earlier patch that make __phys_addr an inline.  This obviously
results in an increase in the code size.  One step I can take to reduce that
is to make it so that the __pa_symbol call does a direct translation for
kernel addresses instead of covering all of virtual memory.

On my system this reduced the size for __pa_symbol from 5 instructions
totalling 30 bytes to 3 instructions totalling 16 bytes.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Link: http://lkml.kernel.org/r/20121116215356.8521.92472.stgit@ahduyck-cp1.jf.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page.h    |  3 ++-
 arch/x86/include/asm/page_32.h |  1 +
 arch/x86/include/asm/page_64.h |  3 +++
 arch/x86/mm/physaddr.c         | 11 +++++++++++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 8ca8283..3698a6a 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -44,7 +44,8 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
  * case properly. Once all supported versions of gcc understand it, we can
  * remove this Voodoo magic stuff. (i.e. once gcc3.x is deprecated)
  */
-#define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
+#define __pa_symbol(x) \
+	__phys_addr_symbol(__phys_reloc_hide((unsigned long)(x)))
 
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
 
diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index da4e762..4d550d0 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -15,6 +15,7 @@ extern unsigned long __phys_addr(unsigned long);
 #else
 #define __phys_addr(x)		__phys_addr_nodebug(x)
 #endif
+#define __phys_addr_symbol(x)	__phys_addr(x)
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
 #ifdef CONFIG_FLATMEM
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 5138174..0f1ddee 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -21,8 +21,11 @@ static inline unsigned long __phys_addr_nodebug(unsigned long x)
 
 #ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
+extern unsigned long __phys_addr_symbol(unsigned long);
 #else
 #define __phys_addr(x)		__phys_addr_nodebug(x)
+#define __phys_addr_symbol(x) \
+	((unsigned long)(x) - __START_KERNEL_map + phys_base)
 #endif
 
 #define __phys_reloc_hide(x)	(x)
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
index fd40d75..c73fedd 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -28,6 +28,17 @@ unsigned long __phys_addr(unsigned long x)
 	return x;
 }
 EXPORT_SYMBOL(__phys_addr);
+
+unsigned long __phys_addr_symbol(unsigned long x)
+{
+	unsigned long y = x - __START_KERNEL_map;
+
+	/* only check upper bounds since lower bounds will trigger carry */
+	VIRTUAL_BUG_ON(y >= KERNEL_IMAGE_SIZE);
+
+	return y + phys_base;
+}
+EXPORT_SYMBOL(__phys_addr_symbol);
 #endif
 
 bool __virt_addr_valid(unsigned long x)
