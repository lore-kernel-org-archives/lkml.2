Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0KRTWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:22:24 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42587 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab0KRTWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:22:22 -0500
X-Sieve: CMU Sieve 2.3
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479,TW_LW=0.077,
	TW_PL=0.077
X-Spam-TokenSummary: Bayes not run.
X-Spam-Relay-Country: 
From: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Sonny Rao <sonnyrao@linux.vnet.ibm.com>, Milton Miller <miltonm@bga.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Powerpc: separate CONFIG_RELOCATABLE from CONFIG_CRASHDUMP in
 boot code
Date: Thu, 18 Nov 2010 04:35:07 -0600
Message-Id: <1290076507-3181-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
X-Xagent-From: sonnyrao@linux.vnet.ibm.com
X-Xagent-To: sonnyrao@linux.vnet.ibm.com
X-Xagent-Gateway: uk1vsc.vnet.ibm.com (XAGENTU at UK1VSC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix head_64.S so that we can build a relocatable kernel
that isn't necessarily a crash-dump kernel

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/head_64.S |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index f0dd577..53b098f 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -96,7 +96,7 @@ __secondary_hold_acknowledge:
 	.llong hvReleaseData-KERNELBASE
 #endif /* CONFIG_PPC_ISERIES */

-#ifdef CONFIG_CRASH_DUMP
+#ifdef CONFIG_RELOCATABLE
 	/* This flag is set to 1 by a loader if the kernel should run
 	 * at the loaded address instead of the linked address.  This
 	 * is used by kexec-tools to keep the the kdump kernel in the
@@ -384,12 +384,10 @@ _STATIC(__after_prom_start)
 	/* process relocations for the final address of the kernel */
 	lis	r25,PAGE_OFFSET@highest	/* compute virtual base of kernel */
 	sldi	r25,r25,32
-#ifdef CONFIG_CRASH_DUMP
 	lwz	r7,__run_at_load-_stext(r26)
-	cmplwi	cr0,r7,1	/* kdump kernel ? - stay where we are */
+	cmplwi	cr0,r7,1	/* flagged to stay where we are ? */
 	bne	1f
 	add	r25,r25,r26
-#endif
 1:	mr	r3,r25
 	bl	.relocate
 #endif
-- 
1.5.6.5

