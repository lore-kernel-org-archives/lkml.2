Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab2JJXAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:00:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55112 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab2JJXAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:00:43 -0400
X-Sasl-enc: dsd6Ur6g+s37FyiKZtkNSVNRcdRVTri1diqA6IYFqOtt 1349910042
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andi Kleen <andi@firstfloor.org>, Ben Hutchings <ben@decadent.org.uk>,
        Michal Marek <mmarek@suse.cz>
Subject: [ 003/122] kbuild: Do not package /boot and /lib in make tar-pkg
Date: Thu, 11 Oct 2012 07:52:49 +0900
Message-Id: <20121010225338.594863941@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Marek <mmarek@suse.cz>

commit fe04ddf7c2910362f3817c8156e41cbd6c0ee35d upstream.

There were reports of users destroying their Fedora installs by a kernel
tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
toplevel directories from the tarball to prevent this from happening.

Reported-by: Andi Kleen <andi@firstfloor.org>
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Makefile        |    2 +-
 scripts/Makefile.fwinst  |    4 ++--
 scripts/package/buildtar |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -142,7 +142,7 @@ KBUILD_CFLAGS += $(call cc-option,-mno-a
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
-archscripts: scripts_basic
+archscripts:
 	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
 
 ###
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -27,7 +27,7 @@ endif
 installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
 
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
-installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/./
+installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/.
 
 # Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
 PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs
@@ -42,7 +42,7 @@ quiet_cmd_install = INSTALL $(subst $(sr
 $(installed-fw-dirs):
 	$(call cmd,mkdir)
 
-$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)
+$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $$(dir $(INSTALL_FW_PATH)/%)
 	$(call cmd,install)
 
 PHONY +=  __fw_install __fw_modinst FORCE
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


