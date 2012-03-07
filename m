Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031681Ab2CGAau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:30:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37249 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965194Ab2CGAas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:30:48 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Russell King <linux@arm.linux.org.uk>, nico@fluxnic.net,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 1/3] Kbuild: centralize MKIMAGE and cmd_uimage definitions
Date: Tue,  6 Mar 2012 17:30:36 -0700
Message-Id: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All ARCHs have the same definition of MKIMAGE. Move it to Makefile.lib
to avoid duplication.

All ARCHs have similar definitions of cmd_uimage. Place a sufficiently
parameterized version in Makefile.lib to avoid duplication.

The centralized cmd_uimage definition will allow the future introduction
of a centralized Kconfig option to make cmd_uimage use -T kernel_noload
rather than -T kernel.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
NOTE: I have not tested this patch in any way at all for architectures
other than ARM.

 arch/arm/boot/Makefile          |   23 +++++++++--------------
 arch/avr32/boot/images/Makefile |    9 +++------
 arch/blackfin/boot/Makefile     |   19 ++++++++-----------
 arch/microblaze/boot/Makefile   |   10 +++-------
 arch/sh/boot/Makefile           |    8 ++------
 arch/sparc/boot/Makefile        |    9 +++------
 arch/unicore32/boot/Makefile    |   12 ++----------
 scripts/Makefile.lib            |   24 ++++++++++++++++++++++++
 8 files changed, 54 insertions(+), 60 deletions(-)

diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index fc871e7..c877087 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -11,8 +11,6 @@
 # Copyright (C) 1995-2002 Russell King
 #
 
-MKIMAGE         := $(srctree)/scripts/mkuboot.sh
-
 ifneq ($(MACHINE),)
 include $(srctree)/$(MACHINE)/Makefile.boot
 endif
@@ -69,22 +67,19 @@ $(obj)/dtbs: $(addprefix $(obj)/, $(dtb-y))
 
 clean-files := *.dtb
 
-quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A arm -O linux -T kernel \
-		   -C none -a $(LOADADDR) -e $(STARTADDR) \
-		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
-
-ifeq ($(CONFIG_ZBOOT_ROM),y)
-$(obj)/uImage: LOADADDR=$(CONFIG_ZBOOT_ROM_TEXT)
+ifneq ($(LOADADDR),)
+  UIMAGE_LOADADDR=$(LOADADDR)
 else
-$(obj)/uImage: LOADADDR=$(ZRELADDR)
+  ifeq ($(CONFIG_ZBOOT_ROM),y)
+    UIMAGE_LOADADDR=$(CONFIG_ZBOOT_ROM_TEXT)
+  else
+    UIMAGE_LOADADDR=$(ZRELADDR)
+  endif
 endif
 
-$(obj)/uImage: STARTADDR=$(LOADADDR)
-
 check_for_multiple_loadaddr = \
-if [ $(words $(LOADADDR)) -gt 1 ]; then \
-	echo 'multiple load addresses: $(LOADADDR)'; \
+if [ $(words $(UIMAGE_LOADADDR)) -gt 1 ]; then \
+	echo 'multiple load addresses: $(UIMAGE_LOADADDR)'; \
 	echo 'This is incompatible with uImages'; \
 	echo 'Specify LOADADDR on the commandline to build an uImage'; \
 	false; \
diff --git a/arch/avr32/boot/images/Makefile b/arch/avr32/boot/images/Makefile
index 1848bf0..c9d8ab5 100644
--- a/arch/avr32/boot/images/Makefile
+++ b/arch/avr32/boot/images/Makefile
@@ -6,8 +6,6 @@
 # for more details.
 #
 
-MKIMAGE		:= $(srctree)/scripts/mkuboot.sh
-
 extra-y		:= vmlinux.bin vmlinux.gz
 
 OBJCOPYFLAGS_vmlinux.bin := -O binary -R .note.gnu.build-id
@@ -17,10 +15,9 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
 
