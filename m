Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0KBApq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:45:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:46190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0KBApm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:45:42 -0400
Date: Tue, 2 Nov 2010 00:45:06 GMT
From: "tip-bot for Ma, Ling" <ling.ma@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ling.ma@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ling.ma@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <C10D3FB0CD45994C8A51FEC1227CE22F0E483AD86A@shsmsx502.ccr.corp.intel.com>
References: <C10D3FB0CD45994C8A51FEC1227CE22F0E483AD86A@shsmsx502.ccr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86, mem: Don't implement forward memmove() as memcpy()
Message-ID: <tip-fdf4289679fd41d76553ce224750e9737cd80eea@git.kernel.org>
Git-Commit-ID: fdf4289679fd41d76553ce224750e9737cd80eea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Nov 2010 00:45:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fdf4289679fd41d76553ce224750e9737cd80eea
Gitweb:     http://git.kernel.org/tip/fdf4289679fd41d76553ce224750e9737cd80eea
Author:     Ma, Ling <ling.ma@intel.com>
AuthorDate: Mon, 23 Aug 2010 14:11:12 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 23 Aug 2010 14:14:27 -0700

x86, mem: Don't implement forward memmove() as memcpy()

memmove() allow source and destination address to be overlap, but
there is no such limitation for memcpy().  Therefore, explicitly
implement memmove() in both the forwards and backward directions, to
give us the ability to optimize memcpy().

Signed-off-by: Ma Ling <ling.ma@intel.com>
LKML-Reference: <C10D3FB0CD45994C8A51FEC1227CE22F0E483AD86A@shsmsx502.ccr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
