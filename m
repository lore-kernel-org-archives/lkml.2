Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0GaQsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 12:48:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0GaQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 12:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s1ofMfL4kSi3+fpVW07Q2V2pkd9/dFjQHcTCHt9qyJnx7jtuaLsJi8tEQv6vNJ8VdZ
         mOZYfSh3aRQ3M3GnDWxcMXth6kJgHbxWTihRtUC2oFmai/5JXvqojRP2nq6NJz/vDvwf
         ovpYo1to5ZQGVZf2fbkSVRf/giPDZKOLeZ7xw=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86-64: Directly access per-cpu IST
Date: Sat, 31 Jul 2010 12:48:22 -0400
Message-Id: <1280594903-6341-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a direct per-cpu reference for the IST instead of using a scratch
register.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
-- 
1.7.2

