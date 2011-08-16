Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1HPFea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:34:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61644 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1HPFe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:34:27 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 2/4] kbuild: reduce kbuild invasivity within kconfig
Date: Tue, 16 Aug 2011 01:34:12 -0400
Message-Id: <1313472854-14426-3-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
References: <1313472854-14426-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce `Kconfig' and `KCONFIG_DEFCONFIG' as a Kconfig's interface to kbuild.
These variable are set in the top-level Makefile, which remove reference to
KBUILD_ prefixed variable within Kconfig makefile.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Makefile                 |    8 ++++++--
 scripts/kconfig/Makefile |   14 +++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index 26798a4..e7b576e 100644
--- a/Makefile
+++ b/Makefile
@@ -238,6 +238,9 @@ endif
 KBUILD_CONFIG	?= .config
 export KBUILD_CONFIG
 
+KBUILD_KCONFIG	?= Kconfig
+export KBUILD_KCONFIG
+
 # SHELL used by kbuild
 CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
 	  else if [ -x /bin/bash ]; then echo /bin/bash; \
@@ -482,11 +485,12 @@ ifeq ($(config-targets),1)
 # KBUILD_DEFCONFIG may point out an alternative default configuration
 # used for 'make defconfig'
 include $(srctree)/arch/$(SRCARCH)/Makefile
-export KBUILD_DEFCONFIG KBUILD_KCONFIG
 
 # Prepare Kconfig environment
+Kconfig           = $(KBUILD_KCONFIG)
 KCONFIG_CONFIG    = $(KBUILD_CONFIG)
-export KCONFIG_CONFIG
+KCONFIG_DEFCONFIG = $(KBUILD_DEFCONFIG)
+export Kconfig KCONFIG_CONFIG KCONFIG_DEFCONFIG
 
 config: scripts_basic outputmakefile FORCE
 	$(Q)mkdir -p include/linux include/config
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 3fa5a65..dabb4f1 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -5,13 +5,9 @@
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config \
 	localmodconfig localyesconfig
 
-ifdef KBUILD_KCONFIG
-Kconfig := $(KBUILD_KCONFIG)
-else
-Kconfig := Kconfig
-endif
-
+Kconfig           ?= Kconfig
 KCONFIG_CONFIG    ?= .config
+KCONFIG_DEFCONFIG ?=
 export KCONFIG_CONFIG
 
 xconfig: $(obj)/qconf
@@ -113,11 +109,11 @@ savedefconfig: $(obj)/conf
 	$< --$@=defconfig $(Kconfig)
 
 defconfig: $(obj)/conf
-ifeq ($(KBUILD_DEFCONFIG),)
+ifeq ($(KCONFIG_DEFCONFIG),)
 	$< --defconfig $(Kconfig)
 else
-	@echo "*** Default configuration is based on '$(KBUILD_DEFCONFIG)'"
-	$(Q)$< --defconfig=arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
+	@echo "*** Default configuration is based on '$(KCONFIG_DEFCONFIG)'"
+	$(Q)$< --defconfig=arch/$(SRCARCH)/configs/$(KCONFIG_DEFCONFIG) $(Kconfig)
 endif
 
 %_defconfig: $(obj)/conf
-- 
1.7.6.153.g78432

