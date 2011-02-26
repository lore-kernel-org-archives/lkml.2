Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1BZRy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 12:54:26 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53468 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1BZRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 12:54:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EwwRKbyvNH60jzT0QZnrfPBXZPOBosSYvfhltMexq86X+GXv0K42iT0SCz0kFrwEEv
         ITVwJ7OT4vmEIIJfSoI46+nR5e80SLoJYCXzIQGM1vDa8kGvZVmkexn6/o8rwT7wWhyd
         dm67+WnmbhiClObTPV+pVSz148zALM7nMsWcM=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86, boot: merge memcpy()
Date: Sat, 26 Feb 2011 12:54:04 -0500
Message-Id: <1298742844-8256-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
References: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge the 32-bit and 64-bit memcpy functions.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/boot/compressed/misc.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index c13b5e9..704bec1 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -10,6 +10,7 @@
  */
 
 #include "misc.h"
+#include <asm/asm.h>
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
@@ -227,35 +228,21 @@ void *memset(void *s, int c, size_t n)
 		ss[i] = c;
 	return s;
 }
-#ifdef CONFIG_X86_32
-void *memcpy(void *dest, const void *src, size_t n)
-{
-	int d0, d1, d2;
-	asm volatile(
-		"rep ; movsl\n\t"
-		"movl %4,%%ecx\n\t"
-		"rep ; movsb\n\t"
-		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		: "0" (n >> 2), "g" (n & 3), "1" (dest), "2" (src)
-		: "memory");
 
-	return dest;
-}
-#else
 void *memcpy(void *dest, const void *src, size_t n)
 {
 	long d0, d1, d2;
 	asm volatile(
-		"rep ; movsq\n\t"
-		"movq %4,%%rcx\n\t"
+		"rep ; " __ASM_SIZE(movs) "\n\t"
+		"mov %4,%0\n\t"
 		"rep ; movsb\n\t"
 		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		: "0" (n >> 3), "g" (n & 7), "1" (dest), "2" (src)
+		: "0" (n / sizeof(long)), "g" (n & (sizeof(long) - 1)),
+		  "1" (dest), "2" (src)
 		: "memory");
 
 	return dest;
 }
-#endif
 
 static void error(char *x)
 {
-- 
1.7.4

