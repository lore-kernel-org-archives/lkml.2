Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab1EXVjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:39:46 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34602 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932717Ab1EXVjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:40 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v6 02/18] ARM: LPAE: add ISBs around MMU enabling code
Date: Tue, 24 May 2011 22:39:08 +0100
Message-Id: <1306273164-18217-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:44.0802 (UTC) FILETIME=[18D77020:01CC1A5B]
X-MC-Unique: 111052422393702501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLdpGf005027

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
index 49f5b2e..ef22486 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -526,6 +526,7 @@ __armv7_mmu_cache_on:
 		mcrne	p15, 0, r3, c2, c0, 0	@ load page table pointer
 		mcrne	p15, 0, r1, c3, c0, 0	@ load domain access control
 #endif
+		mcr	p15, 0, r0, c7, c5, 4	@ ISB
 		mcr	p15, 0, r0, c1, c0, 0	@ load control register
 		mrc	p15, 0, r0, c1, c0, 0	@ and read it back
 		mov	r0, #0
diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index bc2d2d7..2bcc456 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -184,6 +184,17 @@
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
index 8224b1d..b7101ff 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -388,8 +388,10 @@ ENDPROC(__enable_mmu)
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
index 6398ead..1ac5dce 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -88,8 +88,10 @@ ENDPROC(cpu_resume_mmu)
 	.ltorg
 	.align	5
 cpu_resume_turn_mmu_on:
+	instr_sync
 	mcr	p15, 0, r1, c1, c0, 0	@ turn on MMU, I-cache, etc
 	mrc	p15, 0, r1, c0, c0, 0	@ read id reg
+	instr_sync
 	mov	r1, r1
 	mov	r1, r1
 	mov	pc, r3			@ jump to virtual address

