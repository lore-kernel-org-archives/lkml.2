Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0IZJQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:16:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:41394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0IZJQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:16:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,238,1283756400"; 
   d="scan'208";a="558051256"
From: yakui.zhao@intel.com
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>
Subject: [PATCH] X86/Mem: Use string copy operation to optimze copy in kernel compression
Date: Sun, 26 Sep 2010 17:12:01 +0800
Message-Id: <1285492321-14606-1-git-send-email-yakui.zhao@intel.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

It will parse the elf and then copy them to the corresponding destination after
the kernel decompression is finished. And now it uses the slow byte-copy mode.
How about using the string copy operation to accelerate the copy speed in
course of kernel compression?(It is orignated from the arch/x86/lib/memcpy_32.c)

In the test the copy performance can be improved very significantly after using
the string copy operation mechanism.
        1. The copy time can be reduced from 150ms to 20ms on one atom machine
	2. The copy time can be reduced about 80% on another machine
		The time is reduced from 7ms to 1.5ms when using 32-bit kernel.
		The time is reduced from 10ms to 2ms when using 64-bit kernel.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
---
 arch/x86/boot/compressed/misc.c |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8f7bef8..34793ae 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -229,18 +229,41 @@ void *memset(void *s, int c, size_t n)
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
+	int d0, d1, d2;
+	asm volatile(
+		"rep ; movsl\n\t"
+		"movl %4,%%ecx\n\t"
+		"andl $3,%%ecx\n\t"
+		"jz 1f\n\t"
+		"rep ; movsb\n\t"
+		"1:"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n / 4), "g" (n), "1" ((long)dest), "2" ((long)src)
+		: "memory");
 
-	for (i = 0; i < n; i++)
-		d[i] = s[i];
 	return dest;
 }
+#else
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	long d0, d1, d2;
+	asm volatile(
+		"rep ; movsq\n\t"
+		"movq %4,%%rcx\n\t"
+		"andq $7,%%rcx\n\t"
+		"jz 1f\n\t"
+		"rep ; movsb\n\t"
+		"1:"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n / 8), "g" (n), "1" ((long)dest), "2" ((long)src)
+		: "memory");
 
+	return dest;
+}
+#endif
 
 static void error(char *x)
 {
-- 
1.5.4.5

