Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab2IJMi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:38:26 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37967 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab2IJMiX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 08:38:23 -0400
Message-Id: <504DFB5B020000780009A327@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 13:38:19 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] x86/xor: improve XMM register spill/fill
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provided a new enough gcc is in use, we can avoid using the potentially
much slower MOVUPS by making sure stack frame and spilled to variables
are suitably aligned.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/xor.h |   56 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 16 deletions(-)

--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor.h
@@ -36,16 +36,37 @@
  * no advantages to be gotten from x86-64 here anyways.
  */
 
+#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4)
+# ifdef CONFIG_X86_32
+#  define XOR_ALIGN_STACK __attribute__((force_align_arg_pointer))
+#  define XOR_ALIGN 16
+# else
+/*
+ * By forcing the alignment beyond the default of 16 bytes, we make the
+ * compiler guarantee the alignment. Passing -mincoming-stack-boundary=3
+ * (which would have been the better global alternative, as the kernel
+ * never guarantees better stack alignment) isn't permitted on x86-64.
+ */
+#  define XOR_ALIGN_STACK
+#  define XOR_ALIGN 32
+# endif
+# define XOR_MOV "movaps"
+#else
+# define XOR_ALIGN_STACK
+# define XOR_ALIGN 16
+# define XOR_MOV "movups"
+#endif
+
 #define XMMS_SAVE				\
 do {						\
 	preempt_disable();			\
 	cr0 = read_cr0();			\
 	clts();					\
 	asm volatile(				\
-		"movups %%xmm0,(%0)	;\n\t"	\
-		"movups %%xmm1,0x10(%0)	;\n\t"	\
-		"movups %%xmm2,0x20(%0)	;\n\t"	\
-		"movups %%xmm3,0x30(%0)	;\n\t"	\
+		XOR_MOV " %%xmm0,(%0)	;\n\t"	\
+		XOR_MOV " %%xmm1,0x10(%0);\n\t"	\
+		XOR_MOV " %%xmm2,0x20(%0);\n\t"	\
+		XOR_MOV " %%xmm3,0x30(%0);\n\t"	\
 		:				\
 		: "r" (xmm_save) 		\
 		: "memory");			\
@@ -55,10 +76,10 @@ do {						\
 do {						\
 	asm volatile(				\
 		"sfence			;\n\t"	\
-		"movups (%0),%%xmm0	;\n\t"	\
-		"movups 0x10(%0),%%xmm1	;\n\t"	\
-		"movups 0x20(%0),%%xmm2	;\n\t"	\
-		"movups 0x30(%0),%%xmm3	;\n\t"	\
+		XOR_MOV " (%0),%%xmm0	;\n\t"	\
+		XOR_MOV " 0x10(%0),%%xmm1;\n\t"	\
+		XOR_MOV " 0x20(%0),%%xmm2;\n\t"	\
+		XOR_MOV " 0x30(%0),%%xmm3;\n\t"	\
 		:				\
 		: "r" (xmm_save)		\
 		: "memory");			\
@@ -87,11 +108,11 @@ do {						\
 #define XO3(x, y)	"	xorps "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
 #define XO4(x, y)	"	xorps "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
 
-static void
+static void XOR_ALIGN_STACK
 xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 {
 	unsigned long cr0, lines = bytes >> 8;
-	char xmm_save[16*4] __aligned(16);
+	char xmm_save[16*4] __aligned(XOR_ALIGN);
 
 	XMMS_SAVE;
 
@@ -139,12 +160,12 @@ xor_sse_2(unsigned long bytes, unsigned
 	XMMS_RESTORE;
 }
 
-static void
+static void XOR_ALIGN_STACK
 xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3)
 {
 	unsigned long cr0, lines = bytes >> 8;
-	char xmm_save[16*4] __aligned(16);
+	char xmm_save[16*4] __aligned(XOR_ALIGN);
 
 	XMMS_SAVE;
 
@@ -199,12 +220,12 @@ xor_sse_3(unsigned long bytes, unsigned
 	XMMS_RESTORE;
 }
 
-static void
+static void XOR_ALIGN_STACK
 xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
 	unsigned long cr0, lines = bytes >> 8;
-	char xmm_save[16*4] __aligned(16);
+	char xmm_save[16*4] __aligned(XOR_ALIGN);
 
 	XMMS_SAVE;
 
@@ -266,12 +287,12 @@ xor_sse_4(unsigned long bytes, unsigned
 	XMMS_RESTORE;
 }
 
-static void
+static void XOR_ALIGN_STACK
 xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
 	unsigned long cr0, lines = bytes >> 8;
-	char xmm_save[16*4] __aligned(16);
+	char xmm_save[16*4] __aligned(XOR_ALIGN);
 
 	XMMS_SAVE;
 
@@ -348,6 +369,9 @@ xor_sse_5(unsigned long bytes, unsigned
 #undef ST
 #undef BLOCK
 
+#undef XOR_ALIGN_STACK
+#undef XOR_ALIGN
+#undef XOR_MOV
 #undef XOR_CONSTANT_CONSTRAINT
 
 #ifdef CONFIG_X86_32



