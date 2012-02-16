Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2BPOzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:55:07 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:42823 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2BPOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:55:03 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@arm.linux.org.uk, nicolas.pitre@linaro.org, tony@atomide.com,
        s.hauer@pengutronix.de, magnus.damm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 2/2] ARM: add support for xz kernel decompression
Date: Thu, 16 Feb 2012 15:54:17 +0100
Message-Id: <1329404057-26346-3-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes applied on Linus' tree

This patch adds support for xz compression on the ARM architecture.
xz achieves slighly higher compression than LZMA.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/Kconfig                        |    1 +
 arch/arm/boot/compressed/.gitignore     |    1 +
 arch/arm/boot/compressed/Makefile       |    3 ++-
 arch/arm/boot/compressed/decompress.c   |    4 ++++
 arch/arm/boot/compressed/piggy.xzkern.S |    6 ++++++
 5 files changed, 14 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/boot/compressed/piggy.xzkern.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a48aecc..c34ff1e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -21,6 +21,7 @@ config ARM
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
+	select HAVE_KERNEL_XZ
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
index e0936a1..d1977f4 100644
--- a/arch/arm/boot/compressed/.gitignore
+++ b/arch/arm/boot/compressed/.gitignore
@@ -3,6 +3,7 @@ lib1funcs.S
 piggy.gzip
 piggy.lzo
 piggy.lzma
+piggy.xzkern
 vmlinux
 vmlinux.lds
 
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index cf0a64c..5a2972b 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -92,6 +92,7 @@ SEDFLAGS	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
 suffix_$(CONFIG_KERNEL_GZIP) = gzip
 suffix_$(CONFIG_KERNEL_LZO)  = lzo
 suffix_$(CONFIG_KERNEL_LZMA) = lzma
+suffix_$(CONFIG_KERNEL_XZ) = xzkern
 
 # Borrowed libfdt files for the ATAG compatibility mode
 
@@ -115,7 +116,7 @@ targets       := vmlinux vmlinux.lds \
 		 lib1funcs.o lib1funcs.S font.o font.c head.o misc.o $(OBJS)
 
 # Make sure files are removed during clean
-extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S $(libfdt) $(libfdt_hdrs)
+extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xz lib1funcs.S $(libfdt) $(libfdt_hdrs)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
diff --git a/arch/arm/boot/compressed/decompress.c b/arch/arm/boot/compressed/decompress.c
index 07be5a2..0ecd8b4 100644
--- a/arch/arm/boot/compressed/decompress.c
+++ b/arch/arm/boot/compressed/decompress.c
@@ -44,6 +44,10 @@ extern void error(char *);
 #include "../../../../lib/decompress_unlzma.c"
 #endif
 
+#ifdef CONFIG_KERNEL_XZ
+#include "../../../../lib/decompress_unxz.c"
+#endif
+
 int do_decompress(u8 *input, int len, u8 *output, void (*error)(char *x))
 {
 	return decompress(input, len, NULL, NULL, output, NULL, error);
diff --git a/arch/arm/boot/compressed/piggy.xzkern.S b/arch/arm/boot/compressed/piggy.xzkern.S
new file mode 100644
index 0000000..5703f30
--- /dev/null
+++ b/arch/arm/boot/compressed/piggy.xzkern.S
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.xzkern"
+	.globl	input_data_end
+input_data_end:
-- 
1.7.4.1

