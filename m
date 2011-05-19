Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874Ab1ESVlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:41:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56969 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194Ab1ESVle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eLZKcGtBM0sZ2t3pMlfCpri79ZCTeRrZ6IVfuDRN5R7jYzlQA6iVIHTMqDRkbIFN/U
         8DEs73aryrli7XBlQzqPeaHlIq2SJ1maZuFjYOV7slzT3J/vZWXy0Mvn/UIEGKbkr6ur
         3KaI1y9/4d/3DhbizwA+LwTtpu7sQnOYjlz1k=
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, bg-linux@lists.anl-external.org,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 3/7] [RFC][V2] add support for BlueGene/P Double FPU
Date: Thu, 19 May 2011 16:41:11 -0500
Message-Id: <1305841271-4879-1-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305753895-24845-3-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-3-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds save/restore register support for the BlueGene/P
double FPU.  Since there are two FPUs, we need to save and restore
twice the registers.  Fortunately BG/P gives us some opcodes to
assist with that task.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 arch/powerpc/include/asm/ppc-opcode.h  |    9 +++++++++
 arch/powerpc/include/asm/ppc_asm.h     |   32 ++++++++++++++++++++------------
 arch/powerpc/kernel/fpu.S              |    8 ++++----
 arch/powerpc/platforms/44x/Kconfig     |    9 +++++++++
 arch/powerpc/platforms/Kconfig.cputype |    4 ++++
 5 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index 1255569..12a3cc9 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -56,6 +56,9 @@
 #define PPC_INST_TLBSRX_DOT		0x7c0006a5
 #define PPC_INST_XXLOR			0xf0000510
 
+#define PPC_INST_LFPDX			0x7c00039c
+#define PPC_INST_STFPDX			0x7c00079c
+
 /* macros to insert fields into opcodes */
 #define __PPC_RA(a)	(((a) & 0x1f) << 16)
 #define __PPC_RB(b)	(((b) & 0x1f) << 11)
@@ -126,4 +129,10 @@
 #define XXLOR(t, a, b)		stringify_in_c(.long PPC_INST_XXLOR | \
 					       VSX_XX3((t), (a), (b)))
 
+#define LFPDX(t, a, b)		stringify_in_c(.long PPC_INST_LFPDX | \
+				    __PPC_RT(t) | __PPC_RA(a) | __PPC_RB(b)))
+#define STFPDX(t, a, b)		stringify_in_c(.long PPC_INST_STFPDX | \
+				    __PPC_RT(t) | __PPC_RA(a) | __PPC_RB(b)))
+
+
 #endif /* _ASM_POWERPC_PPC_OPCODE_H */
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 9821006..c5f05ad 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -97,18 +97,26 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_SPLPAR)
 #define REST_8GPRS(n, base)	REST_4GPRS(n, base); REST_4GPRS(n+4, base)
 #define REST_10GPRS(n, base)	REST_8GPRS(n, base); REST_2GPRS(n+8, base)
 
