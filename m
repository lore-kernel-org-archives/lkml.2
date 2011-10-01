Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab1JATYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:24:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab1JATXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:23:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/11] ARM: always use ARM_UNWIND for thumb2 kernels
Date: Sat,  1 Oct 2011 21:21:52 +0200
Message-Id: <1317496920-7764-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Df4C6P2NjHzhbfPCLPm1uHi8jJQh2/QxHoqfxtJfx8n
 KyHxbdIVC0FpwyljLkclWBoyDnjhP+lw8grYjf/kpToN5kJ6yw
 eVWbB1jlavDut4tUkM/mxkZ4PyC+j0kG1XDTjTEbIsj0KiychO
 eAOlewxIVO16YQNJ3OEmuhyqZGlhNjO/Zuxl0WkUmR4a4q9W14
 LkofPVJNE0XhOvWIa+pHRoIaqzEw6AfizhnP1kBCB4FwNjSX/U
 83Z0vicCthWH+5X+XBoKo8VYoUJdHIfoWn2ovNOJyXHgLbq8qG
 FgyKwx2CH9G7wS8eli9FYsB43zN89sw6Ggpc8OAZqo9BYDEynx
 VyZ2+aP72GwI7XuQ0x0Q8Xs0hBJhtfi4r2Jp3Cui/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thumb2 kernels cannot be built with frame pointers, but can use the
ARM_UNWIND feature for unwinding instead. This makes sure that all
features that rely on unwinding includeing CONFIG_LATENCYTOP and
FAULT_INJECTION_STACKTRACE_FILTER do not enable frame pointers
when the unwinder is already selected, and we always build with
the unwinder when we want a thumb2 kernel, to make sure we do not
get the frame pointers instead.

A different option would be to redefine the CONFIG_FRAME_POINTERS
option on ARM to mean builing with either frame pointers or
the unwinder, and then select which one to use based on the
CPU architecture or another user option. That would still allow
building thumb2 kernels without the unwinder but would also be
more confusing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig  |    1 +
 lib/Kconfig.debug |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4e1eee0c..497af51 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1457,6 +1457,7 @@ config THUMB2_KERNEL
 	depends on CPU_V7 && !CPU_V6 && !CPU_V6K && EXPERIMENTAL
 	select AEABI
 	select ARM_ASM_UNIFIED
+	select ARM_UNWIND
 	help
 	  By enabling this option, the kernel will be compiled in
 	  Thumb-2 mode. A compiler/assembler that understand the unified
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c0cb9c4..103c171 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1081,7 +1081,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !PPC && !S390 && !MICROBLAZE
+	select FRAME_POINTER if !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
@@ -1091,7 +1091,7 @@ config LATENCYTOP
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 	depends on PROC_FS
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE
+	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
-- 
1.7.5.4

