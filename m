Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1E2WOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 18:14:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:54393 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1E2WOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 18:14:31 -0400
Subject: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 29 May 2011 23:14:28 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1306707270.2029.377.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wasted a bunch of time today because I'd taken a .config from my test
machine and tried to build it, and the existing setting of CONFIG_X86_32
got corrupted.

This patch fixes that. Last time I tried to fix this bug, I had to
contend with Ingo's objection that he didn't actually want 'make
randconfig' to give him a random config... so this is a variant of the
patch which lets him use 'make ARCH=i386 randconfig' and 'make
ARCH=x86_64 randconfig' to get not-entirely-random configurations.

I still maintain that if you actually want a non-random 'randconfig',
perhaps because you want it to be bootable on certain test machines,
then you're going to need to hard-code a whole lot more than *one*
config option — and you'd be better off coming up with a proper
mechanism to do *that* instead of preserving the old 'ARCH=i386' and
'ARCH=x86_64' as a dirty hack to achieve it only for the CONFIG_X86_32
option.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
Same patch as in https://patchwork.kernel.org/patch/33093/

diff --git a/Makefile b/Makefile
index 123d858..7b3b7c5 100644
--- a/Makefile
+++ b/Makefile
@@ -165,7 +165,8 @@ export srctree objtree VPATH
 # then ARCH is assigned, getting whatever value it gets normally, and 
 # SUBARCH is subsequently ignored.
 
-SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
+				  -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..1f206b0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,7 +1,7 @@
 # Select 32 or 64 bit
 config 64BIT
 	bool "64-bit kernel" if ARCH = "x86"
-	default ARCH = "x86_64"
+	default ARCH != "i386"
 	---help---
 	  Say yes to build a 64-bit kernel - formerly known as x86_64
 	  Say no to build a 32-bit kernel - formerly known as i386
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b02e509..94c2d8c 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -2,7 +2,11 @@
 
 # select defconfig based on actual architecture
 ifeq ($(ARCH),x86)
+  ifeq ($(shell uname -m),x86_64)
+        KBUILD_DEFCONFIG := x86_64_defconfig
+  else
         KBUILD_DEFCONFIG := i386_defconfig
+  endif
 else
         KBUILD_DEFCONFIG := $(ARCH)_defconfig
 endif

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

