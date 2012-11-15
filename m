Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993167Ab2KOJk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:40:29 -0500
Received: from mail1.windriver.com ([147.11.146.13]:60749 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992490Ab2KOJkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:40:24 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] book3e/kexec/kdump: enable kexec for kernel
Date: Thu, 15 Nov 2012 17:39:52 +0800
Message-ID: <1352972396-13489-3-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352972396-13489-1-git-send-email-tiejun.chen@windriver.com>
References: <1352972396-13489-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to active KEXEC for book3e and bypass or convert non-book3e stuff
in kexec coverage.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/Kconfig                   |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c |    6 ++++++
 arch/powerpc/kernel/misc_64.S          |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a902a5c..3000cab8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -357,7 +357,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
-	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP)) && EXPERIMENTAL
+	depends on (PPC_BOOK3S || FSL_BOOKE || PPC_BOOK3E || (44x && !SMP)) && EXPERIMENTAL
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index d7f6090..2c0cbf0 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -32,6 +32,7 @@
 int default_machine_kexec_prepare(struct kimage *image)
 {
 	int i;
+#ifndef CONFIG_PPC_BOOK3E
 	unsigned long begin, end;	/* limits of segment */
 	unsigned long low, high;	/* limits of blocked memory range */
 	struct device_node *node;
@@ -40,6 +41,7 @@ int default_machine_kexec_prepare(struct kimage *image)
 
 	if (!ppc_md.hpte_clear_all)
 		return -ENOENT;
+#endif
 
 	/*
 	 * Since we use the kernel fault handlers and paging code to
@@ -50,6 +52,7 @@ int default_machine_kexec_prepare(struct kimage *image)
 		if (image->segment[i].mem < __pa(_end))
 			return -ETXTBSY;
 
+#ifndef CONFIG_PPC_BOOK3E
 	/*
 	 * For non-LPAR, we absolutely can not overwrite the mmu hash
 	 * table, since we are still using the bolted entries in it to
@@ -91,6 +94,7 @@ int default_machine_kexec_prepare(struct kimage *image)
 				return -ETXTBSY;
 		}
 	}
+#endif
 
 	return 0;
 }
@@ -358,6 +362,7 @@ void default_machine_kexec(struct kimage *image)
 	/* NOTREACHED */
 }
 
+#ifndef CONFIG_PPC_BOOK3E
 /* Values we need to export to the second kernel via the device tree. */
 static unsigned long htab_base;
 
@@ -402,3 +407,4 @@ static int __init export_htab_values(void)
 	return 0;
 }
 late_initcall(export_htab_values);
+#endif
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index 5cfa800..c2acf8c 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -532,9 +532,13 @@ _GLOBAL(kexec_sequence)
 	lhz	r25,PACAHWCPUID(r13)	/* get our phys cpu from paca */
 
 	/* disable interrupts, we are overwriting kernel data next */
+#ifndef CONFIG_PPC_BOOK3E
 	mfmsr	r3
 	rlwinm	r3,r3,0,17,15
 	mtmsrd	r3,1
+#else
+	wrteei	0
+#endif
 
 	/* copy dest pages, flush whole dest image */
 	mr	r3,r29
@@ -556,10 +560,12 @@ _GLOBAL(kexec_sequence)
 	li	r6,1
 	stw	r6,kexec_flag-1b(5)
 
+#ifndef CONFIG_PPC_BOOK3E
 	/* clear out hardware hash page table and tlb */
 	ld	r5,0(r27)		/* deref function descriptor */
 	mtctr	r5
 	bctrl				/* ppc_md.hpte_clear_all(void); */
+#endif
 
 /*
  *   kexec image calling is:
-- 
1.7.9.5

