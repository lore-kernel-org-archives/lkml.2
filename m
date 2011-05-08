Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1EHMwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 08:52:07 -0400
Received: from service87.mimecast.com ([94.185.240.25]:42768 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753340Ab1EHMv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 08:51:57 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v5 04/19] ARM: LPAE: Make TTBR1 always point to swapper_pg_dir on ARMv7
Date: Sun,  8 May 2011 13:51:23 +0100
Message-Id: <1304859098-10760-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 08 May 2011 12:51:49.0007 (UTC) FILETIME=[B1FCB1F0:01CC0D7E]
X-MC-Unique: 111050813515402701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p48CqSfA020044

On the secondary CPUs, TTBR1 points to the temporary pgd set up in
__cpu_up() which is later removed. With LPAE, TTBR1 is used for the
kernel mappings.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/smp.h |    1 +
 arch/arm/kernel/head.S     |    7 +++++--
 arch/arm/kernel/smp.c      |    1 +
 arch/arm/mm/proc-v7.S      |    4 +++-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index afea1b1..d924cf8 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -76,6 +76,7 @@ extern void platform_smp_prepare_cpus(unsigned int);
  */
 struct secondary_data {
 	unsigned long pgdir;
+	unsigned long swapper_pg_dir;
 	void *stack;
 };
 extern struct secondary_data secondary_data;
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index ea8fae7..ac368e6 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -113,6 +113,7 @@ ENTRY(stext)
 	ldr	r13, =__mmap_switched		@ address to jump to after
 						@ mmu has been enabled
 	adr	lr, BSYM(1f)			@ return (PIC) address
+	mov	r8, r4				@ set TTBR1 to swapper_pg_dir
  ARM(	add	pc, r10, #PROCINFO_INITFUNC	)
  THUMB(	add	r12, r10, #PROCINFO_INITFUNC	)
  THUMB(	mov	pc, r12				)
@@ -302,8 +303,10 @@ ENTRY(secondary_startup)
 	 */
 	adr	r4, __secondary_data
 	ldmia	r4, {r5, r7, r12}		@ address to jump to after
-	sub	r4, r4, r5			@ mmu has been enabled
-	ldr	r4, [r7, r4]			@ get secondary_data.pgdir
+	sub	r13, r4, r5			@ mmu has been enabled
+	ldr	r4, [r7, r13]			@ get secondary_data.pgdir
+	add	r7, r7, #4
+	ldr	r8, [r7, r13]			@ get secondary_data.swapper_pg_dir
 	adr	lr, BSYM(__enable_mmu)		@ return address
 	mov	r13, r12			@ __secondary_switched address
  ARM(	add	pc, r10, #PROCINFO_INITFUNC	) @ initialise processor
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 556bd54..e2ea1bf 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -105,6 +105,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	 */
 	secondary_data.stack = task_stack_page(idle) + THREAD_START_SP;
 	secondary_data.pgdir = virt_to_phys(pgd);
+	secondary_data.swapper_pg_dir = virt_to_phys(swapper_pg_dir);
 	__cpuc_flush_dcache_area(&secondary_data, sizeof(secondary_data));
 	outer_clean_range(__pa(&secondary_data), __pa(&secondary_data + 1));
 
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 5fd5bc0..864a5c9 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -375,7 +375,9 @@ __v7_setup:
 	mcr	p15, 0, r10, c2, c0, 2		@ TTB control register
 	ALT_SMP(orr	r4, r4, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r4, r4, #TTB_FLAGS_UP)
-	mcr	p15, 0, r4, c2, c0, 1		@ load TTB1
+	ALT_SMP(orr	r8, r8, #TTB_FLAGS_SMP)
+	ALT_UP(orr	r8, r8, #TTB_FLAGS_UP)
+	mcr	p15, 0, r8, c2, c0, 1		@ load TTB1
 	ldr	r5, =PRRR			@ PRRR
 	ldr	r6, =NMRR			@ NMRR
 	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR

