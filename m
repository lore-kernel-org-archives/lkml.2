Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab2EHS0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:26:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:11241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab2EHSXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637075"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com
Subject: [PATCH 12/23] x86, realmode: Remove indirect jumps in trampoline_64.S
Date: Tue,  8 May 2012 21:22:35 +0300
Message-Id: <1336501366-28617-13-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Remove indirect jumps in trampoline_64.S which are no longer
necessary: the realmode code can relocate the absolute jumps
correctly from the start.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/realmode/rm/trampoline_64.S |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 66c58cf..77b72b4 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -73,7 +73,7 @@ ENTRY(trampoline_data)
 	lmsw	%ax			# into protected mode
 
 	# flush prefetch and jump to startup_32
-	ljmpl	*(startup_32_vector)
+	ljmpl	$__KERNEL32_CS, $pa_startup_32
 
 no_longmode:
 	hlt
@@ -113,7 +113,7 @@ ENTRY(startup_32)
 	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we use
 	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
 	 */
-	ljmpl	*(pa_startup_64_vector)
+	ljmpl	$__KERNEL_CS, $pa_startup_64
 
 	.section ".text64","ax"
 	.code64
@@ -144,17 +144,6 @@ tgdt:
 	.quad	0x00cf93000000ffff	# __KERNEL_DS
 tgdt_end:
 
-	.balign 4
-startup_32_vector:
-	.long	pa_startup_32
-	.word	__KERNEL32_CS, 0
-
-	.balign 4
-	.globl startup_64_vector
-startup_64_vector:
-	.long	pa_startup_64
-	.word	__KERNEL_CS, 0
-
 	.data
 	.balign 4
 GLOBAL(trampoline_status)
-- 
1.7.9.5

