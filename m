Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab2K0Xb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:31:58 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37102 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab2K0X3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:29:33 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V7 2/7] ARM: dt: change .dtb build rules to build in dts directory
Date: Tue, 27 Nov 2012 16:29:11 -0700
Message-Id: <1354058956-7199-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

The current rules have the .dtb files build in a different directory
from the .dts files. The only reason for this is that it was what
PowerPC has done historically. This patch changes ARM to use the generic
dtb rule which builds .dtb files in the same directory as the source .dts.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
[swarren: added rm command for old stale .dtb files]
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v7: New patch.
---
 arch/arm/Makefile          |    4 ++--
 arch/arm/boot/Makefile     |   12 ------------
 arch/arm/boot/dts/Makefile |    8 ++++++++
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 1ec5f67..5f92252 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -291,10 +291,10 @@ zinstall uinstall install: vmlinux
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
index 9137df5..abfce28 100644
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
index a17d5ab..cb217f8 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -136,4 +136,12 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8650-mid.dtb
 dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
 
+targets += dtbs
 endif
+
+dtbs: $(addprefix $(obj)/, $(dtb-y))
+	# *.dtb used to be generated in the directory above. Clean out the
+	# old build results so people don't accidentally use them.
+	rm -f $(obj)/../*.dtb
+
+clean-files := *.dtb
-- 
1.7.10.4

