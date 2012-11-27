Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2K0X3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:29:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43164 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2K0X3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:29:38 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Subject: [PATCH V7 5/7] c6x: use new common dtc rule
Date: Tue, 27 Nov 2012 16:29:14 -0700
Message-Id: <1354058956-7199-5-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The current rules have the .dtb files build in a different directory
from the .dts files. This patch changes c6x to use the generic dtb
rule which builds .dtb files in the same directory as the source .dts.

This requires moving parts of arch/c6x/boot/Makefile into newly created
arch/c6x/boot/dts/Makefile, and updating arch/c6x/Makefile to call the
new Makefile. linked_dtb.S is also moved into boot/dts/ since it's used
by rules that were moved.

Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: linux-c6x-dev@linux-c6x.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v7: New patch.
---
 arch/c6x/Makefile                |    2 +-
 arch/c6x/boot/Makefile           |   20 --------------------
 arch/c6x/boot/{ => dts}/Makefile |   14 ++------------
 arch/c6x/boot/dts/linked_dtb.S   |    2 ++
 arch/c6x/boot/linked_dtb.S       |    2 --
 5 files changed, 5 insertions(+), 35 deletions(-)
 copy arch/c6x/boot/{ => dts}/Makefile (50%)
 create mode 100644 arch/c6x/boot/dts/linked_dtb.S
 delete mode 100644 arch/c6x/boot/linked_dtb.S

diff --git a/arch/c6x/Makefile b/arch/c6x/Makefile
index a9eb959..e72eb34 100644
--- a/arch/c6x/Makefile
+++ b/arch/c6x/Makefile
@@ -41,7 +41,7 @@ DTB:=$(subst dtbImage.,,$(filter dtbImage.%, $(MAKECMDGOALS)))
 export DTB
 
 ifneq ($(DTB),)
-core-y	+= $(boot)/
+core-y	+= $(boot)/dts/
 endif
 
 # With make 3.82 we cannot mix normal and wildcard targets
diff --git a/arch/c6x/boot/Makefile b/arch/c6x/boot/Makefile
index 6891257..8734abe 100644
--- a/arch/c6x/boot/Makefile
+++ b/arch/c6x/boot/Makefile
@@ -6,25 +6,5 @@ OBJCOPYFLAGS_vmlinux.bin := -O binary
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
-DTC_FLAGS ?= -p 1024
-
-ifneq ($(DTB),)
-obj-y += linked_dtb.o
-endif
-
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
-quiet_cmd_cp = CP      $< $@$2
-	cmd_cp = cat $< >$@$2 || (rm -f $@ && echo false)
-
-# Generate builtin.dtb from $(DTB).dtb
-$(obj)/builtin.dtb: $(obj)/$(DTB).dtb
-	$(call if_changed,cp)
-
-$(obj)/linked_dtb.o: $(obj)/builtin.dtb
-
 $(obj)/dtbImage.%: vmlinux
 	$(call if_changed,objcopy)
-
-clean-files := $(obj)/*.dtb
diff --git a/arch/c6x/boot/Makefile b/arch/c6x/boot/dts/Makefile
similarity index 50%
copy from arch/c6x/boot/Makefile
copy to arch/c6x/boot/dts/Makefile
index 6891257..c7528b0 100644
--- a/arch/c6x/boot/Makefile
+++ b/arch/c6x/boot/dts/Makefile
@@ -1,20 +1,13 @@
 #
-# Makefile for bootable kernel images
+# Makefile for device trees
 #
 
-OBJCOPYFLAGS_vmlinux.bin := -O binary
-$(obj)/vmlinux.bin: vmlinux FORCE
-	$(call if_changed,objcopy)
-
 DTC_FLAGS ?= -p 1024
 
 ifneq ($(DTB),)
 obj-y += linked_dtb.o
 endif
 
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
 quiet_cmd_cp = CP      $< $@$2
 	cmd_cp = cat $< >$@$2 || (rm -f $@ && echo false)
 
@@ -24,7 +17,4 @@ $(obj)/builtin.dtb: $(obj)/$(DTB).dtb
 
 $(obj)/linked_dtb.o: $(obj)/builtin.dtb
 
-$(obj)/dtbImage.%: vmlinux
-	$(call if_changed,objcopy)
-
-clean-files := $(obj)/*.dtb
+clean-files := *.dtb
diff --git a/arch/c6x/boot/dts/linked_dtb.S b/arch/c6x/boot/dts/linked_dtb.S
new file mode 100644
index 0000000..cf347f1
--- /dev/null
+++ b/arch/c6x/boot/dts/linked_dtb.S
@@ -0,0 +1,2 @@
+.section __fdt_blob,"a"
+.incbin "arch/c6x/boot/dts/builtin.dtb"
diff --git a/arch/c6x/boot/linked_dtb.S b/arch/c6x/boot/linked_dtb.S
deleted file mode 100644
index 57a4454..0000000
--- a/arch/c6x/boot/linked_dtb.S
+++ /dev/null
@@ -1,2 +0,0 @@
-.section __fdt_blob,"a"
-.incbin "arch/c6x/boot/builtin.dtb"
-- 
1.7.10.4

