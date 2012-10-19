Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2JSFho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 01:37:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:26573 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab2JSFhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 01:37:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,610,1344236400"; 
   d="scan'208";a="229566056"
From: ling.ma.program@gmail.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        iant@google.com, Ma Ling <ling.ma.program@gmail.com>
Subject: [PATCH RFC] [x86] Optimize small size memcpy by avoding long latency from decode stage
Date: Fri, 19 Oct 2012 20:29:40 +0800
Message-Id: <1350649780-3276-1-git-send-email-ling.ma.program@gmail.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma.program@gmail.com>

CISC code has higher instruction density, saving memory and
improving i-cache hit rate. However decode become challenge,
only one mulitple-uops(2~3)instruction could be decoded in one cycle,
and instructions containing more 4 uops(rep movsq/b) have to be handled by MS-ROM,
the process take long time and eat up the advantage from it for small size. 

In order to avoid this disavantage, we take use of general instruction code
for small size copy. The result shows it can get 1~2x improvement
on Core2, Nehalem, Sandy Bridge, Ivy Bridge, Atom, and Bulldozer as well.

Signed-off-by: Ma Ling <ling.ma.program@gmail.com>
---
 arch/x86/lib/memcpy_64.S |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 1c273be..6a24c8c 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -5,7 +5,6 @@
 #include <asm/cpufeature.h>
 #include <asm/dwarf2.h>
 #include <asm/alternative-asm.h>
-
 /*
  * memcpy - Copy a memory block.
  *
@@ -19,6 +18,15 @@
  */
 
 /*
+ * memcpy_c() and memcpy_c_e() use rep movsq/movsb respectively,
+ * the instruction have to get micro ops from Microcode Sequencser Rom.
+ * And the decode  process take long latency, in order to avoid it, 
+ * we choose loop unrolling routine for small size.
+ * Could vary the warm up  distance.
+ */
+
+
+/*
  * memcpy_c() - fast string ops (REP MOVSQ) based variant.
  *
  * This gets patched over the unrolled variant (below) via the
@@ -26,6 +34,8 @@
  */
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemcpy_c:
+	cmpq $512, %rdx
+	jbe  memcpy 	
 	movq %rdi, %rax
 	movq %rdx, %rcx
 	shrq $3, %rcx
@@ -46,6 +56,8 @@
  */
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemcpy_c_e:
+	cmpq $512, %rdx
+	jbe  memcpy
 	movq %rdi, %rax
 	movq %rdx, %rcx
 	rep movsb
-- 
1.6.5.2

