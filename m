Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1HBOb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:31:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60551 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1HBObw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:31:52 -0400
Subject: [PATCH] Build a uImage with dtb already appended
To: niklas.hernaeus@linaro.org, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 02 Aug 2011 15:31:48 +0100
Message-ID: <20110802143148.21599.22870.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not commit to mainline; this is a useful hack only for now.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/Makefile      |    3 +++
 arch/arm/boot/Makefile |    8 ++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 70c424e..0677b86 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -282,6 +282,9 @@ zImage Image xipImage bootpImage uImage: vmlinux
 zinstall uinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
+uImage-dtb.%:
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+
 %.dtb:
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index a1edfd5..a64493b 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -57,6 +57,9 @@ $(obj)/zImage:	$(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
 	@echo '  Kernel: $@ is ready'
 
+$(obj)/zImage-dtb.%:	$(obj)/%.dtb $(obj)/zImage
+	cat $(obj)/zImage $< > $@
+
 endif
 
 # Rule to build device tree blobs
@@ -77,11 +80,16 @@ $(obj)/uImage: LOADADDR=$(ZRELADDR)
 endif
 
 $(obj)/uImage: STARTADDR=$(LOADADDR)
+$(obj)/uImage-dtb.%: STARTADDR=$(LOADADDR)
 
 $(obj)/uImage:	$(obj)/zImage FORCE
 	$(call if_changed,uimage)
 	@echo '  Image $@ is ready'
 
+$(obj)/uImage-dtb.%:	$(obj)/zImage-dtb.% FORCE
+	$(call if_changed,uimage)
+	@echo '  Image $@ is ready'
+
 $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/bootp $@
 	@:

