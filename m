Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab2EHWX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:23:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EHWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:23:27 -0400
Date: Tue, 8 May 2012 15:23:18 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-056a43a6d3ab903a798d8ee4435ad67d6fccc3e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-13-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-13-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Remove indirect jumps in trampoline_64.S
Git-Commit-ID: 056a43a6d3ab903a798d8ee4435ad67d6fccc3e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:23:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  056a43a6d3ab903a798d8ee4435ad67d6fccc3e6
Gitweb:     http://git.kernel.org/tip/056a43a6d3ab903a798d8ee4435ad67d6fccc3e6
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 8 May 2012 21:22:35 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:48:03 -0700

x86, realmode: Remove indirect jumps in trampoline_64.S

Remove indirect jumps in trampoline_64.S which are no longer
necessary: the realmode code can relocate the absolute jumps
correctly from the start.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-13-git-send-email-jarkko.sakkinen@intel.com
---
 arch/x86/realmode/rm/trampoline_64.S |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

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
