Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab2F2UjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:39:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55099 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2F2UjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:39:23 -0400
Date: Fri, 29 Jun 2012 22:39:20 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] Build a zImage or uImage with dtb already appended
Message-ID: <20120629203919.GA18617@raptus.dandreoli.com>
Mail-Followup-To: Grant Likely <grant.likely@secretlab.ca>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20110802143148.21599.22870.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802143148.21599.22870.stgit@ponder>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Domenico Andreoli <domenico.andreoli@linux.com>

Add new targets to build zImage and uImage with DTB appended (i.e. make
'uImage-dtb.am335x-bone' or 'make zImage-dtb.omap3-evm').

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Domenico Andreoli <domenico.andreoli@linux.com>

---

On Tue, Aug 02, 2011 at 03:31:48PM +0100, Grant Likely wrote:
> Do not commit to mainline; this is a useful hack only for now.
> 

Is this a better moment for this patch?

Anyway, here is an update for v3.5-rc4. Added zImage-dtb.* as a valid
target and the .gitignore entries.

cheers
Domenico

---
 arch/arm/Makefile        |    6 ++++++
 arch/arm/boot/.gitignore |    2 ++
 arch/arm/boot/Makefile   |    7 +++++++
 3 files changed, 15 insertions(+)

Index: b/arch/arm/Makefile
===================================================================
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -283,6 +283,12 @@ zImage Image xipImage bootpImage uImage:
 zinstall uinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
+zImage-dtb.%:
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+
+uImage-dtb.%:
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+
 %.dtb:
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
Index: b/arch/arm/boot/Makefile
===================================================================
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -55,6 +55,9 @@ $(obj)/zImage:	$(obj)/compressed/vmlinux
 	$(call if_changed,objcopy)
 	@echo '  Kernel: $@ is ready'
 
+$(obj)/zImage-dtb.%:	$(obj)/%.dtb $(obj)/zImage
+	cat $(obj)/zImage $< > $@
+
 endif
 
 targets += $(dtb-y)
@@ -90,6 +93,10 @@ $(obj)/uImage:	$(obj)/zImage FORCE
 	$(call if_changed,uimage)
 	@echo '  Image $@ is ready'
 
+$(obj)/uImage-dtb.%:	$(obj)/zImage-dtb.% FORCE
+	$(call if_changed,uimage)
+	@echo '  Image $@ is ready'
+
 $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/bootp $@
 	@:
Index: b/arch/arm/boot/.gitignore
===================================================================
--- a/arch/arm/boot/.gitignore
+++ b/arch/arm/boot/.gitignore
@@ -1,6 +1,8 @@
 Image
 zImage
+zImage-dtb.*
 xipImage
 bootpImage
 uImage
+uImage-dtb.*
 *.dtb