-#define SAVE_FPR(n, base)	stfd	n,THREAD_FPR0+8*TS_FPRWIDTH*(n)(base)
-#define SAVE_2FPRS(n, base)	SAVE_FPR(n, base); SAVE_FPR(n+1, base)
-#define SAVE_4FPRS(n, base)	SAVE_2FPRS(n, base); SAVE_2FPRS(n+2, base)
-#define SAVE_8FPRS(n, base)	SAVE_4FPRS(n, base); SAVE_4FPRS(n+4, base)
-#define SAVE_16FPRS(n, base)	SAVE_8FPRS(n, base); SAVE_8FPRS(n+8, base)
-#define SAVE_32FPRS(n, base)	SAVE_16FPRS(n, base); SAVE_16FPRS(n+16, base)
-#define REST_FPR(n, base)	lfd	n,THREAD_FPR0+8*TS_FPRWIDTH*(n)(base)
-#define REST_2FPRS(n, base)	REST_FPR(n, base); REST_FPR(n+1, base)
-#define REST_4FPRS(n, base)	REST_2FPRS(n, base); REST_2FPRS(n+2, base)
-#define REST_8FPRS(n, base)	REST_4FPRS(n, base); REST_4FPRS(n+4, base)
-#define REST_16FPRS(n, base)	REST_8FPRS(n, base); REST_8FPRS(n+8, base)
-#define REST_32FPRS(n, base)	REST_16FPRS(n, base); REST_16FPRS(n+16, base)
+#ifdef CONFIG_DOUBLE_FPU
+#define SAVE_FPR(n, b, base)	li b, THREAD_FPR0+(16*(n)); STFPDX(n, base, b)
+#define REST_FPR(n, b, base)	li b, THREAD_FPR0+(16*(n)); LFPDX(n, base, b)
+#else /* CONFIG_DOUBLE_FPU */
+#define SAVE_FPR(n, b, base)	stfd	n, THREAD_FPR0+8*TS_FPRWIDTH*(n)(base)
+#define REST_FPR(n, b, base)	lfd	n, THREAD_FPR0+8*TS_FPRWIDTH*(n)(base)
+#endif /* CONFIG_DOUBLE_FPU */
+
+#define SAVE_2FPRS(n, b, base)	SAVE_FPR(n, b, base); SAVE_FPR(n+1, b, base)
+#define SAVE_4FPRS(n, b, base)	SAVE_2FPRS(n, b, base); SAVE_2FPRS(n+2, b, base)
+#define SAVE_8FPRS(n, b, base)	SAVE_4FPRS(n, b, base); SAVE_4FPRS(n+4, b, base)
+#define SAVE_16FPRS(n, b, base)	SAVE_8FPRS(n, b, base); SAVE_8FPRS(n+8, b, base)
+#define SAVE_32FPRS(n, b, base)	SAVE_16FPRS(n, b, base); \
+				SAVE_16FPRS(n+16, b, base)
+#define REST_2FPRS(n, b, base)	REST_FPR(n, b, base); REST_FPR(n+1, b, base)
+#define REST_4FPRS(n, b, base)	REST_2FPRS(n, b, base); REST_2FPRS(n+2, b, base)
+#define REST_8FPRS(n, b, base)	REST_4FPRS(n, b, base); REST_4FPRS(n+4, b, base)
+#define REST_16FPRS(n, b, base)	REST_8FPRS(n, b, base); REST_8FPRS(n+8, b, base)
+#define REST_32FPRS(n, b, base)	REST_16FPRS(n, b, base); \
+				REST_16FPRS(n+16, b, base)
 
 #define SAVE_VR(n,b,base)	li b,THREAD_VR0+(16*(n));  stvx n,base,b
 #define SAVE_2VRS(n,b,base)	SAVE_VR(n,b,base); SAVE_VR(n+1,b,base)
diff --git a/arch/powerpc/kernel/fpu.S b/arch/powerpc/kernel/fpu.S
index de36955..9f11c66 100644
--- a/arch/powerpc/kernel/fpu.S
+++ b/arch/powerpc/kernel/fpu.S
@@ -30,7 +30,7 @@
 BEGIN_FTR_SECTION							\
 	b	2f;							\
 END_FTR_SECTION_IFSET(CPU_FTR_VSX);					\
-	REST_32FPRS(n,base);						\
+	REST_32FPRS(n,c,base);						\
 	b	3f;							\
 2:	REST_32VSRS(n,c,base);						\
 3:
@@ -39,13 +39,13 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX);					\
 BEGIN_FTR_SECTION							\
 	b	2f;							\
 END_FTR_SECTION_IFSET(CPU_FTR_VSX);					\
-	SAVE_32FPRS(n,base);						\
+	SAVE_32FPRS(n,c,base);						\
 	b	3f;							\
 2:	SAVE_32VSRS(n,c,base);						\
 3:
 #else
-#define REST_32FPVSRS(n,b,base)	REST_32FPRS(n, base)
-#define SAVE_32FPVSRS(n,b,base)	SAVE_32FPRS(n, base)
+#define REST_32FPVSRS(n,b,base)	REST_32FPRS(n,b,base)
+#define SAVE_32FPVSRS(n,b,base)	SAVE_32FPRS(n,b,base)
 #endif
 
 /*
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index f485fc5f..24a515e 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -169,6 +169,15 @@ config YOSEMITE
 	help
 	  This option enables support for the AMCC PPC440EP evaluation board.
 
+config	BGP
+	bool "Blue Gene/P"
+	depends on 44x
+	default n
+	select PPC_FPU
+	select PPC_DOUBLE_FPU
+	help
+	  This option enables support for the IBM BlueGene/P supercomputer.
+
 config ISS4xx
 	bool "ISS 4xx Simulator"
 	depends on (44x || 40x)
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 111138c..1ae59c5 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -137,6 +137,10 @@ config PPC_FPU
 	bool
 	default y if PPC64
 
+config PPC_DOUBLE_FPU
+	bool "Bluegene/P Double FPU Support"
+	depends on BGP
+
 config FSL_EMB_PERFMON
 	bool "Freescale Embedded Perfmon"
 	depends on E500 || PPC_83xx
-- 
1.7.4.1

