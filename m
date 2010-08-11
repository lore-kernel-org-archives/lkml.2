Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0HLFTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 01:19:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:26043 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab0HLFTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 01:19:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,356,1278313200"; 
   d="scan'208";a="646714558"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        root <root@glibc-nhm.localdomain>, Ma Ling <ling.ma@intel.com>
Subject: [PATCH V2] [X86] Fix potential issue on memmove
Date: Thu, 12 Aug 2010 06:20:34 +0800
Message-Id: <1281565234-3096-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@glibc-nhm.localdomain>

memmove allow source and destination address to be overlap, 
but no limitation for memcpy. So memmove use forward or
backward copy mode to handle src > dest and dest > src cases respectively.
However memcpy has not address overlap, it may use any copy mode
theoretically. Our original memmove will call memcpy and assume
it must use forward copy mode, otherwise the system will crash,
it is potential issue. The patch avoid assumption, meanwhile
re-active patch id a1e5278e40f16a4611264f8da9e557c16cb6f6ed,
which will use forward/backward copy mode according to offset address.

Signed-off-by: Ma Ling <ling.ma@intel.com>
---
In this version we try to keep and optimize original memmove.

 arch/x86/lib/memcpy_32.c  |   38 ++++++++++++++++++++++++++----------
 arch/x86/lib/memmove_64.c |   46 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 68 insertions(+), 16 deletions(-)

diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index 5415a9d..be424df 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -25,19 +25,35 @@ void *memmove(void *dest, const void *src, size_t n)
 	int d0, d1, d2;
 
 	if (dest < src) {
-		memcpy(dest, src, n);
+		if ((dest + n) < src)
+			 return memcpy(dest, src, n);
+		else
+			__asm__ __volatile__(
+				"rep\n\t"
+				"movsb\n\t"
+				: "=&c" (d0), "=&S" (d1), "=&D" (d2)
+				:"0" (n),
+				 "1" (src),
+				 "2" (dest)
+				:"memory");
+
 	} else {
-		__asm__ __volatile__(
-			"std\n\t"
-			"rep\n\t"
-			"movsb\n\t"
-			"cld"
-			: "=&c" (d0), "=&S" (d1), "=&D" (d2)
-			:"0" (n),
-			 "1" (n-1+src),
-			 "2" (n-1+dest)
-			:"memory");
+
+		if((src + count) < dest)
+			return memcpy(dest, src, count);
+		else
+			__asm__ __volatile__(
+				"std\n\t"
+				"rep\n\t"
+				"movsb\n\t"
+				"cld"
+				: "=&c" (d0), "=&S" (d1), "=&D" (d2)
+				:"0" (n),
+				 "1" (n-1+src),
+				 "2" (n-1+dest)
+				:"memory");
 	}
+
 	return dest;
 }
 EXPORT_SYMBOL(memmove);
diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 0a33909..ecacc4b 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -8,13 +8,49 @@
 #undef memmove
 void *memmove(void *dest, const void *src, size_t count)
 {
+	unsigned long d0, d1, d2, d3;
 	if (dest < src) {
-		return memcpy(dest, src, count);
+		if ((dest + count) < src)
+			 return memcpy(dest, src, count);
+		else
+			__asm__ __volatile__(
+				"movq %0, %3\n\t"
+				"shr $3, %0\n\t"
+				"andq $7, %3\n\t"
+				"rep\n\t"
+				"movsq\n\t"
+				"movq %3, %0\n\t"
+				"rep\n\t"
+				"movsb"
+				: "=&c" (d0), "=&S" (d1), "=&D" (d2), "=r" (d3)
+				:"0" (count),
+				 "1" (src),
+				 "2" (dest)
+				:"memory");
 	} else {
-		char *p = dest + count;
-		const char *s = src + count;
-		while (count--)
-			*--p = *--s;
+		if((src + count) < dest)
+			return memcpy(dest, src, count);
+		else
+			__asm__ __volatile__(
+				"movq %0, %3\n\t"
+				"lea -8(%1, %0), %1\n\t"
+				"lea -8(%2, %0), %2\n\t"
+				"shr $3, %0\n\t"
+				"andq $7, %3\n\t"
+				"std\n\t"
+				"rep\n\t"
+				"movsq\n\t"
+				"lea 7(%1), %1\n\t"
+				"lea 7(%2), %2\n\t"
+				"movq %3, %0\n\t"
+				"rep\n\t"
+				"movsb\n\t"
+				"cld"
+				: "=&c" (d0), "=&S" (d1), "=&D" (d2), "=r" (d3)
+				:"0" (count),
+				 "1" (src),
+				 "2" (dest)
+				:"memory");
 	}
 	return dest;
 }
-- 
1.6.5.2

