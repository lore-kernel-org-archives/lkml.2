Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966177Ab2JZTaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:30:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54353 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966021Ab2JZTaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:30:06 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V4 REPOST 1/2] kbuild: centralize .dts->.dtb rule
Date: Fri, 26 Oct 2012 13:29:56 -0600
Message-Id: <1351279797-16450-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

All architectures that use cmd_dtc do so in the same way. Move the build
rule to a central location to avoid duplication.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v4: No change.
v3: No change.
v2: New patch.
---
 arch/arm/boot/Makefile      |    4 ----
 arch/c6x/boot/Makefile      |    3 ---
 arch/openrisc/boot/Makefile |    3 ---
 arch/powerpc/boot/Makefile  |    4 ----
 scripts/Makefile.lib        |    3 +++
 5 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index f2aa09e..208bb4c 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -61,10 +61,6 @@ endif
 
 targets += $(dtb-y)
 
-# Rule to build device tree blobs
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
 $(obj)/dtbs: $(addprefix $(obj)/, $(dtb-y))
 
 clean-files := *.dtb
diff --git a/arch/c6x/boot/Makefile b/arch/c6x/boot/Makefile
index 6891257..ad605fb 100644
--- a/arch/c6x/boot/Makefile
+++ b/arch/c6x/boot/Makefile
@@ -12,9 +12,6 @@ ifneq ($(DTB),)
 obj-y += linked_dtb.o
 endif
 
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
 quiet_cmd_cp = CP      $< $@$2
 	cmd_cp = cat $< >$@$2 || (rm -f $@ && echo false)
 
diff --git a/arch/openrisc/boot/Makefile b/arch/openrisc/boot/Makefile
index 0995835..fd329bd 100644
--- a/arch/openrisc/boot/Makefile
+++ b/arch/openrisc/boot/Makefile
@@ -10,6 +10,3 @@ obj-y += $(BUILTIN_DTB)
 clean-files := *.dtb.S
 
 #DTC_FLAGS ?= -p 1024
-
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 6a15c96..90206f2 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -356,10 +356,6 @@ $(obj)/treeImage.initrd.%: vmlinux $(obj)/%.dtb $(wrapperbits)
 $(obj)/treeImage.%: vmlinux $(obj)/%.dtb $(wrapperbits)
 	$(call if_changed,wrap,treeboot-$*,,$(obj)/$*.dtb)
 
-# Rule to build device tree blobs
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
 # If there isn't a platform selected then just strip the vmlinux.
 ifeq (,$(image-y))
 image-y := vmlinux.strip
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 0be6f11..425578e 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -266,6 +266,9 @@ $(obj)/%.dtb.S: $(obj)/%.dtb
 quiet_cmd_dtc = DTC     $@
 cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile) $<
 
+$(obj)/%.dtb: $(src)/dts/%.dts FORCE
+	$(call if_changed_dep,dtc)
+
 # Bzip2
 # ---------------------------------------------------------------------------
 
-- 
1.7.0.4

