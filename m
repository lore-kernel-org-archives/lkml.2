Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2KLU6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:58:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37965 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2KLU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:58:36 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH V6 1/2] kbuild: centralize .dts->.dtb rule
Date: Mon, 12 Nov 2012 13:58:26 -0700
Message-Id: <1352753907-3316-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

All architectures that use cmd_dtc do so in the same way. Move the build
rule to a central location to avoid duplication.

Update Documentation/kbuild to remove the explicit call to cmd_dtc from
the example, now that the rule exists in a centralized location, and in
fact replace the example with a couple that still exist.

arch/mips changes courtesy of Ralf Baechle.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
v6: Added arch/{arm64,microblaze,mips} updates.
v5: Updated Documentation/kbuild.
v4: No change.
v3: No change.
v2: New patch.
---
 Documentation/kbuild/makefiles.txt |   21 +++++++++++++++------
 arch/arm/boot/Makefile             |    4 ----
 arch/arm64/boot/Makefile           |    3 ---
 arch/c6x/boot/Makefile             |    3 ---
 arch/microblaze/boot/Makefile      |    3 ---
 arch/mips/cavium-octeon/Makefile   |    3 ---
 arch/mips/lantiq/dts/Makefile      |    3 ---
 arch/mips/netlogic/dts/Makefile    |    3 ---
 arch/openrisc/boot/Makefile        |    3 ---
 arch/powerpc/boot/Makefile         |    4 ----
 scripts/Makefile.lib               |    3 +++
 11 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index ec9ae67..a0b0671 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -1175,15 +1175,24 @@ When kbuild executes, the following steps are followed (roughly):
 	in an init section in the image. Platform code *must* copy the
 	blob to non-init memory prior to calling unflatten_device_tree().
 
+	To use this command, simply add *.dtb into obj-y or targets, or make
+	some other target depend on %.dtb
+
+	A central rule exists to create $(obj)/%.dtb from $(src)/dts/%.dts;
+	architecture Makefiles do no need to explicitly write out that rule.
+
 	Example:
-		#arch/x86/platform/ce4100/Makefile
-		clean-files := *dtb.S
+		#arch/arm/boot/Makefile
+		targets += $(dtb-y)
+		clean-files := *.dtb
+
+		#arch/powerpc/boot/Makefile
+		DTC_FLAGS       ?= -p 1024
 
-		DTC_FLAGS := -p 1024
-		obj-y += foo.dtb.o
+		$(obj)/dtbImage.%: vmlinux $(wrapperbits) $(obj)/%.dtb
+			$(call if_changed,wrap,$*,,$(obj)/$*.dtb)
 
-		$(obj)/%.dtb: $(src)/%.dts
-			$(call cmd,dtc)
+		clean-files += ... *.dtb
 
 --- 6.8 Custom kbuild commands
 
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
diff --git a/arch/arm64/boot/Makefile b/arch/arm64/boot/Makefile
index eca209b..20048be 100644
--- a/arch/arm64/boot/Makefile
+++ b/arch/arm64/boot/Makefile
@@ -22,9 +22,6 @@ $(obj)/Image: vmlinux FORCE
 $(obj)/Image.gz: $(obj)/Image FORCE
 	$(call if_changed,gzip)
 
-$(obj)/%.dtb: $(src)/dts/%.dts
-	$(call cmd,dtc)
-
 install: $(obj)/Image
 	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
 	$(obj)/Image System.map "$(INSTALL_PATH)"
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
 
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index fa83ea4..226da18 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -48,7 +48,4 @@ $(obj)/simpleImage.%: vmlinux FORCE
 # Rule to build device tree blobs
 DTC_FLAGS := -p 1024
 
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
 clean-files += *.dtb simpleImage.*.unstrip linux.bin.ub
diff --git a/arch/mips/cavium-octeon/Makefile b/arch/mips/cavium-octeon/Makefile
index bc96e29..6e927cf 100644
--- a/arch/mips/cavium-octeon/Makefile
+++ b/arch/mips/cavium-octeon/Makefile
@@ -24,9 +24,6 @@ DTB_FILES = $(patsubst %.dts, %.dtb, $(DTS_FILES))
 
 obj-y += $(patsubst %.dts, %.dtb.o, $(DTS_FILES))
 
-$(obj)/%.dtb: $(src)/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
 # Let's keep the .dtb files around in case we want to look at them.
 .SECONDARY:  $(addprefix $(obj)/, $(DTB_FILES))
 
diff --git a/arch/mips/lantiq/dts/Makefile b/arch/mips/lantiq/dts/Makefile
index 674fca4..6fa72dd 100644
--- a/arch/mips/lantiq/dts/Makefile
+++ b/arch/mips/lantiq/dts/Makefile
@@ -1,4 +1 @@
 obj-$(CONFIG_DT_EASY50712) := easy50712.dtb.o
-
-$(obj)/%.dtb: $(obj)/%.dts
-	$(call if_changed,dtc)
diff --git a/arch/mips/netlogic/dts/Makefile b/arch/mips/netlogic/dts/Makefile
index 67ae3fe..d117d46 100644
--- a/arch/mips/netlogic/dts/Makefile
+++ b/arch/mips/netlogic/dts/Makefile
@@ -1,4 +1 @@
 obj-$(CONFIG_DT_XLP_EVP) := xlp_evp.dtb.o
-
-$(obj)/%.dtb: $(obj)/%.dts
-	$(call if_changed,dtc)
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

