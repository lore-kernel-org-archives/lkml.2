Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0FIKSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:18:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:36447 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab0FIKSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:18:50 -0400
Date: Wed, 9 Jun 2010 10:18:20 GMT
From: tip-bot for Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org,
       tglx@linutronix.de, mingo@elte.hu, mikey@neuling.org
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       benh@kernel.crashing.org, tglx@linutronix.de, mingo@elte.hu,
       mikey@neuling.org
In-Reply-To: <20100608045702.31FB5CC8C7@localhost.localdomain>
References: <20100608045702.31FB5CC8C7@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] powerpc: Enable asymmetric SMT scheduling on POWER7
Message-ID: <tip-76cbd8a8f8b0dddbff89a6708bd5bd13c0d21a00@git.kernel.org>
Git-Commit-ID: 76cbd8a8f8b0dddbff89a6708bd5bd13c0d21a00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:18:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76cbd8a8f8b0dddbff89a6708bd5bd13c0d21a00
Gitweb:     http://git.kernel.org/tip/76cbd8a8f8b0dddbff89a6708bd5bd13c0d21a00
Author:     Michael Neuling <mikey@neuling.org>
AuthorDate: Tue, 8 Jun 2010 14:57:02 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:13:14 +0200

powerpc: Enable asymmetric SMT scheduling on POWER7

The POWER7 core has dynamic SMT mode switching which is controlled by
the hypervisor.  There are 3 SMT modes:
	SMT1 uses thread  0
	SMT2 uses threads 0 & 1
	SMT4 uses threads 0, 1, 2 & 3
When in any particular SMT mode, all threads have the same performance
as each other (ie. at any moment in time, all threads perform the same).

The SMT mode switching works such that when linux has threads 2 & 3 idle
and 0 & 1 active, it will cede (H_CEDE hypercall) threads 2 and 3 in the
idle loop and the hypervisor will automatically switch to SMT2 for that
core (independent of other cores).  The opposite is not true, so if
threads 0 & 1 are idle and 2 & 3 are active, we will stay in SMT4 mode.

Similarly if thread 0 is active and threads 1, 2 & 3 are idle, we'll go
into SMT1 mode.

If we can get the core into a lower SMT mode (SMT1 is best), the threads
will perform better (since they share less core resources).  Hence when
we have idle threads, we want them to be the higher ones.

This adds a feature bit for asymmetric packing to powerpc and then
enables it on POWER7.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
LKML-Reference: <20100608045702.31FB5CC8C7@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/include/asm/cputable.h |    3 ++-
 arch/powerpc/kernel/process.c       |    9 +++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index b0b2113..4b611ca 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -197,6 +197,7 @@ extern const char *powerpc_base_platform;
 #define CPU_FTR_SAO			LONG_ASM_CONST(0x0020000000000000)
 #define CPU_FTR_CP_USE_DCBTZ		LONG_ASM_CONST(0x0040000000000000)
 #define CPU_FTR_UNALIGNED_LD_STD	LONG_ASM_CONST(0x0080000000000000)
+#define CPU_FTR_ASYM_SMT		LONG_ASM_CONST(0x0100000000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -412,7 +413,7 @@ extern const char *powerpc_base_platform;
 	    CPU_FTR_MMCRA | CPU_FTR_SMT | \
 	    CPU_FTR_COHERENT_ICACHE | CPU_FTR_LOCKLESS_TLBIE | \
 	    CPU_FTR_PURR | CPU_FTR_SPURR | CPU_FTR_REAL_LE | \
-	    CPU_FTR_DSCR | CPU_FTR_SAO)
+	    CPU_FTR_DSCR | CPU_FTR_SAO  | CPU_FTR_ASYM_SMT)
 #define CPU_FTRS_CELL	(CPU_FTR_USE_TB | CPU_FTR_LWSYNC | \
 	    CPU_FTR_PPCAS_ARCH_V2 | CPU_FTR_CTRL | \
 	    CPU_FTR_ALTIVEC_COMP | CPU_FTR_MMCRA | CPU_FTR_SMT | \
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 9d255b4..a3f347c 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1268,3 +1268,12 @@ unsigned long randomize_et_dyn(unsigned long base)
 
 	return ret;
 }
+
+int arch_sd_sibiling_asym_packing(void)
+{
+	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
+		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
+		return SD_ASYM_PACKING;
+	}
+	return 0;
+}
