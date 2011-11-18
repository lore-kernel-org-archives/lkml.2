Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1KRTiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:38:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63012 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1KRTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:38:06 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH RFC 3/5] kbuild/extable: Hook up sortextable into the build system.
Date: Fri, 18 Nov 2011 11:37:46 -0800
Message-Id: <1321645068-20475-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com>
References: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Define a config variable BUILDTIME_EXTABLE_SORT to control build time
sorting of the kernel's exception table.

Patch Makefile to do the sorting when BUILDTIME_EXTABLE_SORT is
selected.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 Makefile     |   10 ++++++++++
 init/Kconfig |    3 +++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index dab8610..747074e 100644
--- a/Makefile
+++ b/Makefile
@@ -784,6 +784,10 @@ quiet_cmd_vmlinux_version = GEN     .version
 quiet_cmd_sysmap = SYSMAP
       cmd_sysmap = $(CONFIG_SHELL) $(srctree)/scripts/mksysmap
 
+# Sort exception table at build time
+quiet_cmd_sortextable = SORTEX
+      cmd_sortextable = $(objtree)/scripts/sortextable
+
 # Link of vmlinux
 # If CONFIG_KALLSYMS is set .version is already updated
 # Generate System.map and verify that the content is consistent
@@ -796,6 +800,12 @@ define rule_vmlinux__
 	$(call cmd,vmlinux__)
 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
 
+	$(if $(CONFIG_BUILDTIME_EXTABLE_SORT),				\
+	$(Q)$(if $($(quiet)cmd_sortextable),				\
+	  echo '  $($(quiet)cmd_sortextable)  vmlinux' &&)		\
+	  $(cmd_sortextable)  vmlinux)
+
+
 	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
 	  echo '  $($(quiet)cmd_sysmap)  System.map' &&)                     \
 	$(cmd_sysmap) $@ System.map;                                         \
diff --git a/init/Kconfig b/init/Kconfig
index 43298f9..b1bcfbd 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -27,6 +27,9 @@ config IRQ_WORK
 	bool
 	depends on HAVE_IRQ_WORK
 
+config BUILDTIME_EXTABLE_SORT
+	bool
+
 menu "General setup"
 
 config EXPERIMENTAL
-- 
1.7.2.3

