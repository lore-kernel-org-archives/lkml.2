Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2K0X3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:29:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35807 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2K0X3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:29:39 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH V7 6/7] microblaze: use new common dtc rule
Date: Tue, 27 Nov 2012 16:29:15 -0700
Message-Id: <1354058956-7199-6-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The current rules have the .dtb files build in a different directory
from the .dts files. This patch changes microblaze to use the generic dtb
rule which builds .dtb files in the same directory as the source .dts.

This requires moving parts of arch/microblaze/boot/Makefile into newly
created arch/microblaze/boot/dts/Makefile, and updating
arch/microblaze/Makefile to call the new Makefile. linked_dtb.S is also
moved into boot/dts/ since it's used by rules that were moved.

Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v7: New patch.
---
 arch/microblaze/Makefile              |    2 +-
 arch/microblaze/boot/Makefile         |   19 +------------------
 arch/microblaze/boot/dts/Makefile     |   22 ++++++++++++++++++++++
 arch/microblaze/boot/dts/linked_dtb.S |    2 ++
 arch/microblaze/boot/linked_dtb.S     |    3 ---
 5 files changed, 26 insertions(+), 22 deletions(-)
 create mode 100644 arch/microblaze/boot/dts/Makefile
 create mode 100644 arch/microblaze/boot/dts/linked_dtb.S
 delete mode 100644 arch/microblaze/boot/linked_dtb.S

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index b23c40e..d26fb90 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -57,7 +57,7 @@ boot := arch/microblaze/boot
 DTB:=$(subst simpleImage.,,$(filter simpleImage.%, $(MAKECMDGOALS)))
 
 ifneq ($(DTB),)
-	core-y	+= $(boot)/
+	core-y	+= $(boot)/dts/
 endif
 
 # defines filename extension depending memory management type
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index fa83ea4..80fe54f 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -2,21 +2,10 @@
 # arch/microblaze/boot/Makefile
 #
 
-obj-y += linked_dtb.o
-
 targets := linux.bin linux.bin.gz simpleImage.%
 
 OBJCOPYFLAGS := -R .note -R .comment -R .note.gnu.build-id -O binary
 
-# Ensure system.dtb exists
-$(obj)/linked_dtb.o: $(obj)/system.dtb
-
-# Generate system.dtb from $(DTB).dtb
-ifneq ($(DTB),system)
-$(obj)/system.dtb: $(obj)/$(DTB).dtb
-	$(call if_changed,cp)
-endif
-
 $(obj)/linux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 	$(call if_changed,uimage)
@@ -45,10 +34,4 @@ $(obj)/simpleImage.%: vmlinux FORCE
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
 
-# Rule to build device tree blobs
-DTC_FLAGS := -p 1024
-
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
-clean-files += *.dtb simpleImage.*.unstrip linux.bin.ub
+clean-files += simpleImage.*.unstrip linux.bin.ub
diff --git a/arch/microblaze/boot/dts/Makefile b/arch/microblaze/boot/dts/Makefile
new file mode 100644
index 0000000..c3b3a5d
--- /dev/null
+++ b/arch/microblaze/boot/dts/Makefile
@@ -0,0 +1,22 @@
+#
+# arch/microblaze/boot/Makefile
+#
+
+obj-y += linked_dtb.o
+
+# Ensure system.dtb exists
+$(obj)/linked_dtb.o: $(obj)/system.dtb
+
+# Generate system.dtb from $(DTB).dtb
+ifneq ($(DTB),system)
+$(obj)/system.dtb: $(obj)/$(DTB).dtb
+	$(call if_changed,cp)
+endif
+
+quiet_cmd_cp = CP      $< $@$2
+	cmd_cp = cat $< >$@$2 || (rm -f $@ && echo false)
+
+# Rule to build device tree blobs
+DTC_FLAGS := -p 1024
+
+clean-files += *.dtb
diff --git a/arch/microblaze/boot/dts/linked_dtb.S b/arch/microblaze/boot/dts/linked_dtb.S
new file mode 100644
index 0000000..23345af
--- /dev/null
+++ b/arch/microblaze/boot/dts/linked_dtb.S
@@ -0,0 +1,2 @@
+.section __fdt_blob,"a"
+.incbin "arch/microblaze/boot/dts/system.dtb"
diff --git a/arch/microblaze/boot/linked_dtb.S b/arch/microblaze/boot/linked_dtb.S
deleted file mode 100644
index cb2b537..0000000
--- a/arch/microblaze/boot/linked_dtb.S
+++ /dev/null
@@ -1,3 +0,0 @@
-.section __fdt_blob,"a"
-.incbin "arch/microblaze/boot/system.dtb"
-
-- 
1.7.10.4

