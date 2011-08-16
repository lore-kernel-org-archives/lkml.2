Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1HPFfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:35:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47112 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1HPFeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:34:25 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 1/4] kbuild: introduce KBUILD_CONFIG; unexpose KCONFIG_CONFIG
Date: Tue, 16 Aug 2011 01:34:11 -0400
Message-Id: <1313472854-14426-2-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
References: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine the Kbuild interface to expose it's own variable to architecture
Makefile's and prepare Kconfig environment prior to any %config invocation.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Makefile                                |    8 ++++++--
 arch/arm/boot/compressed/Makefile       |    2 +-
 arch/unicore32/boot/compressed/Makefile |    2 +-
 scripts/kconfig/Makefile                |    3 +++
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index b4ca4e1..26798a4 100644
--- a/Makefile
+++ b/Makefile
@@ -235,8 +235,8 @@ ifeq ($(ARCH),m68knommu)
        hdr-arch  := m68k
 endif
 
-KCONFIG_CONFIG	?= .config
-export KCONFIG_CONFIG
+KBUILD_CONFIG	?= .config
+export KBUILD_CONFIG
 
 # SHELL used by kbuild
 CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
@@ -484,6 +484,10 @@ ifeq ($(config-targets),1)
 include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG KBUILD_KCONFIG
 
+# Prepare Kconfig environment
+KCONFIG_CONFIG    = $(KBUILD_CONFIG)
+export KCONFIG_CONFIG
+
 config: scripts_basic outputmakefile FORCE
 	$(Q)mkdir -p include/linux include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 0c74a6f..1891c0c 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -154,5 +154,5 @@ CFLAGS_font.o := -Dstatic=
 $(obj)/font.c: $(FONTC)
 	$(call cmd,shipped)
 
-$(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile $(KCONFIG_CONFIG)
+$(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile $(KBUILD_CONFIG)
 	@sed "$(SEDFLAGS)" < $< > $@
diff --git a/arch/unicore32/boot/compressed/Makefile b/arch/unicore32/boot/compressed/Makefile
index b0954a2..90a9841 100644
--- a/arch/unicore32/boot/compressed/Makefile
+++ b/arch/unicore32/boot/compressed/Makefile
@@ -63,6 +63,6 @@ ZTEXTADDR	:= 0x03000000
 ZBSSADDR	:= ALIGN(4)
 
 SEDFLAGS_lds	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
-$(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/unicore32/boot/Makefile $(KCONFIG_CONFIG)
+$(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/unicore32/boot/Makefile $(KBUILD_CONFIG)
 	@sed "$(SEDFLAGS_lds)" < $< > $@
 
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 82d2eb2..3fa5a65 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -11,6 +11,9 @@ else
 Kconfig := Kconfig
 endif
 
+KCONFIG_CONFIG    ?= .config
+export KCONFIG_CONFIG
+
 xconfig: $(obj)/qconf
 	$< $(Kconfig)
 
-- 
1.7.6.153.g78432

