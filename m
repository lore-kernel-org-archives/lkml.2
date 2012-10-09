Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab2JIPXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:23:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab2JIPXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:23:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 7/9] ARM: be really quiet when building with 'make -s'
Date: Tue,  9 Oct 2012 17:23:01 +0200
Message-Id: <1349796183-30648-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796183-30648-1-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/qjgPhakgrseN5Rga0tvWVR+H47xvssfmI8IQKFjM/z
 2fQb571w3IgjIL5/4BetZt5g7RF+4eWA9bbpWA/iuHsZx+EoPY
 UbRiNYALzWToYEnfHdDCbkQuyCmYLEJeU+i0sFAWVVk36VLTQc
 ARx3ESyTqboJ4gU9EiYiml25FA11pTbTYb9on58Huud/p2VEdd
 DJd7Tx1RSOPu41hBY7LJN8DuEwxx01dTAJjdRgOcJYxBO1RbMt
 k3fQEJP+aq+bgx/X4JrydsaWJ87uW5VLMCh0/oozfPV4xKjKow
 XNW6n412v4pOTCiF25kfPqzcJiu3GdNnkYLAhmSYOePzPO9o6e
 1zEcI1IWgUt2yeIojudQupT0f43lSPRWNfLa2cQ2SttOcgIJmp
 9NDjKGjWWDfS2NABSA6OdetlmtNsZKue2k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we want the kernel build process to only print messages
on errors, e.g. in automated build testing. This uses the "kecho"
macro that the build system provides to hide a few informational
messages. Nothing changes for a regular "make" or "make V=1".

Without this patch, building any ARM kernel results in:

  Kernel: arch/arm/boot/Image is ready
  Kernel: arch/arm/boot/zImage is ready

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Marek <mmarek@suse.cz>
---
 arch/arm/boot/Makefile  |   10 +++++-----
 arch/arm/tools/Makefile |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index 3fdab01..f2aa09e 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -33,7 +33,7 @@ ifeq ($(CONFIG_XIP_KERNEL),y)
 
 $(obj)/xipImage: vmlinux FORCE
 	$(call if_changed,objcopy)
-	@echo '  Kernel: $@ is ready (physical address: $(CONFIG_XIP_PHYS_ADDR))'
+	$(kecho) '  Kernel: $@ is ready (physical address: $(CONFIG_XIP_PHYS_ADDR))'
 
 $(obj)/Image $(obj)/zImage: FORCE
 	@echo 'Kernel configured for XIP (CONFIG_XIP_KERNEL=y)'
@@ -48,14 +48,14 @@ $(obj)/xipImage: FORCE
 
 $(obj)/Image: vmlinux FORCE
 	$(call if_changed,objcopy)
-	@echo '  Kernel: $@ is ready'
+	$(kecho) '  Kernel: $@ is ready'
 
 $(obj)/compressed/vmlinux: $(obj)/Image FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
 
 $(obj)/zImage:	$(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
-	@echo '  Kernel: $@ is ready'
+	$(kecho) '  Kernel: $@ is ready'
 
 endif
 
@@ -90,7 +90,7 @@ fi
 $(obj)/uImage:	$(obj)/zImage FORCE
 	@$(check_for_multiple_loadaddr)
 	$(call if_changed,uimage)
-	@echo '  Image $@ is ready'
+	$(kecho) '  Image $@ is ready'
 
 $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/bootp $@
@@ -98,7 +98,7 @@ $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 
 $(obj)/bootpImage: $(obj)/bootp/bootp FORCE
 	$(call if_changed,objcopy)
-	@echo '  Kernel: $@ is ready'
+	$(kecho) '  Kernel: $@ is ready'
 
 PHONY += initrd FORCE
 initrd:
diff --git a/arch/arm/tools/Makefile b/arch/arm/tools/Makefile
index 635cb18..cd60a81 100644
--- a/arch/arm/tools/Makefile
+++ b/arch/arm/tools/Makefile
@@ -5,6 +5,6 @@
 #
 
 include/generated/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
-	@echo '  Generating $@'
+	$(kecho) '  Generating $@'
 	@mkdir -p $(dir $@)
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }
-- 
1.7.10

