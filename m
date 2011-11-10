Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab1KJAJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:09:11 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43596
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933416Ab1KJAJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:09:08 -0500
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
Subject: [RFC PATCH 14/17] powerpc/e500: Don't make kgdb use e500v1/e500v2 registers on e500mc
Date: Wed,  9 Nov 2011 19:07:12 -0500
Message-Id: <1320883635-17194-15-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only systems which need the sparse PowerPC register map are the
e500v1/e500v2.

NOTE: The kgdb code does not otherwise use CONFIG_E500, so this support
is probably still buggy on e500v1/e500v2, but I don't know kgdb enough
to fix it.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/include/asm/kgdb.h |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kgdb.h b/arch/powerpc/include/asm/kgdb.h
index 9db24e7..4dea066 100644
--- a/arch/powerpc/include/asm/kgdb.h
+++ b/arch/powerpc/include/asm/kgdb.h
@@ -46,14 +46,17 @@ static inline void arch_kgdb_breakpoint(void)
 #define NUMREGBYTES		((68 * 8) + (3 * 4))
 #define NUMCRITREGBYTES		184
 #else /* CONFIG_PPC32 */
-/* On non-E500 family PPC32 we determine the size by picking the last
- * register we need, but on E500 we skip sections so we list what we
- * need to store, and add it up. */
-#ifndef CONFIG_E500
-#define MAXREG			(PT_FPSCR+1)
-#else
+/*
+ * On FreeScale e500v1 or e500v2 processors we need to skip some register
+ * sections, so just add up a list of what we need to store.
+ *
+ * On all other 32-bit PowerPC we can just pick the last needed register.
+ */
+#ifdef CONFIG_FSL_E500_V1_V2
 /* 32 GPRs (8 bytes), nip, msr, ccr, link, ctr, xer, acc (8 bytes), spefscr*/
-#define MAXREG                 ((32*2)+6+2+1)
+#define MAXREG			((32*2)+6+2+1)
+#else
+#define MAXREG			(PT_FPSCR+1)
 #endif
 #define NUMREGBYTES		(MAXREG * sizeof(int))
 /* CR/LR, R1, R2, R13-R31 inclusive. */
-- 
1.7.2.5

