Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935606Ab2JaN4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970Ab2JaN4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:56:11 -0400
Date: Wed, 31 Oct 2012 09:56:05 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] MODSIGN: Add modules_sign make target
Message-ID: <20121031135605.GJ6627@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_MODULE_SIG is set, and 'make modules_sign' is called then this
patch will cause the modules to get a signature appended.  The make target
is intended to be run after 'make modules_install', and will modify the
modules in-place in the installed location.  It can be used to produce
signed modules after they have been processed by distribution build
scripts.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 v2: Not word-wrapped this time (hopefully)

 Makefile                 |  6 ++++++
 scripts/Makefile.modsign | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)
 create mode 100644 scripts/Makefile.modsign

diff --git a/Makefile b/Makefile
index 3d10a87..3c3ece7 100644
--- a/Makefile
+++ b/Makefile
@@ -985,6 +985,12 @@ _modinst_post: _modinst_
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst
 	$(call cmd,depmod)
 
+ifeq ($(CONFIG_MODULE_SIG), y)
+PHONY += modules_sign
+modules_sign:
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modsign
+endif
+
 else # CONFIG_MODULES
 
 # Modules not configured
diff --git a/scripts/Makefile.modsign b/scripts/Makefile.modsign
new file mode 100644
index 0000000..670d5dc
--- /dev/null
+++ b/scripts/Makefile.modsign
@@ -0,0 +1,32 @@
+# ==========================================================================
+# Signing modules
+# ==========================================================================
+
+PHONY := __modsign
+__modsign:
+
+include scripts/Kbuild.include
+
+__modules := $(sort $(shell grep -h '\.ko' /dev/null $(wildcard $(MODVERDIR)/*.mod)))
+modules := $(patsubst %.o,%.ko,$(wildcard $(__modules:.ko=.o)))
+
+PHONY += $(modules)
+__modsign: $(modules)
+	@:
+
+quiet_cmd_sign_ko = SIGN [M] $(2)/$(notdir $@)
+        cmd_sign_ko = $(mod_sign_cmd) $(2)/$(notdir $@)
+
+# Modules built outside the kernel source tree go into extra by default
+INSTALL_MOD_DIR ?= extra
+ext-mod-dir = $(INSTALL_MOD_DIR)$(subst $(patsubst %/,%,$(KBUILD_EXTMOD)),,$(@D))
+
+modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
+
+$(modules):
+	$(call cmd,sign_ko,$(MODLIB)/$(modinst_dir))
+
+# Declare the contents of the .PHONY variable as phony.  We keep that
+# # information in a variable se we can use it in if_changed and friends.
+
+.PHONY: $(PHONY)
-- 
1.7.12.1

