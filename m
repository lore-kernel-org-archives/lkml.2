Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab0INHR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:17:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:57183 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab0INHRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:17:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,362,1280732400"; 
   d="scan'208";a="657053430"
From: yakui.zhao@intel.com
To: linux-kernel@vger.kernel.org
Cc: Zhao Yakui <yakui.zhao@intel.com>
Subject: [RFC PATCH] X86: Use string copy operation to optimze copy in kernel compression
Date: Tue, 14 Sep 2010 15:12:22 +0800
Message-Id: <1284448342-22982-1-git-send-email-yakui.zhao@intel.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

It will parse code from elf and then copy them to the corresponding destination
after the kernel decompression is finished. And now it uses the slow byte-copy
mode. How about using the string copy operation to accelerate the copy speed in
course of kernel compression?(It is orignated from the arch/x86/lib/memcpy_32.c)

In the test the copy performance can be improved very significantly after using
the string copy operation mechanism.
        1. The copy time can be reduced from 150ms to 20ms on one atom machine
	2. The copy time can be reduced about 80% on another machine
		The time is reduced from 7ms to 1.5ms when using 32-bit kernel.
		The time is reduced from 10ms to 2ms when using 64-bit kernel.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
---
 arch/x86/boot/compressed/misc.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8f7bef8..3b58b4b 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -229,18 +229,37 @@ void *memset(void *s, int c, size_t n)
 		ss[i] = c;
 	return s;
 }
-
+#ifdef CONFIG_X86_32
 void *memcpy(void *dest, const void *src, size_t n)
 {
-	int i;
-	const char *s = src;
-	char *d = dest;
-
-	for (i = 0; i < n; i++)
-		d[i] = s[i];
+	int d0, d1, d2;
+	asm volatile("rep ; movsl\n\t"
+		     "movl %4,%%ecx\n\t"
+		     "andl $3,%%ecx\n\t"
+		     "jz 1f\n\t"
+		     "rep ; movsb\n\t"
+		     "1:"
+		     : "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		     : "0" (n / 4), "g" (n), "1" ((long)dest), "2" ((long)src)
+		     : "memory");
 	return dest;
 }
-
+#else
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	long d0, d1, d2;
+	asm volatile("rep ; movsq\n\t"
+		     "movq %4,%%rcx\n\t"
+		     "andq $7,%%rcx\n\t"
+		     "jz 1f\n\t"
+		     "rep ; movsb\n\t"
+		     "1:"
+		     : "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		     : "0" (n / 8), "g" (n), "1" ((long)dest), "2" ((long)src)
+		     : "memory");
+	return dest;
+}
+#endif
 
 static void error(char *x)
 {
-- 
1.5.4.5

