Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1L2PtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 10:49:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54311 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1L2PtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 10:49:00 -0500
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-modules@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kbuild: add target to install xz modules
Date: Thu, 29 Dec 2011 13:50:19 -0200
Message-Id: <1325173819-26274-2-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add target in Makefile to compress the module with XZ  after it's
installed. kmod can handle modules compressed with xz and it's replacing
module-init-tools.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 Makefile                 |    6 +++++-
 scripts/Makefile.modinst |    7 +++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index baddcfe..f06f886 100644
--- a/Makefile
+++ b/Makefile
@@ -1104,9 +1104,10 @@ PHONY += modules_prepare
 modules_prepare: prepare scripts
 
 # Target to install modules
-PHONY += modules_install modules_install_gz
+PHONY += modules_install modules_install_gz modules_install_xz
 modules_install: _modinst_bare _modinst_post
 modules_install_gz: _modinst_gz _modinst_post
+modules_install_xz: _modinst_xz _modinst_post
 
 PHONY += _modinst_
 _modinst_:
@@ -1127,6 +1128,9 @@ _modinst_bare: _modinst_
 _modinst_gz: _modinst_
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst compression=gz
 
+_modinst_xz: _modinst_
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst compression=xz
+
 # This depmod is only for convenience to give the initial
 # boot a modules.dep even before / is mounted read-write.  However the
 # boot script depmod is the master version.
diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index 442f953..297c546 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -24,6 +24,9 @@ quiet_cmd_modules_install = INSTALL $@
 quiet_cmd_modules_compress_gz = GZ      $@.gz
       cmd_modules_compress_gz = gzip $(2)/$(notdir $@)
 
+quiet_cmd_modules_compress_xz = XZ      $@.xz
+      cmd_modules_compress_xz = xz $(2)/$(notdir $@)
+
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
 ext-mod-dir = $(INSTALL_MOD_DIR)$(subst $(patsubst %/,%,$(KBUILD_EXTMOD)),,$(@D))
@@ -34,6 +37,10 @@ $(modules):
 	$(call cmd,modules_install,$(MODLIB)/$(modinst_dir))
 ifeq ($(compression),gz)
 	$(call cmd,modules_compress_gz,$(MODLIB)/$(modinst_dir))
+else
+ifeq ($(compression),xz)
+	$(call cmd,modules_compress_xz,$(MODLIB)/$(modinst_dir))
+endif
 endif
 
 
-- 
1.7.8.1

