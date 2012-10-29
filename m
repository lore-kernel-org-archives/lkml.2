Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab2J2PfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:35:25 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:46202 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759352Ab2J2PfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:35:22 -0400
Date: Mon, 29 Oct 2012 09:34:25 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michal Marek <mmarek@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: quiet down the non make -s output
Message-ID: <20121029153425.GA9486@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/29/2012 10:34:17 AM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/29/2012 10:34:17 AM,
	Serialize complete at 10/29/2012 10:34:17 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-29_02:2012-10-29,2012-10-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit edc88ceb0c7d285b9f58bc29a638cd8163b59989 silenced the make -s build, but
inadvertently made louder the non-silent build.  Fix by prepending '@' to each
of the added $(kecho) statements.

Build with edc88ceb0c7d285b9f58bc29a638cd8163b59989:

  CHK     include/generated/compile.h
echo '  Kernel: arch/arm/boot/Image is ready'
  Kernel: arch/arm/boot/Image is ready
  LD      arch/arm/boot/compressed/vmlinux
  OBJCOPY arch/arm/boot/zImage
echo '  Kernel: arch/arm/boot/zImage is ready'
  Kernel: arch/arm/boot/zImage is ready

Build with this fix:
  CHK     include/generated/compile.h
  Kernel: arch/arm/boot/Image is ready
  LD      arch/arm/boot/compressed/vmlinux
  OBJCOPY arch/arm/boot/zImage
  Kernel: arch/arm/boot/zImage is ready

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/boot/Makefile  | 10 +++++-----
 arch/arm/tools/Makefile |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index f2aa09e..9137df5 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -33,7 +33,7 @@ ifeq ($(CONFIG_XIP_KERNEL),y)
 
 $(obj)/xipImage: vmlinux FORCE
 	$(call if_changed,objcopy)
-	$(kecho) '  Kernel: $@ is ready (physical address: $(CONFIG_XIP_PHYS_ADDR))'
+	@$(kecho) '  Kernel: $@ is ready (physical address: $(CONFIG_XIP_PHYS_ADDR))'
 
 $(obj)/Image $(obj)/zImage: FORCE
 	@echo 'Kernel configured for XIP (CONFIG_XIP_KERNEL=y)'
@@ -48,14 +48,14 @@ $(obj)/xipImage: FORCE
 
 $(obj)/Image: vmlinux FORCE
 	$(call if_changed,objcopy)
-	$(kecho) '  Kernel: $@ is ready'
+	@$(kecho) '  Kernel: $@ is ready'
 
 $(obj)/compressed/vmlinux: $(obj)/Image FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
 
 $(obj)/zImage:	$(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
-	$(kecho) '  Kernel: $@ is ready'
+	@$(kecho) '  Kernel: $@ is ready'
 
 endif
 
@@ -90,7 +90,7 @@ fi
 $(obj)/uImage:	$(obj)/zImage FORCE
 	@$(check_for_multiple_loadaddr)
 	$(call if_changed,uimage)
-	$(kecho) '  Image $@ is ready'
+	@$(kecho) '  Image $@ is ready'
 
 $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/bootp $@
@@ -98,7 +98,7 @@ $(obj)/bootp/bootp: $(obj)/zImage initrd FORCE
 
 $(obj)/bootpImage: $(obj)/bootp/bootp FORCE
 	$(call if_changed,objcopy)
-	$(kecho) '  Kernel: $@ is ready'
+	@$(kecho) '  Kernel: $@ is ready'
 
 PHONY += initrd FORCE
 initrd:
diff --git a/arch/arm/tools/Makefile b/arch/arm/tools/Makefile
index cd60a81..32d05c8 100644
--- a/arch/arm/tools/Makefile
+++ b/arch/arm/tools/Makefile
@@ -5,6 +5,6 @@
 #
 
 include/generated/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
-	$(kecho) '  Generating $@'
+	@$(kecho) '  Generating $@'
 	@mkdir -p $(dir $@)
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }
-- 
1.8.0
