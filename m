Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0HBPQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:16:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:53965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab0HBPQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:16:11 -0400
Date: Mon, 2 Aug 2010 15:15:54 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1280594903-6341-1-git-send-email-brgerst@gmail.com>
References: <1280594903-6341-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64, asm: Directly access per-cpu IST
Message-ID: <tip-c15a5958a0b6dbf06b3c05972694f04a0c50a4cf@git.kernel.org>
Git-Commit-ID: c15a5958a0b6dbf06b3c05972694f04a0c50a4cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 15:15:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c15a5958a0b6dbf06b3c05972694f04a0c50a4cf
Gitweb:     http://git.kernel.org/tip/c15a5958a0b6dbf06b3c05972694f04a0c50a4cf
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Sat, 31 Jul 2010 12:48:22 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 1 Aug 2010 16:05:17 -0700

x86-64, asm: Directly access per-cpu IST

Use a direct per-cpu reference for the IST instead of using a scratch
register.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1280594903-6341-1-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_64.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4db7c4d..59af275 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1065,6 +1065,7 @@ ENTRY(\sym)
 END(\sym)
 .endm
 
+#define INIT_TSS_IST(x) PER_CPU_VAR(init_tss) + (TSS_ist + ((x) - 1) * 8)
 .macro paranoidzeroentry_ist sym do_sym ist
 ENTRY(\sym)
 	INTR_FRAME
@@ -1076,10 +1077,9 @@ ENTRY(\sym)
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
-	PER_CPU(init_tss, %r12)
-	subq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%r12)
+	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
 	call \do_sym
-	addq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%r12)
+	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 END(\sym)
