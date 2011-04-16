Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1DPQwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:52:07 -0400
Received: from [69.28.251.93] ([69.28.251.93]:57418 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab1DPQvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:51:24 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] MIPS: Clean up protection_map[] initialization
Date: Sat, 16 Apr 2011 09:44:31 -0700
Message-Id: <305a554e4aa54669dfff53283de096eb@localhost>
In-Reply-To: <7aa38c32b7748a95e814e5bb0583f967@localhost>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines, factor out cut&paste flags, and add comments to explain
the pgprot flags used.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/cache.c |   42 +++++++++++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
index 7c251e6..edb003f 100644
--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -137,23 +137,31 @@ EXPORT_SYMBOL(_page_cachable_default);
 
 static inline void setup_protection_map(void)
 {
-	protection_map[0]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[1]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[2]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[3]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[4]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_READ);
-	protection_map[5]  = __pgprot(_page_cachable_default | _PAGE_PRESENT);
-	protection_map[6]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_READ);
-	protection_map[7]  = __pgprot(_page_cachable_default | _PAGE_PRESENT);
-
-	protection_map[8]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[9]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[10] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE | _PAGE_NO_READ);
-	protection_map[11] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE);
-	protection_map[12] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_READ);
-	protection_map[13] = __pgprot(_page_cachable_default | _PAGE_PRESENT);
-	protection_map[14] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_WRITE  | _PAGE_NO_READ);
-	protection_map[15] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_WRITE);
+	int i;
+	const unsigned long prot[] = {
+		/* private mappings (clear the dirty bit until written) */
+		[0]	= _PAGE_NO_EXEC | _PAGE_NO_READ,	/* --- */
+		[1]	= _PAGE_NO_EXEC,			/* r-- */
+		[2]	= _PAGE_NO_EXEC | _PAGE_NO_READ,	/* -w- */
+		[3]	= _PAGE_NO_EXEC,			/* rw- */
+		[4]	= _PAGE_NO_READ,			/* --x */
+		[5]	= 0,					/* r-x */
+		[6]	= _PAGE_NO_READ,			/* -wx */
+		[7]	= 0,					/* rwx */
+		/* shared mappings */
+		[8]	= _PAGE_NO_EXEC | _PAGE_NO_READ,	/* --- */
+		[9]	= _PAGE_NO_EXEC,			/* r-- */
+		[10]	= _PAGE_NO_EXEC | _PAGE_WRITE | _PAGE_NO_READ, /* -w- */
+		[11]	= _PAGE_NO_EXEC | _PAGE_WRITE,		/* rw- */
+		[12]	= _PAGE_NO_READ,			/* --x */
+		[13]	= 0,					/* r-x */
+		[14]	= _PAGE_WRITE | _PAGE_NO_READ,		/* -wx */
+		[15]	= _PAGE_WRITE,				/* rwx */
+	};
+
+	for (i = 0; i < ARRAY_SIZE(protection_map); i++)
+		protection_map[i] = __pgprot(_page_cachable_default |
+					     _PAGE_PRESENT | prot[i]);
 }
 
 void __cpuinit cpu_cache_init(void)
-- 
1.7.4.3

