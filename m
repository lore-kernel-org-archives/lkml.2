Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab2IYWRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:17:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2IYWRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:17:37 -0400
From: Michal Marek <mmarek@suse.cz>
To: andi@firstfloor.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        ben@decadent.org.uk
Subject: [PATCH] kbuild: Do not package /boot and /lib in make tar-pkg
Date: Wed, 26 Sep 2012 00:17:25 +0200
Message-Id: <1348611445-11501-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20120912031646.GV16230@one.firstfloor.org>
References: <20120912031646.GV16230@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were reports of users destroying their Fedora installs by a kernel
tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
toplevel directories from the tarball to prevent this from happening.

Reported-by: Andi Kleen <andi@firstfloor.org>
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/x86/Makefile        |    2 +-
 scripts/Makefile.fwinst  |    4 ++--
 scripts/package/buildtar |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index c098ca4..b0c5276 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -138,7 +138,7 @@ KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
-archscripts: scripts_basic
+archscripts:
 	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
 
 ###
diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 4d908d1..c3f69ae 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -27,7 +27,7 @@ endif
 installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
 
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
-installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/./
+installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/.
 
 # Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
 PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs
@@ -42,7 +42,7 @@ quiet_cmd_install = INSTALL $(subst $(srctree)/,,$@)
 $(installed-fw-dirs):
 	$(call cmd,mkdir)
 
-$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)
+$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $$(dir $(INSTALL_FW_PATH)/%)
 	$(call cmd,install)
 
 PHONY +=  __fw_install __fw_modinst FORCE
diff --git a/scripts/package/buildtar b/scripts/package/buildtar
index 8a7b155..d0d748e 100644
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -109,7 +109,7 @@ esac
 	if tar --owner=root --group=root --help >/dev/null 2>&1; then
 		opts="--owner=root --group=root"
 	fi
-	tar cf - . $opts | ${compress} > "${tarball}${file_ext}"
+	tar cf - boot/* lib/* $opts | ${compress} > "${tarball}${file_ext}"
 )
 
 echo "Tarball successfully created in ${tarball}${file_ext}"
-- 
1.7.3.1

