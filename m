Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab1LPKod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:44:33 -0500
Received: from d1.icnet.pl ([212.160.220.21]:51805 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1LPKoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:44:25 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Tony Lindgren <tony@atomide.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH] ARM: Fix cross compilation broken by failing size command
Date: Fri, 16 Dec 2011 11:42:26 +0100
Message-Id: <1324032146-723-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <Message-ID: <20111214215815.GP32251@atomide.com>
References: <Message-ID: <20111214215815.GP32251@atomide.com>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 5ffb04f6690d71fab241b3562ebf52b893ac4ff1, "ARM: zImage:
make sure appended DTB doesn't get overwritten by kernel .bss", the
native 'size' command, which is now always used for calculation of the
kernel bss size, may break in selected cross compilation environments
with error messages like:

size: arch/arm/boot/compressed/../../../../vmlinux: File format is ambiguous
size: Matching formats: elf32-littlearm elf32-littlearm-symbian elf32-littlearm-vxworks

As a consequence, the KBSS_SZ variable extracted from the size output is
empty, and the the final linker command, provided with incorrectly
formatted arguments, also fails:

  LD      arch/arm/boot/compressed/vmlinux
  arm-angstrom-linux-uclibcgnueabi-ld:--defsym _kernel_bss_size=: syntax error

Don't append the '_kernel_bss_size=$(KBSS_SZ)' argument to the linker
command line if that variable is empty because of the failing size
command. Moreover, use $(CROSS_COMPILE)size if available instead of
native size.

Created and tested against linux-3.2-rc5.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
---
This patch supersedes my previously submitted "ARM: fix $(CROSS_COMPILE) 
prefix missing from size invocation". Thanks to Tony Lindgren for his
comments on $(CROSS_COMPILE)size limited availability.

Unfortunately, I've already pushed that old version to the patch system
at http://www.arm.linux.org.uk/developer/patches/, which I know is not
a review system. Apparently, I was not patient enough, not waiting more
than a week with that regression fix for a single reply to my initial
submission to Russell King, the ARM PORT maintainer, Cc: Nicolas Pitre,
the regression introducing commit author, and the linux-arm-kernel list.
Sorry for that, please drop the old version from the Incoming queue, and
I'll not be pushing anything to that patch system without prior positive
review response any more.

Thanks,
Janusz

 arch/arm/boot/compressed/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 21f56ff..17972e9 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -126,8 +126,11 @@ ccflags-y := -fpic -fno-builtin -I$(obj)
 asflags-y := -Wa,-march=all
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
-KBSS_SZ = $(shell size $(obj)/../../../../vmlinux | awk 'END{print $$3}')
+KBSS_SZ = $(shell if $(CROSS_COMPILE)size $(obj)/../../../../vmlinux; then :; \
+		else size $(obj)/../../../../vmlinux; fi | awk 'END{print $$3}')
+ifneq ($(KBSS_SZ),)
 LDFLAGS_vmlinux = --defsym _kernel_bss_size=$(KBSS_SZ)
+endif
 # Supply ZRELADDR to the decompressor via a linker symbol.
 ifneq ($(CONFIG_AUTO_ZRELADDR),y)
 LDFLAGS_vmlinux += --defsym zreladdr=$(ZRELADDR)
-- 
1.7.3.4

