Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab0HLADz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:03:55 -0400
Received: from kroah.org ([198.145.64.141]:60069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225Ab0HLADs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:03:48 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:23 2010
Message-Id: <20100812000123.599374394@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [03/54] powerpc: fix build with make 3.82
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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


