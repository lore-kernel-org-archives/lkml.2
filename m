Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab0HLAqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:46:24 -0400
Received: from kroah.org ([198.145.64.141]:40001 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547Ab0HKX5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:24 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:55 2010
Message-Id: <20100811235455.793636323@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:53:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [002/111] powerpc: fix build with make 3.82
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sam Ravnborg <sam@ravnborg.org>

commit e32e78c5ee8aadef020fbaecbe6fb741ed9029fd upstream.

Thomas Backlund reported that the powerpc build broke with make 3.82.
It failed with the following message:

    arch/powerpc/Makefile:183: *** mixed implicit and normal rules.  Stop.

The fix is to avoid mixing non-wildcard and wildcard targets.

Reported-by: Thomas Backlund <tmb@mandriva.org>
Tested-by: Thomas Backlund <tmb@mandriva.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/Makefile |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -158,9 +158,11 @@ drivers-$(CONFIG_OPROFILE)	+= arch/power
 # Default to zImage, override when needed
 all: zImage
 
-BOOT_TARGETS = zImage zImage.initrd uImage zImage% dtbImage% treeImage.% cuImage.% simpleImage.%
+# With make 3.82 we cannot mix normal and wildcard targets
+BOOT_TARGETS1 := zImage zImage.initrd uImaged
+BOOT_TARGETS2 := zImage% dtbImage% treeImage.% cuImage.% simpleImage.%
 
-PHONY += $(BOOT_TARGETS)
+PHONY += $(BOOT_TARGETS1) $(BOOT_TARGETS2)
 
 boot := arch/$(ARCH)/boot
 
@@ -175,10 +177,16 @@ relocs_check: arch/powerpc/relocs_check.
 zImage: relocs_check
 endif
 
-$(BOOT_TARGETS): vmlinux
+$(BOOT_TARGETS1): vmlinux
+	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
+$(BOOT_TARGETS2): vmlinux
+	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
+
+
+bootwrapper_install:
 	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
 
-bootwrapper_install %.dtb:
+%.dtb:
 	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
 
 define archhelp


