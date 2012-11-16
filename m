Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2KPTp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:45:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35533 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2KPTp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:45:26 -0500
Date: Fri, 16 Nov 2012 11:44:06 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-b8d5c0d17d7dc5562bce127f4dbeeef2c479b144@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <5093BA1F02000078000A600E@nat28.tlf.novell.com>
References: <5093BA1F02000078000A600E@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64:
  Fix ordering of CFI directives and recent ASM_CLAC additions
Git-Commit-ID: b8d5c0d17d7dc5562bce127f4dbeeef2c479b144
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Nov 2012 11:44:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8d5c0d17d7dc5562bce127f4dbeeef2c479b144
Gitweb:     http://git.kernel.org/tip/b8d5c0d17d7dc5562bce127f4dbeeef2c479b144
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 2 Nov 2012 11:18:39 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Nov 2012 11:35:30 -0800

x86-64: Fix ordering of CFI directives and recent ASM_CLAC additions

While these got added in the right place everywhere else, entry_64.S
is the odd one where they ended up before the initial CFI directive(s).
In order to cover the full code ranges, the CFI directive must be
first, though.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/5093BA1F02000078000A600E@nat28.tlf.novell.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/entry_64.S | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b51b2c7..1328fe4 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -995,8 +995,8 @@ END(interrupt)
 	 */
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
 common_interrupt:
-	ASM_CLAC
 	XCPT_FRAME
+	ASM_CLAC
 	addq $-0x80,(%rsp)		/* Adjust vector to [-256,-1] range */
 	interrupt do_IRQ
 	/* 0(%rsp): old_rsp-ARGOFFSET */
@@ -1135,8 +1135,8 @@ END(common_interrupt)
  */
 .macro apicinterrupt num sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	INTR_FRAME
+	ASM_CLAC
 	pushq_cfi $~(\num)
 .Lcommon_\sym:
 	interrupt \do_sym
@@ -1190,8 +1190,8 @@ apicinterrupt IRQ_WORK_VECTOR \
  */
 .macro zeroentry sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	INTR_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
@@ -1208,8 +1208,8 @@ END(\sym)
 
 .macro paranoidzeroentry sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	INTR_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
@@ -1227,8 +1227,8 @@ END(\sym)
 #define INIT_TSS_IST(x) PER_CPU_VAR(init_tss) + (TSS_ist + ((x) - 1) * 8)
 .macro paranoidzeroentry_ist sym do_sym ist
 ENTRY(\sym)
-	ASM_CLAC
 	INTR_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
@@ -1247,8 +1247,8 @@ END(\sym)
 
 .macro errorentry sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	XCPT_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
@@ -1266,8 +1266,8 @@ END(\sym)
 	/* error code is on the stack already */
 .macro paranoiderrorentry sym do_sym
 ENTRY(\sym)
-	ASM_CLAC
 	XCPT_FRAME
+	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
