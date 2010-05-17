Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab0EQW6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:58:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0EQW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:58:23 -0400
Date: Mon, 17 May 2010 22:57:36 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com,
       borislav.petkov@amd.com
In-Reply-To: <alpine.LFD.2.00.1005171443060.4195@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005171443060.4195@i5.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/hweight] x86, hweight: Use a 32-bit popcnt for __arch_hweight32()
Message-ID: <tip-c59bd5688299cddb71183e156e7a3c1409b90df2@git.kernel.org>
Git-Commit-ID: c59bd5688299cddb71183e156e7a3c1409b90df2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 17 May 2010 22:57:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c59bd5688299cddb71183e156e7a3c1409b90df2
Gitweb:     http://git.kernel.org/tip/c59bd5688299cddb71183e156e7a3c1409b90df2
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 17 May 2010 15:13:23 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 17 May 2010 15:17:16 -0700

x86, hweight: Use a 32-bit popcnt for __arch_hweight32()

Use a 32-bit popcnt instruction for __arch_hweight32(), even on
x86-64.  Even though the input register will *usually* be
zero-extended due to the standard operation of the hardware, it isn't
necessarily so if the input value was the result of truncating a
64-bit operation.

Note: the POPCNT32 variant used on x86-64 has a technically
unnecessary REX prefix to make it five bytes long, the same as a CALL
instruction, therefore avoiding an unnecessary NOP.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <alpine.LFD.2.00.1005171443060.4195@i5.linux-foundation.org>
---
 arch/x86/include/asm/arch_hweight.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/arch_hweight.h b/arch/x86/include/asm/arch_hweight.h
index d1fc3c2..9686c3d 100644
--- a/arch/x86/include/asm/arch_hweight.h
+++ b/arch/x86/include/asm/arch_hweight.h
@@ -2,13 +2,15 @@
 #define _ASM_X86_HWEIGHT_H
 
 #ifdef CONFIG_64BIT
+/* popcnt %edi, %eax -- redundant REX prefix for alignment */
+#define POPCNT32 ".byte 0xf3,0x40,0x0f,0xb8,0xc7"
 /* popcnt %rdi, %rax */
-#define POPCNT ".byte 0xf3,0x48,0x0f,0xb8,0xc7"
+#define POPCNT64 ".byte 0xf3,0x48,0x0f,0xb8,0xc7"
 #define REG_IN "D"
 #define REG_OUT "a"
 #else
 /* popcnt %eax, %eax */
-#define POPCNT ".byte 0xf3,0x0f,0xb8,0xc0"
+#define POPCNT32 ".byte 0xf3,0x0f,0xb8,0xc0"
 #define REG_IN "a"
 #define REG_OUT "a"
 #endif
@@ -23,7 +25,7 @@ static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res = 0;
 
-	asm (ALTERNATIVE("call __sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
+	asm (ALTERNATIVE("call __sw_hweight32", POPCNT32, X86_FEATURE_POPCNT)
 		     : "="REG_OUT (res)
 		     : REG_IN (w));
 
@@ -48,7 +50,7 @@ static inline unsigned long __arch_hweight64(__u64 w)
 	return  __arch_hweight32((u32)w) +
 		__arch_hweight32((u32)(w >> 32));
 #else
-	asm (ALTERNATIVE("call __sw_hweight64", POPCNT, X86_FEATURE_POPCNT)
+	asm (ALTERNATIVE("call __sw_hweight64", POPCNT64, X86_FEATURE_POPCNT)
 		     : "="REG_OUT (res)
 		     : REG_IN (w));
 #endif /* CONFIG_X86_32 */
