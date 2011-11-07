Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab1KGQUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:20:34 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49750 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab1KGQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:20 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v8 06/16] ARM: LPAE: add ISBs around MMU enabling code
Date: Mon,  7 Nov 2011 16:16:48 +0000
Message-Id: <1320682618-1182-7-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:11.0654 (UTC) FILETIME=[B473A860:01CC9D68]
X-MC-Unique: 111110716171705101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GKhxL015328

From: Will Deacon <will.deacon@arm.com>

Before we enable the MMU, we must ensure that the TTBR registers contain
sane values. After the MMU has been enabled, we jump to the *virtual*
address of the following function, so we also need to ensure that the
SCTLR write has taken effect.

This patch adds ISB instructions around the SCTLR write to ensure the
visibility of the above.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/boot/compressed/head.S  |    1 +
 arch/arm/include/asm/assembler.h |   11 +++++++++++
 arch/arm/kernel/head.S           |    2 ++
 arch/arm/kernel/sleep.S          |    2 ++
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index c2effc9..c5d6025 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -659,6 +659,7 @@ __armv7_mmu_cache_on:
 		mcrne	p15, 0, r3, c2, c0, 0	@ load page table pointer
 		mcrne	p15, 0, r1, c3, c0, 0	@ load domain access control
 #endif
+		mcr	p15, 0, r0, c7, c5, 4	@ ISB
 		mcr	p15, 0, r0, c1, c0, 0	@ load control register
 		mrc	p15, 0, r0, c1, c0, 0	@ and read it back
 		mov	r0, #0
diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 29035e8..b6e65de 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -187,6 +187,17 @@
 #endif
 
 /*
+ * Instruction barrier
+ */
+	.macro	instr_sync
+#if __LINUX_ARM_ARCH__ >= 7
+	isb
+#elif __LINUX_ARM_ARCH__ == 6
+	mcr	p15, 0, r0, c7, c5, 4
+#endif
+	.endm
+
+/*
  * SMP data memory barrier
  */
 	.macro	smp_dmb mode
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 566c54c..6ee994c 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -400,8 +400,10 @@ ENDPROC(__enable_mmu)
 	.align	5
 __turn_mmu_on:
 	mov	r0, r0
+	instr_sync
 	mcr	p15, 0, r0, c1, c0, 0		@ write control reg
 	mrc	p15, 0, r3, c0, c0, 0		@ read id reg
+	instr_sync
 	mov	r3, r3
 	mov	r3, r13
 	mov	pc, r3
diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index 020e99c..4ac45fe 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -56,8 +56,10 @@ ENDPROC(cpu_suspend_abort)
 	.align	5
 ENTRY(cpu_resume_mmu)
 	ldr	r3, =cpu_resume_after_mmu
+	instr_sync
 	mcr	p15, 0, r0, c1, c0, 0	@ turn on MMU, I-cache, etc
 	mrc	p15, 0, r0, c0, c0, 0	@ read id reg
+	instr_sync
 	mov	r0, r0
 	mov	r0, r0
 	mov	pc, r3			@ jump to virtual address

