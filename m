Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1KJSuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:50:03 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40352 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab1KJSt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:49:57 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH Resend 1/2] fs: binfmt_elf: Create Kconfig variable for PIE randomization.
Date: Thu, 10 Nov 2011 10:49:49 -0800
Message-Id: <1320950990-10827-1-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randomization of PIE load address is hard coded in binfmt_elf.c for
X86 and ARM.  Create a new Kconfig variable
(CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE) for this and use it instead.
Thus architecture specific policy is pushed out of the generic
binfmt_elf.c and into the architecture Kconfig files.

X86 and ARM Kconfigs are modified to select the new variable so there
is no change in behavior.  A follow on patch will select it for MIPS
too.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: David Daney <david.daney@cavium.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
---

I am resending with no change other than adding HPAs Acked-by.  The
first attempt to send was not completly successful due to my MTA being
fubar.  It should be working now.

 arch/arm/Kconfig  |    1 +
 arch/x86/Kconfig  |    1 +
 fs/Kconfig.binfmt |    3 +++
 fs/binfmt_elf.c   |    2 +-
 4 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 44789ef..3830439 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -30,6 +30,7 @@ config ARM
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_SHOW
 	select CPU_PM if (SUSPEND || CPU_IDLE)
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb9a104..9c3e447 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -75,6 +75,7 @@ config X86
 	select HAVE_BPF_JIT if (X86_64 && NET)
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 79e2ca7..e95d1b6 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -27,6 +27,9 @@ config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
 
+config ARCH_BINFMT_ELF_RANDOMIZE_PIE
+	bool
+
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 21ac5ee..bcb884e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -794,7 +794,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
-#if defined(CONFIG_X86) || defined(CONFIG_ARM)
+#ifdef CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE
 			/* Memory randomization might have been switched off
 			 * in runtime via sysctl.
 			 * If that is the case, retain the original non-zero
-- 
1.7.2.3

