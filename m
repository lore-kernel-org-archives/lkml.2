Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab2EHS1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:27:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:11241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab2EHSXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637060"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com
Subject: [PATCH 10/23] x86, realmode: Move bits to the proper sections in trampoline_64.S
Date: Tue,  8 May 2012 21:22:33 +0300
Message-Id: <1336501366-28617-11-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Move various bits to the sections they really belong in in
trampoline_64.S.  Use GLOBAL() rather than ENTRY() for data objects:
ENTRY() should only be used with code and forces alignment to 16
bytes.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/realmode/rm/trampoline_64.S |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 063da00..66c58cf 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -80,6 +80,7 @@ no_longmode:
 	jmp no_longmode
 #include "../kernel/verify_cpu.S"
 
+	.section ".text32","ax"
 	.code32
 	.balign 4
 ENTRY(startup_32)
@@ -114,6 +115,7 @@ ENTRY(startup_32)
 	 */
 	ljmpl	*(pa_startup_64_vector)
 
+	.section ".text64","ax"
 	.code64
 	.balign 4
 ENTRY(startup_64)
@@ -123,7 +125,8 @@ ENTRY(startup_64)
 	addl	%esi, %eax
 	jmp	*%rax
 
-	# Careful these need to be in the same 64K segment as the above;
+	.section ".rodata","a"
+	.balign	16
 tidt:
 	.word	0			# idt limit = 0
 	.word	0, 0			# idt base = 0L
@@ -153,9 +156,8 @@ startup_64_vector:
 	.word	__KERNEL_CS, 0
 
 	.data
-
 	.balign 4
-ENTRY(trampoline_status)
+GLOBAL(trampoline_status)
 	.long	0
 
 trampoline_stack:
@@ -164,7 +166,7 @@ trampoline_stack_end:
 
 	.globl	level3_ident_pgt
 	.globl	level3_kernel_pgt
-ENTRY(trampoline_level4_pgt)
+GLOBAL(trampoline_level4_pgt)
 	level3_ident_pgt:	.quad	0
 	.fill 510,8,0
 	level3_kernel_pgt:	.quad	0
-- 
1.7.9.5

