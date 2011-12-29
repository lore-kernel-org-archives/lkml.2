Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1L2PtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 10:49:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50008 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab1L2Ps7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 10:48:59 -0500
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-modules@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kbuild: add target to install gzipped modules
Date: Thu, 29 Dec 2011 13:50:18 -0200
Message-Id: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add target in Makefile to compress the module after it's installed.
Module-init-tools and libkmod can handle gzipped modules.

This is not much useful for distributions because the package will gzip
the modules and call depmod in a install rule. However for those
compiling the kernel on their own and debugging module loading, it's
useful so depmod doesn't have to be called twice and we don't have to
manually compress the modules.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 Makefile                 |   10 ++++++++--
 scripts/Makefile.modinst |    8 ++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index ea51081..baddcfe 100644
--- a/Makefile
+++ b/Makefile
@@ -1104,8 +1104,9 @@ PHONY += modules_prepare
 modules_prepare: prepare scripts
 
 # Target to install modules
-PHONY += modules_install
-modules_install: _modinst_ _modinst_post
+PHONY += modules_install modules_install_gz
+modules_install: _modinst_bare _modinst_post
+modules_install_gz: _modinst_gz _modinst_post
 
 PHONY += _modinst_
 _modinst_:
@@ -1119,8 +1120,13 @@ _modinst_:
 	fi
 	@cp -f $(objtree)/modules.order $(MODLIB)/
 	@cp -f $(objtree)/modules.builtin $(MODLIB)/
+
+_modinst_bare: _modinst_
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
+_modinst_gz: _modinst_
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst compression=gz
+
 # This depmod is only for convenience to give the initial
 # boot a modules.dep even before / is mounted read-write.  However the
 # boot script depmod is the master version.
diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index efa5d94..442f953 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -12,6 +12,8 @@ include scripts/Kbuild.include
 __modules := $(sort $(shell grep -h '\.ko' /dev/null $(wildcard $(MODVERDIR)/*.mod)))
 modules := $(patsubst %.o,%.ko,$(wildcard $(__modules:.ko=.o)))
 
+compression ?= none
+
 PHONY += $(modules)
 __modinst: $(modules)
 	@:
@@ -19,6 +21,9 @@ __modinst: $(modules)
 quiet_cmd_modules_install = INSTALL $@
       cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@)
 
+quiet_cmd_modules_compress_gz = GZ      $@.gz
+      cmd_modules_compress_gz = gzip $(2)/$(notdir $@)
+
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
 ext-mod-dir = $(INSTALL_MOD_DIR)$(subst $(patsubst %/,%,$(KBUILD_EXTMOD)),,$(@D))
@@ -27,6 +32,9 @@ modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
 
 $(modules):
 	$(call cmd,modules_install,$(MODLIB)/$(modinst_dir))
+ifeq ($(compression),gz)
+	$(call cmd,modules_compress_gz,$(MODLIB)/$(modinst_dir))
+endif
 
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
-- 
1.7.8.1

