Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1E3KJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:09:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:45830 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1E3KJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:09:32 -0400
Subject: [PATCH v2] x86, kconfig: Pick up the .config arch version in 'make
 oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 May 2011 11:09:29 +0100
In-Reply-To: <20110530091536.GA2827@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530091536.GA2827@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306750170.2029.416.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wasted a bunch of time today because I'd taken a .config from my 
test machine and tried to build it, and the existing setting of 
CONFIG_X86_32 got changed to the host system's bitness which was 
64-bit.

This patch fixes that. Last time I tried to fix this bug, I had 
introduced a regression that broke:

   make ARCH=x86_64 randconfig
   make ARCH=i386 randconfig

type of filtered-randconfig behavior which restricted randconfigs to 
64-bit and 32-bit configs, respectively.

This version fixes that so prior randconfig behavior is maintained,
although if a "filtered randconfig" is desired it seems like it would be
better to actually implement that properly, rather than relying on a
hack which preserves the obsolete 'ARCH=i386' and 'ARCH=x86_64' legacy
just to influence *one* of the many config options that might need to be
hard-coded if you actually want a 'randconfig' that produces a useful
end-result.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1306707270.2029.377.camel@i7.infradead.org

---
v2: Explicitly turn off CONFIG_64BIT in i386_defconfig. The default for
CONFIG_64BIT has *changed* (from n to y) for ARCH=x86, so it needs to be
explicitly turned off or 'make i386_defconfig' will give you 64-bit :)

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
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 6f98726..41cab70 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1,3 +1,4 @@
+# CONFIG_64BIT is not set
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y

-- 
dwmw2

