Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0JAHG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:06:28 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:59921 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0JAHGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:24 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Grant Likely <grant.likely@secretlab.ca>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Torez Smith <lnxtorez@linux.vnet.ibm.com>
Subject: [PATCH 01/18] powerpc: Add ability to build little endian kernels
Date: Fri,  1 Oct 2010 17:05:54 +1000
Message-Id: <1285916771-18033-2-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch allows the kbuild system to successfully compile a kernel for
the little endian PowerPC architecture.

To build such a kernel a supported platform must be used and
CONFIG_CPU_LITTLE_ENDIAN must be set. CROSS_COMPILE must be set to a
suitable toolchain prefix (compiled for the powerpcle-elf target, or
patched to allow the powerpcle-linux target).

Since the system will always start in big endian mode, the zImage
wrapper must still be compiled with a big endian toolchain, which can be
specified via CROSS32_COMPILE.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/Makefile                   |   22 +++++++++++++++++++---
 arch/powerpc/boot/Makefile              |    3 ++-
 arch/powerpc/kernel/vdso32/vdso32.lds.S |    4 ++++
 arch/powerpc/platforms/Kconfig.cputype  |   16 ++++++++++++++++
 4 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index b7212b6..3eed685 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -56,11 +56,27 @@ endif
 
 UTS_MACHINE := $(OLDARCH)
 
+ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
+override CC	+= -mlittle-endian
+override AS	+= -mlittle-endian
+override LD	+= -EL
+LDEMULATION	:= lppc
+GNUTARGET	:= powerpcle
+MULTIPLEWORD	:= -mno-multiple
+else
+override CC	+= -mbig-endian
+override AS	+= -mbig-endian
+override LD	+= -EB
+LDEMULATION	:= ppc
+GNUTARGET	:= powerpc
+MULTIPLEWORD	:= -mmultiple
+endif
+
 ifeq ($(HAS_BIARCH),y)
 override AS	+= -a$(CONFIG_WORD_SIZE)
-override LD	+= -m elf$(CONFIG_WORD_SIZE)ppc
+override LD	+= -m elf$(CONFIG_WORD_SIZE)$(LDEMULATION)
 override CC	+= -m$(CONFIG_WORD_SIZE)
-override AR	:= GNUTARGET=elf$(CONFIG_WORD_SIZE)-powerpc $(AR)
+override AR	:= GNUTARGET=elf$(CONFIG_WORD_SIZE)-$(GNUTARGET) $(AR)
 endif
 
 LDFLAGS_vmlinux-yy := -Bstatic
@@ -68,7 +84,7 @@ LDFLAGS_vmlinux-$(CONFIG_PPC64)$(CONFIG_RELOCATABLE) := -pie
 LDFLAGS_vmlinux	:= $(LDFLAGS_vmlinux-yy)
 
 CFLAGS-$(CONFIG_PPC64)	:= -mminimal-toc -mtraceback=none  -mcall-aixdesc
-CFLAGS-$(CONFIG_PPC32)	:= -ffixed-r2 -mmultiple
+CFLAGS-$(CONFIG_PPC32)	:= -ffixed-r2 $(MULTIPLEWORD)
 KBUILD_CPPFLAGS	+= -Iarch/$(ARCH)
 KBUILD_AFLAGS	+= -Iarch/$(ARCH)
 KBUILD_CFLAGS	+= -msoft-float -pipe -Iarch/$(ARCH) $(CFLAGS-y)
diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index fae8192..39f10a4 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -22,7 +22,8 @@ all: $(obj)/zImage
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		 -fno-strict-aliasing -Os -msoft-float -pipe \
 		 -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
-		 -isystem $(shell $(CROSS32CC) -print-file-name=include)
+		 -isystem $(shell $(CROSS32CC) -print-file-name=include) \
+		 -mbig-endian
 BOOTAFLAGS	:= -D__ASSEMBLY__ $(BOOTCFLAGS) -traditional -nostdinc
 
 ifdef CONFIG_DEBUG_INFO
diff --git a/arch/powerpc/kernel/vdso32/vdso32.lds.S b/arch/powerpc/kernel/vdso32/vdso32.lds.S
index 0546bcd..f4c6676 100644
--- a/arch/powerpc/kernel/vdso32/vdso32.lds.S
+++ b/arch/powerpc/kernel/vdso32/vdso32.lds.S
@@ -4,7 +4,11 @@
  */
 #include <asm/vdso.h>
 
+#ifdef __LITTLE_ENDIAN__
+OUTPUT_FORMAT("elf32-powerpcle", "elf32-powerpcle", "elf32-powerpcle")
+#else
 OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
+#endif
 OUTPUT_ARCH(powerpc:common)
 ENTRY(_start)
 
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index d361f81..074ff12 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -329,3 +329,19 @@ config CHECK_CACHE_COHERENCY
 	bool
 
 endmenu
+
+config ARCH_SUPPORTS_LITTLE_ENDIAN
+	bool
+
+config CPU_LITTLE_ENDIAN
+	bool "Build little endian kernel"
+	depends on ARCH_SUPPORTS_LITTLE_ENDIAN && EXPERIMENTAL
+	default n
+	help
+	  This option selects whether a big endian or little endian kernel will
+	  be built.
+
+	  Note that if building a little endian kernel, CROSS_COMPILE must
+	  point to a toolchain capable of targetting little endian powerpc,
+	  while the toolchain specified by CROSS32_COMPILE must be capable of
+	  targetting *BIG* endian PowerPC.
-- 
1.7.1

