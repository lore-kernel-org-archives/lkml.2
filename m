Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767639Ab2KOLvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:51:37 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39143 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993251Ab2KOLve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:51:34 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH V5 1/2] kbuild: centralize .dts->.dtb rule
Date: Thu, 15 Nov 2012 11:51:24 +0000
Message-Id: <1352980284-2819-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CACxGe6vhd_4rcBbYyqtvbySVaY6XpNE+HQq42PZhKe5yt=zcaA@mail.gmail.com>
References: <CACxGe6vhd_4rcBbYyqtvbySVaY6XpNE+HQq42PZhKe5yt=zcaA@mail.gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> Or how about: I could pick up the patch with only the MIPS hunk and
> every other user can be fixed up independently to use the new rule.

Here's a trial patch to fix up ARM. Does this look correct? This patch
depends on the generic dtb build rule already being applied.

g.

---

arm/of: Change .dtb build rules to build in dts directory

The current rules have the .dtb files build in a different directory
from the .dts files. The only reason for this is that it was what
PowerPC has done historically. This patch changes ARM to use the generic
dtb rule which builds .dtb files in the same directory as the source .dts.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/arm/Makefile          |    4 ++--
 arch/arm/boot/Makefile     |   12 ------------
 arch/arm/boot/dts/Makefile |    4 ++++
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 5f914fc..c35baf1 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -292,10 +292,10 @@ zinstall uinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
 %.dtb: scripts
-	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
 
 dtbs: scripts
-	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) dtbs
 
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index f2aa09e..801b92c 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -15,8 +15,6 @@ ifneq ($(MACHINE),)
 include $(srctree)/$(MACHINE)/Makefile.boot
 endif
 
-include $(srctree)/arch/arm/boot/dts/Makefile
-
 # Note: the following conditions must always be true:
 #   ZRELADDR == virt_to_phys(PAGE_OFFSET + TEXT_OFFSET)
 #   PARAMS_PHYS must be within 4MB of ZRELADDR
@@ -59,16 +57,6 @@ $(obj)/zImage:	$(obj)/compressed/vmlinux FORCE
 
 endif
 
-targets += $(dtb-y)
-
-# Rule to build device tree blobs
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
-$(obj)/dtbs: $(addprefix $(obj)/, $(dtb-y))
-
-clean-files := *.dtb
-
 ifneq ($(LOADADDR),)
   UIMAGE_LOADADDR=$(LOADADDR)
 else
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index f37cf9f..2aef042 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -104,4 +104,8 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8505-ref.dtb \
 	wm8650-mid.dtb
 
+targets += dtbs
 endif
+
+dtbs: $(addprefix $(obj)/, $(dtb-y))
+clean-files := *.dtb
-- 
1.7.10.4

