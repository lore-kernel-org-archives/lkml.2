Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab1KJAIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:08:53 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43518
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933462Ab1KJAIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:08:49 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [RFC PATCH 08/17] powerpc/e500: Remove conditional "lwsync" substitution
Date: Wed,  9 Nov 2011 19:07:06 -0500
Message-Id: <1320883635-17194-9-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As FreeScale e500 systems have different cacheline sizes from e500mc, it
is basically impossible for the kernel to support both in a single
system image at present.

Given that one is SPE-float and the other is classic-float, they are not
generally userspace-compatible either.

This patch updates the conditional to depend on whether the system is
actually targetting an "e500" or "e500mc" core and entirely removes the
unused sync-to-lwsync-replacement on e500v1/e500v2 systems.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/include/asm/synch.h |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/synch.h b/arch/powerpc/include/asm/synch.h
index d7cab44..3d518b6 100644
--- a/arch/powerpc/include/asm/synch.h
+++ b/arch/powerpc/include/asm/synch.h
@@ -5,8 +5,11 @@
 #include <linux/stringify.h>
 #include <asm/feature-fixups.h>
 
-#if defined(__powerpc64__) || defined(CONFIG_PPC_E500MC)
+#if defined(__powerpc64__) || defined(CONFIG_FSL_E500MC)
 #define __SUBARCH_HAS_LWSYNC
+#define LWSYNC lwsync
+#else
+#define LWSYNC sync
 #endif
 
 #ifndef __ASSEMBLY__
@@ -25,17 +28,6 @@ static inline void isync(void)
 }
 #endif /* __ASSEMBLY__ */
 
-#if defined(__powerpc64__)
-#    define LWSYNC	lwsync
-#elif defined(CONFIG_E500)
-#    define LWSYNC					\
-	START_LWSYNC_SECTION(96);			\
-	sync;						\
-	MAKE_LWSYNC_SECTION_ENTRY(96, __lwsync_fixup);
-#else
-#    define LWSYNC	sync
-#endif
-
 #ifdef CONFIG_SMP
 #define __PPC_ACQUIRE_BARRIER				\
 	START_LWSYNC_SECTION(97);			\
-- 
1.7.2.5

