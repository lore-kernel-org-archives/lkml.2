Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1ERVZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:25:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56277 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1ERVZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OfsCHcJ3rAAtFNicCMoqFp5Blrx6EnTMtT/5buyNiMhaaWmglDuE9FczNN42cXYQXq
         OOZhYPzSG+SIcpfu5A9UGNBTD+9D0sBZctHS+2HICKRblDSUxUU9lLcrWl6kS6QtpPdE
         tEu5cpQTHyNxiWQfI3UkhOJ6fuCCKF4bG1PZ8=
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, bg-linux@lists.anl-external.org,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 3/7] [RFC] add support for BlueGene/P FPU
Date: Wed, 18 May 2011 16:24:51 -0500
Message-Id: <1305753895-24845-3-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds save/restore register support for the BlueGene/P
double hummer FPU.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 arch/powerpc/include/asm/ppc_asm.h |   39 ++++++++++++++++++++++++-----------
 arch/powerpc/kernel/fpu.S          |    8 +++---
 arch/powerpc/platforms/44x/Kconfig |    9 ++++++++
 3 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 9821006..daa22bb 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -88,6 +88,13 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_SPLPAR)
 				REST_10GPRS(22, base)
 #endif
 
+#ifdef CONFIG_BGP
+#define LFPDX(frt, ra, rb)	.long (31<<26)|((frt)<<21)|((ra)<<16)| \
+							((rb)<<11)|(462<<1)
+#define STFPDX(frt, ra, rb)	.long (31<<26)|((frt)<<21)|((ra)<<16)| \
+							((rb)<<11)|(974<<1)
+#endif /* CONFIG_BGP */
+
 #define SAVE_2GPRS(n, base)	SAVE_GPR(n, base); SAVE_GPR(n+1, base)
 #define SAVE_4GPRS(n, base)	SAVE_2GPRS(n, base); SAVE_2GPRS(n+2, base)
 #define SAVE_8GPRS(n, base)	SAVE_4GPRS(n, base); SAVE_4GPRS(n+4, base)
@@ -97,18 +104,26 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_SPLPAR)
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
+#ifdef CONFIG_BGP
+#define SAVE_FPR(n, b, base)	li b, THREAD_FPR0+(16*(n)); STFPDX(n, base, b)
+#define REST_FPR(n, b, base)	li b, THREAD_FPR0+(16*(n)); LFPDX(n, base, b)
+#else /* CONFIG_BGP */
+#define SAVE_FPR(n, b, base)	(stfd	n, THREAD_FPR0+8*TS_FPRWIDTH*(n)(base))
+#define REST_FPR(n, b, base)	(lfd	n, THREAD_FPR0+8*TS_FPRWIDTH*(n)(base))
+#endif /* CONFIG_BGP */
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
-- 
1.7.4.1