-quiet_cmd_uimage = UIMAGE $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A avr32 -O linux -T kernel	\
-		-C gzip -a $(CONFIG_LOAD_ADDRESS) -e $(CONFIG_ENTRY_ADDRESS)	\
-		-n 'Linux-$(KERNELRELEASE)' -d $< $@
+UIMAGE_LOADADDR = $(CONFIG_LOAD_ADDRESS
+UIMAGE_ENTRYADDR = $(CONFIG_ENTRY_ADDRESS)
+UIMAGE_COMPRESSION = gzip
 
 targets += uImage uImage.srec
 $(obj)/uImage: $(obj)/vmlinux.gz
diff --git a/arch/blackfin/boot/Makefile b/arch/blackfin/boot/Makefile
index 0a49279..6d2690a 100644
--- a/arch/blackfin/boot/Makefile
+++ b/arch/blackfin/boot/Makefile
@@ -6,20 +6,17 @@
 # for more details.
 #
 
-MKIMAGE := $(srctree)/scripts/mkuboot.sh
-
 targets := vmImage vmImage.bin vmImage.bz2 vmImage.gz vmImage.lzma vmImage.lzo vmImage.xip
 extra-y += vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.lzo vmlinux.bin.xip
 
-UIMAGE_OPTS-y :=
-UIMAGE_OPTS-$(CONFIG_RAMKERNEL) += -a $(CONFIG_BOOT_LOAD)
-UIMAGE_OPTS-$(CONFIG_ROMKERNEL) += -a $(CONFIG_ROM_BASE) -x
-
-quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
-                   -C $(2) -n '$(CPU_REV)-$(KERNELRELEASE)' \
-                   -e $(shell $(NM) vmlinux | awk '$$NF == "__start" {print $$1}') \
-                   $(UIMAGE_OPTS-y) -d $< $@
+ifeq ($(CONFIG_RAMKERNEL),y)
+UIMAGE_LOADADDR = $(CONFIG_BOOT_LOAD)
+else # CONFIG_ROMKERNEL must be set
+UIMAGE_LOADADDR = $(CONFIG_BOOT_LOAD)
+endif
+UIMAGE_ENTRYADDR = $(shell $(NM) vmlinux | awk '$$NF == "__start" {print $$1}')
+UIMAGE_NAME = '$(CPU_REV)-$(KERNELRELEASE)'
+UIMAGE_OPTS-$(CONFIG_ROMKERNEL) += -x
 
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 0c796cf..ca76ecd 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -2,8 +2,6 @@
 # arch/microblaze/boot/Makefile
 #
 
-MKIMAGE := $(srctree)/scripts/mkuboot.sh
-
 obj-y += linked_dtb.o
 
 targets := linux.bin linux.bin.gz simpleImage.%
@@ -35,11 +33,9 @@ quiet_cmd_strip = STRIP   $@
 	cmd_strip = $(STRIP) -K microblaze_start -K _end -K __log_buf \
 				-K _fdt_start vmlinux -o $@
 
-quiet_cmd_uimage = UIMAGE  $@.ub
-	cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A microblaze -O linux -T kernel \
-		-C none -n 'Linux-$(KERNELRELEASE)' \
-		-a $(CONFIG_KERNEL_BASE_ADDR) -e $(CONFIG_KERNEL_BASE_ADDR) \
-		-d $@ $@.ub
+UIMAGE_IN = $@
+UIMAGE_OUT = $@.ub
+UIMAGE_LOADADDR = $(CONFIG_KERNEL_BASE_ADDR)
 
 $(obj)/simpleImage.%: vmlinux FORCE
 	$(call if_changed,cp,.unstrip)
diff --git a/arch/sh/boot/Makefile b/arch/sh/boot/Makefile
index e4ea31a..58592df 100644
--- a/arch/sh/boot/Makefile
+++ b/arch/sh/boot/Makefile
@@ -8,8 +8,6 @@
 # Copyright (C) 1999 Stuart Menefy
 #
 
-MKIMAGE := $(srctree)/scripts/mkuboot.sh
-
 #
 # Assign safe dummy values if these variables are not defined,
 # in order to suppress error message.
@@ -61,10 +59,8 @@ KERNEL_ENTRY	:= $(shell /bin/bash -c 'printf "0x%08x" \
 			$(KERNEL_MEMORY) + \
 			$(CONFIG_ZERO_PAGE_OFFSET) + $(CONFIG_ENTRY_OFFSET)]')
 
-quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A sh -O linux -T kernel \
-		   -C $(2) -a $(KERNEL_LOAD) -e $(KERNEL_ENTRY) \
-		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
+UIMAGE_LOADADDR = $(KERNEL_LOAD)
+UIMAGE_ENTRYADDR = $(KERNEL_ENTRY)
 
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
diff --git a/arch/sparc/boot/Makefile b/arch/sparc/boot/Makefile
index 9205416..19e1bc7 100644
--- a/arch/sparc/boot/Makefile
+++ b/arch/sparc/boot/Makefile
@@ -5,7 +5,6 @@
 
 ROOT_IMG	:= /usr/src/root.img
 ELFTOAOUT	:= elftoaout
-MKIMAGE 	:= $(srctree)/scripts/mkuboot.sh
 
 hostprogs-y	:= piggyback btfixupprep
 targets		:= tftpboot.img btfix.o btfix.S image zImage vmlinux.aout
@@ -92,11 +91,9 @@ $(obj)/image.bin: $(obj)/image FORCE
 $(obj)/image.gz: $(obj)/image.bin
 	$(call if_changed,gzip)
 
-quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A sparc -O linux -T kernel \
-               -C gzip -a $(CONFIG_UBOOT_LOAD_ADDR) \
-	       -e $(CONFIG_UBOOT_ENTRY_ADDR) -n 'Linux-$(KERNELRELEASE)' \
-               -d $< $@
+UIMAGE_LOADADDR = $(CONFIG_UBOOT_LOAD_ADDR
+UIMAGE_ENTRYADDR = $(CONFIG_UBOOT_ENTRY_ADDR)
+UIMAGE_COMPRESSION = gzip
 
 quiet_cmd_uimage.o = UIMAGE.O $@
       cmd_uimage.o = $(LD) -Tdata $(CONFIG_UBOOT_FLASH_ADDR) \
diff --git a/arch/unicore32/boot/Makefile b/arch/unicore32/boot/Makefile
index 79e5f88..ec7fb70 100644
--- a/arch/unicore32/boot/Makefile
+++ b/arch/unicore32/boot/Makefile
@@ -11,8 +11,6 @@
 # Copyright (C) 2001~2010 GUAN Xue-tao
 #
 
-MKIMAGE := $(srctree)/scripts/mkuboot.sh
-
 targets := Image zImage uImage
 
 $(obj)/Image: vmlinux FORCE
@@ -26,14 +24,8 @@ $(obj)/zImage: $(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
 	@echo '  Kernel: $@ is ready'
 
-quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A unicore -O linux -T kernel \
-		   -C none -a $(LOADADDR) -e $(STARTADDR) \
-		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
-
-$(obj)/uImage: LOADADDR=0x0
-
-$(obj)/uImage: STARTADDR=$(LOADADDR)
+UIMAGE_ARCH = unicore
+UIMAGE_LOADADDR = 0x0
 
 $(obj)/uImage: $(obj)/zImage FORCE
 	$(call if_changed,uimage)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 00c368c..7b0be18 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -304,6 +304,30 @@ cmd_lzo = (cat $(filter-out FORCE,$^) | \
 	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
 
+# U-Boot mkimage
+# ---------------------------------------------------------------------------
+
+MKIMAGE := $(srctree)/scripts/mkuboot.sh
+
+# SRCARCH just happens to match slightly more than ARCH (on sparc), so reduces
+# the number of overrides in arch makefiles
+UIMAGE_ARCH = $(SRCARCH)
+UIMAGE_COMPRESSION = $(if $(2),$(2),none)
+UIMAGE_OPTS-y =
+UIMAGE_TYPE = kernel
+UIMAGE_LOADADDR=arch_must_set_this
+UIMAGE_ENTRYADDR=$(UIMAGE_LOADADDR)
+UIMAGE_NAME = 'Linux-$(KERNELRELEASE)'
+UIMAGE_IN = $<
+UIMAGE_OUT = $@
+
+quiet_cmd_uimage = UIMAGE  $(UIMAGE_OUT)
+      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A $(UIMAGE_ARCH) -O linux \
+			-C $(UIMAGE_COMPRESSION) $(UIMAGE_OPTS-y) \
+			-T $(UIMAGE_TYPE) \
+			-a $(UIMAGE_LOADADDR) -e $(UIMAGE_ENTRYADDR) \
+			-n $(UIMAGE_NAME) -d $(UIMAGE_IN) $(UIMAGE_OUT)
+
 # XZ
 # ---------------------------------------------------------------------------
 # Use xzkern to compress the kernel image and xzmisc to compress other things.
-- 
1.7.0.4

