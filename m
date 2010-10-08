Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0JHFkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:40:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:55335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab0JHFkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:40:42 -0400
Date: Fri, 8 Oct 2010 05:40:23 GMT
From: tip-bot for Zhao Yakui <yakui.zhao@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yakui.zhao@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yakui.zhao@intel.com, tglx@linutronix.de
In-Reply-To: <1286502453-7043-1-git-send-email-yakui.zhao@intel.com>
References: <1286502453-7043-1-git-send-email-yakui.zhao@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, setup: Use string copy operation to optimze copy in kernel compression
Message-ID: <tip-68f4d5a00adaab33b136fce2c72d5c377b39b0b0@git.kernel.org>
Git-Commit-ID: 68f4d5a00adaab33b136fce2c72d5c377b39b0b0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Oct 2010 05:40:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68f4d5a00adaab33b136fce2c72d5c377b39b0b0
Gitweb:     http://git.kernel.org/tip/68f4d5a00adaab33b136fce2c72d5c377b39b0b0
Author:     Zhao Yakui <yakui.zhao@intel.com>
AuthorDate: Fri, 8 Oct 2010 09:47:33 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Oct 2010 21:23:09 -0700

x86, setup: Use string copy operation to optimze copy in kernel compression

The kernel decompression code parses the ELF header and then copies
the segment to the corresponding destination.  Currently it uses slow
byte-copy code.  This patch makes it use the string copy operations
instead.

In the test the copy performance can be improved very significantly after using
the string copy operation mechanism.
        1. The copy time can be reduced from 150ms to 20ms on one Atom machine
	2. The copy time can be reduced about 80% on another machine
		The time is reduced from 7ms to 1.5ms when using 32-bit kernel.
		The time is reduced from 10ms to 2ms when using 64-bit kernel.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
LKML-Reference: <1286502453-7043-1-git-send-email-yakui.zhao@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/misc.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8f7bef8..23f315c 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -229,18 +229,35 @@ void *memset(void *s, int c, size_t n)
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
+		"rep ; movsb\n\t"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n >> 2), "g" (n & 3), "1" (dest), "2" (src)
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
+		"rep ; movsb\n\t"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n >> 3), "g" (n & 7), "1" (dest), "2" (src)
+		: "memory");
 
+	return dest;
+}
+#endif
 
 static void error(char *x)
 {
