Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2K0XaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:30:01 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42325 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab2K0X3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:29:41 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH V7 7/7] xtensa: use new common dtc rule
Date: Tue, 27 Nov 2012 16:29:16 -0700
Message-Id: <1354058956-7199-7-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The current rules have the .dtb files build in a different directory
from the .dts files. This patch changes xtensa to use the generic dtb
rule which builds .dtb files in the same directory as the source .dts.

This requires moving parts of arch/xtensa/boot/Makefile into newly
created arch/xtensa/boot/dts/Makefile, and updating arch/xtensa/Makefile
to call the new Makefile.

Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v7: New patch.
---
 arch/xtensa/Makefile          |    4 ++--
 arch/xtensa/boot/Makefile     |   10 ----------
 arch/xtensa/boot/dts/Makefile |   13 +++++++++++++
 3 files changed, 15 insertions(+), 12 deletions(-)
 create mode 100644 arch/xtensa/boot/dts/Makefile

diff --git a/arch/xtensa/Makefile b/arch/xtensa/Makefile
index b8eb819..b0646fd 100644
--- a/arch/xtensa/Makefile
+++ b/arch/xtensa/Makefile
@@ -80,7 +80,7 @@ core-y		+= $(buildvar) $(buildplf)
 
 libs-y		+= arch/xtensa/lib/ $(LIBGCC)
 
-core-$(CONFIG_BUILTIN_DTB_BOOL) += arch/xtensa/boot/
+core-$(CONFIG_BUILTIN_DTB_BOOL) += arch/xtensa/boot/dts/
 
 boot		:= arch/xtensa/boot
 
@@ -92,7 +92,7 @@ zImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $@
 
 %.dtb:
-	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@
 
 define archhelp
   @echo '* zImage      - Compressed kernel image (arch/xtensa/boot/images/zImage.*)'
diff --git a/arch/xtensa/boot/Makefile b/arch/xtensa/boot/Makefile
index 5d21c21..6be27fb 100644
--- a/arch/xtensa/boot/Makefile
+++ b/arch/xtensa/boot/Makefile
@@ -25,16 +25,6 @@ bootdir-$(CONFIG_XTENSA_PLATFORM_ISS)	 += boot-elf
 bootdir-$(CONFIG_XTENSA_PLATFORM_XT2000) += boot-redboot boot-elf boot-uboot
 bootdir-$(CONFIG_XTENSA_PLATFORM_XTAVNET)+= boot-redboot boot-elf boot-uboot
 
-
-BUILTIN_DTB := $(patsubst "%",%,$(CONFIG_BUILTIN_DTB)).dtb.o
-obj-$(CONFIG_BUILTIN_DTB_BOOL) += $(BUILTIN_DTB)
-
-# Rule to build device tree blobs
-$(obj)/%.dtb: $(src)/dts/%.dts FORCE
-	$(call if_changed_dep,dtc)
-
-clean-files := *.dtb.S
-
 zImage Image: $(bootdir-y)
 
 $(bootdir-y): $(addprefix $(obj)/,$(subdir-y)) \
diff --git a/arch/xtensa/boot/dts/Makefile b/arch/xtensa/boot/dts/Makefile
new file mode 100644
index 0000000..0b5581a
--- /dev/null
+++ b/arch/xtensa/boot/dts/Makefile
@@ -0,0 +1,13 @@
+#
+# arch/xtensa/boot/dts/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+#
+
+BUILTIN_DTB := $(patsubst "%",%,$(CONFIG_BUILTIN_DTB)).dtb.o
+obj-$(CONFIG_BUILTIN_DTB_BOOL) += $(BUILTIN_DTB)
+
+clean-files := *.dtb.S
-- 
1.7.10.4

