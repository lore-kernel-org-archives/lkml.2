Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0HBUvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:51:24 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55889 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0HBUvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:51:23 -0400
Date: Mon, 2 Aug 2010 22:51:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Michal Marek <mmarek@suse.cz>, linuxppc-dev@ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bug-make@gnu.org
Subject: Re: make 3.82 fails on powerpc defconfig update [was: Linux 2.6.35]
Message-ID: <20100802205121.GA16520@merkur.ravnborg.org>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com> <4C5686FF.9010803@mandriva.org> <20100802182848.GA16394@merkur.ravnborg.org> <4C572EB0.7060706@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C572EB0.7060706@mandriva.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Thanks, this seems to fix the first issue, but then I get the same erro on the following line 190:
> 
> 190: bootwrapper_install %.dtb:
> 191:        $(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
> 

Obviously - dunno how I missed that.
Updated patch below.

I will do a proper submission after you
confirm that powerpc build is working with make 3.82.

	Sam

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 77cfe7a..ace7a3e 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -163,9 +163,11 @@ drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
 # Default to zImage, override when needed
 all: zImage
 
-BOOT_TARGETS = zImage zImage.initrd uImage zImage% dtbImage% treeImage.% cuImage.% simpleImage.%
+# With make 3.82 we cannot mix normal and wildcard targets
+BOOT_TARGETS1 := zImage zImage.initrd uImaged
+BOOT_TARGETS2 := zImage% dtbImage% treeImage.% cuImage.% simpleImage.%
 
-PHONY += $(BOOT_TARGETS)
+PHONY += $(BOOT_TARGETS1) $(BOOT_TARGETS2)
 
 boot := arch/$(ARCH)/boot
 
@@ -180,10 +182,16 @@ relocs_check: arch/powerpc/relocs_check.pl vmlinux
 zImage: relocs_check
 endif
 
-$(BOOT_TARGETS): vmlinux
+$(BOOT_TARGETS1): vmlinux
+	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
+$(BOOT_TARGETS2): vmlinux
+	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
+
+
+bootwrapper_install
 	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
 
-bootwrapper_install %.dtb:
+%.dtb:
 	$(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)
 
 define archhelp
